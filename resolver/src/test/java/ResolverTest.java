/*
 * Copyright (C) 2023 Objectos Software LTDA.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import static org.testng.Assert.assertEquals;

import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.List;
import org.eclipse.aether.artifact.DefaultArtifact;
import org.testng.annotations.Test;

public class ResolverTest {

	@Test
	public void resolveTestNg771() throws Exception {
		Path repository;
		repository = Files.createTempDirectory("resolver-test-");

		try {
			Resolver resolver;
			resolver = new Resolver();

			String[] args;
			args = new String[] {
					"--local-repo",
					repository.toString(),
					"org.testng/testng/7.7.1"
			};

			resolver.parseArgs(args);

			assertEquals(resolver.localRepositoryPath, repository);
			assertEquals(resolver.requestedArtifact, new DefaultArtifact("org.testng:testng:7.7.1"));

			List<String> result;
			result = resolver.resolve();

			assertEquals(
					result,

					List.of(
							"com/beust/jcommander/1.82/jcommander-1.82.jar",
							"org/slf4j/slf4j-api/1.7.36/slf4j-api-1.7.36.jar",
							"org/testng/testng/7.7.1/testng-7.7.1.jar",
							"org/webjars/jquery/3.6.1/jquery-3.6.1.jar"
					)
			);
		} finally {
			rmdir(repository);
		}
	}

	@Test
	public void resolveLocal() throws Exception {
		Path repository;
		repository = Files.createTempDirectory("resolver-test-");

		try {
			Resolver resolver;
			resolver = new Resolver();

			String[] args;
			args = new String[] {
					"--local-repo",
					repository.toString(),
					"com.example/test/1.0.0"
			};

			resolver.parseArgs(args);

			Path testPom;
			testPom = repository.resolve(Path.of("com", "example", "test", "1.0.0", "test-1.0.0.pom"));

			Files.createDirectories(testPom.getParent());

			Files.writeString(
					testPom,

					"""
					<project>

						<modelVersion>4.0.0</modelVersion>

						<groupId>com.example</groupId>
						<artifactId>test</artifactId>
						<version>1.0.0</version>

						<dependencies>
							<dependency>
								<groupId>org.slf4j</groupId>
								<artifactId>slf4j-api</artifactId>
								<version>1.7.36</version>
							</dependency>
						</dependencies>

					</project>
					"""
			);

			Path testJar;
			testJar = repository.resolve(Path.of("com", "example", "test", "1.0.0", "test-1.0.0.jar"));

			Files.writeString(testJar, "dummy");

			assertEquals(resolver.localRepositoryPath, repository);
			assertEquals(resolver.requestedArtifact, new DefaultArtifact("com.example:test:1.0.0"));

			List<String> result;
			result = resolver.resolve();

			assertEquals(
					result,

					List.of(
							"com/example/test/1.0.0/test-1.0.0.jar",
							"org/slf4j/slf4j-api/1.7.36/slf4j-api-1.7.36.jar"
					)
			);
		} finally {
			rmdir(repository);
		}
	}

	private void rmdir(Path root) throws IOException {
		var rm = new SimpleFileVisitor<Path>() {
			@Override
			public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException {
				Files.delete(dir);
				return FileVisitResult.CONTINUE;
			}

			@Override
			public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
				Files.delete(file);
				return FileVisitResult.CONTINUE;
			}
		};

		Files.walkFileTree(root, rm);
	}

}