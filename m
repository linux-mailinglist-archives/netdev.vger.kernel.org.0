Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE02379CB1
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbfG2XSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:18:24 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40983 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbfG2XSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 19:18:24 -0400
Received: by mail-io1-f65.google.com with SMTP id j5so119750831ioj.8
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 16:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=KdMST0YsCsn8j8M8lepePI08kGwTM65TpX8iIW6UI6g=;
        b=RCQWF7Z57rza4InRFNLO/zTGFUbXaxf7OEcL4ySCd5GrDMYXz2yXJaK/DtkXnE7SKh
         b0tSZhOmZuBvEJfSUTowxkk7R8d1oWUE3pPxMZ5MI5diwkYJVqwyu144tD+AVaEbclBj
         lCXwYNDsuURefJzdKm7Rpt79vlnY/i/UyjcmxvwvXqJvNXOlaRqR2ARpeYtGAlNLlbFq
         doNrbEQch7OuLgmZJUoGPypPg1VZs8GkCm4qhtuEmI3NsmJbFcbvxznFbe5iKHfw8aNa
         j9rrIFaPsl4WVKJCr4bZ+ZMcGq4AjsCxP6o4H5ve+8oF5x2xNf8r6B1H0mXRXfxopt75
         W5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KdMST0YsCsn8j8M8lepePI08kGwTM65TpX8iIW6UI6g=;
        b=DGxxbn9GNFQ/2iniSo175VhE6HYjPMq403/Snw7iTxo69vjzkeygFrNDc1Qb1IsRoN
         01x/As9BMDgkYnB16Cl/MZoUtDNRSjjJ1GOEm/kMr9JCyzG38Rdn1bxzbmSTJOZy5wG3
         x1s4Rf8khoypRo783vTcPZZJJ1mtxsBgbdz5Xk374JEEwEx7nArs2GyplLBTdx9cfHqX
         L7QXucLrbN5fhJhI4xs3CZrXwiLYSDsvWT+AnmIeI2IknxFmzYlgbTo/+RJ5aoZv6bGt
         NUm7yduuumNKgieyahDaOVK+hGIEbL74xgUqH14eVv8EVT3Yq9p811Y1mMVlnHRhmiPH
         PcJA==
X-Gm-Message-State: APjAAAWfB7cUYZRMet7fdL+ddJgt0yK8Bd6Ir1fHs3jBoGqDEdbyXP0D
        /jy/ZWiRapyuSL7jehelBb8=
X-Google-Smtp-Source: APXvYqwh8TAZY2mGL2yBU7XmmPEzePEUGil+uErb4mxddf77Rcg4SKT7oduocNrsTvxQimKp4YBFAg==
X-Received: by 2002:a6b:bbc1:: with SMTP id l184mr35100489iof.232.1564442303510;
        Mon, 29 Jul 2019 16:18:23 -0700 (PDT)
Received: from mojatatu.com ([2607:f2c0:e4b2:adf:ac47:d238:7c0e:5d62])
        by smtp.gmail.com with ESMTPSA id s15sm49435173ioe.88.2019.07.29.16.18.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Jul 2019 16:18:22 -0700 (PDT)
From:   Lucas Bates <lucasb@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, nicolas.dichtel@6wind.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        mleitner@redhat.com, vladbu@mellanox.com, dcaratti@redhat.com,
        kernel@mojatatu.com, Lucas Bates <lucasb@mojatatu.com>
Subject: [PATCH v2 net-next 1/1] tc-testing: Clarify the use of tdc's -d option
Date:   Mon, 29 Jul 2019 19:18:12 -0400
Message-Id: <1564442292-4731-1-git-send-email-lucasb@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The -d command line argument to tdc requires the name of a physical device
on the system where the tests will be run. If -d has not been used, tdc
will skip tests that require a physical device.

This patch is intended to better document what the -d option does and how
it is used.

Signed-off-by: Lucas Bates <lucasb@mojatatu.com>
---
 tools/testing/selftests/tc-testing/README |  4 +++-
 tools/testing/selftests/tc-testing/tdc.py | 12 ++++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/README b/tools/testing/selftests/tc-testing/README
index 22e5da9..b0954c8 100644
--- a/tools/testing/selftests/tc-testing/README
+++ b/tools/testing/selftests/tc-testing/README
@@ -128,7 +128,9 @@ optional arguments:
   -v, --verbose         Show the commands that are being run
   -N, --notap           Suppress tap results for command under test
   -d DEVICE, --device DEVICE
-                        Execute the test case in flower category
+                        Execute test cases that use a physical device, where
+                        DEVICE is its name. (If not defined, tests that require
+                        a physical device will be skipped)
   -P, --pause           Pause execution just before post-suite stage
 
 selection:
diff --git a/tools/testing/selftests/tc-testing/tdc.py b/tools/testing/selftests/tc-testing/tdc.py
index f04321a..e566c70 100755
--- a/tools/testing/selftests/tc-testing/tdc.py
+++ b/tools/testing/selftests/tc-testing/tdc.py
@@ -356,12 +356,14 @@ def test_runner(pm, args, filtered_tests):
     time.sleep(2)
     for tidx in testlist:
         if "flower" in tidx["category"] and args.device == None:
+            errmsg = "Tests using the DEV2 variable must define the name of a "
+            errmsg += "physical NIC with the -d option when running tdc.\n"
+            errmsg += "Test has been skipped."
             if args.verbose > 1:
-                print('Not executing test {} {} because DEV2 not defined'.
-                      format(tidx['id'], tidx['name']))
+                print(errmsg)
             res = TestResult(tidx['id'], tidx['name'])
             res.set_result(ResultState.skip)
-            res.set_errormsg('Not executed because DEV2 is not defined')
+            res.set_errormsg(errmsg)
             tsr.add_resultdata(res)
             continue
         try:
@@ -499,7 +501,9 @@ def set_args(parser):
         choices=['none', 'xunit', 'tap'],
         help='Specify the format for test results. (Default: TAP)')
     parser.add_argument('-d', '--device',
-                        help='Execute the test case in flower category')
+                        help='Execute test cases that use a physical device, ' +
+                        'where DEVICE is its name. (If not defined, tests ' +
+                        'that require a physical device will be skipped)')
     parser.add_argument(
         '-P', '--pause', action='store_true',
         help='Pause execution just before post-suite stage')
-- 
2.7.4

