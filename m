Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2ED6767C
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 00:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfGLWWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 18:22:14 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33683 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727245AbfGLWWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 18:22:13 -0400
Received: by mail-io1-f67.google.com with SMTP id z3so23797736iog.0
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 15:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u9AqsqcwVjiGnUltUMHsiFqjDMQznLomqEsk8nrIAks=;
        b=kCTWWsUXnDICQBiRe2C4b7b/1LKOdrJjy1K+WEXgNxx/DcGpfs5h0hI9nZvRtSG8oO
         8QYCFpFp4xIOa4VYTyM+w0eVmmy39ZgmxMBbmV/YQT71c18TfztLBxH/lUloAShSOwnp
         C9bumCVw8311APTivQsgaj5WoQ2bRsLfxo54gRhkqgvBXAvaXP7/pkINjtQivl4IU/p6
         oq2VGNy8FpMTmhlAqZsf4V9aGyR9y0qBdLiEW3HwnkGQPghGRJ5TXfiRKI+F233gexJ8
         XoseLgpwvpGkztVfAzHQvQeQwuPgjYKJUzzNlp88VZaFLc1dB/xl3MjeZjyh4Q7w+jEe
         5oyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=u9AqsqcwVjiGnUltUMHsiFqjDMQznLomqEsk8nrIAks=;
        b=sdBPZ51yNUdBVSogNtSJREDR3jIFz1RIdXit3LiBCtlWmIpDONPp1fxF8bFB9TfZFM
         em8Sb56M6oKGJKF3Jf0uDdp3M6NZdKZ1ZFlSS6B12F+lFDBSx40XeyOIkJzAg4muqgBB
         No4sXCwqCqYnTyILu4GIpIXpnAPsoUXoI5BY3Fmy6eRwtx35yAbE4d6xjnTZEBxv+cSO
         RgMwwpdqNljNWL16vm3e6w2CxYLUsGcPhB9HIf6lQv1/TtjVXaOG0skWs5CvNUX6wZmG
         vmDfCwRmquOjDJEp4NseVPEz/79VdoJhI29PNjZVzc4BrTKJYH/omZnIW/MmPluzkUzQ
         PDxQ==
X-Gm-Message-State: APjAAAVGET7Fo5Zw2HLOdJaknDCHkMNOniL98nqqvApxdG/C4L8nbYwv
        LDA2LKSJyoO0wuo9yKkbeiM=
X-Google-Smtp-Source: APXvYqyP+RyPF35GdIgcSYoNqPLdbX7eJi1P+4a/+nhH43TBQxyXFJwDoUvRUivP7c3iT5iC++cPEQ==
X-Received: by 2002:a5d:9acf:: with SMTP id x15mr12275210ion.190.1562970132947;
        Fri, 12 Jul 2019 15:22:12 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id q22sm8074594ioj.56.2019.07.12.15.22.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 12 Jul 2019 15:22:12 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 2/2] tc-testing: updated skbedit action tests with batch create/delete
Date:   Fri, 12 Jul 2019 18:22:00 -0400
Message-Id: <1562970120-29517-2-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562970120-29517-1-git-send-email-mrv@mojatatu.com>
References: <1562970120-29517-1-git-send-email-mrv@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../tc-testing/tc-tests/actions/skbedit.json       | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json b/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json
index 45e7e89928a5..797477c1208f 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/skbedit.json
@@ -553,5 +553,52 @@
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

