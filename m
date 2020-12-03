Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7AC2CCED7
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 06:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgLCFx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 00:53:28 -0500
Received: from mga07.intel.com ([134.134.136.100]:12941 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725979AbgLCFx1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 00:53:27 -0500
IronPort-SDR: vJNBIDD4D8RU1aebaitQa+aO2lykWGt6mGm+YpPqEO0raK0RQHCLLrZdwvNvwSI2rf87sRPypt
 COu2YFhWcKvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="237260244"
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="xz'?yaml'?scan'208";a="237260244"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 21:52:26 -0800
IronPort-SDR: 569/IHr94vJoRwiG+FgxM2Nb7SJKlamwQ4gNXUIpAji5Z0npuFSZManURz2JZYKzhw600jd7sV
 FnJGk2dHZq0g==
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="xz'?yaml'?scan'208";a="550363624"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.140])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 21:52:21 -0800
Date:   Thu, 3 Dec 2020 14:06:29 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Gary Lin <glin@suse.com>
Cc:     0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@lists.01.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        andreas.taschner@suse.com
Subject: [bpf, x64]  de900a2419: kernel-selftests.net.test_bpf.sh.fail
Message-ID: <20201203060628.GD27350@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5gxpn/Q6ypwruk0T"
Content-Disposition: inline
In-Reply-To: <20201127072254.1061-1-glin@suse.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5gxpn/Q6ypwruk0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Greeting,

FYI, we noticed the following commit (built with gcc-9):

commit: de900a24194807c73768a543f989161a1ee47c7e ("[PATCH] bpf, x64: add extra passes without size optimizations")
url: https://github.com/0day-ci/linux/commits/Gary-Lin/bpf-x64-add-extra-passes-without-size-optimizations/20201127-152514
base: https://git.kernel.org/cgit/linux/kernel/git/bpf/bpf-next.git master

in testcase: kernel-selftests
version: kernel-selftests-x86_64-b5a583fb-1_20201015
with following parameters:

	group: net
	ucode: 0xe2

test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
test-url: https://www.kernel.org/doc/Documentation/kselftest.txt


on test machine: 8 threads Intel(R) Core(TM) i7-6770HQ CPU @ 2.60GHz with 32G memory

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):




If you fix the issue, kindly add following tag
Reported-by: kernel test robot <oliver.sang@intel.com>


user  :notice: [  218.215557] # selftests: net: test_bpf.sh

kern  :info  : [  218.232063] test_bpf: #0 TAX jited:1 145 19 19 PASS
kern  :info  : [  218.238259] test_bpf: #1 TXA jited:1 34 14 14 PASS
kern  :info  : [  218.244288] test_bpf: #2 ADD_SUB_MUL_K jited:1 32 PASS
kern  :info  : [  218.250691] test_bpf: #3 DIV_MOD_KX jited:1 42 PASS
kern  :info  : [  218.256812] test_bpf: #4 AND_OR_LSH_K jited:1 29 15 PASS
kern  :info  : [  218.263396] test_bpf: #5 LD_IMM_0 jited:1 17 PASS
kern  :info  : [  218.269051] test_bpf: #6 LD_IND jited:1 36 67 35 PASS
kern  :info  : [  218.275233] test_bpf: #7 LD_ABS jited:1 37 20 19 PASS
kern  :info  : [  218.281410] test_bpf: #8 LD_ABS_LL jited:1 43 28 PASS
kern  :info  : [  218.287744] test_bpf: #9 LD_IND_LL jited:1 36 20 20 PASS
kern  :info  : [  218.294370] test_bpf: #10 LD_ABS_NET jited:1 54 24 PASS
kern  :info  : [  218.300744] test_bpf: #11 LD_IND_NET jited:1 37 20 20 PASS
kern  :info  : [  218.307363] test_bpf: #12 LD_PKTTYPE jited:1 32 18 PASS
kern  :info  : [  218.313772] test_bpf: #13 LD_MARK jited:1 15 15 PASS
kern  :info  : [  218.320015] test_bpf: #14 LD_RXHASH jited:1 15 15 PASS
kern  :info  : [  218.326246] test_bpf: #15 LD_QUEUE jited:1 15 15 PASS
kern  :info  : [  218.332407] test_bpf: #16 LD_PROTOCOL jited:1 20 19 PASS
kern  :info  : [  218.338914] test_bpf: #17 LD_VLAN_TAG jited:1 15 15 PASS
kern  :info  : [  218.345224] test_bpf: #18 LD_VLAN_TAG_PRESENT jited:1 15 15 PASS
kern  :info  : [  218.352214] test_bpf: #19 LD_IFINDEX jited:1 16 16 PASS
kern  :info  : [  218.358594] test_bpf: #20 LD_HATYPE jited:1 48 15 PASS
kern  :info  : [  218.364883] test_bpf: #21 LD_CPU jited:1 18 51 PASS
kern  :info  : [  218.371095] test_bpf: #22 LD_NLATTR jited:1 92 46 PASS
kern  :info  : [  218.377537] test_bpf: #23 LD_NLATTR_NEST jited:1 60 61 PASS
kern  :info  : [  218.384440] test_bpf: #24 LD_PAYLOAD_OFF jited:1 1355 1432 PASS
kern  :info  : [  218.394149] test_bpf: #25 LD_ANC_XOR jited:1 15 27 PASS
kern  :info  : [  218.400726] test_bpf: #26 SPILL_FILL jited:1 15 15 28 PASS
kern  :info  : [  218.407298] test_bpf: #27 JEQ jited:1 36 17 16 PASS
kern  :info  : [  218.413283] test_bpf: #28 JGT jited:1 21 16 17 PASS
kern  :info  : [  218.419201] test_bpf: #29 JGE (jt 0), test 1 jited:1 46 16 15 PASS
kern  :info  : [  218.426769] test_bpf: #30 JGE (jt 0), test 2 jited:1 23 23 24 PASS
kern  :info  : [  218.435004] test_bpf: #31 JGE jited:1 28 30 30 PASS
kern  :info  : [  218.441648] test_bpf: #32 JSET jited:1 30 28 32 PASS
kern  :info  : [  218.448430] test_bpf: #33 tcpdump port 22 jited:1 48 37 39 PASS
kern  :info  : [  218.456234] test_bpf: #34 tcpdump complex jited:1 20 27 34 PASS
kern  :info  : [  218.463293] test_bpf: #35 RET_A jited:1 35 15 PASS
kern  :info  : [  218.469127] test_bpf: #36 INT: ADD trivial jited:1 46 PASS
kern  :info  : [  218.475707] test_bpf: #37 INT: MUL_X jited:1 33 PASS
kern  :info  : [  218.481664] test_bpf: #38 INT: MUL_X2 jited:1 17 PASS
kern  :info  : [  218.487740] test_bpf: #39 INT: MUL32_X jited:1 20 PASS
kern  :info  : [  218.493882] test_bpf: #40 INT: ADD 64-bit jited:1 44 PASS
kern  :info  : [  218.500321] test_bpf: #41 INT: ADD 32-bit jited:1 57 PASS
kern  :info  : [  218.506784] test_bpf: #42 INT: SUB jited:1 28 PASS
kern  :info  : [  218.512454] test_bpf: #43 INT: XOR jited:1 40 PASS
kern  :info  : [  218.518286] test_bpf: #44 INT: MUL jited:1 62 PASS
kern  :info  : [  218.524098] test_bpf: #45 MOV REG64 jited:1 16 PASS
kern  :info  : [  218.530429] test_bpf: #46 MOV REG32 jited:1 23 PASS
kern  :info  : [  218.536740] test_bpf: #47 LD IMM64 jited:1 23 PASS
kern  :info  : [  218.543021] test_bpf: #48 INT: ALU MIX jited:1 40 PASS
kern  :info  : [  218.549576] test_bpf: #49 INT: shifts by register jited:1 60 PASS
kern  :info  : [  218.557539] test_bpf: #50 check: missing ret PASS
kern  :info  : [  218.562972] test_bpf: #51 check: div_k_0 PASS
kern  :info  : [  218.568248] test_bpf: #52 check: unknown insn PASS
kern  :info  : [  218.573813] test_bpf: #53 check: out of range spill/fill PASS
kern  :info  : [  218.580568] test_bpf: #54 JUMPS + HOLES jited:1 19 PASS
kern  :info  : [  218.586923] test_bpf: #55 check: RET X PASS
kern  :info  : [  218.591977] test_bpf: #56 check: LDX + RET X PASS
kern  :info  : [  218.597444] test_bpf: #57 M[]: alt STX + LDX jited:1 26 PASS
kern  :info  : [  218.603894] test_bpf: #58 M[]: full STX + full LDX jited:1 34 PASS
kern  :info  : [  218.611067] test_bpf: #59 check: SKF_AD_MAX PASS
kern  :info  : [  218.616502] test_bpf: #60 LD [SKF_AD_OFF-1] jited:1 19 PASS
kern  :info  : [  218.623241] test_bpf: #61 load 64-bit immediate jited:1 17 PASS
kern  :info  : [  218.630224] test_bpf: #62 ALU_MOV_X: dst = 2 jited:1 15 PASS
kern  :info  : [  218.636885] test_bpf: #63 ALU_MOV_X: dst = 4294967295 jited:1 15 PASS
kern  :info  : [  218.644414] test_bpf: #64 ALU64_MOV_X: dst = 2 jited:1 31 PASS
kern  :info  : [  218.651401] test_bpf: #65 ALU64_MOV_X: dst = 4294967295 jited:1 30 PASS
kern  :info  : [  218.659217] test_bpf: #66 ALU_MOV_K: dst = 2 jited:1 28 PASS
kern  :info  : [  218.666039] test_bpf: #67 ALU_MOV_K: dst = 4294967295 jited:1 14 PASS
kern  :info  : [  218.673587] test_bpf: #68 ALU_MOV_K: 0x0000ffffffff0000 = 0x00000000ffffffff jited:1 17 PASS
kern  :info  : [  218.683051] test_bpf: #69 ALU64_MOV_K: dst = 2 jited:1 14 PASS
kern  :info  : [  218.689936] test_bpf: #70 ALU64_MOV_K: dst = 2147483647 jited:1 14 PASS
kern  :info  : [  218.697572] test_bpf: #71 ALU64_OR_K: dst = 0x0 jited:1 32 PASS
kern  :info  : [  218.704558] test_bpf: #72 ALU64_MOV_K: dst = -1 jited:1 28 PASS
kern  :info  : [  218.711567] test_bpf: #73 ALU_ADD_X: 1 + 2 = 3 jited:1 31 PASS
kern  :info  : [  218.718530] test_bpf: #74 ALU_ADD_X: 1 + 4294967294 = 4294967295 jited:1 14 PASS
kern  :info  : [  218.727050] test_bpf: #75 ALU_ADD_X: 2 + 4294967294 = 0 jited:1 30 PASS
kern  :info  : [  218.734740] test_bpf: #76 ALU64_ADD_X: 1 + 2 = 3 jited:1 41 PASS
kern  :info  : [  218.742061] test_bpf: #77 ALU64_ADD_X: 1 + 4294967294 = 4294967295 jited:1 17 PASS
kern  :info  : [  218.750729] test_bpf: #78 ALU64_ADD_X: 2 + 4294967294 = 4294967296 jited:1 29 PASS
kern  :info  : [  218.759582] test_bpf: #79 ALU_ADD_K: 1 + 2 = 3 jited:1 14 PASS
kern  :info  : [  218.766585] test_bpf: #80 ALU_ADD_K: 3 + 0 = 3 jited:1 31 PASS
kern  :info  : [  218.773557] test_bpf: #81 ALU_ADD_K: 1 + 4294967294 = 4294967295 jited:1 31 PASS
kern  :info  : [  218.782151] test_bpf: #82 ALU_ADD_K: 4294967294 + 2 = 0 jited:1 28 PASS
kern  :info  : [  218.790076] test_bpf: #83 ALU_ADD_K: 0 + (-1) = 0x00000000ffffffff jited:1 16 PASS
kern  :info  : [  218.798570] test_bpf: #84 ALU_ADD_K: 0 + 0xffff = 0xffff jited:1 50 PASS
kern  :info  : [  218.806619] test_bpf: #85 ALU_ADD_K: 0 + 0x7fffffff = 0x7fffffff jited:1 16 PASS
kern  :info  : [  218.815366] test_bpf: #86 ALU_ADD_K: 0 + 0x80000000 = 0x80000000 jited:1 16 PASS
kern  :info  : [  218.824105] test_bpf: #87 ALU_ADD_K: 0 + 0x80008000 = 0x80008000 jited:1 56 PASS
kern  :info  : [  218.832577] test_bpf: #88 ALU64_ADD_K: 1 + 2 = 3 jited:1 31 PASS
kern  :info  : [  218.839843] test_bpf: #89 ALU64_ADD_K: 3 + 0 = 3 jited:1 30 PASS
kern  :info  : [  218.846934] test_bpf: #90 ALU64_ADD_K: 1 + 2147483646 = 2147483647 jited:1 14 PASS
kern  :info  : [  218.855741] test_bpf: #91 ALU64_ADD_K: 4294967294 + 2 = 4294967296 jited:1 31 PASS
kern  :info  : [  218.864473] test_bpf: #92 ALU64_ADD_K: 2147483646 + -2147483647 = -1 jited:1 15 PASS
kern  :info  : [  218.873433] test_bpf: #93 ALU64_ADD_K: 1 + 0 = 1 jited:1 16 PASS
kern  :info  : [  218.880638] test_bpf: #94 ALU64_ADD_K: 0 + (-1) = 0xffffffffffffffff jited:1 29 PASS
kern  :info  : [  218.889476] test_bpf: #95 ALU64_ADD_K: 0 + 0xffff = 0xffff jited:1 47 PASS
kern  :info  : [  218.897641] test_bpf: #96 ALU64_ADD_K: 0 + 0x7fffffff = 0x7fffffff jited:1 16 PASS
kern  :info  : [  218.906600] test_bpf: #97 ALU64_ADD_K: 0 + 0x80000000 = 0xffffffff80000000 jited:1 32 PASS
kern  :info  : [  218.916214] test_bpf: #98 ALU_ADD_K: 0 + 0x80008000 = 0xffffffff80008000 jited:1 17 PASS
kern  :info  : [  218.925719] test_bpf: #99 ALU_SUB_X: 3 - 1 = 2 jited:1 14 PASS
kern  :info  : [  218.932716] test_bpf: #100 ALU_SUB_X: 4294967295 - 4294967294 = 1 jited:1 14 PASS
kern  :info  : [  218.941379] test_bpf: #101 ALU64_SUB_X: 3 - 1 = 2 jited:1 14 PASS
kern  :info  : [  218.948550] test_bpf: #102 ALU64_SUB_X: 4294967295 - 4294967294 = 1 jited:1 30 PASS
kern  :info  : [  218.957548] test_bpf: #103 ALU_SUB_K: 3 - 1 = 2 jited:1 28 PASS
kern  :info  : [  218.964599] test_bpf: #104 ALU_SUB_K: 3 - 0 = 3 jited:1 15 PASS
kern  :info  : [  218.971539] test_bpf: #105 ALU_SUB_K: 4294967295 - 4294967294 = 1 jited:1 42 PASS
kern  :info  : [  218.980246] test_bpf: #106 ALU64_SUB_K: 3 - 1 = 2 jited:1 14 PASS
kern  :info  : [  218.987424] test_bpf: #107 ALU64_SUB_K: 3 - 0 = 3 jited:1 14 PASS
kern  :info  : [  218.994853] test_bpf: #108 ALU64_SUB_K: 4294967294 - 4294967295 = -1 jited:1 41 PASS
kern  :info  : [  219.003967] test_bpf: #109 ALU64_ADD_K: 2147483646 - 2147483647 = -1 jited:1 14 PASS
kern  :info  : [  219.012951] test_bpf: #110 ALU_MUL_X: 2 * 3 = 6 jited:1 15 PASS
kern  :info  : [  219.019956] test_bpf: #111 ALU_MUL_X: 2 * 0x7FFFFFF8 = 0xFFFFFFF0 jited:1 15 PASS
kern  :info  : [  219.028665] test_bpf: #112 ALU_MUL_X: -1 * -1 = 1 jited:1 16 PASS
kern  :info  : [  219.036295] test_bpf: #113 ALU64_MUL_X: 2 * 3 = 6 jited:1 31 PASS
kern  :info  : [  219.043546] test_bpf: #114 ALU64_MUL_X: 1 * 2147483647 = 2147483647 jited:1 20 PASS
kern  :info  : [  219.053213] test_bpf: #115 ALU_MUL_K: 2 * 3 = 6 jited:1 28 PASS
kern  :info  : [  219.060245] test_bpf: #116 ALU_MUL_K: 3 * 1 = 3 jited:1 16 PASS
kern  :info  : [  219.067304] test_bpf: #117 ALU_MUL_K: 2 * 0x7FFFFFF8 = 0xFFFFFFF0 jited:1 15 PASS
kern  :info  : [  219.076058] test_bpf: #118 ALU_MUL_K: 1 * (-1) = 0x00000000ffffffff jited:1 17 PASS
kern  :info  : [  219.084931] test_bpf: #119 ALU64_MUL_K: 2 * 3 = 6 jited:1 15 PASS
kern  :info  : [  219.092206] test_bpf: #120 ALU64_MUL_K: 3 * 1 = 3 jited:1 30 PASS
kern  :info  : [  219.099622] test_bpf: #121 ALU64_MUL_K: 1 * 2147483647 = 2147483647 jited:1 28 PASS
kern  :info  : [  219.108668] test_bpf: #122 ALU64_MUL_K: 1 * -2147483647 = -2147483647 jited:1 41 PASS
kern  :info  : [  219.117828] test_bpf: #123 ALU64_MUL_K: 1 * (-1) = 0xffffffffffffffff jited:1 42 PASS
kern  :info  : [  219.126857] test_bpf: #124 ALU_DIV_X: 6 / 2 = 3 jited:1 18 PASS
kern  :info  : [  219.133963] test_bpf: #125 ALU_DIV_X: 4294967295 / 4294967295 = 1 jited:1 19 PASS
kern  :info  : [  219.142635] test_bpf: #126 ALU64_DIV_X: 6 / 2 = 3 jited:1 51 PASS
kern  :info  : [  219.150091] test_bpf: #127 ALU64_DIV_X: 2147483647 / 2147483647 = 1 jited:1 89 PASS
kern  :info  : [  219.159082] test_bpf: #128 ALU64_DIV_X: 0xffffffffffffffff / (-1) = 0x0000000000000001 jited:1 22 PASS
kern  :info  : [  219.169748] test_bpf: #129 ALU_DIV_K: 6 / 2 = 3 jited:1 18 PASS
kern  :info  : [  219.176855] test_bpf: #130 ALU_DIV_K: 3 / 1 = 3 jited:1 45 PASS
kern  :info  : [  219.183933] test_bpf: #131 ALU_DIV_K: 4294967295 / 4294967295 = 1 jited:1 18 PASS
kern  :info  : [  219.192667] test_bpf: #132 ALU_DIV_K: 0xffffffffffffffff / (-1) = 0x1 jited:1 48 PASS
kern  :info  : [  219.201806] test_bpf: #133 ALU64_DIV_K: 6 / 2 = 3 jited:1 36 PASS
kern  :info  : [  219.209068] test_bpf: #134 ALU64_DIV_K: 3 / 1 = 3 jited:1 36 PASS
kern  :info  : [  219.216189] test_bpf: #135 ALU64_DIV_K: 2147483647 / 2147483647 = 1 jited:1 23 PASS
kern  :info  : [  219.225098] test_bpf: #136 ALU64_DIV_K: 0xffffffffffffffff / (-1) = 0x0000000000000001 jited:1 22 PASS
kern  :info  : [  219.235723] test_bpf: #137 ALU_MOD_X: 3 % 2 = 1 jited:1 18 PASS
kern  :info  : [  219.243052] test_bpf: #138 ALU_MOD_X: 4294967295 % 4294967293 = 2 jited:1 18 PASS
kern  :info  : [  219.251780] test_bpf: #139 ALU64_MOD_X: 3 % 2 = 1 jited:1 23 PASS
kern  :info  : [  219.259097] test_bpf: #140 ALU64_MOD_X: 2147483647 % 2147483645 = 2 jited:1 38 PASS
kern  :info  : [  219.268039] test_bpf: #141 ALU_MOD_K: 3 % 2 = 1 jited:1 19 PASS
kern  :info  : [  219.275114] test_bpf: #142 ALU_MOD_K: 3 % 1 = 0 jited:1 PASS
kern  :info  : [  219.282033] test_bpf: #143 ALU_MOD_K: 4294967295 % 4294967293 = 2 jited:1 18 PASS
kern  :info  : [  219.290795] test_bpf: #144 ALU64_MOD_K: 3 % 2 = 1 jited:1 35 PASS
kern  :info  : [  219.298123] test_bpf: #145 ALU64_MOD_K: 3 % 1 = 0 jited:1 PASS
kern  :info  : [  219.305093] test_bpf: #146 ALU64_MOD_K: 2147483647 % 2147483645 = 2 jited:1 23 PASS
kern  :info  : [  219.314052] test_bpf: #147 ALU_AND_X: 3 & 2 = 2 jited:1 15 PASS
kern  :info  : [  219.321278] test_bpf: #148 ALU_AND_X: 0xffffffff & 0xffffffff = 0xffffffff jited:1 31 PASS
kern  :info  : [  219.330968] test_bpf: #149 ALU64_AND_X: 3 & 2 = 2 jited:1 15 PASS
kern  :info  : [  219.338525] test_bpf: #150 ALU64_AND_X: 0xffffffff & 0xffffffff = 0xffffffff jited:1 27 PASS
kern  :info  : [  219.348528] test_bpf: #151 ALU_AND_K: 3 & 2 = 2 jited:1 28 PASS
kern  :info  : [  219.355735] test_bpf: #152 ALU_AND_K: 0xffffffff & 0xffffffff = 0xffffffff jited:1 14 PASS
kern  :info  : [  219.365344] test_bpf: #153 ALU64_AND_K: 3 & 2 = 2 jited:1 30 PASS
kern  :info  : [  219.372875] test_bpf: #154 ALU64_AND_K: 0xffffffff & 0xffffffff = 0xffffffff jited:1 43 PASS
kern  :info  : [  219.382638] test_bpf: #155 ALU64_AND_K: 0x0000ffffffff0000 & 0x0 = 0x0000ffff00000000 jited:1 15 PASS
kern  :info  : [  219.393475] test_bpf: #156 ALU64_AND_K: 0x0000ffffffff0000 & -1 = 0x0000ffffffffffff jited:1 16 PASS
kern  :info  : [  219.403980] test_bpf: #157 ALU64_AND_K: 0xffffffffffffffff & -1 = 0xffffffffffffffff jited:1 43 PASS
kern  :info  : [  219.414628] test_bpf: #158 ALU_OR_X: 1 | 2 = 3 jited:1 15 PASS
kern  :info  : [  219.421746] test_bpf: #159 ALU_OR_X: 0x0 | 0xffffffff = 0xffffffff jited:1 32 PASS
kern  :info  : [  219.430830] test_bpf: #160 ALU64_OR_X: 1 | 2 = 3 jited:1 14 PASS
kern  :info  : [  219.438279] test_bpf: #161 ALU64_OR_X: 0 | 0xffffffff = 0xffffffff jited:1 14 PASS
kern  :info  : [  219.447219] test_bpf: #162 ALU_OR_K: 1 | 2 = 3 jited:1 31 PASS
kern  :info  : [  219.454225] test_bpf: #163 ALU_OR_K: 0 & 0xffffffff = 0xffffffff jited:1 31 PASS
kern  :info  : [  219.463133] test_bpf: #164 ALU64_OR_K: 1 | 2 = 3 jited:1 15 PASS
kern  :info  : [  219.470262] test_bpf: #165 ALU64_OR_K: 0 & 0xffffffff = 0xffffffff jited:1 30 PASS
kern  :info  : [  219.479684] test_bpf: #166 ALU64_OR_K: 0x0000ffffffff0000 | 0x0 = 0x0000ffff00000000 jited:1 16 PASS
kern  :info  : [  219.490378] test_bpf: #167 ALU64_OR_K: 0x0000ffffffff0000 | -1 = 0xffffffffffffffff jited:1 15 PASS
kern  :info  : [  219.500792] test_bpf: #168 ALU64_OR_K: 0x000000000000000 | -1 = 0xffffffffffffffff jited:1 29 PASS
kern  :info  : [  219.511157] test_bpf: #169 ALU_XOR_X: 5 ^ 6 = 3 jited:1 15 PASS
kern  :info  : [  219.518457] test_bpf: #170 ALU_XOR_X: 0x1 ^ 0xffffffff = 0xfffffffe jited:1 15 PASS
kern  :info  : [  219.527436] test_bpf: #171 ALU64_XOR_X: 5 ^ 6 = 3 jited:1 31 PASS
kern  :info  : [  219.534936] test_bpf: #172 ALU64_XOR_X: 1 ^ 0xffffffff = 0xfffffffe jited:1 31 PASS
kern  :info  : [  219.543997] test_bpf: #173 ALU_XOR_K: 5 ^ 6 = 3 jited:1 30 PASS
kern  :info  : [  219.551584] test_bpf: #174 ALU_XOR_K: 1 ^ 0xffffffff = 0xfffffffe jited:1 14 PASS
kern  :info  : [  219.560258] test_bpf: #175 ALU64_XOR_K: 5 ^ 6 = 3 jited:1 14 PASS
kern  :info  : [  219.567736] test_bpf: #176 ALU64_XOR_K: 1 & 0xffffffff = 0xfffffffe jited:1 28 PASS
kern  :info  : [  219.576870] test_bpf: #177 ALU64_XOR_K: 0x0000ffffffff0000 ^ 0x0 = 0x0000ffffffff0000 jited:1 16 PASS
kern  :info  : [  219.587602] test_bpf: #178 ALU64_XOR_K: 0x0000ffffffff0000 ^ -1 = 0xffff00000000ffff jited:1 29 PASS
kern  :info  : [  219.598272] test_bpf: #179 ALU64_XOR_K: 0x000000000000000 ^ -1 = 0xffffffffffffffff jited:1 32 PASS
kern  :info  : [  219.608971] test_bpf: #180 ALU_LSH_X: 1 << 1 = 2 jited:1 15 PASS
kern  :info  : [  219.616402] test_bpf: #181 ALU_LSH_X: 1 << 31 = 0x80000000 jited:1 15 PASS
kern  :info  : [  219.624774] test_bpf: #182 ALU64_LSH_X: 1 << 1 = 2 jited:1 28 PASS
kern  :info  : [  219.632477] test_bpf: #183 ALU64_LSH_X: 1 << 31 = 0x80000000 jited:1 31 PASS
kern  :info  : [  219.640877] test_bpf: #184 ALU_LSH_K: 1 << 1 = 2 jited:1 15 PASS
kern  :info  : [  219.648456] test_bpf: #185 ALU_LSH_K: 1 << 31 = 0x80000000 jited:1 27 PASS
kern  :info  : [  219.656726] test_bpf: #186 ALU64_LSH_K: 1 << 1 = 2 jited:1 31 PASS
kern  :info  : [  219.664348] test_bpf: #187 ALU64_LSH_K: 1 << 31 = 0x80000000 jited:1 30 PASS
kern  :info  : [  219.672942] test_bpf: #188 ALU_RSH_X: 2 >> 1 = 1 jited:1 31 PASS
kern  :info  : [  219.680337] test_bpf: #189 ALU_RSH_X: 0x80000000 >> 31 = 1 jited:1 31 PASS
kern  :info  : [  219.688564] test_bpf: #190 ALU64_RSH_X: 2 >> 1 = 1 jited:1 28 PASS
kern  :info  : [  219.696200] test_bpf: #191 ALU64_RSH_X: 0x80000000 >> 31 = 1 jited:1 15 PASS
kern  :info  : [  219.704839] test_bpf: #192 ALU_RSH_K: 2 >> 1 = 1 jited:1 40 PASS
kern  :info  : [  219.712278] test_bpf: #193 ALU_RSH_K: 0x80000000 >> 31 = 1 jited:1 28 PASS
kern  :info  : [  219.720570] test_bpf: #194 ALU64_RSH_K: 2 >> 1 = 1 jited:1 14 PASS
kern  :info  : [  219.728130] test_bpf: #195 ALU64_RSH_K: 0x80000000 >> 31 = 1 jited:1 96 PASS
kern  :info  : [  219.736663] test_bpf: #196 ALU_ARSH_X: 0xff00ff0000000000 >> 40 = 0xffffffffffff00ff jited:1 43 PASS
kern  :info  : [  219.747440] test_bpf: #197 ALU_ARSH_K: 0xff00ff0000000000 >> 40 = 0xffffffffffff00ff jited:1 30 PASS
kern  :info  : [  219.758166] test_bpf: #198 ALU_NEG: -(3) = -3 jited:1 17 PASS
kern  :info  : [  219.765372] test_bpf: #199 ALU_NEG: -(-3) = 3 jited:1 14 PASS
kern  :info  : [  219.772531] test_bpf: #200 ALU64_NEG: -(3) = -3 jited:1 30 PASS
kern  :info  : [  219.779645] test_bpf: #201 ALU64_NEG: -(-3) = 3 jited:1 27 PASS
kern  :info  : [  219.786845] test_bpf: #202 ALU_END_FROM_BE 16: 0x0123456789abcdef -> 0xcdef jited:1 29 PASS
kern  :info  : [  219.796701] test_bpf: #203 ALU_END_FROM_BE 32: 0x0123456789abcdef -> 0x89abcdef jited:1 41 PASS
kern  :info  : [  219.806906] test_bpf: #204 ALU_END_FROM_BE 64: 0x0123456789abcdef -> 0x89abcdef jited:1 14 PASS
kern  :info  : [  219.816957] test_bpf: #205 ALU_END_FROM_LE 16: 0x0123456789abcdef -> 0xefcd jited:1 14 PASS
kern  :info  : [  219.826743] test_bpf: #206 ALU_END_FROM_LE 32: 0x0123456789abcdef -> 0xefcdab89 jited:1 15 PASS
kern  :info  : [  219.836890] test_bpf: #207 ALU_END_FROM_LE 64: 0x0123456789abcdef -> 0x67452301 jited:1 14 PASS
kern  :info  : [  219.846956] test_bpf: #208 ST_MEM_B: Store/Load byte: max negative jited:1 15 PASS
kern  :info  : [  219.855815] test_bpf: #209 ST_MEM_B: Store/Load byte: max positive jited:1 15 PASS
kern  :info  : [  219.864781] test_bpf: #210 STX_MEM_B: Store/Load byte: max negative jited:1 15 PASS
kern  :info  : [  219.873935] test_bpf: #211 ST_MEM_H: Store/Load half word: max negative jited:1 99 PASS
kern  :info  : [  219.883545] test_bpf: #212 ST_MEM_H: Store/Load half word: max positive jited:1 33 PASS
kern  :info  : [  219.892812] test_bpf: #213 STX_MEM_H: Store/Load half word: max negative jited:1 16 PASS
kern  :info  : [  219.902519] test_bpf: #214 ST_MEM_W: Store/Load word: max negative jited:1 31 PASS
kern  :info  : [  219.911221] test_bpf: #215 ST_MEM_W: Store/Load word: max positive jited:1 30 PASS
kern  :info  : [  219.920275] test_bpf: #216 STX_MEM_W: Store/Load word: max negative jited:1 15 PASS
kern  :info  : [  219.929085] test_bpf: #217 ST_MEM_DW: Store/Load double word: max negative jited:1 15 PASS
kern  :info  : [  219.938677] test_bpf: #218 ST_MEM_DW: Store/Load double word: max negative 2 jited:1 17 PASS
kern  :info  : [  219.948518] test_bpf: #219 ST_MEM_DW: Store/Load double word: max positive jited:1 15 PASS
kern  :info  : [  219.958086] test_bpf: #220 STX_MEM_DW: Store/Load double word: max negative jited:1 15 PASS
kern  :info  : [  219.967727] test_bpf: #221 STX_XADD_W: Test: 0x12 + 0x10 = 0x22 jited:1 35 PASS
kern  :info  : [  219.976311] test_bpf: #222 STX_XADD_W: Test side-effects, r10: 0x12 + 0x10 = 0x22 jited:1 PASS
kern  :info  : [  219.986519] test_bpf: #223 STX_XADD_W: Test side-effects, r0: 0x12 + 0x10 = 0x22 jited:1 37 PASS
kern  :info  : [  219.996645] test_bpf: #224 STX_XADD_W: X + 1 + 1 + 1 + ... jited:1 23331 PASS
kern  :info  : [  220.028577] test_bpf: #225 STX_XADD_DW: Test: 0x12 + 0x10 = 0x22 jited:1 38 PASS
kern  :info  : [  220.037256] test_bpf: #226 STX_XADD_DW: Test side-effects, r10: 0x12 + 0x10 = 0x22 jited:1 PASS
kern  :info  : [  220.047387] test_bpf: #227 STX_XADD_DW: Test side-effects, r0: 0x12 + 0x10 = 0x22 jited:1 23 PASS
kern  :info  : [  220.057627] test_bpf: #228 STX_XADD_DW: X + 1 + 1 + 1 + ... jited:1 23321 PASS
kern  :info  : [  220.089670] test_bpf: #229 JMP_EXIT jited:1 30 PASS
kern  :info  : [  220.095687] test_bpf: #230 JMP_JA: Unconditional jump: if (true) return 1 jited:1 16 PASS
kern  :info  : [  220.105089] test_bpf: #231 JMP_JSLT_K: Signed jump: if (-2 < -1) return 1 jited:1 16 PASS
kern  :info  : [  220.114639] test_bpf: #232 JMP_JSLT_K: Signed jump: if (-1 < -1) return 0 jited:1 31 PASS
kern  :info  : [  220.124095] test_bpf: #233 JMP_JSGT_K: Signed jump: if (-1 > -2) return 1 jited:1 16 PASS
kern  :info  : [  220.133667] test_bpf: #234 JMP_JSGT_K: Signed jump: if (-1 > -1) return 0 jited:1 15 PASS
kern  :info  : [  220.143020] test_bpf: #235 JMP_JSLE_K: Signed jump: if (-2 <= -1) return 1 jited:1 29 PASS
kern  :info  : [  220.152627] test_bpf: #236 JMP_JSLE_K: Signed jump: if (-1 <= -1) return 1 jited:1 30 PASS
kern  :info  : [  220.162193] test_bpf: #237 JMP_JSLE_K: Signed jump: value walk 1 jited:1 17 PASS
kern  :info  : [  220.170802] test_bpf: #238 JMP_JSLE_K: Signed jump: value walk 2 jited:1 44 PASS
kern  :info  : [  220.179597] test_bpf: #239 JMP_JSGE_K: Signed jump: if (-1 >= -2) return 1 jited:1 16 PASS
kern  :info  : [  220.189121] test_bpf: #240 JMP_JSGE_K: Signed jump: if (-1 >= -1) return 1 jited:1 35 PASS
kern  :info  : [  220.198646] test_bpf: #241 JMP_JSGE_K: Signed jump: value walk 1 jited:1 16 PASS
kern  :info  : [  220.207170] test_bpf: #242 JMP_JSGE_K: Signed jump: value walk 2 jited:1 33 PASS
kern  :info  : [  220.215748] test_bpf: #243 JMP_JGT_K: if (3 > 2) return 1 jited:1 16 PASS
kern  :info  : [  220.223806] test_bpf: #244 JMP_JGT_K: Unsigned jump: if (-1 > 1) return 1 jited:1 16 PASS
kern  :info  : [  220.233118] test_bpf: #245 JMP_JLT_K: if (2 < 3) return 1 jited:1 16 PASS
kern  :info  : [  220.241038] test_bpf: #246 JMP_JGT_K: Unsigned jump: if (1 < -1) return 1 jited:1 16 PASS
kern  :info  : [  220.250449] test_bpf: #247 JMP_JGE_K: if (3 >= 2) return 1 jited:1 16 PASS
kern  :info  : [  220.258656] test_bpf: #248 JMP_JLE_K: if (2 <= 3) return 1 jited:1 29 PASS
kern  :info  : [  220.266785] test_bpf: #249 JMP_JGT_K: if (3 > 2) return 1 (jump backwards) jited:1 16 PASS
kern  :info  : [  220.276386] test_bpf: #250 JMP_JGE_K: if (3 >= 3) return 1 jited:1 16 PASS
kern  :info  : [  220.284520] test_bpf: #251 JMP_JGT_K: if (2 < 3) return 1 (jump backwards) jited:1 30 PASS
kern  :info  : [  220.294064] test_bpf: #252 JMP_JLE_K: if (3 <= 3) return 1 jited:1 31 PASS
kern  :info  : [  220.302112] test_bpf: #253 JMP_JNE_K: if (3 != 2) return 1 jited:1 16 PASS
kern  :info  : [  220.310237] test_bpf: #254 JMP_JEQ_K: if (3 == 3) return 1 jited:1 48 PASS
kern  :info  : [  220.318375] test_bpf: #255 JMP_JSET_K: if (0x3 & 0x2) return 1 jited:1 17 PASS
kern  :info  : [  220.326768] test_bpf: #256 JMP_JSET_K: if (0x3 & 0xffffffff) return 1 jited:1 16 PASS
kern  :info  : [  220.335896] test_bpf: #257 JMP_JSGT_X: Signed jump: if (-1 > -2) return 1 jited:1 30 PASS
kern  :info  : [  220.345398] test_bpf: #258 JMP_JSGT_X: Signed jump: if (-1 > -1) return 0 jited:1 31 PASS
kern  :info  : [  220.354824] test_bpf: #259 JMP_JSLT_X: Signed jump: if (-2 < -1) return 1 jited:1 15 PASS
kern  :info  : [  220.364434] test_bpf: #260 JMP_JSLT_X: Signed jump: if (-1 < -1) return 0 jited:1 31 PASS
kern  :info  : [  220.373940] test_bpf: #261 JMP_JSGE_X: Signed jump: if (-1 >= -2) return 1 jited:1 16 PASS
kern  :info  : [  220.383575] test_bpf: #262 JMP_JSGE_X: Signed jump: if (-1 >= -1) return 1 jited:1 17 PASS
kern  :info  : [  220.393028] test_bpf: #263 JMP_JSLE_X: Signed jump: if (-2 <= -1) return 1 jited:1 16 PASS
kern  :info  : [  220.402676] test_bpf: #264 JMP_JSLE_X: Signed jump: if (-1 <= -1) return 1 jited:1 29 PASS
kern  :info  : [  220.412314] test_bpf: #265 JMP_JGT_X: if (3 > 2) return 1 jited:1 32 PASS
kern  :info  : [  220.420350] test_bpf: #266 JMP_JGT_X: Unsigned jump: if (-1 > 1) return 1 jited:1 33 PASS
kern  :info  : [  220.429941] test_bpf: #267 JMP_JLT_X: if (2 < 3) return 1 jited:1 15 PASS
kern  :info  : [  220.438007] test_bpf: #268 JMP_JLT_X: Unsigned jump: if (1 < -1) return 1 jited:1 16 PASS
kern  :info  : [  220.447284] test_bpf: #269 JMP_JGE_X: if (3 >= 2) return 1 jited:1 15 PASS
kern  :info  : [  220.455471] test_bpf: #270 JMP_JGE_X: if (3 >= 3) return 1 jited:1 16 PASS
kern  :info  : [  220.463517] test_bpf: #271 JMP_JLE_X: if (2 <= 3) return 1 jited:1 47 PASS
kern  :info  : [  220.471537] test_bpf: #272 JMP_JLE_X: if (3 <= 3) return 1 jited:1 48 PASS
kern  :info  : [  220.479407] test_bpf: #273 JMP_JGE_X: ldimm64 test 1 jited:1 15 PASS
kern  :info  : [  220.487041] test_bpf: #274 JMP_JGE_X: ldimm64 test 2 jited:1 16 PASS
kern  :info  : [  220.494563] test_bpf: #275 JMP_JGE_X: ldimm64 test 3 jited:1 15 PASS
kern  :info  : [  220.502257] test_bpf: #276 JMP_JLE_X: ldimm64 test 1 jited:1 15 PASS
kern  :info  : [  220.509756] test_bpf: #277 JMP_JLE_X: ldimm64 test 2 jited:1 15 PASS
kern  :info  : [  220.517118] test_bpf: #278 JMP_JLE_X: ldimm64 test 3 jited:1 46 PASS
kern  :info  : [  220.524727] test_bpf: #279 JMP_JNE_X: if (3 != 2) return 1 jited:1 31 PASS
kern  :info  : [  220.532981] test_bpf: #280 JMP_JEQ_X: if (3 == 3) return 1 jited:1 16 PASS
kern  :info  : [  220.541029] test_bpf: #281 JMP_JSET_X: if (0x3 & 0x2) return 1 jited:1 32 PASS
kern  :info  : [  220.549426] test_bpf: #282 JMP_JSET_X: if (0x3 & 0xffffffff) return 1 jited:1 16 PASS
kern  :info  : [  220.558609] test_bpf: #283 JMP_JA: Jump, gap, jump, ... jited:1 15 PASS
kern  :info  : [  220.566492] test_bpf: #284 BPF_MAXINSNS: Maximum possible literals jited:1 28 PASS
kern  :info  : [  220.576482] test_bpf: #285 BPF_MAXINSNS: Single literal jited:1 31 PASS
kern  :info  : [  220.585206] test_bpf: #286 BPF_MAXINSNS: Run/add until end jited:1 1270 PASS
kern  :info  : [  220.595248] test_bpf: #287 BPF_MAXINSNS: Too many instructions PASS
kern  :info  : [  220.602496] test_bpf: #288 BPF_MAXINSNS: Very long jump jited:1 16 PASS
kern  :info  : [  220.611388] test_bpf: #289 BPF_MAXINSNS: Ctx heavy transformations jited:1 882 924 PASS
kern  :info  : [  220.623139] test_bpf: #290 BPF_MAXINSNS: Call heavy transformations jited:1 15436 15275 PASS
kern  :info  : [  220.664413] test_bpf: #291 BPF_MAXINSNS: Jump heavy test jited:1 1157 PASS
kern  :info  : [  220.674935] test_bpf: #292 BPF_MAXINSNS: Very long jump backwards jited:1 28 PASS
kern  :info  : [  220.683870] test_bpf: #293 BPF_MAXINSNS: Edge hopping nuthouse jited:1 9467 PASS
kern  :info  : [  220.702435] test_bpf: #294 BPF_MAXINSNS: Jump, gap, jump, ...
kern  :warn  : [  220.703470] bpf_jit: disable optimizations for further passes
kern  :warn  : [  220.717031] UNEXPECTED_PASS
kern  :info  : [  220.717046] test_bpf: #295 BPF_MAXINSNS: jump over MSH PASS
kern  :info  : [  220.727738] test_bpf: #296 BPF_MAXINSNS: exec all MSH jited:1 7928 PASS
kern  :info  : [  220.747560] test_bpf: #297 BPF_MAXINSNS: ld_abs+get_processor_id jited:1 7861 PASS
kern  :info  : [  220.766620] test_bpf: #298 LD_IND byte frag jited:1 72 PASS
kern  :info  : [  220.773561] test_bpf: #299 LD_IND halfword frag jited:1 61 PASS
kern  :info  : [  220.780588] test_bpf: #300 LD_IND word frag jited:1 76 PASS
kern  :info  : [  220.787401] test_bpf: #301 LD_IND halfword mixed head/frag jited:1 53 PASS
kern  :info  : [  220.795281] test_bpf: #302 LD_IND word mixed head/frag jited:1 67 PASS
kern  :info  : [  220.803442] test_bpf: #303 LD_ABS byte frag jited:1 77 PASS
kern  :info  : [  220.810126] test_bpf: #304 LD_ABS halfword frag jited:1 46 PASS
kern  :info  : [  220.817107] test_bpf: #305 LD_ABS word frag jited:1 92 PASS
kern  :info  : [  220.823811] test_bpf: #306 LD_ABS halfword mixed head/frag jited:1 53 PASS
kern  :info  : [  220.831918] test_bpf: #307 LD_ABS word mixed head/frag jited:1 66 PASS
kern  :info  : [  220.839605] test_bpf: #308 LD_IND byte default X jited:1 21 PASS
kern  :info  : [  220.846694] test_bpf: #309 LD_IND byte positive offset jited:1 52 PASS
kern  :info  : [  220.854389] test_bpf: #310 LD_IND byte negative offset jited:1 20 PASS
kern  :info  : [  220.862023] test_bpf: #311 LD_IND byte positive offset, all ff jited:1 20 PASS
kern  :info  : [  220.870274] test_bpf: #312 LD_IND byte positive offset, out of bounds jited:1 36 PASS
kern  :info  : [  220.879245] test_bpf: #313 LD_IND byte negative offset, out of bounds jited:1 22 PASS
kern  :info  : [  220.888240] test_bpf: #314 LD_IND byte negative offset, multiple calls jited:1 67 PASS
kern  :info  : [  220.897522] test_bpf: #315 LD_IND halfword positive offset jited:1 19 PASS
kern  :info  : [  220.905500] test_bpf: #316 LD_IND halfword negative offset jited:1 19 PASS
kern  :info  : [  220.913499] test_bpf: #317 LD_IND halfword unaligned jited:1 19 PASS
kern  :info  : [  220.920943] test_bpf: #318 LD_IND halfword positive offset, all ff jited:1 19 PASS
kern  :info  : [  220.929701] test_bpf: #319 LD_IND halfword positive offset, out of bounds jited:1 20 PASS
kern  :info  : [  220.938959] test_bpf: #320 LD_IND halfword negative offset, out of bounds jited:1 46 PASS
kern  :info  : [  220.948384] test_bpf: #321 LD_IND word positive offset jited:1 31 PASS
kern  :info  : [  220.956441] test_bpf: #322 LD_IND word negative offset jited:1 58 PASS
kern  :info  : [  220.964354] test_bpf: #323 LD_IND word unaligned (addr & 3 == 2) jited:1 18 PASS
kern  :info  : [  220.972891] test_bpf: #324 LD_IND word unaligned (addr & 3 == 1) jited:1 19 PASS
kern  :info  : [  220.981433] test_bpf: #325 LD_IND word unaligned (addr & 3 == 3) jited:1 23 PASS
kern  :info  : [  220.990107] test_bpf: #326 LD_IND word positive offset, all ff jited:1 32 PASS
kern  :info  : [  220.998522] test_bpf: #327 LD_IND word positive offset, out of bounds jited:1 21 PASS
kern  :info  : [  221.007554] test_bpf: #328 LD_IND word negative offset, out of bounds jited:1 20 PASS
kern  :info  : [  221.016508] test_bpf: #329 LD_ABS byte jited:1 32 PASS
kern  :info  : [  221.022921] test_bpf: #330 LD_ABS byte positive offset, all ff jited:1 16 PASS
kern  :info  : [  221.031363] test_bpf: #331 LD_ABS byte positive offset, out of bounds jited:1 19 PASS
kern  :info  : [  221.040290] test_bpf: #332 LD_ABS byte negative offset, out of bounds load PASS
kern  :info  : [  221.048546] test_bpf: #333 LD_ABS byte negative offset, in bounds jited:1 34 PASS
kern  :info  : [  221.057356] test_bpf: #334 LD_ABS byte negative offset, out of bounds jited:1 21 PASS
kern  :info  : [  221.066369] test_bpf: #335 LD_ABS byte negative offset, multiple calls jited:1 66 PASS
kern  :info  : [  221.075602] test_bpf: #336 LD_ABS halfword jited:1 45 PASS
kern  :info  : [  221.082310] test_bpf: #337 LD_ABS halfword unaligned jited:1 17 PASS
kern  :info  : [  221.089952] test_bpf: #338 LD_ABS halfword positive offset, all ff jited:1 16 PASS
kern  :info  : [  221.098623] test_bpf: #339 LD_ABS halfword positive offset, out of bounds jited:1 19 PASS
kern  :info  : [  221.107986] test_bpf: #340 LD_ABS halfword negative offset, out of bounds load PASS
kern  :info  : [  221.116747] test_bpf: #341 LD_ABS halfword negative offset, in bounds jited:1 21 PASS
kern  :info  : [  221.125926] test_bpf: #342 LD_ABS halfword negative offset, out of bounds jited:1 34 PASS
kern  :info  : [  221.135322] test_bpf: #343 LD_ABS word jited:1 32 PASS
kern  :info  : [  221.141799] test_bpf: #344 LD_ABS word unaligned (addr & 3 == 2) jited:1 17 PASS
kern  :info  : [  221.150380] test_bpf: #345 LD_ABS word unaligned (addr & 3 == 1) jited:1 48 PASS
kern  :info  : [  221.158974] test_bpf: #346 LD_ABS word unaligned (addr & 3 == 3) jited:1 16 PASS
kern  :info  : [  221.167594] test_bpf: #347 LD_ABS word positive offset, all ff jited:1 32 PASS
kern  :info  : [  221.176128] test_bpf: #348 LD_ABS word positive offset, out of bounds jited:1 23 PASS
kern  :info  : [  221.185273] test_bpf: #349 LD_ABS word negative offset, out of bounds load PASS
kern  :info  : [  221.193698] test_bpf: #350 LD_ABS word negative offset, in bounds jited:1 21 PASS
kern  :info  : [  221.202599] test_bpf: #351 LD_ABS word negative offset, out of bounds jited:1 22 PASS
kern  :info  : [  221.211976] test_bpf: #352 LDX_MSH standalone, preserved A jited:1 16 PASS
kern  :info  : [  221.220091] test_bpf: #353 LDX_MSH standalone, preserved A 2 jited:1 31 PASS
kern  :info  : [  221.228501] test_bpf: #354 LDX_MSH standalone, test result 1 jited:1 18 PASS
kern  :info  : [  221.236753] test_bpf: #355 LDX_MSH standalone, test result 2 jited:1 32 PASS
kern  :info  : [  221.245028] test_bpf: #356 LDX_MSH standalone, negative offset jited:1 21 PASS
kern  :info  : [  221.253567] test_bpf: #357 LDX_MSH standalone, negative offset 2 jited:1 37 PASS
kern  :info  : [  221.262370] test_bpf: #358 LDX_MSH standalone, out of bounds jited:1 20 PASS
kern  :info  : [  221.270645] test_bpf: #359 ADD default X jited:1 15 PASS
kern  :info  : [  221.276943] test_bpf: #360 ADD default A jited:1 28 PASS
kern  :info  : [  221.283444] test_bpf: #361 SUB default X jited:1 28 PASS
kern  :info  : [  221.289940] test_bpf: #362 SUB default A jited:1 15 PASS
kern  :info  : [  221.296293] test_bpf: #363 MUL default X jited:1 15 PASS
kern  :info  : [  221.302735] test_bpf: #364 MUL default A jited:1 32 PASS
kern  :info  : [  221.308930] test_bpf: #365 DIV default X jited:1 15 PASS
kern  :info  : [  221.315126] test_bpf: #366 DIV default A jited:1 19 PASS
kern  :info  : [  221.321567] test_bpf: #367 MOD default X jited:1 15 PASS
kern  :info  : [  221.327878] test_bpf: #368 MOD default A jited:1 31 PASS
kern  :info  : [  221.334163] test_bpf: #369 JMP EQ default A jited:1 30 PASS
kern  :info  : [  221.340815] test_bpf: #370 JMP EQ default X jited:1 31 PASS
kern  :info  : [  221.347547] test_bpf: #371 JNE signed compare, test 1 jited:1 44 PASS
kern  :info  : [  221.355072] test_bpf: #372 JNE signed compare, test 2 jited:1 15 PASS
kern  :info  : [  221.362663] test_bpf: #373 JNE signed compare, test 3 jited:1 16 PASS
kern  :info  : [  221.370317] test_bpf: #374 JNE signed compare, test 4 jited:1 15 PASS
kern  :info  : [  221.377885] test_bpf: #375 JNE signed compare, test 5 jited:1 15 PASS
kern  :info  : [  221.385489] test_bpf: #376 JNE signed compare, test 6 jited:1 14 PASS
kern  :info  : [  221.393195] test_bpf: #377 JNE signed compare, test 7 jited:1 46 PASS
kern  :info  : [  221.400882] test_bpf: Summary: 377 PASSED, 1 FAILED, [365/365 JIT'ed]
user  :notice: [  221.434499] # test_bpf: [FAIL]

user  :notice: [  221.441834] not ok 9 selftests: net: test_bpf.sh # exit=1


To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp install job.yaml  # job file is attached in this email
        bin/lkp run     job.yaml



Thanks,
Oliver Sang


--5gxpn/Q6ypwruk0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-5.10.0-rc3-00844-gde900a241948"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.10.0-rc3 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-9 (Debian 9.3.0-15) 9.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=90300
CONFIG_LD_VERSION=235000000
CONFIG_CLANG_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_WATCH_QUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_USELIB=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_INJECTION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_IRQ_MSI_IOMMU=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# end of Timers subsystem

# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPTION=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_TASKS_RCU=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# end of RCU Subsystem

CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
# CONFIG_CGROUP_RDMA is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_RD_ZSTD=y
# CONFIG_BOOT_CONFIG is not set
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
# CONFIG_BPF_LSM is not set
CONFIG_BPF_SYSCALL=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
# CONFIG_BPF_PRELOAD is not set
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_RSEQ=y
# CONFIG_DEBUG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_MEMCG_SYSFS_ON is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=y
# CONFIG_SLAB_FREELIST_RANDOM is not set
# CONFIG_SLAB_FREELIST_HARDENED is not set
# CONFIG_SHUFFLE_PAGE_ALLOCATOR is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DYNAMIC_PHYSICAL_MASK=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
CONFIG_X86_CPU_RESCTRL=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_AMD_PLATFORM_DEVICE=y
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_XXL=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
CONFIG_XEN=y
CONFIG_XEN_PV=y
CONFIG_XEN_PV_SMP=y
# CONFIG_XEN_DOM0 is not set
CONFIG_XEN_PVHVM=y
CONFIG_XEN_PVHVM_SMP=y
CONFIG_XEN_512GB=y
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCELOG_LEGACY is not set
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_I8K=m
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_AMD_MEM_ENCRYPT=y
# CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_UMIP=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
# CONFIG_KEXEC_SIG is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_XONLY is not set
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
# end of Processor type and features

CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_HIBERNATION_SNAPSHOT_DEV=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_TAD is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=m
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_HMAT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_ACPI_DPTF is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_ACPI_CONFIGFS is not set
# CONFIG_PMIC_OPREGION is not set
CONFIG_X86_PM_TIMER=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_X86_SYSFB is not set
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
# end of Binary Emulations

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_APPLE_PROPERTIES=y
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y
CONFIG_EFI_DEV_PATH_PARSER=y
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_WERROR is not set
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
CONFIG_KVM_MMU_AUDIT=y
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y
CONFIG_AS_TPAUSE=y

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_GENERIC_ENTRY=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
# CONFIG_MODULE_COMPRESS is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=m
# CONFIG_BLK_DEV_ZONED is not set
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
# CONFIG_BLK_WBT is not set
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
# end of Partition Types

CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_PM=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
# CONFIG_IOSCHED_BFQ is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_AREAS=7
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_ZSWAP=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="lzo"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD=y
# CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD is not set
# CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC is not set
CONFIG_ZSWAP_ZPOOL_DEFAULT="zbud"
# CONFIG_ZSWAP_DEFAULT_ON is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
# CONFIG_ZSMALLOC_PGTABLE_MAPPING is not set
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ZONE_DEVICE=y
CONFIG_DEV_PAGEMAP_OPS=y
CONFIG_HMM_MIRROR=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_FRAME_VECTOR=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_PERCPU_STATS is not set
CONFIG_GUP_BENCHMARK=y
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_MAPPING_DIRTY_HELPERS=y
# end of Memory Management options

CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_NET_REDIRECT=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_UNIX_DIAG=m
CONFIG_TLS=m
# CONFIG_TLS_DEVICE is not set
# CONFIG_TLS_TOE is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_USER_COMPAT is not set
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_AH=m
CONFIG_XFRM_ESP=m
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_XDP_SOCKETS=y
# CONFIG_XDP_SOCKETS_DIAG is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=y
CONFIG_NET_FOU=y
CONFIG_NET_FOU_IP_TUNNELS=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
# CONFIG_INET_ESP_OFFLOAD is not set
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
# CONFIG_INET_RAW_DIAG is not set
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
# CONFIG_TCP_CONG_NV is not set
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
# CONFIG_TCP_CONG_BBR is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
# CONFIG_INET6_ESP_OFFLOAD is not set
# CONFIG_INET6_ESPINTCP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=y
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_FOU=y
CONFIG_IPV6_FOU_TUNNEL=y
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
# CONFIG_IPV6_SEG6_HMAC is not set
CONFIG_IPV6_SEG6_BPF=y
# CONFIG_IPV6_RPL_LWTUNNEL is not set
CONFIG_NETLABEL=y
CONFIG_MPTCP=y
CONFIG_INET_MPTCP_DIAG=m
CONFIG_MPTCP_IPV6=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_COMMON=m
# CONFIG_NF_LOG_NETDEV is not set
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
# CONFIG_NETFILTER_NETLINK_GLUE_CT is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=y
CONFIG_NF_TABLES_NETDEV=y
# CONFIG_NFT_NUMGEN is not set
CONFIG_NFT_CT=m
CONFIG_NFT_FLOW_OFFLOAD=m
CONFIG_NFT_COUNTER=m
# CONFIG_NFT_CONNLIMIT is not set
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
CONFIG_NFT_NAT=m
# CONFIG_NFT_TUNNEL is not set
CONFIG_NFT_OBJREF=m
CONFIG_NFT_QUEUE=m
# CONFIG_NFT_QUOTA is not set
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
# CONFIG_NFT_XFRM is not set
# CONFIG_NFT_SOCKET is not set
# CONFIG_NFT_OSF is not set
# CONFIG_NFT_TPROXY is not set
# CONFIG_NFT_SYNPROXY is not set
# CONFIG_NF_DUP_NETDEV is not set
# CONFIG_NFT_DUP_NETDEV is not set
# CONFIG_NFT_FWD_NETDEV is not set
# CONFIG_NFT_REJECT_NETDEV is not set
CONFIG_NF_FLOW_TABLE_INET=m
CONFIG_NF_FLOW_TABLE=m
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
CONFIG_NETFILTER_XT_MATCH_L2TP=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
# CONFIG_IP_VS_FO is not set
# CONFIG_IP_VS_OVF is not set
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_REJECT_IPV4=m
# CONFIG_NFT_DUP_IPV4 is not set
# CONFIG_NFT_FIB_IPV4 is not set
# CONFIG_NF_TABLES_ARP is not set
CONFIG_NF_FLOW_TABLE_IPV4=m
CONFIG_NF_DUP_IPV4=m
# CONFIG_NF_LOG_ARP is not set
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_REJECT_IPV6=m
# CONFIG_NFT_DUP_IPV6 is not set
# CONFIG_NFT_FIB_IPV6 is not set
CONFIG_NF_FLOW_TABLE_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
# CONFIG_NF_TABLES_BRIDGE is not set
# CONFIG_NF_CONNTRACK_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_BPFILTER is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y
# end of DCCP CCIDs Configuration

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# end of DCCP Kernel Hacking

CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
CONFIG_6LOWPAN_NHC=m
CONFIG_6LOWPAN_NHC_DEST=m
CONFIG_6LOWPAN_NHC_FRAGMENT=m
CONFIG_6LOWPAN_NHC_HOP=m
CONFIG_6LOWPAN_NHC_IPV6=m
CONFIG_6LOWPAN_NHC_MOBILITY=m
CONFIG_6LOWPAN_NHC_ROUTING=m
CONFIG_6LOWPAN_NHC_UDP=m
# CONFIG_6LOWPAN_GHC_EXT_HDR_HOP is not set
# CONFIG_6LOWPAN_GHC_UDP is not set
# CONFIG_6LOWPAN_GHC_ICMPV6 is not set
# CONFIG_6LOWPAN_GHC_EXT_HDR_DEST is not set
# CONFIG_6LOWPAN_GHC_EXT_HDR_FRAG is not set
# CONFIG_6LOWPAN_GHC_EXT_HDR_ROUTE is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
CONFIG_NET_SCH_ETF=m
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=m
# CONFIG_NET_SCH_CAKE is not set
CONFIG_NET_SCH_FQ=m
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=m
CONFIG_NET_SCH_ETS=m
# CONFIG_NET_SCH_DEFAULT is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_EMATCH_CANID=m
CONFIG_NET_EMATCH_IPSET=m
CONFIG_NET_EMATCH_IPT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_ACT_MPLS=m
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
CONFIG_NET_ACT_CONNMARK=m
CONFIG_NET_ACT_CTINFO=m
CONFIG_NET_ACT_SKBMOD=m
CONFIG_NET_ACT_IFE=m
CONFIG_NET_ACT_TUNNEL_KEY=m
CONFIG_NET_ACT_CT=m
# CONFIG_NET_ACT_GATE is not set
CONFIG_NET_IFE_SKBMARK=m
CONFIG_NET_IFE_SKBPRIO=m
CONFIG_NET_IFE_SKBTCINDEX=m
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_OPENVSWITCH_GENEVE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_HYPERV_VSOCKETS=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=m
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=m
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
# CONFIG_CAN_J1939 is not set
# CONFIG_CAN_ISOTP is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_F81601 is not set
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_PLX_PCI=m
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_SOFTING=m

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_CAN_MCP251XFD is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
CONFIG_CAN_8DEV_USB=m
CONFIG_CAN_EMS_USB=m
CONFIG_CAN_ESD_USB2=m
# CONFIG_CAN_GS_USB is not set
CONFIG_CAN_KVASER_USB=m
# CONFIG_CAN_MCBA_USB is not set
CONFIG_CAN_PEAK_USB=m
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
# end of CAN Device Drivers

CONFIG_BT=m
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m
CONFIG_BT_HS=y
CONFIG_BT_LE=y
# CONFIG_BT_6LOWPAN is not set
# CONFIG_BT_LEDS is not set
# CONFIG_BT_MSFTEXT is not set
CONFIG_BT_DEBUGFS=y
# CONFIG_BT_SELFTEST is not set

#
# Bluetooth device drivers
#
CONFIG_BT_INTEL=m
CONFIG_BT_BCM=m
CONFIG_BT_RTL=m
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTUSB_AUTOSUSPEND is not set
CONFIG_BT_HCIBTUSB_BCM=y
# CONFIG_BT_HCIBTUSB_MTK is not set
CONFIG_BT_HCIBTUSB_RTL=y
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_INTEL is not set
# CONFIG_BT_HCIUART_AG6XX is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
CONFIG_BT_ATH3K=m
# CONFIG_BT_MTKSDIO is not set
# end of Bluetooth device drivers

# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
CONFIG_NET_IFE=m
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_PAGE_POOL=y
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
# CONFIG_PCIE_DPC is not set
# CONFIG_PCIE_PTM is not set
# CONFIG_PCIE_BW is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_PCI_PF_STUB is not set
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
CONFIG_PCI_HYPERV=m
# CONFIG_PCIE_BUS_TUNE_OFF is not set
CONFIG_PCIE_BUS_DEFAULT=y
# CONFIG_PCIE_BUS_SAFE is not set
# CONFIG_PCIE_BUS_PERFORMANCE is not set
# CONFIG_PCIE_BUS_PEER2PEER is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y
CONFIG_PCI_HYPERV_INTERFACE=m

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set
# end of DesignWare PCI Core Support

#
# Mobiveil PCIe Core Support
#
# end of Mobiveil PCIe Core Support

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
# end of Firmware loader

CONFIG_WANT_DEV_COREDUMP=y
CONFIG_ALLOW_DEV_COREDUMP=y
CONFIG_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_SYS_HYPERVISOR=y
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# CONFIG_MHI_BUS is not set
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_GNSS is not set
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set

#
# Partition parsers
#
# CONFIG_MTD_AR7_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
# end of Partition parsers

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set
# end of RAM/ROM/Flash chip drivers

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
# end of Mapping drivers for chip access

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_MCHP23K256 is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# end of Self-contained MTD device drivers

#
# NAND
#
# CONFIG_MTD_ONENAND is not set
# CONFIG_MTD_RAW_NAND is not set
# CONFIG_MTD_SPI_NAND is not set

#
# ECC engine support
#
# end of ECC engine support
# end of NAND

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# end of LPDDR & LPDDR2 PCM memory drivers

# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_MTD_HYPERBUS is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_FD=m
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
CONFIG_ZRAM=m
# CONFIG_ZRAM_WRITEBACK is not set
# CONFIG_ZRAM_MEMORY_TRACKING is not set
# CONFIG_BLK_DEV_UMEM is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SKD is not set
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
# CONFIG_NVME_MULTIPATH is not set
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
CONFIG_NVME_FC=m
# CONFIG_NVME_TCP is not set
CONFIG_NVME_TARGET=m
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=m
CONFIG_NVME_TARGET_FC=m
CONFIG_NVME_TARGET_FCLOOP=m
# CONFIG_NVME_TARGET_TCP is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_PVPANIC=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_VIRTIO is not set
# CONFIG_INTEL_MEI_HDCP is not set
CONFIG_VMWARE_VMCI=m
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_MISC_ALCOR_PCI is not set
# CONFIG_MISC_RTSX_PCI is not set
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# CONFIG_UACCE is not set
# end of Misc devices

CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_CXGB3_ISCSI=m
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=m
# CONFIG_SCSI_AIC7XXX is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=m
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=m
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=m
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS=m
# CONFIG_SCSI_SMARTPQI is not set
CONFIG_SCSI_UFSHCD=m
CONFIG_SCSI_UFSHCD_PCI=m
# CONFIG_SCSI_UFS_DWC_TC_PCI is not set
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
# CONFIG_SCSI_UFS_BSG is not set
CONFIG_SCSI_HPTIOP=m
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
CONFIG_VMWARE_PVSCSI=m
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_HYPERV_STORAGE=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=m
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=m
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
CONFIG_SCSI_STEX=m
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
CONFIG_TCM_QLA2XXX=m
# CONFIG_TCM_QLA2XXX_DEBUG is not set
CONFIG_SCSI_QLA_ISCSI=m
# CONFIG_QEDI is not set
# CONFIG_QEDF is not set
CONFIG_SCSI_LPFC=m
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_PMCRAID=m
CONFIG_SCSI_PM8001=m
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=m
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_FORCE=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_SVW=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_ATP867X=m
CONFIG_PATA_CMD64X=m
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=m
CONFIG_PATA_IT821X=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=m
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_PDC_OLD=m
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=m
CONFIG_PATA_SCH=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_TOSHIBA=m
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=m
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=m
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=m
# CONFIG_MD_CLUSTER is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
# CONFIG_DM_WRITECACHE is not set
# CONFIG_DM_EBS is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_MULTIPATH_HST is not set
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
# CONFIG_DM_INTEGRITY is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=m
CONFIG_ISCSI_TARGET_CXGB4=m
# CONFIG_SBP_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=m
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=y
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_IFB=y
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
# CONFIG_IPVLAN is not set
CONFIG_VXLAN=y
CONFIG_GENEVE=y
# CONFIG_BAREUDP is not set
# CONFIG_GTP is not set
CONFIG_MACSEC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_NTB_NETDEV=m
CONFIG_TUN=m
CONFIG_TAP=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=y
CONFIG_VIRTIO_NET=m
CONFIG_NLMON=m
CONFIG_NET_VRF=y
CONFIG_VSOCKMON=m
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# Distributed Switch Architecture drivers
#
# end of Distributed Switch Architecture drivers

CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
CONFIG_ENA_ETHERNET=m
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_AMD_XGBE=m
# CONFIG_AMD_XGBE_DCB is not set
CONFIG_AMD_XGBE_HAVE_ECC=y
CONFIG_NET_VENDOR_AQUANTIA=y
CONFIG_AQTION=m
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
CONFIG_ALX=m
CONFIG_NET_VENDOR_AURORA=y
# CONFIG_AURORA_NB8800 is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_BCMGENET is not set
CONFIG_BNX2=m
CONFIG_CNIC=m
# CONFIG_TIGON3 is not set
CONFIG_BNX2X=m
CONFIG_BNX2X_SRIOV=y
# CONFIG_SYSTEMPORT is not set
CONFIG_BNXT=m
CONFIG_BNXT_SRIOV=y
CONFIG_BNXT_FLOWER_OFFLOAD=y
CONFIG_BNXT_DCB=y
CONFIG_BNXT_HWMON=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=m
CONFIG_NET_VENDOR_CADENCE=y
CONFIG_MACB=m
CONFIG_MACB_USE_HWSTAMP=y
# CONFIG_MACB_PCI is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
CONFIG_LIQUIDIO=m
CONFIG_LIQUIDIO_VF=m
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=m
CONFIG_CHELSIO_T4=m
# CONFIG_CHELSIO_T4_DCB is not set
CONFIG_CHELSIO_T4VF=m
CONFIG_CHELSIO_LIB=m
CONFIG_CHELSIO_INLINE_CRYPTO=y
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_CX_ECAT is not set
CONFIG_DNET=m
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
CONFIG_BE2NET_HWMON=y
CONFIG_BE2NET_BE2=y
CONFIG_BE2NET_BE3=y
CONFIG_BE2NET_LANCER=y
CONFIG_BE2NET_SKYHAWK=y
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_GOOGLE=y
# CONFIG_GVE is not set
CONFIG_NET_VENDOR_HUAWEI=y
# CONFIG_HINIC is not set
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGBVF=m
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBEVF=m
CONFIG_I40E=y
CONFIG_I40E_DCB=y
CONFIG_IAVF=m
CONFIG_I40EVF=m
# CONFIG_ICE is not set
CONFIG_FM10K=m
# CONFIG_IGC is not set
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=m
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_PRESTERA is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=m
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_MLX4_CORE_GEN2=y
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NFP=m
CONFIG_NFP_APP_FLOWER=y
CONFIG_NFP_APP_ABM_NIC=y
# CONFIG_NFP_DEBUG is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_ETHOC=m
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
CONFIG_QLCNIC=m
CONFIG_QLCNIC_SRIOV=y
CONFIG_QLCNIC_DCB=y
CONFIG_QLCNIC_HWMON=y
CONFIG_NETXEN_NIC=m
CONFIG_QED=m
CONFIG_QED_SRIOV=y
CONFIG_QEDE=m
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_ROCKER=m
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
CONFIG_SFC=m
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_SFC_MCDI_LOGGING=y
CONFIG_SFC_FALCON=m
CONFIG_SFC_FALCON_MTD=y
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_EPIC100=m
# CONFIG_SMSC911X is not set
CONFIG_SMSC9420=m
CONFIG_NET_VENDOR_SOCIONEXT=y
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
CONFIG_TLAN=m
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLINK=m
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set
CONFIG_FIXED_PHY=y
# CONFIG_SFP is not set

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=m
# CONFIG_ADIN_PHY is not set
# CONFIG_AQUANTIA_PHY is not set
# CONFIG_AX88796B_PHY is not set
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM54140_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM84881_PHY is not set
CONFIG_BCM87XX_PHY=m
CONFIG_BCM_NET_PHYLIB=m
CONFIG_CICADA_PHY=m
# CONFIG_CORTINA_PHY is not set
CONFIG_DAVICOM_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_LXT_PHY=m
# CONFIG_INTEL_XWAY_PHY is not set
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MARVELL_PHY=m
# CONFIG_MARVELL_10G_PHY is not set
CONFIG_MICREL_PHY=m
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
CONFIG_NATIONAL_PHY=m
# CONFIG_NXP_TJA11XX_PHY is not set
CONFIG_QSEMI_PHY=m
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
CONFIG_SMSC_PHY=m
CONFIG_STE10XP=m
# CONFIG_TERANETICS_PHY is not set
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
CONFIG_VITESSE_PHY=m
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_MDIO_DEVRES=y
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_BCM_UNIMAC is not set
# CONFIG_MDIO_GPIO is not set
# CONFIG_MDIO_MVUSB is not set
# CONFIG_MDIO_MSCC_MIIM is not set
# CONFIG_MDIO_THUNDER is not set

#
# MDIO Multiplexers
#

#
# PCS device drivers
#
# CONFIG_PCS_XPCS is not set
# end of PCS device drivers

# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
CONFIG_PPTP=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_USB_NET_DRIVERS=y
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=m
# CONFIG_USB_LAN78XX is not set
# CONFIG_USB_USBNET is not set
CONFIG_USB_HSO=m
# CONFIG_USB_IPHETH is not set
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_ATH_COMMON=m
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K_BTCOEX_SUPPORT=y
# CONFIG_ATH9K is not set
CONFIG_ATH9K_HTC=m
# CONFIG_ATH9K_HTC_DEBUGFS is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
# CONFIG_ATH11K is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLEGACY=m
CONFIG_IWL4965=m
CONFIG_IWL3945=m

#
# iwl3945 / iwl4965 Debugging Options
#
CONFIG_IWLEGACY_DEBUG=y
CONFIG_IWLEGACY_DEBUGFS=y
# end of iwl3945 / iwl4965 Debugging Options

CONFIG_IWLWIFI=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLDVM=m
CONFIG_IWLMVM=m
CONFIG_IWLWIFI_OPMODE_MODULAR=y
# CONFIG_IWLWIFI_BCAST_FILTERING is not set

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLWIFI_DEBUGFS=y
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
# end of Debugging Options

CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_PRISM54 is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
# CONFIG_MT7601U is not set
# CONFIG_MT76x0U is not set
# CONFIG_MT76x0E is not set
# CONFIG_MT76x2E is not set
# CONFIG_MT76x2U is not set
# CONFIG_MT7603E is not set
# CONFIG_MT7615E is not set
# CONFIG_MT7663U is not set
# CONFIG_MT7663S is not set
# CONFIG_MT7915E is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_RTL_CARDS is not set
# CONFIG_RTL8XXXU is not set
# CONFIG_RTW88 is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_VIRT_WIFI is not set
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKELB=m
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set
CONFIG_XEN_NETDEV_FRONTEND=m
CONFIG_VMXNET3=m
CONFIG_FUJITSU_ES=m
CONFIG_HYPERV_NET=m
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m
CONFIG_ISDN=y
CONFIG_ISDN_CAPI=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
CONFIG_MISDN_HFCUSB=m
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
CONFIG_MISDN_W6692=m
CONFIG_MISDN_NETJET=m
CONFIG_MISDN_HDLC=m
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
# CONFIG_NVM is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_CYAPA=m
# CONFIG_MOUSE_ELAN_I2C is not set
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_MOUSE_SYNAPTICS_USB=m
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
# CONFIG_TABLET_USB_PEGASUS is not set
# CONFIG_TABLET_SERIAL_WACOM4 is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_PROPERTIES=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ADC is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_BU21029 is not set
# CONFIG_TOUCHSCREEN_CHIPONE_ICN8505 is not set
# CONFIG_TOUCHSCREEN_CY8CTMA140 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX_SERIAL is not set
# CONFIG_TOUCHSCREEN_EXC3000 is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GOODIX is not set
# CONFIG_TOUCHSCREEN_HIDEEP is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_S6SY761 is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_EKTF2127 is not set
# CONFIG_TOUCHSCREEN_ELAN is not set
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MELFAS_MIP4 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WDT87XX_I2C is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2004 is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_RM_TS is not set
# CONFIG_TOUCHSCREEN_SILEAD is not set
# CONFIG_TOUCHSCREEN_SIS_I2C is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_STMFTS is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
# CONFIG_TOUCHSCREEN_SURFACE3_SPI is not set
# CONFIG_TOUCHSCREEN_SX8654 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZET6223 is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_TOUCHSCREEN_ROHM_BU21023 is not set
# CONFIG_TOUCHSCREEN_IQS5XX is not set
# CONFIG_TOUCHSCREEN_ZINITIX is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_E3X0_BUTTON is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_DECODER is not set
# CONFIG_INPUT_GPIO_VIBRA is not set
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
# CONFIG_INPUT_PWM_VIBRA is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_IQS269A is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set
CONFIG_RMI4_CORE=m
# CONFIG_RMI4_I2C is not set
# CONFIG_RMI4_SPI is not set
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
# CONFIG_RMI4_F34 is not set
# CONFIG_RMI4_F3A is not set
# CONFIG_RMI4_F54 is not set
# CONFIG_RMI4_F55 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_HYPERV_KEYBOARD=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_LDISC_AUTOLOAD=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_NOZOMI=m
# CONFIG_NULL_TTY is not set
# CONFIG_TRACE_SINK is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_DEVMEM=y
# CONFIG_DEVKMEM is not set
CONFIG_NVRAM=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_DEVPORT=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TCG_XEN is not set
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=m
CONFIG_TCG_TIS_ST33ZP24_I2C=m
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# end of Character devices

# CONFIG_RANDOM_TRUST_CPU is not set
# CONFIG_RANDOM_TRUST_BOOTLOADER is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
# CONFIG_I2C_MUX_MLXCPLD is not set
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_AMD_MP2 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_MLXCPLD is not set
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_LANTIQ_SSC is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set
# CONFIG_SPI_AMD is not set

#
# SPI Multiplexer support
#
# CONFIG_SPI_MUX is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
CONFIG_SPI_DYNAMIC=y
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=m
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_VMW is not set
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_AMD=m
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
CONFIG_PINCTRL_INTEL=y
# CONFIG_PINCTRL_BROXTON is not set
CONFIG_PINCTRL_CANNONLAKE=m
# CONFIG_PINCTRL_CEDARFORK is not set
CONFIG_PINCTRL_DENVERTON=m
# CONFIG_PINCTRL_EMMITSBURG is not set
CONFIG_PINCTRL_GEMINILAKE=m
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_JASPERLAKE is not set
CONFIG_PINCTRL_LEWISBURG=m
CONFIG_PINCTRL_SUNRISEPOINT=m
# CONFIG_PINCTRL_TIGERLAKE is not set

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_AMDPT=m
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_XILINX is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCA9570 is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
CONFIG_GPIO_VIPERBOARD=m
# end of USB GPIO expanders

# CONFIG_GPIO_AGGREGATOR is not set
CONFIG_GPIO_MOCKUP=m
# CONFIG_W1 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_BQ25980 is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_CHARGER_BD99954 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
# CONFIG_SENSORS_AMD_ENERGY is not set
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_CORSAIR_CPRO is not set
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IIO_HWMON is not set
# CONFIG_SENSORS_I5500 is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_MR75203 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX16601 is not set
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_DEVFREQ_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_PKG_TEMP_THERMAL=m
CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=m
CONFIG_ACPI_THERMAL_REL=m
# CONFIG_INT3406_THERMAL is not set
CONFIG_PROC_THERMAL_MMIO_RAPL=y
# end of ACPI INT340X thermal drivers

# CONFIG_INTEL_PCH_THERMAL is not set
# end of Intel thermal drivers

# CONFIG_GENERIC_ADC_THERMAL is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set
CONFIG_XEN_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6360 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=m
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SL28CPLD is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_INTEL_M10_BMC is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_LIRC=y
CONFIG_RC_DECODERS=y
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_SHARP_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
# CONFIG_IR_XMP_DECODER is not set
CONFIG_IR_IMON_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=m
CONFIG_IR_ENE=m
CONFIG_IR_IMON=m
# CONFIG_IR_IMON_RAW is not set
CONFIG_IR_MCEUSB=m
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
CONFIG_IR_REDRAT3=m
CONFIG_IR_STREAMZAP=m
CONFIG_IR_WINBOND_CIR=m
# CONFIG_IR_IGORPLUGUSB is not set
CONFIG_IR_IGUANA=m
CONFIG_IR_TTUSBIR=m
CONFIG_RC_LOOPBACK=m
# CONFIG_IR_SERIAL is not set
# CONFIG_IR_SIR is not set
# CONFIG_RC_XBOX_DVD is not set
# CONFIG_IR_TOY is not set
# CONFIG_MEDIA_CEC_SUPPORT is not set
CONFIG_MEDIA_SUPPORT=m
# CONFIG_MEDIA_SUPPORT_FILTER is not set
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Media device types
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_SDR_SUPPORT=y
CONFIG_MEDIA_PLATFORM_SUPPORT=y
CONFIG_MEDIA_TEST_SUPPORT=y
# end of Media device types

#
# Media core support
#
CONFIG_VIDEO_DEV=m
CONFIG_MEDIA_CONTROLLER=y
CONFIG_DVB_CORE=m
# end of Media core support

#
# Video4Linux options
#
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L2_I2C=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
# end of Video4Linux options

#
# Media controller options
#
CONFIG_MEDIA_CONTROLLER_DVB=y
# end of Media controller options

#
# Digital TV options
#
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=y
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set
# CONFIG_DVB_ULE_DEBUG is not set
# end of Digital TV options

#
# Media drivers
#
CONFIG_TTPCI_EEPROM=m
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
# CONFIG_USB_GSPCA_DTCS033 is not set
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
# CONFIG_USB_GSPCA_KINECT is not set
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
# CONFIG_USB_GSPCA_STK1135 is not set
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TOPRO=m
# CONFIG_USB_GSPCA_TOUPTEK is not set
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
# CONFIG_VIDEO_CPIA2 is not set
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
# CONFIG_VIDEO_USBTV is not set

#
# Analog TV USB devices
#
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=m
# CONFIG_VIDEO_STK1160_COMMON is not set
# CONFIG_VIDEO_GO7007 is not set

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_AU0828_V4L2=y
# CONFIG_VIDEO_AU0828_RC is not set
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
CONFIG_VIDEO_TM6000=m
CONFIG_VIDEO_TM6000_ALSA=m
CONFIG_VIDEO_TM6000_DVB=m

#
# Digital TV USB devices
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_DIB3000MC=m
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
# CONFIG_DVB_USB_CXUSB_ANALOG is not set
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_PCTV452E=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_AZ6027=m
CONFIG_DVB_USB_TECHNISAT_USB2=m
CONFIG_DVB_USB_V2=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_AF9035=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_AZ6007=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_LME2510=m
CONFIG_DVB_USB_MXL111SF=m
CONFIG_DVB_USB_RTL28XXU=m
# CONFIG_DVB_USB_DVBSKY is not set
# CONFIG_DVB_USB_ZD1301 is not set
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_SMS_USB_DRV=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set
# CONFIG_DVB_AS102 is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
# CONFIG_VIDEO_EM28XX_V4L2 is not set
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_EM28XX_RC=m

#
# Software defined radio USB devices
#
# CONFIG_USB_AIRSPY is not set
# CONFIG_USB_HACKRF is not set
# CONFIG_USB_MSI2500 is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
# CONFIG_VIDEO_MEYE is not set
# CONFIG_VIDEO_SOLO6X10 is not set
# CONFIG_VIDEO_TW5864 is not set
# CONFIG_VIDEO_TW68 is not set
# CONFIG_VIDEO_TW686X is not set

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=m
# CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS is not set
# CONFIG_VIDEO_IVTV_ALSA is not set
CONFIG_VIDEO_FB_IVTV=m
# CONFIG_VIDEO_FB_IVTV_FORCE_PAT is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DT3155 is not set

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CX18_ALSA=m
CONFIG_VIDEO_CX23885=m
CONFIG_MEDIA_ALTERA_CI=m
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_ENABLE_VP3054=y
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_BT848=m
CONFIG_DVB_BT8XX=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_SAA7164=m

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110_IR=y
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
# CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
CONFIG_DVB_PLUTO2=m
CONFIG_DVB_DM1105=m
CONFIG_DVB_PT1=m
# CONFIG_DVB_PT3 is not set
CONFIG_MANTIS_CORE=m
CONFIG_DVB_MANTIS=m
CONFIG_DVB_HOPPER=m
CONFIG_DVB_NGENE=m
CONFIG_DVB_DDBRIDGE=m
# CONFIG_DVB_DDBRIDGE_MSIENABLE is not set
# CONFIG_DVB_SMIPCIE is not set
# CONFIG_DVB_NETUP_UNIDVB is not set
# CONFIG_VIDEO_IPU3_CIO2 is not set
# CONFIG_VIDEO_PCI_SKELETON is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=m
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_CYPRESS_FIRMWARE=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_V4L2=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEOBUF2_DMA_SG=m
CONFIG_VIDEOBUF2_DVB=m
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_SMS_SIANO_MDTV=m
CONFIG_SMS_SIANO_RC=y
# CONFIG_SMS_SIANO_DEBUGFS is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set
# CONFIG_SDR_PLATFORM_DRIVERS is not set

#
# MMC/SDIO DVB adapters
#
CONFIG_SMS_SDIO_DRV=m
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_TEST_DRIVERS is not set

#
# FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
# end of Media drivers

#
# Media ancillary drivers
#
CONFIG_MEDIA_ATTACH=y

#
# IR I2C driver auto-selected by 'Autoselect ancillary drivers'
#
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TDA1997X is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS3308=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
# CONFIG_VIDEO_SONY_BTF_MPX is not set
# end of Audio decoders, processors and mixers

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m
# end of RDS decoders

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_ADV7604 is not set
# CONFIG_VIDEO_ADV7842 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=m
# CONFIG_VIDEO_TC358743 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_TW9910 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m
# end of Video decoders

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_ADV7511 is not set
# CONFIG_VIDEO_AD9389B is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set
# end of Video encoders

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
# end of Video improvement chips

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m
# end of Audio/Video compression chips

#
# SDR tuner chips
#
# CONFIG_SDR_MAX2175 is not set
# end of SDR tuner chips

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
CONFIG_VIDEO_M52790=m
# CONFIG_VIDEO_I2C is not set
# CONFIG_VIDEO_ST_MIPID02 is not set
# end of Miscellaneous helper chips

#
# Camera sensor devices
#
# CONFIG_VIDEO_HI556 is not set
# CONFIG_VIDEO_IMX214 is not set
# CONFIG_VIDEO_IMX219 is not set
# CONFIG_VIDEO_IMX258 is not set
# CONFIG_VIDEO_IMX274 is not set
# CONFIG_VIDEO_IMX290 is not set
# CONFIG_VIDEO_IMX319 is not set
# CONFIG_VIDEO_IMX355 is not set
# CONFIG_VIDEO_OV2640 is not set
# CONFIG_VIDEO_OV2659 is not set
# CONFIG_VIDEO_OV2680 is not set
# CONFIG_VIDEO_OV2685 is not set
# CONFIG_VIDEO_OV2740 is not set
# CONFIG_VIDEO_OV5647 is not set
# CONFIG_VIDEO_OV6650 is not set
# CONFIG_VIDEO_OV5670 is not set
# CONFIG_VIDEO_OV5675 is not set
# CONFIG_VIDEO_OV5695 is not set
# CONFIG_VIDEO_OV7251 is not set
# CONFIG_VIDEO_OV772X is not set
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_OV7740 is not set
# CONFIG_VIDEO_OV8856 is not set
# CONFIG_VIDEO_OV9640 is not set
# CONFIG_VIDEO_OV9650 is not set
# CONFIG_VIDEO_OV13858 is not set
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9M001 is not set
# CONFIG_VIDEO_MT9M032 is not set
# CONFIG_VIDEO_MT9M111 is not set
# CONFIG_VIDEO_MT9P031 is not set
# CONFIG_VIDEO_MT9T001 is not set
# CONFIG_VIDEO_MT9T112 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_MT9V032 is not set
# CONFIG_VIDEO_MT9V111 is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_NOON010PC30 is not set
# CONFIG_VIDEO_M5MOLS is not set
# CONFIG_VIDEO_RDACM20 is not set
# CONFIG_VIDEO_RJ54N1 is not set
# CONFIG_VIDEO_S5K6AA is not set
# CONFIG_VIDEO_S5K6A3 is not set
# CONFIG_VIDEO_S5K4ECGX is not set
# CONFIG_VIDEO_S5K5BAF is not set
# CONFIG_VIDEO_SMIAPP is not set
# CONFIG_VIDEO_ET8EK8 is not set
# CONFIG_VIDEO_S5C73M3 is not set
# end of Camera sensor devices

#
# Lens drivers
#
# CONFIG_VIDEO_AD5820 is not set
# CONFIG_VIDEO_AK7375 is not set
# CONFIG_VIDEO_DW9714 is not set
# CONFIG_VIDEO_DW9768 is not set
# CONFIG_VIDEO_DW9807_VCM is not set
# end of Lens drivers

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set
# end of Flash devices

#
# SPI helper chips
#
# CONFIG_VIDEO_GS1662 is not set
# end of SPI helper chips

#
# Media SPI Adapters
#
# CONFIG_CXD2880_SPI_DRV is not set
# end of Media SPI Adapters

CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA18250=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
# CONFIG_MEDIA_TUNER_MSI001 is not set
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88RS6000T=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m
# CONFIG_MEDIA_TUNER_MXL301RF is not set
CONFIG_MEDIA_TUNER_QM1D1C0042=m
CONFIG_MEDIA_TUNER_QM1D1B0004=m
# end of Customize TV tuners

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV0910=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_STV6111=m
CONFIG_DVB_MXL5XX=m
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m
CONFIG_DVB_MN88472=m
CONFIG_DVB_MN88473=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_CX24120=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
# CONFIG_DVB_S5H1432 is not set
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
# CONFIG_DVB_DIB9000 is not set
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_CXD2841ER=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_RTL2832_SDR=m
CONFIG_DVB_SI2168=m
# CONFIG_DVB_ZD1301_DEMOD is not set
CONFIG_DVB_GP8PSK_FE=m
# CONFIG_DVB_CXD2880 is not set

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LGDT3306A=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=m
# CONFIG_DVB_MN88443X is not set

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBH25=m
# CONFIG_DVB_LNBH29 is not set
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m
# CONFIG_DVB_HORUS3A is not set
# CONFIG_DVB_ASCOT2E is not set
# CONFIG_DVB_HELENE is not set

#
# Common Interface (EN50221) controller drivers
#
CONFIG_DVB_CXD2099=m
# CONFIG_DVB_SP2 is not set
# end of Customise DVB Frontends

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m
# end of Media ancillary drivers

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DEBUG_MM is not set
CONFIG_DRM_DEBUG_SELFTEST=m
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_TTM_DMA_PAGE_POOL=y
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
CONFIG_DRM_I915_GVT=y
CONFIG_DRM_I915_GVT_KVMGT=m

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_DEBUG_MMIO is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# end of drm/i915 Debugging

#
# drm/i915 Profile Guided Optimisation
#
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# end of drm/i915 Profile Guided Optimisation

CONFIG_DRM_VGEM=y
# CONFIG_DRM_VKMS is not set
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
CONFIG_DRM_UDL=m
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_QXL=m
CONFIG_DRM_BOCHS=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_GM12U320 is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_ILI9486 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_XEN is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_EXPORT_FOR_TESTS=y
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_LIB_RANDOM=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_KTD253 is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_PCM_ELD=y
CONFIG_SND_HWDEP=m
CONFIG_SND_SEQ_DEVICE=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_PCM_TIMER=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_PROC_FS=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_SEQUENCER_OSS=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_SEQ_MIDI_EVENT=m
CONFIG_SND_SEQ_MIDI=m
CONFIG_SND_SEQ_MIDI_EMUL=m
CONFIG_SND_SEQ_VIRMIDI=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL3_LIB_SEQ=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=5
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=m
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_ES1968_RADIO=y
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LOLA=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=m
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=m
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=m
CONFIG_SND_HDA_GENERIC_LEDS=y
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=0
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=m
CONFIG_SND_HDA_CODEC_ANALOG=m
CONFIG_SND_HDA_CODEC_SIGMATEL=m
CONFIG_SND_HDA_CODEC_VIA=m
CONFIG_SND_HDA_CODEC_HDMI=m
CONFIG_SND_HDA_CODEC_CIRRUS=m
CONFIG_SND_HDA_CODEC_CONEXANT=m
CONFIG_SND_HDA_CODEC_CA0110=m
CONFIG_SND_HDA_CODEC_CA0132=m
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=m
CONFIG_SND_HDA_CODEC_SI3054=m
CONFIG_SND_HDA_GENERIC=m
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_HDA_INTEL_HDMI_SILENT_STREAM is not set
# end of HD-Audio

CONFIG_SND_HDA_CORE=m
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_COMPONENT=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_EXT_CORE=m
CONFIG_SND_HDA_PREALLOC_SIZE=512
CONFIG_SND_INTEL_NHLT=y
CONFIG_SND_INTEL_DSP_CONFIG=m
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER=y
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_USB_6FIRE=m
CONFIG_SND_USB_HIFACE=m
CONFIG_SND_BCD2000=m
CONFIG_SND_USB_LINE6=m
CONFIG_SND_USB_POD=m
CONFIG_SND_USB_PODHD=m
CONFIG_SND_USB_TONEPORT=m
CONFIG_SND_USB_VARIAX=m
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
# CONFIG_SND_DICE is not set
# CONFIG_SND_OXFW is not set
CONFIG_SND_ISIGHT=m
# CONFIG_SND_FIREWORKS is not set
# CONFIG_SND_BEBOB is not set
# CONFIG_SND_FIREWIRE_DIGI00X is not set
# CONFIG_SND_FIREWIRE_TASCAM is not set
# CONFIG_SND_FIREWIRE_MOTU is not set
# CONFIG_SND_FIREFACE is not set
CONFIG_SND_SOC=m
CONFIG_SND_SOC_COMPRESS=y
CONFIG_SND_SOC_TOPOLOGY=y
CONFIG_SND_SOC_ACPI=m
# CONFIG_SND_SOC_AMD_ACP is not set
# CONFIG_SND_SOC_AMD_ACP3x is not set
# CONFIG_SND_SOC_AMD_RENOIR is not set
# CONFIG_SND_ATMEL_SOC is not set
# CONFIG_SND_BCM63XX_I2S_WHISTLER is not set
# CONFIG_SND_DESIGNWARE_I2S is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
# CONFIG_SND_SOC_FSL_ASRC is not set
# CONFIG_SND_SOC_FSL_SAI is not set
# CONFIG_SND_SOC_FSL_AUDMIX is not set
# CONFIG_SND_SOC_FSL_SSI is not set
# CONFIG_SND_SOC_FSL_SPDIF is not set
# CONFIG_SND_SOC_FSL_ESAI is not set
# CONFIG_SND_SOC_FSL_MICFIL is not set
# CONFIG_SND_SOC_IMX_AUDMUX is not set
# end of SoC Audio for Freescale CPUs

# CONFIG_SND_I2S_HI6210_I2S is not set
# CONFIG_SND_SOC_IMG is not set
CONFIG_SND_SOC_INTEL_SST_TOPLEVEL=y
CONFIG_SND_SOC_INTEL_SST=m
# CONFIG_SND_SOC_INTEL_CATPT is not set
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM=m
# CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_PCI is not set
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_ACPI=m
CONFIG_SND_SOC_INTEL_SKYLAKE=m
CONFIG_SND_SOC_INTEL_SKL=m
CONFIG_SND_SOC_INTEL_APL=m
CONFIG_SND_SOC_INTEL_KBL=m
CONFIG_SND_SOC_INTEL_GLK=m
CONFIG_SND_SOC_INTEL_CNL=m
CONFIG_SND_SOC_INTEL_CFL=m
# CONFIG_SND_SOC_INTEL_CML_H is not set
# CONFIG_SND_SOC_INTEL_CML_LP is not set
CONFIG_SND_SOC_INTEL_SKYLAKE_FAMILY=m
CONFIG_SND_SOC_INTEL_SKYLAKE_SSP_CLK=m
# CONFIG_SND_SOC_INTEL_SKYLAKE_HDAUDIO_CODEC is not set
CONFIG_SND_SOC_INTEL_SKYLAKE_COMMON=m
CONFIG_SND_SOC_ACPI_INTEL_MATCH=m
CONFIG_SND_SOC_INTEL_MACH=y
# CONFIG_SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES is not set
CONFIG_SND_SOC_INTEL_BYTCR_RT5640_MACH=m
CONFIG_SND_SOC_INTEL_BYTCR_RT5651_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5672_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5645_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_MAX98090_TI_MACH=m
# CONFIG_SND_SOC_INTEL_CHT_BSW_NAU8824_MACH is not set
# CONFIG_SND_SOC_INTEL_BYT_CHT_CX2072X_MACH is not set
CONFIG_SND_SOC_INTEL_BYT_CHT_DA7213_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_ES8316_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_NOCODEC_MACH=m
CONFIG_SND_SOC_INTEL_SKL_RT286_MACH=m
CONFIG_SND_SOC_INTEL_SKL_NAU88L25_SSM4567_MACH=m
CONFIG_SND_SOC_INTEL_SKL_NAU88L25_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_DA7219_MAX98357A_GENERIC=m
CONFIG_SND_SOC_INTEL_BXT_DA7219_MAX98357A_COMMON=m
CONFIG_SND_SOC_INTEL_BXT_DA7219_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_BXT_RT298_MACH=m
CONFIG_SND_SOC_INTEL_KBL_RT5663_MAX98927_MACH=m
CONFIG_SND_SOC_INTEL_KBL_RT5663_RT5514_MAX98927_MACH=m
# CONFIG_SND_SOC_INTEL_KBL_DA7219_MAX98357A_MACH is not set
# CONFIG_SND_SOC_INTEL_KBL_DA7219_MAX98927_MACH is not set
# CONFIG_SND_SOC_INTEL_KBL_RT5660_MACH is not set
# CONFIG_SND_SOC_MTK_BTCVSD is not set
# CONFIG_SND_SOC_SOF_TOPLEVEL is not set

#
# STMicroelectronics STM32 SOC audio support
#
# end of STMicroelectronics STM32 SOC audio support

# CONFIG_SND_SOC_XILINX_I2S is not set
# CONFIG_SND_SOC_XILINX_AUDIO_FORMATTER is not set
# CONFIG_SND_SOC_XILINX_SPDIF is not set
# CONFIG_SND_SOC_XTFPGA_I2S is not set
# CONFIG_ZX_TDM is not set
CONFIG_SND_SOC_I2C_AND_SPI=m

#
# CODEC drivers
#
# CONFIG_SND_SOC_AC97_CODEC is not set
# CONFIG_SND_SOC_ADAU1701 is not set
# CONFIG_SND_SOC_ADAU1761_I2C is not set
# CONFIG_SND_SOC_ADAU1761_SPI is not set
# CONFIG_SND_SOC_ADAU7002 is not set
# CONFIG_SND_SOC_ADAU7118_HW is not set
# CONFIG_SND_SOC_ADAU7118_I2C is not set
# CONFIG_SND_SOC_AK4104 is not set
# CONFIG_SND_SOC_AK4118 is not set
# CONFIG_SND_SOC_AK4458 is not set
# CONFIG_SND_SOC_AK4554 is not set
# CONFIG_SND_SOC_AK4613 is not set
# CONFIG_SND_SOC_AK4642 is not set
# CONFIG_SND_SOC_AK5386 is not set
# CONFIG_SND_SOC_AK5558 is not set
# CONFIG_SND_SOC_ALC5623 is not set
# CONFIG_SND_SOC_BD28623 is not set
# CONFIG_SND_SOC_BT_SCO is not set
# CONFIG_SND_SOC_CS35L32 is not set
# CONFIG_SND_SOC_CS35L33 is not set
# CONFIG_SND_SOC_CS35L34 is not set
# CONFIG_SND_SOC_CS35L35 is not set
# CONFIG_SND_SOC_CS35L36 is not set
# CONFIG_SND_SOC_CS42L42 is not set
# CONFIG_SND_SOC_CS42L51_I2C is not set
# CONFIG_SND_SOC_CS42L52 is not set
# CONFIG_SND_SOC_CS42L56 is not set
# CONFIG_SND_SOC_CS42L73 is not set
# CONFIG_SND_SOC_CS4234 is not set
# CONFIG_SND_SOC_CS4265 is not set
# CONFIG_SND_SOC_CS4270 is not set
# CONFIG_SND_SOC_CS4271_I2C is not set
# CONFIG_SND_SOC_CS4271_SPI is not set
# CONFIG_SND_SOC_CS42XX8_I2C is not set
# CONFIG_SND_SOC_CS43130 is not set
# CONFIG_SND_SOC_CS4341 is not set
# CONFIG_SND_SOC_CS4349 is not set
# CONFIG_SND_SOC_CS53L30 is not set
# CONFIG_SND_SOC_CX2072X is not set
CONFIG_SND_SOC_DA7213=m
CONFIG_SND_SOC_DA7219=m
CONFIG_SND_SOC_DMIC=m
# CONFIG_SND_SOC_ES7134 is not set
# CONFIG_SND_SOC_ES7241 is not set
CONFIG_SND_SOC_ES8316=m
# CONFIG_SND_SOC_ES8328_I2C is not set
# CONFIG_SND_SOC_ES8328_SPI is not set
# CONFIG_SND_SOC_GTM601 is not set
CONFIG_SND_SOC_HDAC_HDMI=m
# CONFIG_SND_SOC_INNO_RK3036 is not set
# CONFIG_SND_SOC_MAX98088 is not set
CONFIG_SND_SOC_MAX98090=m
CONFIG_SND_SOC_MAX98357A=m
# CONFIG_SND_SOC_MAX98504 is not set
# CONFIG_SND_SOC_MAX9867 is not set
CONFIG_SND_SOC_MAX98927=m
# CONFIG_SND_SOC_MAX98373_I2C is not set
CONFIG_SND_SOC_MAX98390=m
# CONFIG_SND_SOC_MAX9860 is not set
# CONFIG_SND_SOC_MSM8916_WCD_DIGITAL is not set
# CONFIG_SND_SOC_PCM1681 is not set
# CONFIG_SND_SOC_PCM1789_I2C is not set
# CONFIG_SND_SOC_PCM179X_I2C is not set
# CONFIG_SND_SOC_PCM179X_SPI is not set
# CONFIG_SND_SOC_PCM186X_I2C is not set
# CONFIG_SND_SOC_PCM186X_SPI is not set
# CONFIG_SND_SOC_PCM3060_I2C is not set
# CONFIG_SND_SOC_PCM3060_SPI is not set
# CONFIG_SND_SOC_PCM3168A_I2C is not set
# CONFIG_SND_SOC_PCM3168A_SPI is not set
# CONFIG_SND_SOC_PCM512x_I2C is not set
# CONFIG_SND_SOC_PCM512x_SPI is not set
# CONFIG_SND_SOC_RK3328 is not set
CONFIG_SND_SOC_RL6231=m
CONFIG_SND_SOC_RL6347A=m
CONFIG_SND_SOC_RT286=m
CONFIG_SND_SOC_RT298=m
CONFIG_SND_SOC_RT5514=m
CONFIG_SND_SOC_RT5514_SPI=m
# CONFIG_SND_SOC_RT5616 is not set
# CONFIG_SND_SOC_RT5631 is not set
CONFIG_SND_SOC_RT5640=m
CONFIG_SND_SOC_RT5645=m
CONFIG_SND_SOC_RT5651=m
CONFIG_SND_SOC_RT5663=m
CONFIG_SND_SOC_RT5670=m
# CONFIG_SND_SOC_SGTL5000 is not set
# CONFIG_SND_SOC_SIMPLE_AMPLIFIER is not set
# CONFIG_SND_SOC_SIRF_AUDIO_CODEC is not set
# CONFIG_SND_SOC_SPDIF is not set
# CONFIG_SND_SOC_SSM2305 is not set
# CONFIG_SND_SOC_SSM2602_SPI is not set
# CONFIG_SND_SOC_SSM2602_I2C is not set
CONFIG_SND_SOC_SSM4567=m
# CONFIG_SND_SOC_STA32X is not set
# CONFIG_SND_SOC_STA350 is not set
# CONFIG_SND_SOC_STI_SAS is not set
# CONFIG_SND_SOC_TAS2552 is not set
# CONFIG_SND_SOC_TAS2562 is not set
# CONFIG_SND_SOC_TAS2764 is not set
# CONFIG_SND_SOC_TAS2770 is not set
# CONFIG_SND_SOC_TAS5086 is not set
# CONFIG_SND_SOC_TAS571X is not set
# CONFIG_SND_SOC_TAS5720 is not set
# CONFIG_SND_SOC_TAS6424 is not set
# CONFIG_SND_SOC_TDA7419 is not set
# CONFIG_SND_SOC_TFA9879 is not set
# CONFIG_SND_SOC_TLV320AIC23_I2C is not set
# CONFIG_SND_SOC_TLV320AIC23_SPI is not set
# CONFIG_SND_SOC_TLV320AIC31XX is not set
# CONFIG_SND_SOC_TLV320AIC32X4_I2C is not set
# CONFIG_SND_SOC_TLV320AIC32X4_SPI is not set
# CONFIG_SND_SOC_TLV320AIC3X is not set
# CONFIG_SND_SOC_TLV320ADCX140 is not set
CONFIG_SND_SOC_TS3A227E=m
# CONFIG_SND_SOC_TSCS42XX is not set
# CONFIG_SND_SOC_TSCS454 is not set
# CONFIG_SND_SOC_UDA1334 is not set
# CONFIG_SND_SOC_WM8510 is not set
# CONFIG_SND_SOC_WM8523 is not set
# CONFIG_SND_SOC_WM8524 is not set
# CONFIG_SND_SOC_WM8580 is not set
# CONFIG_SND_SOC_WM8711 is not set
# CONFIG_SND_SOC_WM8728 is not set
# CONFIG_SND_SOC_WM8731 is not set
# CONFIG_SND_SOC_WM8737 is not set
# CONFIG_SND_SOC_WM8741 is not set
# CONFIG_SND_SOC_WM8750 is not set
# CONFIG_SND_SOC_WM8753 is not set
# CONFIG_SND_SOC_WM8770 is not set
# CONFIG_SND_SOC_WM8776 is not set
# CONFIG_SND_SOC_WM8782 is not set
# CONFIG_SND_SOC_WM8804_I2C is not set
# CONFIG_SND_SOC_WM8804_SPI is not set
# CONFIG_SND_SOC_WM8903 is not set
# CONFIG_SND_SOC_WM8904 is not set
# CONFIG_SND_SOC_WM8960 is not set
# CONFIG_SND_SOC_WM8962 is not set
# CONFIG_SND_SOC_WM8974 is not set
# CONFIG_SND_SOC_WM8978 is not set
# CONFIG_SND_SOC_WM8985 is not set
# CONFIG_SND_SOC_ZL38060 is not set
# CONFIG_SND_SOC_ZX_AUD96P22 is not set
# CONFIG_SND_SOC_MAX9759 is not set
# CONFIG_SND_SOC_MT6351 is not set
# CONFIG_SND_SOC_MT6358 is not set
# CONFIG_SND_SOC_MT6660 is not set
# CONFIG_SND_SOC_NAU8540 is not set
# CONFIG_SND_SOC_NAU8810 is not set
# CONFIG_SND_SOC_NAU8822 is not set
CONFIG_SND_SOC_NAU8824=m
CONFIG_SND_SOC_NAU8825=m
# CONFIG_SND_SOC_TPA6130A2 is not set
# end of CODEC drivers

# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SND_X86=y
CONFIG_HDMI_LPE_AUDIO=m
CONFIG_SND_SYNTH_EMUX=m
# CONFIG_SND_XEN_FRONTEND is not set
CONFIG_AC97_BUS=m

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=m
# CONFIG_HID_ASUS is not set
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=y
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
CONFIG_HID_PRODIKEYS=m
# CONFIG_HID_CMEDIA is not set
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_GEMBIRD is not set
# CONFIG_HID_GFRM is not set
# CONFIG_HID_GLORIOUS is not set
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
# CONFIG_HID_VIVALDI is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=y
# CONFIG_HID_JABRA is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
CONFIG_HID_REDRAGON=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NTI is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=y
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# CONFIG_HID_MCP2221 is not set
# end of Special HID drivers

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y
# end of USB HID support

#
# I2C HID support
#
CONFIG_I2C_HID=m
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=y
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_FEW_INIT_RETRIES is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_PRODUCTLIST is not set
# CONFIG_USB_OTG_DISABLE_EXTERNAL_HUB is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=m
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PCI_RENESAS is not set
# CONFIG_USB_XHCI_PLATFORM is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
CONFIG_USBIP_CORE=m
# CONFIG_USBIP_VHCI_HCD is not set
# CONFIG_USBIP_HOST is not set
# CONFIG_USBIP_DEBUG is not set
# CONFIG_USB_CDNS3 is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
# CONFIG_USB_SERIAL_MXUPORT is not set
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_QT2=m
# CONFIG_USB_SERIAL_UPD78F0730 is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
# CONFIG_APPLE_MFI_FASTCHARGE is not set
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
# CONFIG_USB_HUB_USB251XB is not set
CONFIG_USB_HSIC_USB3503=m
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_TYPEC_TPS6598X is not set
# CONFIG_TYPEC_STUSB160X is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SPI is not set
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_CLASS_MULTICOLOR is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
# CONFIG_LEDS_LP50XX is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
# CONFIG_LEDS_MLXCPLD is not set
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=m
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_GHES=y
CONFIG_EDAC_AMD64=m
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
# CONFIG_EDAC_I10NM is not set
CONFIG_EDAC_PND2=m
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV3032 is not set
# CONFIG_RTC_DRV_RV8803 is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RX6110 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
CONFIG_RTC_DRV_RV3029_HWMON=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
# CONFIG_INTEL_IDMA64 is not set
# CONFIG_INTEL_IDXD is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_XILINX_ZYNQMP_DPDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
# CONFIG_DW_EDMA_PCIE is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
# CONFIG_UDMABUF is not set
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_SELFTESTS is not set
# CONFIG_DMABUF_HEAPS is not set
# end of DMABUF options

CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
# CONFIG_HD44780 is not set
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
# CONFIG_IMG_ASCII_LCD is not set
# CONFIG_PARPORT_PANEL is not set
# CONFIG_CHARLCD_BL_OFF is not set
# CONFIG_CHARLCD_BL_ON is not set
CONFIG_CHARLCD_BL_FLASH=y
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_UIO_HV_GENERIC=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_MDEV=m
CONFIG_VFIO_MDEV_DEVICE=m
CONFIG_IRQ_BYPASS_MANAGER=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_PCI_LEGACY=y
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MEM=m
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=m
# CONFIG_VDPA is not set
CONFIG_VHOST_IOTLB=m
CONFIG_VHOST=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_TIMER=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m
# end of Microsoft Hyper-V guest support

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not set
CONFIG_XEN_SCRUB_PAGES_DEFAULT=y
CONFIG_XEN_DEV_EVTCHN=m
# CONFIG_XEN_BACKEND is not set
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
# CONFIG_XEN_GRANT_DMA_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
# CONFIG_XEN_PVCALLS_FRONTEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
CONFIG_XEN_HAVE_VPMU=y
# CONFIG_XEN_UNPOPULATED_ALLOC is not set
# end of Xen driver support

# CONFIG_GREYBUS is not set
CONFIG_STAGING=y
# CONFIG_PRISM2_USB is not set
# CONFIG_COMEDI is not set
# CONFIG_RTL8192U is not set
CONFIG_RTLLIB=m
CONFIG_RTLLIB_CRYPTO_CCMP=m
CONFIG_RTLLIB_CRYPTO_TKIP=m
CONFIG_RTLLIB_CRYPTO_WEP=m
CONFIG_RTL8192E=m
# CONFIG_RTL8723BS is not set
CONFIG_R8712U=m
# CONFIG_R8188EU is not set
# CONFIG_RTS5208 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# CONFIG_ADIS16203 is not set
# CONFIG_ADIS16240 is not set
# end of Accelerometers

#
# Analog to digital converters
#
# CONFIG_AD7816 is not set
# CONFIG_AD7280 is not set
# end of Analog to digital converters

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set
# end of Analog digital bi-direction converters

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7746 is not set
# end of Capacitance to digital converters

#
# Direct Digital Synthesis
#
# CONFIG_AD9832 is not set
# CONFIG_AD9834 is not set
# end of Direct Digital Synthesis

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set
# end of Network Analyzer, Impedance Converters

#
# Active energy metering IC
#
# CONFIG_ADE7854 is not set
# end of Active energy metering IC

#
# Resolver to digital converters
#
# CONFIG_AD2S1210 is not set
# end of Resolver to digital converters
# end of IIO staging drivers

# CONFIG_FB_SM750 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ASHMEM is not set
CONFIG_ION=y
CONFIG_ION_SYSTEM_HEAP=y
# CONFIG_ION_CMA_HEAP is not set
# end of Android

# CONFIG_LTE_GDM724X is not set
CONFIG_FIREWIRE_SERIAL=m
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
# CONFIG_GS_FPGABOOT is not set
# CONFIG_UNISYSSPAR is not set
# CONFIG_FB_TFT is not set
# CONFIG_KS7010 is not set
# CONFIG_PI433 is not set

#
# Gasket devices
#
# CONFIG_STAGING_GASKET_FRAMEWORK is not set
# end of Gasket devices

# CONFIG_FIELDBUS_DEV is not set
# CONFIG_KPC2000 is not set
CONFIG_QLGE=m
# CONFIG_WIMAX is not set
# CONFIG_WFX is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_ALIENWARE_WMI is not set
# CONFIG_HUAWEI_WMI is not set
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m
CONFIG_MXM_WMI=m
# CONFIG_PEAQ_WMI is not set
# CONFIG_XIAOMI_WMI is not set
CONFIG_ACERHDF=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACER_WMI=m
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
CONFIG_DCDBAS=m
CONFIG_DELL_SMBIOS=m
CONFIG_DELL_SMBIOS_WMI=y
CONFIG_DELL_SMBIOS_SMM=y
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_RBTN=m
CONFIG_DELL_RBU=m
CONFIG_DELL_SMO8800=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_DESCRIPTOR=m
CONFIG_DELL_WMI_AIO=m
# CONFIG_DELL_WMI_LED is not set
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
CONFIG_HP_WIRELESS=m
CONFIG_HP_WMI=m
# CONFIG_IBM_RTL is not set
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_SENSORS_HDAPS=m
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_INTEL_ATOMISP2_PM is not set
CONFIG_INTEL_HID_EVENT=m
# CONFIG_INTEL_INT0002_VGPIO is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_INTEL_OAKTRAIL=m
CONFIG_INTEL_VBTN=m
# CONFIG_SURFACE3_WMI is not set
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_PCENGINES_APU2 is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
CONFIG_COMPAL_LAPTOP=m
# CONFIG_LG_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_SYSTEM76_ACPI is not set
CONFIG_TOPSTAR_LAPTOP=m
# CONFIG_I2C_MULTI_INSTANTIATE is not set
# CONFIG_MLX_PLATFORM is not set
CONFIG_INTEL_IPS=m
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set

#
# Intel Speed Select Technology interface support
#
# CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
# end of Intel Speed Select Technology interface support

# CONFIG_INTEL_TURBO_MAX_3 is not set
# CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set
CONFIG_INTEL_PMC_CORE=m
# CONFIG_INTEL_PUNIT_IPC is not set
# CONFIG_INTEL_SCU_PCI is not set
# CONFIG_INTEL_SCU_PLATFORM is not set
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
# CONFIG_MELLANOX_PLATFORM is not set
CONFIG_HAVE_CLK=y
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOASID=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_V2=m
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
# CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON is not set
CONFIG_IRQ_REMAP=y
CONFIG_HYPERV_IOMMU=y

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Aspeed SoC drivers
#
# end of Aspeed SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# CONFIG_XILINX_VCU is not set
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set
# CONFIG_DEVFREQ_GOV_PASSIVE is not set

#
# DEVFREQ Drivers
#
# CONFIG_PM_DEVFREQ_EVENT is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
# CONFIG_IIO_BUFFER_DMA is not set
# CONFIG_IIO_BUFFER_DMAENGINE is not set
# CONFIG_IIO_BUFFER_HW_CONSUMER is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=m
# CONFIG_IIO_CONFIGFS is not set
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
# CONFIG_IIO_SW_DEVICE is not set
# CONFIG_IIO_SW_TRIGGER is not set
# CONFIG_IIO_TRIGGERED_EVENT is not set

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16209 is not set
# CONFIG_ADXL345_I2C is not set
# CONFIG_ADXL345_SPI is not set
# CONFIG_ADXL372_SPI is not set
# CONFIG_ADXL372_I2C is not set
# CONFIG_BMA180 is not set
# CONFIG_BMA220 is not set
# CONFIG_BMA400 is not set
# CONFIG_BMC150_ACCEL is not set
# CONFIG_DA280 is not set
# CONFIG_DA311 is not set
# CONFIG_DMARD09 is not set
# CONFIG_DMARD10 is not set
CONFIG_HID_SENSOR_ACCEL_3D=m
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
# CONFIG_KXSD9 is not set
# CONFIG_KXCJK1013 is not set
# CONFIG_MC3230 is not set
# CONFIG_MMA7455_I2C is not set
# CONFIG_MMA7455_SPI is not set
# CONFIG_MMA7660 is not set
# CONFIG_MMA8452 is not set
# CONFIG_MMA9551 is not set
# CONFIG_MMA9553 is not set
# CONFIG_MXC4005 is not set
# CONFIG_MXC6255 is not set
# CONFIG_SCA3000 is not set
# CONFIG_STK8312 is not set
# CONFIG_STK8BA50 is not set
# end of Accelerometers

#
# Analog to digital converters
#
# CONFIG_AD7091R5 is not set
# CONFIG_AD7124 is not set
# CONFIG_AD7192 is not set
# CONFIG_AD7266 is not set
# CONFIG_AD7291 is not set
# CONFIG_AD7292 is not set
# CONFIG_AD7298 is not set
# CONFIG_AD7476 is not set
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD7606_IFACE_SPI is not set
# CONFIG_AD7766 is not set
# CONFIG_AD7768_1 is not set
# CONFIG_AD7780 is not set
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
# CONFIG_AD7923 is not set
# CONFIG_AD7949 is not set
# CONFIG_AD799X is not set
# CONFIG_AD9467 is not set
# CONFIG_ADI_AXI_ADC is not set
# CONFIG_HI8435 is not set
# CONFIG_HX711 is not set
# CONFIG_INA2XX_ADC is not set
# CONFIG_LTC2471 is not set
# CONFIG_LTC2485 is not set
# CONFIG_LTC2496 is not set
# CONFIG_LTC2497 is not set
# CONFIG_MAX1027 is not set
# CONFIG_MAX11100 is not set
# CONFIG_MAX1118 is not set
# CONFIG_MAX1241 is not set
# CONFIG_MAX1363 is not set
# CONFIG_MAX9611 is not set
# CONFIG_MCP320X is not set
# CONFIG_MCP3422 is not set
# CONFIG_MCP3911 is not set
# CONFIG_NAU7802 is not set
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_ADC0832 is not set
# CONFIG_TI_ADC084S021 is not set
# CONFIG_TI_ADC12138 is not set
# CONFIG_TI_ADC108S102 is not set
# CONFIG_TI_ADC128S052 is not set
# CONFIG_TI_ADC161S626 is not set
# CONFIG_TI_ADS1015 is not set
# CONFIG_TI_ADS7950 is not set
# CONFIG_TI_TLC4541 is not set
# CONFIG_VIPERBOARD_ADC is not set
# CONFIG_XILINX_XADC is not set
# end of Analog to digital converters

#
# Analog Front Ends
#
# end of Analog Front Ends

#
# Amplifiers
#
# CONFIG_AD8366 is not set
# CONFIG_HMC425 is not set
# end of Amplifiers

#
# Chemical Sensors
#
# CONFIG_ATLAS_PH_SENSOR is not set
# CONFIG_ATLAS_EZO_SENSOR is not set
# CONFIG_BME680 is not set
# CONFIG_CCS811 is not set
# CONFIG_IAQCORE is not set
# CONFIG_SCD30_CORE is not set
# CONFIG_SENSIRION_SGP30 is not set
# CONFIG_SPS30 is not set
# CONFIG_VZ89X is not set
# end of Chemical Sensors

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
# end of Hid Sensor IIO Common

#
# SSP Sensor Common
#
# CONFIG_IIO_SSP_SENSORHUB is not set
# end of SSP Sensor Common

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
# CONFIG_AD5446 is not set
# CONFIG_AD5449 is not set
# CONFIG_AD5592R is not set
# CONFIG_AD5593R is not set
# CONFIG_AD5504 is not set
# CONFIG_AD5624R_SPI is not set
# CONFIG_AD5686_SPI is not set
# CONFIG_AD5696_I2C is not set
# CONFIG_AD5755 is not set
# CONFIG_AD5758 is not set
# CONFIG_AD5761 is not set
# CONFIG_AD5764 is not set
# CONFIG_AD5770R is not set
# CONFIG_AD5791 is not set
# CONFIG_AD7303 is not set
# CONFIG_AD8801 is not set
# CONFIG_DS4424 is not set
# CONFIG_LTC1660 is not set
# CONFIG_LTC2632 is not set
# CONFIG_M62332 is not set
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set
# CONFIG_MCP4922 is not set
# CONFIG_TI_DAC082S085 is not set
# CONFIG_TI_DAC5571 is not set
# CONFIG_TI_DAC7311 is not set
# CONFIG_TI_DAC7612 is not set
# end of Digital to analog converters

#
# IIO dummy driver
#
# end of IIO dummy driver

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set
# end of Clock Generator/Distribution

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set
# CONFIG_ADF4371 is not set
# end of Phase-Locked Loop (PLL) frequency synthesizers
# end of Frequency Synthesizers DDS/PLL

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
# CONFIG_ADIS16136 is not set
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS290 is not set
# CONFIG_ADXRS450 is not set
# CONFIG_BMG160 is not set
# CONFIG_FXAS21002C is not set
CONFIG_HID_SENSOR_GYRO_3D=m
# CONFIG_MPU3050_I2C is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set
# end of Digital gyroscope sensors

#
# Health Sensors
#

#
# Heart Rate Monitors
#
# CONFIG_AFE4403 is not set
# CONFIG_AFE4404 is not set
# CONFIG_MAX30100 is not set
# CONFIG_MAX30102 is not set
# end of Heart Rate Monitors
# end of Health Sensors

#
# Humidity sensors
#
# CONFIG_AM2315 is not set
# CONFIG_DHT11 is not set
# CONFIG_HDC100X is not set
# CONFIG_HDC2010 is not set
# CONFIG_HID_SENSOR_HUMIDITY is not set
# CONFIG_HTS221 is not set
# CONFIG_HTU21 is not set
# CONFIG_SI7005 is not set
# CONFIG_SI7020 is not set
# end of Humidity sensors

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
# CONFIG_ADIS16460 is not set
# CONFIG_ADIS16475 is not set
# CONFIG_ADIS16480 is not set
# CONFIG_BMI160_I2C is not set
# CONFIG_BMI160_SPI is not set
# CONFIG_FXOS8700_I2C is not set
# CONFIG_FXOS8700_SPI is not set
# CONFIG_KMX61 is not set
# CONFIG_INV_ICM42600_I2C is not set
# CONFIG_INV_ICM42600_SPI is not set
# CONFIG_INV_MPU6050_I2C is not set
# CONFIG_INV_MPU6050_SPI is not set
# CONFIG_IIO_ST_LSM6DSX is not set
# end of Inertial measurement units

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
# CONFIG_ADJD_S311 is not set
# CONFIG_ADUX1020 is not set
# CONFIG_AL3010 is not set
# CONFIG_AL3320A is not set
# CONFIG_APDS9300 is not set
# CONFIG_APDS9960 is not set
# CONFIG_AS73211 is not set
# CONFIG_BH1750 is not set
# CONFIG_BH1780 is not set
# CONFIG_CM32181 is not set
# CONFIG_CM3232 is not set
# CONFIG_CM3323 is not set
# CONFIG_CM36651 is not set
# CONFIG_GP2AP002 is not set
# CONFIG_GP2AP020A00F is not set
# CONFIG_SENSORS_ISL29018 is not set
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_ISL29125 is not set
CONFIG_HID_SENSOR_ALS=m
CONFIG_HID_SENSOR_PROX=m
# CONFIG_JSA1212 is not set
# CONFIG_RPR0521 is not set
# CONFIG_LTR501 is not set
# CONFIG_LV0104CS is not set
# CONFIG_MAX44000 is not set
# CONFIG_MAX44009 is not set
# CONFIG_NOA1305 is not set
# CONFIG_OPT3001 is not set
# CONFIG_PA12203001 is not set
# CONFIG_SI1133 is not set
# CONFIG_SI1145 is not set
# CONFIG_STK3310 is not set
# CONFIG_ST_UVIS25 is not set
# CONFIG_TCS3414 is not set
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL2772 is not set
# CONFIG_TSL4531 is not set
# CONFIG_US5182D is not set
# CONFIG_VCNL4000 is not set
# CONFIG_VCNL4035 is not set
# CONFIG_VEML6030 is not set
# CONFIG_VEML6070 is not set
# CONFIG_VL6180 is not set
# CONFIG_ZOPT2201 is not set
# end of Light sensors

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_AK09911 is not set
# CONFIG_BMC150_MAGN_I2C is not set
# CONFIG_BMC150_MAGN_SPI is not set
# CONFIG_MAG3110 is not set
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
# CONFIG_MMC35240 is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set
# CONFIG_SENSORS_HMC5843_I2C is not set
# CONFIG_SENSORS_HMC5843_SPI is not set
# CONFIG_SENSORS_RM3100_I2C is not set
# CONFIG_SENSORS_RM3100_SPI is not set
# end of Magnetometer sensors

#
# Multiplexers
#
# end of Multiplexers

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m
CONFIG_HID_SENSOR_DEVICE_ROTATION=m
# end of Inclinometer sensors

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set
# end of Triggers - standalone

#
# Linear and angular position sensors
#
# end of Linear and angular position sensors

#
# Digital potentiometers
#
# CONFIG_AD5272 is not set
# CONFIG_DS1803 is not set
# CONFIG_MAX5432 is not set
# CONFIG_MAX5481 is not set
# CONFIG_MAX5487 is not set
# CONFIG_MCP4018 is not set
# CONFIG_MCP4131 is not set
# CONFIG_MCP4531 is not set
# CONFIG_MCP41010 is not set
# CONFIG_TPL0102 is not set
# end of Digital potentiometers

#
# Digital potentiostats
#
# CONFIG_LMP91000 is not set
# end of Digital potentiostats

#
# Pressure sensors
#
# CONFIG_ABP060MG is not set
# CONFIG_BMP280 is not set
# CONFIG_DLHL60D is not set
# CONFIG_DPS310 is not set
CONFIG_HID_SENSOR_PRESS=m
# CONFIG_HP03 is not set
# CONFIG_ICP10100 is not set
# CONFIG_MPL115_I2C is not set
# CONFIG_MPL115_SPI is not set
# CONFIG_MPL3115 is not set
# CONFIG_MS5611 is not set
# CONFIG_MS5637 is not set
# CONFIG_IIO_ST_PRESS is not set
# CONFIG_T5403 is not set
# CONFIG_HP206C is not set
# CONFIG_ZPA2326 is not set
# end of Pressure sensors

#
# Lightning sensors
#
# CONFIG_AS3935 is not set
# end of Lightning sensors

#
# Proximity and distance sensors
#
# CONFIG_ISL29501 is not set
# CONFIG_LIDAR_LITE_V2 is not set
# CONFIG_MB1232 is not set
# CONFIG_PING is not set
# CONFIG_RFD77402 is not set
# CONFIG_SRF04 is not set
# CONFIG_SX9310 is not set
# CONFIG_SX9500 is not set
# CONFIG_SRF08 is not set
# CONFIG_VCNL3020 is not set
# CONFIG_VL53L0X_I2C is not set
# end of Proximity and distance sensors

#
# Resolver to digital converters
#
# CONFIG_AD2S90 is not set
# CONFIG_AD2S1200 is not set
# end of Resolver to digital converters

#
# Temperature sensors
#
# CONFIG_LTC2983 is not set
# CONFIG_MAXIM_THERMOCOUPLE is not set
# CONFIG_HID_SENSOR_TEMP is not set
# CONFIG_MLX90614 is not set
# CONFIG_MLX90632 is not set
# CONFIG_TMP006 is not set
# CONFIG_TMP007 is not set
# CONFIG_TSYS01 is not set
# CONFIG_TSYS02D is not set
# CONFIG_MAX31856 is not set
# end of Temperature sensors

CONFIG_NTB=m
# CONFIG_NTB_MSI is not set
CONFIG_NTB_AMD=m
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
CONFIG_NTB_PERF=m
CONFIG_NTB_TRANSPORT=m
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
# CONFIG_PWM_LPSS_PCI is not set
# CONFIG_PWM_LPSS_PLATFORM is not set
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_USB_LGM_PHY is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_CPCAP_USB is not set
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_USB4 is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_BLK=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
CONFIG_DAX_DRIVER=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_DEV_DAX_PMEM_COMPAT=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y

#
# HW tracing support
#
# CONFIG_STM is not set
# CONFIG_INTEL_TH is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_TEE is not set
CONFIG_PM_OPP=y
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# CONFIG_MOST is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_USE_FOR_EXT2=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_ONLINE_SCRUB is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
# CONFIG_FS_ENCRYPTION is not set
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
# CONFIG_VIRTIO_FS is not set
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_EXFAT_FS is not set
# CONFIG_NTFS_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_VMCORE_DEVICE_DUMP is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_PROC_CPU_RESCTRL=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_TMPFS_INODE64 is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
# CONFIG_CRAMFS_MTD is not set
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_PSTORE_BLK is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EROFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
# CONFIG_NFSD_V4_2_INTER_SSC is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
CONFIG_SUNRPC_DEBUG=y
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_HARDENED_USERCOPY_FALLBACK=y
# CONFIG_HARDENED_USERCOPY_PAGESPAN is not set
# CONFIG_FORTIFY_SOURCE is not set
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
# CONFIG_SECURITY_SELINUX_DISABLE is not set
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_SIDTAB_HASH_BITS=9
CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE=256
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_WRITE_POLICY is not set
# CONFIG_IMA_READ_POLICY is not set
CONFIG_IMA_APPRAISE=y
CONFIG_IMA_ARCH_POLICY=y
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
# CONFIG_IMA_APPRAISE_MODSIG is not set
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS=y
CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS=y
CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT=y
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
# end of Memory initialization
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=m
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_SIMD=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m
CONFIG_CRYPTO_ENGINE=m

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=m
CONFIG_CRYPTO_ECC=m
CONFIG_CRYPTO_ECDH=m
# CONFIG_CRYPTO_ECRDSA is not set
# CONFIG_CRYPTO_SM2 is not set
# CONFIG_CRYPTO_CURVE25519 is not set
# CONFIG_CRYPTO_CURVE25519_X86 is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CFB is not set
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set
CONFIG_CRYPTO_ESSIV=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_XXHASH=m
CONFIG_CRYPTO_BLAKE2B=m
# CONFIG_CRYPTO_BLAKE2S is not set
# CONFIG_CRYPTO_BLAKE2S_X86 is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_POLY1305 is not set
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_SHA3 is not set
# CONFIG_CRYPTO_SM3 is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_CHACHA20 is not set
# CONFIG_CRYPTO_CHACHA20_X86_64 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=m
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
# CONFIG_CRYPTO_USER_API_AEAD is not set
CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE=y
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
# CONFIG_CRYPTO_LIB_BLAKE2S is not set
# CONFIG_CRYPTO_LIB_CHACHA is not set
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA256=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
# CONFIG_CRYPTO_DEV_NITROX_CNN55XX is not set
CONFIG_CRYPTO_DEV_CHELSIO=m
CONFIG_CRYPTO_DEV_VIRTIO=m
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
# CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE is not set
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_RAID6_PQ_BENCHMARK=y
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CORDIC=m
CONFIG_PRIME_NUMBERS=m
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC64 is not set
# CONFIG_CRC4 is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_BTREE=y
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED=y
CONFIG_SWIOTLB=y
CONFIG_DMA_COHERENT_POOL=y
CONFIG_DMA_CMA=y
# CONFIG_DMA_PERNUMA_CMA is not set

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
CONFIG_SGL_ALLOC=y
CONFIG_IOMMU_HELPER=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_DIMLIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_SBITMAP=y
# CONFIG_STRING_SELFTEST is not set
# end of Library routines

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
# CONFIG_PRINTK_CALLER is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_INFO_COMPRESSED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF4 is not set
CONFIG_DEBUG_INFO_BTF=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
# CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_32B is not set
CONFIG_STACK_VALIDATION=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
# end of Generic Kernel Debugging Instruments

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
# CONFIG_KASAN is not set
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

# CONFIG_DEBUG_TIMEKEEPING is not set
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RAW_LOCK_NESTING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_WW_MUTEX_SELFTEST=m
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_TRACE_IRQFLAGS=y
CONFIG_TRACE_IRQFLAGS_NMI=y
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PLIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_RCU_SCALE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_REF_SCALE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
CONFIG_TRACE_PREEMPT_TOGGLE=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
CONFIG_PREEMPTIRQ_DELAY_TEST=m
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_SAMPLES=y
# CONFIG_SAMPLE_AUXDISPLAY is not set
# CONFIG_SAMPLE_TRACE_EVENTS is not set
CONFIG_SAMPLE_TRACE_PRINTK=m
CONFIG_SAMPLE_FTRACE_DIRECT=m
# CONFIG_SAMPLE_TRACE_ARRAY is not set
# CONFIG_SAMPLE_KOBJECT is not set
# CONFIG_SAMPLE_KPROBES is not set
# CONFIG_SAMPLE_HW_BREAKPOINT is not set
# CONFIG_SAMPLE_KFIFO is not set
# CONFIG_SAMPLE_LIVEPATCH is not set
# CONFIG_SAMPLE_CONFIGFS is not set
# CONFIG_SAMPLE_VFIO_MDEV_MTTY is not set
# CONFIG_SAMPLE_VFIO_MDEV_MDPY is not set
# CONFIG_SAMPLE_VFIO_MDEV_MDPY_FB is not set
# CONFIG_SAMPLE_VFIO_MDEV_MBOCHS is not set
# CONFIG_SAMPLE_WATCHDOG is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_FPU=y
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# CONFIG_UNWINDER_GUESS is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_STRSCPY=m
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_PRINTF=m
CONFIG_TEST_BITMAP=m
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_IDA is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_BITOPS=m
CONFIG_TEST_VMALLOC=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
CONFIG_TEST_BLACKHOLE_DEV=m
# CONFIG_FIND_BIT_BENCHMARK is not set
CONFIG_TEST_FIRMWARE=m
CONFIG_TEST_SYSCTL=y
# CONFIG_TEST_UDELAY is not set
CONFIG_TEST_STATIC_KEYS=m
CONFIG_TEST_KMOD=m
# CONFIG_TEST_MEMCAT_P is not set
CONFIG_TEST_LIVEPATCH=m
# CONFIG_TEST_STACKINIT is not set
# CONFIG_TEST_MEMINIT is not set
CONFIG_TEST_HMM=m
# CONFIG_TEST_FREE_PAGES is not set
# CONFIG_TEST_FPU is not set
# CONFIG_MEMTEST is not set
# CONFIG_HYPERV_TESTING is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--5gxpn/Q6ypwruk0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='kernel-selftests'
	export testcase='kernel-selftests'
	export category='functional'
	export kconfig='x86_64-rhel-7.6-kselftests'
	export job_origin='/lkp-src/allot/cyclic:p1:linux-devel:devel-hourly/lkp-skl-nuc2/kernel-selftests-bm.yaml'
	export queue_cmdline_keys='branch
commit
queue_at_least_once'
	export queue='validate'
	export testbox='lkp-skl-nuc2'
	export tbox_group='lkp-skl-nuc2'
	export submit_id='5fc7c3bbea479512c7303c56'
	export job_file='/lkp/jobs/scheduled/lkp-skl-nuc2/kernel-selftests-net-ucode=0xe2-debian-10.4-x86_64-20200603.cgz-de900a24194807c73768a543f989161a1ee47c7e-20201203-4807-r1y3ic-1.yaml'
	export id='815a81d786d92dd11bb4b61827af2a360a3c0398'
	export queuer_version='/lkp-src'
	export model='Skylake'
	export nr_cpu=8
	export memory='32G'
	export nr_sdd_partitions=1
	export ssd_partitions='/dev/disk/by-id/ata-INTEL_SSDSCKKF480H6_CVLY6296001Z480F-part1'
	export swap_partitions=
	export rootfs_partition='/dev/disk/by-id/ata-INTEL_SSDSCKKF480H6_CVLY629600JP480F-part1'
	export brand='Intel(R) Core(TM) i7-6770HQ CPU @ 2.60GHz'
	export commit='de900a24194807c73768a543f989161a1ee47c7e'
	export netconsole_port=6675
	export ucode='0xe2'
	export need_kconfig_hw='CONFIG_E1000E=y
CONFIG_SATA_AHCI'
	export need_kernel_headers=true
	export need_kernel_selftests=true
	export need_kconfig='CONFIG_USER_NS=y
CONFIG_BPF_SYSCALL=y
CONFIG_TEST_BPF=m
CONFIG_NUMA=y ~ ">= v5.6-rc1"
CONFIG_NET_VRF=y ~ ">= v4.3-rc1"
CONFIG_NET_L3_MASTER_DEV=y ~ ">= v4.4-rc1"
CONFIG_IPV6=y
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_VETH=y
CONFIG_NET_IPVTI=m
CONFIG_IPV6_VTI=m
CONFIG_DUMMY=y
CONFIG_BRIDGE=y
CONFIG_VLAN_8021Q=y
CONFIG_IFB=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_NF_CONNTRACK=m
CONFIG_NF_NAT=m ~ ">= v5.1-rc1"
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP_NF_NAT=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_IPV6=y ~ ">= v4.17-rc1"
CONFIG_NF_TABLES_IPV4=y ~ ">= v4.17-rc1"
CONFIG_NFT_CHAIN_NAT_IPV6=m ~ "<= v5.0"
CONFIG_NFT_CHAIN_NAT_IPV4=m ~ "<= v5.0"
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_ETF=m ~ ">= v4.19-rc1"
CONFIG_NET_SCH_NETEM=y
CONFIG_TEST_BLACKHOLE_DEV=m ~ ">= v5.3-rc1"
CONFIG_KALLSYMS=y'
	export enqueue_time='2020-12-03 00:41:32 +0800'
	export _id='5fc7c3bbea479512c7303c56'
	export _rt='/result/kernel-selftests/net-ucode=0xe2/lkp-skl-nuc2/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e'
	export user='lkp'
	export compiler='gcc-9'
	export head_commit='76b77b10f6fd5bd6295ee46b67e3cc5e2be1daab'
	export base_commit='b65054597872ce3aefbc6a666385eabdf9e288da'
	export branch='linux-review/Gary-Lin/bpf-x64-add-extra-passes-without-size-optimizations/20201127-152514'
	export rootfs='debian-10.4-x86_64-20200603.cgz'
	export result_root='/result/kernel-selftests/net-ucode=0xe2/lkp-skl-nuc2/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e/3'
	export scheduler_version='/lkp/lkp/.src-20201203-000523'
	export LKP_SERVER='internal-lkp-server'
	export arch='x86_64'
	export max_uptime=2400
	export initrd='/osimage/debian/debian-10.4-x86_64-20200603.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/jobs/scheduled/lkp-skl-nuc2/kernel-selftests-net-ucode=0xe2-debian-10.4-x86_64-20200603.cgz-de900a24194807c73768a543f989161a1ee47c7e-20201203-4807-r1y3ic-1.yaml
ARCH=x86_64
kconfig=x86_64-rhel-7.6-kselftests
branch=linux-review/Gary-Lin/bpf-x64-add-extra-passes-without-size-optimizations/20201127-152514
commit=de900a24194807c73768a543f989161a1ee47c7e
BOOT_IMAGE=/pkg/linux/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e/vmlinuz-5.10.0-rc3-00844-gde900a241948
max_uptime=2400
RESULT_ROOT=/result/kernel-selftests/net-ucode=0xe2/lkp-skl-nuc2/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e/3
LKP_SERVER=internal-lkp-server
nokaslr
selinux=0
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e/modules.cgz'
	export bm_initrd='/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20200709.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/kernel-selftests_20201124.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/kernel-selftests-x86_64-b5a583fb-1_20201015.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz'
	export linux_headers_initrd='/pkg/linux/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e/linux-headers.cgz'
	export linux_selftests_initrd='/pkg/linux/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e/linux-selftests.cgz'
	export ucode_initrd='/osimage/ucode/intel-ucode-20201117.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='5.10.0-rc2-00008-g50b8a742850f'
	export repeat_to=4
	export schedule_notify_address=
	export queue_at_least_once=1
	export kernel='/pkg/linux/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e/vmlinuz-5.10.0-rc3-00844-gde900a241948'
	export dequeue_time='2020-12-03 01:28:49 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-skl-nuc2/kernel-selftests-net-ucode=0xe2-debian-10.4-x86_64-20200603.cgz-de900a24194807c73768a543f989161a1ee47c7e-20201203-4807-r1y3ic-1.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test group='net' $LKP_SRC/tests/wrapper kernel-selftests
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	$LKP_SRC/stats/wrapper kernel-selftests
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time kernel-selftests.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--5gxpn/Q6ypwruk0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---

#! jobs/kernel-selftests-bm.yaml
suite: kernel-selftests
testcase: kernel-selftests
category: functional
kconfig: x86_64-rhel-7.6-kselftests
kernel-selftests:
  group: net
job_origin: "/lkp-src/allot/cyclic:p1:linux-devel:devel-hourly/lkp-skl-nuc2/kernel-selftests-bm.yaml"

#! queue options
queue_cmdline_keys:
- branch
- commit
queue: bisect
testbox: lkp-skl-nuc2
tbox_group: lkp-skl-nuc2
submit_id: 5fc6e603547a450d9dd1c5f4
job_file: "/lkp/jobs/scheduled/lkp-skl-nuc2/kernel-selftests-net-ucode=0xe2-debian-10.4-x86_64-20200603.cgz-de900a24194807c73768a543f989161a1ee47c7e-20201202-3485-1qy3oen-0.yaml"
id: 2aacc8372a3fdf55eb3f9de4f792daee8174b59e
queuer_version: "/lkp-src"

#! hosts/lkp-skl-nuc2
model: Skylake
nr_cpu: 8
memory: 32G
nr_sdd_partitions: 1
ssd_partitions: "/dev/disk/by-id/ata-INTEL_SSDSCKKF480H6_CVLY6296001Z480F-part1"
swap_partitions: 
rootfs_partition: "/dev/disk/by-id/ata-INTEL_SSDSCKKF480H6_CVLY629600JP480F-part1"
brand: Intel(R) Core(TM) i7-6770HQ CPU @ 2.60GHz

#! include/category/functional
kmsg: 
heartbeat: 
meminfo: 

#! include/queue/cyclic
commit: de900a24194807c73768a543f989161a1ee47c7e

#! include/testbox/lkp-skl-nuc2
netconsole_port: 6675
ucode: '0xe2'
need_kconfig_hw:
- CONFIG_E1000E=y
- CONFIG_SATA_AHCI

#! include/kernel-selftests
need_kernel_headers: true
need_kernel_selftests: true
need_kconfig:
- CONFIG_USER_NS=y
- CONFIG_BPF_SYSCALL=y
- CONFIG_TEST_BPF=m
- CONFIG_NUMA=y ~ ">= v5.6-rc1"
- CONFIG_NET_VRF=y ~ ">= v4.3-rc1"
- CONFIG_NET_L3_MASTER_DEV=y ~ ">= v4.4-rc1"
- CONFIG_IPV6=y
- CONFIG_IPV6_MULTIPLE_TABLES=y
- CONFIG_VETH=y
- CONFIG_NET_IPVTI=m
- CONFIG_IPV6_VTI=m
- CONFIG_DUMMY=y
- CONFIG_BRIDGE=y
- CONFIG_VLAN_8021Q=y
- CONFIG_IFB=y
- CONFIG_NETFILTER=y
- CONFIG_NETFILTER_ADVANCED=y
- CONFIG_NF_CONNTRACK=m
- CONFIG_NF_NAT=m ~ ">= v5.1-rc1"
- CONFIG_IP6_NF_IPTABLES=m
- CONFIG_IP_NF_IPTABLES=m
- CONFIG_IP6_NF_NAT=m
- CONFIG_IP_NF_NAT=m
- CONFIG_NF_TABLES=m
- CONFIG_NF_TABLES_IPV6=y ~ ">= v4.17-rc1"
- CONFIG_NF_TABLES_IPV4=y ~ ">= v4.17-rc1"
- CONFIG_NFT_CHAIN_NAT_IPV6=m ~ "<= v5.0"
- CONFIG_NFT_CHAIN_NAT_IPV4=m ~ "<= v5.0"
- CONFIG_NET_SCH_FQ=m
- CONFIG_NET_SCH_ETF=m ~ ">= v4.19-rc1"
- CONFIG_NET_SCH_NETEM=y
- CONFIG_TEST_BLACKHOLE_DEV=m ~ ">= v5.3-rc1"
- CONFIG_KALLSYMS=y
enqueue_time: 2020-12-02 08:55:31.525869974 +08:00
_id: 5fc6e603547a450d9dd1c5f4
_rt: "/result/kernel-selftests/net-ucode=0xe2/lkp-skl-nuc2/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e"

#! schedule options
user: lkp
compiler: gcc-9
head_commit: 76b77b10f6fd5bd6295ee46b67e3cc5e2be1daab
base_commit: b65054597872ce3aefbc6a666385eabdf9e288da
branch: linux-devel/devel-hourly-2020120103
rootfs: debian-10.4-x86_64-20200603.cgz
result_root: "/result/kernel-selftests/net-ucode=0xe2/lkp-skl-nuc2/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e/0"
scheduler_version: "/lkp/lkp/.src-20201201-225242"
LKP_SERVER: internal-lkp-server
arch: x86_64
max_uptime: 2400
initrd: "/osimage/debian/debian-10.4-x86_64-20200603.cgz"
bootloader_append:
- root=/dev/ram0
- user=lkp
- job=/lkp/jobs/scheduled/lkp-skl-nuc2/kernel-selftests-net-ucode=0xe2-debian-10.4-x86_64-20200603.cgz-de900a24194807c73768a543f989161a1ee47c7e-20201202-3485-1qy3oen-0.yaml
- ARCH=x86_64
- kconfig=x86_64-rhel-7.6-kselftests
- branch=linux-devel/devel-hourly-2020120103
- commit=de900a24194807c73768a543f989161a1ee47c7e
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e/vmlinuz-5.10.0-rc3-00844-gde900a241948
- max_uptime=2400
- RESULT_ROOT=/result/kernel-selftests/net-ucode=0xe2/lkp-skl-nuc2/debian-10.4-x86_64-20200603.cgz/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e/0
- LKP_SERVER=internal-lkp-server
- nokaslr
- selinux=0
- debug
- apic=debug
- sysrq_always_enabled
- rcupdate.rcu_cpu_stall_timeout=100
- net.ifnames=0
- printk.devkmsg=on
- panic=-1
- softlockup_panic=1
- nmi_watchdog=panic
- oops=panic
- load_ramdisk=2
- prompt_ramdisk=0
- drbd.minor_count=8
- systemd.log_level=err
- ignore_loglevel
- console=tty0
- earlyprintk=ttyS0,115200
- console=ttyS0,115200
- vga=normal
- rw
modules_initrd: "/pkg/linux/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e/modules.cgz"
bm_initrd: "/osimage/deps/debian-10.4-x86_64-20200603.cgz/run-ipconfig_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/lkp_20200709.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/rsync-rootfs_20200608.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/kernel-selftests_20201124.cgz,/osimage/pkg/debian-10.4-x86_64-20200603.cgz/kernel-selftests-x86_64-b5a583fb-1_20201015.cgz,/osimage/deps/debian-10.4-x86_64-20200603.cgz/hw_20200715.cgz"
linux_headers_initrd: "/pkg/linux/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e/linux-headers.cgz"
linux_selftests_initrd: "/pkg/linux/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e/linux-selftests.cgz"
ucode_initrd: "/osimage/ucode/intel-ucode-20201117.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn

#! /lkp/lkp/.src-20201130-155400/include/site/inn
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer: 
watchdog: 

#! runtime status
last_kernel: 5.10.0-rc6-06654-gf8a6ae13e504
schedule_notify_address: 

#! user overrides
kernel: "/pkg/linux/x86_64-rhel-7.6-kselftests/gcc-9/de900a24194807c73768a543f989161a1ee47c7e/vmlinuz-5.10.0-rc3-00844-gde900a241948"
dequeue_time: 2020-12-02 09:50:29.534948539 +08:00

#! /lkp/lkp/.src-20201201-225242/include/site/inn
job_state: finished
loadavg: 0.80 0.74 0.67 1/260 6754
start_time: '1606873924'
end_time: '1606875028'
version: "/lkp/lkp/.src-20201201-225315:0a8f5c12-dirty:5a5e0b02c"

--5gxpn/Q6ypwruk0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

 "sed" "-i" "s/default_timeout=45/default_timeout=300/" "kselftest/runner.sh"
 "make" "-C" "bpf"
 "make" "-C" "../../../tools/testing/selftests/net"
 "make" "install" "INSTALL_PATH=/usr/bin/" "-C" "../../../tools/testing/selftests/net"
 "make" "run_tests" "-C" "net"

--5gxpn/Q6ypwruk0T
Content-Type: application/x-xz
Content-Disposition: attachment; filename="kmsg.xz"
Content-Transfer-Encoding: base64

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
+bcDigABjasEwcokac2VdLHEZ/sCAAAAAARZWg==

--5gxpn/Q6ypwruk0T
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=kernel-selftests
Content-Transfer-Encoding: quoted-printable

KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-7=
=2E6-kselftests-de900a24194807c73768a543f989161a1ee47c7e
2020-12-02 17:30:17 sed -i s/default_timeout=3D45/default_timeout=3D300/ ks=
elftest/runner.sh
LKP WARN miss config CONFIG_BAREUDP=3D of net/config
2020-12-02 17:30:17 make -C bpf
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftest=
s-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf'
  MKDIR    include
  MKDIR    libbpf
  HOSTCC   /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
fixdep.o
  HOSTLD   /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
fixdep-in.o
  LINK     /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
fixdep
  GEN      /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
bpf_helper_defs.h
  MKDIR    /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
staticobjs/
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
staticobjs/libbpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
staticobjs/bpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
staticobjs/nlattr.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
staticobjs/btf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
staticobjs/libbpf_errno.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
staticobjs/str_error.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
staticobjs/netlink.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
staticobjs/bpf_prog_linfo.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
staticobjs/libbpf_probes.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
staticobjs/xsk.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
staticobjs/hashmap.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
staticobjs/btf_dump.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
staticobjs/ringbuf.o
  LD       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
staticobjs/libbpf-in.o
  LINK     /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
libbpf.a
Warning: Kernel ABI header at 'tools/include/uapi/linux/netlink.h' differs =
=66rom latest version at 'include/uapi/linux/netlink.h'
Warning: Kernel ABI header at 'tools/include/uapi/linux/if_link.h' differs =
=66rom latest version at 'include/uapi/linux/if_link.h'
  MKDIR    /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
sharedobjs/
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
sharedobjs/libbpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
sharedobjs/bpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
sharedobjs/nlattr.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
sharedobjs/btf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
sharedobjs/libbpf_errno.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
sharedobjs/str_error.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
sharedobjs/netlink.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
sharedobjs/bpf_prog_linfo.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
sharedobjs/libbpf_probes.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
sharedobjs/xsk.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
sharedobjs/hashmap.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
sharedobjs/btf_dump.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
sharedobjs/ringbuf.o
  LD       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
sharedobjs/libbpf-in.o
  LINK     /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
libbpf.so.0.3.0
  GEN      /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/libbpf/=
libbpf.pc
  INSTALL  headers
  CC       test_stub.o
  BINARY   test_verifier
  BINARY   test_tag
  MKDIR    bpftool
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/map_perf_ring.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/xlated_dumper.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/iter.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/btf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/tracelog.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/perf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/common.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/btf_dumper.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/net.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/struct_ops.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/netlink_dumper.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/link.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/cgroup.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/cfg.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/gen.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/main.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/json_writer.o
  MKDIR    /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/main.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/common.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/json_writer.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/gen.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/btf.o
  MKDIR    /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/
  GEN      /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/bpf_helper_defs.h
  MKDIR    /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/staticobjs/
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/staticobjs/libbpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/staticobjs/bpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/staticobjs/nlattr.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/staticobjs/btf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/staticobjs/libbpf_errno.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/staticobjs/str_error.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/staticobjs/netlink.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/staticobjs/bpf_prog_linfo.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/staticobjs/libbpf_probes.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/staticobjs/xsk.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/staticobjs/hashmap.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/staticobjs/btf_dump.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/staticobjs/ringbuf.o
  LD       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/staticobjs/libbpf-in.o
  LINK     /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/libbpf/libbpf.a
  LINK     /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//bootstrap/bpftool
  GEN      /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/vmlinux.h
  MKDIR    /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/
  GEN      /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/bpf_helper_defs.h
  MKDIR    /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/staticobjs/
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/staticobjs/libbpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/staticobjs/bpf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/staticobjs/nlattr.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/staticobjs/btf.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/staticobjs/libbpf_errno.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/staticobjs/str_error.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/staticobjs/netlink.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/staticobjs/bpf_prog_linfo.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/staticobjs/libbpf_probes.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/staticobjs/xsk.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/staticobjs/hashmap.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/staticobjs/btf_dump.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/staticobjs/ringbuf.o
  LD       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/staticobjs/libbpf-in.o
  LINK     /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
//libbpf/libbpf.a
  CLANG    /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/profiler.bpf.o
  GEN      /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/profiler.skel.h
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/prog.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/map.o
  CLANG    /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/pid_iter.bpf.o
  GEN      /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/pid_iter.skel.h
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/pids.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/feature.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/jit_disasm.o
  CC       /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/disasm.o
  LINK     /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools/build/bpftool=
/bpftool
  INSTALL  bpftool
Makefile:45: *** "rst2man not found, but required to generate man pages".  =
Stop.
make: *** [Makefile:178: /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests=
-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools=
/sbin/bpftool] Error 2
make: *** Deleting file '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests=
-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf/tools=
/sbin/bpftool'
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests=
-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/bpf'
LKP SKIP net.l2tp.sh
2020-12-02 17:30:53 make -C ../../../tools/testing/selftests/net
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftest=
s-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net'
make --no-builtin-rules ARCH=3Dx86 -C ../../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselft=
ests-de900a24194807c73768a543f989161a1ee47c7e'
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/unifdef
  WRAP    arch/x86/include/generated/uapi/asm/bpf_perf_event.h
  WRAP    arch/x86/include/generated/uapi/asm/errno.h
  WRAP    arch/x86/include/generated/uapi/asm/fcntl.h
  WRAP    arch/x86/include/generated/uapi/asm/ioctl.h
  WRAP    arch/x86/include/generated/uapi/asm/ioctls.h
  WRAP    arch/x86/include/generated/uapi/asm/ipcbuf.h
  WRAP    arch/x86/include/generated/uapi/asm/param.h
  WRAP    arch/x86/include/generated/uapi/asm/poll.h
  WRAP    arch/x86/include/generated/uapi/asm/resource.h
  WRAP    arch/x86/include/generated/uapi/asm/socket.h
  WRAP    arch/x86/include/generated/uapi/asm/sockios.h
  WRAP    arch/x86/include/generated/uapi/asm/termbits.h
  WRAP    arch/x86/include/generated/uapi/asm/termios.h
  WRAP    arch/x86/include/generated/uapi/asm/types.h
  SYSTBL  arch/x86/include/generated/asm/syscalls_32.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_32.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_64.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_x32.h
  HOSTCC  arch/x86/tools/relocs_32.o
  HOSTCC  arch/x86/tools/relocs_64.o
  HOSTCC  arch/x86/tools/relocs_common.o
  HOSTLD  arch/x86/tools/relocs
  UPD     include/generated/uapi/linux/version.h
  HDRINST usr/include/video/edid.h
  HDRINST usr/include/video/uvesafb.h
  HDRINST usr/include/video/sisfb.h
  HDRINST usr/include/drm/vmwgfx_drm.h
  HDRINST usr/include/drm/nouveau_drm.h
  HDRINST usr/include/drm/exynos_drm.h
  HDRINST usr/include/drm/vgem_drm.h
  HDRINST usr/include/drm/drm_fourcc.h
  HDRINST usr/include/drm/omap_drm.h
  HDRINST usr/include/drm/msm_drm.h
  HDRINST usr/include/drm/panfrost_drm.h
  HDRINST usr/include/drm/savage_drm.h
  HDRINST usr/include/drm/mga_drm.h
  HDRINST usr/include/drm/r128_drm.h
  HDRINST usr/include/drm/lima_drm.h
  HDRINST usr/include/drm/drm_sarea.h
  HDRINST usr/include/drm/virtgpu_drm.h
  HDRINST usr/include/drm/v3d_drm.h
  HDRINST usr/include/drm/etnaviv_drm.h
  HDRINST usr/include/drm/i915_drm.h
  HDRINST usr/include/drm/drm.h
  HDRINST usr/include/drm/amdgpu_drm.h
  HDRINST usr/include/drm/sis_drm.h
  HDRINST usr/include/drm/qxl_drm.h
  HDRINST usr/include/drm/tegra_drm.h
  HDRINST usr/include/drm/radeon_drm.h
  HDRINST usr/include/drm/armada_drm.h
  HDRINST usr/include/drm/via_drm.h
  HDRINST usr/include/drm/vc4_drm.h
  HDRINST usr/include/drm/i810_drm.h
  HDRINST usr/include/drm/drm_mode.h
  HDRINST usr/include/mtd/nftl-user.h
  HDRINST usr/include/mtd/ubi-user.h
  HDRINST usr/include/mtd/mtd-user.h
  HDRINST usr/include/mtd/inftl-user.h
  HDRINST usr/include/mtd/mtd-abi.h
  HDRINST usr/include/xen/gntdev.h
  HDRINST usr/include/xen/privcmd.h
  HDRINST usr/include/xen/evtchn.h
  HDRINST usr/include/xen/gntalloc.h
  HDRINST usr/include/asm-generic/bpf_perf_event.h
  HDRINST usr/include/asm-generic/auxvec.h
  HDRINST usr/include/asm-generic/posix_types.h
  HDRINST usr/include/asm-generic/param.h
  HDRINST usr/include/asm-generic/types.h
  HDRINST usr/include/asm-generic/stat.h
  HDRINST usr/include/asm-generic/resource.h
  HDRINST usr/include/asm-generic/shmbuf.h
  HDRINST usr/include/asm-generic/hugetlb_encode.h
  HDRINST usr/include/asm-generic/int-ll64.h
  HDRINST usr/include/asm-generic/signal.h
  HDRINST usr/include/asm-generic/termios.h
  HDRINST usr/include/asm-generic/kvm_para.h
  HDRINST usr/include/asm-generic/int-l64.h
  HDRINST usr/include/asm-generic/mman-common.h
  HDRINST usr/include/asm-generic/unistd.h
  HDRINST usr/include/asm-generic/swab.h
  HDRINST usr/include/asm-generic/ucontext.h
  HDRINST usr/include/asm-generic/siginfo.h
  HDRINST usr/include/asm-generic/errno-base.h
  HDRINST usr/include/asm-generic/ioctls.h
  HDRINST usr/include/asm-generic/bitsperlong.h
  HDRINST usr/include/asm-generic/msgbuf.h
  HDRINST usr/include/asm-generic/setup.h
  HDRINST usr/include/asm-generic/fcntl.h
  HDRINST usr/include/asm-generic/termbits.h
  HDRINST usr/include/asm-generic/socket.h
  HDRINST usr/include/asm-generic/poll.h
  HDRINST usr/include/asm-generic/statfs.h
  HDRINST usr/include/asm-generic/signal-defs.h
  HDRINST usr/include/asm-generic/mman.h
  HDRINST usr/include/asm-generic/errno.h
  HDRINST usr/include/asm-generic/ioctl.h
  HDRINST usr/include/asm-generic/sockios.h
  HDRINST usr/include/asm-generic/sembuf.h
  HDRINST usr/include/asm-generic/ipcbuf.h
  HDRINST usr/include/rdma/hns-abi.h
  HDRINST usr/include/rdma/rdma_user_ioctl.h
  HDRINST usr/include/rdma/mthca-abi.h
  HDRINST usr/include/rdma/ib_user_ioctl_cmds.h
  HDRINST usr/include/rdma/ib_user_sa.h
  HDRINST usr/include/rdma/rdma_user_cm.h
  HDRINST usr/include/rdma/mlx5-abi.h
  HDRINST usr/include/rdma/rdma_user_rxe.h
  HDRINST usr/include/rdma/rvt-abi.h
  HDRINST usr/include/rdma/ocrdma-abi.h
  HDRINST usr/include/rdma/i40iw-abi.h
  HDRINST usr/include/rdma/vmw_pvrdma-abi.h
  HDRINST usr/include/rdma/siw-abi.h
  HDRINST usr/include/rdma/mlx4-abi.h
  HDRINST usr/include/rdma/mlx5_user_ioctl_cmds.h
  HDRINST usr/include/rdma/ib_user_ioctl_verbs.h
  HDRINST usr/include/rdma/ib_user_mad.h
  HDRINST usr/include/rdma/efa-abi.h
  HDRINST usr/include/rdma/ib_user_verbs.h
  HDRINST usr/include/rdma/mlx5_user_ioctl_verbs.h
  HDRINST usr/include/rdma/hfi/hfi1_user.h
  HDRINST usr/include/rdma/hfi/hfi1_ioctl.h
  HDRINST usr/include/rdma/rdma_netlink.h
  HDRINST usr/include/rdma/rdma_user_ioctl_cmds.h
  HDRINST usr/include/rdma/bnxt_re-abi.h
  HDRINST usr/include/rdma/qedr-abi.h
  HDRINST usr/include/rdma/cxgb4-abi.h
  HDRINST usr/include/misc/uacce/uacce.h
  HDRINST usr/include/misc/uacce/hisi_qm.h
  HDRINST usr/include/misc/pvpanic.h
  HDRINST usr/include/misc/fastrpc.h
  HDRINST usr/include/misc/cxl.h
  HDRINST usr/include/misc/ocxl.h
  HDRINST usr/include/misc/habanalabs.h
  HDRINST usr/include/misc/xilinx_sdfec.h
  HDRINST usr/include/linux/hash_info.h
  HDRINST usr/include/linux/auto_fs.h
  HDRINST usr/include/linux/nbd.h
  HDRINST usr/include/linux/isdn/capicmd.h
  HDRINST usr/include/linux/if_fc.h
  HDRINST usr/include/linux/bpf_perf_event.h
  HDRINST usr/include/linux/jffs2.h
  HDRINST usr/include/linux/net.h
  HDRINST usr/include/linux/can.h
  HDRINST usr/include/linux/kfd_ioctl.h
  HDRINST usr/include/linux/atmclip.h
  HDRINST usr/include/linux/if_ether.h
  HDRINST usr/include/linux/nbd-netlink.h
  HDRINST usr/include/linux/if_bonding.h
  HDRINST usr/include/linux/tipc_sockets_diag.h
  HDRINST usr/include/linux/fib_rules.h
  HDRINST usr/include/linux/btrfs.h
  HDRINST usr/include/linux/limits.h
  HDRINST usr/include/linux/fou.h
  HDRINST usr/include/linux/atmioc.h
  HDRINST usr/include/linux/auxvec.h
  HDRINST usr/include/linux/netlink_diag.h
  HDRINST usr/include/linux/posix_types.h
  HDRINST usr/include/linux/qemu_fw_cfg.h
  HDRINST usr/include/linux/input.h
  HDRINST usr/include/linux/vbox_err.h
  HDRINST usr/include/linux/times.h
  HDRINST usr/include/linux/vt.h
  HDRINST usr/include/linux/param.h
  HDRINST usr/include/linux/utsname.h
  HDRINST usr/include/linux/types.h
  HDRINST usr/include/linux/baycom.h
  HDRINST usr/include/linux/falloc.h
  HDRINST usr/include/linux/virtio_pmem.h
  HDRINST usr/include/linux/if_xdp.h
  HDRINST usr/include/linux/in_route.h
  HDRINST usr/include/linux/memfd.h
  HDRINST usr/include/linux/ppp-ioctl.h
  HDRINST usr/include/linux/atm_nicstar.h
  HDRINST usr/include/linux/nvram.h
  HDRINST usr/include/linux/raid/md_u.h
  HDRINST usr/include/linux/raid/md_p.h
  HDRINST usr/include/linux/shm.h
  HDRINST usr/include/linux/nfs3.h
  HDRINST usr/include/linux/vfio_ccw.h
  HDRINST usr/include/linux/android/binder.h
  HDRINST usr/include/linux/android/binderfs.h
  HDRINST usr/include/linux/xdp_diag.h
  HDRINST usr/include/linux/stat.h
  HDRINST usr/include/linux/fuse.h
  HDRINST usr/include/linux/elf-em.h
  HDRINST usr/include/linux/ptrace.h
  HDRINST usr/include/linux/capi.h
  HDRINST usr/include/linux/cyclades.h
  HDRINST usr/include/linux/hsr_netlink.h
  HDRINST usr/include/linux/virtio_crypto.h
  HDRINST usr/include/linux/securebits.h
  HDRINST usr/include/linux/a.out.h
  HDRINST usr/include/linux/uleds.h
  HDRINST usr/include/linux/resource.h
  HDRINST usr/include/linux/net_dropmon.h
  HDRINST usr/include/linux/io_uring.h
  HDRINST usr/include/linux/ip.h
  HDRINST usr/include/linux/zorro_ids.h
  HDRINST usr/include/linux/mtio.h
  HDRINST usr/include/linux/netconf.h
  HDRINST usr/include/linux/uinput.h
  HDRINST usr/include/linux/v4l2-mediabus.h
  HDRINST usr/include/linux/ncsi.h
  HDRINST usr/include/linux/magic.h
  HDRINST usr/include/linux/v4l2-subdev.h
  HDRINST usr/include/linux/sed-opal.h
  HDRINST usr/include/linux/kcov.h
  HDRINST usr/include/linux/genwqe/genwqe_card.h
  HDRINST usr/include/linux/nilfs2_api.h
  HDRINST usr/include/linux/dma-heap.h
  HDRINST usr/include/linux/string.h
  HDRINST usr/include/linux/ipmi_msgdefs.h
  HDRINST usr/include/linux/nsfs.h
  HDRINST usr/include/linux/fsverity.h
  HDRINST usr/include/linux/tcp.h
  HDRINST usr/include/linux/if_fddi.h
  HDRINST usr/include/linux/ife.h
  HDRINST usr/include/linux/hdreg.h
  HDRINST usr/include/linux/x25.h
  HDRINST usr/include/linux/openat2.h
  HDRINST usr/include/linux/fs.h
  HDRINST usr/include/linux/signal.h
  HDRINST usr/include/linux/if_arp.h
  HDRINST usr/include/linux/virtio_ring.h
  HDRINST usr/include/linux/if_plip.h
  HDRINST usr/include/linux/futex.h
  HDRINST usr/include/linux/virtio_balloon.h
  HDRINST usr/include/linux/perf_event.h
  HDRINST usr/include/linux/nfs4_mount.h
  HDRINST usr/include/linux/pps.h
  HDRINST usr/include/linux/major.h
  HDRINST usr/include/linux/cec-funcs.h
  HDRINST usr/include/linux/omapfb.h
  HDRINST usr/include/linux/zorro.h
  HDRINST usr/include/linux/batadv_packet.h
  HDRINST usr/include/linux/in.h
  HDRINST usr/include/linux/bpfilter.h
  HDRINST usr/include/linux/timex.h
  HDRINST usr/include/linux/qrtr.h
  HDRINST usr/include/linux/if_x25.h
  HDRINST usr/include/linux/serial_core.h
  HDRINST usr/include/linux/utime.h
  HDRINST usr/include/linux/termios.h
  HDRINST usr/include/linux/fdreg.h
  HDRINST usr/include/linux/phantom.h
  HDRINST usr/include/linux/nfs.h
  HDRINST usr/include/linux/uuid.h
  HDRINST usr/include/linux/lightnvm.h
  HDRINST usr/include/linux/cdrom.h
  HDRINST usr/include/linux/remoteproc_cdev.h
  HDRINST usr/include/linux/dlmconstants.h
  HDRINST usr/include/linux/keyctl.h
  HDRINST usr/include/linux/apm_bios.h
  HDRINST usr/include/linux/if_vlan.h
  HDRINST usr/include/linux/romfs_fs.h
  HDRINST usr/include/linux/kvm_para.h
  HDRINST usr/include/linux/virtio_rng.h
  HDRINST usr/include/linux/seg6_iptunnel.h
  HDRINST usr/include/linux/mptcp.h
  HDRINST usr/include/linux/xattr.h
  HDRINST usr/include/linux/cciss_defs.h
  HDRINST usr/include/linux/hdlcdrv.h
  HDRINST usr/include/linux/spi/spidev.h
  HDRINST usr/include/linux/vhost_types.h
  HDRINST usr/include/linux/qnxtypes.h
  HDRINST usr/include/linux/if_hippi.h
  HDRINST usr/include/linux/fpga-dfl.h
  HDRINST usr/include/linux/tc_act/tc_mirred.h
  HDRINST usr/include/linux/tc_act/tc_mpls.h
  HDRINST usr/include/linux/tc_act/tc_nat.h
  HDRINST usr/include/linux/tc_act/tc_defact.h
  HDRINST usr/include/linux/tc_act/tc_ct.h
  HDRINST usr/include/linux/tc_act/tc_ctinfo.h
  HDRINST usr/include/linux/tc_act/tc_gate.h
  HDRINST usr/include/linux/tc_act/tc_connmark.h
  HDRINST usr/include/linux/tc_act/tc_ife.h
  HDRINST usr/include/linux/tc_act/tc_skbedit.h
  HDRINST usr/include/linux/tc_act/tc_vlan.h
  HDRINST usr/include/linux/tc_act/tc_gact.h
  HDRINST usr/include/linux/tc_act/tc_ipt.h
  HDRINST usr/include/linux/tc_act/tc_skbmod.h
  HDRINST usr/include/linux/tc_act/tc_csum.h
  HDRINST usr/include/linux/tc_act/tc_tunnel_key.h
  HDRINST usr/include/linux/tc_act/tc_bpf.h
  HDRINST usr/include/linux/tc_act/tc_pedit.h
  HDRINST usr/include/linux/tc_act/tc_sample.h
  HDRINST usr/include/linux/rpl.h
  HDRINST usr/include/linux/dns_resolver.h
  HDRINST usr/include/linux/ethtool_netlink.h
  HDRINST usr/include/linux/i2c.h
  HDRINST usr/include/linux/ip_vs.h
  HDRINST usr/include/linux/oom.h
  HDRINST usr/include/linux/atm_zatm.h
  HDRINST usr/include/linux/sock_diag.h
  HDRINST usr/include/linux/personality.h
  HDRINST usr/include/linux/udmabuf.h
  HDRINST usr/include/linux/kcm.h
  HDRINST usr/include/linux/virtio_vsock.h
  HDRINST usr/include/linux/atmppp.h
  HDRINST usr/include/linux/dma-buf.h
  HDRINST usr/include/linux/if_phonet.h
  HDRINST usr/include/linux/gen_stats.h
  HDRINST usr/include/linux/netfilter_ipv6.h
  HDRINST usr/include/linux/unistd.h
  HDRINST usr/include/linux/cm4000_cs.h
  HDRINST usr/include/linux/inet_diag.h
  HDRINST usr/include/linux/psp-sev.h
  HDRINST usr/include/linux/swab.h
  HDRINST usr/include/linux/mqueue.h
  HDRINST usr/include/linux/iio/types.h
  HDRINST usr/include/linux/iio/events.h
  HDRINST usr/include/linux/i2c-dev.h
  HDRINST usr/include/linux/atmbr2684.h
  HDRINST usr/include/linux/ax25.h
  HDRINST usr/include/linux/ultrasound.h
  HDRINST usr/include/linux/libc-compat.h
  HDRINST usr/include/linux/elf-fdpic.h
  HDRINST usr/include/linux/batman_adv.h
  HDRINST usr/include/linux/dlm.h
  HDRINST usr/include/linux/msdos_fs.h
  HDRINST usr/include/linux/atmdev.h
  HDRINST usr/include/linux/rxrpc.h
  HDRINST usr/include/linux/kernel-page-flags.h
  HDRINST usr/include/linux/phonet.h
  HDRINST usr/include/linux/map_to_7segment.h
  HDRINST usr/include/linux/vsockmon.h
  HDRINST usr/include/linux/cec.h
  HDRINST usr/include/linux/firewire-cdev.h
  HDRINST usr/include/linux/eventpoll.h
  HDRINST usr/include/linux/hidraw.h
  HDRINST usr/include/linux/netdevice.h
  HDRINST usr/include/linux/dn.h
  HDRINST usr/include/linux/atmlec.h
  HDRINST usr/include/linux/tipc.h
  HDRINST usr/include/linux/binfmts.h
  HDRINST usr/include/linux/stm.h
  HDRINST usr/include/linux/nfsacl.h
  HDRINST usr/include/linux/sem.h
  HDRINST usr/include/linux/arm_sdei.h
  HDRINST usr/include/linux/gameport.h
  HDRINST usr/include/linux/atalk.h
  HDRINST usr/include/linux/am437x-vpfe.h
  HDRINST usr/include/linux/irqnr.h
  HDRINST usr/include/linux/seg6_genl.h
  HDRINST usr/include/linux/ptp_clock.h
  HDRINST usr/include/linux/udp.h
  HDRINST usr/include/linux/sunrpc/debug.h
  HDRINST usr/include/linux/netfilter_arp/arpt_mangle.h
  HDRINST usr/include/linux/netfilter_arp/arp_tables.h
  HDRINST usr/include/linux/atmmpc.h
  HDRINST usr/include/linux/iommu.h
  HDRINST usr/include/linux/rose.h
  HDRINST usr/include/linux/virtio_config.h
  HDRINST usr/include/linux/hyperv.h
  HDRINST usr/include/linux/fscrypt.h
  HDRINST usr/include/linux/can/bcm.h
  HDRINST usr/include/linux/can/isotp.h
  HDRINST usr/include/linux/can/j1939.h
  HDRINST usr/include/linux/can/vxcan.h
  HDRINST usr/include/linux/can/error.h
  HDRINST usr/include/linux/can/gw.h
  HDRINST usr/include/linux/can/raw.h
  HDRINST usr/include/linux/can/netlink.h
  HDRINST usr/include/linux/fb.h
  HDRINST usr/include/linux/elf.h
  HDRINST usr/include/linux/bpf.h
  HDRINST usr/include/linux/pg.h
  HDRINST usr/include/linux/cgroupstats.h
  HDRINST usr/include/linux/psci.h
  HDRINST usr/include/linux/vm_sockets_diag.h
  HDRINST usr/include/linux/mempolicy.h
  HDRINST usr/include/linux/nfs_idmap.h
  HDRINST usr/include/linux/bpqether.h
  HDRINST usr/include/linux/capability.h
  HDRINST usr/include/linux/i8k.h
  HDRINST usr/include/linux/blkpg.h
  HDRINST usr/include/linux/l2tp.h
  HDRINST usr/include/linux/if_eql.h
  HDRINST usr/include/linux/sched/types.h
  HDRINST usr/include/linux/un.h
  HDRINST usr/include/linux/gtp.h
  HDRINST usr/include/linux/target_core_user.h
  HDRINST usr/include/linux/quota.h
  HDRINST usr/include/linux/ipv6.h
  HDRINST usr/include/linux/cn_proc.h
  HDRINST usr/include/linux/hsi/cs-protocol.h
  HDRINST usr/include/linux/hsi/hsi_char.h
  HDRINST usr/include/linux/if_alg.h
  HDRINST usr/include/linux/rseq.h
  HDRINST usr/include/linux/mroute.h
  HDRINST usr/include/linux/atmapi.h
  HDRINST usr/include/linux/ivtvfb.h
  HDRINST usr/include/linux/msg.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_redirect.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_arp.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_log.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_802_3.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_pkttype.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_ip6.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_vlan.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_ip.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_mark_t.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_arpreply.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_among.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_nat.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_nflog.h
  HDRINST usr/include/linux/netfilter_bridge/ebtables.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_limit.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_stp.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_mark_m.h
  HDRINST usr/include/linux/bt-bmc.h
  HDRINST usr/include/linux/rio_cm_cdev.h
  HDRINST usr/include/linux/n_r3964.h
  HDRINST usr/include/linux/sync_file.h
  HDRINST usr/include/linux/uio.h
  HDRINST usr/include/linux/reiserfs_fs.h
  HDRINST usr/include/linux/netfilter.h
  HDRINST usr/include/linux/fiemap.h
  HDRINST usr/include/linux/virtio_blk.h
  HDRINST usr/include/linux/virtio_ids.h
  HDRINST usr/include/linux/tls.h
  HDRINST usr/include/linux/wmi.h
  HDRINST usr/include/linux/net_namespace.h
  HDRINST usr/include/linux/bsg.h
  HDRINST usr/include/linux/mpls.h
  HDRINST usr/include/linux/caif/if_caif.h
  HDRINST usr/include/linux/caif/caif_socket.h
  HDRINST usr/include/linux/if_infiniband.h
  HDRINST usr/include/linux/edd.h
  HDRINST usr/include/linux/netrom.h
  HDRINST usr/include/linux/videodev2.h
  HDRINST usr/include/linux/fcntl.h
  HDRINST usr/include/linux/coda.h
  HDRINST usr/include/linux/kd.h
  HDRINST usr/include/linux/errqueue.h
  HDRINST usr/include/linux/virtio_types.h
  HDRINST usr/include/linux/snmp.h
  HDRINST usr/include/linux/seg6_local.h
  HDRINST usr/include/linux/if_addr.h
  HDRINST usr/include/linux/virtio_net.h
  HDRINST usr/include/linux/module.h
  HDRINST usr/include/linux/aspeed-lpc-ctrl.h
  HDRINST usr/include/linux/mii.h
  HDRINST usr/include/linux/pci.h
  HDRINST usr/include/linux/sysinfo.h
  HDRINST usr/include/linux/virtio_fs.h
  HDRINST usr/include/linux/keyboard.h
  HDRINST usr/include/linux/uvcvideo.h
  HDRINST usr/include/linux/taskstats.h
  HDRINST usr/include/linux/adb.h
  HDRINST usr/include/linux/sonet.h
  HDRINST usr/include/linux/sdla.h
  HDRINST usr/include/linux/bpf_common.h
  HDRINST usr/include/linux/v4l2-common.h
  HDRINST usr/include/linux/fsmap.h
  HDRINST usr/include/linux/selinux_netlink.h
  HDRINST usr/include/linux/efs_fs_sb.h
  HDRINST usr/include/linux/lwtunnel.h
  HDRINST usr/include/linux/fsi.h
  HDRINST usr/include/linux/atmsvc.h
  HDRINST usr/include/linux/if_frad.h
  HDRINST usr/include/linux/usbdevice_fs.h
  HDRINST usr/include/linux/cciss_ioctl.h
  HDRINST usr/include/linux/lp.h
  HDRINST usr/include/linux/if_slip.h
  HDRINST usr/include/linux/btf.h
  HDRINST usr/include/linux/pci_regs.h
  HDRINST usr/include/linux/unix_diag.h
  HDRINST usr/include/linux/if_link.h
  HDRINST usr/include/linux/udf_fs_i.h
  HDRINST usr/include/linux/sctp.h
  HDRINST usr/include/linux/xfrm.h
  HDRINST usr/include/linux/virtio_iommu.h
  HDRINST usr/include/linux/rds.h
  HDRINST usr/include/linux/nfs2.h
  HDRINST usr/include/linux/agpgart.h
  HDRINST usr/include/linux/v4l2-dv-timings.h
  HDRINST usr/include/linux/blktrace_api.h
  HDRINST usr/include/linux/socket.h
  HDRINST usr/include/linux/sonypi.h
  HDRINST usr/include/linux/tc_ematch/tc_em_nbyte.h
  HDRINST usr/include/linux/tc_ematch/tc_em_meta.h
  HDRINST usr/include/linux/tc_ematch/tc_em_text.h
  HDRINST usr/include/linux/tc_ematch/tc_em_ipt.h
  HDRINST usr/include/linux/tc_ematch/tc_em_cmp.h
  HDRINST usr/include/linux/kernel.h
  HDRINST usr/include/linux/gfs2_ondisk.h
  HDRINST usr/include/linux/if_bridge.h
  HDRINST usr/include/linux/aspeed-p2a-ctrl.h
  HDRINST usr/include/linux/isst_if.h
  HDRINST usr/include/linux/pr.h
  HDRINST usr/include/linux/ppdev.h
  HDRINST usr/include/linux/media.h
  HDRINST usr/include/linux/psample.h
  HDRINST usr/include/linux/ethtool.h
  HDRINST usr/include/linux/veth.h
  HDRINST usr/include/linux/tipc_config.h
  HDRINST usr/include/linux/pidfd.h
  HDRINST usr/include/linux/membarrier.h
  HDRINST usr/include/linux/if_tun.h
  HDRINST usr/include/linux/time_types.h
  HDRINST usr/include/linux/inotify.h
  HDRINST usr/include/linux/gpio.h
  HDRINST usr/include/linux/serial.h
  HDRINST usr/include/linux/virtio_mem.h
  HDRINST usr/include/linux/if_cablemodem.h
  HDRINST usr/include/linux/ipc.h
  HDRINST usr/include/linux/posix_acl.h
  HDRINST usr/include/linux/kdev_t.h
  HDRINST usr/include/linux/tty.h
  HDRINST usr/include/linux/idxd.h
  HDRINST usr/include/linux/adfs_fs.h
  HDRINST usr/include/linux/pmu.h
  HDRINST usr/include/linux/v4l2-controls.h
  HDRINST usr/include/linux/toshiba.h
  HDRINST usr/include/linux/vhost.h
  HDRINST usr/include/linux/nilfs2_ondisk.h
  HDRINST usr/include/linux/vmcore.h
  HDRINST usr/include/linux/virtio_input.h
  HDRINST usr/include/linux/rtc.h
  HDRINST usr/include/linux/const.h
  HDRINST usr/include/linux/hdlc.h
  HDRINST usr/include/linux/mpls_iptunnel.h
  HDRINST usr/include/linux/wireguard.h
  HDRINST usr/include/linux/timerfd.h
  HDRINST usr/include/linux/radeonfb.h
  HDRINST usr/include/linux/arcfb.h
  HDRINST usr/include/linux/firewire-constants.h
  HDRINST usr/include/linux/if_ltalk.h
  HDRINST usr/include/linux/minix_fs.h
  HDRINST usr/include/linux/max2175.h
  HDRINST usr/include/linux/scc.h
  HDRINST usr/include/linux/kcmp.h
  HDRINST usr/include/linux/ipx.h
  HDRINST usr/include/linux/usb/charger.h
  HDRINST usr/include/linux/usb/audio.h
  HDRINST usr/include/linux/usb/ch11.h
  HDRINST usr/include/linux/usb/ch9.h
  HDRINST usr/include/linux/usb/cdc.h
  HDRINST usr/include/linux/usb/g_uvc.h
  HDRINST usr/include/linux/usb/cdc-wdm.h
  HDRINST usr/include/linux/usb/gadgetfs.h
  HDRINST usr/include/linux/usb/functionfs.h
  HDRINST usr/include/linux/usb/video.h
  HDRINST usr/include/linux/usb/tmc.h
  HDRINST usr/include/linux/usb/g_printer.h
  HDRINST usr/include/linux/usb/raw_gadget.h
  HDRINST usr/include/linux/usb/midi.h
  HDRINST usr/include/linux/lirc.h
  HDRINST usr/include/linux/nl80211.h
  HDRINST usr/include/linux/uhid.h
  HDRINST usr/include/linux/filter.h
  HDRINST usr/include/linux/dlm_plock.h
  HDRINST usr/include/linux/matroxfb.h
  HDRINST usr/include/linux/close_range.h
  HDRINST usr/include/linux/pkt_cls.h
  HDRINST usr/include/linux/mei.h
  HDRINST usr/include/linux/dccp.h
  HDRINST usr/include/linux/auto_fs4.h
  HDRINST usr/include/linux/wait.h
  HDRINST usr/include/linux/sysctl.h
  HDRINST usr/include/linux/userfaultfd.h
  HDRINST usr/include/linux/connector.h
  HDRINST usr/include/linux/vm_sockets.h
  HDRINST usr/include/linux/tcp_metrics.h
  HDRINST usr/include/linux/cryptouser.h
  HDRINST usr/include/linux/scif_ioctl.h
  HDRINST usr/include/linux/devlink.h
  HDRINST usr/include/linux/cuda.h
  HDRINST usr/include/linux/poll.h
  HDRINST usr/include/linux/reboot.h
  HDRINST usr/include/linux/synclink.h
  HDRINST usr/include/linux/netfilter_ipv4.h
  HDRINST usr/include/linux/openvswitch.h
  HDRINST usr/include/linux/rio_mport_cdev.h
  HDRINST usr/include/linux/btrfs_tree.h
  HDRINST usr/include/linux/netfilter_decnet.h
  HDRINST usr/include/linux/if_ppp.h
  HDRINST usr/include/linux/iso_fs.h
  HDRINST usr/include/linux/ppp-comp.h
  HDRINST usr/include/linux/vfio_zdev.h
  HDRINST usr/include/linux/userio.h
  HDRINST usr/include/linux/hpet.h
  HDRINST usr/include/linux/byteorder/big_endian.h
  HDRINST usr/include/linux/byteorder/little_endian.h
  HDRINST usr/include/linux/sched.h
  HDRINST usr/include/linux/prctl.h
  HDRINST usr/include/linux/coresight-stm.h
  HDRINST usr/include/linux/posix_acl_xattr.h
  HDRINST usr/include/linux/mdio.h
  HDRINST usr/include/linux/cramfs_fs.h
  HDRINST usr/include/linux/audit.h
  HDRINST usr/include/linux/loop.h
  HDRINST usr/include/linux/netfilter_bridge.h
  HDRINST usr/include/linux/watch_queue.h
  HDRINST usr/include/linux/if_arcnet.h
  HDRINST usr/include/linux/rtnetlink.h
  HDRINST usr/include/linux/ipsec.h
  HDRINST usr/include/linux/usbip.h
  HDRINST usr/include/linux/bfs_fs.h
  HDRINST usr/include/linux/dm-log-userspace.h
  HDRINST usr/include/linux/blkzoned.h
  HDRINST usr/include/linux/nexthop.h
  HDRINST usr/include/linux/smc.h
  HDRINST usr/include/linux/nubus.h
  HDRINST usr/include/linux/aio_abi.h
  HDRINST usr/include/linux/sound.h
  HDRINST usr/include/linux/xilinx-v4l2-controls.h
  HDRINST usr/include/linux/vbox_vmmdev_types.h
  HDRINST usr/include/linux/dvb/net.h
  HDRINST usr/include/linux/dvb/audio.h
  HDRINST usr/include/linux/dvb/osd.h
  HDRINST usr/include/linux/dvb/frontend.h
  HDRINST usr/include/linux/dvb/version.h
  HDRINST usr/include/linux/dvb/ca.h
  HDRINST usr/include/linux/dvb/video.h
  HDRINST usr/include/linux/dvb/dmx.h
  HDRINST usr/include/linux/ipmi_bmc.h
  HDRINST usr/include/linux/input-event-codes.h
  HDRINST usr/include/linux/mman.h
  HDRINST usr/include/linux/parport.h
  HDRINST usr/include/linux/um_timetravel.h
  HDRINST usr/include/linux/if_pppox.h
  HDRINST usr/include/linux/raw.h
  HDRINST usr/include/linux/serio.h
  HDRINST usr/include/linux/hw_breakpoint.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ecn.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_REJECT.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ttl.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ah.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ECN.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_TTL.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_LOG.h
  HDRINST usr/include/linux/netfilter_ipv4/ip_tables.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
  HDRINST usr/include/linux/wireless.h
  HDRINST usr/include/linux/smc_diag.h
  HDRINST usr/include/linux/ndctl.h
  HDRINST usr/include/linux/gsmmux.h
  HDRINST usr/include/linux/mmtimer.h
  HDRINST usr/include/linux/rfkill.h
  HDRINST usr/include/linux/virtio_scsi.h
  HDRINST usr/include/linux/pfkeyv2.h
  HDRINST usr/include/linux/errno.h
  HDRINST usr/include/linux/pkt_sched.h
  HDRINST usr/include/linux/if_addrlabel.h
  HDRINST usr/include/linux/vtpm_proxy.h
  HDRINST usr/include/linux/mroute6.h
  HDRINST usr/include/linux/atm.h
  HDRINST usr/include/linux/if_packet.h
  HDRINST usr/include/linux/seg6_hmac.h
  HDRINST usr/include/linux/atmsap.h
  HDRINST usr/include/linux/atm_tcp.h
  HDRINST usr/include/linux/ivtv.h
  HDRINST usr/include/linux/virtio_console.h
  HDRINST usr/include/linux/signalfd.h
  HDRINST usr/include/linux/rpmsg.h
  HDRINST usr/include/linux/mount.h
  HDRINST usr/include/linux/cfm_bridge.h
  HDRINST usr/include/linux/vboxguest.h
  HDRINST usr/include/linux/pcitest.h
  HDRINST usr/include/linux/nfs_mount.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_ipv6header.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_frag.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_NPT.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6_tables.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_ah.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_LOG.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_hl.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_rt.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_opts.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_srh.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_HL.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_mh.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_REJECT.h
  HDRINST usr/include/linux/if_macsec.h
  HDRINST usr/include/linux/tipc_netlink.h
  HDRINST usr/include/linux/ioctl.h
  HDRINST usr/include/linux/cycx_cfm.h
  HDRINST usr/include/linux/omap3isp.h
  HDRINST usr/include/linux/icmp.h
  HDRINST usr/include/linux/kvm.h
  HDRINST usr/include/linux/in6.h
  HDRINST usr/include/linux/netfilter_arp.h
  HDRINST usr/include/linux/seg6.h
  HDRINST usr/include/linux/kernelcapi.h
  HDRINST usr/include/linux/fsl_hypervisor.h
  HDRINST usr/include/linux/bcache.h
  HDRINST usr/include/linux/fadvise.h
  HDRINST usr/include/linux/mrp_bridge.h
  HDRINST usr/include/linux/dqblk_xfs.h
  HDRINST usr/include/linux/i2o-dev.h
  HDRINST usr/include/linux/nvme_ioctl.h
  HDRINST usr/include/linux/switchtec_ioctl.h
  HDRINST usr/include/linux/thermal.h
  HDRINST usr/include/linux/hdlc/ioctl.h
  HDRINST usr/include/linux/cifs/cifs_mount.h
  HDRINST usr/include/linux/reiserfs_xattr.h
  HDRINST usr/include/linux/joystick.h
  HDRINST usr/include/linux/serial_reg.h
  HDRINST usr/include/linux/sockios.h
  HDRINST usr/include/linux/if_team.h
  HDRINST usr/include/linux/acct.h
  HDRINST usr/include/linux/atm_eni.h
  HDRINST usr/include/linux/dcbnl.h
  HDRINST usr/include/linux/smiapp.h
  HDRINST usr/include/linux/vfio.h
  HDRINST usr/include/linux/nfs4.h
  HDRINST usr/include/linux/media-bus-format.h
  HDRINST usr/include/linux/netlink.h
  HDRINST usr/include/linux/nfs_fs.h
  HDRINST usr/include/linux/icmpv6.h
  HDRINST usr/include/linux/auto_dev-ioctl.h
  HDRINST usr/include/linux/packet_diag.h
  HDRINST usr/include/linux/qnx4_fs.h
  HDRINST usr/include/linux/nfsd/nfsfh.h
  HDRINST usr/include/linux/nfsd/stats.h
  HDRINST usr/include/linux/nfsd/export.h
  HDRINST usr/include/linux/nfsd/cld.h
  HDRINST usr/include/linux/nfsd/debug.h
  HDRINST usr/include/linux/erspan.h
  HDRINST usr/include/linux/stddef.h
  HDRINST usr/include/linux/atmarp.h
  HDRINST usr/include/linux/soundcard.h
  HDRINST usr/include/linux/if_tunnel.h
  HDRINST usr/include/linux/netfilter/xt_l2tp.h
  HDRINST usr/include/linux/netfilter/xt_connbytes.h
  HDRINST usr/include/linux/netfilter/nfnetlink_compat.h
  HDRINST usr/include/linux/netfilter/xt_ipcomp.h
  HDRINST usr/include/linux/netfilter/xt_tcpudp.h
  HDRINST usr/include/linux/netfilter/xt_HMARK.h
  HDRINST usr/include/linux/netfilter/xt_LED.h
  HDRINST usr/include/linux/netfilter/xt_NFLOG.h
  HDRINST usr/include/linux/netfilter/xt_CONNSECMARK.h
  HDRINST usr/include/linux/netfilter/xt_rpfilter.h
  HDRINST usr/include/linux/netfilter/xt_IDLETIMER.h
  HDRINST usr/include/linux/netfilter/xt_CLASSIFY.h
  HDRINST usr/include/linux/netfilter/nfnetlink_osf.h
  HDRINST usr/include/linux/netfilter/xt_esp.h
  HDRINST usr/include/linux/netfilter/xt_hashlimit.h
  HDRINST usr/include/linux/netfilter/nfnetlink_log.h
  HDRINST usr/include/linux/netfilter/xt_ecn.h
  HDRINST usr/include/linux/netfilter/xt_ipvs.h
  HDRINST usr/include/linux/netfilter/xt_LOG.h
  HDRINST usr/include/linux/netfilter/xt_tcpmss.h
  HDRINST usr/include/linux/netfilter/xt_u32.h
  HDRINST usr/include/linux/netfilter/xt_recent.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_common.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_tuple_common.h
  HDRINST usr/include/linux/netfilter/xt_sctp.h
  HDRINST usr/include/linux/netfilter/xt_DSCP.h
  HDRINST usr/include/linux/netfilter/xt_SYNPROXY.h
  HDRINST usr/include/linux/netfilter/xt_owner.h
  HDRINST usr/include/linux/netfilter/xt_comment.h
  HDRINST usr/include/linux/netfilter/nfnetlink.h
  HDRINST usr/include/linux/netfilter/xt_cpu.h
  HDRINST usr/include/linux/netfilter/xt_string.h
  HDRINST usr/include/linux/netfilter/xt_AUDIT.h
  HDRINST usr/include/linux/netfilter/nfnetlink_conntrack.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_sctp.h
  HDRINST usr/include/linux/netfilter/xt_statistic.h
  HDRINST usr/include/linux/netfilter/xt_devgroup.h
  HDRINST usr/include/linux/netfilter/xt_RATEEST.h
  HDRINST usr/include/linux/netfilter/xt_bpf.h
  HDRINST usr/include/linux/netfilter/xt_quota.h
  HDRINST usr/include/linux/netfilter/xt_osf.h
  HDRINST usr/include/linux/netfilter/nfnetlink_queue.h
  HDRINST usr/include/linux/netfilter/xt_multiport.h
  HDRINST usr/include/linux/netfilter/xt_NFQUEUE.h
  HDRINST usr/include/linux/netfilter/nf_tables_compat.h
  HDRINST usr/include/linux/netfilter/xt_iprange.h
  HDRINST usr/include/linux/netfilter/xt_helper.h
  HDRINST usr/include/linux/netfilter/xt_dscp.h
  HDRINST usr/include/linux/netfilter/xt_cgroup.h
  HDRINST usr/include/linux/netfilter/xt_time.h
  HDRINST usr/include/linux/netfilter/xt_limit.h
  HDRINST usr/include/linux/netfilter/xt_state.h
  HDRINST usr/include/linux/netfilter/xt_MARK.h
  HDRINST usr/include/linux/netfilter/nf_tables.h
  HDRINST usr/include/linux/netfilter/nf_nat.h
  HDRINST usr/include/linux/netfilter/xt_CONNMARK.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_ftp.h
  HDRINST usr/include/linux/netfilter/xt_TEE.h
  HDRINST usr/include/linux/netfilter/xt_addrtype.h
  HDRINST usr/include/linux/netfilter/xt_CT.h
  HDRINST usr/include/linux/netfilter/xt_policy.h
  HDRINST usr/include/linux/netfilter/xt_rateest.h
  HDRINST usr/include/linux/netfilter/xt_dccp.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_tcp.h
  HDRINST usr/include/linux/netfilter/xt_TCPOPTSTRIP.h
  HDRINST usr/include/linux/netfilter/xt_realm.h
  HDRINST usr/include/linux/netfilter/xt_SECMARK.h
  HDRINST usr/include/linux/netfilter/xt_pkttype.h
  HDRINST usr/include/linux/netfilter/xt_conntrack.h
  HDRINST usr/include/linux/netfilter/xt_connlimit.h
  HDRINST usr/include/linux/netfilter/xt_socket.h
  HDRINST usr/include/linux/netfilter/xt_physdev.h
  HDRINST usr/include/linux/netfilter/xt_mark.h
  HDRINST usr/include/linux/netfilter/xt_connlabel.h
  HDRINST usr/include/linux/netfilter/xt_connmark.h
  HDRINST usr/include/linux/netfilter/nf_log.h
  HDRINST usr/include/linux/netfilter/xt_mac.h
  HDRINST usr/include/linux/netfilter/nfnetlink_acct.h
  HDRINST usr/include/linux/netfilter/xt_CHECKSUM.h
  HDRINST usr/include/linux/netfilter/xt_set.h
  HDRINST usr/include/linux/netfilter/xt_cluster.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set_hash.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set_bitmap.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set_list.h
  HDRINST usr/include/linux/netfilter/xt_TCPMSS.h
  HDRINST usr/include/linux/netfilter/xt_nfacct.h
  HDRINST usr/include/linux/netfilter/nf_synproxy.h
  HDRINST usr/include/linux/netfilter/xt_TPROXY.h
  HDRINST usr/include/linux/netfilter/nfnetlink_cthelper.h
  HDRINST usr/include/linux/netfilter/xt_length.h
  HDRINST usr/include/linux/netfilter/nfnetlink_cttimeout.h
  HDRINST usr/include/linux/netfilter/x_tables.h
  HDRINST usr/include/linux/affs_hardblocks.h
  HDRINST usr/include/linux/route.h
  HDRINST usr/include/linux/patchkey.h
  HDRINST usr/include/linux/virtio_mmio.h
  HDRINST usr/include/linux/nitro_enclaves.h
  HDRINST usr/include/linux/virtio_pci.h
  HDRINST usr/include/linux/tiocl.h
  HDRINST usr/include/linux/hid.h
  HDRINST usr/include/linux/virtio_gpu.h
  HDRINST usr/include/linux/dlm_device.h
  HDRINST usr/include/linux/fanotify.h
  HDRINST usr/include/linux/ppp_defs.h
  HDRINST usr/include/linux/neighbour.h
  HDRINST usr/include/linux/if.h
  HDRINST usr/include/linux/fd.h
  HDRINST usr/include/linux/watchdog.h
  HDRINST usr/include/linux/ipv6_route.h
  HDRINST usr/include/linux/dlm_netlink.h
  HDRINST usr/include/linux/ip6_tunnel.h
  HDRINST usr/include/linux/net_tstamp.h
  HDRINST usr/include/linux/genetlink.h
  HDRINST usr/include/linux/chio.h
  HDRINST usr/include/linux/random.h
  HDRINST usr/include/linux/mmc/ioctl.h
  HDRINST usr/include/linux/bcm933xx_hcs.h
  HDRINST usr/include/linux/tee.h
  HDRINST usr/include/linux/coff.h
  HDRINST usr/include/linux/screen_info.h
  HDRINST usr/include/linux/if_pppol2tp.h
  HDRINST usr/include/linux/suspend_ioctls.h
  HDRINST usr/include/linux/ipmi.h
  HDRINST usr/include/linux/virtio_9p.h
  HDRINST usr/include/linux/meye.h
  HDRINST usr/include/linux/kexec.h
  HDRINST usr/include/linux/atm_idt77105.h
  HDRINST usr/include/linux/pktcdvd.h
  HDRINST usr/include/linux/time.h
  HDRINST usr/include/linux/llc.h
  HDRINST usr/include/linux/atm_he.h
  HDRINST usr/include/linux/tty_flags.h
  HDRINST usr/include/linux/igmp.h
  HDRINST usr/include/linux/ila.h
  HDRINST usr/include/linux/seccomp.h
  HDRINST usr/include/linux/dm-ioctl.h
  HDRINST usr/include/linux/nfc.h
  HDRINST usr/include/linux/hiddev.h
  HDRINST usr/include/linux/rpl_iptunnel.h
  HDRINST usr/include/sound/asound.h
  HDRINST usr/include/sound/asequencer.h
  HDRINST usr/include/sound/skl-tplg-interface.h
  HDRINST usr/include/sound/usb_stream.h
  HDRINST usr/include/sound/tlv.h
  HDRINST usr/include/sound/snd_sst_tokens.h
  HDRINST usr/include/sound/compress_params.h
  HDRINST usr/include/sound/hdspm.h
  HDRINST usr/include/sound/sfnt_info.h
  HDRINST usr/include/sound/emu10k1.h
  HDRINST usr/include/sound/asound_fm.h
  HDRINST usr/include/sound/sof/header.h
  HDRINST usr/include/sound/sof/abi.h
  HDRINST usr/include/sound/sof/tokens.h
  HDRINST usr/include/sound/sof/fw.h
  HDRINST usr/include/sound/asoc.h
  HDRINST usr/include/sound/compress_offload.h
  HDRINST usr/include/sound/sb16_csp.h
  HDRINST usr/include/sound/hdsp.h
  HDRINST usr/include/sound/firewire.h
  HDRINST usr/include/scsi/fc/fc_fs.h
  HDRINST usr/include/scsi/fc/fc_gs.h
  HDRINST usr/include/scsi/fc/fc_ns.h
  HDRINST usr/include/scsi/fc/fc_els.h
  HDRINST usr/include/scsi/scsi_netlink.h
  HDRINST usr/include/scsi/scsi_bsg_fc.h
  HDRINST usr/include/scsi/scsi_bsg_ufs.h
  HDRINST usr/include/scsi/cxlflash_ioctl.h
  HDRINST usr/include/scsi/scsi_netlink_fc.h
  HDRINST usr/include/linux/version.h
  HDRINST usr/include/asm/auxvec.h
  HDRINST usr/include/asm/posix_types.h
  HDRINST usr/include/asm/vmx.h
  HDRINST usr/include/asm/e820.h
  HDRINST usr/include/asm/stat.h
  HDRINST usr/include/asm/ptrace.h
  HDRINST usr/include/asm/a.out.h
  HDRINST usr/include/asm/shmbuf.h
  HDRINST usr/include/asm/bootparam.h
  HDRINST usr/include/asm/signal.h
  HDRINST usr/include/asm/ldt.h
  HDRINST usr/include/asm/kvm_para.h
  HDRINST usr/include/asm/kvm_perf.h
  HDRINST usr/include/asm/mtrr.h
  HDRINST usr/include/asm/unistd.h
  HDRINST usr/include/asm/swab.h
  HDRINST usr/include/asm/msr.h
  HDRINST usr/include/asm/ucontext.h
  HDRINST usr/include/asm/siginfo.h
  HDRINST usr/include/asm/hwcap2.h
  HDRINST usr/include/asm/mce.h
  HDRINST usr/include/asm/bitsperlong.h
  HDRINST usr/include/asm/msgbuf.h
  HDRINST usr/include/asm/setup.h
  HDRINST usr/include/asm/vsyscall.h
  HDRINST usr/include/asm/posix_types_32.h
  HDRINST usr/include/asm/perf_regs.h
  HDRINST usr/include/asm/ist.h
  HDRINST usr/include/asm/posix_types_x32.h
  HDRINST usr/include/asm/svm.h
  HDRINST usr/include/asm/boot.h
  HDRINST usr/include/asm/byteorder.h
  HDRINST usr/include/asm/prctl.h
  HDRINST usr/include/asm/vm86.h
  HDRINST usr/include/asm/sigcontext32.h
  HDRINST usr/include/asm/sigcontext.h
  HDRINST usr/include/asm/statfs.h
  HDRINST usr/include/asm/mman.h
  HDRINST usr/include/asm/hw_breakpoint.h
  HDRINST usr/include/asm/posix_types_64.h
  HDRINST usr/include/asm/kvm.h
  HDRINST usr/include/asm/debugreg.h
  HDRINST usr/include/asm/processor-flags.h
  HDRINST usr/include/asm/sembuf.h
  HDRINST usr/include/asm/ptrace-abi.h
  HDRINST usr/include/asm/unistd_x32.h
  HDRINST usr/include/asm/unistd_64.h
  HDRINST usr/include/asm/unistd_32.h
  HDRINST usr/include/asm/types.h
  HDRINST usr/include/asm/termios.h
  HDRINST usr/include/asm/termbits.h
  HDRINST usr/include/asm/sockios.h
  HDRINST usr/include/asm/socket.h
  HDRINST usr/include/asm/resource.h
  HDRINST usr/include/asm/poll.h
  HDRINST usr/include/asm/param.h
  HDRINST usr/include/asm/ipcbuf.h
  HDRINST usr/include/asm/ioctls.h
  HDRINST usr/include/asm/ioctl.h
  HDRINST usr/include/asm/fcntl.h
  HDRINST usr/include/asm/errno.h
  HDRINST usr/include/asm/bpf_perf_event.h
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselfte=
sts-de900a24194807c73768a543f989161a1ee47c7e'
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseport=
_bpf.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/net/reuseport_bpf
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseport=
_bpf_cpu.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a241=
94807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/reuseport_bpf_c=
pu
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseport=
_bpf_numa.c -lnuma -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de=
900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/reusepor=
t_bpf_numa
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseport=
_dualstack.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2=
4194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/reuseport_dua=
lstack
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseaddr=
_conflict.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24=
194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/reuseaddr_conf=
lict
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    tls.c  -o=
 /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c73768a54=
3f989161a1ee47c7e/tools/testing/selftests/net/tls
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    socket.c =
 -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c73768=
a543f989161a1ee47c7e/tools/testing/selftests/net/socket
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    nettest.c=
  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c7376=
8a543f989161a1ee47c7e/tools/testing/selftests/net/nettest
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    psock_fan=
out.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807=
c73768a543f989161a1ee47c7e/tools/testing/selftests/net/psock_fanout
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    psock_tpa=
cket.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419480=
7c73768a543f989161a1ee47c7e/tools/testing/selftests/net/psock_tpacket
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    msg_zeroc=
opy.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807=
c73768a543f989161a1ee47c7e/tools/testing/selftests/net/msg_zerocopy
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseport=
_addr_any.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24=
194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/reuseport_addr=
_any
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    tcp_mmap.=
c -lpthread -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a241=
94807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/tcp_mmap
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    tcp_inq.c=
 -lpthread -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419=
4807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/tcp_inq
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    psock_snd=
=2Ec  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c=
73768a543f989161a1ee47c7e/tools/testing/selftests/net/psock_snd
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    txring_ov=
erwrite.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a2419=
4807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/txring_overwrite
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    udpgso.c =
 -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c73768=
a543f989161a1ee47c7e/tools/testing/selftests/net/udpgso
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    udpgso_be=
nch_tx.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194=
807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/udpgso_bench_tx
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    udpgso_be=
nch_rx.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194=
807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/udpgso_bench_rx
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    ip_defrag=
=2Ec  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c=
73768a543f989161a1ee47c7e/tools/testing/selftests/net/ip_defrag
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    so_txtime=
=2Ec  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c=
73768a543f989161a1ee47c7e/tools/testing/selftests/net/so_txtime
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    ipv6_flow=
label.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a241948=
07c73768a543f989161a1ee47c7e/tools/testing/selftests/net/ipv6_flowlabel
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    ipv6_flow=
label_mgr.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24=
194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/ipv6_flowlabel=
_mgr
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    tcp_fasto=
pen_backup_key.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de9=
00a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/tcp_fasto=
pen_backup_key
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    fin_ack_l=
at.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c=
73768a543f989161a1ee47c7e/tools/testing/selftests/net/fin_ack_lat
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    reuseaddr=
_ports_exhausted.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-d=
e900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/reusead=
dr_ports_exhausted
reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts unreusable_opts[12] =3D {
                                         ^
  {0, 0, 0, 0},
   {   } {   }
reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts unreusable_opts[12] =3D {
                                         ^
  {0, 0, 0, 0},
   {   } {   }
  {0, 0, 0, 1},
   {   } {   }
reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts unreusable_opts[12] =3D {
                                         ^
  {0, 0, 0, 0},
   {   } {   }
  {0, 0, 0, 1},
   {   } {   }
  {0, 0, 1, 0},
   {   } {   }
reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts unreusable_opts[12] =3D {
                                         ^
  {0, 0, 0, 0},
   {   } {   }
  {0, 0, 0, 1},
   {   } {   }
  {0, 0, 1, 0},
   {   } {   }
  {0, 0, 1, 1},
   {   } {   }
reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts unreusable_opts[12] =3D {
                                         ^
  {0, 0, 0, 0},
   {   } {   }
  {0, 0, 0, 1},
   {   } {   }
  {0, 0, 1, 0},
   {   } {   }
  {0, 0, 1, 1},
   {   } {   }
  {0, 1, 0, 0},
   {   } {   }
reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts unreusable_opts[12] =3D {
                                         ^
  {0, 0, 0, 0},
   {   } {   }
  {0, 0, 0, 1},
   {   } {   }
  {0, 0, 1, 0},
   {   } {   }
  {0, 0, 1, 1},
   {   } {   }
  {0, 1, 0, 0},
   {   } {   }
  {0, 1, 0, 1},
   {   } {   }
reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts unreusable_opts[12] =3D {
                                         ^
  {0, 0, 0, 0},
   {   } {   }
  {0, 0, 0, 1},
   {   } {   }
  {0, 0, 1, 0},
   {   } {   }
  {0, 0, 1, 1},
   {   } {   }
  {0, 1, 0, 0},
   {   } {   }
  {0, 1, 0, 1},
   {   } {   }
  {0, 1, 1, 0},
   {   } {   }
reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts unreusable_opts[12] =3D {
                                         ^
  {0, 0, 0, 0},
   {   } {   }
  {0, 0, 0, 1},
   {   } {   }
  {0, 0, 1, 0},
   {   } {   }
  {0, 0, 1, 1},
   {   } {   }
  {0, 1, 0, 0},
   {   } {   }
  {0, 1, 0, 1},
   {   } {   }
  {0, 1, 1, 0},
   {   } {   }
  {0, 1, 1, 1},
   {   } {   }
reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts unreusable_opts[12] =3D {
                                         ^
  {0, 0, 0, 0},
   {   } {   }
  {0, 0, 0, 1},
   {   } {   }
  {0, 0, 1, 0},
   {   } {   }
  {0, 0, 1, 1},
   {   } {   }
  {0, 1, 0, 0},
   {   } {   }
  {0, 1, 0, 1},
   {   } {   }
  {0, 1, 1, 0},
   {   } {   }
  {0, 1, 1, 1},
   {   } {   }
  {1, 0, 0, 0},
   {   } {   }
reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts unreusable_opts[12] =3D {
                                         ^
  {0, 0, 0, 0},
   {   } {   }
  {0, 0, 0, 1},
   {   } {   }
  {0, 0, 1, 0},
   {   } {   }
  {0, 0, 1, 1},
   {   } {   }
  {0, 1, 0, 0},
   {   } {   }
  {0, 1, 0, 1},
   {   } {   }
  {0, 1, 1, 0},
   {   } {   }
  {0, 1, 1, 1},
   {   } {   }
  {1, 0, 0, 0},
   {   } {   }
  {1, 0, 0, 1},
   {   } {   }
reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts unreusable_opts[12] =3D {
                                         ^
  {0, 0, 0, 0},
   {   } {   }
  {0, 0, 0, 1},
   {   } {   }
  {0, 0, 1, 0},
   {   } {   }
  {0, 0, 1, 1},
   {   } {   }
  {0, 1, 0, 0},
   {   } {   }
  {0, 1, 0, 1},
   {   } {   }
  {0, 1, 1, 0},
   {   } {   }
  {0, 1, 1, 1},
   {   } {   }
  {1, 0, 0, 0},
   {   } {   }
  {1, 0, 0, 1},
   {   } {   }
  {1, 0, 1, 0},
   {   } {   }
reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts unreusable_opts[12] =3D {
                                         ^
  {0, 0, 0, 0},
   {   } {   }
  {0, 0, 0, 1},
   {   } {   }
  {0, 0, 1, 0},
   {   } {   }
  {0, 0, 1, 1},
   {   } {   }
  {0, 1, 0, 0},
   {   } {   }
  {0, 1, 0, 1},
   {   } {   }
  {0, 1, 1, 0},
   {   } {   }
  {0, 1, 1, 1},
   {   } {   }
  {1, 0, 0, 0},
   {   } {   }
  {1, 0, 0, 1},
   {   } {   }
  {1, 0, 1, 0},
   {   } {   }
  {1, 0, 1, 1},
   {   } {   }
reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts unreusable_opts[12] =3D {
                                         ^
  {0, 0, 0, 0},
   {   } {   }
  {0, 0, 0, 1},
   {   } {   }
  {0, 0, 1, 0},
   {   } {   }
  {0, 0, 1, 1},
   {   } {   }
  {0, 1, 0, 0},
   {   } {   }
  {0, 1, 0, 1},
   {   } {   }
  {0, 1, 1, 0},
   {   } {   }
  {0, 1, 1, 1},
   {   } {   }
  {1, 0, 0, 0},
   {   } {   }
  {1, 0, 0, 1},
   {   } {   }
  {1, 0, 1, 0},
   {   } {   }
  {1, 0, 1, 1},
   {   } {   }
reuseaddr_ports_exhausted.c:47:38: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts reusable_opts[4] =3D {
                                      ^
  {1, 1, 0, 0},
   {   } {   }
reuseaddr_ports_exhausted.c:47:38: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts reusable_opts[4] =3D {
                                      ^
  {1, 1, 0, 0},
   {   } {   }
  {1, 1, 0, 1},
   {   } {   }
reuseaddr_ports_exhausted.c:47:38: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts reusable_opts[4] =3D {
                                      ^
  {1, 1, 0, 0},
   {   } {   }
  {1, 1, 0, 1},
   {   } {   }
  {1, 1, 1, 0},
   {   } {   }
reuseaddr_ports_exhausted.c:47:38: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts reusable_opts[4] =3D {
                                      ^
  {1, 1, 0, 0},
   {   } {   }
  {1, 1, 0, 1},
   {   } {   }
  {1, 1, 1, 0},
   {   } {   }
  {1, 1, 1, 1},
   {   } {   }
reuseaddr_ports_exhausted.c:47:38: warning: missing braces around initializ=
er [-Wmissing-braces]
 struct reuse_opts reusable_opts[4] =3D {
                                      ^
  {1, 1, 0, 0},
   {   } {   }
  {1, 1, 0, 1},
   {   } {   }
  {1, 1, 1, 0},
   {   } {   }
  {1, 1, 1, 1},
   {   } {   }
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    hwtstamp_=
config.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194=
807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/hwtstamp_config
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    rxtimesta=
mp.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c=
73768a543f989161a1ee47c7e/tools/testing/selftests/net/rxtimestamp
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    timestamp=
ing.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807=
c73768a543f989161a1ee47c7e/tools/testing/selftests/net/timestamping
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    txtimesta=
mp.c  -o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c=
73768a543f989161a1ee47c7e/tools/testing/selftests/net/txtimestamp
txtimestamp.c: In function =E2=80=98do_test=E2=80=99:
txtimestamp.c:498:6: warning: suggest explicit braces to avoid ambiguous =
=E2=80=98else=E2=80=99 [-Wdangling-else]
   if (cfg_use_pf_packet || cfg_ipproto =3D=3D IPPROTO_RAW)
      ^
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/    ipsec.c  =
-o /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c73768a=
543f989161a1ee47c7e/tools/testing/selftests/net/ipsec
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests=
-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net'
2020-12-02 17:31:30 make install INSTALL_PATH=3D/usr/bin/ -C ../../../tools=
/testing/selftests/net
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftest=
s-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net'
make --no-builtin-rules ARCH=3Dx86 -C ../../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselft=
ests-de900a24194807c73768a543f989161a1ee47c7e'
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselfte=
sts-de900a24194807c73768a543f989161a1ee47c7e'
rsync -a run_netsocktests run_afpackettests test_bpf.sh netdevice.sh rtnetl=
ink.sh xfrm_policy.sh test_blackhole_dev.sh fib_tests.sh fib-onlink-tests.s=
h pmtu.sh udpgso.sh ip_defrag.sh udpgso_bench.sh fib_rule_tests.sh msg_zero=
copy.sh psock_snd.sh udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reus=
eport_addr_any.sh test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.=
sh tcp_fastopen_backup_key.sh fcnal-test.sh  traceroute.sh fin_ack_lat.sh f=
ib_nexthop_multiprefix.sh fib_nexthops.sh altnames.sh icmp_redirect.sh ip6_=
gre_headroom.sh route_localnet.sh reuseaddr_ports_exhausted.sh txtimestamp.=
sh vrf-xfrm-tests.sh rxtimestamp.sh devlink_port_split.py drop_monitor_test=
s.sh vrf_route_leaking.sh bareudp.sh /usr/bin//
rsync -a in_netns.sh /usr/bin//
rsync -a /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c=
73768a543f989161a1ee47c7e/tools/testing/selftests/net/reuseport_bpf /usr/sr=
c/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c73768a543f989161=
a1ee47c7e/tools/testing/selftests/net/reuseport_bpf_cpu /usr/src/perf_selft=
ests-x86_64-rhel-7.6-kselftests-de900a24194807c73768a543f989161a1ee47c7e/to=
ols/testing/selftests/net/reuseport_bpf_numa /usr/src/perf_selftests-x86_64=
-rhel-7.6-kselftests-de900a24194807c73768a543f989161a1ee47c7e/tools/testing=
/selftests/net/reuseport_dualstack /usr/src/perf_selftests-x86_64-rhel-7.6-=
kselftests-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests=
/net/reuseaddr_conflict /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-=
de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/tls /u=
sr/bin//
rsync -a /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c=
73768a543f989161a1ee47c7e/tools/testing/selftests/net/socket /usr/src/perf_=
selftests-x86_64-rhel-7.6-kselftests-de900a24194807c73768a543f989161a1ee47c=
7e/tools/testing/selftests/net/nettest /usr/src/perf_selftests-x86_64-rhel-=
7.6-kselftests-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selft=
ests/net/psock_fanout /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de=
900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/psock_tp=
acket /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c737=
68a543f989161a1ee47c7e/tools/testing/selftests/net/msg_zerocopy /usr/src/pe=
rf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c73768a543f989161a1ee=
47c7e/tools/testing/selftests/net/reuseport_addr_any /usr/src/perf_selftest=
s-x86_64-rhel-7.6-kselftests-de900a24194807c73768a543f989161a1ee47c7e/tools=
/testing/selftests/net/tcp_mmap /usr/src/perf_selftests-x86_64-rhel-7.6-kse=
lftests-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/ne=
t/tcp_inq /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807=
c73768a543f989161a1ee47c7e/tools/testing/selftests/net/psock_snd /usr/src/p=
erf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c73768a543f989161a1e=
e47c7e/tools/testing/selftests/net/txring_overwrite /usr/src/perf_selftests=
-x86_64-rhel-7.6-kselftests-de900a24194807c73768a543f989161a1ee47c7e/tools/=
testing/selftests/net/udpgso /usr/src/perf_selftests-x86_64-rhel-7.6-kselft=
ests-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/u=
dpgso_bench_tx /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a241=
94807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/udpgso_bench_rx=
 /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c73768a54=
3f989161a1ee47c7e/tools/testing/selftests/net/ip_defrag /usr/src/perf_selft=
ests-x86_64-rhel-7.6-kselftests-de900a24194807c73768a543f989161a1ee47c7e/to=
ols/testing/selftests/net/so_txtime /usr/src/perf_selftests-x86_64-rhel-7.6=
-kselftests-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftest=
s/net/ipv6_flowlabel /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de9=
00a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/ipv6_flow=
label_mgr /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807=
c73768a543f989161a1ee47c7e/tools/testing/selftests/net/tcp_fastopen_backup_=
key /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c73768=
a543f989161a1ee47c7e/tools/testing/selftests/net/fin_ack_lat /usr/src/perf_=
selftests-x86_64-rhel-7.6-kselftests-de900a24194807c73768a543f989161a1ee47c=
7e/tools/testing/selftests/net/reuseaddr_ports_exhausted /usr/src/perf_self=
tests-x86_64-rhel-7.6-kselftests-de900a24194807c73768a543f989161a1ee47c7e/t=
ools/testing/selftests/net/hwtstamp_config /usr/src/perf_selftests-x86_64-r=
hel-7.6-kselftests-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/s=
elftests/net/rxtimestamp /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests=
-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net/times=
tamping /usr/src/perf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c7=
3768a543f989161a1ee47c7e/tools/testing/selftests/net/txtimestamp /usr/src/p=
erf_selftests-x86_64-rhel-7.6-kselftests-de900a24194807c73768a543f989161a1e=
e47c7e/tools/testing/selftests/net/ipsec /usr/bin//
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests=
-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net'
2020-12-02 17:31:31 make run_tests -C net
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftest=
s-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net'
make --no-builtin-rules ARCH=3Dx86 -C ../../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselft=
ests-de900a24194807c73768a543f989161a1ee47c7e'
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselfte=
sts-de900a24194807c73768a543f989161a1ee47c7e'
TAP version 13
1..47
# selftests: net: reuseport_bpf
# ---- IPv4 UDP ----
# Testing EBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing EBPF mod 20...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 10: 10
# Socket 11: 11
# Socket 12: 12
# Socket 13: 13
# Socket 14: 14
# Socket 15: 15
# Socket 16: 16
# Socket 17: 17
# Socket 18: 18
# Socket 19: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 10: 30
# Socket 11: 31
# Socket 12: 32
# Socket 13: 33
# Socket 14: 34
# Socket 15: 35
# Socket 16: 36
# Socket 17: 37
# Socket 18: 38
# Socket 19: 39
# Reprograming, testing mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 0: 30
# Socket 1: 31
# Socket 2: 32
# Socket 3: 33
# Socket 4: 34
# Socket 5: 35
# Socket 6: 36
# Socket 7: 37
# Socket 8: 38
# Socket 9: 39
# Testing CBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing CBPF mod 20...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 10: 10
# Socket 11: 11
# Socket 12: 12
# Socket 13: 13
# Socket 14: 14
# Socket 15: 15
# Socket 16: 16
# Socket 17: 17
# Socket 18: 18
# Socket 19: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 10: 30
# Socket 11: 31
# Socket 12: 32
# Socket 13: 33
# Socket 14: 34
# Socket 15: 35
# Socket 16: 36
# Socket 17: 37
# Socket 18: 38
# Socket 19: 39
# Reprograming, testing mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 0: 30
# Socket 1: 31
# Socket 2: 32
# Socket 3: 33
# Socket 4: 34
# Socket 5: 35
# Socket 6: 36
# Socket 7: 37
# Socket 8: 38
# Socket 9: 39
# Testing too many filters...
# Testing filters on non-SO_REUSEPORT socket...
# ---- IPv6 UDP ----
# Testing EBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing EBPF mod 20...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 10: 10
# Socket 11: 11
# Socket 12: 12
# Socket 13: 13
# Socket 14: 14
# Socket 15: 15
# Socket 16: 16
# Socket 17: 17
# Socket 18: 18
# Socket 19: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 10: 30
# Socket 11: 31
# Socket 12: 32
# Socket 13: 33
# Socket 14: 34
# Socket 15: 35
# Socket 16: 36
# Socket 17: 37
# Socket 18: 38
# Socket 19: 39
# Reprograming, testing mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 0: 30
# Socket 1: 31
# Socket 2: 32
# Socket 3: 33
# Socket 4: 34
# Socket 5: 35
# Socket 6: 36
# Socket 7: 37
# Socket 8: 38
# Socket 9: 39
# Testing CBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing CBPF mod 20...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 10: 10
# Socket 11: 11
# Socket 12: 12
# Socket 13: 13
# Socket 14: 14
# Socket 15: 15
# Socket 16: 16
# Socket 17: 17
# Socket 18: 18
# Socket 19: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 10: 30
# Socket 11: 31
# Socket 12: 32
# Socket 13: 33
# Socket 14: 34
# Socket 15: 35
# Socket 16: 36
# Socket 17: 37
# Socket 18: 38
# Socket 19: 39
# Reprograming, testing mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 0: 30
# Socket 1: 31
# Socket 2: 32
# Socket 3: 33
# Socket 4: 34
# Socket 5: 35
# Socket 6: 36
# Socket 7: 37
# Socket 8: 38
# Socket 9: 39
# Testing too many filters...
# Testing filters on non-SO_REUSEPORT socket...
# ---- IPv6 UDP w/ mapped IPv4 ----
# Testing EBPF mod 20...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 10: 10
# Socket 11: 11
# Socket 12: 12
# Socket 13: 13
# Socket 14: 14
# Socket 15: 15
# Socket 16: 16
# Socket 17: 17
# Socket 18: 18
# Socket 19: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 10: 30
# Socket 11: 31
# Socket 12: 32
# Socket 13: 33
# Socket 14: 34
# Socket 15: 35
# Socket 16: 36
# Socket 17: 37
# Socket 18: 38
# Socket 19: 39
# Reprograming, testing mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 0: 30
# Socket 1: 31
# Socket 2: 32
# Socket 3: 33
# Socket 4: 34
# Socket 5: 35
# Socket 6: 36
# Socket 7: 37
# Socket 8: 38
# Socket 9: 39
# Testing EBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing CBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing CBPF mod 20...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 10: 10
# Socket 11: 11
# Socket 12: 12
# Socket 13: 13
# Socket 14: 14
# Socket 15: 15
# Socket 16: 16
# Socket 17: 17
# Socket 18: 18
# Socket 19: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 10: 30
# Socket 11: 31
# Socket 12: 32
# Socket 13: 33
# Socket 14: 34
# Socket 15: 35
# Socket 16: 36
# Socket 17: 37
# Socket 18: 38
# Socket 19: 39
# Reprograming, testing mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Socket 0: 20
# Socket 1: 21
# Socket 2: 22
# Socket 3: 23
# Socket 4: 24
# Socket 5: 25
# Socket 6: 26
# Socket 7: 27
# Socket 8: 28
# Socket 9: 29
# Socket 0: 30
# Socket 1: 31
# Socket 2: 32
# Socket 3: 33
# Socket 4: 34
# Socket 5: 35
# Socket 6: 36
# Socket 7: 37
# Socket 8: 38
# Socket 9: 39
# ---- IPv4 TCP ----
# Testing EBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing CBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing too many filters...
# Testing filters on non-SO_REUSEPORT socket...
# ---- IPv6 TCP ----
# Testing EBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing CBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing too many filters...
# Testing filters on non-SO_REUSEPORT socket...
# ---- IPv6 TCP w/ mapped IPv4 ----
# Testing EBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing CBPF mod 10...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 5: 5
# Socket 6: 6
# Socket 7: 7
# Socket 8: 8
# Socket 9: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 5: 15
# Socket 6: 16
# Socket 7: 17
# Socket 8: 18
# Socket 9: 19
# Reprograming, testing mod 5...
# Socket 0: 0
# Socket 1: 1
# Socket 2: 2
# Socket 3: 3
# Socket 4: 4
# Socket 0: 5
# Socket 1: 6
# Socket 2: 7
# Socket 3: 8
# Socket 4: 9
# Socket 0: 10
# Socket 1: 11
# Socket 2: 12
# Socket 3: 13
# Socket 4: 14
# Socket 0: 15
# Socket 1: 16
# Socket 2: 17
# Socket 3: 18
# Socket 4: 19
# Testing filter add without bind...
# SUCCESS
ok 1 selftests: net: reuseport_bpf
# selftests: net: reuseport_bpf_cpu
# ---- IPv4 UDP ----
# send cpu 0, receive socket 0
# send cpu 1, receive socket 1
# send cpu 2, receive socket 2
# send cpu 3, receive socket 3
# send cpu 4, receive socket 4
# send cpu 5, receive socket 5
# send cpu 6, receive socket 6
# send cpu 7, receive socket 7
# send cpu 7, receive socket 7
# send cpu 6, receive socket 6
# send cpu 5, receive socket 5
# send cpu 4, receive socket 4
# send cpu 3, receive socket 3
# send cpu 2, receive socket 2
# send cpu 1, receive socket 1
# send cpu 0, receive socket 0
# send cpu 0, receive socket 0
# send cpu 2, receive socket 2
# send cpu 4, receive socket 4
# send cpu 6, receive socket 6
# send cpu 1, receive socket 1
# send cpu 3, receive socket 3
# send cpu 5, receive socket 5
# send cpu 7, receive socket 7
# ---- IPv6 UDP ----
# send cpu 0, receive socket 0
# send cpu 1, receive socket 1
# send cpu 2, receive socket 2
# send cpu 3, receive socket 3
# send cpu 4, receive socket 4
# send cpu 5, receive socket 5
# send cpu 6, receive socket 6
# send cpu 7, receive socket 7
# send cpu 7, receive socket 7
# send cpu 6, receive socket 6
# send cpu 5, receive socket 5
# send cpu 4, receive socket 4
# send cpu 3, receive socket 3
# send cpu 2, receive socket 2
# send cpu 1, receive socket 1
# send cpu 0, receive socket 0
# send cpu 0, receive socket 0
# send cpu 2, receive socket 2
# send cpu 4, receive socket 4
# send cpu 6, receive socket 6
# send cpu 1, receive socket 1
# send cpu 3, receive socket 3
# send cpu 5, receive socket 5
# send cpu 7, receive socket 7
# ---- IPv4 TCP ----
# send cpu 0, receive socket 0
# send cpu 1, receive socket 1
# send cpu 2, receive socket 2
# send cpu 3, receive socket 3
# send cpu 4, receive socket 4
# send cpu 5, receive socket 5
# send cpu 6, receive socket 6
# send cpu 7, receive socket 7
# send cpu 7, receive socket 7
# send cpu 6, receive socket 6
# send cpu 5, receive socket 5
# send cpu 4, receive socket 4
# send cpu 3, receive socket 3
# send cpu 2, receive socket 2
# send cpu 1, receive socket 1
# send cpu 0, receive socket 0
# send cpu 0, receive socket 0
# send cpu 2, receive socket 2
# send cpu 4, receive socket 4
# send cpu 6, receive socket 6
# send cpu 1, receive socket 1
# send cpu 3, receive socket 3
# send cpu 5, receive socket 5
# send cpu 7, receive socket 7
# ---- IPv6 TCP ----
# send cpu 0, receive socket 0
# send cpu 1, receive socket 1
# send cpu 2, receive socket 2
# send cpu 3, receive socket 3
# send cpu 4, receive socket 4
# send cpu 5, receive socket 5
# send cpu 6, receive socket 6
# send cpu 7, receive socket 7
# send cpu 7, receive socket 7
# send cpu 6, receive socket 6
# send cpu 5, receive socket 5
# send cpu 4, receive socket 4
# send cpu 3, receive socket 3
# send cpu 2, receive socket 2
# send cpu 1, receive socket 1
# send cpu 0, receive socket 0
# send cpu 0, receive socket 0
# send cpu 2, receive socket 2
# send cpu 4, receive socket 4
# send cpu 6, receive socket 6
# send cpu 1, receive socket 1
# send cpu 3, receive socket 3
# send cpu 5, receive socket 5
# send cpu 7, receive socket 7
# SUCCESS
ok 2 selftests: net: reuseport_bpf_cpu
# selftests: net: reuseport_bpf_numa
# ---- IPv4 UDP ----
# send node 0, receive socket 0
# send node 0, receive socket 0
# ---- IPv6 UDP ----
# send node 0, receive socket 0
# send node 0, receive socket 0
# ---- IPv4 TCP ----
# send node 0, receive socket 0
# send node 0, receive socket 0
# ---- IPv6 TCP ----
# send node 0, receive socket 0
# send node 0, receive socket 0
# SUCCESS
ok 3 selftests: net: reuseport_bpf_numa
# selftests: net: reuseport_dualstack
# ---- UDP IPv4 created before IPv6 ----
# ---- UDP IPv6 created before IPv4 ----
# ---- UDP IPv4 created before IPv6 (large) ----
# ---- UDP IPv6 created before IPv4 (large) ----
# ---- TCP IPv4 created before IPv6 ----
# ---- TCP IPv6 created before IPv4 ----
# SUCCESS
ok 4 selftests: net: reuseport_dualstack
# selftests: net: reuseaddr_conflict
# Opening 127.0.0.1:9999
# Opening INADDR_ANY:9999
# bind: Address already in use
# Opening in6addr_any:9999
# Opening INADDR_ANY:9999
# bind: Address already in use
# Opening INADDR_ANY:9999 after closing ipv6 socket
# bind: Address already in use
# Successok 5 selftests: net: reuseaddr_conflict
# selftests: net: tls
# TAP version 13
# 1..93
# # Starting 93 tests from 4 test cases.
# #  RUN           global.non_established ...
# #            OK  global.non_established
# ok 1 global.non_established
# #  RUN           global.keysizes ...
# #            OK  global.keysizes
# ok 2 global.keysizes
# #  RUN           tls_basic.base_base ...
# #            OK  tls_basic.base_base
# ok 3 tls_basic.base_base
# #  RUN           tls.12.sendfile ...
# #            OK  tls.12.sendfile
# ok 4 tls.12.sendfile
# #  RUN           tls.12.send_then_sendfile ...
# #            OK  tls.12.send_then_sendfile
# ok 5 tls.12.send_then_sendfile
# #  RUN           tls.12.multi_chunk_sendfile ...
# # multi_chunk_sendfile: Test terminated by timeout
# #          FAIL  tls.12.multi_chunk_sendfile
# not ok 6 tls.12.multi_chunk_sendfile
# #  RUN           tls.12.recv_max ...
# #            OK  tls.12.recv_max
# ok 7 tls.12.recv_max
# #  RUN           tls.12.recv_small ...
# #            OK  tls.12.recv_small
# ok 8 tls.12.recv_small
# #  RUN           tls.12.msg_more ...
# #            OK  tls.12.msg_more
# ok 9 tls.12.msg_more
# #  RUN           tls.12.msg_more_unsent ...
# #            OK  tls.12.msg_more_unsent
# ok 10 tls.12.msg_more_unsent
# #  RUN           tls.12.sendmsg_single ...
# #            OK  tls.12.sendmsg_single
# ok 11 tls.12.sendmsg_single
# #  RUN           tls.12.sendmsg_fragmented ...
# #            OK  tls.12.sendmsg_fragmented
# ok 12 tls.12.sendmsg_fragmented
# #  RUN           tls.12.sendmsg_large ...
# #            OK  tls.12.sendmsg_large
# ok 13 tls.12.sendmsg_large
# #  RUN           tls.12.sendmsg_multiple ...
# #            OK  tls.12.sendmsg_multiple
# ok 14 tls.12.sendmsg_multiple
# #  RUN           tls.12.sendmsg_multiple_stress ...
# #            OK  tls.12.sendmsg_multiple_stress
# ok 15 tls.12.sendmsg_multiple_stress
# #  RUN           tls.12.splice_from_pipe ...
# #            OK  tls.12.splice_from_pipe
# ok 16 tls.12.splice_from_pipe
# #  RUN           tls.12.splice_from_pipe2 ...
# #            OK  tls.12.splice_from_pipe2
# ok 17 tls.12.splice_from_pipe2
# #  RUN           tls.12.send_and_splice ...
# #            OK  tls.12.send_and_splice
# ok 18 tls.12.send_and_splice
# #  RUN           tls.12.splice_to_pipe ...
# #            OK  tls.12.splice_to_pipe
# ok 19 tls.12.splice_to_pipe
# #  RUN           tls.12.recvmsg_single ...
# #            OK  tls.12.recvmsg_single
# ok 20 tls.12.recvmsg_single
# #  RUN           tls.12.recvmsg_single_max ...
# #            OK  tls.12.recvmsg_single_max
# ok 21 tls.12.recvmsg_single_max
# #  RUN           tls.12.recvmsg_multiple ...
# #            OK  tls.12.recvmsg_multiple
# ok 22 tls.12.recvmsg_multiple
# #  RUN           tls.12.single_send_multiple_recv ...
# #            OK  tls.12.single_send_multiple_recv
# ok 23 tls.12.single_send_multiple_recv
# #  RUN           tls.12.multiple_send_single_recv ...
# #            OK  tls.12.multiple_send_single_recv
# ok 24 tls.12.multiple_send_single_recv
# #  RUN           tls.12.single_send_multiple_recv_non_align ...
# #            OK  tls.12.single_send_multiple_recv_non_align
# ok 25 tls.12.single_send_multiple_recv_non_align
# #  RUN           tls.12.recv_partial ...
# #            OK  tls.12.recv_partial
# ok 26 tls.12.recv_partial
# #  RUN           tls.12.recv_nonblock ...
# #            OK  tls.12.recv_nonblock
# ok 27 tls.12.recv_nonblock
# #  RUN           tls.12.recv_peek ...
# #            OK  tls.12.recv_peek
# ok 28 tls.12.recv_peek
# #  RUN           tls.12.recv_peek_multiple ...
# #            OK  tls.12.recv_peek_multiple
# ok 29 tls.12.recv_peek_multiple
# #  RUN           tls.12.recv_peek_multiple_records ...
# #            OK  tls.12.recv_peek_multiple_records
# ok 30 tls.12.recv_peek_multiple_records
# #  RUN           tls.12.recv_peek_large_buf_mult_recs ...
# #            OK  tls.12.recv_peek_large_buf_mult_recs
# ok 31 tls.12.recv_peek_large_buf_mult_recs
# #  RUN           tls.12.recv_lowat ...
# #            OK  tls.12.recv_lowat
# ok 32 tls.12.recv_lowat
# #  RUN           tls.12.bidir ...
# #            OK  tls.12.bidir
# ok 33 tls.12.bidir
# #  RUN           tls.12.pollin ...
# #            OK  tls.12.pollin
# ok 34 tls.12.pollin
# #  RUN           tls.12.poll_wait ...
# #            OK  tls.12.poll_wait
# ok 35 tls.12.poll_wait
# #  RUN           tls.12.poll_wait_split ...
# #            OK  tls.12.poll_wait_split
# ok 36 tls.12.poll_wait_split
# #  RUN           tls.12.blocking ...
# #            OK  tls.12.blocking
# ok 37 tls.12.blocking
# #  RUN           tls.12.nonblocking ...
# #            OK  tls.12.nonblocking
# ok 38 tls.12.nonblocking
# #  RUN           tls.12.mutliproc_even ...
# #            OK  tls.12.mutliproc_even
# ok 39 tls.12.mutliproc_even
# #  RUN           tls.12.mutliproc_readers ...
# #            OK  tls.12.mutliproc_readers
# ok 40 tls.12.mutliproc_readers
# #  RUN           tls.12.mutliproc_writers ...
# #            OK  tls.12.mutliproc_writers
# ok 41 tls.12.mutliproc_writers
# #  RUN           tls.12.mutliproc_sendpage_even ...
# #            OK  tls.12.mutliproc_sendpage_even
# ok 42 tls.12.mutliproc_sendpage_even
# #  RUN           tls.12.mutliproc_sendpage_readers ...
# #            OK  tls.12.mutliproc_sendpage_readers
# ok 43 tls.12.mutliproc_sendpage_readers
# #  RUN           tls.12.mutliproc_sendpage_writers ...
# #            OK  tls.12.mutliproc_sendpage_writers
# ok 44 tls.12.mutliproc_sendpage_writers
# #  RUN           tls.12.control_msg ...
# #            OK  tls.12.control_msg
# ok 45 tls.12.control_msg
# #  RUN           tls.12.shutdown ...
# #            OK  tls.12.shutdown
# ok 46 tls.12.shutdown
# #  RUN           tls.12.shutdown_unsent ...
# #            OK  tls.12.shutdown_unsent
# ok 47 tls.12.shutdown_unsent
# #  RUN           tls.12.shutdown_reuse ...
# #            OK  tls.12.shutdown_reuse
# ok 48 tls.12.shutdown_reuse
# #  RUN           tls.13.sendfile ...
# #            OK  tls.13.sendfile
# ok 49 tls.13.sendfile
# #  RUN           tls.13.send_then_sendfile ...
# #            OK  tls.13.send_then_sendfile
# ok 50 tls.13.send_then_sendfile
# #  RUN           tls.13.multi_chunk_sendfile ...
# # multi_chunk_sendfile: Test terminated by timeout
# #          FAIL  tls.13.multi_chunk_sendfile
# not ok 51 tls.13.multi_chunk_sendfile
# #  RUN           tls.13.recv_max ...
# #            OK  tls.13.recv_max
# ok 52 tls.13.recv_max
# #  RUN           tls.13.recv_small ...
# #            OK  tls.13.recv_small
# ok 53 tls.13.recv_small
# #  RUN           tls.13.msg_more ...
# #            OK  tls.13.msg_more
# ok 54 tls.13.msg_more
# #  RUN           tls.13.msg_more_unsent ...
# #            OK  tls.13.msg_more_unsent
# ok 55 tls.13.msg_more_unsent
# #  RUN           tls.13.sendmsg_single ...
# #            OK  tls.13.sendmsg_single
# ok 56 tls.13.sendmsg_single
# #  RUN           tls.13.sendmsg_fragmented ...
# #            OK  tls.13.sendmsg_fragmented
# ok 57 tls.13.sendmsg_fragmented
# #  RUN           tls.13.sendmsg_large ...
# #            OK  tls.13.sendmsg_large
# ok 58 tls.13.sendmsg_large
# #  RUN           tls.13.sendmsg_multiple ...
# #            OK  tls.13.sendmsg_multiple
# ok 59 tls.13.sendmsg_multiple
# #  RUN           tls.13.sendmsg_multiple_stress ...
# #            OK  tls.13.sendmsg_multiple_stress
# ok 60 tls.13.sendmsg_multiple_stress
# #  RUN           tls.13.splice_from_pipe ...
# #            OK  tls.13.splice_from_pipe
# ok 61 tls.13.splice_from_pipe
# #  RUN           tls.13.splice_from_pipe2 ...
# #            OK  tls.13.splice_from_pipe2
# ok 62 tls.13.splice_from_pipe2
# #  RUN           tls.13.send_and_splice ...
# #            OK  tls.13.send_and_splice
# ok 63 tls.13.send_and_splice
# #  RUN           tls.13.splice_to_pipe ...
# #            OK  tls.13.splice_to_pipe
# ok 64 tls.13.splice_to_pipe
# #  RUN           tls.13.recvmsg_single ...
# #            OK  tls.13.recvmsg_single
# ok 65 tls.13.recvmsg_single
# #  RUN           tls.13.recvmsg_single_max ...
# #            OK  tls.13.recvmsg_single_max
# ok 66 tls.13.recvmsg_single_max
# #  RUN           tls.13.recvmsg_multiple ...
# #            OK  tls.13.recvmsg_multiple
# ok 67 tls.13.recvmsg_multiple
# #  RUN           tls.13.single_send_multiple_recv ...
# #            OK  tls.13.single_send_multiple_recv
# ok 68 tls.13.single_send_multiple_recv
# #  RUN           tls.13.multiple_send_single_recv ...
# #            OK  tls.13.multiple_send_single_recv
# ok 69 tls.13.multiple_send_single_recv
# #  RUN           tls.13.single_send_multiple_recv_non_align ...
# #            OK  tls.13.single_send_multiple_recv_non_align
# ok 70 tls.13.single_send_multiple_recv_non_align
# #  RUN           tls.13.recv_partial ...
# #            OK  tls.13.recv_partial
# ok 71 tls.13.recv_partial
# #  RUN           tls.13.recv_nonblock ...
# #            OK  tls.13.recv_nonblock
# ok 72 tls.13.recv_nonblock
# #  RUN           tls.13.recv_peek ...
# #            OK  tls.13.recv_peek
# ok 73 tls.13.recv_peek
# #  RUN           tls.13.recv_peek_multiple ...
# #            OK  tls.13.recv_peek_multiple
# ok 74 tls.13.recv_peek_multiple
# #  RUN           tls.13.recv_peek_multiple_records ...
# #            OK  tls.13.recv_peek_multiple_records
# ok 75 tls.13.recv_peek_multiple_records
# #  RUN           tls.13.recv_peek_large_buf_mult_recs ...
# #            OK  tls.13.recv_peek_large_buf_mult_recs
# ok 76 tls.13.recv_peek_large_buf_mult_recs
# #  RUN           tls.13.recv_lowat ...
# #            OK  tls.13.recv_lowat
# ok 77 tls.13.recv_lowat
# #  RUN           tls.13.bidir ...
# #            OK  tls.13.bidir
# ok 78 tls.13.bidir
# #  RUN           tls.13.pollin ...
# #            OK  tls.13.pollin
# ok 79 tls.13.pollin
# #  RUN           tls.13.poll_wait ...
# #            OK  tls.13.poll_wait
# ok 80 tls.13.poll_wait
# #  RUN           tls.13.poll_wait_split ...
# #            OK  tls.13.poll_wait_split
# ok 81 tls.13.poll_wait_split
# #  RUN           tls.13.blocking ...
# #            OK  tls.13.blocking
# ok 82 tls.13.blocking
# #  RUN           tls.13.nonblocking ...
# #            OK  tls.13.nonblocking
# ok 83 tls.13.nonblocking
# #  RUN           tls.13.mutliproc_even ...
# #            OK  tls.13.mutliproc_even
# ok 84 tls.13.mutliproc_even
# #  RUN           tls.13.mutliproc_readers ...
# #            OK  tls.13.mutliproc_readers
# ok 85 tls.13.mutliproc_readers
# #  RUN           tls.13.mutliproc_writers ...
# #            OK  tls.13.mutliproc_writers
# ok 86 tls.13.mutliproc_writers
# #  RUN           tls.13.mutliproc_sendpage_even ...
# #            OK  tls.13.mutliproc_sendpage_even
# ok 87 tls.13.mutliproc_sendpage_even
# #  RUN           tls.13.mutliproc_sendpage_readers ...
# #            OK  tls.13.mutliproc_sendpage_readers
# ok 88 tls.13.mutliproc_sendpage_readers
# #  RUN           tls.13.mutliproc_sendpage_writers ...
# #            OK  tls.13.mutliproc_sendpage_writers
# ok 89 tls.13.mutliproc_sendpage_writers
# #  RUN           tls.13.control_msg ...
# #            OK  tls.13.control_msg
# ok 90 tls.13.control_msg
# #  RUN           tls.13.shutdown ...
# #            OK  tls.13.shutdown
# ok 91 tls.13.shutdown
# #  RUN           tls.13.shutdown_unsent ...
# #            OK  tls.13.shutdown_unsent
# ok 92 tls.13.shutdown_unsent
# #  RUN           tls.13.shutdown_reuse ...
# #            OK  tls.13.shutdown_reuse
# ok 93 tls.13.shutdown_reuse
# # FAILED: 91 / 93 tests passed.
# # Totals: pass:91 fail:2 xfail:0 xpass:0 skip:0 error:0
not ok 6 selftests: net: tls # exit=3D1
# selftests: net: run_netsocktests
# --------------------
# running socket test
# --------------------
# socket(44, 0, 0) expected err (Address family not supported by protocol) =
got (Socket type not supported)
# [FAIL]
not ok 7 selftests: net: run_netsocktests # exit=3D1
# selftests: net: run_afpackettests
# --------------------
# running psock_fanout test
# --------------------
# test: control single socket
# test: control multiple sockets
# test: control multiple sockets, max_num_members
# test: unique ids
#=20
# test: datapath 0x0 ports 8000,8002
# info: count=3D0,0, expect=3D0,0
# info: count=3D0,20, expect=3D15,5
# warning: incorrect queue lengths
# info: count=3D0,20, expect=3D20,5
# warning: incorrect queue lengths
# info: trying alternate ports (20)
#=20
# test: datapath 0x0 ports 8000,8003
# info: count=3D0,0, expect=3D0,0
# info: count=3D0,20, expect=3D15,5
# warning: incorrect queue lengths
# info: count=3D0,20, expect=3D20,5
# warning: incorrect queue lengths
# info: trying alternate ports (19)
#=20
# test: datapath 0x0 ports 8000,8004
# info: count=3D0,0, expect=3D0,0
# info: count=3D5,15, expect=3D15,5
# info: count=3D5,20, expect=3D20,5
#=20
# test: datapath 0x1000 ports 8000,8004
# info: count=3D0,0, expect=3D0,0
# info: count=3D5,15, expect=3D15,5
# info: count=3D15,20, expect=3D20,15
#=20
# test: datapath 0x1 ports 8000,8004
# info: count=3D0,0, expect=3D0,0
# info: count=3D10,10, expect=3D10,10
# info: count=3D17,18, expect=3D18,17
#=20
# test: datapath 0x3 ports 8000,8004
# info: count=3D0,0, expect=3D0,0
# info: count=3D15,5, expect=3D15,5
# info: count=3D20,15, expect=3D20,15
#=20
# test: datapath 0x6 ports 8000,8004
# info: count=3D0,0, expect=3D0,0
# info: count=3D5,15, expect=3D15,5
# info: count=3D20,15, expect=3D15,20
#=20
# test: datapath 0x7 ports 8000,8004
# info: count=3D0,0, expect=3D0,0
# info: count=3D5,15, expect=3D15,5
# info: count=3D20,15, expect=3D15,20
#=20
# test: datapath 0x2 ports 8000,8004
# info: count=3D0,0, expect=3D0,0
# info: count=3D20,0, expect=3D20,0
# info: count=3D20,0, expect=3D20,0
#=20
# test: datapath 0x2 ports 8000,8004
# info: count=3D0,0, expect=3D0,0
# info: count=3D0,20, expect=3D0,20
# info: count=3D0,20, expect=3D0,20
#=20
# test: datapath 0x2000 ports 8000,8004
# info: count=3D0,0, expect=3D0,0
# info: count=3D20,20, expect=3D20,20
# info: count=3D20,20, expect=3D20,20
# OK. All tests passed
# [PASS]
# --------------------
# running psock_tpacket test
# --------------------
# test: TPACKET_V1 with PACKET_RX_RING .................... 100 pkts (14200=
 bytes)
# test: TPACKET_V1 with PACKET_TX_RING .................... 100 pkts (14200=
 bytes)
# test: TPACKET_V2 with PACKET_RX_RING .................... 100 pkts (14200=
 bytes)
# test: TPACKET_V2 with PACKET_TX_RING .................... 100 pkts (14200=
 bytes)
# test: TPACKET_V3 with PACKET_RX_RING .................... 100 pkts (14200=
 bytes)
# test: TPACKET_V3 with PACKET_TX_RING .................... 100 pkts (14200=
 bytes)
# OK. All tests passed
# [PASS]
# --------------------
# running txring_overwrite test
# --------------------
# read: a (0x61)
# read: b (0x62)
# [PASS]
ok 8 selftests: net: run_afpackettests
# selftests: net: test_bpf.sh
# test_bpf: [FAIL]
not ok 9 selftests: net: test_bpf.sh # exit=3D1
# selftests: net: netdevice.sh
# SKIP: eth0: interface already up
# PASS: eth0: ethtool list features
# PASS: eth0: ethtool dump
# PASS: eth0: ethtool stats
# SKIP: eth0: interface kept up
ok 10 selftests: net: netdevice.sh
# selftests: net: rtnetlink.sh
# PASS: policy routing
# PASS: route get
# PASS: preferred_lft addresses have expired
# PASS: promote_secondaries complete
# PASS: tc htb hierarchy
# PASS: gre tunnel endpoint
# PASS: gretap
# PASS: ip6gretap
# PASS: erspan
# PASS: ip6erspan
# PASS: bridge setup
# PASS: ipv6 addrlabel
# PASS: set ifalias 6cb97d08-b0c4-49c4-9bcf-9add43c868a8 for test-dummy0
# PASS: vrf
# PASS: vxlan
# PASS: fou
# PASS: macsec
# PASS: ipsec
# FAIL: ipsec_offload netdevsim doesn't support IPsec offload
# PASS: bridge fdb get
# PASS: neigh get
# PASS: bridge_parent_id
not ok 11 selftests: net: rtnetlink.sh # exit=3D1
# selftests: net: xfrm_policy.sh
# PASS: policy before exception matches
# PASS: ping to .254 bypassed ipsec tunnel (exceptions)
# PASS: direct policy matches (exceptions)
# PASS: policy matches (exceptions)
# PASS: ping to .254 bypassed ipsec tunnel (exceptions and block policies)
# PASS: direct policy matches (exceptions and block policies)
# PASS: policy matches (exceptions and block policies)
# PASS: ping to .254 bypassed ipsec tunnel (exceptions and block policies a=
fter hresh changes)
# PASS: direct policy matches (exceptions and block policies after hresh ch=
anges)
# PASS: policy matches (exceptions and block policies after hresh changes)
# PASS: ping to .254 bypassed ipsec tunnel (exceptions and block policies a=
fter hthresh change in ns3)
# PASS: direct policy matches (exceptions and block policies after hthresh =
change in ns3)
# PASS: policy matches (exceptions and block policies after hthresh change =
in ns3)
# PASS: ping to .254 bypassed ipsec tunnel (exceptions and block policies a=
fter htresh change to normal)
# PASS: direct policy matches (exceptions and block policies after htresh c=
hange to normal)
# PASS: policy matches (exceptions and block policies after htresh change t=
o normal)
# PASS: policies with repeated htresh change
ok 12 selftests: net: xfrm_policy.sh
# selftests: net: test_blackhole_dev.sh
# test_blackhole_dev: ok
ok 13 selftests: net: test_blackhole_dev.sh
# selftests: net: fib_tests.sh
#=20
# Single path route test
#     Start point
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     Nexthop device deleted
#     TEST: IPv4 fibmatch - no route                                      [=
 OK ]
#     TEST: IPv6 fibmatch - no route                                      [=
 OK ]
#=20
# Multipath route test
#     Start point
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     One nexthop device deleted
#     TEST: IPv4 - multipath route removed on delete                      [=
 OK ]
#     TEST: IPv6 - multipath down to single path                          [=
 OK ]
#     Second nexthop device deleted
#     TEST: IPv6 - no route                                               [=
 OK ]
#=20
# Single path, admin down
#     Start point
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     Route deleted on down
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#=20
# Admin down multipath
#     Verify start point
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     One device down, one up
#     TEST: IPv4 fibmatch on down device                                  [=
 OK ]
#     TEST: IPv6 fibmatch on down device                                  [=
 OK ]
#     TEST: IPv4 fibmatch on up device                                    [=
 OK ]
#     TEST: IPv6 fibmatch on up device                                    [=
 OK ]
#     TEST: IPv4 flags on down device                                     [=
 OK ]
#     TEST: IPv6 flags on down device                                     [=
 OK ]
#     TEST: IPv4 flags on up device                                       [=
 OK ]
#     TEST: IPv6 flags on up device                                       [=
 OK ]
#     Other device down and up
#     TEST: IPv4 fibmatch on down device                                  [=
 OK ]
#     TEST: IPv6 fibmatch on down device                                  [=
 OK ]
#     TEST: IPv4 fibmatch on up device                                    [=
 OK ]
#     TEST: IPv6 fibmatch on up device                                    [=
 OK ]
#     TEST: IPv4 flags on down device                                     [=
 OK ]
#     TEST: IPv6 flags on down device                                     [=
 OK ]
#     TEST: IPv4 flags on up device                                       [=
 OK ]
#     TEST: IPv6 flags on up device                                       [=
 OK ]
#     Both devices down
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#=20
# Local carrier tests - single path
#     Start point
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     TEST: IPv4 - no linkdown flag                                       [=
 OK ]
#     TEST: IPv6 - no linkdown flag                                       [=
 OK ]
#     Carrier off on nexthop
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     TEST: IPv4 - linkdown flag set                                      [=
 OK ]
#     TEST: IPv6 - linkdown flag set                                      [=
 OK ]
#     Route to local address with carrier down
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     TEST: IPv4 linkdown flag set                                        [=
 OK ]
#     TEST: IPv6 linkdown flag set                                        [=
 OK ]
#=20
# Single path route carrier test
#     Start point
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     TEST: IPv4 no linkdown flag                                         [=
 OK ]
#     TEST: IPv6 no linkdown flag                                         [=
 OK ]
#     Carrier down
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     TEST: IPv4 linkdown flag set                                        [=
 OK ]
#     TEST: IPv6 linkdown flag set                                        [=
 OK ]
#     Second address added with carrier down
#     TEST: IPv4 fibmatch                                                 [=
 OK ]
#     TEST: IPv6 fibmatch                                                 [=
 OK ]
#     TEST: IPv4 linkdown flag set                                        [=
 OK ]
#     TEST: IPv6 linkdown flag set                                        [=
 OK ]
#=20
# IPv4 nexthop tests
# <<< write me >>>
#=20
# IPv6 nexthop tests
#     TEST: Directly connected nexthop, unicast address                   [=
 OK ]
#     TEST: Directly connected nexthop, unicast address with device       [=
 OK ]
#     TEST: Gateway is linklocal address                                  [=
 OK ]
#     TEST: Gateway is linklocal address, no device                       [=
 OK ]
#     TEST: Gateway can not be local unicast address                      [=
 OK ]
#     TEST: Gateway can not be local unicast address, with device         [=
 OK ]
#     TEST: Gateway can not be a local linklocal address                  [=
 OK ]
#     TEST: Gateway can be local address in a VRF                         [=
 OK ]
#     TEST: Gateway can be local address in a VRF, with device            [=
 OK ]
#     TEST: Gateway can be local linklocal address in a VRF               [=
 OK ]
#     TEST: Redirect to VRF lookup                                        [=
 OK ]
#     TEST: VRF route, gateway can be local address in default VRF        [=
 OK ]
#     TEST: VRF route, gateway can not be a local address                 [=
 OK ]
#     TEST: VRF route, gateway can not be a local addr with device        [=
 OK ]
#=20
# FIB rule with suppress_prefixlength
#     TEST: FIB rule suppress test                                        [=
 OK ]
#=20
# IPv6 route add / append tests
#     TEST: Attempt to add duplicate route - gw                           [=
 OK ]
#     TEST: Attempt to add duplicate route - dev only                     [=
 OK ]
#     TEST: Attempt to add duplicate route - reject route                 [=
 OK ]
#     TEST: Append nexthop to existing route - gw                         [=
 OK ]
#     TEST: Add multipath route                                           [=
 OK ]
#     TEST: Attempt to add duplicate multipath route                      [=
 OK ]
#     TEST: Route add with different metrics                              [=
 OK ]
#     TEST: Route delete with metric                                      [=
 OK ]
#=20
# IPv6 route replace tests
#     TEST: Single path with single path                                  [=
 OK ]
#     TEST: Single path with multipath                                    [=
 OK ]
#     TEST: Single path with single path via multipath attribute          [=
 OK ]
#     TEST: Invalid nexthop                                               [=
 OK ]
#     TEST: Single path - replace of non-existent route                   [=
 OK ]
#     TEST: Multipath with multipath                                      [=
 OK ]
#     TEST: Multipath with single path                                    [=
 OK ]
#     TEST: Multipath with single path via multipath attribute            [=
 OK ]
#     TEST: Multipath with dev-only                                       [=
 OK ]
#     TEST: Multipath - invalid first nexthop                             [=
 OK ]
#     TEST: Multipath - invalid second nexthop                            [=
 OK ]
#     TEST: Multipath - replace of non-existent route                     [=
 OK ]
#=20
# IPv4 route add / append tests
#     TEST: Attempt to add duplicate route - gw                           [=
 OK ]
#     TEST: Attempt to add duplicate route - dev only                     [=
 OK ]
#     TEST: Attempt to add duplicate route - reject route                 [=
 OK ]
#     TEST: Add new nexthop for existing prefix                           [=
 OK ]
#     TEST: Append nexthop to existing route - gw                         [=
 OK ]
#     TEST: Append nexthop to existing route - dev only                   [=
 OK ]
#     TEST: Append nexthop to existing route - reject route               [=
 OK ]
#     TEST: Append nexthop to existing reject route - gw                  [=
 OK ]
#     TEST: Append nexthop to existing reject route - dev only            [=
 OK ]
#     TEST: add multipath route                                           [=
 OK ]
#     TEST: Attempt to add duplicate multipath route                      [=
 OK ]
#     TEST: Route add with different metrics                              [=
 OK ]
#     TEST: Route delete with metric                                      [=
 OK ]
#=20
# IPv4 route replace tests
#     TEST: Single path with single path                                  [=
 OK ]
#     TEST: Single path with multipath                                    [=
 OK ]
#     TEST: Single path with reject route                                 [=
 OK ]
#     TEST: Single path with single path via multipath attribute          [=
 OK ]
#     TEST: Invalid nexthop                                               [=
 OK ]
#     TEST: Single path - replace of non-existent route                   [=
 OK ]
#     TEST: Multipath with multipath                                      [=
 OK ]
#     TEST: Multipath with single path                                    [=
 OK ]
#     TEST: Multipath with single path via multipath attribute            [=
 OK ]
#     TEST: Multipath with reject route                                   [=
 OK ]
#     TEST: Multipath - invalid first nexthop                             [=
 OK ]
#     TEST: Multipath - invalid second nexthop                            [=
 OK ]
#     TEST: Multipath - replace of non-existent route                     [=
 OK ]
#=20
# IPv6 prefix route tests
#     TEST: Default metric                                                [=
 OK ]
#     TEST: User specified metric on first device                         [=
 OK ]
#     TEST: User specified metric on second device                        [=
 OK ]
#     TEST: Delete of address on first device                             [=
 OK ]
#     TEST: Modify metric of address                                      [=
 OK ]
#     TEST: Prefix route removed on link down                             [=
 OK ]
#     TEST: Prefix route with metric on link up                           [=
 OK ]
#     TEST: Set metric with peer route on local side                      [=
 OK ]
#     TEST: User specified metric on local address                        [=
 OK ]
#     TEST: Set metric with peer route on peer side                       [=
 OK ]
#     TEST: Modify metric and peer address on local side                  [=
 OK ]
#     TEST: Modify metric and peer address on peer side                   [=
 OK ]
#=20
# IPv4 prefix route tests
#     TEST: Default metric                                                [=
 OK ]
#     TEST: User specified metric on first device                         [=
 OK ]
#     TEST: User specified metric on second device                        [=
 OK ]
#     TEST: Delete of address on first device                             [=
 OK ]
#     TEST: Modify metric of address                                      [=
 OK ]
#     TEST: Prefix route removed on link down                             [=
 OK ]
#     TEST: Prefix route with metric on link up                           [=
 OK ]
#     TEST: Modify metric of .0/24 address                                [=
 OK ]
#     TEST: Set metric of address with peer route                         [=
 OK ]
#     TEST: Modify metric and peer address for peer route                 [=
 OK ]
#=20
# IPv6 routes with metrics
#     TEST: Single path route with mtu metric                             [=
 OK ]
#     TEST: Multipath route via 2 single routes with mtu metric on first  [=
 OK ]
#     TEST: Multipath route via 2 single routes with mtu metric on 2nd    [=
 OK ]
#     TEST:     MTU of second leg                                         [=
 OK ]
#     TEST: Multipath route with mtu metric                               [=
 OK ]
#     TEST: Using route with mtu metric                                   [=
 OK ]
#     TEST: Invalid metric (fails metric_convert)                         [=
 OK ]
#=20
# IPv4 route add / append tests
#     TEST: Single path route with mtu metric                             [=
 OK ]
#     TEST: Multipath route with mtu metric                               [=
 OK ]
#     TEST: Using route with mtu metric                                   [=
 OK ]
#     TEST: Invalid metric (fails metric_convert)                         [=
 OK ]
#=20
# IPv4 route with IPv6 gateway tests
#     TEST: Single path route with IPv6 gateway                           [=
 OK ]
#     TEST: Single path route with IPv6 gateway - ping                    [=
 OK ]
#     TEST: Single path route delete                                      [=
 OK ]
#     TEST: Multipath route add - v6 nexthop then v4                      [=
 OK ]
#     TEST:     Multipath route delete - nexthops in wrong order          [=
 OK ]
#     TEST:     Multipath route delete exact match                        [=
 OK ]
#     TEST: Multipath route add - v4 nexthop then v6                      [=
 OK ]
#     TEST:     Multipath route delete - nexthops in wrong order          [=
 OK ]
#     TEST:     Multipath route delete exact match                        [=
 OK ]
#=20
# IPv4 rp_filter tests
#     TEST: rp_filter passes local packets                                [=
FAIL]
#     TEST: rp_filter passes loopback packets                             [=
FAIL]
#=20
# IPv4 delete address route tests
#     TEST: Route removed from VRF when source address deleted            [=
 OK ]
#     TEST: Route in default VRF not removed                              [=
 OK ]
#     TEST: Route removed in default VRF when source address deleted      [=
 OK ]
#     TEST: Route in VRF is not removed by address delete                 [=
 OK ]
#=20
# Tests passed: 164
# Tests failed:   2
not ok 14 selftests: net: fib_tests.sh # exit=3D1
# selftests: net: fib-onlink-tests.sh
# Error: ipv4: FIB table does not exist.
# Flush terminated
# Error: ipv6: FIB table does not exist.
# Flush terminated
#=20
# ########################################
# Configuring interfaces
#=20
# ######################################################################
# TEST SECTION: IPv4 onlink
# ######################################################################
#=20
# #########################################
# TEST SUBSECTION: Valid onlink commands
#=20
# #########################################
# TEST SUBSECTION: default VRF - main table
#     TEST: unicast connected                                   [ OK ]
#     TEST: unicast recursive                                   [ OK ]
#=20
# #########################################
# TEST SUBSECTION: VRF lisa
#     TEST: unicast connected                                   [ OK ]
#     TEST: unicast recursive                                   [ OK ]
#=20
# #########################################
# TEST SUBSECTION: VRF device, PBR table
#     TEST: unicast connected                                   [ OK ]
#     TEST: unicast recursive                                   [ OK ]
#=20
# #########################################
# TEST SUBSECTION: default VRF - main table - multipath
#     TEST: unicast connected - multipath                       [ OK ]
#     TEST: unicast recursive - multipath                       [ OK ]
#     TEST: unicast connected - multipath onlink first only     [ OK ]
#     TEST: unicast connected - multipath onlink second only    [ OK ]
#=20
# #########################################
# TEST SUBSECTION: Invalid onlink commands
#     TEST: Invalid gw - local unicast address                  [ OK ]
#     TEST: Invalid gw - local unicast address, VRF             [ OK ]
#     TEST: No nexthop device given                             [ OK ]
#     TEST: Gateway resolves to wrong nexthop device            [ OK ]
#     TEST: Gateway resolves to wrong nexthop device - VRF      [ OK ]
#=20
# ######################################################################
# TEST SECTION: IPv6 onlink
# ######################################################################
#=20
# #########################################
# TEST SUBSECTION: Valid onlink commands
#=20
# #########################################
# TEST SUBSECTION: default VRF - main table
#     TEST: unicast connected                                   [ OK ]
#     TEST: unicast recursive                                   [ OK ]
#     TEST: v4-mapped                                           [ OK ]
#=20
# #########################################
# TEST SUBSECTION: VRF lisa
#     TEST: unicast connected                                   [ OK ]
#     TEST: unicast recursive                                   [ OK ]
#     TEST: v4-mapped                                           [ OK ]
#=20
# #########################################
# TEST SUBSECTION: VRF device, PBR table
#     TEST: unicast connected                                   [ OK ]
#     TEST: unicast recursive                                   [ OK ]
#     TEST: v4-mapped                                           [ OK ]
#=20
# #########################################
# TEST SUBSECTION: default VRF - main table - multipath
#     TEST: unicast connected - multipath onlink                [ OK ]
#     TEST: unicast recursive - multipath onlink                [ OK ]
#     TEST: v4-mapped - multipath onlink                        [ OK ]
#     TEST: unicast connected - multipath onlink both nexthops  [ OK ]
#     TEST: unicast connected - multipath onlink first only     [ OK ]
#     TEST: unicast connected - multipath onlink second only    [ OK ]
#=20
# #########################################
# TEST SUBSECTION: Invalid onlink commands
#     TEST: Invalid gw - local unicast address                  [ OK ]
#     TEST: Invalid gw - local linklocal address                [ OK ]
#     TEST: Invalid gw - multicast address                      [ OK ]
#     TEST: Invalid gw - local unicast address, VRF             [ OK ]
#     TEST: Invalid gw - local linklocal address, VRF           [ OK ]
#     TEST: Invalid gw - multicast address, VRF                 [ OK ]
#     TEST: No nexthop device given                             [ OK ]
#     TEST: Gateway resolves to wrong nexthop device - VRF      [ OK ]
#=20
# Tests passed:  38
# Tests failed:   0
ok 15 selftests: net: fib-onlink-tests.sh
# selftests: net: pmtu.sh
# TEST: ipv4: PMTU exceptions                                         [ OK ]
# TEST: ipv4: PMTU exceptions - nexthop objects                       [ OK ]
# TEST: ipv6: PMTU exceptions                                         [ OK ]
# TEST: ipv6: PMTU exceptions - nexthop objects                       [ OK ]
# TEST: IPv4 over vxlan4: PMTU exceptions                             [ OK ]
# TEST: IPv4 over vxlan4: PMTU exceptions - nexthop objects           [ OK ]
# TEST: IPv6 over vxlan4: PMTU exceptions                             [ OK ]
# TEST: IPv6 over vxlan4: PMTU exceptions - nexthop objects           [ OK ]
# TEST: IPv4 over vxlan6: PMTU exceptions                             [ OK ]
# TEST: IPv4 over vxlan6: PMTU exceptions - nexthop objects           [ OK ]
# TEST: IPv6 over vxlan6: PMTU exceptions                             [ OK ]
# TEST: IPv6 over vxlan6: PMTU exceptions - nexthop objects           [ OK ]
# TEST: IPv4 over geneve4: PMTU exceptions                            [ OK ]
# TEST: IPv4 over geneve4: PMTU exceptions - nexthop objects          [ OK ]
# TEST: IPv6 over geneve4: PMTU exceptions                            [ OK ]
# TEST: IPv6 over geneve4: PMTU exceptions - nexthop objects          [ OK ]
# TEST: IPv4 over geneve6: PMTU exceptions                            [ OK ]
# TEST: IPv4 over geneve6: PMTU exceptions - nexthop objects          [ OK ]
# TEST: IPv6 over geneve6: PMTU exceptions                            [ OK ]
# TEST: IPv6 over geneve6: PMTU exceptions - nexthop objects          [ OK ]
# TEST: IPv4, bridged vxlan4: PMTU exceptions                         [ OK ]
# TEST: IPv4, bridged vxlan4: PMTU exceptions - nexthop objects       [ OK ]
# TEST: IPv6, bridged vxlan4: PMTU exceptions                         [ OK ]
# TEST: IPv6, bridged vxlan4: PMTU exceptions - nexthop objects       [ OK ]
# TEST: IPv4, bridged vxlan6: PMTU exceptions                         [ OK ]
# TEST: IPv4, bridged vxlan6: PMTU exceptions - nexthop objects       [ OK ]
# TEST: IPv6, bridged vxlan6: PMTU exceptions                         [ OK ]
# TEST: IPv6, bridged vxlan6: PMTU exceptions - nexthop objects       [ OK ]
# TEST: IPv4, bridged geneve4: PMTU exceptions                        [ OK ]
# TEST: IPv4, bridged geneve4: PMTU exceptions - nexthop objects      [ OK ]
# TEST: IPv6, bridged geneve4: PMTU exceptions                        [ OK ]
# TEST: IPv6, bridged geneve4: PMTU exceptions - nexthop objects      [ OK ]
# TEST: IPv4, bridged geneve6: PMTU exceptions                        [ OK ]
# TEST: IPv4, bridged geneve6: PMTU exceptions - nexthop objects      [ OK ]
# TEST: IPv6, bridged geneve6: PMTU exceptions                        [ OK ]
# TEST: IPv6, bridged geneve6: PMTU exceptions - nexthop objects      [ OK ]
#   ovs_bridge not supported
# TEST: IPv4, OVS vxlan4: PMTU exceptions                             [SKIP]
#   ovs_bridge not supported
# TEST: IPv6, OVS vxlan4: PMTU exceptions                             [SKIP]
#   ovs_bridge not supported
# TEST: IPv4, OVS vxlan6: PMTU exceptions                             [SKIP]
#   ovs_bridge not supported
# TEST: IPv6, OVS vxlan6: PMTU exceptions                             [SKIP]
#   ovs_bridge not supported
# TEST: IPv4, OVS geneve4: PMTU exceptions                            [SKIP]
#   ovs_bridge not supported
# TEST: IPv6, OVS geneve4: PMTU exceptions                            [SKIP]
#   ovs_bridge not supported
# TEST: IPv4, OVS geneve6: PMTU exceptions                            [SKIP]
#   ovs_bridge not supported
# TEST: IPv6, OVS geneve6: PMTU exceptions                            [SKIP]
# TEST: IPv4 over fou4: PMTU exceptions                               [ OK ]
# TEST: IPv4 over fou4: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv6 over fou4: PMTU exceptions                               [ OK ]
# TEST: IPv6 over fou4: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv4 over fou6: PMTU exceptions                               [ OK ]
# TEST: IPv4 over fou6: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv6 over fou6: PMTU exceptions                               [ OK ]
# TEST: IPv6 over fou6: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv4 over gue4: PMTU exceptions                               [ OK ]
# TEST: IPv4 over gue4: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv6 over gue4: PMTU exceptions                               [ OK ]
# TEST: IPv6 over gue4: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv4 over gue6: PMTU exceptions                               [ OK ]
# TEST: IPv4 over gue6: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv6 over gue6: PMTU exceptions                               [ OK ]
# TEST: IPv6 over gue6: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv4 over IPv4: PMTU exceptions                               [ OK ]
# TEST: IPv4 over IPv4: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv6 over IPv4: PMTU exceptions                               [ OK ]
# TEST: IPv6 over IPv4: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv4 over IPv6: PMTU exceptions                               [ OK ]
# TEST: IPv4 over IPv6: PMTU exceptions - nexthop objects             [ OK ]
# TEST: IPv6 over IPv6: PMTU exceptions                               [ OK ]
# TEST: IPv6 over IPv6: PMTU exceptions - nexthop objects             [ OK ]
# TEST: vti6: PMTU exceptions                                         [ OK ]
# TEST: vti4: PMTU exceptions                                         [ OK ]
# TEST: vti4: default MTU assignment                                  [ OK ]
# TEST: vti6: default MTU assignment                                  [ OK ]
# TEST: vti4: MTU setting on link creation                            [ OK ]
# TEST: vti6: MTU setting on link creation                            [ OK ]
# TEST: vti6: MTU changes on link changes                             [ OK ]
# TEST: ipv4: cleanup of cached exceptions                            [ OK ]
# TEST: ipv4: cleanup of cached exceptions - nexthop objects          [ OK ]
# TEST: ipv6: cleanup of cached exceptions                            [ OK ]
# TEST: ipv6: cleanup of cached exceptions - nexthop objects          [ OK ]
# TEST: ipv4: list and flush cached exceptions                        [ OK ]
# TEST: ipv4: list and flush cached exceptions - nexthop objects      [ OK ]
# TEST: ipv6: list and flush cached exceptions                        [ OK ]
# TEST: ipv6: list and flush cached exceptions - nexthop objects      [ OK ]
ok 16 selftests: net: pmtu.sh
# selftests: net: udpgso.sh
# ipv4 cmsg
# device mtu (orig): 65536
# device mtu (test): 1500
# ipv4 tx:1 gso:0=20
# ipv4 tx:1472 gso:0=20
# ipv4 tx:1473 gso:0 (fail)
# ipv4 tx:1472 gso:1472=20
# ipv4 tx:1473 gso:1472=20
# ipv4 tx:2944 gso:1472=20
# ipv4 tx:2945 gso:1472=20
# ipv4 tx:64768 gso:1472=20
# ipv4 tx:65507 gso:1472=20
# ipv4 tx:65508 gso:1472 (fail)
# ipv4 tx:1 gso:1=20
# ipv4 tx:2 gso:1=20
# ipv4 tx:5 gso:2=20
# ipv4 tx:36 gso:1=20
# ipv4 tx:37 gso:1 (fail)
# OK
# ipv4 setsockopt
# device mtu (orig): 65536
# device mtu (test): 1500
# ipv4 tx:1 gso:0=20
# ipv4 tx:1472 gso:0=20
# ipv4 tx:1473 gso:0 (fail)
# ipv4 tx:1472 gso:1472=20
# ipv4 tx:1473 gso:1472=20
# ipv4 tx:2944 gso:1472=20
# ipv4 tx:2945 gso:1472=20
# ipv4 tx:64768 gso:1472=20
# ipv4 tx:65507 gso:1472=20
# ipv4 tx:65508 gso:1472 (fail)
# ipv4 tx:1 gso:1=20
# ipv4 tx:2 gso:1=20
# ipv4 tx:5 gso:2=20
# ipv4 tx:36 gso:1=20
# ipv4 tx:37 gso:1 (fail)
# OK
# ipv6 cmsg
# device mtu (orig): 65536
# device mtu (test): 1500
# ipv6 tx:1 gso:0=20
# ipv6 tx:1452 gso:0=20
# ipv6 tx:1453 gso:0 (fail)
# ipv6 tx:1452 gso:1452=20
# ipv6 tx:1453 gso:1452=20
# ipv6 tx:2904 gso:1452=20
# ipv6 tx:2905 gso:1452=20
# ipv6 tx:65340 gso:1452=20
# ipv6 tx:65527 gso:1452=20
# ipv6 tx:65528 gso:1452 (fail)
# ipv6 tx:1 gso:1=20
# ipv6 tx:2 gso:1=20
# ipv6 tx:5 gso:2=20
# ipv6 tx:16 gso:1=20
# ipv6 tx:17 gso:1 (fail)
# OK
# ipv6 setsockopt
# device mtu (orig): 65536
# device mtu (test): 1500
# ipv6 tx:1 gso:0=20
# ipv6 tx:1452 gso:0=20
# ipv6 tx:1453 gso:0 (fail)
# ipv6 tx:1452 gso:1452=20
# ipv6 tx:1453 gso:1452=20
# ipv6 tx:2904 gso:1452=20
# ipv6 tx:2905 gso:1452=20
# ipv6 tx:65340 gso:1452=20
# ipv6 tx:65527 gso:1452=20
# ipv6 tx:65528 gso:1452 (fail)
# ipv6 tx:1 gso:1=20
# ipv6 tx:2 gso:1=20
# ipv6 tx:5 gso:2=20
# ipv6 tx:16 gso:1=20
# ipv6 tx:17 gso:1 (fail)
# OK
# ipv4 connected
# device mtu (orig): 65536
# device mtu (test): 1600
# route mtu (test): 1500
# path mtu (read):  1500
# ipv4 tx:1 gso:0=20
# ipv4 tx:1472 gso:0=20
# ipv4 tx:1473 gso:0 (fail)
# ipv4 tx:1472 gso:1472=20
# ipv4 tx:1473 gso:1472=20
# ipv4 tx:2944 gso:1472=20
# ipv4 tx:2945 gso:1472=20
# ipv4 tx:64768 gso:1472=20
# ipv4 tx:65507 gso:1472=20
# ipv4 tx:65508 gso:1472 (fail)
# ipv4 tx:1 gso:1=20
# ipv4 tx:2 gso:1=20
# ipv4 tx:5 gso:2=20
# ipv4 tx:36 gso:1=20
# ipv4 tx:37 gso:1 (fail)
# OK
# ipv4 msg_more
# device mtu (orig): 65536
# device mtu (test): 1500
# ipv4 tx:1 gso:0=20
# ipv4 tx:1472 gso:0=20
# ipv4 tx:1473 gso:0 (fail)
# ipv4 tx:1472 gso:1472=20
# ipv4 tx:1473 gso:1472=20
# ipv4 tx:2944 gso:1472=20
# ipv4 tx:2945 gso:1472=20
# ipv4 tx:64768 gso:1472=20
# ipv4 tx:65507 gso:1472=20
# ipv4 tx:65508 gso:1472 (fail)
# ipv4 tx:1 gso:1=20
# ipv4 tx:2 gso:1=20
# ipv4 tx:5 gso:2=20
# ipv4 tx:36 gso:1=20
# ipv4 tx:37 gso:1 (fail)
# OK
# ipv6 msg_more
# device mtu (orig): 65536
# device mtu (test): 1500
# ipv6 tx:1 gso:0=20
# ipv6 tx:1452 gso:0=20
# ipv6 tx:1453 gso:0 (fail)
# ipv6 tx:1452 gso:1452=20
# ipv6 tx:1453 gso:1452=20
# ipv6 tx:2904 gso:1452=20
# ipv6 tx:2905 gso:1452=20
# ipv6 tx:65340 gso:1452=20
# ipv6 tx:65527 gso:1452=20
# ipv6 tx:65528 gso:1452 (fail)
# ipv6 tx:1 gso:1=20
# ipv6 tx:2 gso:1=20
# ipv6 tx:5 gso:2=20
# ipv6 tx:16 gso:1=20
# ipv6 tx:17 gso:1 (fail)
# OK
ok 17 selftests: net: udpgso.sh
# selftests: net: ip_defrag.sh
# ipv4 defrag
# PASS
# seed =3D 1606930722
# ipv4 defrag with overlaps
# PASS
# seed =3D 1606930722
# ipv6 defrag
# PASS
# seed =3D 1606930729
# ipv6 defrag with overlaps
# PASS
# seed =3D 1606930730
# ipv6 nf_conntrack defrag
# PASS
# seed =3D 1606930735
# ipv6 nf_conntrack defrag with overlaps
# PASS
# seed =3D 1606930735
# all tests done
ok 18 selftests: net: ip_defrag.sh
# selftests: net: udpgso_bench.sh
# ipv4
# tcp
# tcp tx:   2970 MB/s    50383 calls/s  50383 msg/s
# tcp rx:   2972 MB/s    50353 calls/s
# tcp tx:   3039 MB/s    51548 calls/s  51548 msg/s
# tcp rx:   3041 MB/s    51578 calls/s
# tcp tx:   3042 MB/s    51603 calls/s  51603 msg/s
# tcp zerocopy
# tcp tx:   2159 MB/s    36631 calls/s  36631 msg/s
# tcp rx:   2161 MB/s    36603 calls/s
# tcp tx:   2224 MB/s    37725 calls/s  37725 msg/s
# tcp rx:   2225 MB/s    37695 calls/s
# tcp tx:   2220 MB/s    37666 calls/s  37666 msg/s
# udp
# udp rx:    149 MB/s   106484 calls/s
# udp tx:    149 MB/s   106806 calls/s   2543 msg/s
# udp rx:    152 MB/s   108376 calls/s
# udp tx:    151 MB/s   108234 calls/s   2577 msg/s
# udp rx:    151 MB/s   107662 calls/s
# udp tx:    150 MB/s   107562 calls/s   2561 msg/s
# udp gso
# udp rx:    764 MB/s   544256 calls/s
# udp tx:    765 MB/s    12986 calls/s  12986 msg/s
# udp rx:    793 MB/s   564925 calls/s
# udp tx:    792 MB/s    13445 calls/s  13445 msg/s
# udp rx:    801 MB/s   570830 calls/s
# udp tx:    800 MB/s    13582 calls/s  13582 msg/s
# udp gso zerocopy
# udp rx:    737 MB/s   525428 calls/s
# udp tx:    740 MB/s    12556 calls/s  12556 msg/s
# udp rx:    738 MB/s   525824 calls/s
# udp tx:    737 MB/s    12509 calls/s  12509 msg/s
# udp rx:    745 MB/s   530944 calls/s
# udp tx:    744 MB/s    12627 calls/s  12627 msg/s
# udp gso timestamp
# udp rx:    704 MB/s   501648 calls/s
# udp tx:    707 MB/s    11995 calls/s  11995 msg/s
# udp rx:    744 MB/s   530117 calls/s
# udp tx:    743 MB/s    12610 calls/s  12610 msg/s
# udp rx:    744 MB/s   530619 calls/s
# udp tx:    744 MB/s    12625 calls/s  12625 msg/s
# udp gso zerocopy audit
# udp rx:    723 MB/s   515410 calls/s
# udp tx:    725 MB/s    12303 calls/s  12303 msg/s
# udp rx:    731 MB/s   521324 calls/s
# udp tx:    731 MB/s    12403 calls/s  12403 msg/s
# udp rx:    742 MB/s   528896 calls/s
# udp tx:    741 MB/s    12578 calls/s  12578 msg/s
# Summary over 3.000 seconds...
# sum udp tx:    750 MB/s      37284 calls (12428/s)      37284 msgs (12428=
/s)
# Zerocopy acks:               37284
# udp gso timestamp audit
# udp rx:    717 MB/s   510850 calls/s
# udp tx:    718 MB/s    12187 calls/s  12187 msg/s
# udp rx:    722 MB/s   514370 calls/s
# udp tx:    722 MB/s    12247 calls/s  12247 msg/s
# udp rx:    747 MB/s   532434 calls/s
# udp tx:    746 MB/s    12664 calls/s  12664 msg/s
# Summary over 3.000 seconds...
# sum udp tx:    746 MB/s      37098 calls (12366/s)      37098 msgs (12366=
/s)
# Tx Timestamps:               37098 received                 0 errors
# udp gso zerocopy timestamp audit
# udp rx:    656 MB/s   467502 calls/s
# udp tx:    658 MB/s    11163 calls/s  11163 msg/s
# udp rx:    673 MB/s   479514 calls/s
# udp tx:    672 MB/s    11403 calls/s  11403 msg/s
# udp rx:    666 MB/s   474516 calls/s
# udp tx:    665 MB/s    11290 calls/s  11290 msg/s
# Summary over 3.000 seconds...
# sum udp tx:    681 MB/s      33856 calls (11285/s)      33856 msgs (11285=
/s)
# Tx Timestamps:               33856 received                 0 errors
# Zerocopy acks:               33856
# ipv6
# tcp
# tcp tx:   3062 MB/s    51949 calls/s  51949 msg/s
# tcp rx:   3068 MB/s    52033 calls/s
# tcp tx:   3134 MB/s    53155 calls/s  53155 msg/s
# tcp rx:   3137 MB/s    53195 calls/s
# tcp tx:   3072 MB/s    52118 calls/s  52118 msg/s
# tcp zerocopy
# tcp tx:   2274 MB/s    38580 calls/s  38580 msg/s
# tcp rx:   2275 MB/s    38496 calls/s
# tcp tx:   2268 MB/s    38480 calls/s  38480 msg/s
# tcp rx:   2271 MB/s    38456 calls/s
# tcp tx:   2313 MB/s    39240 calls/s  39240 msg/s
# udp
# udp rx:    130 MB/s    95083 calls/s
# udp tx:    130 MB/s    95288 calls/s   2216 msg/s
# udp rx:    130 MB/s    95081 calls/s
# udp tx:    130 MB/s    95073 calls/s   2211 msg/s
# udp rx:    133 MB/s    97240 calls/s
# udp tx:    133 MB/s    97137 calls/s   2259 msg/s
# udp gso
# udp rx:    746 MB/s   544424 calls/s
# udp tx:    748 MB/s    12698 calls/s  12698 msg/s
# udp tx:    748 MB/s    12702 calls/s  12702 msg/s
# udp rx:    748 MB/s   546019 calls/s
# udp tx:    761 MB/s    12924 calls/s  12924 msg/s
# udp gso zerocopy
# udp rx:    711 MB/s   518755 calls/s
# udp tx:    713 MB/s    12098 calls/s  12098 msg/s
# udp rx:    713 MB/s   520560 calls/s
# udp tx:    713 MB/s    12095 calls/s  12095 msg/s
# udp rx:    723 MB/s   527919 calls/s
# udp tx:    723 MB/s    12269 calls/s  12269 msg/s
# udp gso timestamp
# udp rx:    730 MB/s   532696 calls/s
# udp tx:    733 MB/s    12435 calls/s  12435 msg/s
# udp rx:    757 MB/s   552347 calls/s
# udp tx:    756 MB/s    12832 calls/s  12832 msg/s
# udp rx:    758 MB/s   553496 calls/s
# udp tx:    758 MB/s    12860 calls/s  12860 msg/s
# udp gso zerocopy audit
# udp rx:    704 MB/s   513953 calls/s
# udp tx:    705 MB/s    11959 calls/s  11959 msg/s
# udp tx:    709 MB/s    12035 calls/s  12035 msg/s
# udp rx:    709 MB/s   517769 calls/s
# udp tx:    717 MB/s    12166 calls/s  12166 msg/s
# Summary over 3.000 seconds...
# sum udp tx:    727 MB/s      36160 calls (12053/s)      36160 msgs (12053=
/s)
# Zerocopy acks:               36160
# udp gso timestamp audit
# udp rx:    721 MB/s   526201 calls/s
# udp tx:    723 MB/s    12268 calls/s  12268 msg/s
# udp rx:    736 MB/s   537045 calls/s
# udp tx:    735 MB/s    12476 calls/s  12476 msg/s
# udp rx:    725 MB/s   529168 calls/s
# udp tx:    724 MB/s    12296 calls/s  12296 msg/s
# Summary over 3.000 seconds...
# sum udp tx:    745 MB/s      37040 calls (12346/s)      37040 msgs (12346=
/s)
# Tx Timestamps:               37040 received                 0 errors
# udp gso zerocopy timestamp audit
# udp rx:    649 MB/s   473516 calls/s
# udp tx:    651 MB/s    11044 calls/s  11044 msg/s
# udp rx:    665 MB/s   485083 calls/s
# udp tx:    664 MB/s    11268 calls/s  11268 msg/s
# udp rx:    665 MB/s   485685 calls/s
# udp tx:    665 MB/s    11285 calls/s  11285 msg/s
# Summary over 3.000 seconds...
# sum udp tx:    676 MB/s      33597 calls (11199/s)      33597 msgs (11199=
/s)
# Tx Timestamps:               33597 received                 0 errors
# Zerocopy acks:               33597
# udpgso_bench.sh: PASS=3D18 SKIP=3D0 FAIL=3D0
# udpgso_bench.sh: =1B[0;92mPASS=1B[0m
ok 19 selftests: net: udpgso_bench.sh
# selftests: net: fib_rule_tests.sh
#=20
# ######################################################################
# TEST SECTION: IPv4 fib rule
# ######################################################################
#=20
#     TEST: rule4 check: oif dummy0                             [ OK ]
#=20
#     TEST: rule4 del by pref: oif dummy0                       [ OK ]
# net.ipv4.ip_forward =3D 1
# net.ipv4.conf.dummy0.rp_filter =3D 0
#=20
#     TEST: rule4 check: from 192.51.100.3 iif dummy0           [ OK ]
#=20
#     TEST: rule4 del by pref: from 192.51.100.3 iif dummy0     [ OK ]
# net.ipv4.ip_forward =3D 0
#=20
#     TEST: rule4 check: tos 0x10                               [ OK ]
#=20
#     TEST: rule4 del by pref: tos 0x10                         [ OK ]
#=20
#     TEST: rule4 check: fwmark 0x64                            [ OK ]
#=20
#     TEST: rule4 del by pref: fwmark 0x64                      [ OK ]
#=20
#     TEST: rule4 check: uidrange 100-100                       [ OK ]
#=20
#     TEST: rule4 del by pref: uidrange 100-100                 [ OK ]
#=20
#     TEST: rule4 check: sport 666 dport 777                    [ OK ]
#=20
#     TEST: rule4 del by pref: sport 666 dport 777              [ OK ]
#=20
#     TEST: rule4 check: ipproto tcp                            [ OK ]
#=20
#     TEST: rule4 del by pref: ipproto tcp                      [ OK ]
#=20
#     TEST: rule4 check: ipproto icmp                           [ OK ]
#=20
#     TEST: rule4 del by pref: ipproto icmp                     [ OK ]
#=20
# ######################################################################
# TEST SECTION: IPv6 fib rule
# ######################################################################
#=20
#     TEST: rule6 check: oif dummy0                             [ OK ]
#=20
#     TEST: rule6 del by pref: oif dummy0                       [ OK ]
#=20
#     TEST: rule6 check: from 2001:db8:1::3 iif dummy0          [ OK ]
#=20
#     TEST: rule6 del by pref: from 2001:db8:1::3 iif dummy0    [ OK ]
#=20
#     TEST: rule6 check: tos 0x10                               [ OK ]
#=20
#     TEST: rule6 del by pref: tos 0x10                         [ OK ]
#=20
#     TEST: rule6 check: fwmark 0x64                            [ OK ]
#=20
#     TEST: rule6 del by pref: fwmark 0x64                      [ OK ]
#=20
#     TEST: rule6 check: uidrange 100-100                       [ OK ]
#=20
#     TEST: rule6 del by pref: uidrange 100-100                 [ OK ]
#=20
#     TEST: rule6 check: sport 666 dport 777                    [ OK ]
#=20
#     TEST: rule6 del by pref: sport 666 dport 777              [ OK ]
#=20
#     TEST: rule6 check: ipproto tcp                            [ OK ]
#=20
#     TEST: rule6 del by pref: ipproto tcp                      [ OK ]
#=20
#     TEST: rule6 check: ipproto ipv6-icmp                      [ OK ]
#=20
#     TEST: rule6 del by pref: ipproto ipv6-icmp                [ OK ]
#=20
# Tests passed:  32
# Tests failed:   0
ok 20 selftests: net: fib_rule_tests.sh
# selftests: net: msg_zerocopy.sh
# ipv4 tcp -t 1
# tx=3D59146 (3690 MB) txc=3D0 zc=3Dn
# rx=3D29574 (3690 MB)
# ipv4 tcp -z -t 1
# tx=3D44698 (2789 MB) txc=3D44698 zc=3Dn
# rx=3D22350 (2789 MB)
# ok
# ipv6 tcp -t 1
# tx=3D44701 (2789 MB) txc=3D0 zc=3Dn
# rx=3D22351 (2789 MB)
# ipv6 tcp -z -t 1
# tx=3D37093 (2314 MB) txc=3D37093 zc=3Dn
# rx=3D18548 (2314 MB)
# ok
# ipv4 udp -t 1
# tx=3D66189 (4130 MB) txc=3D0 zc=3Dn
# rx=3D66189 (4130 MB)
# ipv4 udp -z -t 1
# tx=3D48192 (3007 MB) txc=3D48192 zc=3Dn
# rx=3D48192 (3007 MB)
# ok
# ipv6 udp -t 1
# tx=3D60985 (3805 MB) txc=3D0 zc=3Dn
# rx=3D60985 (3805 MB)
# ipv6 udp -z -t 1
# tx=3D46666 (2912 MB) txc=3D46666 zc=3Dn
# rx=3D46666 (2912 MB)
# ok
# OK. All tests passed
ok 21 selftests: net: msg_zerocopy.sh
# selftests: net: psock_snd.sh
# dgram
# tx: 128
# rx: 142
# rx: 100
# OK
#=20
# dgram bind
# tx: 128
# rx: 142
# rx: 100
# OK
#=20
# raw
# tx: 142
# rx: 142
# rx: 100
# OK
#=20
# raw bind
# tx: 142
# rx: 142
# rx: 100
# OK
#=20
# raw qdisc bypass
# tx: 142
# rx: 142
# rx: 100
# OK
#=20
# raw vlan
# tx: 146
# rx: 100
# OK
#=20
# raw vnet hdr
# tx: 152
# rx: 142
# rx: 100
# OK
#=20
# raw csum_off
# tx: 152
# rx: 142
# rx: 100
# OK
#=20
# raw csum_off with bad offset (expected to fail)
# ./psock_snd: write: Invalid argument
# raw min size
# tx: 42
# rx: 0
# OK
#=20
# raw mtu size
# tx: 1514
# rx: 1472
# OK
#=20
# raw mtu size + 1 (expected to fail)
# ./psock_snd: write: Message too long
# raw vlan mtu size + 1 (expected to fail)
# ./psock_snd: write: Message too long
# dgram mtu size
# tx: 1500
# rx: 1472
# OK
#=20
# dgram mtu size + 1 (expected to fail)
# ./psock_snd: write: Message too long
# raw truncate hlen (expected to fail: does not arrive)
# tx: 14
# ./psock_snd: recv: Resource temporarily unavailable
# raw truncate hlen - 1 (expected to fail: EINVAL)
# ./psock_snd: write: Invalid argument
# raw gso min size
# tx: 1525
# rx: 1473
# OK
#=20
# raw gso min size - 1 (expected to fail)
# tx: 1524
# rx: 1472
# OK
#=20
not ok 22 selftests: net: psock_snd.sh # exit=3D1
# selftests: net: udpgro_bench.sh
# Missing xdp_dummy helper. Build bpf selftest first
not ok 23 selftests: net: udpgro_bench.sh # exit=3D255
# selftests: net: udpgro.sh
# Missing xdp_dummy helper. Build bpf selftest first
not ok 24 selftests: net: udpgro.sh # exit=3D255
# selftests: net: test_vxlan_under_vrf.sh
# Checking HV connectivity                                           [ OK ]
# Check VM connectivity through VXLAN (underlay in the default VRF)  [ OK ]
# Check VM connectivity through VXLAN (underlay in a VRF)            [FAIL]
not ok 25 selftests: net: test_vxlan_under_vrf.sh # exit=3D1
# selftests: net: reuseport_addr_any.sh
# UDP IPv4 ... pass
# UDP IPv6 ... pass
# UDP IPv4 mapped to IPv6 ... pass
# TCP IPv4 ... pass
# TCP IPv6 ... pass
# TCP IPv4 mapped to IPv6 ... pass
# DCCP IPv4 ... pass
# DCCP IPv6 ... pass
# DCCP IPv4 mapped to IPv6 ... pass
# SUCCESS
ok 26 selftests: net: reuseport_addr_any.sh
# selftests: net: test_vxlan_fdb_changelink.sh
# expected two remotes after fdb append	[ OK ]
# expected two remotes after link set	[ OK ]
ok 27 selftests: net: test_vxlan_fdb_changelink.sh
# selftests: net: so_txtime.sh
#=20
# SO_TXTIME ipv6 clock monotonic
# payload:a delay:97 expected:0 (us)
#=20
# SO_TXTIME ipv4 clock monotonic
# payload:a delay:39 expected:0 (us)
#=20
# SO_TXTIME ipv6 clock monotonic
# payload:a delay:49 expected:0 (us)
#=20
# SO_TXTIME ipv4 clock monotonic
# payload:a delay:65 expected:0 (us)
#=20
# SO_TXTIME ipv6 clock monotonic
# payload:a delay:10146 expected:10000 (us)
#=20
# SO_TXTIME ipv4 clock monotonic
# payload:a delay:10097 expected:10000 (us)
#=20
# SO_TXTIME ipv6 clock monotonic
# payload:a delay:10183 expected:10000 (us)
# payload:b delay:20072 expected:20000 (us)
#=20
# SO_TXTIME ipv4 clock monotonic
# payload:a delay:10080 expected:10000 (us)
# payload:b delay:20070 expected:20000 (us)
#=20
# SO_TXTIME ipv6 clock monotonic
# payload:b delay:20159 expected:20000 (us)
# payload:a delay:20172 expected:20000 (us)
#=20
# SO_TXTIME ipv4 clock monotonic
# payload:b delay:20130 expected:20000 (us)
# payload:a delay:20143 expected:20000 (us)
#=20
# SO_TXTIME ipv6 clock tai
# send: pkt a at -1606930826746ms dropped: invalid txtime
# ./so_txtime: recv: timeout
#=20
# SO_TXTIME ipv6 clock tai
# send: pkt a at 0ms dropped: invalid txtime
# ./so_txtime: recv: timeout
#=20
# SO_TXTIME ipv6 clock tai
# payload:a delay:9739 expected:10000 (us)
#=20
# SO_TXTIME ipv4 clock tai
# payload:a delay:9724 expected:10000 (us)
#=20
# SO_TXTIME ipv6 clock tai
# payload:a delay:9679 expected:10000 (us)
# payload:b delay:19625 expected:20000 (us)
#=20
# SO_TXTIME ipv4 clock tai
# payload:a delay:9672 expected:10000 (us)
# payload:b delay:19678 expected:20000 (us)
#=20
# SO_TXTIME ipv6 clock tai
# payload:b delay:9671 expected:10000 (us)
# payload:a delay:19720 expected:20000 (us)
#=20
# SO_TXTIME ipv4 clock tai
# payload:b delay:9717 expected:10000 (us)
# payload:a delay:19718 expected:20000 (us)
# OK. All tests passed
ok 28 selftests: net: so_txtime.sh
# selftests: net: ipv6_flowlabel.sh
# TEST management
# [OK]   !(flowlabel_get(fd, 1, 255, 0))
# [OK]   !(flowlabel_put(fd, 1))
# [OK]   !(flowlabel_get(fd, 0x1FFFFF, 255, 1))
# [OK]   flowlabel_get(fd, 1, 255, 1)
# [OK]   flowlabel_get(fd, 1, 255, 0)
# [OK]   flowlabel_get(fd, 1, 255, 1)
# [OK]   !(flowlabel_get(fd, 1, 255, 1 | 2))
# [OK]   flowlabel_put(fd, 1)
# [OK]   flowlabel_put(fd, 1)
# [OK]   flowlabel_put(fd, 1)
# [OK]   !(flowlabel_put(fd, 1))
# [OK]   flowlabel_get(fd, 2, 1, 1)
# [OK]   !(flowlabel_get(fd, 2, 255, 1))
# [OK]   !(flowlabel_get(fd, 2, 1, 1))
# [OK]   flowlabel_put(fd, 2)
# [OK]   flowlabel_get(fd, 3, 3, 1)
# [OK]   !(flowlabel_get(fd, 3, 255, 0))
# [OK]   !(flowlabel_get(fd, 3, 1, 0))
# [OK]   flowlabel_get(fd, 3, 3, 0)
# [OK]   flowlabel_get(fd, 3, 3, 0)
# [OK]   !(flowlabel_get(fd, 3, 3, 0))
# [OK]   flowlabel_get(fd, 4, 2, 1)
# [OK]   flowlabel_get(fd, 4, 2, 0)
# [OK]   !(flowlabel_get(fd, 4, 2, 0))
# TEST datapath
# send no label: recv no label (auto off)
# sent without label
# recv without label
# send label
# sent with label 1
# recv with label 1
# TEST datapath (with auto-flowlabels)
# send no label: recv auto flowlabel
# sent without label
# recv with label 824766
# send label
# sent with label 1
# recv with label 1
# OK. All tests passed
ok 29 selftests: net: ipv6_flowlabel.sh
# selftests: net: tcp_fastopen_backup_key.sh
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# PASS
# all tests done
ok 30 selftests: net: tcp_fastopen_backup_key.sh
# selftests: net: fcnal-test.sh
#=20
# #########################################################################=
##
# IPv4 ping
# #########################################################################=
##
#=20
#=20
# #################################################################
# No VRF
#=20
# SYSCTL: net.ipv4.raw_l3mdev_accept=3D0
#=20
# TEST: ping out - ns-B IP                                                 =
     [ OK ]
# TEST: ping out, device bind - ns-B IP                                    =
     [ OK ]
# TEST: ping out, address bind - ns-B IP                                   =
     [ OK ]
# TEST: ping out - ns-B loopback IP                                        =
     [ OK ]
# TEST: ping out, device bind - ns-B loopback IP                           =
     [ OK ]
# TEST: ping out, address bind - ns-B loopback IP                          =
     [ OK ]
# TEST: ping in - ns-A IP                                                  =
     [ OK ]
# TEST: ping in - ns-A loopback IP                                         =
     [ OK ]
# TEST: ping local - ns-A IP                                               =
     [ OK ]
# TEST: ping local - ns-A loopback IP                                      =
     [ OK ]
# TEST: ping local - loopback                                              =
     [ OK ]
# TEST: ping local, device bind - ns-A IP                                  =
     [ OK ]
# TEST: ping local, device bind - ns-A loopback IP                         =
     [ OK ]
# TEST: ping local, device bind - loopback                                 =
     [ OK ]
# TEST: ping out, blocked by rule - ns-B loopback IP                       =
     [ OK ]
# TEST: ping in, blocked by rule - ns-A loopback IP                        =
     [ OK ]
# TEST: ping out, blocked by route - ns-B loopback IP                      =
     [ OK ]
# TEST: ping in, blocked by route - ns-A loopback IP                       =
     [ OK ]
# TEST: ping out, unreachable default route - ns-B loopback IP             =
     [ OK ]
# SYSCTL: net.ipv4.raw_l3mdev_accept=3D1
#=20
# TEST: ping out - ns-B IP                                                 =
     [ OK ]
# TEST: ping out, device bind - ns-B IP                                    =
     [ OK ]
# TEST: ping out, address bind - ns-B IP                                   =
     [ OK ]
# TEST: ping out - ns-B loopback IP                                        =
     [ OK ]
# TEST: ping out, device bind - ns-B loopback IP                           =
     [ OK ]
# TEST: ping out, address bind - ns-B loopback IP                          =
     [ OK ]
# TEST: ping in - ns-A IP                                                  =
     [ OK ]
# TEST: ping in - ns-A loopback IP                                         =
     [ OK ]
# TEST: ping local - ns-A IP                                               =
     [ OK ]
# TEST: ping local - ns-A loopback IP                                      =
     [ OK ]
# TEST: ping local - loopback                                              =
     [ OK ]
# TEST: ping local, device bind - ns-A IP                                  =
     [ OK ]
# TEST: ping local, device bind - ns-A loopback IP                         =
     [ OK ]
# TEST: ping local, device bind - loopback                                 =
     [ OK ]
# TEST: ping out, blocked by rule - ns-B loopback IP                       =
     [ OK ]
# TEST: ping in, blocked by rule - ns-A loopback IP                        =
     [ OK ]
# TEST: ping out, blocked by route - ns-B loopback IP                      =
     [ OK ]
# TEST: ping in, blocked by route - ns-A loopback IP                       =
     [ OK ]
# TEST: ping out, unreachable default route - ns-B loopback IP             =
     [ OK ]
#=20
# #################################################################
# With VRF
#=20
# SYSCTL: net.ipv4.raw_l3mdev_accept=3D1
#=20
# TEST: ping out, VRF bind - ns-B IP                                       =
     [ OK ]
# TEST: ping out, device bind - ns-B IP                                    =
     [ OK ]
# TEST: ping out, vrf device + dev address bind - ns-B IP                  =
     [ OK ]
# TEST: ping out, vrf device + vrf address bind - ns-B IP                  =
     [ OK ]
# TEST: ping out, VRF bind - ns-B loopback IP                              =
     [ OK ]
# TEST: ping out, device bind - ns-B loopback IP                           =
     [ OK ]
# TEST: ping out, vrf device + dev address bind - ns-B loopback IP         =
     [ OK ]
# TEST: ping out, vrf device + vrf address bind - ns-B loopback IP         =
     [ OK ]
# TEST: ping in - ns-A IP                                                  =
     [ OK ]
# TEST: ping in - VRF IP                                                   =
     [ OK ]
# TEST: ping local, VRF bind - ns-A IP                                     =
     [ OK ]
# TEST: ping local, VRF bind - VRF IP                                      =
     [ OK ]
# TEST: ping local, VRF bind - loopback                                    =
     [ OK ]
# TEST: ping local, device bind - ns-A IP                                  =
     [ OK ]
# TEST: ping local, device bind - VRF IP                                   =
     [ OK ]
# TEST: ping local, device bind - loopback                                 =
     [ OK ]
# TEST: ping out, vrf bind, blocked by rule - ns-B loopback IP             =
     [ OK ]
# TEST: ping out, device bind, blocked by rule - ns-B loopback IP          =
     [ OK ]
# TEST: ping in, blocked by rule - ns-A loopback IP                        =
     [ OK ]
# TEST: ping out, vrf bind, unreachable route - ns-B loopback IP           =
     [ OK ]
# TEST: ping out, device bind, unreachable route - ns-B loopback IP        =
     [ OK ]
# TEST: ping in, unreachable route - ns-A loopback IP                      =
     [ OK ]
#=20
# #########################################################################=
##
# IPv4/TCP
# #########################################################################=
##
#=20
#=20
# #################################################################
# No VRF
#=20
#=20
# #################################################################
# tcp_l3mdev_accept disabled
#=20
# SYSCTL: net.ipv4.tcp_l3mdev_accept=3D0
#=20
# TEST: Global server - ns-A IP                                            =
     [ OK ]
# TEST: Global server - ns-A loopback IP                                   =
     [ OK ]
# TEST: Device server - ns-A IP                                            =
     [ OK ]
# TEST: No server - ns-A IP                                                =
     [ OK ]
# TEST: No server - ns-A loopback IP                                       =
     [ OK ]
# TEST: Client - ns-B IP                                                   =
     [ OK ]
# TEST: Client, device bind - ns-B IP                                      =
     [ OK ]
# TEST: No server, unbound client - ns-B IP                                =
     [ OK ]
# TEST: No server, device client - ns-B IP                                 =
     [ OK ]
# TEST: Client - ns-B loopback IP                                          =
     [ OK ]
# TEST: Client, device bind - ns-B loopback IP                             =
     [ OK ]
# TEST: No server, unbound client - ns-B loopback IP                       =
     [ OK ]
# TEST: No server, device client - ns-B loopback IP                        =
     [ OK ]
# TEST: Global server, local connection - ns-A IP                          =
     [ OK ]
# TEST: Global server, local connection - ns-A loopback IP                 =
     [ OK ]
# TEST: Global server, local connection - loopback                         =
     [ OK ]
# TEST: Device server, unbound client, local connection - ns-A IP          =
     [ OK ]
# TEST: Device server, unbound client, local connection - ns-A loopback IP =
     [ OK ]
# TEST: Device server, unbound client, local connection - loopback         =
     [ OK ]
# TEST: Global server, device client, local connection - ns-A IP           =
     [ OK ]
# TEST: Global server, device client, local connection - ns-A loopback IP  =
     [ OK ]
# TEST: Global server, device client, local connection - loopback          =
     [ OK ]
# TEST: Device server, device client, local connection - ns-A IP           =
     [ OK ]
# TEST: No server, device client, local conn - ns-A IP                     =
     [ OK ]
# TEST: MD5: Single address config                                         =
     [ OK ]
# TEST: MD5: Server no config, client uses password                        =
     [ OK ]
# TEST: MD5: Client uses wrong password                                    =
     [ OK ]
# TEST: MD5: Client address does not match address configured with password=
     [ OK ]
# TEST: MD5: Prefix config                                                 =
     [ OK ]
# TEST: MD5: Prefix config, client uses wrong password                     =
     [ OK ]
# TEST: MD5: Prefix config, client address not in configured prefix        =
     [ OK ]
#=20
# #################################################################
# tcp_l3mdev_accept enabled
#=20
# SYSCTL: net.ipv4.tcp_l3mdev_accept=3D1
#=20
# TEST: Global server - ns-A IP                                            =
     [ OK ]
# TEST: Global server - ns-A loopback IP                                   =
     [ OK ]
# TEST: Device server - ns-A IP                                            =
     [ OK ]
# TEST: No server - ns-A IP                                                =
     [ OK ]
# TEST: No server - ns-A loopback IP                                       =
     [ OK ]
# TEST: Client - ns-B IP                                                   =
     [ OK ]
# TEST: Client, device bind - ns-B IP                                      =
     [ OK ]
# TEST: No server, unbound client - ns-B IP                                =
     [ OK ]
# TEST: No server, device client - ns-B IP                                 =
     [ OK ]
# TEST: Client - ns-B loopback IP                                          =
     [ OK ]
# TEST: Client, device bind - ns-B loopback IP                             =
     [ OK ]
# TEST: No server, unbound client - ns-B loopback IP                       =
     [ OK ]
# TEST: No server, device client - ns-B loopback IP                        =
     [ OK ]
# TEST: Global server, local connection - ns-A IP                          =
     [ OK ]
# TEST: Global server, local connection - ns-A loopback IP                 =
     [ OK ]
#
not ok 31 selftests: net: fcnal-test.sh # TIMEOUT 300 seconds
# selftests: net: traceroute.sh
# SKIP: Could not run IPV6 test without traceroute6
# SKIP: Could not run IPV4 test without traceroute
#=20
# Tests passed:   0
# Tests failed:   0
ok 32 selftests: net: traceroute.sh
# selftests: net: fin_ack_lat.sh
# server port: 47683
# test done
ok 33 selftests: net: fin_ack_lat.sh
# selftests: net: fib_nexthop_multiprefix.sh
# TEST: IPv4: host 0 to host 1, mtu 1300                              [ OK ]
# TEST: IPv6: host 0 to host 1, mtu 1300                              [FAIL]
#=20
# TEST: IPv4: host 0 to host 2, mtu 1350                              [ OK ]
# TEST: IPv6: host 0 to host 2, mtu 1350                              [FAIL]
#=20
# TEST: IPv4: host 0 to host 3, mtu 1400                              [ OK ]
# TEST: IPv6: host 0 to host 3, mtu 1400                              [FAIL]
#=20
# TEST: IPv4: host 0 to host 1, mtu 1300                              [ OK ]
# TEST: IPv6: host 0 to host 1, mtu 1300                              [FAIL]
#=20
# TEST: IPv4: host 0 to host 2, mtu 1350                              [ OK ]
# TEST: IPv6: host 0 to host 2, mtu 1350                              [FAIL]
#=20
# TEST: IPv4: host 0 to host 3, mtu 1400                              [ OK ]
# TEST: IPv6: host 0 to host 3, mtu 1400                              [FAIL]
ok 34 selftests: net: fib_nexthop_multiprefix.sh
# selftests: net: fib_nexthops.sh
#=20
# Basic functional tests
# ----------------------
# TEST: List with nothing defined                                     [ OK ]
# TEST: Nexthop get on non-existent id                                [ OK ]
# TEST: Nexthop with no device or gateway                             [ OK ]
# TEST: Nexthop with down device                                      [ OK ]
# TEST: Nexthop with device that is linkdown                          [ OK ]
# TEST: Nexthop with device only                                      [ OK ]
# TEST: Nexthop with duplicate id                                     [ OK ]
# TEST: Blackhole nexthop                                             [ OK ]
# TEST: Blackhole nexthop with other attributes                       [ OK ]
# TEST: Create group                                                  [ OK ]
# TEST: Create group with blackhole nexthop                           [ OK ]
# TEST: Create multipath group where 1 path is a blackhole            [ OK ]
# TEST: Multipath group can not have a member replaced by blackhole   [ OK ]
# TEST: Create group with non-existent nexthop                        [ OK ]
# TEST: Create group with same nexthop multiple times                 [ OK ]
# TEST: Replace nexthop with nexthop group                            [ OK ]
# TEST: Replace nexthop group with nexthop                            [ OK ]
# TEST: Nexthop group and device                                      [ OK ]
# TEST: Test proto flush                                              [ OK ]
# TEST: Nexthop group and blackhole                                   [ OK ]
#=20
# IPv4 functional
# ----------------------
# TEST: Create nexthop with id, gw, dev                               [ OK ]
# TEST: Get nexthop by id                                             [ OK ]
# TEST: Delete nexthop by id                                          [ OK ]
# TEST: Create nexthop - gw only                                      [ OK ]
# TEST: Create nexthop - invalid gw+dev combination                   [ OK ]
# TEST: Create nexthop - gw+dev and onlink                            [ OK ]
# TEST: Nexthops removed on admin down                                [ OK ]
#=20
# IPv4 groups functional
# ----------------------
# TEST: Create nexthop group with single nexthop                      [ OK ]
# TEST: Get nexthop group by id                                       [ OK ]
# TEST: Delete nexthop group by id                                    [ OK ]
# TEST: Nexthop group with multiple nexthops                          [ OK ]
# TEST: Nexthop group updated when entry is deleted                   [ OK ]
# TEST: Nexthop group with weighted nexthops                          [ OK ]
# TEST: Weighted nexthop group updated when entry is deleted          [ OK ]
# TEST: Nexthops in groups removed on admin down                      [ OK ]
# TEST: Multiple groups with same nexthop                             [ OK ]
# TEST: Nexthops in group removed on admin down - mixed group         [ OK ]
# TEST: Nexthop group can not have a group as an entry                [ OK ]
# TEST: Nexthop group with a blackhole entry                          [ OK ]
# TEST: Nexthop group can not have a blackhole and another nexthop    [ OK ]
# TEST: IPv6 nexthop with IPv4 route                                  [ OK ]
# TEST: IPv6 nexthop with IPv4 route                                  [ OK ]
# TEST: IPv4 route with IPv6 gateway                                  [ OK ]
# TEST: IPv4 route with invalid IPv6 gateway                          [ OK ]
#=20
# IPv4 functional runtime
# -----------------------
# TEST: Route add                                                     [ OK ]
# TEST: Route delete                                                  [ OK ]
# TEST: Route add - scope conflict with nexthop                       [ OK ]
# TEST: Nexthop replace with invalid scope for existing route         [ OK ]
# TEST: Basic ping                                                    [ OK ]
# TEST: Ping - multipath                                              [ OK ]
# TEST: Ping - multiple default routes, nh first                      [ OK ]
# TEST: Ping - multiple default routes, nh second                     [ OK ]
# TEST: Ping - blackhole                                              [ OK ]
# TEST: Ping - blackhole replaced with gateway                        [ OK ]
# TEST: Ping - gateway replaced by blackhole                          [ OK ]
# TEST: Ping - group with blackhole                                   [ OK ]
# TEST: Ping - group blackhole replaced with gateways                 [ OK ]
# TEST: IPv4 route with device only nexthop                           [ OK ]
# TEST: IPv4 multipath route with nexthop mix - dev only + gw         [ OK ]
# TEST: IPv6 nexthop with IPv4 route                                  [ OK ]
# TEST: IPv4 route with mixed v4-v6 multipath route                   [ OK ]
# TEST: IPv6 nexthop with IPv4 route                                  [ OK ]
# TEST: IPv4 route with IPv6 gateway                                  [ OK ]
# TEST: IPv4 default route with IPv6 gateway                          [ OK ]
# TEST: IPv4 route with MPLS encap                                    [ OK ]
# TEST: IPv4 route with MPLS encap - check                            [ OK ]
# TEST: IPv4 route with MPLS encap and v6 gateway                     [ OK ]
# TEST: IPv4 route with MPLS encap, v6 gw - check                     [ OK ]
#=20
# IPv4 large groups (x32)
# ---------------------
# TEST: Dump large (x32) ecmp groups                                  [ OK ]
#=20
# IPv4 nexthop api compat mode
# ----------------------------
# TEST: IPv4 default nexthop compat mode check                        [ OK ]
# TEST: IPv4 compat mode on - route add notification                  [ OK ]
# TEST: IPv4 compat mode on - route dump                              [ OK ]
# TEST: IPv4 compat mode on - nexthop change                          [ OK ]
# TEST: IPv4 set compat mode - 0                                      [ OK ]
# TEST: IPv4 compat mode off - route add notification                 [ OK ]
# TEST: IPv4 compat mode off - route dump                             [ OK ]
# TEST: IPv4 compat mode off - nexthop change                         [ OK ]
# TEST: IPv4 compat mode off - nexthop delete                         [ OK ]
# TEST: IPv4 set compat mode - 1                                      [ OK ]
#=20
# IPv4 fdb groups functional
# --------------------------
# TEST: Fdb Nexthop group with multiple nexthops                      [ OK ]
# TEST: Get Fdb nexthop group by id                                   [ OK ]
# TEST: Fdb Nexthop group with non-fdb nexthops                       [ OK ]
# TEST: Non-Fdb Nexthop group with fdb nexthops                       [ OK ]
# TEST: Fdb Nexthop with blackhole                                    [ OK ]
# TEST: Fdb Nexthop with oif                                          [ OK ]
# TEST: Fdb Nexthop with onlink                                       [ OK ]
# TEST: Fdb Nexthop with encap                                        [ OK ]
# TEST: Fdb mac add with nexthop group                                [ OK ]
# TEST: Fdb mac add with nexthop                                      [ OK ]
# TEST: Route add with fdb nexthop                                    [ OK ]
# TEST: Route add with fdb nexthop group                              [ OK ]
# TEST: Fdb entry after deleting a single nexthop                     [ OK ]
# TEST: Fdb nexthop delete                                            [ OK ]
# TEST: Fdb entry after deleting a nexthop group                      [ OK ]
#=20
# IPv4 runtime torture
# --------------------
# SKIP: Could not run test; need mausezahn tool
#=20
# IPv6
# ----------------------
# TEST: Create nexthop with id, gw, dev                               [ OK ]
# TEST: Get nexthop by id                                             [ OK ]
# TEST: Delete nexthop by id                                          [ OK ]
# TEST: Create nexthop - gw only                                      [ OK ]
# TEST: Create nexthop - invalid gw+dev combination                   [ OK ]
# TEST: Create nexthop - gw+dev and onlink                            [ OK ]
# TEST: Nexthops removed on admin down                                [ OK ]
#=20
# IPv6 groups functional
# ----------------------
# TEST: Create nexthop group with single nexthop                      [ OK ]
# TEST: Get nexthop group by id                                       [ OK ]
# TEST: Delete nexthop group by id                                    [ OK ]
# TEST: Nexthop group with multiple nexthops                          [ OK ]
# TEST: Nexthop group updated when entry is deleted                   [ OK ]
# TEST: Nexthop group with weighted nexthops                          [ OK ]
# TEST: Weighted nexthop group updated when entry is deleted          [ OK ]
# TEST: Nexthops in groups removed on admin down                      [ OK ]
# TEST: Multiple groups with same nexthop                             [ OK ]
# TEST: Nexthops in group removed on admin down - mixed group         [ OK ]
# TEST: Nexthop group can not have a group as an entry                [ OK ]
# TEST: Nexthop group with a blackhole entry                          [ OK ]
# TEST: Nexthop group can not have a blackhole and another nexthop    [ OK ]
#=20
# IPv6 functional runtime
# -----------------------
# TEST: Route add                                                     [ OK ]
# TEST: Route delete                                                  [ OK ]
# TEST: Ping with nexthop                                             [FAIL]
# TEST: Ping - multipath                                              [ OK ]
# TEST: Ping - blackhole                                              [ OK ]
# TEST: Ping - blackhole replaced with gateway                        [ OK ]
# TEST: Ping - gateway replaced by blackhole                          [ OK ]
# TEST: Ping - group with blackhole                                   [ OK ]
# TEST: Ping - group blackhole replaced with gateways                 [ OK ]
# TEST: IPv6 route with device only nexthop                           [ OK ]
# TEST: IPv6 multipath route with nexthop mix - dev only + gw         [ OK ]
# TEST: IPv6 route can not have a v4 gateway                          [ OK ]
# TEST: Nexthop replace - v6 route, v4 nexthop                        [ OK ]
# TEST: Nexthop replace of group entry - v6 route, v4 nexthop         [ OK ]
# TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
# TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
# TEST: IPv6 route using a group after removing v4 gateways           [ OK ]
# TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
# TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
# TEST: IPv6 route using a group after replacing v4 gateways          [ OK ]
# TEST: Nexthop with default route and rpfilter                       [ OK ]
# TEST: Nexthop with multipath default route and rpfilter             [ OK ]
#=20
# IPv6 large groups (x32)
# ---------------------
# TEST: Dump large (x32) ecmp groups                                  [ OK ]
#=20
# IPv6 nexthop api compat mode test
# --------------------------------
# TEST: IPv6 default nexthop compat mode check                        [ OK ]
# TEST: IPv6 compat mode on - route add notification                  [ OK ]
# TEST: IPv6 compat mode on - route dump                              [ OK ]
# TEST: IPv6 compat mode on - nexthop change                          [ OK ]
# TEST: IPv6 set compat mode - 0                                      [ OK ]
# TEST: IPv6 compat mode off - route add notification                 [ OK ]
# TEST: IPv6 compat mode off - route dump                             [ OK ]
# TEST: IPv6 compat mode off - nexthop change                         [ OK ]
# TEST: IPv6 compat mode off - nexthop delete                         [ OK ]
# TEST: IPv6 set compat mode - 1                                      [ OK ]
#=20
# IPv6 fdb groups functional
# --------------------------
# TEST: Fdb Nexthop group with multiple nexthops                      [ OK ]
# TEST: Get Fdb nexthop group by id                                   [ OK ]
# TEST: Fdb Nexthop group with non-fdb nexthops                       [ OK ]
# TEST: Non-Fdb Nexthop group with fdb nexthops                       [ OK ]
# TEST: Fdb Nexthop with blackhole                                    [ OK ]
# TEST: Fdb Nexthop with oif                                          [ OK ]
# TEST: Fdb Nexthop with onlink                                       [ OK ]
# TEST: Fdb Nexthop with encap                                        [ OK ]
# TEST: Fdb mac add with nexthop group                                [ OK ]
# TEST: Fdb mac add with nexthop                                      [ OK ]
# TEST: Route add with fdb nexthop                                    [ OK ]
# TEST: Route add with fdb nexthop group                              [ OK ]
# TEST: Fdb entry after deleting a single nexthop                     [ OK ]
# TEST: Fdb nexthop delete                                            [ OK ]
# TEST: Fdb entry after deleting a nexthop group                      [ OK ]
#=20
# IPv6 runtime torture
# --------------------
# SKIP: Could not run test; need mausezahn tool
#=20
# Tests passed: 161
# Tests failed:   1
not ok 35 selftests: net: fib_nexthops.sh # exit=3D1
# selftests: net: altnames.sh
# SKIP: jq not installed
not ok 36 selftests: net: altnames.sh # exit=3D1
# selftests: net: icmp_redirect.sh
#=20
# #########################################################################=
##
# Legacy routing
# #########################################################################=
##
#=20
# TEST: IPv4: redirect exception                                      [ OK ]
# TEST: IPv6: redirect exception                                      [FAIL]
# TEST: IPv4: redirect exception plus mtu                             [ OK ]
# TEST: IPv6: redirect exception plus mtu                             [FAIL]
# TEST: IPv4: routing reset                                           [ OK ]
# TEST: IPv6: routing reset                                           [ OK ]
# TEST: IPv4: mtu exception                                           [ OK ]
# TEST: IPv6: mtu exception                                           [ OK ]
# TEST: IPv4: mtu exception plus redirect                             [ OK ]
# TEST: IPv6: mtu exception plus redirect                             [FAIL]
#=20
# #########################################################################=
##
# Legacy routing with VRF
# #########################################################################=
##
#=20
# TEST: IPv4: redirect exception                                      [ OK ]
# TEST: IPv6: redirect exception                                      [FAIL]
# TEST: IPv4: redirect exception plus mtu                             [ OK ]
# TEST: IPv6: redirect exception plus mtu                             [FAIL]
# TEST: IPv4: routing reset                                           [ OK ]
# TEST: IPv6: routing reset                                           [ OK ]
# TEST: IPv4: mtu exception                                           [ OK ]
# TEST: IPv6: mtu exception                                           [ OK ]
# TEST: IPv4: mtu exception plus redirect                             [ OK ]
# TEST: IPv6: mtu exception plus redirect                             [FAIL]
#=20
# #########################################################################=
##
# Routing with nexthop objects
# #########################################################################=
##
#=20
# TEST: IPv4: redirect exception                                      [ OK ]
# TEST: IPv6: redirect exception                                      [FAIL]
# TEST: IPv4: redirect exception plus mtu                             [ OK ]
# TEST: IPv6: redirect exception plus mtu                             [FAIL]
# TEST: IPv4: routing reset                                           [ OK ]
# TEST: IPv6: routing reset                                           [ OK ]
# TEST: IPv4: mtu exception                                           [ OK ]
# TEST: IPv6: mtu exception                                           [ OK ]
# TEST: IPv4: mtu exception plus redirect                             [ OK ]
# TEST: IPv6: mtu exception plus redirect                             [FAIL]
#=20
# #########################################################################=
##
# Routing with nexthop objects and VRF
# #########################################################################=
##
#=20
# TEST: IPv4: redirect exception                                      [ OK ]
# TEST: IPv6: redirect exception                                      [FAIL]
# TEST: IPv4: redirect exception plus mtu                             [ OK ]
# TEST: IPv6: redirect exception plus mtu                             [FAIL]
# TEST: IPv4: routing reset                                           [ OK ]
# TEST: IPv6: routing reset                                           [ OK ]
# TEST: IPv4: mtu exception                                           [ OK ]
# TEST: IPv6: mtu exception                                           [ OK ]
# TEST: IPv4: mtu exception plus redirect                             [ OK ]
# TEST: IPv6: mtu exception plus redirect                             [FAIL]
#=20
# Tests passed:  28
# Tests failed:  12
not ok 37 selftests: net: icmp_redirect.sh # exit=3D1
# selftests: net: ip6_gre_headroom.sh
# TEST: ip6gretap headroom                                            [PASS]
# TEST: ip6erspan headroom                                            [PASS]
ok 38 selftests: net: ip6_gre_headroom.sh
# selftests: net: route_localnet.sh
# run arp_announce test
# net.ipv4.conf.veth0.route_localnet =3D 1
# net.ipv4.conf.veth1.route_localnet =3D 1
# net.ipv4.conf.veth0.arp_announce =3D 2
# net.ipv4.conf.veth1.arp_announce =3D 2
# PING 127.25.3.14 (127.25.3.14) from 127.25.3.4 veth0: 56(84) bytes of dat=
a.
# 64 bytes from 127.25.3.14: icmp_seq=3D1 ttl=3D64 time=3D0.117 ms
# 64 bytes from 127.25.3.14: icmp_seq=3D2 ttl=3D64 time=3D0.053 ms
# 64 bytes from 127.25.3.14: icmp_seq=3D3 ttl=3D64 time=3D0.046 ms
# 64 bytes from 127.25.3.14: icmp_seq=3D4 ttl=3D64 time=3D0.045 ms
# 64 bytes from 127.25.3.14: icmp_seq=3D5 ttl=3D64 time=3D0.045 ms
#=20
# --- 127.25.3.14 ping statistics ---
# 5 packets transmitted, 5 received, 0% packet loss, time 106ms
# rtt min/avg/max/mdev =3D 0.045/0.061/0.117/0.028 ms
# ok
# run arp_ignore test
# net.ipv4.conf.veth0.route_localnet =3D 1
# net.ipv4.conf.veth1.route_localnet =3D 1
# net.ipv4.conf.veth0.arp_ignore =3D 3
# net.ipv4.conf.veth1.arp_ignore =3D 3
# PING 127.25.3.14 (127.25.3.14) from 127.25.3.4 veth0: 56(84) bytes of dat=
a.
# 64 bytes from 127.25.3.14: icmp_seq=3D1 ttl=3D64 time=3D0.081 ms
# 64 bytes from 127.25.3.14: icmp_seq=3D2 ttl=3D64 time=3D0.059 ms
# 64 bytes from 127.25.3.14: icmp_seq=3D3 ttl=3D64 time=3D0.047 ms
# 64 bytes from 127.25.3.14: icmp_seq=3D4 ttl=3D64 time=3D0.045 ms
# 64 bytes from 127.25.3.14: icmp_seq=3D5 ttl=3D64 time=3D0.045 ms
#=20
# --- 127.25.3.14 ping statistics ---
# 5 packets transmitted, 5 received, 0% packet loss, time 90ms
# rtt min/avg/max/mdev =3D 0.045/0.055/0.081/0.015 ms
# ok
ok 39 selftests: net: route_localnet.sh
# selftests: net: reuseaddr_ports_exhausted.sh
# TAP version 13
# 1..3
# # Starting 3 tests from 1 test cases.
# #  RUN           global.reuseaddr_ports_exhausted_unreusable ...
# #            OK  global.reuseaddr_ports_exhausted_unreusable
# ok 1 global.reuseaddr_ports_exhausted_unreusable
# #  RUN           global.reuseaddr_ports_exhausted_reusable_same_euid ...
# #            OK  global.reuseaddr_ports_exhausted_reusable_same_euid
# ok 2 global.reuseaddr_ports_exhausted_reusable_same_euid
# #  RUN           global.reuseaddr_ports_exhausted_reusable_different_euid=
 ...
# #            OK  global.reuseaddr_ports_exhausted_reusable_different_euid
# ok 3 global.reuseaddr_ports_exhausted_reusable_different_euid
# # PASSED: 3 / 3 tests passed.
# # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0
# tests done
ok 40 selftests: net: reuseaddr_ports_exhausted.sh
# selftests: net: txtimestamp.sh
# protocol:     TCP
# payload:      10
# server port:  9000
#=20
# family:       INET=20
# test SND
#     USR: 1606931270 s 382032 us (seq=3D0, len=3D0)
#     SND: 1606931270 s 383277 us (seq=3D9, len=3D10)  (USR +1244 us)
#     USR: 1606931270 s 432258 us (seq=3D0, len=3D0)
#     SND: 1606931270 s 433281 us (seq=3D19, len=3D10)  (USR +1023 us)
#     USR: 1606931270 s 482546 us (seq=3D0, len=3D0)
#     SND: 1606931270 s 483578 us (seq=3D29, len=3D10)  (USR +1032 us)
#     USR: 1606931270 s 532819 us (seq=3D0, len=3D0)
#     SND: 1606931270 s 533851 us (seq=3D39, len=3D10)  (USR +1032 us)
#     USR-SND: count=3D4, avg=3D1083 us, min=3D1023 us, max=3D1244 us
# test ENQ
#     USR: 1606931270 s 689649 us (seq=3D0, len=3D0)
#     ENQ: 1606931270 s 689700 us (seq=3D9, len=3D10)  (USR +51 us)
#     USR: 1606931270 s 739968 us (seq=3D0, len=3D0)
#     ENQ: 1606931270 s 740002 us (seq=3D19, len=3D10)  (USR +33 us)
#     USR: 1606931270 s 790258 us (seq=3D0, len=3D0)
#     ENQ: 1606931270 s 790278 us (seq=3D29, len=3D10)  (USR +19 us)
#     USR: 1606931270 s 840530 us (seq=3D0, len=3D0)
#     ENQ: 1606931270 s 840550 us (seq=3D39, len=3D10)  (USR +19 us)
#     USR-ENQ: count=3D4, avg=3D31 us, min=3D19 us, max=3D51 us
# test ENQ + SND
#     USR: 1606931270 s 997452 us (seq=3D0, len=3D0)
#     ENQ: 1606931270 s 997499 us (seq=3D9, len=3D10)  (USR +47 us)
#     SND: 1606931270 s 998506 us (seq=3D9, len=3D10)  (USR +1054 us)
#     USR: 1606931271 s 47690 us (seq=3D0, len=3D0)
#     ENQ: 1606931271 s 47717 us (seq=3D19, len=3D10)  (USR +27 us)
#     SND: 1606931271 s 48725 us (seq=3D19, len=3D10)  (USR +1035 us)
#     USR: 1606931271 s 97897 us (seq=3D0, len=3D0)
#     ENQ: 1606931271 s 97910 us (seq=3D29, len=3D10)  (USR +13 us)
#     SND: 1606931271 s 98920 us (seq=3D29, len=3D10)  (USR +1023 us)
#     USR: 1606931271 s 148112 us (seq=3D0, len=3D0)
#     ENQ: 1606931271 s 148127 us (seq=3D39, len=3D10)  (USR +14 us)
#     SND: 1606931271 s 149140 us (seq=3D39, len=3D10)  (USR +1027 us)
#     USR-ENQ: count=3D4, avg=3D25 us, min=3D13 us, max=3D47 us
#     USR-SND: count=3D4, avg=3D1035 us, min=3D1023 us, max=3D1054 us
#=20
# test ACK
#     USR: 1606931271 s 304660 us (seq=3D0, len=3D0)
#     ACK: 1606931271 s 310764 us (seq=3D9, len=3D10)  (USR +6104 us)
#     USR: 1606931271 s 354878 us (seq=3D0, len=3D0)
# ERROR: 23548 us expected between 6000 and 6500
#     ACK: 1606931271 s 378426 us (seq=3D19, len=3D10)  (USR +23547 us)
#     USR: 1606931271 s 405066 us (seq=3D0, len=3D0)
# ERROR: 23575 us expected between 6000 and 6500
#     ACK: 1606931271 s 428641 us (seq=3D29, len=3D10)  (USR +23574 us)
#     USR: 1606931271 s 455308 us (seq=3D0, len=3D0)
# ERROR: 23533 us expected between 6000 and 6500
#     ACK: 1606931271 s 478841 us (seq=3D39, len=3D10)  (USR +23532 us)
#     USR-ACK: count=3D4, avg=3D19190 us, min=3D6104 us, max=3D23574 us
#=20
# test SND + ACK
#     USR: 1606931271 s 616550 us (seq=3D0, len=3D0)
#     SND: 1606931271 s 617612 us (seq=3D9, len=3D10)  (USR +1062 us)
#     ACK: 1606931271 s 622653 us (seq=3D9, len=3D10)  (USR +6102 us)
#     USR: 1606931271 s 666826 us (seq=3D0, len=3D0)
#     SND: 1606931271 s 667858 us (seq=3D19, len=3D10)  (USR +1032 us)
#     ACK: 1606931271 s 672933 us (seq=3D19, len=3D10)  (USR +6107 us)
#     USR: 1606931271 s 717103 us (seq=3D0, len=3D0)
#     SND: 1606931271 s 718149 us (seq=3D29, len=3D10)  (USR +1045 us)
#     ACK: 1606931271 s 723206 us (seq=3D29, len=3D10)  (USR +6103 us)
#     USR: 1606931271 s 767440 us (seq=3D0, len=3D0)
#     SND: 1606931271 s 768478 us (seq=3D39, len=3D10)  (USR +1037 us)
#     ACK: 1606931271 s 773544 us (seq=3D39, len=3D10)  (USR +6103 us)
#     USR-SND: count=3D4, avg=3D1044 us, min=3D1032 us, max=3D1062 us
#     USR-ACK: count=3D4, avg=3D6104 us, min=3D6102 us, max=3D6107 us
#=20
# test ENQ + SND + ACK
#     USR: 1606931271 s 924257 us (seq=3D0, len=3D0)
#     ENQ: 1606931271 s 924314 us (seq=3D9, len=3D10)  (USR +57 us)
#     SND: 1606931271 s 925328 us (seq=3D9, len=3D10)  (USR +1071 us)
#     ACK: 1606931271 s 930447 us (seq=3D9, len=3D10)  (USR +6190 us)
#     USR: 1606931271 s 974619 us (seq=3D0, len=3D0)
#     ENQ: 1606931271 s 974653 us (seq=3D19, len=3D10)  (USR +33 us)
#     SND: 1606931271 s 975667 us (seq=3D19, len=3D10)  (USR +1047 us)
#     ACK: 1606931271 s 980723 us (seq=3D19, len=3D10)  (USR +6103 us)
#     USR: 1606931272 s 24883 us (seq=3D0, len=3D0)
#     ENQ: 1606931272 s 24897 us (seq=3D29, len=3D10)  (USR +13 us)
#     SND: 1606931272 s 25907 us (seq=3D29, len=3D10)  (USR +1023 us)
#     ACK: 1606931272 s 30953 us (seq=3D29, len=3D10)  (USR +6070 us)
#     USR: 1606931272 s 75133 us (seq=3D0, len=3D0)
#     ENQ: 1606931272 s 75161 us (seq=3D39, len=3D10)  (USR +27 us)
#     SND: 1606931272 s 76172 us (seq=3D39, len=3D10)  (USR +1039 us)
#     ACK: 1606931272 s 81225 us (seq=3D39, len=3D10)  (USR +6091 us)
#     USR-ENQ: count=3D4, avg=3D32 us, min=3D13 us, max=3D57 us
#     USR-SND: count=3D4, avg=3D1045 us, min=3D1023 us, max=3D1071 us
#     USR-ACK: count=3D4, avg=3D6113 us, min=3D6070 us, max=3D6190 us
not ok 41 selftests: net: txtimestamp.sh # exit=3D1
# selftests: net: vrf-xfrm-tests.sh
#=20
# No qdisc on VRF device
# TEST: IPv4 no xfrm policy                                           [ OK ]
# TEST: IPv6 no xfrm policy                                           [ OK ]
# TEST: IPv4 xfrm policy based on address                             [ OK ]
# TEST: IPv6 xfrm policy based on address                             [ OK ]
# TEST: IPv6 xfrm policy with VRF in selector                         [ OK ]
# Error: Unknown device type.
# Cannot find device "xfrm0"
# Cannot find device "xfrm0"
# Cannot find device "xfrm0"
# TEST: IPv4 xfrm policy with xfrm device                             [FAIL]
# TEST: IPv6 xfrm policy with xfrm device                             [FAIL]
# Cannot find device "xfrm0"
#=20
# netem qdisc on VRF device
# TEST: IPv4 no xfrm policy                                           [ OK ]
# TEST: IPv6 no xfrm policy                                           [ OK ]
# TEST: IPv4 xfrm policy based on address                             [ OK ]
# TEST: IPv6 xfrm policy based on address                             [ OK ]
# TEST: IPv6 xfrm policy with VRF in selector                         [ OK ]
# Error: Unknown device type.
# Cannot find device "xfrm0"
# Cannot find device "xfrm0"
# Cannot find device "xfrm0"
# TEST: IPv4 xfrm policy with xfrm device                             [FAIL]
# TEST: IPv6 xfrm policy with xfrm device                             [FAIL]
# Cannot find device "xfrm0"
#=20
# Tests passed:  10
# Tests failed:   4
not ok 42 selftests: net: vrf-xfrm-tests.sh # exit=3D1
# selftests: net: rxtimestamp.sh
# Testing ip...
# Starting testcase 0 over ipv4...
# Starting testcase 0 over ipv6...
# Starting testcase 1 over ipv4...
# Starting testcase 1 over ipv6...
# Starting testcase 2 over ipv4...
# Starting testcase 2 over ipv6...
# Starting testcase 3 over ipv4...
# Starting testcase 3 over ipv6...
# Starting testcase 4 over ipv4...
# Starting testcase 4 over ipv6...
# Starting testcase 5 over ipv4...
# Starting testcase 5 over ipv6...
# Starting testcase 6 over ipv4...
# Starting testcase 6 over ipv6...
# Starting testcase 7 over ipv4...
# Starting testcase 7 over ipv6...
# Starting testcase 8 over ipv4...
# Starting testcase 8 over ipv6...
# Starting testcase 9 over ipv4...
# Starting testcase 9 over ipv6...
# Testing udp...
# Starting testcase 0 over ipv4...
# Starting testcase 0 over ipv6...
# Starting testcase 1 over ipv4...
# Starting testcase 1 over ipv6...
# Starting testcase 2 over ipv4...
# Starting testcase 2 over ipv6...
# Starting testcase 3 over ipv4...
# Starting testcase 3 over ipv6...
# Starting testcase 4 over ipv4...
# Starting testcase 4 over ipv6...
# Starting testcase 5 over ipv4...
# Starting testcase 5 over ipv6...
# Starting testcase 6 over ipv4...
# Starting testcase 6 over ipv6...
# Starting testcase 7 over ipv4...
# Starting testcase 7 over ipv6...
# Starting testcase 8 over ipv4...
# Starting testcase 8 over ipv6...
# Starting testcase 9 over ipv4...
# Starting testcase 9 over ipv6...
# Testing tcp...
# Starting testcase 0 over ipv4...
# Starting testcase 0 over ipv6...
# Starting testcase 1 over ipv4...
# Starting testcase 1 over ipv6...
# Starting testcase 2 over ipv4...
# Starting testcase 2 over ipv6...
# Starting testcase 3 over ipv4...
# Starting testcase 3 over ipv6...
# Starting testcase 4 over ipv4...
# Starting testcase 4 over ipv6...
# Starting testcase 5 over ipv4...
# Starting testcase 5 over ipv6...
# Starting testcase 6 over ipv4...
# Starting testcase 6 over ipv6...
# Starting testcase 7 over ipv4...
# Starting testcase 7 over ipv6...
# Starting testcase 8 over ipv4...
# Starting testcase 8 over ipv6...
# Starting testcase 9 over ipv4...
# Starting testcase 9 over ipv6...
# PASSED.
ok 43 selftests: net: rxtimestamp.sh
# selftests: net: devlink_port_split.py
ok 44 selftests: net: devlink_port_split.py
# selftests: net: drop_monitor_tests.sh
# SKIP: Could not run test without tshark tool
ok 45 selftests: net: drop_monitor_tests.sh # SKIP
# selftests: net: vrf_route_leaking.sh
#=20
# #########################################################################=
##
# IPv4 (sym route): VRF ICMP ttl error route lookup ping
# #########################################################################=
##
#=20
# TEST: Basic IPv4 connectivity                                       [ OK ]
# TEST: Ping received ICMP ttl exceeded                               [ OK ]
#=20
# #########################################################################=
##
# IPv4 (sym route): VRF ICMP error route lookup traceroute
# #########################################################################=
##
#=20
# SKIP: Could not run IPV4 test without traceroute
#=20
# #########################################################################=
##
# IPv4 (sym route): VRF ICMP fragmentation error route lookup ping
# #########################################################################=
##
#=20
# TEST: Basic IPv4 connectivity                                       [ OK ]
# TEST: Ping received ICMP Frag needed                                [ OK ]
#=20
# #########################################################################=
##
# IPv4 (asym route): VRF ICMP ttl error route lookup ping
# #########################################################################=
##
#=20
# TEST: Basic IPv4 connectivity                                       [ OK ]
# TEST: Ping received ICMP ttl exceeded                               [ OK ]
#=20
# #########################################################################=
##
# IPv4 (asym route): VRF ICMP error route lookup traceroute
# #########################################################################=
##
#=20
# SKIP: Could not run IPV4 test without traceroute
#=20
# #########################################################################=
##
# IPv6 (sym route): VRF ICMP ttl error route lookup ping
# #########################################################################=
##
#=20
# TEST: Basic IPv6 connectivity                                       [ OK ]
# TEST: Ping received ICMP Hop limit                                  [ OK ]
#=20
# #########################################################################=
##
# IPv6 (sym route): VRF ICMP error route lookup traceroute
# #########################################################################=
##
#=20
# SKIP: Could not run IPV6 test without traceroute6
#=20
# #########################################################################=
##
# IPv6 (sym route): VRF ICMP fragmentation error route lookup ping
# #########################################################################=
##
#=20
# TEST: Basic IPv6 connectivity                                       [ OK ]
# TEST: Ping received ICMP Packet too big                             [FAIL]
#=20
# #########################################################################=
##
# IPv6 (asym route): VRF ICMP ttl error route lookup ping
# #########################################################################=
##
#=20
# TEST: Basic IPv6 connectivity                                       [ OK ]
# TEST: Ping received ICMP Hop limit                                  [ OK ]
#=20
# #########################################################################=
##
# IPv6 (asym route): VRF ICMP error route lookup traceroute
# #########################################################################=
##
#=20
# SKIP: Could not run IPV6 test without traceroute6
#=20
# Tests passed:  11
# Tests failed:   1
not ok 46 selftests: net: vrf_route_leaking.sh # exit=3D1
# selftests: net: bareudp.sh
# Error: Unknown device type.
# Error: Setting up the testing environment failed.
ok 47 selftests: net: bareudp.sh # SKIP
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-kselftests=
-de900a24194807c73768a543f989161a1ee47c7e/tools/testing/selftests/net'

--5gxpn/Q6ypwruk0T--
