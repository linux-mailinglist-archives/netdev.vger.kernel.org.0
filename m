Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6539C85427
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 21:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388914AbfHGT5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 15:57:43 -0400
Received: from mail-ot1-f51.google.com ([209.85.210.51]:43895 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388713AbfHGT5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 15:57:42 -0400
Received: by mail-ot1-f51.google.com with SMTP id j11so8811608otp.10
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 12:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VikfknS/bkhly6szckUIdHfqtKi1WQDv/sbkVo/HIW8=;
        b=D9qfV7bz9w2BxnG72uSKoGlIwb5vd0usiBDlv+zCuBMEPURy3VW3o7ADv9ZMBC1CCc
         vxU0yxzf+HKlNETrgRLyjEE/bll9t+9lLmAFQK7W9lhwfyzsUoUhkllK/lAiI+Ls70LU
         2m9TZ6fUdDQarE5wUEU2jV2lj0rJ5htJLTwXOOvrBP8WS3/9vK50Eb3kdfawbJB8gbGU
         yyKaiFdDXKWCyCmokJ3ZGqCRLHGENo3pUc2nnXh6tUj+ikDwfwiyMMLd90XDuDD/BDft
         AERrS0w73Ff4oasNwEYfkFDbiFJ5qfwdxxwQ6YFkwWIWUu4czvibOSeR8YDrY1QnynOO
         KvJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VikfknS/bkhly6szckUIdHfqtKi1WQDv/sbkVo/HIW8=;
        b=l7oba3xmBsvm3Ewx6sycu/A2SqBlSPk2xmnRzZuIIDu+Mrmx7bKaSOZ8u+bluaKo1Y
         woMBEGHQ3Ds+U1Vz1DVgNU9ea3XCZmZ6FhNIkZ9saXIclIyplhb5eLMy6c2pQagnLi9T
         A3k3sp5MPwilyqdgrkS5fuiZefrN1jGlxAXgSVPHxlI5bhrejftEQbaT2FR6rjm68DZs
         Mi7xbgY5CSYgvm0FrnavjS5WVqBLHVtAACwH5CtWnhdRcUw1aSm2mKcnXyIMUapGns3o
         XL5p5Oz438ydWhqIftvp3LMiqoEwR/dJZTTibntDQZ6mZYv5aYfojcV0WY48Potd6BfZ
         0+Hg==
X-Gm-Message-State: APjAAAVZWDa1zTjXXiAuUrvmhmEI+WbHSe1HpzkXeMw0X2GHBYwbYTPh
        maZEk3/PBZblRc4d8i+3Ch2zug==
X-Google-Smtp-Source: APXvYqwYLsMr0sOb5sOg8n4mV8J3i16gulkI4fND1vx+B1HRUugdJd4FpP6l169A2NbU5lU25e5lNA==
X-Received: by 2002:a02:3f1d:: with SMTP id d29mr12362442jaa.116.1565207862098;
        Wed, 07 Aug 2019 12:57:42 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id n7sm68971618ioo.79.2019.08.07.12.57.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 07 Aug 2019 12:57:41 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net 2/2] tc-testing: updated skbedit action tests with batch create/delete
Date:   Wed,  7 Aug 2019 15:57:29 -0400
Message-Id: <1565207849-11442-3-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565207849-11442-1-git-send-email-mrv@mojatatu.com>
References: <1565207849-11442-1-git-send-email-mrv@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update TDC tests with cases varifying ability of TC to install or delete
batches of skbedit actions.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/actions/skbedit.json       | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json b/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json
index bf5ebf59c2d4..9cdd2e31ac2c 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json
@@ -670,5 +670,52 @@
         "teardown": [
             "$TC actions flush action skbedit"
         ]
+    },
+    {
+        "id": "630c",
+        "name": "Add batch of 32 skbedit actions with all parameters and cookie",
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
+        "cmdUnderTest": "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action skbedit queue_mapping 2 priority 10 mark 7/0xaabbccdd ptype host inheritdsfield index \\$i cookie aabbccddeeff112233445566778800a1 \\\"; args=\"\\$args\\$cmd\"; done && $TC actions add \\$args\"",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action skbedit",
+        "matchPattern": "^[ \t]+index [0-9]+ ref",
+        "matchCount": "32",
+        "teardown": [
+            "$TC actions flush action skbedit"
+        ]
+    },
+    {
+        "id": "706d",
+        "name": "Delete batch of 32 skbedit actions with all parameters",
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
+            "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action skbedit queue_mapping 2 priority 10 mark 7/0xaabbccdd ptype host inheritdsfield index \\$i \\\"; args=\\\"\\$args\\$cmd\\\"; done && $TC actions add \\$args\""
+        ],
+        "cmdUnderTest": "bash -c \"for i in \\`seq 1 32\\`; do cmd=\\\"action skbedit index \\$i \\\"; args=\"\\$args\\$cmd\"; done && $TC actions del \\$args\"",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action skbedit",
+        "matchPattern": "^[ \t]+index [0-9]+ ref",
+        "matchCount": "0",
+        "teardown": []
     }
 ]
-- 
2.7.4

