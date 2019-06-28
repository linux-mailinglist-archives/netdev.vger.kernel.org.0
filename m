Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDB15A651
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfF1VcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:32:09 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:37646 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfF1VcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:32:09 -0400
Received: by mail-io1-f47.google.com with SMTP id e5so15528559iok.4
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 14:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=qpHKRnJVkby+FzX+jeNPeFFxALdr/97iyacHZsV7kEA=;
        b=A87oeggPeY0WtxorKGj9YZSAdmu11BTSYj4sJswytpUuudYh8I2Jz6UUmRaJJCLXs8
         /iZapMhLeyQWQWbbB/yGkN2qs5Xrqs2/lOGMfbad0xo7WipkPVrI15cQU33yxdZfGKvz
         onRERyd6HmAvW/IdO7DaTjj/0eLSfbaK8YwDwfz5sPctk1yTgjX2NK6H4Xl1t46FDel4
         GxXQV3oMtCG1IfPCp2emK39Eg0aCWSrimw32FcR9Kx8m4pxshw58+FsQz91jGJiG0ax1
         zL/RLrRwnhxo1GMIdZhVcpWwz6wt5IHEePuO90BSHYiYk+iB6Au/8PrXuCsSeTlqSoy4
         gHwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qpHKRnJVkby+FzX+jeNPeFFxALdr/97iyacHZsV7kEA=;
        b=qkJXMoRe45Ct6AfJNEQtXDFTCZq9FzjY2X+XqNKSRDpsoD/WC/LPv2Kiq31271rcPq
         Lnva6zvfwfuPBQsiDox+j+ekkcBV0G0azCqb3nNzK6H0XdwyEWaCV7Xy72liVr2mb/vr
         2GUMfAoLNZzeaUeqOy2Q8sa5zTvaNtTf0I+a1n9MoxQbCrvQGQiji052rfPerf5IvvBj
         ekrur45uRYSj+Wqzy5SuHz1cmLDQ0ZBMFQ7tSGN9mnYXyWTczsw8NOK1t+kh0tRlaFag
         l5W4wRXCGTj3HlHNk/jNvVerGl31wtxqeFHVkgry3AxMeBvFxQzqAjiV+B7IOI0qcqKm
         ryRA==
X-Gm-Message-State: APjAAAVMtCw209EiGifOJxRzZP+7G7iWxcQIlozjEQ046hU1IEENjyLU
        ihPzfQgU2mW95RjGhtVHvkogJ2GdwJ0=
X-Google-Smtp-Source: APXvYqwWS91Md7w74PSJFQZz1OR6fMe80+EFxX1Anq79Yeh9JpjCkjFjKe8BIzJoYykixwELYZNl7A==
X-Received: by 2002:a5d:9749:: with SMTP id c9mr13710345ioo.258.1561757527922;
        Fri, 28 Jun 2019 14:32:07 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id r139sm9194242iod.61.2019.06.28.14.32.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 28 Jun 2019 14:32:07 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net-next 1/1] tc-testing: added tdc tests for prio qdisc
Date:   Fri, 28 Jun 2019 17:32:01 -0400
Message-Id: <1561757521-15439-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 .../selftests/tc-testing/tc-tests/qdiscs/prio.json | 276 +++++++++++++++++++++
 1 file changed, 276 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/prio.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/prio.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/prio.json
