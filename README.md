# Fanes-Code CLI 🚀

Advanced Flutter Scaffolding Tool for Clean Architecture (BLoC & GetX).

## Features
- ✅ **Init Project**: Automated folder structure & routes setup.
- ✅ **BLoC Generator**: Create features with automatic global provider registration.
- ✅ **GetX Generator**: Create features with automatic route & binding injection.
- ✅ **API Scaffolding**: Inject POST/GET Dio logic with Token headers automatically.
- ✅ **Local Storage**: Hive initialization in one command.
- ✅ **Custom Widgets**: Rapidly create common UI components (e.g., Password Field).

## Installation
```bash
git clone https://github.com/fanes-setiawan/flutter_cli_automation.git
cd flutter_cli_automation
dart pub global activate --source path . --overwrite
```

## Usage
```bash
fanes-cli version
fanes-cli init
fanes-cli bloc -n <feature_name>
fanes-cli getx -n <feature_name>
fanes-cli add-post -n <function_name>
```

Built with ❤️ by Fanes Setiawan.
