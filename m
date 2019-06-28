Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27BB55A398
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfF1Sah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:30:37 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:33501 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfF1Sah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:30:37 -0400
Received: by mail-io1-f47.google.com with SMTP id u13so14587141iop.0
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jkbHn2jzC3UONBFtiBz/8eVPYnS/BBeCIRAmEIbLSq8=;
        b=PZQt85QwygSnSpsZKj40LKB5QWqSBKgtVtbh0d7jMsihf9x+XcCvFmNZ6cttIYhjQ+
         u1DeeZHCBDI/rQX0IvAV7uchUYU8VKUiYI/x/QoNW+RA3seRz1RMyO4GPnY1FbExrGUm
         Y8MmdvYHGvpJKmUkUAY9tC6zwYyPFztSyMrc7NKxNRMuPTZ5AnibVcOz/Si4nKAQMcTc
         M0On/cVZYyvBGiSPFX4SENtBmJkFG2NIpABqjdIjzTrPXWvAL0xsRBGqd3JFW43weAYN
         xlAvEC4oKv05VvcF3Pqk0jnYNaDBAh8WQqiXuunw9FNmnT2XqM+/cfCW8r9IzHQgWp4Z
         t0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jkbHn2jzC3UONBFtiBz/8eVPYnS/BBeCIRAmEIbLSq8=;
        b=HjNMXs0CcQqdQhLKOdhvpONCWF9hkAaFCGOlSVUmedn76TwoEk4ZImy+gParhyHUBA
         0nlLQ+nCFn+kZLuZ8TJaGksMYOULDGamFkWwOAmXaK2/sCTPmNBeKIGDJ3GTOq4E3ide
         jhVeHUZKph0xS+0KoYvn2bHlVdaHsZHjiMCgK2X8DyNs81vPGKj3yHYGvp+lM0ubRRoO
         H+Gih1P2t4pA7scLqES36lKH+vPQna2fWlyTt+84NWxCl/E575DQc62BVphl4V+3SJTd
         gX18BhHG1oqiEIVAMPi2OdJIeIXEzW9+ULkAopNKHR/Gb+82PbTnJUWdWx1Csmvptgw4
         jKwg==
X-Gm-Message-State: APjAAAUIJ9Mp+udOQMTJgkUus3kB8TaN/b2ddryaxYJcla1VxOW8H/3I
        u745UOEm7afqwPT0u/PPZ/GhEA==
X-Google-Smtp-Source: APXvYqyfAu5Bm+DaXfdi0JkBeN4fXE3UgU7MuOY0QV16aKxB4i+bYwLwnFHxJ0B53NtEUfwyA1Ea0w==
X-Received: by 2002:a6b:ed02:: with SMTP id n2mr12878666iog.131.1561746636362;
        Fri, 28 Jun 2019 11:30:36 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id t4sm2472804iop.0.2019.06.28.11.30.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 28 Jun 2019 11:30:36 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 2/2] tc-testing: updated mirred action tests with batch create/delete
Date:   Fri, 28 Jun 2019 14:30:18 -0400
Message-Id: <1561746618-29349-3-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561746618-29349-1-git-send-email-mrv@mojatatu.com>
References: <1561746618-29349-1-git-send-email-mrv@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/actions/mirred.json        | 94 ++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json b/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json
index 6e5fb3d25681..2232b21e2510 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/mirred.json
@@ -459,5 +459,99 @@
         "teardown": [
             "$TC actions flush action mirred"
         ]
+    },
+    {
+        "id": "4749",
+        "name": "Add batch of 32 mirred redirect egress actions with cookie",
+        "category": [
+            "actions",
+            "mirred"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mirred",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action mirred egress redirect dev lo index \\$i cookie aabbccddeeff112233445566778800a1 \\\"; args=\"\\$args\\$cmd\"; done && $TC actions add \\$args\"",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mirred",
+        "matchPattern": "^[ \t]+index [0-9]+ ref",
+        "matchCount": "32",
+        "teardown": [
+            "$TC actions flush action mirred"
+        ]
+    },
+    {
+        "id": "5c69",
+        "name": "Delete batch of 32 mirred redirect egress actions",
+        "category": [
+            "actions",
+            "mirred"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mirred",
+                0,
+                1,
+                255
+            ],
+            "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action mirred egress redirect dev lo index \\$i \\\"; args=\\\"\\$args\\$cmd\\\"; done && $TC actions add \\$args\""
+        ],
+        "cmdUnderTest": "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action mirred index \\$i \\\"; args=\"\\$args\\$cmd\"; done && $TC actions del \\$args\"",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mirred",
+        "matchPattern": "^[ \t]+index [0-9]+ ref",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "d3c0",
+        "name": "Add batch of 32 mirred mirror ingress actions with cookie",
+        "category": [
+            "actions",
+            "mirred"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mirred",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action mirred ingress mirror dev lo index \\$i cookie aabbccddeeff112233445566778800a1 \\\"; args=\"\\$args\\$cmd\"; done && $TC actions add \\$args\"",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mirred",
+        "matchPattern": "^[ \t]+index [0-9]+ ref",
+        "matchCount": "32",
+        "teardown": [
+            "$TC actions flush action mirred"
+        ]
+    },
+    {
+        "id": "e684",
+        "name": "Delete batch of 32 mirred mirror ingress actions",
+        "category": [
+            "actions",
+            "mirred"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action mirred",
+                0,
+                1,
+                255
+            ],
+            "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action mirred ingress mirror dev lo index \\$i \\\"; args=\\\"\\$args\\$cmd\\\"; done && $TC actions add \\$args\""
+        ],
+        "cmdUnderTest": "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action mirred index \\$i \\\"; args=\"\\$args\\$cmd\"; done && $TC actions del \\$args\"",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action mirred",
+        "matchPattern": "^[ \t]+index [0-9]+ ref",
+        "matchCount": "0",
+        "teardown": []
     }
 ]
-- 
2.7.4

