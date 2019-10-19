Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76F77DD8D6
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 15:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbfJSNqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 09:46:17 -0400
Received: from mail-il1-f170.google.com ([209.85.166.170]:45716 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfJSNqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 09:46:17 -0400
Received: by mail-il1-f170.google.com with SMTP id u1so8071992ilq.12
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 06:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=UFAsJyOw81ImBzWypVcYSYZBRFZUx43OuPhbzpwnGhU=;
        b=P2w0lg6rZKg0vJ1p/U9/GRwMRGECWFdO2jj/CH4ZVvbCcZOKt/7mfH3vhCYkXhJygL
         mk4IK3xYALSj3xeJLf7h4H5FAAp9BNJ0pHov2aIFFrC20ZNcHujopAkE1x5CFOVFiouC
         2h1Txucv2f4jXnS4hZ1byFyWaGzA0H70eCcDP/nHgulqjveSb8k7sOuQjQYS907zFtE0
         aajeVNbNsILl8r5M5mrv1+mGKbkSUFOUxbtVVG9hq8uqTfBzN0kUVQslkk3Ru1bOgq39
         bVLJlIOylqF+zECoPLo+pY3RfUlilbbUexUTgptaQtHrU+9UUlZoHFM85zFTrnSEIU/P
         F4wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UFAsJyOw81ImBzWypVcYSYZBRFZUx43OuPhbzpwnGhU=;
        b=TZ6N4C4NryTE1jkOj9XeoeWAsjMYih+UWs9Pzem8xZxFH7iBnYhiZ3tDxuI6AqDkHa
         Ppbit8snD4c93sHbpHIcrPADuJQuFGQrHjtPMoPc3sBtBdmyYApNTK+YM8aoO25lWNCQ
         1r6ItnB5+4yZRHw7g5H4dIXOGN7Awv6kqI2e00DDosw/FKC8P6erWMvFlB4FfOUY3igz
         1O95mfz7EAkja5d0koAesU9dk3wspn5YDGwvVQik/CUlzCfD/rtxwJaWJ/DFI96wOVRR
         GOFEDRqpEfTjcOEZXenY5a20ItBl5r34Cp5hRqJmew2PoBzj3c8BfLl6Ubevd81MqMLz
         PaNA==
X-Gm-Message-State: APjAAAUg+RWNxyRC00w7BAq6hLHdmGkstGtm613gjHod3CSM1pMRdIa/
        IayVn27ENyLxmyZ76trzYEFqUA==
X-Google-Smtp-Source: APXvYqx/lSNGiPiQ/CvPI1sfEubgPePCunMInZZ2l10tRbqVprUq6x6C/s6Bp8JDjucl6yR6LEhvcw==
X-Received: by 2002:a92:5dda:: with SMTP id e87mr15905537ilg.216.1571492775895;
        Sat, 19 Oct 2019 06:46:15 -0700 (PDT)
Received: from mojatatu.com ([74.127.203.196])
        by smtp.gmail.com with ESMTPSA id y5sm1931251ilm.63.2019.10.19.06.46.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 19 Oct 2019 06:46:15 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: updated pedit TDC tests
Date:   Sat, 19 Oct 2019 09:45:53 -0400
Message-Id: <1571492753-7771-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added test cases for IP header operations:
- set tos/precedence
- add value to tos/precedence
- clear tos/precedence
- invert tos/precedence

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/actions/pedit.json         | 200 +++++++++++++++++++++
 1 file changed, 200 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json b/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
index 54934203274c..7871073e3576 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/pedit.json
@@ -847,6 +847,206 @@
         ]
     },
     {
+        "id": "cc8a",
+        "name": "Add pedit action with LAYERED_OP ip set tos",
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
+        "cmdUnderTest": "$TC actions add action pedit munge ip tos set 0x4 continue",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action continue keys 1.*key #0  at 0: val 00040000 mask ff00ffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "7a17",
+        "name": "Add pedit action with LAYERED_OP ip set precedence",
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
+        "cmdUnderTest": "$TC actions add action pedit munge ip precedence set 3 jump 2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action jump 2 keys 1.*key #0  at 0: val 00030000 mask ff00ffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "c3b6",
+        "name": "Add pedit action with LAYERED_OP ip add tos",
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
+        "cmdUnderTest": "$TC actions add action pedit ex munge ip tos add 0x1 pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action pass keys 1.*key #0  at ipv4\\+0: val 00010000 mask ff00ffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "43d3",
+        "name": "Add pedit action with LAYERED_OP ip add precedence",
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
+        "cmdUnderTest": "$TC actions add action pedit ex munge ip precedence add 0x1 pipe",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action pipe keys 1.*key #0  at ipv4\\+0: val 00010000 mask ff00ffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "438e",
+        "name": "Add pedit action with LAYERED_OP ip clear tos",
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
+        "cmdUnderTest": "$TC actions add action pedit munge ip tos clear continue",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action continue keys 1.*key #0  at 0: val 00000000 mask ff00ffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "6b1b",
+        "name": "Add pedit action with LAYERED_OP ip clear precedence",
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
+        "cmdUnderTest": "$TC actions add action pedit munge ip precedence clear jump 2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action jump 2 keys 1.*key #0  at 0: val 00000000 mask ff00ffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "824a",
+        "name": "Add pedit action with LAYERED_OP ip invert tos",
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
+        "cmdUnderTest": "$TC actions add action pedit munge ip tos invert pipe",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action pipe keys 1.*key #0  at 0: val 00ff0000 mask ffffffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
+        "id": "106f",
+        "name": "Add pedit action with LAYERED_OP ip invert precedence",
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
+        "cmdUnderTest": "$TC actions add action pedit munge ip precedence invert reclassify",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action pedit",
+        "matchPattern": "action order [0-9]+:  pedit action reclassify keys 1.*key #0  at 0: val 00ff0000 mask ffffffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action pedit"
+        ]
+    },
+    {
         "id": "6829",
         "name": "Add pedit action with LAYERED_OP beyond ip set dport & sport",
         "category": [
-- 
2.7.4

