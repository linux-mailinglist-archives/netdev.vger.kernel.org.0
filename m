Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 154EC6C079
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 19:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388236AbfGQRgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 13:36:46 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36188 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfGQRgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 13:36:45 -0400
Received: by mail-io1-f66.google.com with SMTP id o9so47120213iom.3
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 10:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VikfknS/bkhly6szckUIdHfqtKi1WQDv/sbkVo/HIW8=;
        b=OTMSI60b59oL/JaY20L4tULmSdXRuNKnnNKBpiOj1BbzwvQIjvSQdrStRSJectVjqZ
         XF7hs7kPaV8hRGyr/9rWEeD6wwXeplb0QH8hFZFYeCHlJ2bc4vpq1ihdYRMjdi4YDfN1
         1QETO8wwF6yEis7GyFyLhPXcO1VtfDoz0wbdKVTuhS+yzifahCjZnKz/SAJQKMzmixXG
         oESws4lls2P6Rq4VObMACnY6K95d/VACXqhqVijDTc/FOTJSYPAnNaThbzU9qThrSZFh
         71B+kVfq0b0LMq+O9jHPmrnU+xR23hnfzZn8aeiklQIAjyKn4U5er/4Ss2b1rGctnpKt
         AM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VikfknS/bkhly6szckUIdHfqtKi1WQDv/sbkVo/HIW8=;
        b=ZDMPmV7NqHhCcKE2ZITAs69EMGuH1xlqauuoz3tMkKHc0MtwqvzI8/2RuOx+TMVkgt
         /BIUkA8dOwpaT9qJR3CwZN0mJiJLvnJXvwHqSduxqV27XaoCsEduY3cgno35bQHyMsuo
         T3fiaJOITR7aZYn41ThnymdvD6iLnbbQD0tPPuoyCt8JKyynuNl2k9Yc7nqYX/vIUIJH
         4o/CouHlYKYVHPkb4XjMf9ammcawyN4r37fexZ6eSGjpSW9fZdD//80bE8uIo0ZakqNY
         iASrJzwSJb4qULnI1QpskW5Vw3TVaEpWiGAhX4nQZWYl0/l+ypKeese9RbKKeq9lgQCA
         lg2Q==
X-Gm-Message-State: APjAAAXYHe/o0XPoKRMV5/ernjO58/KDCwvznzYt4e3uaEPd8DrTkNRW
        Qb6X42KL5STnvTLDvKo3rFI=
X-Google-Smtp-Source: APXvYqw/4hmbYvIlQLg8PPbGqs+NyQw88Sf3xoAyzF4RWNMTx5M6zjSjzZUYYncx9drVMxEYjvE4ew==
X-Received: by 2002:a5d:85c3:: with SMTP id e3mr37953614ios.265.1563385004766;
        Wed, 17 Jul 2019 10:36:44 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id 20sm29052967iog.62.2019.07.17.10.36.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 17 Jul 2019 10:36:44 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next v2 2/2] tc-testing: updated skbedit action tests with batch create/delete
Date:   Wed, 17 Jul 2019 13:36:32 -0400
Message-Id: <1563384992-9430-3-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563384992-9430-1-git-send-email-mrv@mojatatu.com>
References: <1563384992-9430-1-git-send-email-mrv@mojatatu.com>
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

