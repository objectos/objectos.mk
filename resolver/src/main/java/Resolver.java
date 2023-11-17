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

import java.io.File;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import org.apache.maven.repository.internal.MavenRepositorySystemUtils;
import org.eclipse.aether.AbstractRepositoryListener;
import org.eclipse.aether.DefaultRepositorySystemSession;
import org.eclipse.aether.RepositoryEvent;
import org.eclipse.aether.RepositoryListener;
import org.eclipse.aether.RepositorySystem;
import org.eclipse.aether.artifact.Artifact;
import org.eclipse.aether.artifact.DefaultArtifact;
import org.eclipse.aether.collection.CollectRequest;
import org.eclipse.aether.connector.basic.BasicRepositoryConnectorFactory;
import org.eclipse.aether.graph.Dependency;
import org.eclipse.aether.impl.DefaultServiceLocator;
import org.eclipse.aether.repository.LocalRepository;
import org.eclipse.aether.repository.LocalRepositoryManager;
import org.eclipse.aether.repository.RemoteRepository;
import org.eclipse.aether.resolution.ArtifactResult;
import org.eclipse.aether.resolution.DependencyRequest;
import org.eclipse.aether.resolution.DependencyResolutionException;
import org.eclipse.aether.resolution.DependencyResult;
import org.eclipse.aether.spi.connector.RepositoryConnectorFactory;
import org.eclipse.aether.spi.connector.transport.TransporterFactory;
import org.eclipse.aether.transport.file.FileTransporterFactory;
import org.eclipse.aether.transport.http.HttpTransporterFactory;
import org.eclipse.aether.util.artifact.JavaScopes;

@SuppressWarnings("deprecation")
public class Resolver {

	Path localRepositoryPath;

	List<String> requestedCoordinates = new ArrayList<>();

	Resolver() {}

	public static void main(String[] args) {
		Resolver resolver;
		resolver = new Resolver();

		resolver.parseArgs(args);
	}

	final void parseArgs(String[] args) {
		int index;
		index = 0;

		int length;
		length = args.length;

		while (index < length) {
			String arg;
			arg = args[index++];

			switch (arg) {
				case "--local-repo" -> {
					if (index < length) {
						String name;
						name = args[index++];

						localRepositoryPath = Path.of(name);
					}
				}

				default -> requestedCoordinates.add(arg);
			}
		}

		if (localRepositoryPath == null) {
			throw new UnsupportedOperationException("Implement me");
		}

		if (requestedCoordinates.isEmpty()) {
			throw new UnsupportedOperationException("Implement me");
		}
	}

	final List<String> resolve() throws DependencyResolutionException {
		// RepositorySystem

		DefaultServiceLocator serviceLocator;
		serviceLocator = MavenRepositorySystemUtils.newServiceLocator();

		serviceLocator.addService(RepositoryConnectorFactory.class, BasicRepositoryConnectorFactory.class);

		serviceLocator.addService(TransporterFactory.class, FileTransporterFactory.class);

		serviceLocator.addService(TransporterFactory.class, HttpTransporterFactory.class);

		RepositorySystem repositorySystem;
		repositorySystem = serviceLocator.getService(RepositorySystem.class);

		// RepositorySystemSession

		DefaultRepositorySystemSession session;
		session = MavenRepositorySystemUtils.newSession();

		File localRepositoryFile;
		localRepositoryFile = localRepositoryPath.toFile();

		LocalRepository localRepository;
		localRepository = new LocalRepository(localRepositoryFile);

		LocalRepositoryManager localRepositoryManager;
		localRepositoryManager = repositorySystem.newLocalRepositoryManager(session, localRepository);

		session.setLocalRepositoryManager(localRepositoryManager);

		RepositoryListener repositoryListener;
		repositoryListener = new ThisRepositoryListener();

		session.setRepositoryListener(repositoryListener);

		// CollectRequest

		CollectRequest collectRequest;
		collectRequest = new CollectRequest();

		List<Dependency> dependencies;
		dependencies = createDependencies();

		collectRequest.setDependencies(dependencies);

		RemoteRepository central;
		central = new RemoteRepository.Builder("central", "default", "https://repo1.maven.org/maven2/").build();

		List<RemoteRepository> repositories;
		repositories = List.of(central);

		collectRequest.setRepositories(repositories);

		// DependencyRequest

		DependencyRequest dependencyRequest;
		dependencyRequest = new DependencyRequest(collectRequest, null);

		DependencyResult dependencyResult;
		dependencyResult = repositorySystem.resolveDependencies(session, dependencyRequest);

		List<ArtifactResult> artifacts;
		artifacts = dependencyResult.getArtifactResults();

		return artifacts.stream()
				.map(ArtifactResult::getArtifact)
				.map(Artifact::getFile)
				.map(File::getAbsolutePath)
				.toList();
	}

	private List<Dependency> createDependencies() {
		int size;
		size = requestedCoordinates.size();

		List<Dependency> result;
		result = new ArrayList<>(size);

		for (int i = 0; i < size; i++) {
			String coordinate;
			coordinate = requestedCoordinates.get(i);

			Artifact artifact;
			artifact = new DefaultArtifact(coordinate);

			String scope;
			scope = JavaScopes.COMPILE;

			Dependency dependency;
			dependency = new Dependency(artifact, scope);

			result.add(dependency);
		}

		return result;
	}

}

final class ThisRepositoryListener extends AbstractRepositoryListener {

	@Override
	public final void artifactDownloading(RepositoryEvent event) {
		Artifact artifact;
		artifact = event.getArtifact();

		log("Downloading", artifact);
	}

	private void log(String action, Artifact artifact) {
		System.out.println(action + " " + artifact);
	}

}