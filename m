Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B6571FD1
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 21:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391657AbfGWTCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 15:02:09 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35369 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391653AbfGWTCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 15:02:09 -0400
Received: by mail-qt1-f195.google.com with SMTP id d23so42976028qto.2
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 12:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=c3fHbXa72v2tfrAHsdP6N9Jat3ka5sIg27aXMNSsU0w=;
        b=Z0n03clHWhSBm4oxYYmtAcjfZceDdzhKgHETU+T+eNPODBEiDdVx6bul8aSixmSmWY
         CjQsnxyBBNXIvwMJao3BwJuDLk+WPUbk+2FX8vQ8nSOSHmVk5uVUePq5mwOG+WgtbX7V
         ApcoGVcjSKjzAsclln54kYiEg55qBY7ZlUqPT3WcUDYZw+RJ/3oj0PdYq3eSIU95KKKn
         9pJqBPEK6HQBW67Mob/uIv01g0YyUHI6hka1b6dKAWthFNQz8daLM/RKHtQPVjTPZ/6V
         njQyntR7u8lKe+UYRPcKNCpW0rIl5CH8CxYQD4mGTWXND/RsnqNCJ6dFB1pWOVP59cQe
         I7EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=c3fHbXa72v2tfrAHsdP6N9Jat3ka5sIg27aXMNSsU0w=;
        b=ZwmFEi5qXNDNY3kWlcHEAJC9amNLJZxrCcUytbh9J8BcWrUjvY3RoKZJrTZw3SYFQM
         oqkhkCtZgTy3hCqSj6bJtHeUZ5Li+foJlkj5dtGF6S6xArVL/Kqb/d7obK2KSNyi1jtk
         RDeKjNgtlwntRWBpb6+8lGAXzFfpWGX1ZdIhU+ScGsk028cFl6+8sTMrwvh+HK4bY7Lt
         lH1O9kkmv8x2LN8xjgwW5PfvqpxfxwxnKMcSWffvwKnkRs1GSyBtdf7Ru1P9Fg3cGUGe
         H8zdJ4YdDHkfcDL+ud52vuwTqklXHsO8z5ymBSxDgPHoObHyIBRFrA5uzMnGX2hOVsYX
         h/hg==
X-Gm-Message-State: APjAAAUdrhGR5MpocowVYOGsCaSLnVaPzAG7U/uw3hK4NMG1+gP+6xXA
        GaGKn6NcSldL8UERcuD9gtc=
X-Google-Smtp-Source: APXvYqxWpOthMNvfXapJNcPeF8a/0EXqO0e8DLAQy6VexT4M73ivOJ4ChetUP3IOo3gqNibhK7tioA==
X-Received: by 2002:ac8:6c31:: with SMTP id k17mr52876292qtu.253.1563908528049;
        Tue, 23 Jul 2019 12:02:08 -0700 (PDT)
Received: from mojatatu.com ([2001:67c:370:128:e4f2:ff5b:fe2a:5c4a])
        by smtp.gmail.com with ESMTPSA id o5sm19396783qkf.10.2019.07.23.12.02.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 23 Jul 2019 12:02:07 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: added tdc tests for [b|p]fifo qdisc
Date:   Tue, 23 Jul 2019 15:01:59 -0400
Message-Id: <1563908519-30111-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../selftests/tc-testing/tc-tests/qdiscs/fifo.json | 304 +++++++++++++++++++++
 1 file changed, 304 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/fifo.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fifo.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fifo.json
