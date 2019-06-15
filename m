Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D6547205
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 22:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfFOU0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 16:26:00 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:38744 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfFOUZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 16:25:59 -0400
Received: by mail-io1-f49.google.com with SMTP id d12so5235279iod.5
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 13:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=S/i4Du4fuKRLTLc/3rUKIe9r7Kic1xy01Mqy1CmOKf8=;
        b=yT8tu5R3X6eEu3ubgi/L60FQSBH63zHtPfk4r5K8OYPEkFFz1wdi9IhGkn2bnz1Me8
         ry3B7Pvmw99gDwkhlYwGr/5NN2jC41/BQGd9Di/slZP3VaArvml9LUa4lgKRKLfqaGBQ
         MjirgcB5COBV3iWweq7IyH+cy4G03bLa2LFUOujPKOMHvxUC6kqmsWBSrlS/St5OkXgU
         WThnQiC2bSzL8ZKtyRudaJhuyTMIpC2YwBXDP6yF3IhVSC8NYXTYE1ooGyQyZRrnDeo+
         0TjlcBPG7lBZ6fOX1caye7GySCYN7pT2RDg+Bud9vIZoJxDAjrN0bREE1FgOyvAPdw/a
         5/gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=S/i4Du4fuKRLTLc/3rUKIe9r7Kic1xy01Mqy1CmOKf8=;
        b=sRfW2QUyTHDt95mr9tJbR/4VDf3WuQedHEKhuFBjW24lR2CqYGEH65khEnIZ+NLXu0
         vQfB5O72iJAV+xBRF6wHwESIHNugwE/KV9IQzJxaG6XVsKgucMsccjADKaHqoBZ8OdFc
         wyaGlkxbW3qYcd/zRPbVkKcjgPcDrXcGF/V0PCVNv0NE31LwlvcN/iYgUgayQOZ6CIhR
         8SuE2q+eoNBAMUWyPAfWwhOEY0rldNW17qGLF7BHcyP+aDk6kUnY/U5IfPhRsju7VJk3
         8m6jXc6LhpENDoNRu5UoZyJ+eo8gAAxhLAE2yFjIKiFAOPYQp//6xdYTMgBtQuvi48xG
         fkPg==
X-Gm-Message-State: APjAAAXIka8L+kXxP4YIaIC6jMA/IwwH9Vwu+4d0/QHFGrwZsLE9lfi7
        bunsh5uJG2txumkrQ9iuhlVokg==
X-Google-Smtp-Source: APXvYqxC4qcjA6wO0rD3WVbrUC+dKmebFDRihiP0+yXdMnkLlJwUHcN6glRX0mgS/0kvzuNhFvEr3w==
X-Received: by 2002:a6b:2c96:: with SMTP id s144mr51791630ios.57.1560630358919;
        Sat, 15 Jun 2019 13:25:58 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id h18sm5598081iob.80.2019.06.15.13.25.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 15 Jun 2019 13:25:58 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-tests: updated skbedit tests
Date:   Sat, 15 Jun 2019 16:25:50 -0400
Message-Id: <1560630350-23799-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Added index upper bound test case
- Added mark upper bound test case
- Re-worded descriptions to few cases for clarity

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/actions/skbedit.json       | 62 ++++++++++++++++++----
 1 file changed, 53 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json b/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json
index ecd96eda7f6a..45e7e89928a5 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json
@@ -24,8 +24,32 @@
         ]
     },
     {
+        "id": "c8cf",
+        "name": "Add skbedit action with 32-bit maximum mark",
+        "category": [
+            "actions",
+            "skbedit"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action skbedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action skbedit mark 4294967295 pipe index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions get action skbedit index 1",
+        "matchPattern": "action order [0-9]*: skbedit  mark 4294967295.*pipe.*index 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action skbedit"
+        ]
+    },
+    {
         "id": "407b",
-        "name": "Add skbedit action with invalid mark",
+        "name": "Add skbedit action with mark exceeding 32-bit maximum",
         "category": [
             "actions",
             "skbedit"
@@ -43,9 +67,7 @@
         "verifyCmd": "$TC actions list action skbedit",
         "matchPattern": "action order [0-9]*:  skbedit mark",
         "matchCount": "0",
-        "teardown": [
-            "$TC actions flush action skbedit"
-        ]
+        "teardown": []
     },
     {
         "id": "081d",
@@ -121,7 +143,7 @@
     },
     {
         "id": "985c",
-        "name": "Add skbedit action with invalid queue_mapping",
+        "name": "Add skbedit action with queue_mapping exceeding 16-bit maximum",
         "category": [
             "actions",
             "skbedit"
@@ -413,7 +435,7 @@
     },
     {
         "id": "a6d6",
-        "name": "Add skbedit action with index",
+        "name": "Add skbedit action with index at 32-bit maximum",
         "category": [
             "actions",
             "skbedit"
@@ -426,16 +448,38 @@
                 255
             ]
         ],
-        "cmdUnderTest": "$TC actions add action skbedit mark 808 index 4040404040",
+        "cmdUnderTest": "$TC actions add action skbedit mark 808 index 4294967295",
         "expExitCode": "0",
-        "verifyCmd": "$TC actions list action skbedit",
-        "matchPattern": "index 4040404040",
+        "verifyCmd": "$TC actions get action skbedit index 4294967295",
+        "matchPattern": "action order [0-9]*: skbedit  mark 808.*index 4294967295",
         "matchCount": "1",
         "teardown": [
             "$TC actions flush action skbedit"
         ]
     },
     {
+        "id": "f0f4",
+        "name": "Add skbedit action with index exceeding 32-bit maximum",
+        "category": [
+            "actions",
+            "skbedit"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action skbedit",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC actions add action skbedit mark 808 pass index 4294967297",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions get action skbedit index 4294967297",
+        "matchPattern": "action order [0-9]*:.*skbedit.*mark 808.*pass.*index 4294967297",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
         "id": "38f3",
         "name": "Delete skbedit action",
         "category": [
-- 
2.7.4

