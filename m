Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A4B5B2B92
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 03:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiIIB1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 21:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIIB1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 21:27:39 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FC61177A3;
        Thu,  8 Sep 2022 18:27:36 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MNytm2sHfz14QXZ;
        Fri,  9 Sep 2022 09:23:44 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 9 Sep
 2022 09:27:34 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next 0/8] add tc-testing test cases
Date:   Fri, 9 Sep 2022 09:29:28 +0800
Message-ID: <20220909012936.268433-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

For this patchset, test cases of the ctinfo, gate, and xt action modules
are added to the tc-testing test suite. Also add deleting test for
connmark, ife, nat, sample and tunnel_key action modules.

After a test case is added locally, the test result is as follows:

./tdc.py -c action ctinfo
considering category action
considering category ctinfo
Test c826: Add ctinfo action with default setting
Test 0286: Add ctinfo action with dscp
Test 4938: Add ctinfo action with valid cpmark and zone
Test 7593: Add ctinfo action with drop control
Test 2961: Replace ctinfo action zone and action control
Test e567: Delete ctinfo action with valid index
Test 6a91: Delete ctinfo action with invalid index
Test 5232: List ctinfo actions
Test 7702: Flush ctinfo actions
Test 3201: Add ctinfo action with duplicate index
Test 8295: Add ctinfo action with invalid index
Test 3964: Replace ctinfo action with invalid goto_chain control

All test results:

1..12
ok 1 c826 - Add ctinfo action with default setting
ok 2 0286 - Add ctinfo action with dscp
ok 3 4938 - Add ctinfo action with valid cpmark and zone
ok 4 7593 - Add ctinfo action with drop control
ok 5 2961 - Replace ctinfo action zone and action control
ok 6 e567 - Delete ctinfo action with valid index
ok 7 6a91 - Delete ctinfo action with invalid index
ok 8 5232 - List ctinfo actions
ok 9 7702 - Flush ctinfo actions
ok 10 3201 - Add ctinfo action with duplicate index
ok 11 8295 - Add ctinfo action with invalid index
ok 12 3964 - Replace ctinfo action with invalid goto_chain control

./tdc.py -c action gate
considering category gate
considering category action
Test 5153: Add gate action with priority and sched-entry
Test 7189: Add gate action with base-time
Test a721: Add gate action with cycle-time
Test c029: Add gate action with cycle-time-ext
Test 3719: Replace gate base-time action
Test d821: Delete gate action with valid index
Test 3128: Delete gate action with invalid index
Test 7837: List gate actions
Test 9273: Flush gate actions
Test c829: Add gate action with duplicate index
Test 3043: Add gate action with invalid index
Test 2930: Add gate action with cookie

All test results:

1..12
ok 1 5153 - Add gate action with priority and sched-entry
ok 2 7189 - Add gate action with base-time
ok 3 a721 - Add gate action with cycle-time
ok 4 c029 - Add gate action with cycle-time-ext
ok 5 3719 - Replace gate base-time action
ok 6 d821 - Delete gate action with valid index
ok 7 3128 - Delete gate action with invalid index
ok 8 7837 - List gate actions
ok 9 9273 - Flush gate actions
ok 10 c829 - Add gate action with duplicate index
ok 11 3043 - Add gate action with invalid index
ok 12 2930 - Add gate action with cookie

./tdc.py -c action xt
considering category xt
considering category action
Test 2029: Add xt action with log-prefix
Test 3562: Replace xt action log-prefix
Test 8291: Delete xt action with valid index
Test 5169: Delete xt action with invalid index
Test 7284: List xt actions
Test 5010: Flush xt actions
Test 8437: Add xt action with duplicate index
Test 2837: Add xt action with invalid index

All test results:

1..8
ok 1 2029 - Add xt action with log-prefix
ok 2 3562 - Replace xt action log-prefix
ok 3 8291 - Delete xt action with valid index
ok 4 5169 - Delete xt action with invalid index
ok 5 7284 - List xt actions
ok 6 5010 - Flush xt actions
ok 7 8437 - Add xt action with duplicate index
ok 8 2837 - Add xt action with invalid index

