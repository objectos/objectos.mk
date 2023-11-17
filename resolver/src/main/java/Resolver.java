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

import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

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
	}

}
