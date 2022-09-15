Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DD95B9462
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 08:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiIOG3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 02:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiIOG3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 02:29:10 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0DE8C03C;
        Wed, 14 Sep 2022 23:28:57 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MSnGp3f8qzNmCb;
        Thu, 15 Sep 2022 14:24:18 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 15 Sep
 2022 14:28:54 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <shuah@kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v3 4/9] selftests/tc-testings: add selftests for cgroup filter
Date:   Thu, 15 Sep 2022 14:30:33 +0800
Message-ID: <20220915063038.20010-5-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220915063038.20010-1-shaozhengchao@huawei.com>
References: <20220915063038.20010-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test 6273: Add cgroup filter with cmp ematch u8/link layer and drop action
Test 4721: Add cgroup filter with cmp ematch u8/link layer with trans
flag and pass action
Test d392: Add cgroup filter with cmp ematch u16/link layer and pipe action
Test 0234: Add cgroup filter with cmp ematch u32/link layer and miltiple
actions
Test 8499: Add cgroup filter with cmp ematch u8/network layer and pass
action
Test b273: Add cgroup filter with cmp ematch u8/network layer with trans
flag and drop action
Test 1934: Add cgroup filter with cmp ematch u16/network layer and pipe
action
Test 2733: Add cgroup filter with cmp ematch u32/network layer and
miltiple actions
Test 3271: Add cgroup filter with NOT cmp ematch rule and pass action
Test 2362: Add cgroup filter with two ANDed cmp ematch rules and single
action
Test 9993: Add cgroup filter with two ORed cmp ematch rules and single
action
Test 2331: Add cgroup filter with two ANDed cmp ematch rules and one ORed
ematch rule and single action
Test 3645: Add cgroup filter with two ANDed cmp ematch rules and one NOT
ORed ematch rule and single action
Test b124: Add cgroup filter with u32 ematch u8/zero offset and drop
action
Test 7381: Add cgroup filter with u32 ematch u8/zero offset and invalid
value >0xFF
Test 2231: Add cgroup filter with u32 ematch u8/positive offset and drop
action
Test 1882: Add cgroup filter with u32 ematch u8/invalid mask >0xFF
Test 1237: Add cgroup filter with u32 ematch u8/missing offset
Test 3812: Add cgroup filter with u32 ematch u8/missing AT keyword
Test 1112: Add cgroup filter with u32 ematch u8/missing value
Test 3241: Add cgroup filter with u32 ematch u8/non-numeric value
Test e231: Add cgroup filter with u32 ematch u8/non-numeric mask
Test 4652: Add cgroup filter with u32 ematch u8/negative offset and pass
Test 1331: Add cgroup filter with u32 ematch u16/zero offset and pipe
action
Test e354: Add cgroup filter with u32 ematch u16/zero offset and invalid
value >0xFFFF
Test 3538: Add cgroup filter with u32 ematch u16/positive offset and drop
action
Test 4576: Add cgroup filter with u32 ematch u16/invalid mask >0xFFFF
Test b842: Add cgroup filter with u32 ematch u16/missing offset
Test c924: Add cgroup filter with u32 ematch u16/missing AT keyword
Test cc93: Add cgroup filter with u32 ematch u16/missing value
Test 123c: Add cgroup filter with u32 ematch u16/non-numeric value
Test 3675: Add cgroup filter with u32 ematch u16/non-numeric mask
Test 1123: Add cgroup filter with u32 ematch u16/negative offset and drop
action
Test 4234: Add cgroup filter with u32 ematch u16/nexthdr+ offset and pass
action
Test e912: Add cgroup filter with u32 ematch u32/zero offset and pipe
action
Test 1435: Add cgroup filter with u32 ematch u32/positive offset and drop
action
Test 1282: Add cgroup filter with u32 ematch u32/missing offset
Test 6456: Add cgroup filter with u32 ematch u32/missing AT keyword
Test 4231: Add cgroup filter with u32 ematch u32/missing value
Test 2131: Add cgroup filter with u32 ematch u32/non-numeric value
Test f125: Add cgroup filter with u32 ematch u32/non-numeric mask
Test 4316: Add cgroup filter with u32 ematch u32/negative offset and drop
action
Test 23ae: Add cgroup filter with u32 ematch u32/nexthdr+ offset and pipe
action
Test 23a1: Add cgroup filter with canid ematch and single SFF
Test 324f: Add cgroup filter with canid ematch and single SFF with mask
Test 2576: Add cgroup filter with canid ematch and multiple SFF
Test 4839: Add cgroup filter with canid ematch and multiple SFF with masks
Test 6713: Add cgroup filter with canid ematch and single EFF
Test ab9d: Add cgroup filter with canid ematch and multiple EFF with masks
Test 5349: Add cgroup filter with canid ematch and a combination of
SFF/EFF
Test c934: Add cgroup filter with canid ematch and a combination of
SFF/EFF with masks
Test 4319: Replace cgroup filter with diffferent match
Test 4636: Delete cgroup filter

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 .../tc-testing/tc-tests/filters/cgroup.json   | 1236 +++++++++++++++++
 1 file changed, 1236 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/cgroup.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/cgroup.json b/tools/testing/selftests/tc-testing/tc-tests/filters/cgroup.json