./tdc.py -c action connmark
considering category action
considering category connmark
Test 2002: Add valid connmark action with defaults
Test 56a5: Add valid connmark action with control pass
Test 7c66: Add valid connmark action with control drop
Test a913: Add valid connmark action with control pipe
Test bdd8: Add valid connmark action with control reclassify
Test b8be: Add valid connmark action with control continue
Test d8a6: Add valid connmark action with control jump
Test aae8: Add valid connmark action with zone argument
Test 2f0b: Add valid connmark action with invalid zone argument
Test 9305: Add connmark action with unsupported argument
Test 71ca: Add valid connmark action and replace it
Test 5f8f: Add valid connmark action with cookie
Test c506: Replace connmark with invalid goto chain control
Test 6571: Delete connmark action with valid index
Test 3426: Delete connmark action with invalid index

All test results:

1..15
ok 1 2002 - Add valid connmark action with defaults
ok 2 56a5 - Add valid connmark action with control pass
ok 3 7c66 - Add valid connmark action with control drop
ok 4 a913 - Add valid connmark action with control pipe
ok 5 bdd8 - Add valid connmark action with control reclassify
ok 6 b8be - Add valid connmark action with control continue
ok 7 d8a6 - Add valid connmark action with control jump
ok 8 aae8 - Add valid connmark action with zone argument
ok 9 2f0b - Add valid connmark action with invalid zone argument
ok 10 9305 - Add connmark action with unsupported argument
ok 11 71ca - Add valid connmark action and replace it
ok 12 5f8f - Add valid connmark action with cookie
ok 13 c506 - Replace connmark with invalid goto chain control
ok 14 6571 - Delete connmark action with valid index
ok 15 3426 - Delete connmark action with invalid index

./tdc.py -c action ife
considering category action
considering category ife
Test 7682: Create valid ife encode action with mark and pass control
Test ef47: Create valid ife encode action with mark and pipe control
Test df43: Create valid ife encode action with mark and continue control
Test e4cf: Create valid ife encode action with mark and drop control
Test ccba: Create valid ife encode action with mark and reclassify control
Test a1cf: Create valid ife encode action with mark and jump control
Test cb3d: Create valid ife encode action with mark value at 32-bit
maximum
Test 1efb: Create ife encode action with mark value exceeding 32-bit
maximum
Test 95ed: Create valid ife encode action with prio and pass control
Test aa17: Create valid ife encode action with prio and pipe control
Test 74c7: Create valid ife encode action with prio and continue control
Test 7a97: Create valid ife encode action with prio and drop control
Test f66b: Create valid ife encode action with prio and reclassify control
Test 3056: Create valid ife encode action with prio and jump control
Test 7dd3: Create valid ife encode action with prio value at 32-bit
maximum
Test 2ca1: Create ife encode action with prio value exceeding 32-bit
maximum
Test 05bb: Create valid ife encode action with tcindex and pass control
Test ce65: Create valid ife encode action with tcindex and pipe control
Test 09cd: Create valid ife encode action with tcindex and continue control
Test 8eb5: Create valid ife encode action with tcindex and continue control
Test 451a: Create valid ife encode action with tcindex and drop control
Test d76c: Create valid ife encode action with tcindex and reclassify
control
Test e731: Create valid ife encode action with tcindex and jump control
Test b7b8: Create valid ife encode action with tcindex value at 16-bit
maximum
Test d0d8: Create ife encode action with tcindex value exceeding 16-bit
maximum
Test 2a9c: Create valid ife encode action with mac src parameter
Test cf5c: Create valid ife encode action with mac dst parameter
Test 2353: Create valid ife encode action with mac src and mac dst
parameters
Test 552c: Create valid ife encode action with mark and type parameters
Test 0421: Create valid ife encode action with prio and type parameters
Test 4017: Create valid ife encode action with tcindex and type parameters
Test fac3: Create valid ife encode action with index at 32-bit maximum
Test 7c25: Create valid ife decode action with pass control
Test dccb: Create valid ife decode action with pipe control
Test 7bb9: Create valid ife decode action with continue control
Test d9ad: Create valid ife decode action with drop control
Test 219f: Create valid ife decode action with reclassify control
Test 8f44: Create valid ife decode action with jump control
Test 56cf: Create ife encode action with index exceeding 32-bit maximum
Test ee94: Create ife encode action with invalid control
Test b330: Create ife encode action with cookie
Test bbc0: Create ife encode action with invalid argument
Test d54a: Create ife encode action with invalid type argument
Test 7ee0: Create ife encode action with invalid mac src argument
Test 0a7d: Create ife encode action with invalid mac dst argument
Test a0e2: Replace ife encode action with invalid goto chain control
Test a972: Delete ife encode action with valid index
Test 1272: Delete ife encode action with invalid index

