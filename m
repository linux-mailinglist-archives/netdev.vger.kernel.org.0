Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 785A165B8A
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 18:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbfGKQ3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 12:29:08 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39513 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728045AbfGKQ3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 12:29:08 -0400
Received: by mail-io1-f68.google.com with SMTP id f4so13875194ioh.6
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 09:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=3PGALE1Lj/+P5QEMH+LWiHvgMILXh+vRnx/Jvwzj3v8=;
        b=WdFFfFC7lK8VEZYeAyJ6nfueWEred8X9HeQi0UJRy9TFQoAa5Gkkj6zriF9cnuGYnT
         IiWKsGDj9PKbwL72M6PDoH67aezlNCyTEAh/6YpmjKA0Y6IQQvmaEZ+v0doIc9yYgukc
         Cn65TOho6aAaUQpRzmkArjmqoFh5TohDADkWG7xiXpBH7VBVtzr6czqTmqLLsq2e4SNj
         9mJAEwwW+eV1GPlrBDcQK4KXn0AVzrAUnVNm+hh8bE3DDqA24PWqlYZUoNk+xVvwzjSc
         NJVKzv5vm3V59wMEXowu8+qWSLu1OH+vXa/V5/t2B84NEnUFX9KZlcrUuMY5FthbaxTi
         bekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3PGALE1Lj/+P5QEMH+LWiHvgMILXh+vRnx/Jvwzj3v8=;
        b=IdmnaBdN/+7QpgFk7coVOLYPTX5dVStmeWS0+IlB6QAhL8mLTY3xY69AFJmv3BAMJH
         qdQMpmvhGEvSIaoNW+EYobDLD/t8MgMVnFuisv/zcnvnuNalOurAUVW6V/Bo/yPCocu9
         WzLhIgvNX/AEDoYgX3Kxym1/mJZ16hPouowXyZo6BfPvH2xWsO/DwkTve5rse3ycqZcn
         M/ipgDDP2E7VJ8WVAIRepvuL0wFSpdX2wGfQPZ46O2YByJk9kGtFPxRGCJ239qXCOBlw
         QQ9SLqAzmosw/pOixQw/ONm8/vAsbcF120onk56D4zrw+qiZusqNXRAPA6zWNW2pfS22
         /MEA==
X-Gm-Message-State: APjAAAXhmZmWO/u6a25lMGHbJWs+t6Y32028HiZztRUAME58VrcqcBLd
        R6Iefk3PF97EgW7s9BdvIC7WOzmr
X-Google-Smtp-Source: APXvYqxNaubtpaUHIXFd4K+9YsyiR8AiC9go5d8u6e9vwrA776+cZU5dI8M27PGOGtL9cDEDctRquA==
X-Received: by 2002:a05:6602:219a:: with SMTP id b26mr5379294iob.55.1562862547182;
        Thu, 11 Jul 2019 09:29:07 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id t5sm5173856iol.55.2019.07.11.09.29.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 11 Jul 2019 09:29:06 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-tests: updated skbedit tests
Date:   Thu, 11 Jul 2019 12:29:00 -0400
Message-Id: <1562862540-16509-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Added mask upper bound test case
- Added mask validation test case
- Added mask replacement case

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/actions/skbedit.json       | 117 +++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json b/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json
index 45e7e89928a5..bf5ebf59c2d4 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json
@@ -70,6 +70,123 @@
         "teardown": []
     },
     {
+        "id": "d4cd",
+        "name": "Add skbedit action with valid mark and mask",
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
+        "cmdUnderTest": "$TC actions add action skbedit mark 1/0xaabb",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action skbedit",
+        "matchPattern": "action order [0-9]*: skbedit  mark 1/0xaabb",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action skbedit"
+        ]
+    },
+    {
+        "id": "baa7",
+        "name": "Add skbedit action with valid mark and 32-bit maximum mask",
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
+        "cmdUnderTest": "$TC actions add action skbedit mark 1/0xffffffff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action skbedit",
+        "matchPattern": "action order [0-9]*: skbedit  mark 1/0xffffffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action skbedit"
+        ]
+    },
+    {
+        "id": "62a5",
+        "name": "Add skbedit action with valid mark and mask exceeding 32-bit maximum",
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
+        "cmdUnderTest": "$TC actions add action skbedit mark 1/0xaabbccddeeff112233",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action skbedit",
+        "matchPattern": "action order [0-9]*: skbedit  mark 1/0xaabbccddeeff112233",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "bc15",
+        "name": "Add skbedit action with valid mark and mask with invalid format",
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
+        "cmdUnderTest": "$TC actions add action skbedit mark 1/-1234",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action skbedit",
+        "matchPattern": "action order [0-9]*: skbedit  mark 1/-1234",
+        "matchCount": "0",
+        "teardown": []
+    },
+    {
+        "id": "57c2",
+        "name": "Replace skbedit action with new mask",
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
+            ],
+            "$TC actions add action skbedit mark 1/0x11223344 index 1"
+        ],
+        "cmdUnderTest": "$TC actions replace action skbedit mark 1/0xaabb index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action skbedit",
+        "matchPattern": "action order [0-9]*: skbedit  mark 1/0xaabb",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action skbedit"
+        ]
+    },
+    {
         "id": "081d",
         "name": "Add skbedit action with priority",
         "category": [
-- 
2.7.4

