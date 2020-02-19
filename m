Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE9721651BF
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 22:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgBSViR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 16:38:17 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36002 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbgBSViR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 16:38:17 -0500
Received: by mail-qt1-f194.google.com with SMTP id t13so1390726qto.3
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 13:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=8qyGB2579j4yy+TVYecF3MMS4B8zTaBpF1Dlq2IhRUE=;
        b=pXvH4kSl1W+kV1UtX9tx5hwwiguUwSCA+wJoURgidZLwL4BYH1LIiE7DZT2gPtMJ9t
         e2iyXMmUrK875zPm8Ub8/yAqsA5HxmJy6kqDvmBqzBHg/WAIQ6mp8tdo7Y0ZqRLgg/2b
         TsGuBExueRXt6TappiBv9t77cloxKcngR9Apa4P4ehI2rnMA6gJtsi3l4NdRx4UV3H52
         ExuAEFk1oVT1zD5dG4njnuI1NDhzTsDEsZzW2o8yhuMxN9NOFsD7Owt28Br+fBrXcv4M
         vOooWFEBrbP+b48uP+H8Jwo8yGn0cnue7msrszZBcAb/+mHTM3dNRElRbyE7R5XrPMDG
         AeIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8qyGB2579j4yy+TVYecF3MMS4B8zTaBpF1Dlq2IhRUE=;
        b=TiDockd4sYm5ExRbHO+Y0+vzV3aVDk6VVIN/ZTYLryhuDbI5QApSofqA3a0cFROYj/
         ogB9OAs7lMSkxDpN6Q/e5zHw+SkHu0pXt9Nb9BnZzQTu8Py24KJwEfZwm9V7OyqJem7V
         5feZdvWaaYG1sw7vSuwGMLwP66dwBv36SHbvKJrtD+Vs5XdU1o8HzWx1BAr4o/TzzMUU
         Ctc3/Z4/73mWZzNzCX5vE73PiYvLuY2iJo4UvJCpmTyupEOPE3hGpulFpjRjwb9hPsOp
         r/2J+lLYWqQEQfzuhev7+KOfTxWK6q8RcBf5+/+0m11BxipWaIitAdxXgUa2VB/o4VbC
         TygQ==
X-Gm-Message-State: APjAAAUt+IQO0QlYsz2K5FRu65KW63CmtQyRbqA9uUIjhULmivEw3ngt
        QXLT7IO6XCTIxb9zZM5DjfQqm3wOs54=
X-Google-Smtp-Source: APXvYqytRrvTnYXtJGXcWKKHffbYvVeXg6hsJ0rCV2jNT+DK//eaDpJuV6Cv6nDf0fFdr3XxsPF8zQ==
X-Received: by 2002:ac8:67d7:: with SMTP id r23mr23568141qtp.20.1582148295840;
        Wed, 19 Feb 2020 13:38:15 -0800 (PST)
Received: from mojatatu.com (69-196-152-194.dsl.teksavvy.com. [69.196.152.194])
        by smtp.gmail.com with ESMTPSA id g18sm541730qki.13.2020.02.19.13.38.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 19 Feb 2020 13:38:15 -0800 (PST)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: updated tdc tests for basic filter
Date:   Wed, 19 Feb 2020 16:37:56 -0500
Message-Id: <1582148276-6955-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added tests for 'u32' extended match rules for u8 alignment.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/filters/basic.json         | 242 +++++++++++++++++++++
 1 file changed, 242 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
index 98a20faf3198..75f547a5ee48 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
@@ -372,5 +372,247 @@
         "teardown": [
             "$TC qdisc del dev $DEV1 ingress"
         ]
+    },
+    {
+        "id": "bae4",
+        "name": "Add basic filter with u32 ematch u8/zero offset and default action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u8 0x11 0x0f at 0)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(01000000/0f000000 at 0\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "e6cb",
+        "name": "Add basic filter with u32 ematch u8/zero offset and invalid value >0xFF",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u8 0x1122 0x0f at 0)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(11220000/0f000000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "7727",
+        "name": "Add basic filter with u32 ematch u8/positive offset and default action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u8 0x77 0x1f at 12)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(17000000/1f000000 at 12\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "a429",
+        "name": "Add basic filter with u32 ematch u8/invalid mask >0xFF",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u8 0x77 0xff00 at 12)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(77000000/ff000000 at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "8373",
+        "name": "Add basic filter with u32 ematch u8/missing offset",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u8 0x77 0xff at)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(77000000 at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "ab8e",
+        "name": "Add basic filter with u32 ematch u8/missing AT keyword",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u8 0x77 0xff 0)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(77000000 at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "712d",
+        "name": "Add basic filter with u32 ematch u8/missing value",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u8 at 12)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "350f",
+        "name": "Add basic filter with u32 ematch u8/non-numeric value",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u8 zero 0xff at 0)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(00000000/ff000000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "e28f",
+        "name": "Add basic filter with u32 ematch u8/non-numeric mask",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u8 0x11 mask at 0)' classid 1:1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(11000000/00000000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "6d5f",
+        "name": "Add basic filter with u32 ematch u8/negative offset and default action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u8 0xaa 0xf0 at -14)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(0000a000/0000f000 at -16\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "12dc",
+        "name": "Add basic filter with u32 ematch u8/nexthdr+ offset and default action",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u8 0xaa 0xf0 at nexthdr+0)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip basic",
+        "matchPattern": "^filter parent ffff: protocol ip pref 1 basic.*handle 0x1 flowid 1:1.*u32\\(a0000000/f0000000 at nexthdr\\+0\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
     }
 ]
-- 
2.7.4