All test results:

1..48
ok 1 7682 - Create valid ife encode action with mark and pass control
ok 2 ef47 - Create valid ife encode action with mark and pipe control
ok 3 df43 - Create valid ife encode action with mark and continue control
ok 4 e4cf - Create valid ife encode action with mark and drop control
ok 5 ccba - Create valid ife encode action with mark and reclassify
control
ok 6 a1cf - Create valid ife encode action with mark and jump control
ok 7 cb3d - Create valid ife encode action with mark value at 32-bit
maximum
ok 8 1efb - Create ife encode action with mark value exceeding 32-bit
maximum
ok 9 95ed - Create valid ife encode action with prio and pass control
ok 10 aa17 - Create valid ife encode action with prio and pipe control
ok 11 74c7 - Create valid ife encode action with prio and continue control
ok 12 7a97 - Create valid ife encode action with prio and drop control
ok 13 f66b - Create valid ife encode action with prio and reclassify
control
ok 14 3056 - Create valid ife encode action with prio and jump control
ok 15 7dd3 - Create valid ife encode action with prio value at 32-bit
maximum
ok 16 2ca1 - Create ife encode action with prio value exceeding 32-bit
maximum
ok 17 05bb - Create valid ife encode action with tcindex and pass control
ok 18 ce65 - Create valid ife encode action with tcindex and pipe control
ok 19 09cd - Create valid ife encode action with tcindex and continue
control
ok 20 8eb5 - Create valid ife encode action with tcindex and continue
control
ok 21 451a - Create valid ife encode action with tcindex and drop control
ok 22 d76c - Create valid ife encode action with tcindex and reclassify
control
ok 23 e731 - Create valid ife encode action with tcindex and jump control
ok 24 b7b8 - Create valid ife encode action with tcindex value at 16-bit
maximum
ok 25 d0d8 - Create ife encode action with tcindex value exceeding 16-bit
maximum
ok 26 2a9c - Create valid ife encode action with mac src parameter
ok 27 cf5c - Create valid ife encode action with mac dst parameter
ok 28 2353 - Create valid ife encode action with mac src and mac dst
parameters
ok 29 552c - Create valid ife encode action with mark and type parameters
ok 30 0421 - Create valid ife encode action with prio and type parameters
ok 31 4017 - Create valid ife encode action with tcindex and type
parameters
ok 32 fac3 - Create valid ife encode action with index at 32-bit maximum
ok 33 7c25 - Create valid ife decode action with pass control
ok 34 dccb - Create valid ife decode action with pipe control
ok 35 7bb9 - Create valid ife decode action with continue control
ok 36 d9ad - Create valid ife decode action with drop control
ok 37 219f - Create valid ife decode action with reclassify control
ok 38 8f44 - Create valid ife decode action with jump control
ok 39 56cf - Create ife encode action with index exceeding 32-bit maximum
ok 40 ee94 - Create ife encode action with invalid control
ok 41 b330 - Create ife encode action with cookie
ok 42 bbc0 - Create ife encode action with invalid argument
ok 43 d54a - Create ife encode action with invalid type argument
ok 44 7ee0 - Create ife encode action with invalid mac src argument
ok 45 0a7d - Create ife encode action with invalid mac dst argument
ok 46 a0e2 - Replace ife encode action with invalid goto chain control
ok 47 a972 - Delete ife encode action with valid index
ok 48 1272 - Delete ife encode action with invalid index

