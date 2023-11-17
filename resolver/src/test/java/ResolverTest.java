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
import org.testng.annotations.Test;

public class ResolverTest {

	private static final String TESTNG_7_7_1 = "org.testng:testng:7.7.1";

	@Test
	public void resolveTestNg771() throws IOException {
		Path repository;
		repository = Files.createTempDirectory("resolver-test-");

		try {
			Resolver resolver;
			resolver = new Resolver();

			String[] args;
			args = new String[] {
					"--local-repo",
					repository.toString(),
					TESTNG_7_7_1
			};

			resolver.parseArgs(args);

			assertEquals(resolver.localRepositoryPath, repository);
			assertEquals(resolver.requestedCoordinates, List.of(TESTNG_7_7_1));
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