new file mode 100644
index 000000000000..756bfbe9d7b5
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/cgroup.json
@@ -0,0 +1,1236 @@
+[
+    {
+        "id": "6273",
+        "name": "Add cgroup filter with cmp ematch u8/link layer and drop action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'cmp(u8 at 0 layer link mask 0xff gt 10)' action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref [0-9]+ cgroup chain [0-9]+.*handle 0x1.*cmp\\(u8 at 0 layer 0 mask 0xff gt 10\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4721",
+        "name": "Add cgroup filter with cmp ematch u8/link layer with trans flag and pass action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'cmp(u8 at 0 layer link mask 0xff trans gt 10)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref [0-9]+ cgroup chain [0-9]+.*handle 0x1.*cmp\\(u8 at 0 layer 0 mask 0xff trans gt 10\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "d392",
+        "name": "Add cgroup filter with cmp ematch u16/link layer and pipe action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'cmp(u16 at 0 layer 0 mask 0xff00 lt 3)' action pipe",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref [0-9]+ cgroup chain [0-9]+.*handle 0x1.*cmp\\(u16 at 0 layer 0 mask 0xff00 lt 3\\).*action pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "0234",
+        "name": "Add cgroup filter with cmp ematch u32/link layer and miltiple actions",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'cmp(u32 at 4 layer link mask 0xff00ff00 eq 3)' action skbedit mark 7 pipe action gact drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref [0-9]+ cgroup chain [0-9]+.*handle 0x1.*cmp\\(u32 at 4 layer 0 mask 0xff00ff00 eq 3\\).*action.*skbedit.*mark 7 pipe.*action.*gact action drop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "8499",
+        "name": "Add cgroup filter with cmp ematch u8/network layer and pass action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0xab protocol ip prio 11 cgroup match 'cmp(u8 at 0 layer 1 mask 0xff gt 10)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show  dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 11 cgroup.*handle 0xab.*cmp\\(u8 at 0 layer 1 mask 0xff gt 10\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "b273",
+        "name": "Add cgroup filter with cmp ematch u8/network layer with trans flag and drop action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0xab protocol ip prio 11 cgroup match 'cmp(u8 at 0 layer 1 mask 0xff trans gt 10)' action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 11 cgroup.*handle 0xab.*cmp\\(u8 at 0 layer 1 mask 0xff trans gt 10\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "1934",
+        "name": "Add cgroup filter with cmp ematch u16/network layer and pipe action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x100 protocol ip prio 100 cgroup match 'cmp(u16 at 0 layer network mask 0xff00 lt 3)' action pipe",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "filter protocol ip pref 100 cgroup.*handle 0x100..*cmp\\(u16 at 0 layer 1 mask 0xff00 lt 3\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2733",
+        "name": "Add cgroup filter with cmp ematch u32/network layer and miltiple actions",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x112233 protocol ip prio 7 cgroup match 'cmp(u32 at 4 layer network mask 0xff00ff00 eq 3)' action skbedit mark 7 pipe action gact drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 7 cgroup.*handle 0x112233.*cmp\\(u32 at 4 layer 1 mask 0xff00ff00 eq 3\\).*action.*skbedit.*mark 7 pipe.*action.*gact action drop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "3271",
+        "name": "Add cgroup filter with NOT cmp ematch rule and pass action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'not cmp(u8 at 0 layer link mask 0xff eq 3)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*NOT cmp\\(u8 at 0 layer 0 mask 0xff eq 3\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2362",
+        "name": "Add cgroup filter with two ANDed cmp ematch rules and single action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'cmp(u8 at 0 layer link mask 0xff eq 3) and cmp(u16 at 8 layer link mask 0x00ff gt 7)' action gact drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*cmp\\(u8 at 0 layer 0 mask 0xff eq 3\\).*AND cmp\\(u16 at 8 layer 0 mask 0xff gt 7\\).*action.*gact action drop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "9993",
+        "name": "Add cgroup filter with two ORed cmp ematch rules and single action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'cmp(u8 at 0 layer link mask 0xff eq 3) or cmp(u16 at 8 layer link mask 0x00ff gt 7)' action gact drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*cmp\\(u8 at 0 layer 0 mask 0xff eq 3\\).*OR cmp\\(u16 at 8 layer 0 mask 0xff gt 7\\).*action.*gact action drop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2331",
+        "name": "Add cgroup filter with two ANDed cmp ematch rules and one ORed ematch rule and single action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'cmp(u8 at 0 layer link mask 0xff eq 3) and cmp(u16 at 8 layer link mask 0x00ff gt 7) or cmp(u32 at 4 layer network mask 0xa0a0 lt 3)' action gact drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*cmp\\(u8 at 0 layer 0 mask 0xff eq 3\\).*AND cmp\\(u16 at 8 layer 0 mask 0xff gt 7\\).*OR cmp\\(u32 at 4 layer 1 mask 0xa0a0 lt 3\\).*action.*gact action drop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "3645",
+        "name": "Add cgroup filter with two ANDed cmp ematch rules and one NOT ORed ematch rule and single action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'cmp(u8 at 0 layer link mask 0xff eq 3) and cmp(u16 at 8 layer link mask 0x00ff gt 7) or not cmp(u32 at 4 layer network mask 0xa0a0 lt 3)' action gact drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*cmp\\(u8 at 0 layer 0 mask 0xff eq 3\\).*AND cmp\\(u16 at 8 layer 0 mask 0xff gt 7\\).*OR NOT cmp\\(u32 at 4 layer 1 mask 0xa0a0 lt 3\\).*action.*gact action drop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "b124",
+        "name": "Add cgroup filter with u32 ematch u8/zero offset and drop action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u8 0x11 0x0f at 0)' action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(01000000/0f000000 at 0\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "7381",
+        "name": "Add cgroup filter with u32 ematch u8/zero offset and invalid value >0xFF",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'u32(u8 0x1122 0x0f at 0)' action pass",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(11220000/0f000000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2231",
+        "name": "Add cgroup filter with u32 ematch u8/positive offset and drop action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u8 0x77 0x1f at 12)' action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(17000000/1f000000 at 12\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "1882",
+        "name": "Add cgroup filter with u32 ematch u8/invalid mask >0xFF",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u8 0x77 0xff00 at 12)' action drop",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(77000000/ff000000 at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "1237",
+        "name": "Add cgroup filter with u32 ematch u8/missing offset",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u8 0x77 0xff at)' action pipe",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(77000000 at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "3812",
+        "name": "Add cgroup filter with u32 ematch u8/missing AT keyword",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u8 0x77 0xff 0)' action pass",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(77000000 at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "1112",
+        "name": "Add cgroup filter with u32 ematch u8/missing value",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u8 at 12)' action drop",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "3241",
+        "name": "Add cgroup filter with u32 ematch u8/non-numeric value",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u8 zero 0xff at 0)' action pipe",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1 flowid 1:1.*u32\\(00000000/ff000000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "e231",
+        "name": "Add cgroup filter with u32 ematch u8/non-numeric mask",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u8 0x11 mask at 0)' action pass",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(11000000/00000000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4652",
+        "name": "Add cgroup filter with u32 ematch u8/negative offset and pass action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+	    "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u8 0xaa 0xf0 at -14)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(0000a000/0000f000 at -16\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "7566",
+        "name": "Add cgroup filter with u32 ematch u8/nexthdr+ offset and drop action",
+        "category": [
+            "filter",
+            "drop"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u8 0xaa 0xf0 at nexthdr+0)' action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(a0000000/f0000000 at nexthdr\\+0\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "1331",
+        "name": "Add cgroup filter with u32 ematch u16/zero offset and pipe action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u16 0x1122 0xffff at 0)' action pipe",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(11220000/ffff0000 at 0\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "e354",
+        "name": "Add cgroup filter with u32 ematch u16/zero offset and invalid value >0xFFFF",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u16 0x112233 0xffff at 0)'",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(11223300/ffff0000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "3538",
+        "name": "Add cgroup filter with u32 ematch u16/positive offset and drop action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u16 0x7788 0x1fff at 12)' action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(17880000/1fff0000 at 12\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4576",
+        "name": "Add cgroup filter with u32 ematch u16/invalid mask >0xFFFF",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u16 0x7788 0xffffffff at 12)' action pass",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(77880000/ffffffff at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "b842",
+        "name": "Add cgroup filter with u32 ematch u16/missing offset",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u16 0x7788 0xffff at)' action pass",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(77880000 at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "c924",
+        "name": "Add cgroup filter with u32 ematch u16/missing AT keyword",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u16 0x7788 0xffff 0)' action pass",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(77880000/ffff0000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "cc93",
+        "name": "Add cgroup filter with u32 ematch u16/missing value",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u16 at 12)' action pass",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "123c",
+        "name": "Add cgroup filter with u32 ematch u16/non-numeric value",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u16 zero 0xffff at 0)' action pass",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(00000000/ffff0000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "3675",
+        "name": "Add cgroup filter with u32 ematch u16/non-numeric mask",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u8 0x1122 mask at 0)' action pass",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(11220000/00000000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "1123",
+	"name": "Add cgroup filter with u32 ematch u16/negative offset and drop action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u16 0xaabb 0xffff at -12)' action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(aabb0000/ffff0000 at -12\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4234",
+        "name": "Add cgroup filter with u32 ematch u16/nexthdr+ offset and pass action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u16 0xaabb 0xf0f0 at nexthdr+0)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(a0b00000/f0f00000 at nexthdr\\+0\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "e912",
+        "name": "Add cgroup filter with u32 ematch u32/zero offset and pipe action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u32 0xaabbccdd 0xffffffff at 0)' action pipe",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(aabbccdd/ffffffff at 0\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "1435",
+        "name": "Add cgroup filter with u32 ematch u32/positive offset and drop action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+	    "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u32 0x11227788 0x1ffff0f0 at 12)' action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(11227080/1ffff0f0 at 12\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "1282",
+        "name": "Add cgroup filter with u32 ematch u32/missing offset",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u32 0x11227788 0xffffffff at)' action pass",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(11227788/ffffffff at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "6456",
+        "name": "Add cgroup filter with u32 ematch u32/missing AT keyword",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u32 0x77889900 0xfffff0f0 0)' action pipe",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(77889900/fffff0f0 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4231",
+        "name": "Add cgroup filter with u32 ematch u32/missing value",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u32 at 12)' action pipe",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(at 12\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2131",
+        "name": "Add cgroup filter with u32 ematch u32/non-numeric value",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u32 zero 0xffff at 0)' action pipe",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(00000000/ffff0000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "f125",
+        "name": "Add cgroup filter with u32 ematch u32/non-numeric mask",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u32 0x11223344 mask at 0)' action pass",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(11223344/00000000 at 0\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4316",
+        "name": "Add cgroup filter with u32 ematch u32/negative offset and drop action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u32 0xaabbccdd 0xff00ff00 at -12)' action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(aa00cc00/ff00ff00 at -12\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "23ae",
+        "name": "Add cgroup filter with u32 ematch u32/nexthdr+ offset and pipe action",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'u32(u32 0xaabbccdd 0xffffffff at nexthdr+0)' action pipe",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*u32\\(aabbccdd/ffffffff at nexthdr\\+0\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "23a1",
+        "name": "Add cgroup filter with canid ematch and single SFF",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'canid(sff 1)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*canid\\(sff 0x1\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "324f",
+        "name": "Add cgroup filter with canid ematch and single SFF with mask",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'canid(sff 0xaabb:0x00ff)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*canid\\(sff 0x2BB:0xFF\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2576",
+        "name": "Add cgroup filter with canid ematch and multiple SFF",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'canid(sff 1 sff 2 sff 3)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*canid\\(sff 0x1 sff 0x2 sff 0x3\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4839",
+        "name": "Add cgroup filter with canid ematch and multiple SFF with masks",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'canid(sff 0xaa:0x01 sff 0xbb:0x02 sff 0xcc:0x03)' action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*canid\\(sff 0xAA:0x1 sff 0xBB:0x2 sff 0xCC:0x3\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "6713",
+        "name": "Add cgroup filter with canid ematch and single EFF",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'canid(eff 1)' action pipe",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*canid\\(eff 0x1\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4572",
+        "name": "Add cgroup filter with canid ematch and single EFF with mask",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'canid(eff 0xaabb:0xf1f1)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*canid\\(eff 0xAABB:0xF1F1\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "8031",
+        "name": "Add cgroup filter with canid ematch and multiple EFF",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'canid(eff 1 eff 2 eff 3)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*canid\\(eff 0x1 eff 0x2 eff 0x3\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "ab9d",
+        "name": "Add cgroup filter with canid ematch and multiple EFF with masks",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'canid(eff 0xaa:0x01 eff 0xbb:0x02 eff 0xcc:0x03)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*canid\\(eff 0xAA:0x1 eff 0xBB:0x2 eff 0xCC:0x3\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "5349",
+        "name": "Add cgroup filter with canid ematch and a combination of SFF/EFF",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'canid(sff 0x01 eff 0x02)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*canid\\(eff 0x2 sff 0x1\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "c934",
+        "name": "Add cgroup filter with canid ematch and a combination of SFF/EFF with masks",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'canid(sff 0x01:0xf eff 0x02:0xf)' action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 cgroup.*handle 0x1.*canid\\(eff 0x2:0xF sff 0x1:0xF\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4319",
+        "name": "Replace cgroup filter with diffferent match",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'cmp(u8 at 0 layer link mask 0xff gt 10)' action pass"
+        ],
+        "cmdUnderTest": "$TC filter replace dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'cmp(u8 at 0 layer link mask 0xff gt 8)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "cmp\\(u8 at 0 layer 0 mask 0xff gt 8\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4636",
+        "name": "Delete cgroup filter",
+        "category": [
+            "filter",
+            "cgroup"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 cgroup match 'cmp(u8 at 0 layer link mask 0xff gt 10)' action pass"
+        ],
+        "cmdUnderTest": "$TC filter delete dev $DEV1 parent ffff: protocol ip prio 1 cgroup match 'cmp(u8 at 0 layer link mask 0xff gt 10)' action pass",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "cmp\\(u8 at 0 layer 0 mask 0xff gt 8\\)",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    }
+]
-- 
2.17.1