./tdc.py -c action nat
considering category action
considering category nat
Test 7565: Add nat action on ingress with default control action
Test fd79: Add nat action on ingress with pipe control action
Test eab9: Add nat action on ingress with continue control action
Test c53a: Add nat action on ingress with reclassify control action
Test 76c9: Add nat action on ingress with jump control action
Test 24c6: Add nat action on ingress with drop control action
Test 2120: Add nat action on ingress with maximum index value
Test 3e9d: Add nat action on ingress with invalid index value
Test f6c9: Add nat action on ingress with invalid IP address
Test be25: Add nat action on ingress with invalid argument
Test a7bd: Add nat action on ingress with DEFAULT IP address
Test ee1e: Add nat action on ingress with ANY IP address
Test 1de8: Add nat action on ingress with ALL IP address
Test 8dba: Add nat action on egress with default control action
Test 19a7: Add nat action on egress with pipe control action
Test f1d9: Add nat action on egress with continue control action
Test 6d4a: Add nat action on egress with reclassify control action
Test b313: Add nat action on egress with jump control action
Test d9fc: Add nat action on egress with drop control action
Test a895: Add nat action on egress with DEFAULT IP address
Test 2572: Add nat action on egress with ANY IP address
Test 37f3: Add nat action on egress with ALL IP address
Test 6054: Add nat action on egress with cookie
Test 79d6: Add nat action on ingress with cookie
Test 4b12: Replace nat action with invalid goto chain control
Test b811: Delete nat action with valid index
Test a521: Delete nat action with invalid index

All test results:

1..27
ok 1 7565 - Add nat action on ingress with default control action
ok 2 fd79 - Add nat action on ingress with pipe control action
ok 3 eab9 - Add nat action on ingress with continue control action
ok 4 c53a - Add nat action on ingress with reclassify control action
ok 5 76c9 - Add nat action on ingress with jump control action
ok 6 24c6 - Add nat action on ingress with drop control action
ok 7 2120 - Add nat action on ingress with maximum index value
ok 8 3e9d - Add nat action on ingress with invalid index value
ok 9 f6c9 - Add nat action on ingress with invalid IP address
ok 10 be25 - Add nat action on ingress with invalid argument
ok 11 a7bd - Add nat action on ingress with DEFAULT IP address
ok 12 ee1e - Add nat action on ingress with ANY IP address
ok 13 1de8 - Add nat action on ingress with ALL IP address
ok 14 8dba - Add nat action on egress with default control action
ok 15 19a7 - Add nat action on egress with pipe control action
ok 16 f1d9 - Add nat action on egress with continue control action
ok 17 6d4a - Add nat action on egress with reclassify control action
ok 18 b313 - Add nat action on egress with jump control action
ok 19 d9fc - Add nat action on egress with drop control action
ok 20 a895 - Add nat action on egress with DEFAULT IP address
ok 21 2572 - Add nat action on egress with ANY IP address
ok 22 37f3 - Add nat action on egress with ALL IP address
ok 23 6054 - Add nat action on egress with cookie
ok 24 79d6 - Add nat action on ingress with cookie
ok 25 4b12 - Replace nat action with invalid goto chain control
ok 26 b811 - Delete nat action with valid index
ok 27 a521 - Delete nat action with invalid index

./tdc.py -c action sample
considering category action
considering category sample
Test 9784: Add valid sample action with mandatory arguments
Test 5c91: Add valid sample action with mandatory arguments and continue
control action
Test 334b: Add valid sample action with mandatory arguments and drop
control action
Test da69: Add valid sample action with mandatory arguments and reclassify
control action
Test 13ce: Add valid sample action with mandatory arguments and pipe
control action
Test 1886: Add valid sample action with mandatory arguments and jump
control action
Test 7571: Add sample action with invalid rate
Test b6d4: Add sample action with mandatory arguments and invalid control
action
Test a874: Add invalid sample action without mandatory arguments
Test ac01: Add invalid sample action without mandatory argument rate
Test 4203: Add invalid sample action without mandatory argument group
Test 14a7: Add invalid sample action without mandatory argument group
Test 8f2e: Add valid sample action with trunc argument
Test 45f8: Add sample action with maximum rate argument
Test ad0c: Add sample action with maximum trunc argument
Test 83a9: Add sample action with maximum group argument
Test ed27: Add sample action with invalid rate argument
Test 2eae: Add sample action with invalid group argument
Test 6ff3: Add sample action with invalid trunc size
Test 2b2a: Add sample action with invalid index
Test dee2: Add sample action with maximum allowed index
Test 560e: Add sample action with cookie
Test 704a: Replace existing sample action with new rate argument
Test 60eb: Replace existing sample action with new group argument
Test 2cce: Replace existing sample action with new trunc argument
Test 59d1: Replace existing sample action with new control argument
Test 0a6e: Replace sample action with invalid goto chain control
Test 3872: Delete sample action with valid index
Test a394: Delete sample action with invalid index

All test results:

