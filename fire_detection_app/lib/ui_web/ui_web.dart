// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This library defines the web-specific additions that go along with dart:ui
//
// The web_sdk/sdk_rewriter.dart uses this directive.
// ignore: unnecessary_library_directive
@JS()
library dart.ui_web;

import 'dart:async';
import 'dart:_js_annotations';
import 'dart:ui' as ui;
import 'dart:_skwasm_stub' if (dart.library.ffi) 'dart:_skwasm_impl';
import 'dart:_engine';
import 'dart:_web_unicode';
import 'dart:_web_test_fonts';
import 'dart:_web_locale_keymap' as locale_keymap;


part 'ui_web/url_strategy.dart';