new file mode 100644
index 000000000000..9c792fa8ca23
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/prio.json
@@ -0,0 +1,276 @@
+[
+    {
+        "id": "ddd9",
+        "name": "Add prio qdisc on egress",
+        "category": [
+            "qdisc",
+            "prio"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc prio 1: root",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 handle 1: root prio",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "aa71",
+        "name": "Add prio qdisc on egress with handle of maximum value",
+        "category": [
+            "qdisc",
+            "prio"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 root handle ffff: prio",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc prio ffff: root",
+        "matchCount": "1",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "db37",
+        "name": "Add prio qdisc on egress with invalid handle exceeding maximum value",
+        "category": [
+            "qdisc",
+            "prio"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 root handle 10000: prio",
+        "expExitCode": "255",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc prio 10000: root",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "39d8",
+        "name": "Add prio qdisc on egress with unsupported argument",
+        "category": [
+            "qdisc",
+            "prio"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio foorbar",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc prio 1: root",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "5769",
+        "name": "Add prio qdisc on egress with 4 bands and new priomap",
+        "category": [
+            "qdisc",
+            "prio"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio bands 4 priomap 1 1 2 2 3 3 0 0 1 2 3 0 0 0 0 0",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc prio 1: root.*bands 4 priomap.*1 1 2 2 3 3 0 0 1 2 3 0 0 0 0 0",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 handle 1: root prio",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "fe0f",
+        "name": "Add prio qdisc on egress with 4 bands and priomap exceeding TC_PRIO_MAX entries",
+        "category": [
+            "qdisc",
+            "prio"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio bands 4 priomap 1 1 2 2 3 3 0 0 1 2 3 0 0 0 0 0 1 1",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc prio 1: root.*bands 4 priomap.*1 1 2 2 3 3 0 0 1 2 3 0 0 0 0 0 1 1",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "1f91",
+        "name": "Add prio qdisc on egress with 4 bands and priomap's values exceeding bands number",
+        "category": [
+            "qdisc",
+            "prio"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio bands 4 priomap 1 1 2 2 7 5 0 0 1 2 3 0 0 0 0 0",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc prio 1: root.*bands 4 priomap.*1 1 2 2 7 5 0 0 1 2 3 0 0 0 0 0",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "d248",
+        "name": "Add prio qdisc on egress with invalid bands value (< 2)",
+        "category": [
+            "qdisc",
+            "prio"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio bands 1 priomap 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc prio 1: root.*bands 1 priomap.*0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "1d0e",
+        "name": "Add prio qdisc on egress with invalid bands value exceeding TCQ_PRIO_BANDS",
+        "category": [
+            "qdisc",
+            "prio"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio bands 1024 priomap 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc prio 1: root.*bands 1024 priomap.*1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "1971",
+        "name": "Replace default prio qdisc on egress with 8 bands and new priomap",
+        "category": [
+            "qdisc",
+            "prio"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 handle 1: root prio"
+        ],
+        "cmdUnderTest": "$TC qdisc replace dev $DEV1 handle 1: root prio bands 8 priomap 1 1 2 2 3 3 4 4 5 5 6 6 7 7 0 0",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc prio 1: root.*bands 8 priomap.*1 1 2 2 3 3 4 4 5 5 6 6 7 7 0 0",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 handle 1: root prio",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "d88a",
+        "name": "Add duplicate prio qdisc on egress",
+        "category": [
+            "qdisc",
+            "prio"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 handle 1: root prio"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc prio 1: root",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 handle 1: root prio",
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "5948",
+        "name": "Delete nonexistent prio qdisc",
+        "category": [
+            "qdisc",
+            "prio"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $DEV1 root handle 1: prio",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc prio 1: root",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "6c0a",
+        "name": "Add prio qdisc on egress with invalid format for handles",
+        "category": [
+            "qdisc",
+            "prio"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DEV1 root handle 123^ prio",
+        "expExitCode": "255",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc prio 123 root",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    },
+    {
+        "id": "0175",
+        "name": "Delete prio qdisc twice",
+        "category": [
+            "qdisc",
+            "prio"
+        ],
+        "setup": [
+            "$IP link add dev $DEV1 type dummy || /bin/true",
+            "$TC qdisc add dev $DEV1 root handle 1: prio",
+            "$TC qdisc del dev $DEV1 root handle 1: prio"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $DEV1 handle 1: root prio",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "matchPattern": "qdisc ingress ffff:",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DEV1 type dummy"
+        ]
+    }
+]
-- 
2.7.4