1..29
ok 1 9784 - Add valid sample action with mandatory arguments
ok 2 5c91 - Add valid sample action with mandatory arguments and continue
control action
ok 3 334b - Add valid sample action with mandatory arguments and drop
control action
ok 4 da69 - Add valid sample action with mandatory arguments and
reclassify control action
ok 5 13ce - Add valid sample action with mandatory arguments and pipe
control action
ok 6 1886 - Add valid sample action with mandatory arguments and jump
control action
ok 7 7571 - Add sample action with invalid rate
ok 8 b6d4 - Add sample action with mandatory arguments and invalid control
action
ok 9 a874 - Add invalid sample action without mandatory arguments
ok 10 ac01 - Add invalid sample action without mandatory argument rate
ok 11 4203 - Add invalid sample action without mandatory argument group
ok 12 14a7 - Add invalid sample action without mandatory argument group
ok 13 8f2e - Add valid sample action with trunc argument
ok 14 45f8 - Add sample action with maximum rate argument
ok 15 ad0c - Add sample action with maximum trunc argument
ok 16 83a9 - Add sample action with maximum group argument
ok 17 ed27 - Add sample action with invalid rate argument
ok 18 2eae - Add sample action with invalid group argument
ok 19 6ff3 - Add sample action with invalid trunc size
ok 20 2b2a - Add sample action with invalid index
ok 21 dee2 - Add sample action with maximum allowed index
ok 22 560e - Add sample action with cookie
ok 23 704a - Replace existing sample action with new rate argument
ok 24 60eb - Replace existing sample action with new group argument
ok 25 2cce - Replace existing sample action with new trunc argument
ok 26 59d1 - Replace existing sample action with new control argument
ok 27 0a6e - Replace sample action with invalid goto chain control
ok 28 3872 - Delete sample action with valid index
ok 29 a394 - Delete sample action with invalid index

./tdc.py -c action tunnel_key
considering category tunnel_key
considering category action
Test 2b11: Add tunnel_key set action with mandatory parameters
Test dc6b: Add tunnel_key set action with missing mandatory src_ip
parameter
Test 7f25: Add tunnel_key set action with missing mandatory dst_ip
parameter
Test a5e0: Add tunnel_key set action with invalid src_ip parameter
Test eaa8: Add tunnel_key set action with invalid dst_ip parameter
Test 3b09: Add tunnel_key set action with invalid id parameter
Test 9625: Add tunnel_key set action with invalid dst_port parameter
Test 05af: Add tunnel_key set action with optional dst_port parameter
Test da80: Add tunnel_key set action with index at 32-bit maximum
Test d407: Add tunnel_key set action with index exceeding 32-bit maximum
Test 5cba: Add tunnel_key set action with id value at 32-bit maximum
Test e84a: Add tunnel_key set action with id value exceeding 32-bit
maximum
Test 9c19: Add tunnel_key set action with dst_port value at 16-bit maximum
Test 3bd9: Add tunnel_key set action with dst_port value exceeding 16-bit
maximum
Test 68e2: Add tunnel_key unset action
Test 6192: Add tunnel_key unset continue action
Test 061d: Add tunnel_key set continue action with cookie
Test 8acb: Add tunnel_key set continue action with invalid cookie
Test a07e: Add tunnel_key action with no set/unset command specified
Test b227: Add tunnel_key action with csum option
Test 58a7: Add tunnel_key action with nocsum option
Test 2575: Add tunnel_key action with not-supported parameter
Test 7a88: Add tunnel_key action with cookie parameter
Test 4f20: Add tunnel_key action with a single geneve option parameter
Test e33d: Add tunnel_key action with multiple geneve options parameter
Test 0778: Add tunnel_key action with invalid class geneve option
parameter
Test 4ae8: Add tunnel_key action with invalid type geneve option parameter
Test 4039: Add tunnel_key action with short data length geneve option
parameter
Test 26a6: Add tunnel_key action with non-multiple of 4 data length geneve
option parameter
Test f44d: Add tunnel_key action with incomplete geneve options parameter
Test 7afc: Replace tunnel_key set action with all parameters
Test 364d: Replace tunnel_key set action with all parameters and cookie
Test 937c: Fetch all existing tunnel_key actions
Test 6783: Flush all existing tunnel_key actions
Test 8242: Replace tunnel_key set action with invalid goto chain
Test 0cd2: Add tunnel_key set action with no_percpu flag
Test 3671: Delete tunnel_key set action with valid index
Test 8597: Delete tunnel_key set action with invalid index

