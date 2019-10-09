Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D29D1A25
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbfJIUx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:53:59 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38885 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbfJIUx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:53:59 -0400
Received: by mail-io1-f66.google.com with SMTP id u8so8460237iom.5
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 13:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=rFSEbgthMxPvlvlOTpNgDKBBJz69ouzL9ePokw5k1lQ=;
        b=VcHYtKGLPd46FcWdHOW2LcMsT2PmZIANSEB0M2rjIDSixe6sxo+AJWrE2h4ntlp/Ki
         XDzC2ES3dZF271tNKdcQ2g1YIfjf4h0PLsnoAdEZFbTxMsfhRaMQClcuEWRF81R6kYAz
         jJKLwENyFVzQKeeVLl6F2FxWaNjm8Jrl9rTCDBpdOL9+pX8OOnYfwZ67FDVfUse3wFtv
         FhWLlsXhz/wZXY/vsWc0tL4biMlzBSJqY83OiXfNxM42QvXSBjA8Ow+8J7TVFMty3k2N
         C75LZfaak59I5bbsWa7mmpjsjGCS7H54cW7iwhZ8WDp02pYqyu6vCGBynlyrMqndGEYe
         LJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rFSEbgthMxPvlvlOTpNgDKBBJz69ouzL9ePokw5k1lQ=;
        b=mbEy0Cfh/ApgbQb/pktQL0+H4YW/v9MbPo4k12knuQtbxC507ejrGuXhOqiw8A/O/1
         dtlNj+O7bFLv7yAkzCQ+1zorME+v5b5fi6y03j2ey0O/uIz2XLc4bEiD0SZj0c1vQe6O
         jaVLUtCB5mButtEpAyZCInZ1wjoU36EzY6X8buAPyji3Up/fSdgKy7/qpMLlGek0JUth
         sjuGABQn3If1ViD3USQHRnHWQHoBqk0hxoUwBrwTiiTNPGHNwXlnM0WRVzU5H6A5f9FB
         hStQdTkg02t1KoMA04va3r4juvEQEaas0JqHexgVnnOUrap2qyAEFAiGMt5nPpGhsyj9
         I0zg==
X-Gm-Message-State: APjAAAX61kpygIuBCXiQdzzwbBiy7gzFNZn/YunfvzQikk2Oqka2of1O
        /EDciMezVRue8zeuIqEjN09+Vg==
X-Google-Smtp-Source: APXvYqz2Ti/KyjPT9cfKOlaqW6sHu66dD6tf1Hzc1CXb/MXsKm2fjNRzNXTRU1kdkFKrQ/jdH6vUsw==
X-Received: by 2002:a05:6602:25d6:: with SMTP id d22mr5484879iop.188.1570654438274;
        Wed, 09 Oct 2019 13:53:58 -0700 (PDT)
Received: from mojatatu.com (69-196-152-194.dsl.teksavvy.com. [69.196.152.194])
        by smtp.gmail.com with ESMTPSA id x11sm2364570ioa.4.2019.10.09.13.53.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 09 Oct 2019 13:53:57 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: updated pedit test cases
Date:   Wed,  9 Oct 2019 16:53:51 -0400
Message-Id: <1570654431-8270-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added test case for layered IP operation for a single source IP4/IP6
address and a single destination IP4/IP6 address.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/actions/pedit.json         | 101 ++++++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json b/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
index 0d319f1d01db..c30d37a0b9bc 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
@@ -424,6 +424,56 @@
         ]
     },
     {
+        "id": "7588",
+        "name": "Add pedit action with LAYERED_OP ip set src",
+        "category": [
+            "actions",
+            "pedit",
+            "layered_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit munge ip src set 1.1.1.1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action pass keys 1.*key #0  at 12: val 01010101 mask 00000000",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "0fa7",
+        "name": "Add pedit action with LAYERED_OP ip set dst",
+        "category": [
+            "actions",
+            "pedit",
+            "layered_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit munge ip dst set 2.2.2.2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action pass keys 1.*key #0  at 16: val 02020202 mask 00000000",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
         "id": "5810",
         "name": "Add pedit action with LAYERED_OP ip set src & dst",
         "category": [
@@ -674,6 +724,56 @@
         ]
     },
     {
+        "id": "815c",
+        "name": "Add pedit action with LAYERED_OP ip6 set src",
+        "category": [
+            "actions",
+            "pedit",
+            "layered_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit ex munge ip6 src set 2001:0db8:0:f101::1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action pass keys 4.*key #0  at ipv6\\+8: val 20010db8 mask 00000000.*key #1  at ipv6\\+12: val 0000f101 mask 00000000.*key #2  at ipv6\\+16: val 00000000 mask 00000000.*key #3  at ipv6\\+20: val 00000001 mask 00000000",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "4dae",
+        "name": "Add pedit action with LAYERED_OP ip6 set dst",
+        "category": [
+            "actions",
+            "pedit",
+            "layered_op"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action pedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action pedit ex munge ip6 dst set 2001:0db8:0:f101::1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action pass keys 4.*key #0  at ipv6\\+24: val 20010db8 mask 00000000.*key #1  at ipv6\\+28: val 0000f101 mask 00000000.*key #2  at ipv6\\+32: val 00000000 mask 00000000.*key #3  at ipv6\\+36: val 00000001 mask 00000000",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
         "id": "fc1f",
         "name": "Add pedit action with LAYERED_OP ip6 set src & dst",
         "category": [
@@ -950,5 +1050,4 @@
             "$TC actions flush action pedit"
         ]
     }
-
 ]
-- 
2.7.4