new file mode 100644
index 000000000000..9de61fa10878
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fifo.json
@@ -0,0 +1,304 @@
+[
+    {
+        "id": "a519",
+        "name": "Add bfifo qdisc with system default parameters on egress",
+        "__comment": "When omitted, queue size in bfifo is calculated as: txqueuelen * (MTU + LinkLayerHdrSize), where LinkLayerHdrSize=14 for Ethernet",
+        "category": [
+            "qdisc",
+            "fifo"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root bfifo",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc bfifo 1: root.*limit [0-9]+b",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 handle 1: root bfifo",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "585c",
+        "name": "Add pfifo qdisc with system default parameters on egress",
+        "__comment": "When omitted, queue size in pfifo is defaulted to the interface's txqueuelen value.",
+        "category": [
+            "qdisc",
+            "fifo"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root pfifo",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc pfifo 1: root.*limit [0-9]+p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 handle 1: root pfifo",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "a86e",
+        "name": "Add bfifo qdisc with system default parameters on egress with handle of maximum value",
+        "category": [
+            "qdisc",
+            "fifo"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 root handle ffff: bfifo",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc bfifo ffff: root.*limit [0-9]+b",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 handle ffff: root bfifo",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "9ac8",
+        "name": "Add bfifo qdisc on egress with queue size of 3000 bytes",
+        "category": [
+            "qdisc",
+            "fifo"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root bfifo limit 3000b",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc bfifo 1: root.*limit 3000b",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 handle 1: root bfifo",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "f4e6",
+        "name": "Add pfifo qdisc on egress with queue size of 3000 packets",
+        "category": [
+            "qdisc",
+            "fifo"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 txqueuelen 3000 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root pfifo limit 3000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc pfifo 1: root.*limit 3000p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 handle 1: root pfifo",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "b1b1",
+        "name": "Add bfifo qdisc with system default parameters on egress with invalid handle exceeding maximum value",
+        "category": [
+            "qdisc",
+            "fifo"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 root handle 10000: bfifo",
+        "expExitCode": "255",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc bfifo 10000: root.*limit [0-9]+b",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "8d5e",
+        "name": "Add bfifo qdisc on egress with unsupported argument",
+        "category": [
+            "qdisc",
+            "fifo"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root bfifo foorbar",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc bfifo 1: root",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "7787",
+        "name": "Add pfifo qdisc on egress with unsupported argument",
+        "category": [
+            "qdisc",
+            "fifo"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root pfifo foorbar",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc pfifo 1: root",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "c4b6",
+        "name": "Replace bfifo qdisc on egress with new queue size",
+        "category": [
+            "qdisc",
+            "fifo"
+        ],
+        "setup": [
+            "$IP link del dev $DEV1 type dummy || /bin/true",
+            "$IP link add dev $DEV1 txqueuelen 1000 type dummy",
+            "$TC qdisc add dev $DEV1 handle 1: root bfifo"
+        ],
+        "cmdUnderTest": "$TC qdisc replace dev $DEV1 handle 1: root bfifo limit 3000b",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc bfifo 1: root.*limit 3000b",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 handle 1: root bfifo",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "3df6",
+        "name": "Replace pfifo qdisc on egress with new queue size",
+        "category": [
+            "qdisc",
+            "fifo"
+        ],
+        "setup": [
+            "$IP link del dev $DEV1 type dummy || /bin/true",
+            "$IP link add dev $DEV1 txqueuelen 1000 type dummy",
+            "$TC qdisc add dev $DEV1 handle 1: root pfifo"
+        ],
+        "cmdUnderTest": "$TC qdisc replace dev $DEV1 handle 1: root pfifo limit 30",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc pfifo 1: root.*limit 30p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 handle 1: root pfifo",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "7a67",
+        "name": "Add bfifo qdisc on egress with queue size in invalid format",
+        "category": [
+            "qdisc",
+            "fifo"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root bfifo limit foo-bar",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc bfifo 1: root.*limit foo-bar",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "1298",
+        "name": "Add duplicate bfifo qdisc on egress",
+        "category": [
+            "qdisc",
+            "fifo"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 handle 1: root bfifo"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root bfifo",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc bfifo 1: root",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 handle 1: root bfifo",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "45a0",
+        "name": "Delete nonexistent bfifo qdisc",
+        "category": [
+            "qdisc",
+            "fifo"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $DEV1 root handle 1: bfifo",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc bfifo 1: root",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "972b",
+        "name": "Add prio qdisc on egress with invalid format for handles",
+        "category": [
+            "qdisc",
+            "fifo"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 root handle 123^ bfifo limit 100b",
+        "expExitCode": "255",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc bfifo 123 root",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "4d39",
+        "name": "Delete bfifo qdisc twice",
+        "category": [
+            "qdisc",
+            "fifo"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 root handle 1: bfifo",
+            "$TC qdisc del dev $DEV1 root handle 1: bfifo"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $DEV1 handle 1: root bfifo",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc bfifo 1: root",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    }
+]
-- 
2.7.4