All test results:

1..38
ok 1 2b11 - Add tunnel_key set action with mandatory parameters
ok 2 dc6b - Add tunnel_key set action with missing mandatory src_ip
parameter
ok 3 7f25 - Add tunnel_key set action with missing mandatory dst_ip
parameter
ok 4 a5e0 - Add tunnel_key set action with invalid src_ip parameter
ok 5 eaa8 - Add tunnel_key set action with invalid dst_ip parameter
ok 6 3b09 - Add tunnel_key set action with invalid id parameter
ok 7 9625 - Add tunnel_key set action with invalid dst_port parameter
ok 8 05af - Add tunnel_key set action with optional dst_port parameter
ok 9 da80 - Add tunnel_key set action with index at 32-bit maximum
ok 10 d407 - Add tunnel_key set action with index exceeding 32-bit maximum
ok 11 5cba - Add tunnel_key set action with id value at 32-bit maximum
ok 12 e84a - Add tunnel_key set action with id value exceeding 32-bit
maximum
ok 13 9c19 - Add tunnel_key set action with dst_port value at 16-bit
maximum
ok 14 3bd9 - Add tunnel_key set action with dst_port value exceeding
16-bit maximum
ok 15 68e2 - Add tunnel_key unset action
ok 16 6192 - Add tunnel_key unset continue action
ok 17 061d - Add tunnel_key set continue action with cookie
ok 18 8acb - Add tunnel_key set continue action with invalid cookie
ok 19 a07e - Add tunnel_key action with no set/unset command specified
ok 20 b227 - Add tunnel_key action with csum option
ok 21 58a7 - Add tunnel_key action with nocsum option
ok 22 2575 - Add tunnel_key action with not-supported parameter
ok 23 7a88 - Add tunnel_key action with cookie parameter
ok 24 4f20 - Add tunnel_key action with a single geneve option parameter
ok 25 e33d - Add tunnel_key action with multiple geneve options parameter
ok 26 0778 - Add tunnel_key action with invalid class geneve option
parameter
ok 27 4ae8 - Add tunnel_key action with invalid type geneve option
parameter
ok 28 4039 - Add tunnel_key action with short data length geneve option
parameter
ok 29 26a6 - Add tunnel_key action with non-multiple of 4 data length
geneve option parameter
ok 30 f44d - Add tunnel_key action with incomplete geneve options
parameter
ok 31 7afc - Replace tunnel_key set action with all parameters
ok 32 364d - Replace tunnel_key set action with all parameters and cookie
ok 33 937c - Fetch all existing tunnel_key actions
ok 34 6783 - Flush all existing tunnel_key actions
ok 35 8242 - Replace tunnel_key set action with invalid goto chain
ok 36 0cd2 - Add tunnel_key set action with no_percpu flag
ok 37 3671 - Delete tunnel_key set action with valid index
ok 38 8597 - Delete tunnel_key set action with invalid index

Zhengchao Shao (8):
  selftests/tc-testings: add selftests for ctinfo action
  selftests/tc-testings: add selftests for gate action
  selftests/tc-testings: add selftests for xt action
  selftests/tc-testings: add connmark action deleting test case
  selftests/tc-testings: add ife action deleting test case
  selftests/tc-testings: add nat action deleting test case
  selftests/tc-testings: add sample action deleting test case
  selftests/tc-testings: add tunnel_key action deleting test case

 .../tc-testing/tc-tests/actions/connmark.json |  50 +++
 .../tc-testing/tc-tests/actions/ctinfo.json   | 316 ++++++++++++++++++
 .../tc-testing/tc-tests/actions/gate.json     | 315 +++++++++++++++++
 .../tc-testing/tc-tests/actions/ife.json      |  50 +++
 .../tc-testing/tc-tests/actions/nat.json      |  50 +++
 .../tc-testing/tc-tests/actions/sample.json   |  50 +++
 .../tc-tests/actions/tunnel_key.json          |  50 +++
 .../tc-testing/tc-tests/actions/xt.json       | 219 ++++++++++++
 8 files changed, 1100 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/ctinfo.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/gate.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/xt.json

-- 
2.17.1

