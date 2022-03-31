import 'dart:collection';

import 'package:at_commons/at_commons.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests to verify notify verb regex', () {
    test('Test to verify notify verb with encryptedSharedKey and checksum', () {
      var command =
          'notify:update:priority:low:strategy:all:latestN:1:sharedKeyEnc:GxIjM8e/nsga3:pubKeyCS:5d52f6f2868:@bob:phone.wavi@alice:989745456';
      var verbParams = _getVerbParams(VerbSyntax.notify, command);
      expect(verbParams[SHARED_KEY_ENCRYPTED], 'GxIjM8e/nsga3');
      expect(verbParams[SHARED_WITH_PUBLIC_KEY_CHECK_SUM], '5d52f6f2868');
      expect(verbParams[PRIORITY], 'low');
      expect(verbParams[LATEST_N], '1');
      expect(verbParams[VALUE], '989745456');
      expect(verbParams[STRATEGY], 'all');
    });
  });

  group('A group of tests to verify notify delete verb', () {
    test('Valid id sent to notify delete', () {
      var command = 'notify:delete:abcd-1234';
      var verbParams = _getVerbParams(VerbSyntax.notifyDelete, command);
      expect(verbParams[ID], 'abcd-1234');
    });

    test('id not sent to notify delete', () {
      var command = 'notify:delete:';
      var verbParams = _getVerbParams(VerbSyntax.notifyDelete, command);
      expect(verbParams.isEmpty, true);
    });
  });
}

Map _getVerbParams(String regex, String command) {
  var regExp = RegExp(regex, caseSensitive: false);
  var regexMatches = regExp.allMatches(command);
  var paramsMap = HashMap<String, String?>();
  for (var f in regexMatches) {
    for (var name in f.groupNames) {
      paramsMap.putIfAbsent(name, () => f.namedGroup(name));
    }
  }
  return paramsMap;
}
