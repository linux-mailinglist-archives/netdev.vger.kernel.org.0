Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 786FD4CB6C
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 11:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfFTJ7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 05:59:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:21398 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbfFTJ7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 05:59:21 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 02:59:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,396,1557212400"; 
   d="xz'?scan'208";a="154069285"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.6])
  by orsmga008.jf.intel.com with ESMTP; 20 Jun 2019 02:58:59 -0700
Date:   Thu, 20 Jun 2019 17:59:10 +0800
From:   kernel test robot <rong.a.chen@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com, lkp@01.org
Subject: [bpf] 9fe4f05d33: kernel_selftests.bpf.test_verifier.fail
Message-ID: <20190620095910.GQ7221@shao2-debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="By57YlnFViWR/M0S"
Content-Disposition: inline
In-Reply-To: <20190615191225.2409862-5-ast@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--By57YlnFViWR/M0S
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

FYI, we noticed the following commit (built with gcc-7):

commit: 9fe4f05d33eae0421a065e3bced38905b789c4e8 ("[PATCH v3 bpf-next 4/9] bpf: introduce bounded loops")
url: https://github.com/0day-ci/linux/commits/Alexei-Starovoitov/bpf-bounded-loops-and-other-features/20190617-041439
base: https://git.kernel.org/cgit/linux/kernel/git/bpf/bpf-next.git master

in testcase: kernel_selftests
with following parameters:

	group: kselftests-00

test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
test-url: https://www.kernel.org/doc/Documentation/kselftest.txt


on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 4G

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):


# selftests: bpf: test_verifier
# #0/u invalid and of negative number OK
# #0/p invalid and of negative number OK
# #1/u invalid range check OK
# #1/p invalid range check OK
# #2/u valid map access into an array with a constant OK
# #2/p valid map access into an array with a constant OK
# #3/u valid map access into an array with a register OK
# #3/p valid map access into an array with a register OK
# #4/u valid map access into an array with a variable OK
# #4/p valid map access into an array with a variable OK
# #5/u valid map access into an array with a signed variable OK
# #5/p valid map access into an array with a signed variable OK
# #6/u invalid map access into an array with a constant OK
# #6/p invalid map access into an array with a constant OK
# #7/u invalid map access into an array with a register OK
# #7/p invalid map access into an array with a register OK
# #8/u invalid map access into an array with a variable OK
# #8/p invalid map access into an array with a variable OK
# #9/u invalid map access into an array with no floor check OK
# #9/p invalid map access into an array with no floor check OK
# #10/u invalid map access into an array with a invalid max check OK
# #10/p invalid map access into an array with a invalid max check OK
# #11/u invalid map access into an array with a invalid max check OK
# #11/p invalid map access into an array with a invalid max check OK
# #12/u valid read map access into a read-only array 1 OK
# #12/p valid read map access into a read-only array 1 OK
# #13/p valid read map access into a read-only array 2 OK
# #14/u invalid write map access into a read-only array 1 OK
# #14/p invalid write map access into a read-only array 1 OK
# #15/p invalid write map access into a read-only array 2 OK
# #16/u valid write map access into a write-only array 1 OK
# #16/p valid write map access into a write-only array 1 OK
# #17/p valid write map access into a write-only array 2 OK
# #18/u invalid read map access into a write-only array 1 OK
# #18/p invalid read map access into a write-only array 1 OK
# #19/p invalid read map access into a write-only array 2 OK
# #20/u empty prog OK
# #20/p empty prog OK
# #21/u only exit insn OK
# #21/p only exit insn OK
# #22/u no bpf_exit OK
# #22/p no bpf_exit OK
# #23/u invalid call insn1 OK
# #23/p invalid call insn1 OK
# #24/u invalid call insn2 OK
# #24/p invalid call insn2 OK
# #25/u invalid function call OK
# #25/p invalid function call OK
# #26/p invalid argument register OK
# #27/p non-invalid argument register OK
# #28/u add+sub+mul OK
# #28/p add+sub+mul OK
# #29/p xor32 zero extend check OK
# #30/u arsh32 on imm OK
# #30/p arsh32 on imm OK
# #31/u arsh32 on imm 2 OK
# #31/p arsh32 on imm 2 OK
# #32/u arsh32 on reg OK
# #32/p arsh32 on reg OK
# #33/u arsh32 on reg 2 OK
# #33/p arsh32 on reg 2 OK
# #34/u arsh64 on imm OK
# #34/p arsh64 on imm OK
# #35/u arsh64 on reg OK
# #35/p arsh64 on reg OK
# #36/u invalid 64-bit BPF_END OK
# #36/p invalid 64-bit BPF_END OK
# #37/p mov64 src == dst OK
# #38/p mov64 src != dst OK
# #39/u stack out of bounds OK
# #39/p stack out of bounds OK
# #40/u uninitialized stack1 OK
# #40/p uninitialized stack1 OK
# #41/u uninitialized stack2 OK
# #41/p uninitialized stack2 OK
# #42/u invalid fp arithmetic OK
# #42/p invalid fp arithmetic OK
# #43/u non-invalid fp arithmetic OK
# #43/p non-invalid fp arithmetic OK
# #44/u misaligned read from stack OK
# #44/p misaligned read from stack OK
# #45/u invalid src register in STX OK
# #45/p invalid src register in STX OK
# #46/u invalid dst register in STX OK
# #46/p invalid dst register in STX OK
# #47/u invalid dst register in ST OK
# #47/p invalid dst register in ST OK
# #48/u invalid src register in LDX OK
# #48/p invalid src register in LDX OK
# #49/u invalid dst register in LDX OK
# #49/p invalid dst register in LDX OK
# #50/u subtraction bounds (map value) variant 1 OK
# #50/p subtraction bounds (map value) variant 1 OK
# #51/u subtraction bounds (map value) variant 2 OK
# #51/p subtraction bounds (map value) variant 2 OK
# #52/u check subtraction on pointers for unpriv OK
# #52/p check subtraction on pointers for unpriv OK
# #53/u bounds check based on zero-extended MOV OK
# #53/p bounds check based on zero-extended MOV OK
# #54/u bounds check based on sign-extended MOV. test1 OK
# #54/p bounds check based on sign-extended MOV. test1 OK
# #55/u bounds check based on sign-extended MOV. test2 OK
# #55/p bounds check based on sign-extended MOV. test2 OK
# #56/p bounds check based on reg_off + var_off + insn_off. test1 OK
# #57/p bounds check based on reg_off + var_off + insn_off. test2 OK
# #58/u bounds check after truncation of non-boundary-crossing range OK
# #58/p bounds check after truncation of non-boundary-crossing range OK
# #59/u bounds check after truncation of boundary-crossing range (1) OK
# #59/p bounds check after truncation of boundary-crossing range (1) OK
# #60/u bounds check after truncation of boundary-crossing range (2) OK
# #60/p bounds check after truncation of boundary-crossing range (2) OK
# #61/u bounds check after wrapping 32-bit addition OK
# #61/p bounds check after wrapping 32-bit addition OK
# #62/u bounds check after shift with oversized count operand OK
# #62/p bounds check after shift with oversized count operand OK
# #63/u bounds check after right shift of maybe-negative number OK
# #63/p bounds check after right shift of maybe-negative number OK
# #64/u bounds check after 32-bit right shift with 64-bit input OK
# #64/p bounds check after 32-bit right shift with 64-bit input OK
# #65/u bounds check map access with off+size signed 32bit overflow. test1 OK
# #65/p bounds check map access with off+size signed 32bit overflow. test1 OK
# #66/u bounds check map access with off+size signed 32bit overflow. test2 OK
# #66/p bounds check map access with off+size signed 32bit overflow. test2 OK
# #67/u bounds check map access with off+size signed 32bit overflow. test3 OK
# #67/p bounds check map access with off+size signed 32bit overflow. test3 OK
# #68/u bounds check map access with off+size signed 32bit overflow. test4 OK
# #68/p bounds check map access with off+size signed 32bit overflow. test4 OK
# #69/u check deducing bounds from const, 1 OK
# #69/p check deducing bounds from const, 1 OK
# #70/u check deducing bounds from const, 2 OK
# #70/p check deducing bounds from const, 2 OK
# #71/u check deducing bounds from const, 3 OK
# #71/p check deducing bounds from const, 3 OK
# #72/u check deducing bounds from const, 4 OK
# #72/p check deducing bounds from const, 4 OK
# #73/u check deducing bounds from const, 5 OK
# #73/p check deducing bounds from const, 5 OK
# #74/u check deducing bounds from const, 6 OK
# #74/p check deducing bounds from const, 6 OK
# #75/u check deducing bounds from const, 7 OK
# #75/p check deducing bounds from const, 7 OK
# #76/u check deducing bounds from const, 8 OK
# #76/p check deducing bounds from const, 8 OK
# #77/u check deducing bounds from const, 9 OK
# #77/p check deducing bounds from const, 9 OK
# #78/u check deducing bounds from const, 10 OK
# #78/p check deducing bounds from const, 10 OK
# #79/u bounds checks mixing signed and unsigned, positive bounds OK
# #79/p bounds checks mixing signed and unsigned, positive bounds OK
# #80/u bounds checks mixing signed and unsigned OK
# #80/p bounds checks mixing signed and unsigned OK
# #81/u bounds checks mixing signed and unsigned, variant 2 OK
# #81/p bounds checks mixing signed and unsigned, variant 2 OK
# #82/u bounds checks mixing signed and unsigned, variant 3 OK
# #82/p bounds checks mixing signed and unsigned, variant 3 OK
# #83/u bounds checks mixing signed and unsigned, variant 4 OK
# #83/p bounds checks mixing signed and unsigned, variant 4 OK
# #84/u bounds checks mixing signed and unsigned, variant 5 OK
# #84/p bounds checks mixing signed and unsigned, variant 5 OK
# #85/u bounds checks mixing signed and unsigned, variant 6 OK
# #85/p bounds checks mixing signed and unsigned, variant 6 OK
# #86/u bounds checks mixing signed and unsigned, variant 7 OK
# #86/p bounds checks mixing signed and unsigned, variant 7 OK
# #87/u bounds checks mixing signed and unsigned, variant 8 OK
# #87/p bounds checks mixing signed and unsigned, variant 8 OK
# #88/u bounds checks mixing signed and unsigned, variant 9 OK
# #88/p bounds checks mixing signed and unsigned, variant 9 OK
# #89/u bounds checks mixing signed and unsigned, variant 10 OK
# #89/p bounds checks mixing signed and unsigned, variant 10 OK
# #90/u bounds checks mixing signed and unsigned, variant 11 OK
# #90/p bounds checks mixing signed and unsigned, variant 11 OK
# #91/u bounds checks mixing signed and unsigned, variant 12 OK
# #91/p bounds checks mixing signed and unsigned, variant 12 OK
# #92/u bounds checks mixing signed and unsigned, variant 13 OK
# #92/p bounds checks mixing signed and unsigned, variant 13 OK
# #93/u bounds checks mixing signed and unsigned, variant 14 OK
# #93/p bounds checks mixing signed and unsigned, variant 14 OK
# #94/u bounds checks mixing signed and unsigned, variant 15 OK
# #94/p bounds checks mixing signed and unsigned, variant 15 OK
# #95/p bpf_get_stack return R0 within range OK
# #96/p calls: basic sanity OK
# #97/u calls: not on unpriviledged OK
# #97/p calls: not on unpriviledged OK
# #98/p calls: div by 0 in subprog OK
# #99/p calls: multiple ret types in subprog 1 OK
# #100/p calls: multiple ret types in subprog 2 OK
# #101/p calls: overlapping caller/callee OK
# #102/p calls: wrong recursive calls OK
# #103/p calls: wrong src reg OK
# #104/p calls: wrong off value OK
# #105/p calls: jump back loop OK
# #106/p calls: conditional call OK
# #107/p calls: conditional call 2 OK
# #108/p calls: conditional call 3 FAIL
# Unexpected success to load!
# verification time 7 usec
# stack depth 0
# processed 15 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 0
# #109/p calls: conditional call 4 OK
# #110/p calls: conditional call 5 FAIL
# Unexpected success to load!
# verification time 48 usec
# stack depth 0+0
# processed 15 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 0
# #111/p calls: conditional call 6 FAIL
# Unexpected error message!
# 	EXP: back-edge from insn
# 	RES: R1 !read_ok
# verification time 8 usec
# stack depth 0+0
# processed 7 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
# 
# R1 !read_ok
# verification time 8 usec
# stack depth 0+0
# processed 7 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
# #112/p calls: using r0 returned by callee OK
# #113/p calls: using uninit r0 from callee OK
# #114/p calls: callee is using r1 OK
# #115/u calls: callee using args1 OK
# #115/p calls: callee using args1 OK
# #116/p calls: callee using wrong args2 OK
# #117/u calls: callee using two args OK
# #117/p calls: callee using two args OK
# #118/p calls: callee changing pkt pointers OK
# #119/u calls: ptr null check in subprog OK
# #119/p calls: ptr null check in subprog OK
# #120/p calls: two calls with args OK
# #121/p calls: calls with stack arith OK
# #122/p calls: calls with misaligned stack access OK
# #123/p calls: calls control flow, jump test OK
# #124/p calls: calls control flow, jump test 2 OK
# #125/p calls: two calls with bad jump OK
# #126/p calls: recursive call. test1 OK
# #127/p calls: recursive call. test2 OK
# #128/p calls: unreachable code OK
# #129/p calls: invalid call OK
# #130/p calls: invalid call 2 OK
# #131/p calls: jumping across function bodies. test1 OK
# #132/p calls: jumping across function bodies. test2 OK
# #133/p calls: call without exit OK
# #134/p calls: call into middle of ld_imm64 OK
# #135/p calls: call into middle of other call OK
# #136/p calls: ld_abs with changing ctx data in callee OK
# #137/p calls: two calls with bad fallthrough OK
# #138/p calls: two calls with stack read OK
# #139/p calls: two calls with stack write OK
# #140/p calls: stack overflow using two frames (pre-call access) OK
# #141/p calls: stack overflow using two frames (post-call access) OK
# #142/p calls: stack depth check using three frames. test1 OK
# #143/p calls: stack depth check using three frames. test2 OK
# #144/p calls: stack depth check using three frames. test3 OK
# #145/p calls: stack depth check using three frames. test4 OK
# #146/p calls: stack depth check using three frames. test5 OK
# #147/p calls: stack depth check in dead code OK
# #148/p calls: spill into caller stack frame OK
# #149/p calls: write into caller stack frame OK
# #150/p calls: write into callee stack frame OK
# #151/p calls: two calls with stack write and void return OK
# #152/u calls: ambiguous return value OK
# #152/p calls: ambiguous return value OK
# #153/p calls: two calls that return map_value OK
# #154/p calls: two calls that return map_value with bool condition OK
# #155/p calls: two calls that return map_value with incorrect bool check OK
# #156/p calls: two calls that receive map_value via arg=ptr_stack_of_caller. test1 OK
# #157/p calls: two calls that receive map_value via arg=ptr_stack_of_caller. test2 OK
# #158/p calls: two jumps that receive map_value via arg=ptr_stack_of_jumper. test3 OK
# #159/p calls: two calls that receive map_value_ptr_or_null via arg. test1 OK
# #160/p calls: two calls that receive map_value_ptr_or_null via arg. test2 OK
# #161/p calls: pkt_ptr spill into caller stack OK
# #162/p calls: pkt_ptr spill into caller stack 2 OK
# #163/p calls: pkt_ptr spill into caller stack 3 OK
# #164/p calls: pkt_ptr spill into caller stack 4 OK
# #165/p calls: pkt_ptr spill into caller stack 5 OK
# #166/p calls: pkt_ptr spill into caller stack 6 OK
# #167/p calls: pkt_ptr spill into caller stack 7 OK
# #168/p calls: pkt_ptr spill into caller stack 8 OK
# #169/p calls: pkt_ptr spill into caller stack 9 OK
# #170/p calls: caller stack init to zero or map_value_or_null OK
# #171/p calls: stack init to zero and pruning OK
# #172/u calls: ctx read at start of subprog OK
# #172/p calls: ctx read at start of subprog OK
# #173/u calls: cross frame pruning OK
# #173/p calls: cross frame pruning FAIL
# Unexpected success to load!
# verification time 85 usec
# stack depth 0+0
# processed 15 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 0
# #174/u calls: cross frame pruning - liveness propagation OK
# #174/p calls: cross frame pruning - liveness propagation OK
# #175/u unreachable OK
# #175/p unreachable OK
# #176/u unreachable2 OK
# #176/p unreachable2 OK
# #177/u out of range jump OK
# #177/p out of range jump OK
# #178/u out of range jump2 OK
# #178/p out of range jump2 OK
# #179/u loop (back-edge) OK
# #179/p loop (back-edge) FAIL
# Unexpected error message!
# 	EXP: back-edge
# 	RES: unreachable insn 1
# verification time 4 usec
# stack depth 0
# processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
# 
# unreachable insn 1
# verification time 4 usec
# stack depth 0
# processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
# #180/u loop2 (back-edge) OK
# #180/p loop2 (back-edge) FAIL
# Unexpected error message!
# 	EXP: back-edge
# 	RES: unreachable insn 4
# verification time 5 usec
# stack depth 0
# processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
# 
# unreachable insn 4
# verification time 5 usec
# stack depth 0
# processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
# #181/u conditional loop OK
# #181/p conditional loop FAIL
# Unexpected error message!
# 	EXP: back-edge
# 	RES: R0 !read_ok
# verification time 6 usec
# stack depth 0
# processed 1 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
# 
# R0 !read_ok
# verification time 6 usec
# stack depth 0
# processed 1 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
# #182/p bpf_exit with invalid return code. test1 OK
# #183/p bpf_exit with invalid return code. test2 OK
# #184/p bpf_exit with invalid return code. test3 OK
# #185/p bpf_exit with invalid return code. test4 OK
# #186/p bpf_exit with invalid return code. test5 OK
# #187/p bpf_exit with invalid return code. test6 OK
# #188/p bpf_exit with invalid return code. test7 OK
# #189/u direct packet read test#1 for CGROUP_SKB OK
# #189/p direct packet read test#1 for CGROUP_SKB OK
# #190/u direct packet read test#2 for CGROUP_SKB OK
# #190/p direct packet read test#2 for CGROUP_SKB OK
# #191/u direct packet read test#3 for CGROUP_SKB OK
# #191/p direct packet read test#3 for CGROUP_SKB OK
# #192/u direct packet read test#4 for CGROUP_SKB OK
# #192/p direct packet read test#4 for CGROUP_SKB OK
# #193/u invalid access of tc_classid for CGROUP_SKB OK
# #193/p invalid access of tc_classid for CGROUP_SKB OK
# #194/u invalid access of data_meta for CGROUP_SKB OK
# #194/p invalid access of data_meta for CGROUP_SKB OK
# #195/u invalid access of flow_keys for CGROUP_SKB OK
# #195/p invalid access of flow_keys for CGROUP_SKB OK
# #196/u invalid write access to napi_id for CGROUP_SKB OK
# #196/p invalid write access to napi_id for CGROUP_SKB OK
# #197/u write tstamp from CGROUP_SKB OK
# #197/p write tstamp from CGROUP_SKB OK
# #198/u read tstamp from CGROUP_SKB OK
# #198/p read tstamp from CGROUP_SKB OK
# #199/u valid cgroup storage access OK
# #199/p valid cgroup storage access OK
# #200/u invalid cgroup storage access 1 OK
# #200/p invalid cgroup storage access 1 OK
# #201/u invalid cgroup storage access 2 OK
# #201/p invalid cgroup storage access 2 OK
# #202/u invalid cgroup storage access 3 OK
# #202/p invalid cgroup storage access 3 OK
# #203/u invalid cgroup storage access 4 OK
# #203/p invalid cgroup storage access 4 OK
# #204/u invalid cgroup storage access 5 OK
# #204/p invalid cgroup storage access 5 OK
# #205/u invalid cgroup storage access 6 OK
# #205/p invalid cgroup storage access 6 OK
# #206/u valid per-cpu cgroup storage access OK
# #206/p valid per-cpu cgroup storage access OK
# #207/u invalid per-cpu cgroup storage access 1 OK
# #207/p invalid per-cpu cgroup storage access 1 OK
# #208/u invalid per-cpu cgroup storage access 2 OK
# #208/p invalid per-cpu cgroup storage access 2 OK
# #209/u invalid per-cpu cgroup storage access 3 OK
# #209/p invalid per-cpu cgroup storage access 3 OK
# #210/u invalid per-cpu cgroup storage access 4 OK
# #210/p invalid per-cpu cgroup storage access 4 OK
# #211/u invalid per-cpu cgroup storage access 5 OK
# #211/p invalid per-cpu cgroup storage access 5 OK
# #212/u invalid per-cpu cgroup storage access 6 OK
# #212/p invalid per-cpu cgroup storage access 6 OK
# #213/p constant register |= constant should keep constant type OK
# #214/p constant register |= constant should not bypass stack boundary checks OK
# #215/p constant register |= constant register should keep constant type OK
# #216/p constant register |= constant register should not bypass stack boundary checks OK
# #217/p context stores via ST OK
# #218/p context stores via XADD OK
# #219/p arithmetic ops make PTR_TO_CTX unusable OK
# #220/p pass unmodified ctx pointer to helper OK
# #221/p pass modified ctx pointer to helper, 1 OK
# #222/u pass modified ctx pointer to helper, 2 OK
# #222/p pass modified ctx pointer to helper, 2 OK
# #223/p pass modified ctx pointer to helper, 3 OK
# #224/p valid access family in SK_MSG OK
# #225/p valid access remote_ip4 in SK_MSG OK
# #226/p valid access local_ip4 in SK_MSG OK
# #227/p valid access remote_port in SK_MSG OK
# #228/p valid access local_port in SK_MSG OK
# #229/p valid access remote_ip6 in SK_MSG OK
# #230/p valid access local_ip6 in SK_MSG OK
# #231/p valid access size in SK_MSG OK
# #232/p invalid 64B read of size in SK_MSG OK
# #233/p invalid read past end of SK_MSG OK
# #234/p invalid read offset in SK_MSG OK
# #235/p direct packet read for SK_MSG OK
# #236/p direct packet write for SK_MSG OK
# #237/p overlapping checks for direct packet access SK_MSG OK
# #238/u access skb fields ok OK
# #238/p access skb fields ok OK
# #239/u access skb fields bad1 OK
# #239/p access skb fields bad1 OK
# #240/u access skb fields bad2 OK
# #240/p access skb fields bad2 OK
# #241/u access skb fields bad3 OK
# #241/p access skb fields bad3 OK
# #242/u access skb fields bad4 OK
# #242/p access skb fields bad4 OK
# #243/u invalid access __sk_buff family OK
# #243/p invalid access __sk_buff family OK
# #244/u invalid access __sk_buff remote_ip4 OK
# #244/p invalid access __sk_buff remote_ip4 OK
# #245/u invalid access __sk_buff local_ip4 OK
# #245/p invalid access __sk_buff local_ip4 OK
# #246/u invalid access __sk_buff remote_ip6 OK
# #246/p invalid access __sk_buff remote_ip6 OK
# #247/u invalid access __sk_buff local_ip6 OK
# #247/p invalid access __sk_buff local_ip6 OK
# #248/u invalid access __sk_buff remote_port OK
# #248/p invalid access __sk_buff remote_port OK
# #249/u invalid access __sk_buff remote_port OK
# #249/p invalid access __sk_buff remote_port OK
# #250/p valid access __sk_buff family OK
# #251/p valid access __sk_buff remote_ip4 OK
# #252/p valid access __sk_buff local_ip4 OK
# #253/p valid access __sk_buff remote_ip6 OK
# #254/p valid access __sk_buff local_ip6 OK
# #255/p valid access __sk_buff remote_port OK
# #256/p valid access __sk_buff remote_port OK
# #257/p invalid access of tc_classid for SK_SKB OK
# #258/p invalid access of skb->mark for SK_SKB OK
# #259/p check skb->mark is not writeable by SK_SKB OK
# #260/p check skb->tc_index is writeable by SK_SKB OK
# #261/p check skb->priority is writeable by SK_SKB OK
# #262/p direct packet read for SK_SKB OK
# #263/p direct packet write for SK_SKB OK
# #264/p overlapping checks for direct packet access SK_SKB OK
# #265/u check skb->mark is not writeable by sockets OK
# #265/p check skb->mark is not writeable by sockets OK
# #266/u check skb->tc_index is not writeable by sockets OK
# #266/p check skb->tc_index is not writeable by sockets OK
# #267/u check cb access: byte OK
# #267/p check cb access: byte OK
# #268/u __sk_buff->hash, offset 0, byte store not permitted OK
# #268/p __sk_buff->hash, offset 0, byte store not permitted OK
# #269/u __sk_buff->tc_index, offset 3, byte store not permitted OK
# #269/p __sk_buff->tc_index, offset 3, byte store not permitted OK
# #270/u check skb->hash byte load permitted OK
# #270/p check skb->hash byte load permitted OK
# #271/u check skb->hash byte load permitted 1 OK
# #271/p check skb->hash byte load permitted 1 OK
# #272/u check skb->hash byte load permitted 2 OK
# #272/p check skb->hash byte load permitted 2 OK
# #273/u check skb->hash byte load permitted 3 OK
# #273/p check skb->hash byte load permitted 3 OK
# #274/p check cb access: byte, wrong type OK
# #275/u check cb access: half OK
# #275/p check cb access: half OK
# #276/u check cb access: half, unaligned OK
# #276/p check cb access: half, unaligned OK
# #277/u check __sk_buff->hash, offset 0, half store not permitted OK
# #277/p check __sk_buff->hash, offset 0, half store not permitted OK
# #278/u check __sk_buff->tc_index, offset 2, half store not permitted OK
# #278/p check __sk_buff->tc_index, offset 2, half store not permitted OK
# #279/u check skb->hash half load permitted OK
# #279/p check skb->hash half load permitted OK
# #280/u check skb->hash half load permitted 2 OK
# #280/p check skb->hash half load permitted 2 OK
# #281/u check skb->hash half load not permitted, unaligned 1 OK
# #281/p check skb->hash half load not permitted, unaligned 1 OK
# #282/u check skb->hash half load not permitted, unaligned 3 OK
# #282/p check skb->hash half load not permitted, unaligned 3 OK
# #283/p check cb access: half, wrong type OK
# #284/u check cb access: word OK
# #284/p check cb access: word OK
# #285/u check cb access: word, unaligned 1 OK
# #285/p check cb access: word, unaligned 1 OK
# #286/u check cb access: word, unaligned 2 OK
# #286/p check cb access: word, unaligned 2 OK
# #287/u check cb access: word, unaligned 3 OK
# #287/p check cb access: word, unaligned 3 OK
# #288/u check cb access: word, unaligned 4 OK
# #288/p check cb access: word, unaligned 4 OK
# #289/u check cb access: double OK
# #289/p check cb access: double OK
# #290/u check cb access: double, unaligned 1 OK
# #290/p check cb access: double, unaligned 1 OK
# #291/u check cb access: double, unaligned 2 OK
# #291/p check cb access: double, unaligned 2 OK
# #292/u check cb access: double, oob 1 OK
# #292/p check cb access: double, oob 1 OK
# #293/u check cb access: double, oob 2 OK
# #293/p check cb access: double, oob 2 OK
# #294/u check __sk_buff->ifindex dw store not permitted OK
# #294/p check __sk_buff->ifindex dw store not permitted OK
# #295/u check __sk_buff->ifindex dw load not permitted OK
# #295/p check __sk_buff->ifindex dw load not permitted OK
# #296/p check cb access: double, wrong type OK
# #297/p check out of range skb->cb access OK
# #298/u write skb fields from socket prog OK
# #298/p write skb fields from socket prog OK
# #299/p write skb fields from tc_cls_act prog OK
# #300/u check skb->data half load not permitted OK
# #300/p check skb->data half load not permitted OK
# #301/u read gso_segs from CGROUP_SKB OK
# #301/p read gso_segs from CGROUP_SKB OK
# #302/u write gso_segs from CGROUP_SKB OK
# #302/p write gso_segs from CGROUP_SKB OK
# #303/p read gso_segs from CLS OK
# #304/u check wire_len is not readable by sockets OK
# #304/p check wire_len is not readable by sockets OK
# #305/p check wire_len is readable by tc classifier OK
# #306/p check wire_len is not writable by tc classifier OK
# #307/u dead code: start OK
# #307/p dead code: start OK
# #308/u dead code: mid 1 OK
# #308/p dead code: mid 1 OK
# #309/u dead code: mid 2 OK
# #309/p dead code: mid 2 OK
# #310/u dead code: end 1 OK
# #310/p dead code: end 1 OK
# #311/u dead code: end 2 OK
# #311/p dead code: end 2 OK
# #312/u dead code: end 3 OK
# #312/p dead code: end 3 OK
# #313/u dead code: tail of main + func OK
# #313/p dead code: tail of main + func OK
# #314/u dead code: tail of main + two functions OK
# #314/p dead code: tail of main + two functions OK
# #315/u dead code: function in the middle and mid of another func OK
# #315/p dead code: function in the middle and mid of another func OK
# #316/u dead code: middle of main before call OK
# #316/p dead code: middle of main before call OK
# #317/u dead code: start of a function OK
# #317/p dead code: start of a function OK
# #318/p pkt_end - pkt_start is allowed OK
# #319/p direct packet access: test1 OK
# #320/p direct packet access: test2 OK
# #321/u direct packet access: test3 OK
# #321/p direct packet access: test3 OK
# #322/p direct packet access: test4 (write) OK
# #323/p direct packet access: test5 (pkt_end >= reg, good access) OK
# #324/p direct packet access: test6 (pkt_end >= reg, bad access) OK
# #325/p direct packet access: test7 (pkt_end >= reg, both accesses) OK
# #326/p direct packet access: test8 (double test, variant 1) OK
# #327/p direct packet access: test9 (double test, variant 2) OK
# #328/p direct packet access: test10 (write invalid) OK
# #329/p direct packet access: test11 (shift, good access) OK
# #330/p direct packet access: test12 (and, good access) OK
# #331/p direct packet access: test13 (branches, good access) OK
# #332/p direct packet access: test14 (pkt_ptr += 0, CONST_IMM, good access) OK
# #333/p direct packet access: test15 (spill with xadd) OK
# #334/p direct packet access: test16 (arith on data_end) OK
# #335/p direct packet access: test17 (pruning, alignment) OK
# #336/p direct packet access: test18 (imm += pkt_ptr, 1) OK
# #337/p direct packet access: test19 (imm += pkt_ptr, 2) OK
# #338/p direct packet access: test20 (x += pkt_ptr, 1) OK
# #339/p direct packet access: test21 (x += pkt_ptr, 2) OK
# #340/p direct packet access: test22 (x += pkt_ptr, 3) OK
# #341/p direct packet access: test23 (x += pkt_ptr, 4) OK
# #342/p direct packet access: test24 (x += pkt_ptr, 5) OK
# #343/p direct packet access: test25 (marking on <, good access) OK
# #344/p direct packet access: test26 (marking on <, bad access) OK
# #345/p direct packet access: test27 (marking on <=, good access) OK
# #346/p direct packet access: test28 (marking on <=, bad access) OK
# #347/p direct packet access: test29 (reg > pkt_end in subprog) OK
# #348/u direct stack access with 32-bit wraparound. test1 OK
# #348/p direct stack access with 32-bit wraparound. test1 OK
# #349/u direct stack access with 32-bit wraparound. test2 OK
# #349/p direct stack access with 32-bit wraparound. test2 OK
# #350/u direct stack access with 32-bit wraparound. test3 OK
# #350/p direct stack access with 32-bit wraparound. test3 OK
# #351/u direct map access, write test 1 OK
# #351/p direct map access, write test 1 OK
# #352/u direct map access, write test 2 OK
# #352/p direct map access, write test 2 OK
# #353/u direct map access, write test 3 OK
# #353/p direct map access, write test 3 OK
# #354/u direct map access, write test 4 OK
# #354/p direct map access, write test 4 OK
# #355/u direct map access, write test 5 OK
# #355/p direct map access, write test 5 OK
# #356/u direct map access, write test 6 OK
# #356/p direct map access, write test 6 OK
# #357/u direct map access, write test 7 OK
# #357/p direct map access, write test 7 OK
# #358/u direct map access, write test 8 OK
# #358/p direct map access, write test 8 OK
# #359/u direct map access, write test 9 OK
# #359/p direct map access, write test 9 OK
# #360/u direct map access, write test 10 OK
# #360/p direct map access, write test 10 OK
# #361/u direct map access, write test 11 OK
# #361/p direct map access, write test 11 OK
# #362/u direct map access, write test 12 OK
# #362/p direct map access, write test 12 OK
# #363/u direct map access, write test 13 OK
# #363/p direct map access, write test 13 OK
# #364/u direct map access, write test 14 OK
# #364/p direct map access, write test 14 OK
# #365/u direct map access, write test 15 OK
# #365/p direct map access, write test 15 OK
# #366/u direct map access, write test 16 OK
# #366/p direct map access, write test 16 OK
# #367/u direct map access, write test 17 OK
# #367/p direct map access, write test 17 OK
# #368/u direct map access, write test 18 OK
# #368/p direct map access, write test 18 OK
# #369/u direct map access, write test 19 OK
# #369/p direct map access, write test 19 OK
# #370/u direct map access, write test 20 OK
# #370/p direct map access, write test 20 OK
# #371/u direct map access, invalid insn test 1 OK
# #371/p direct map access, invalid insn test 1 OK
# #372/u direct map access, invalid insn test 2 OK
# #372/p direct map access, invalid insn test 2 OK
# #373/u direct map access, invalid insn test 3 OK
# #373/p direct map access, invalid insn test 3 OK
# #374/u direct map access, invalid insn test 4 OK
# #374/p direct map access, invalid insn test 4 OK
# #375/u direct map access, invalid insn test 5 OK
# #375/p direct map access, invalid insn test 5 OK
# #376/u direct map access, invalid insn test 6 OK
# #376/p direct map access, invalid insn test 6 OK
# #377/u direct map access, invalid insn test 7 OK
# #377/p direct map access, invalid insn test 7 OK
# #378/u direct map access, invalid insn test 8 OK
# #378/p direct map access, invalid insn test 8 OK
# #379/u direct map access, invalid insn test 9 OK
# #379/p direct map access, invalid insn test 9 OK
# #380/u DIV32 by 0, zero check 1 OK
# #380/p DIV32 by 0, zero check 1 OK
# #381/u DIV32 by 0, zero check 2 OK
# #381/p DIV32 by 0, zero check 2 OK
# #382/u DIV64 by 0, zero check OK
# #382/p DIV64 by 0, zero check OK
# #383/u MOD32 by 0, zero check 1 OK
# #383/p MOD32 by 0, zero check 1 OK
# #384/u MOD32 by 0, zero check 2 OK
# #384/p MOD32 by 0, zero check 2 OK
# #385/u MOD64 by 0, zero check OK
# #385/p MOD64 by 0, zero check OK
# #386/p DIV32 by 0, zero check ok, cls OK
# #387/p DIV32 by 0, zero check 1, cls OK
# #388/p DIV32 by 0, zero check 2, cls OK
# #389/p DIV64 by 0, zero check, cls OK
# #390/p MOD32 by 0, zero check ok, cls OK
# #391/p MOD32 by 0, zero check 1, cls OK
# #392/p MOD32 by 0, zero check 2, cls OK
# #393/p MOD64 by 0, zero check 1, cls OK
# #394/p MOD64 by 0, zero check 2, cls OK
# #395/p DIV32 overflow, check 1 OK
# #396/p DIV32 overflow, check 2 OK
# #397/p DIV64 overflow, check 1 OK
# #398/p DIV64 overflow, check 2 OK
# #399/p MOD32 overflow, check 1 OK
# #400/p MOD32 overflow, check 2 OK
# #401/p MOD64 overflow, check 1 OK
# #402/p MOD64 overflow, check 2 OK
# #403/p helper access to variable memory: stack, bitwise AND + JMP, correct bounds OK
# #404/p helper access to variable memory: stack, bitwise AND, zero included OK
# #405/p helper access to variable memory: stack, bitwise AND + JMP, wrong max OK
# #406/p helper access to variable memory: stack, JMP, correct bounds OK
# #407/p helper access to variable memory: stack, JMP (signed), correct bounds OK
# #408/p helper access to variable memory: stack, JMP, bounds + offset OK
# #409/p helper access to variable memory: stack, JMP, wrong max OK
# #410/p helper access to variable memory: stack, JMP, no max check OK
# #411/p helper access to variable memory: stack, JMP, no min check OK
# #412/p helper access to variable memory: stack, JMP (signed), no min check OK
# #413/p helper access to variable memory: map, JMP, correct bounds OK
# #414/p helper access to variable memory: map, JMP, wrong max OK
# #415/p helper access to variable memory: map adjusted, JMP, correct bounds OK
# #416/p helper access to variable memory: map adjusted, JMP, wrong max OK
# #417/p helper access to variable memory: size = 0 allowed on NULL (ARG_PTR_TO_MEM_OR_NULL) OK
# #418/p helper access to variable memory: size > 0 not allowed on NULL (ARG_PTR_TO_MEM_OR_NULL) OK
# #419/p helper access to variable memory: size = 0 allowed on != NULL stack pointer (ARG_PTR_TO_MEM_OR_NULL) OK
# #420/p helper access to variable memory: size = 0 allowed on != NULL map pointer (ARG_PTR_TO_MEM_OR_NULL) OK
# #421/p helper access to variable memory: size possible = 0 allowed on != NULL stack pointer (ARG_PTR_TO_MEM_OR_NULL) OK
# #422/p helper access to variable memory: size possible = 0 allowed on != NULL map pointer (ARG_PTR_TO_MEM_OR_NULL) OK
# #423/p helper access to variable memory: size possible = 0 allowed on != NULL packet pointer (ARG_PTR_TO_MEM_OR_NULL) OK
# #424/p helper access to variable memory: size = 0 not allowed on NULL (!ARG_PTR_TO_MEM_OR_NULL) OK
# #425/p helper access to variable memory: size > 0 not allowed on NULL (!ARG_PTR_TO_MEM_OR_NULL) OK
# #426/p helper access to variable memory: size = 0 allowed on != NULL stack pointer (!ARG_PTR_TO_MEM_OR_NULL) OK
# #427/p helper access to variable memory: size = 0 allowed on != NULL map pointer (!ARG_PTR_TO_MEM_OR_NULL) OK
# #428/p helper access to variable memory: size possible = 0 allowed on != NULL stack pointer (!ARG_PTR_TO_MEM_OR_NULL) OK
# #429/p helper access to variable memory: size possible = 0 allowed on != NULL map pointer (!ARG_PTR_TO_MEM_OR_NULL) OK
# #430/p helper access to variable memory: 8 bytes leak OK
# #431/p helper access to variable memory: 8 bytes no leak (init memory) OK
# #432/p helper access to packet: test1, valid packet_ptr range OK
# #433/p helper access to packet: test2, unchecked packet_ptr OK
# #434/p helper access to packet: test3, variable add OK
# #435/p helper access to packet: test4, packet_ptr with bad range OK
# #436/p helper access to packet: test5, packet_ptr with too short range OK
# #437/p helper access to packet: test6, cls valid packet_ptr range OK
# #438/p helper access to packet: test7, cls unchecked packet_ptr OK
# #439/p helper access to packet: test8, cls variable add OK
# #440/p helper access to packet: test9, cls packet_ptr with bad range OK
# #441/p helper access to packet: test10, cls packet_ptr with too short range OK
# #442/p helper access to packet: test11, cls unsuitable helper 1 OK
# #443/p helper access to packet: test12, cls unsuitable helper 2 OK
# #444/p helper access to packet: test13, cls helper ok OK
# #445/p helper access to packet: test14, cls helper ok sub OK
# #446/p helper access to packet: test15, cls helper fail sub OK
# #447/p helper access to packet: test16, cls helper fail range 1 OK
# #448/p helper access to packet: test17, cls helper fail range 2 OK
# #449/p helper access to packet: test18, cls helper fail range 3 OK
# #450/p helper access to packet: test19, cls helper range zero OK
# #451/p helper access to packet: test20, pkt end as input OK
# #452/p helper access to packet: test21, wrong reg OK
# #453/p helper access to map: full range OK
# #454/p helper access to map: partial range OK
# #455/p helper access to map: empty range OK
# #456/p helper access to map: out-of-bound range OK
# #457/p helper access to map: negative range OK
# #458/p helper access to adjusted map (via const imm): full range OK
# #459/p helper access to adjusted map (via const imm): partial range OK
# #460/p helper access to adjusted map (via const imm): empty range OK
# #461/p helper access to adjusted map (via const imm): out-of-bound range OK
# #462/p helper access to adjusted map (via const imm): negative range (> adjustment) OK
# #463/p helper access to adjusted map (via const imm): negative range (< adjustment) OK
# #464/p helper access to adjusted map (via const reg): full range OK
# #465/p helper access to adjusted map (via const reg): partial range OK
# #466/p helper access to adjusted map (via const reg): empty range OK
# #467/p helper access to adjusted map (via const reg): out-of-bound range OK
# #468/p helper access to adjusted map (via const reg): negative range (> adjustment) OK
# #469/p helper access to adjusted map (via const reg): negative range (< adjustment) OK
# #470/p helper access to adjusted map (via variable): full range OK
# #471/p helper access to adjusted map (via variable): partial range OK
# #472/p helper access to adjusted map (via variable): empty range OK
# #473/p helper access to adjusted map (via variable): no max check OK
# #474/p helper access to adjusted map (via variable): wrong max check OK
# #475/p helper access to map: bounds check using <, good access OK
# #476/p helper access to map: bounds check using <, bad access OK
# #477/p helper access to map: bounds check using <=, good access OK
# #478/p helper access to map: bounds check using <=, bad access OK
# #479/p helper access to map: bounds check using s<, good access OK
# #480/p helper access to map: bounds check using s<, good access 2 OK
# #481/p helper access to map: bounds check using s<, bad access OK
# #482/p helper access to map: bounds check using s<=, good access OK
# #483/p helper access to map: bounds check using s<=, good access 2 OK
# #484/p helper access to map: bounds check using s<=, bad access OK
# #485/p map lookup helper access to map OK
# #486/p map update helper access to map OK
# #487/p map update helper access to map: wrong size OK
# #488/p map helper access to adjusted map (via const imm) OK
# #489/p map helper access to adjusted map (via const imm): out-of-bound 1 OK
# #490/p map helper access to adjusted map (via const imm): out-of-bound 2 OK
# #491/p map helper access to adjusted map (via const reg) OK
# #492/p map helper access to adjusted map (via const reg): out-of-bound 1 OK
# #493/p map helper access to adjusted map (via const reg): out-of-bound 2 OK
# #494/p map helper access to adjusted map (via variable) OK
# #495/p map helper access to adjusted map (via variable): no max check OK
# #496/p map helper access to adjusted map (via variable): wrong max check OK
# #497/p ARG_PTR_TO_LONG uninitialized OK
# #498/p ARG_PTR_TO_LONG half-uninitialized OK
# #499/p ARG_PTR_TO_LONG misaligned OK
# #500/p ARG_PTR_TO_LONG size < sizeof(long) OK
# #501/p ARG_PTR_TO_LONG initialized OK
# #502/u jit: lsh, rsh, arsh by 1 OK
# #502/p jit: lsh, rsh, arsh by 1 OK
# #503/u jit: mov32 for ldimm64, 1 OK
# #503/p jit: mov32 for ldimm64, 1 OK
# #504/u jit: mov32 for ldimm64, 2 OK
# #504/p jit: mov32 for ldimm64, 2 OK
# #505/u jit: various mul tests OK
# #505/p jit: various mul tests OK
# #506/u jit: jsgt, jslt OK
# #506/p jit: jsgt, jslt OK
# #507/p jset32: BPF_K 3 cases OK
# #508/p jset32: BPF_X 3 cases OK
# #509/u jset32: min/max deduction OK
# #509/p jset32: min/max deduction OK
# #510/p jeq32: BPF_K 2 cases OK
# #511/p jeq32: BPF_X 3 cases OK
# #512/u jeq32: min/max deduction OK
# #512/p jeq32: min/max deduction OK
# #513/p jne32: BPF_K 2 cases OK
# #514/p jne32: BPF_X 3 cases OK
# #515/u jne32: min/max deduction OK
# #515/p jne32: min/max deduction OK
# #516/p jge32: BPF_K 3 cases OK
# #517/p jge32: BPF_X 3 cases OK
# #518/u jge32: min/max deduction OK
# #518/p jge32: min/max deduction OK
# #519/p jgt32: BPF_K 3 cases OK
# #520/p jgt32: BPF_X 3 cases OK
# #521/u jgt32: min/max deduction OK
# #521/p jgt32: min/max deduction OK
# #522/p jle32: BPF_K 3 cases OK
# #523/p jle32: BPF_X 3 cases OK
# #524/u jle32: min/max deduction OK
# #524/p jle32: min/max deduction OK
# #525/p jlt32: BPF_K 3 cases OK
# #526/p jlt32: BPF_X 3 cases OK
# #527/u jlt32: min/max deduction OK
# #527/p jlt32: min/max deduction OK
# #528/p jsge32: BPF_K 3 cases OK
# #529/p jsge32: BPF_X 3 cases OK
# #530/u jsge32: min/max deduction OK
# #530/p jsge32: min/max deduction OK
# #531/p jsgt32: BPF_K 3 cases OK
# #532/p jsgt32: BPF_X 3 cases OK
# #533/u jsgt32: min/max deduction OK
# #533/p jsgt32: min/max deduction OK
# #534/p jsle32: BPF_K 3 cases OK
# #535/p jsle32: BPF_X 3 cases OK
# #536/u jsle32: min/max deduction OK
# #536/p jsle32: min/max deduction OK
# #537/p jslt32: BPF_K 3 cases OK
# #538/p jslt32: BPF_X 3 cases OK
# #539/u jslt32: min/max deduction OK
# #539/p jslt32: min/max deduction OK
# #540/p jset: functional 7 cases OK
# #541/p jset: sign-extend OK
# #542/u jset: known const compare OK
# #542/p jset: known const compare OK
# #543/u jset: known const compare bad OK
# #543/p jset: known const compare bad OK
# #544/u jset: unknown const compare taken OK
# #544/p jset: unknown const compare taken OK
# #545/u jset: unknown const compare not taken OK
# #545/p jset: unknown const compare not taken OK
# #546/u jset: half-known const compare OK
# #546/p jset: half-known const compare OK
# #547/u jset: range OK
# #547/p jset: range OK
# #548/u jump test 1 OK
# #548/p jump test 1 OK
# #549/u jump test 2 OK
# #549/p jump test 2 OK
# #550/u jump test 3 OK
# #550/p jump test 3 OK
# #551/u jump test 4 OK
# #551/p jump test 4 OK
# #552/u jump test 5 OK
# #552/p jump test 5 OK
# #553/u jump test 6 OK
# #553/p jump test 6 OK
# #554/u jump test 7 OK
# #554/p jump test 7 OK
# #555/u jump test 8 OK
# #555/p jump test 8 OK
# #556/p jump/call test 9 OK
# #557/p jump/call test 10 OK
# #558/p jump/call test 11 OK
# #559/u junk insn OK
# #559/p junk insn OK
# #560/u junk insn2 OK
# #560/p junk insn2 OK
# #561/u junk insn3 OK
# #561/p junk insn3 OK
# #562/u junk insn4 OK
# #562/p junk insn4 OK
# #563/u junk insn5 OK
# #563/p junk insn5 OK
# #564/u ld_abs: check calling conv, r1 OK
# #564/p ld_abs: check calling conv, r1 OK
# #565/u ld_abs: check calling conv, r2 OK
# #565/p ld_abs: check calling conv, r2 OK
# #566/u ld_abs: check calling conv, r3 OK
# #566/p ld_abs: check calling conv, r3 OK
# #567/u ld_abs: check calling conv, r4 OK
# #567/p ld_abs: check calling conv, r4 OK
# #568/u ld_abs: check calling conv, r5 OK
# #568/p ld_abs: check calling conv, r5 OK
# #569/u ld_abs: check calling conv, r7 OK
# #569/p ld_abs: check calling conv, r7 OK
# #570/p ld_abs: tests on r6 and skb data reload helper OK
# #571/p ld_abs: invalid op 1 OK
# #572/p ld_abs: invalid op 2 OK
# #573/p ld_abs: nmap reduced OK
# #574/p ld_abs: div + abs, test 1 OK
# #575/p ld_abs: div + abs, test 2 OK
# #576/p ld_abs: div + abs, test 3 OK
# #577/p ld_abs: div + abs, test 4 OK
# #578/p ld_abs: vlan + abs, test 1 OK
# #579/p ld_abs: vlan + abs, test 2 OK
# #580/p ld_abs: jump around ld_abs OK
# #581/p ld_dw: xor semi-random 64 bit imms, test 1 OK
# #582/p ld_dw: xor semi-random 64 bit imms, test 2 OK
# #583/p ld_dw: xor semi-random 64 bit imms, test 3 OK
# #584/p ld_dw: xor semi-random 64 bit imms, test 4 OK
# #585/p ld_dw: xor semi-random 64 bit imms, test 5 OK
# #586/u test1 ld_imm64 OK
# #586/p test1 ld_imm64 OK
# #587/u test2 ld_imm64 OK
# #587/p test2 ld_imm64 OK
# #588/u test3 ld_imm64 OK
# #588/p test3 ld_imm64 OK
# #589/u test4 ld_imm64 OK
# #589/p test4 ld_imm64 OK
# #590/u test5 ld_imm64 OK
# #590/p test5 ld_imm64 OK
# #591/u test6 ld_imm64 OK
# #591/p test6 ld_imm64 OK
# #592/u test7 ld_imm64 OK
# #592/p test7 ld_imm64 OK
# #593/u test8 ld_imm64 OK
# #593/p test8 ld_imm64 OK
# #594/u test9 ld_imm64 OK
# #594/p test9 ld_imm64 OK
# #595/u test10 ld_imm64 OK
# #595/p test10 ld_imm64 OK
# #596/u test11 ld_imm64 OK
# #596/p test11 ld_imm64 OK
# #597/u test12 ld_imm64 OK
# #597/p test12 ld_imm64 OK
# #598/u test13 ld_imm64 OK
# #598/p test13 ld_imm64 OK
# #599/u test14 ld_imm64: reject 2nd imm != 0 OK
# #599/p test14 ld_imm64: reject 2nd imm != 0 OK
# #600/u ld_ind: check calling conv, r1 OK
# #600/p ld_ind: check calling conv, r1 OK
# #601/u ld_ind: check calling conv, r2 OK
# #601/p ld_ind: check calling conv, r2 OK
# #602/u ld_ind: check calling conv, r3 OK
# #602/p ld_ind: check calling conv, r3 OK
# #603/u ld_ind: check calling conv, r4 OK
# #603/p ld_ind: check calling conv, r4 OK
# #604/u ld_ind: check calling conv, r5 OK
# #604/p ld_ind: check calling conv, r5 OK
# #605/u ld_ind: check calling conv, r7 OK
# #605/p ld_ind: check calling conv, r7 OK
# #606/u leak pointer into ctx 1 OK
# #606/p leak pointer into ctx 1 OK
# #607/u leak pointer into ctx 2 OK
# #607/p leak pointer into ctx 2 OK
# #608/u leak pointer into ctx 3 OK
# #608/p leak pointer into ctx 3 OK
# #609/u leak pointer into map val OK
# #609/p leak pointer into map val OK
# #610/p invalid direct packet write for LWT_IN OK
# #611/p invalid direct packet write for LWT_OUT OK
# #612/p direct packet write for LWT_XMIT OK
# #613/p direct packet read for LWT_IN OK
# #614/p direct packet read for LWT_OUT OK
# #615/p direct packet read for LWT_XMIT OK
# #616/p overlapping checks for direct packet access OK
# #617/p make headroom for LWT_XMIT OK
# #618/u invalid access of tc_classid for LWT_IN OK
# #618/p invalid access of tc_classid for LWT_IN OK
# #619/u invalid access of tc_classid for LWT_OUT OK
# #619/p invalid access of tc_classid for LWT_OUT OK
# #620/u invalid access of tc_classid for LWT_XMIT OK
# #620/p invalid access of tc_classid for LWT_XMIT OK
# #621/p check skb->tc_classid half load not permitted for lwt prog OK
# #622/u map in map access OK
# #622/p map in map access OK
# #623/u invalid inner map pointer OK
# #623/p invalid inner map pointer OK
# #624/u forgot null checking on the inner map pointer OK
# #624/p forgot null checking on the inner map pointer OK
# #625/p calls: two calls returning different map pointers for lookup (hash, array) OK
# #626/p calls: two calls returning different map pointers for lookup (hash, map in map) OK
# #627/u cond: two branches returning different map pointers for lookup (tail, tail) OK
# #627/p cond: two branches returning different map pointers for lookup (tail, tail) OK
# #628/u cond: two branches returning same map pointers for lookup (tail, tail) OK
# #628/p cond: two branches returning same map pointers for lookup (tail, tail) OK
# #629/u invalid map_fd for function call OK
# #629/p invalid map_fd for function call OK
# #630/u don't check return value before access OK
# #630/p don't check return value before access OK
# #631/u access memory with incorrect alignment OK
# #631/p access memory with incorrect alignment OK
# #632/u sometimes access memory with incorrect alignment OK
# #632/p sometimes access memory with incorrect alignment OK
# #633/u masking, test out of bounds 1 OK
# #633/p masking, test out of bounds 1 OK
# #634/u masking, test out of bounds 2 OK
# #634/p masking, test out of bounds 2 OK
# #635/u masking, test out of bounds 3 OK
# #635/p masking, test out of bounds 3 OK
# #636/u masking, test out of bounds 4 OK
# #636/p masking, test out of bounds 4 OK
# #637/u masking, test out of bounds 5 OK
# #637/p masking, test out of bounds 5 OK
# #638/u masking, test out of bounds 6 OK
# #638/p masking, test out of bounds 6 OK
# #639/u masking, test out of bounds 7 OK
# #639/p masking, test out of bounds 7 OK
# #640/u masking, test out of bounds 8 OK
# #640/p masking, test out of bounds 8 OK
# #641/u masking, test out of bounds 9 OK
# #641/p masking, test out of bounds 9 OK
# #642/u masking, test out of bounds 10 OK
# #642/p masking, test out of bounds 10 OK
# #643/u masking, test out of bounds 11 OK
# #643/p masking, test out of bounds 11 OK
# #644/u masking, test out of bounds 12 OK
# #644/p masking, test out of bounds 12 OK
# #645/u masking, test in bounds 1 OK
# #645/p masking, test in bounds 1 OK
# #646/u masking, test in bounds 2 OK
# #646/p masking, test in bounds 2 OK
# #647/u masking, test in bounds 3 OK
# #647/p masking, test in bounds 3 OK
# #648/u masking, test in bounds 4 OK
# #648/p masking, test in bounds 4 OK
# #649/u masking, test in bounds 5 OK
# #649/p masking, test in bounds 5 OK
# #650/u masking, test in bounds 6 OK
# #650/p masking, test in bounds 6 OK
# #651/u masking, test in bounds 7 OK
# #651/p masking, test in bounds 7 OK
# #652/u masking, test in bounds 8 OK
# #652/p masking, test in bounds 8 OK
# #653/p meta access, test1 OK
# #654/p meta access, test2 OK
# #655/p meta access, test3 OK
# #656/p meta access, test4 OK
# #657/p meta access, test5 OK
# #658/p meta access, test6 OK
# #659/p meta access, test7 OK
# #660/p meta access, test8 OK
# #661/p meta access, test9 OK
# #662/p meta access, test10 OK
# #663/p meta access, test11 OK
# #664/p meta access, test12 OK
# #665/p check bpf_perf_event_data->sample_period byte load permitted OK
# #666/p check bpf_perf_event_data->sample_period half load permitted OK
# #667/p check bpf_perf_event_data->sample_period word load permitted OK
# #668/p check bpf_perf_event_data->sample_period dword load permitted OK
# #669/p prevent map lookup in sockmap OK
# #670/p prevent map lookup in sockhash OK
# #671/p prevent map lookup in stack trace OK
# #672/u prevent map lookup in prog array OK
# #672/p prevent map lookup in prog array OK
# #673/p raw_stack: no skb_load_bytes OK
# #674/p raw_stack: skb_load_bytes, negative len OK
# #675/p raw_stack: skb_load_bytes, negative len 2 OK
# #676/p raw_stack: skb_load_bytes, zero len OK
# #677/p raw_stack: skb_load_bytes, no init OK
# #678/p raw_stack: skb_load_bytes, init OK
# #679/p raw_stack: skb_load_bytes, spilled regs around bounds OK
# #680/p raw_stack: skb_load_bytes, spilled regs corruption OK
# #681/p raw_stack: skb_load_bytes, spilled regs corruption 2 OK
# #682/p raw_stack: skb_load_bytes, spilled regs + data OK
# #683/p raw_stack: skb_load_bytes, invalid access 1 OK
# #684/p raw_stack: skb_load_bytes, invalid access 2 OK
# #685/p raw_stack: skb_load_bytes, invalid access 3 OK
# #686/p raw_stack: skb_load_bytes, invalid access 4 OK
# #687/p raw_stack: skb_load_bytes, invalid access 5 OK
# #688/p raw_stack: skb_load_bytes, invalid access 6 OK
# #689/p raw_stack: skb_load_bytes, large access OK
# #690/p raw_tracepoint_writable: reject variable offset OK
# #691/p reference tracking: leak potential reference OK
# #692/p reference tracking: leak potential reference to sock_common OK
# #693/p reference tracking: leak potential reference on stack OK
# #694/p reference tracking: leak potential reference on stack 2 OK
# #695/p reference tracking: zero potential reference OK
# #696/p reference tracking: zero potential reference to sock_common OK
# #697/p reference tracking: copy and zero potential references OK
# #698/p reference tracking: release reference without check OK
# #699/p reference tracking: release reference to sock_common without check OK
# #700/p reference tracking: release reference OK
# #701/p reference tracking: release reference to sock_common OK
# #702/p reference tracking: release reference 2 OK
# #703/p reference tracking: release reference twice OK
# #704/p reference tracking: release reference twice inside branch OK
# #705/p reference tracking: alloc, check, free in one subbranch OK
# #706/p reference tracking: alloc, check, free in both subbranches OK
# #707/p reference tracking in call: free reference in subprog OK
# #708/p reference tracking in call: free reference in subprog and outside OK
# #709/p reference tracking in call: alloc & leak reference in subprog OK
# #710/p reference tracking in call: alloc in subprog, release outside OK
# #711/p reference tracking in call: sk_ptr leak into caller stack OK
# #712/p reference tracking in call: sk_ptr spill into caller stack OK
# #713/p reference tracking: allow LD_ABS OK
# #714/p reference tracking: forbid LD_ABS while holding reference OK
# #715/p reference tracking: allow LD_IND OK
# #716/p reference tracking: forbid LD_IND while holding reference OK
# #717/p reference tracking: check reference or tail call OK
# #718/p reference tracking: release reference then tail call OK
# #719/p reference tracking: leak possible reference over tail call OK
# #720/p reference tracking: leak checked reference over tail call OK
# #721/p reference tracking: mangle and release sock_or_null OK
# #722/p reference tracking: mangle and release sock OK
# #723/p reference tracking: access member OK
# #724/p reference tracking: write to member OK
# #725/p reference tracking: invalid 64-bit access of member OK
# #726/p reference tracking: access after release OK
# #727/p reference tracking: direct access for lookup OK
# #728/p reference tracking: use ptr from bpf_tcp_sock() after release OK
# #729/p reference tracking: use ptr from bpf_sk_fullsock() after release OK
# #730/p reference tracking: use ptr from bpf_sk_fullsock(tp) after release OK
# #731/p reference tracking: use sk after bpf_sk_release(tp) OK
# #732/p reference tracking: use ptr from bpf_get_listener_sock() after bpf_sk_release(sk) OK
# #733/p reference tracking: bpf_sk_release(listen_sk) OK
# #734/p reference tracking: tp->snd_cwnd after bpf_sk_fullsock(sk) and bpf_tcp_sock(sk) OK
# #735/u runtime/jit: tail_call within bounds, prog once OK
# #735/p runtime/jit: tail_call within bounds, prog once OK
# #736/u runtime/jit: tail_call within bounds, prog loop OK
# #736/p runtime/jit: tail_call within bounds, prog loop OK
# #737/u runtime/jit: tail_call within bounds, no prog OK
# #737/p runtime/jit: tail_call within bounds, no prog OK
# #738/u runtime/jit: tail_call out of bounds OK
# #738/p runtime/jit: tail_call out of bounds OK
# #739/u runtime/jit: pass negative index to tail_call OK
# #739/p runtime/jit: pass negative index to tail_call OK
# #740/u runtime/jit: pass > 32bit index to tail_call OK
# #740/p runtime/jit: pass > 32bit index to tail_call OK
# #741/p scale: scale test 1 FAIL
# Failed to load prog 'Success'!
# BPF program is too large. Processed 1000001 insn
# verification time 553348 usec
# stack depth 512
# processed 1000001 insns (limit 1000000) max_states_per_insn 0 total_states 4876 peak_states 4876 mark_read 1
# #742/p scale: scale test 2 FAIL
# Failed to load prog 'Success'!
# BPF program is too large. Processed 1000001 insn
# verification time 665424 usec
# stack depth 0+0+0+0+0+0+0+288
# processed 1000001 insns (limit 1000000) max_states_per_insn 1 total_states 4878 peak_states 4878 mark_read 1
# #743/u pointer/scalar confusion in state equality check (way 1) OK
# #743/p pointer/scalar confusion in state equality check (way 1) OK
# #744/u pointer/scalar confusion in state equality check (way 2) OK
# #744/p pointer/scalar confusion in state equality check (way 2) OK
# #745/p liveness pruning and write screening OK
# #746/u varlen_map_value_access pruning OK
# #746/p varlen_map_value_access pruning OK
# #747/p search pruning: all branches should be verified (nop operation) OK
# #748/p search pruning: all branches should be verified (invalid stack access) OK
# #749/u allocated_stack OK
# #749/p allocated_stack OK
# #750/u skb->sk: no NULL check OK
# #750/p skb->sk: no NULL check OK
# #751/u skb->sk: sk->family [non fullsock field] OK
# #751/p skb->sk: sk->family [non fullsock field] OK
# #752/u skb->sk: sk->type [fullsock field] OK
# #752/p skb->sk: sk->type [fullsock field] OK
# #753/u bpf_sk_fullsock(skb->sk): no !skb->sk check OK
# #753/p bpf_sk_fullsock(skb->sk): no !skb->sk check OK
# #754/u sk_fullsock(skb->sk): no NULL check on ret OK
# #754/p sk_fullsock(skb->sk): no NULL check on ret OK
# #755/u sk_fullsock(skb->sk): sk->type [fullsock field] OK
# #755/p sk_fullsock(skb->sk): sk->type [fullsock field] OK
# #756/u sk_fullsock(skb->sk): sk->family [non fullsock field] OK
# #756/p sk_fullsock(skb->sk): sk->family [non fullsock field] OK
# #757/u sk_fullsock(skb->sk): sk->state [narrow load] OK
# #757/p sk_fullsock(skb->sk): sk->state [narrow load] OK
# #758/u sk_fullsock(skb->sk): sk->dst_port [narrow load] OK
# #758/p sk_fullsock(skb->sk): sk->dst_port [narrow load] OK
# #759/u sk_fullsock(skb->sk): sk->dst_port [load 2nd byte] OK
# #759/p sk_fullsock(skb->sk): sk->dst_port [load 2nd byte] OK
# #760/u sk_fullsock(skb->sk): sk->dst_ip6 [load 2nd byte] OK
# #760/p sk_fullsock(skb->sk): sk->dst_ip6 [load 2nd byte] OK
# #761/u sk_fullsock(skb->sk): sk->type [narrow load] OK
# #761/p sk_fullsock(skb->sk): sk->type [narrow load] OK
# #762/u sk_fullsock(skb->sk): sk->protocol [narrow load] OK
# #762/p sk_fullsock(skb->sk): sk->protocol [narrow load] OK
# #763/u sk_fullsock(skb->sk): beyond last field OK
# #763/p sk_fullsock(skb->sk): beyond last field OK
# #764/u bpf_tcp_sock(skb->sk): no !skb->sk check OK
# #764/p bpf_tcp_sock(skb->sk): no !skb->sk check OK
# #765/u bpf_tcp_sock(skb->sk): no NULL check on ret OK
# #765/p bpf_tcp_sock(skb->sk): no NULL check on ret OK
# #766/u bpf_tcp_sock(skb->sk): tp->snd_cwnd OK
# #766/p bpf_tcp_sock(skb->sk): tp->snd_cwnd OK
# #767/u bpf_tcp_sock(skb->sk): tp->bytes_acked OK
# #767/p bpf_tcp_sock(skb->sk): tp->bytes_acked OK
# #768/u bpf_tcp_sock(skb->sk): beyond last field OK
# #768/p bpf_tcp_sock(skb->sk): beyond last field OK
# #769/u bpf_tcp_sock(bpf_sk_fullsock(skb->sk)): tp->snd_cwnd OK
# #769/p bpf_tcp_sock(bpf_sk_fullsock(skb->sk)): tp->snd_cwnd OK
# #770/p bpf_sk_release(skb->sk) OK
# #771/p bpf_sk_release(bpf_sk_fullsock(skb->sk)) OK
# #772/p bpf_sk_release(bpf_tcp_sock(skb->sk)) OK
# #773/p sk_storage_get(map, skb->sk, NULL, 0): value == NULL OK
# #774/p sk_storage_get(map, skb->sk, 1, 1): value == 1 OK
# #775/p sk_storage_get(map, skb->sk, &stack_value, 1): stack_value OK
# #776/p sk_storage_get(map, skb->sk, &stack_value, 1): partially init stack_value OK
# #777/p bpf_map_lookup_elem(smap, &key) OK
# #778/p bpf_map_lookup_elem(xskmap, &key); xs->queue_id SKIP (unsupported map type 17)
# #779/u check valid spill/fill OK
# #779/p check valid spill/fill OK
# #780/u check valid spill/fill, skb mark OK
# #780/p check valid spill/fill, skb mark OK
# #781/u check corrupted spill/fill OK
# #781/p check corrupted spill/fill OK
# #782/u check corrupted spill/fill, LSB OK
# #782/p check corrupted spill/fill, LSB OK
# #783/u check corrupted spill/fill, MSB OK
# #783/p check corrupted spill/fill, MSB OK
# #784/u spin_lock: test1 success OK
# #784/p spin_lock: test1 success OK
# #785/u spin_lock: test2 direct ld/st OK
# #785/p spin_lock: test2 direct ld/st OK
# #786/u spin_lock: test3 direct ld/st OK
# #786/p spin_lock: test3 direct ld/st OK
# #787/u spin_lock: test4 direct ld/st OK
# #787/p spin_lock: test4 direct ld/st OK
# #788/u spin_lock: test5 call within a locked region OK
# #788/p spin_lock: test5 call within a locked region OK
# #789/u spin_lock: test6 missing unlock OK
# #789/p spin_lock: test6 missing unlock OK
# #790/u spin_lock: test7 unlock without lock OK
# #790/p spin_lock: test7 unlock without lock OK
# #791/u spin_lock: test8 double lock OK
# #791/p spin_lock: test8 double lock OK
# #792/u spin_lock: test9 different lock OK
# #792/p spin_lock: test9 different lock OK
# #793/u spin_lock: test10 lock in subprog without unlock OK
# #793/p spin_lock: test10 lock in subprog without unlock OK
# #794/p spin_lock: test11 ld_abs under lock OK
# #795/u PTR_TO_STACK store/load OK
# #795/p PTR_TO_STACK store/load OK
# #796/u PTR_TO_STACK store/load - bad alignment on off OK
# #796/p PTR_TO_STACK store/load - bad alignment on off OK
# #797/u PTR_TO_STACK store/load - bad alignment on reg OK
# #797/p PTR_TO_STACK store/load - bad alignment on reg OK
# #798/u PTR_TO_STACK store/load - out of bounds low OK
# #798/p PTR_TO_STACK store/load - out of bounds low OK
# #799/u PTR_TO_STACK store/load - out of bounds high OK
# #799/p PTR_TO_STACK store/load - out of bounds high OK
# #800/u PTR_TO_STACK check high 1 OK
# #800/p PTR_TO_STACK check high 1 OK
# #801/u PTR_TO_STACK check high 2 OK
# #801/p PTR_TO_STACK check high 2 OK
# #802/u PTR_TO_STACK check high 3 OK
# #802/p PTR_TO_STACK check high 3 OK
# #803/u PTR_TO_STACK check high 4 OK
# #803/p PTR_TO_STACK check high 4 OK
# #804/u PTR_TO_STACK check high 5 OK
# #804/p PTR_TO_STACK check high 5 OK
# #805/u PTR_TO_STACK check high 6 OK
# #805/p PTR_TO_STACK check high 6 OK
# #806/u PTR_TO_STACK check high 7 OK
# #806/p PTR_TO_STACK check high 7 OK
# #807/u PTR_TO_STACK check low 1 OK
# #807/p PTR_TO_STACK check low 1 OK
# #808/u PTR_TO_STACK check low 2 OK
# #808/p PTR_TO_STACK check low 2 OK
# #809/u PTR_TO_STACK check low 3 OK
# #809/p PTR_TO_STACK check low 3 OK
# #810/u PTR_TO_STACK check low 4 OK
# #810/p PTR_TO_STACK check low 4 OK
# #811/u PTR_TO_STACK check low 5 OK
# #811/p PTR_TO_STACK check low 5 OK
# #812/u PTR_TO_STACK check low 6 OK
# #812/p PTR_TO_STACK check low 6 OK
# #813/u PTR_TO_STACK check low 7 OK
# #813/p PTR_TO_STACK check low 7 OK
# #814/u PTR_TO_STACK mixed reg/k, 1 OK
# #814/p PTR_TO_STACK mixed reg/k, 1 OK
# #815/u PTR_TO_STACK mixed reg/k, 2 OK
# #815/p PTR_TO_STACK mixed reg/k, 2 OK
# #816/u PTR_TO_STACK mixed reg/k, 3 OK
# #816/p PTR_TO_STACK mixed reg/k, 3 OK
# #817/u PTR_TO_STACK reg OK
# #817/p PTR_TO_STACK reg OK
# #818/u stack pointer arithmetic OK
# #818/p stack pointer arithmetic OK
# #819/u read uninitialized register OK
# #819/p read uninitialized register OK
# #820/u read invalid register OK
# #820/p read invalid register OK
# #821/u program doesn't init R0 before exit OK
# #821/p program doesn't init R0 before exit OK
# #822/u program doesn't init R0 before exit in all branches OK
# #822/p program doesn't init R0 before exit in all branches OK
# #823/u unpriv: return pointer OK
# #823/p unpriv: return pointer OK
# #824/u unpriv: add const to pointer OK
# #824/p unpriv: add const to pointer OK
# #825/u unpriv: add pointer to pointer OK
# #825/p unpriv: add pointer to pointer OK
# #826/u unpriv: neg pointer OK
# #826/p unpriv: neg pointer OK
# #827/u unpriv: cmp pointer with const OK
# #827/p unpriv: cmp pointer with const OK
# #828/u unpriv: cmp pointer with pointer OK
# #828/p unpriv: cmp pointer with pointer OK
# #829/p unpriv: check that printk is disallowed OK
# #830/u unpriv: pass pointer to helper function OK
# #830/p unpriv: pass pointer to helper function OK
# #831/u unpriv: indirectly pass pointer on stack to helper function OK
# #831/p unpriv: indirectly pass pointer on stack to helper function OK
# #832/u unpriv: mangle pointer on stack 1 OK
# #832/p unpriv: mangle pointer on stack 1 OK
# #833/u unpriv: mangle pointer on stack 2 OK
# #833/p unpriv: mangle pointer on stack 2 OK
# #834/u unpriv: read pointer from stack in small chunks OK
# #834/p unpriv: read pointer from stack in small chunks OK
# #835/u unpriv: write pointer into ctx OK
# #835/p unpriv: write pointer into ctx OK
# #836/u unpriv: spill/fill of ctx OK
# #836/p unpriv: spill/fill of ctx OK
# #837/p unpriv: spill/fill of ctx 2 OK
# #838/p unpriv: spill/fill of ctx 3 OK
# #839/p unpriv: spill/fill of ctx 4 OK
# #840/p unpriv: spill/fill of different pointers stx OK
# #841/p unpriv: spill/fill of different pointers stx - ctx and sock OK
# #842/p unpriv: spill/fill of different pointers stx - leak sock OK
# #843/p unpriv: spill/fill of different pointers stx - sock and ctx (read) OK
# #844/p unpriv: spill/fill of different pointers stx - sock and ctx (write) OK
# #845/p unpriv: spill/fill of different pointers ldx OK
# #846/u unpriv: write pointer into map elem value OK
# #846/p unpriv: write pointer into map elem value OK
# #847/u alu32: mov u32 const OK
# #847/p alu32: mov u32 const OK
# #848/u unpriv: partial copy of pointer OK
# #848/p unpriv: partial copy of pointer OK
# #849/u unpriv: pass pointer to tail_call OK
# #849/p unpriv: pass pointer to tail_call OK
# #850/u unpriv: cmp map pointer with zero OK
# #850/p unpriv: cmp map pointer with zero OK
# #851/u unpriv: write into frame pointer OK
# #851/p unpriv: write into frame pointer OK
# #852/u unpriv: spill/fill frame pointer OK
# #852/p unpriv: spill/fill frame pointer OK
# #853/u unpriv: cmp of frame pointer OK
# #853/p unpriv: cmp of frame pointer OK
# #854/u unpriv: adding of fp OK
# #854/p unpriv: adding of fp OK
# #855/u unpriv: cmp of stack pointer OK
# #855/p unpriv: cmp of stack pointer OK
# #856/u map element value store of cleared call register OK
# #856/p map element value store of cleared call register OK
# #857/u map element value with unaligned store OK
# #857/p map element value with unaligned store OK
# #858/u map element value with unaligned load OK
# #858/p map element value with unaligned load OK
# #859/u map element value is preserved across register spilling OK
# #859/p map element value is preserved across register spilling OK
# #860/u map element value is preserved across register spilling OK
# #860/p map element value is preserved across register spilling OK
# #861/u map element value or null is marked on register spilling OK
# #861/p map element value or null is marked on register spilling OK
# #862/u map element value illegal alu op, 1 OK
# #862/p map element value illegal alu op, 1 OK
# #863/u map element value illegal alu op, 2 OK
# #863/p map element value illegal alu op, 2 OK
# #864/u map element value illegal alu op, 3 OK
# #864/p map element value illegal alu op, 3 OK
# #865/u map element value illegal alu op, 4 OK
# #865/p map element value illegal alu op, 4 OK
# #866/u map element value illegal alu op, 5 OK
# #866/p map element value illegal alu op, 5 OK
# #867/p multiple registers share map_lookup_elem result OK
# #868/p alu ops on ptr_to_map_value_or_null, 1 OK
# #869/p alu ops on ptr_to_map_value_or_null, 2 OK
# #870/p alu ops on ptr_to_map_value_or_null, 3 OK
# #871/p invalid memory access with multiple map_lookup_elem calls OK
# #872/p valid indirect map_lookup_elem access with 2nd lookup in branch OK
# #873/u invalid map access from else condition OK
# #873/p invalid map access from else condition OK
# #874/u map access: known scalar += value_ptr from different maps OK
# #874/p map access: known scalar += value_ptr from different maps OK
# #875/u map access: value_ptr -= known scalar from different maps OK
# #875/p map access: value_ptr -= known scalar from different maps OK
# #876/u map access: known scalar += value_ptr from different maps, but same value properties OK
# #876/p map access: known scalar += value_ptr from different maps, but same value properties OK
# #877/u map access: mixing value pointer and scalar, 1 OK
# #877/p map access: mixing value pointer and scalar, 1 OK
# #878/u map access: mixing value pointer and scalar, 2 OK
# #878/p map access: mixing value pointer and scalar, 2 OK
# #879/u sanitation: alu with different scalars 1 OK
# #879/p sanitation: alu with different scalars 1 OK
# #880/u sanitation: alu with different scalars 2 OK
# #880/p sanitation: alu with different scalars 2 OK
# #881/u sanitation: alu with different scalars 3 OK
# #881/p sanitation: alu with different scalars 3 OK
# #882/u map access: value_ptr += known scalar, upper oob arith, test 1 OK
# #882/p map access: value_ptr += known scalar, upper oob arith, test 1 OK
# #883/u map access: value_ptr += known scalar, upper oob arith, test 2 OK
# #883/p map access: value_ptr += known scalar, upper oob arith, test 2 OK
# #884/u map access: value_ptr += known scalar, upper oob arith, test 3 OK
# #884/p map access: value_ptr += known scalar, upper oob arith, test 3 OK
# #885/u map access: value_ptr -= known scalar, lower oob arith, test 1 OK
# #885/p map access: value_ptr -= known scalar, lower oob arith, test 1 OK
# #886/u map access: value_ptr -= known scalar, lower oob arith, test 2 OK
# #886/p map access: value_ptr -= known scalar, lower oob arith, test 2 OK
# #887/u map access: value_ptr -= known scalar, lower oob arith, test 3 OK
# #887/p map access: value_ptr -= known scalar, lower oob arith, test 3 OK
# #888/u map access: known scalar += value_ptr OK
# #888/p map access: known scalar += value_ptr OK
# #889/u map access: value_ptr += known scalar, 1 OK
# #889/p map access: value_ptr += known scalar, 1 OK
# #890/u map access: value_ptr += known scalar, 2 OK
# #890/p map access: value_ptr += known scalar, 2 OK
# #891/u map access: value_ptr += known scalar, 3 OK
# #891/p map access: value_ptr += known scalar, 3 OK
# #892/u map access: value_ptr += known scalar, 4 OK
# #892/p map access: value_ptr += known scalar, 4 OK
# #893/u map access: value_ptr += known scalar, 5 OK
# #893/p map access: value_ptr += known scalar, 5 OK
# #894/u map access: value_ptr += known scalar, 6 OK
# #894/p map access: value_ptr += known scalar, 6 OK
# #895/u map access: unknown scalar += value_ptr, 1 OK
# #895/p map access: unknown scalar += value_ptr, 1 OK
# #896/u map access: unknown scalar += value_ptr, 2 OK
# #896/p map access: unknown scalar += value_ptr, 2 OK
# #897/u map access: unknown scalar += value_ptr, 3 OK
# #897/p map access: unknown scalar += value_ptr, 3 OK
# #898/u map access: unknown scalar += value_ptr, 4 OK
# #898/p map access: unknown scalar += value_ptr, 4 OK
# #899/u map access: value_ptr += unknown scalar, 1 OK
# #899/p map access: value_ptr += unknown scalar, 1 OK
# #900/u map access: value_ptr += unknown scalar, 2 OK
# #900/p map access: value_ptr += unknown scalar, 2 OK
# #901/u map access: value_ptr += unknown scalar, 3 OK
# #901/p map access: value_ptr += unknown scalar, 3 OK
# #902/u map access: value_ptr += value_ptr OK
# #902/p map access: value_ptr += value_ptr OK
# #903/u map access: known scalar -= value_ptr OK
# #903/p map access: known scalar -= value_ptr OK
# #904/u map access: value_ptr -= known scalar OK
# #904/p map access: value_ptr -= known scalar OK
# #905/u map access: value_ptr -= known scalar, 2 OK
# #905/p map access: value_ptr -= known scalar, 2 OK
# #906/u map access: unknown scalar -= value_ptr OK
# #906/p map access: unknown scalar -= value_ptr OK
# #907/u map access: value_ptr -= unknown scalar OK
# #907/p map access: value_ptr -= unknown scalar OK
# #908/u map access: value_ptr -= unknown scalar, 2 OK
# #908/p map access: value_ptr -= unknown scalar, 2 OK
# #909/u map access: value_ptr -= value_ptr OK
# #909/p map access: value_ptr -= value_ptr OK
# #910/p variable-offset ctx access OK
# #911/p variable-offset stack access OK
# #912/p indirect variable-offset stack access, unbounded OK
# #913/p indirect variable-offset stack access, max out of bound OK
# #914/p indirect variable-offset stack access, min out of bound OK
# #915/p indirect variable-offset stack access, max_off+size > max_initialized OK
# #916/p indirect variable-offset stack access, min_off < min_initialized OK
# #917/u indirect variable-offset stack access, priv vs unpriv OK
# #917/p indirect variable-offset stack access, priv vs unpriv OK
# #918/p indirect variable-offset stack access, uninitialized OK
# #919/p indirect variable-offset stack access, ok OK
# #920/p xadd/w check unaligned stack OK
# #921/p xadd/w check unaligned map OK
# #922/p xadd/w check unaligned pkt OK
# #923/p xadd/w check whether src/dst got mangled, 1 OK
# #924/p xadd/w check whether src/dst got mangled, 2 OK
# #925/p XDP, using ifindex from netdev OK
# #926/p XDP pkt read, pkt_end mangling, bad access 1 OK
# #927/p XDP pkt read, pkt_end mangling, bad access 2 OK
# #928/p XDP pkt read, pkt_data' > pkt_end, good access OK
# #929/p XDP pkt read, pkt_data' > pkt_end, bad access 1 OK
# #930/p XDP pkt read, pkt_data' > pkt_end, bad access 2 OK
# #931/p XDP pkt read, pkt_end > pkt_data', good access OK
# #932/p XDP pkt read, pkt_end > pkt_data', bad access 1 OK
# #933/p XDP pkt read, pkt_end > pkt_data', bad access 2 OK
# #934/p XDP pkt read, pkt_data' < pkt_end, good access OK
# #935/p XDP pkt read, pkt_data' < pkt_end, bad access 1 OK
# #936/p XDP pkt read, pkt_data' < pkt_end, bad access 2 OK
# #937/p XDP pkt read, pkt_end < pkt_data', good access OK
# #938/p XDP pkt read, pkt_end < pkt_data', bad access 1 OK
# #939/p XDP pkt read, pkt_end < pkt_data', bad access 2 OK
# #940/p XDP pkt read, pkt_data' >= pkt_end, good access OK
# #941/p XDP pkt read, pkt_data' >= pkt_end, bad access 1 OK
# #942/p XDP pkt read, pkt_data' >= pkt_end, bad access 2 OK
# #943/p XDP pkt read, pkt_end >= pkt_data', good access OK
# #944/p XDP pkt read, pkt_end >= pkt_data', bad access 1 OK
# #945/p XDP pkt read, pkt_end >= pkt_data', bad access 2 OK
# #946/p XDP pkt read, pkt_data' <= pkt_end, good access OK
# #947/p XDP pkt read, pkt_data' <= pkt_end, bad access 1 OK
# #948/p XDP pkt read, pkt_data' <= pkt_end, bad access 2 OK
# #949/p XDP pkt read, pkt_end <= pkt_data', good access OK
# #950/p XDP pkt read, pkt_end <= pkt_data', bad access 1 OK
# #951/p XDP pkt read, pkt_end <= pkt_data', bad access 2 OK
# #952/p XDP pkt read, pkt_meta' > pkt_data, good access OK
# #953/p XDP pkt read, pkt_meta' > pkt_data, bad access 1 OK
# #954/p XDP pkt read, pkt_meta' > pkt_data, bad access 2 OK
# #955/p XDP pkt read, pkt_data > pkt_meta', good access OK
# #956/p XDP pkt read, pkt_data > pkt_meta', bad access 1 OK
# #957/p XDP pkt read, pkt_data > pkt_meta', bad access 2 OK
# #958/p XDP pkt read, pkt_meta' < pkt_data, good access OK
# #959/p XDP pkt read, pkt_meta' < pkt_data, bad access 1 OK
# #960/p XDP pkt read, pkt_meta' < pkt_data, bad access 2 OK
# #961/p XDP pkt read, pkt_data < pkt_meta', good access OK
# #962/p XDP pkt read, pkt_data < pkt_meta', bad access 1 OK
# #963/p XDP pkt read, pkt_data < pkt_meta', bad access 2 OK
# #964/p XDP pkt read, pkt_meta' >= pkt_data, good access OK
# #965/p XDP pkt read, pkt_meta' >= pkt_data, bad access 1 OK
# #966/p XDP pkt read, pkt_meta' >= pkt_data, bad access 2 OK
# #967/p XDP pkt read, pkt_data >= pkt_meta', good access OK
# #968/p XDP pkt read, pkt_data >= pkt_meta', bad access 1 OK
# #969/p XDP pkt read, pkt_data >= pkt_meta', bad access 2 OK
# #970/p XDP pkt read, pkt_meta' <= pkt_data, good access OK
# #971/p XDP pkt read, pkt_meta' <= pkt_data, bad access 1 OK
# #972/p XDP pkt read, pkt_meta' <= pkt_data, bad access 2 OK
# #973/p XDP pkt read, pkt_data <= pkt_meta', good access OK
# #974/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 OK
# #975/p XDP pkt read, pkt_data <= pkt_meta', bad access 2 OK
# Summary: 1429 PASSED, 1 SKIPPED, 9 FAILED
not ok 1 selftests: bpf: test_verifier


If you fix the issue, kindly add following tag
Reported-by: kernel test robot <rong.a.chen@intel.com>




To reproduce:

        # build kernel
	cd linux
	cp config-5.2.0-rc2-00603-g9fe4f05 .config
	make HOSTCC=gcc-7 CC=gcc-7 ARCH=x86_64 olddefconfig
	make HOSTCC=gcc-7 CC=gcc-7 ARCH=x86_64 prepare
	make HOSTCC=gcc-7 CC=gcc-7 ARCH=x86_64 modules_prepare
	make HOSTCC=gcc-7 CC=gcc-7 ARCH=x86_64 SHELL=/bin/bash
	make HOSTCC=gcc-7 CC=gcc-7 ARCH=x86_64 bzImage


        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp qemu -k <bzImage> job-script # job-script is attached in this email



Thanks,
Rong Chen


--By57YlnFViWR/M0S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-5.2.0-rc2-00603-g9fe4f05"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.2.0-rc2 Kernel Configuration
#

#
# Compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
#
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=70300
CONFIG_CLANG_VERSION=0
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_WARN_MAYBE_UNINITIALIZED=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
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
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

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
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y

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
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# end of RCU Subsystem

CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS_PROC is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
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
# CONFIG_SYSCTL_SYSCALL is not set
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
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT_ALWAYS_ON=y
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
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
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
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
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
# CONFIG_PVH is not set
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
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
CONFIG_X86_MCELOG_LEGACY=y
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
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_AMD_MEM_ENCRYPT=y
# CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
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
CONFIG_X86_INTEL_UMIP=y
CONFIG_X86_INTEL_MPX=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
CONFIG_KEXEC_VERIFY_SIG=y
CONFIG_KEXEC_BZIMAGE_VERIFY_SIG=y
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
# CONFIG_ACPI_PROCFS_POWER is not set
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
CONFIG_ACPI_NUMA=y
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
# CONFIG_ACPI_HMAT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_ERST_DEBUG=y
# CONFIG_DPTF_POWER is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_X86_PM_TIMER=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set

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

CONFIG_X86_DEV_DMA_OPS=y
CONFIG_HAVE_GENERIC_GUP=y

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
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_APPLE_PROPERTIES=y
# CONFIG_RESET_ATTACK_MITIGATION is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y
CONFIG_EFI_DEV_PATH_PARSER=y
CONFIG_EFI_EARLYCON=y

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
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
CONFIG_KVM_AMD_SEV=y
CONFIG_KVM_MMU_AUDIT=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
CONFIG_VHOST=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
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
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_HAVE_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_CC_HAS_STACKPROTECTOR_NONE=y
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
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_64BIT_TIME=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_ARCH_HAS_REFCOUNT=y
# CONFIG_REFCOUNT_FULL is not set
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_PLUGIN_HOSTCC="g++"
CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y

#
# GCC plugins
#
# CONFIG_GCC_PLUGIN_CYC_COMPLEXITY is not set
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# CONFIG_GCC_PLUGIN_RANDSTRUCT is not set
# end of GCC plugins
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
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
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_ZONED=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
# CONFIG_BLK_WBT is not set
# CONFIG_BLK_CGROUP_IOLATENCY is not set
CONFIG_BLK_DEBUG_FS=y
CONFIG_BLK_DEBUG_FS_ZONED=y
# CONFIG_BLK_SED_OPAL is not set

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
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
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
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
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
CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_AREAS=7
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_ZSWAP=y
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_ZONE_DEVICE=y
CONFIG_ZONE_DEVICE=y
CONFIG_ARCH_HAS_HMM_MIRROR=y
CONFIG_ARCH_HAS_HMM_DEVICE=y
CONFIG_ARCH_HAS_HMM=y
CONFIG_MIGRATE_VMA_HELPER=y
CONFIG_DEV_PAGEMAP_OPS=y
CONFIG_HMM=y
CONFIG_HMM_MIRROR=y
# CONFIG_DEVICE_PRIVATE is not set
# CONFIG_DEVICE_PUBLIC is not set
CONFIG_FRAME_VECTOR=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_BENCHMARK is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
# end of Memory Management options

CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_UNIX_DIAG=m
# CONFIG_TLS is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_XDP_SOCKETS is not set
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
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
CONFIG_NET_FOU=m
CONFIG_NET_FOU_IP_TUNNELS=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
# CONFIG_INET_ESP_OFFLOAD is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
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
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_FOU=m
CONFIG_IPV6_FOU_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
# CONFIG_IPV6_SEG6_HMAC is not set
CONFIG_IPV6_SEG6_BPF=y
CONFIG_NETLABEL=y
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
# CONFIG_NF_TABLES_SET is not set
# CONFIG_NF_TABLES_INET is not set
# CONFIG_NF_TABLES_NETDEV is not set
# CONFIG_NFT_NUMGEN is not set
CONFIG_NFT_CT=m
CONFIG_NFT_COUNTER=m
# CONFIG_NFT_CONNLIMIT is not set
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
# CONFIG_NFT_TUNNEL is not set
# CONFIG_NFT_OBJREF is not set
CONFIG_NFT_QUEUE=m
# CONFIG_NFT_QUOTA is not set
CONFIG_NFT_REJECT=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
# CONFIG_NFT_XFRM is not set
# CONFIG_NFT_SOCKET is not set
# CONFIG_NFT_OSF is not set
# CONFIG_NFT_TPROXY is not set
# CONFIG_NF_FLOW_TABLE is not set
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
# CONFIG_NF_TABLES_IPV4 is not set
# CONFIG_NF_TABLES_ARP is not set
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
# CONFIG_NF_TABLES_IPV6 is not set
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
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
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
# CONFIG_NET_SCH_ETF is not set
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
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
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m
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
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_EMATCH_IPSET=m
# CONFIG_NET_EMATCH_IPT is not set
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
CONFIG_NET_ACT_VLAN=m
# CONFIG_NET_ACT_BPF is not set
CONFIG_NET_ACT_CONNMARK=m
# CONFIG_NET_ACT_CTINFO is not set
CONFIG_NET_ACT_SKBMOD=m
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=m
CONFIG_NET_CLS_IND=y
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
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_HYPERV_VSOCKETS=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_MPLS_ROUTING is not set
CONFIG_NET_NSH=m
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
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

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
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
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_EMS_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PLX_PCI=m
CONFIG_CAN_SOFTING=m

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set
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
# CONFIG_BT_SELFTEST is not set
CONFIG_BT_DEBUGFS=y

#
# Bluetooth device drivers
#
CONFIG_BT_INTEL=m
CONFIG_BT_BCM=m
CONFIG_BT_RTL=m
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTUSB_AUTOSUSPEND is not set
CONFIG_BT_HCIBTUSB_BCM=y
CONFIG_BT_HCIBTUSB_RTL=y
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_INTEL is not set
# CONFIG_BT_HCIUART_AG6XX is not set
# CONFIG_BT_HCIUART_MRVL is not set
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
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_FAILOVER=m
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
# CONFIG_PCIEASPM_DEBUG is not set
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
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support

CONFIG_VMD=y

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set
# end of DesignWare PCI Core Support
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
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
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
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_GNSS is not set
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# Partition parsers
#
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

# CONFIG_MTD_ONENAND is not set
# CONFIG_MTD_RAW_NAND is not set
# CONFIG_MTD_SPI_NAND is not set

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
CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION=y
CONFIG_BLK_DEV_FD=m
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
# CONFIG_ZRAM is not set
# CONFIG_BLK_DEV_UMEM is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
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
CONFIG_VIRTIO_BLK=y
# CONFIG_VIRTIO_BLK_SCSI is not set
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
CONFIG_NVME_FABRICS=m
CONFIG_NVME_FC=m
# CONFIG_NVME_TCP is not set
CONFIG_NVME_TARGET=m
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
CONFIG_SGI_IOC4=m
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
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
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
# CONFIG_INTEL_MEI_HDCP is not set
CONFIG_VMWARE_VMCI=m

#
# Intel MIC & related support
#

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# SCIF Bus Driver
#
# CONFIG_SCIF_BUS is not set

#
# VOP Bus Driver
#
# CONFIG_VOP_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#

#
# VOP Driver
#
# end of Intel MIC & related support

# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_MISC_ALCOR_PCI is not set
# CONFIG_MISC_RTSX_PCI is not set
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
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
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
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
# CONFIG_SCSI_LPFC is not set
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
CONFIG_ATA_VERBOSE_ERROR=y
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
CONFIG_MD_MULTIPATH=m
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
CONFIG_DM_ERA=m
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
# CONFIG_DM_INTEGRITY is not set
# CONFIG_DM_ZONED is not set
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
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_IFB=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
# CONFIG_IPVLAN is not set
CONFIG_VXLAN=m
CONFIG_GENEVE=m
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
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
CONFIG_NLMON=m
CONFIG_NET_VRF=y
CONFIG_VSOCKMON=m
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#

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
CONFIG_AMD8111_ETH=m
CONFIG_PCNET32=m
CONFIG_AMD_XGBE=m
# CONFIG_AMD_XGBE_DCB is not set
CONFIG_AMD_XGBE_HAVE_ECC=y
CONFIG_NET_VENDOR_AQUANTIA=y
CONFIG_AQTION=m
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
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
CONFIG_TIGON3=y
CONFIG_TIGON3_HWMON=y
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
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_CX_ECAT is not set
CONFIG_DNET=m
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
CONFIG_BE2NET_HWMON=y
CONFIG_BE2NET_BE2=y
CONFIG_BE2NET_BE3=y
CONFIG_BE2NET_LANCER=y
CONFIG_BE2NET_SKYHAWK=y
CONFIG_NET_VENDOR_EZCHIP=y
# CONFIG_NET_VENDOR_HP is not set
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
CONFIG_IXGB=y
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
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
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
# CONFIG_MSCC_OCELOT_SWITCH is not set
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
CONFIG_YELLOWFIN=m
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
CONFIG_QLCNIC=m
CONFIG_QLCNIC_SRIOV=y
CONFIG_QLCNIC_DCB=y
CONFIG_QLCNIC_HWMON=y
CONFIG_QLGE=m
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
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
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
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
# CONFIG_MDIO_BCM_UNIMAC is not set
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_GPIO is not set
# CONFIG_MDIO_MSCC_MIIM is not set
# CONFIG_MDIO_THUNDER is not set
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=m
# CONFIG_AQUANTIA_PHY is not set
# CONFIG_ASIX_PHY is not set
CONFIG_AT803X_PHY=m
# CONFIG_BCM7XXX_PHY is not set
CONFIG_BCM87XX_PHY=m
CONFIG_BCM_NET_PHYLIB=m
CONFIG_BROADCOM_PHY=m
CONFIG_CICADA_PHY=m
# CONFIG_CORTINA_PHY is not set
CONFIG_DAVICOM_PHY=m
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_ICPLUS_PHY=m
# CONFIG_INTEL_XWAY_PHY is not set
CONFIG_LSI_ET1011C_PHY=m
CONFIG_LXT_PHY=m
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
CONFIG_VITESSE_PHY=m
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
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
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=m
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_HUAWEI_CDC_NCM=m
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET_ENABLE=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=m
# CONFIG_USB_NET_CH9200 is not set
# CONFIG_USB_NET_AQC111 is not set
CONFIG_WLAN=y
# CONFIG_WIRELESS_WDS is not set
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
# CONFIG_IWLWIFI_PCIE_RTPM is not set

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

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
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
# CONFIG_DSCC4 is not set
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
CONFIG_THUNDERBOLT_NET=m
CONFIG_HYPERV_NET=m
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
# CONFIG_ISDN_PPP_BSDCOMP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m
# end of ISDN feature submodules

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
CONFIG_HISAX_NO_SENDCOMPLETE=y
CONFIG_HISAX_NO_LLC=y
CONFIG_HISAX_NO_KEYPAD=y
CONFIG_HISAX_1TR6=y
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=y
CONFIG_HISAX_TELESPCI=y
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
CONFIG_HISAX_NICCY=y
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_PCI=y
CONFIG_HISAX_W6692=y
CONFIG_HISAX_HFC_SX=y
CONFIG_HISAX_ENTERNOW_PCI=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=m
# CONFIG_HISAX_HFCUSB is not set
CONFIG_HISAX_HFC4S8S=m
CONFIG_HISAX_FRITZ_PCIPNP=m
# end of Passive cards

CONFIG_ISDN_CAPI=m
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPIDRV=m
# CONFIG_ISDN_CAPI_CAPIDRV_VERBOSE is not set

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_CAPI=y
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
# CONFIG_GIGASET_DEBUG is not set
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
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
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
CONFIG_ISDN_HDLC=m
CONFIG_NVM=y
# CONFIG_NVM_PBLK is not set

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
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_E3X0_BUTTON is not set
# CONFIG_INPUT_MSM_VIBRATOR is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_GP2A=m
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
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=m
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
# CONFIG_NULL_TTY is not set
CONFIG_LDISC_AUTOLOAD=y
CONFIG_DEVMEM=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
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
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
# CONFIG_SERIAL_8250_MOXA is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# end of Serial drivers

# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
CONFIG_VIRTIO_CONSOLE=y
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
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
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
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set
# end of Character devices

# CONFIG_RANDOM_TRUST_CPU is not set

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
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
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
CONFIG_I2C_PARPORT_LIGHT=m
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
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
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
CONFIG_PTP_1588_CLOCK_KVM=m
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
CONFIG_PINCTRL_INTEL=m
# CONFIG_PINCTRL_BROXTON is not set
CONFIG_PINCTRL_CANNONLAKE=m
# CONFIG_PINCTRL_CEDARFORK is not set
CONFIG_PINCTRL_DENVERTON=m
CONFIG_PINCTRL_GEMINILAKE=m
# CONFIG_PINCTRL_ICELAKE is not set
CONFIG_PINCTRL_LEWISBURG=m
CONFIG_PINCTRL_SUNRISEPOINT=m
CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_AMDPT=m
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_LYNXPOINT is not set
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_VX855 is not set
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

CONFIG_GPIO_MOCKUP=y
# CONFIG_W1 is not set
# CONFIG_POWER_AVS is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
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
# CONFIG_CHARGER_BQ25890 is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_CHARGER_RT9455 is not set
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
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
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
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_TC654 is not set
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
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
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
CONFIG_SENSORS_ADS1015=m
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
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_CLOCK_THERMAL is not set
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
# end of ACPI INT340X thermal drivers

# CONFIG_INTEL_PCH_THERMAL is not set
# end of Intel thermal drivers

# CONFIG_GENERIC_ADC_THERMAL is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
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
# CONFIG_MFD_CROS_EC is not set
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
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
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
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SMSC is not set
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
# CONFIG_IR_IMON_DECODER is not set
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
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_CEC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_MEDIA_CONTROLLER_DVB=y
CONFIG_VIDEO_DEV=m
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_DVB_CORE=m
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=y
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set
# CONFIG_DVB_ULE_DEBUG is not set

#
# Media drivers
#
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
CONFIG_VIDEO_USBVISION=m
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
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=m
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

#
# Texas Instruments WL128x FM driver (ST based)
#
# end of Texas Instruments WL128x FM driver (ST based)

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
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

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS3308=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m

#
# Camera sensor devices
#

#
# Lens drivers
#

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m

#
# SDR tuner chips
#

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_M52790=m

#
# Media SPI Adapters
#
# CONFIG_CXD2880_SPI_DRV is not set
# end of Media SPI Adapters

CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA18250=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
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
CONFIG_MEDIA_TUNER_QM1D1C0042=m
CONFIG_MEDIA_TUNER_QM1D1B0004=m

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
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_CXD2841ER=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_SI2168=m
CONFIG_DVB_GP8PSK_FE=m

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
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m

#
# Common Interface (EN50221) controller drivers
#
CONFIG_DVB_CXD2099=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m

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
CONFIG_DRM=m
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
CONFIG_DRM_DEBUG_SELFTEST=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
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

#
# ACP (Audio CoProcessor) Configuration
#
# end of ACP (Audio CoProcessor) Configuration

# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
# CONFIG_DRM_I915_ALPHA_SUPPORT is not set
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
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# end of drm/i915 Debugging

CONFIG_DRM_VGEM=m
# CONFIG_DRM_VKMS is not set
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
CONFIG_DRM_UDL=m
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_CIRRUS_QEMU=m
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
# CONFIG_DRM_HISI_HIBMC is not set
# CONFIG_DRM_TINYDRM is not set
# CONFIG_DRM_XEN is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_LEGACY is not set
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
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
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
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_PM8941_WLED is not set
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
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
# CONFIG_VGACON_SOFT_SCROLLBACK_PERSISTENT_ENABLE_BY_DEFAULT is not set
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
# end of HD-Audio

CONFIG_SND_HDA_CORE=m
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_COMPONENT=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_EXT_CORE=m
CONFIG_SND_HDA_PREALLOC_SIZE=512
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
# CONFIG_SND_ATMEL_SOC is not set
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
CONFIG_SND_SST_IPC=m
CONFIG_SND_SST_IPC_ACPI=m
CONFIG_SND_SOC_INTEL_SST_ACPI=m
CONFIG_SND_SOC_INTEL_SST=m
CONFIG_SND_SOC_INTEL_SST_FIRMWARE=m
CONFIG_SND_SOC_INTEL_HASWELL=m
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
CONFIG_SND_SOC_INTEL_SKYLAKE_FAMILY=m
CONFIG_SND_SOC_INTEL_SKYLAKE_SSP_CLK=m
# CONFIG_SND_SOC_INTEL_SKYLAKE_HDAUDIO_CODEC is not set
CONFIG_SND_SOC_INTEL_SKYLAKE_COMMON=m
CONFIG_SND_SOC_ACPI_INTEL_MATCH=m
CONFIG_SND_SOC_INTEL_MACH=y
CONFIG_SND_SOC_INTEL_HASWELL_MACH=m
CONFIG_SND_SOC_INTEL_BDW_RT5677_MACH=m
CONFIG_SND_SOC_INTEL_BROADWELL_MACH=m
CONFIG_SND_SOC_INTEL_BYTCR_RT5640_MACH=m
CONFIG_SND_SOC_INTEL_BYTCR_RT5651_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5672_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5645_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_MAX98090_TI_MACH=m
# CONFIG_SND_SOC_INTEL_CHT_BSW_NAU8824_MACH is not set
CONFIG_SND_SOC_INTEL_BYT_CHT_DA7213_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_ES8316_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_NOCODEC_MACH=m
CONFIG_SND_SOC_INTEL_SKL_RT286_MACH=m
CONFIG_SND_SOC_INTEL_SKL_NAU88L25_SSM4567_MACH=m
CONFIG_SND_SOC_INTEL_SKL_NAU88L25_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_BXT_DA7219_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_BXT_RT298_MACH=m
CONFIG_SND_SOC_INTEL_KBL_RT5663_MAX98927_MACH=m
CONFIG_SND_SOC_INTEL_KBL_RT5663_RT5514_MAX98927_MACH=m
# CONFIG_SND_SOC_INTEL_KBL_DA7219_MAX98357A_MACH is not set
# CONFIG_SND_SOC_INTEL_KBL_DA7219_MAX98927_MACH is not set
# CONFIG_SND_SOC_INTEL_KBL_RT5660_MACH is not set
# CONFIG_SND_SOC_INTEL_GLK_RT5682_MAX98357A_MACH is not set
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
# CONFIG_SND_SOC_CS4265 is not set
# CONFIG_SND_SOC_CS4270 is not set
# CONFIG_SND_SOC_CS4271_I2C is not set
# CONFIG_SND_SOC_CS4271_SPI is not set
# CONFIG_SND_SOC_CS42XX8_I2C is not set
# CONFIG_SND_SOC_CS43130 is not set
# CONFIG_SND_SOC_CS4341 is not set
# CONFIG_SND_SOC_CS4349 is not set
# CONFIG_SND_SOC_CS53L30 is not set
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
# CONFIG_SND_SOC_MAX98373 is not set
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
CONFIG_SND_SOC_RT5677=m
CONFIG_SND_SOC_RT5677_SPI=m
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
CONFIG_SND_SOC_TS3A227E=m
# CONFIG_SND_SOC_TSCS42XX is not set
# CONFIG_SND_SOC_TSCS454 is not set
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
# CONFIG_SND_SOC_ZX_AUD96P22 is not set
# CONFIG_SND_SOC_MAX9759 is not set
# CONFIG_SND_SOC_MT6351 is not set
# CONFIG_SND_SOC_MT6358 is not set
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
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
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
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=m
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
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
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=m
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
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
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
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
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
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
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
CONFIG_INTEL_IOATDMA=m
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
CONFIG_HSU_DMA=y

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
CONFIG_IRQ_BYPASS_MANAGER=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_TSCPAGE=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m
# end of Microsoft Hyper-V guest support

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_SELFBALLOONING is not set
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
CONFIG_XEN_TMEM=m
# CONFIG_XEN_PVCALLS_FRONTEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
CONFIG_XEN_HAVE_VPMU=y
# end of Xen driver support

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
# CONFIG_AD7192 is not set
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

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# end of Speakup console speech

# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ASHMEM is not set
# CONFIG_ANDROID_VSOC is not set
CONFIG_ION=y
CONFIG_ION_SYSTEM_HEAP=y
# CONFIG_ION_CARVEOUT_HEAP is not set
# CONFIG_ION_CHUNK_HEAP is not set
# CONFIG_ION_CMA_HEAP is not set
# end of Android

# CONFIG_LTE_GDM724X is not set
CONFIG_FIREWIRE_SERIAL=m
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
# CONFIG_GS_FPGABOOT is not set
# CONFIG_UNISYSSPAR is not set
# CONFIG_FB_TFT is not set
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
# CONFIG_MOST is not set
# CONFIG_KS7010 is not set
# CONFIG_GREYBUS is not set
# CONFIG_PI433 is not set

#
# Gasket devices
#
# CONFIG_STAGING_GASKET_FRAMEWORK is not set
# end of Gasket devices

# CONFIG_EROFS_FS is not set
# CONFIG_FIELDBUS_DEV is not set
# CONFIG_KPC2000 is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACERHDF=m
# CONFIG_ALIENWARE_WMI is not set
CONFIG_ASUS_LAPTOP=m
CONFIG_DCDBAS=m
CONFIG_DELL_SMBIOS=m
CONFIG_DELL_SMBIOS_WMI=y
CONFIG_DELL_SMBIOS_SMM=y
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_DESCRIPTOR=m
CONFIG_DELL_WMI_AIO=m
# CONFIG_DELL_WMI_LED is not set
CONFIG_DELL_SMO8800=m
CONFIG_DELL_RBTN=m
CONFIG_DELL_RBU=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
CONFIG_AMILO_RFKILL=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
CONFIG_HP_WIRELESS=m
CONFIG_HP_WMI=m
# CONFIG_LG_LAPTOP is not set
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=m
# CONFIG_SURFACE3_WMI is not set
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_WMI=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
CONFIG_INTEL_WMI_THUNDERBOLT=m
CONFIG_MSI_WMI=m
# CONFIG_PEAQ_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_HID_EVENT=m
CONFIG_INTEL_VBTN=m
CONFIG_INTEL_IPS=m
CONFIG_INTEL_PMC_CORE=m
# CONFIG_IBM_RTL is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_INTEL_OAKTRAIL=m
CONFIG_APPLE_GMUX=m
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_INTEL_PMC_IPC is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
# CONFIG_INTEL_PUNIT_IPC is not set
# CONFIG_MLX_PLATFORM is not set
# CONFIG_INTEL_TURBO_MAX_3 is not set
# CONFIG_I2C_MULTI_INSTANTIATE is not set
# CONFIG_INTEL_ATOMISP2_PM is not set
# CONFIG_HUAWEI_WMI is not set
# CONFIG_PCENGINES_APU2 is not set
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
# CONFIG_MELLANOX_PLATFORM is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# end of Common Clock Framework

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
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_V2=m
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
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
# IXP4xx SoC drivers
#
# CONFIG_IXP4XX_QMGR is not set
# CONFIG_IXP4XX_NPE is not set
# end of IXP4xx SoC drivers

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
# CONFIG_IIO_BUFFER_HW_CONSUMER is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=m
# CONFIG_IIO_CONFIGFS is not set
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
# CONFIG_IIO_SW_DEVICE is not set
# CONFIG_IIO_SW_TRIGGER is not set

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
# CONFIG_BMC150_ACCEL is not set
# CONFIG_DA280 is not set
# CONFIG_DA311 is not set
# CONFIG_DMARD09 is not set
# CONFIG_DMARD10 is not set
CONFIG_HID_SENSOR_ACCEL_3D=m
# CONFIG_IIO_CROS_EC_ACCEL_LEGACY is not set
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
# CONFIG_AD7124 is not set
# CONFIG_AD7266 is not set
# CONFIG_AD7291 is not set
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
# CONFIG_HI8435 is not set
# CONFIG_HX711 is not set
# CONFIG_INA2XX_ADC is not set
# CONFIG_LTC2471 is not set
# CONFIG_LTC2485 is not set
# CONFIG_LTC2497 is not set
# CONFIG_MAX1027 is not set
# CONFIG_MAX11100 is not set
# CONFIG_MAX1118 is not set
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
# end of Analog to digital converters

#
# Analog Front Ends
#
# end of Analog Front Ends

#
# Amplifiers
#
# CONFIG_AD8366 is not set
# end of Amplifiers

#
# Chemical Sensors
#
# CONFIG_ATLAS_PH_SENSOR is not set
# CONFIG_BME680 is not set
# CONFIG_CCS811 is not set
# CONFIG_IAQCORE is not set
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
# CONFIG_LTC1660 is not set
# CONFIG_LTC2632 is not set
# CONFIG_AD5686_SPI is not set
# CONFIG_AD5696_I2C is not set
# CONFIG_AD5755 is not set
# CONFIG_AD5758 is not set
# CONFIG_AD5761 is not set
# CONFIG_AD5764 is not set
# CONFIG_AD5791 is not set
# CONFIG_AD7303 is not set
# CONFIG_AD8801 is not set
# CONFIG_DS4424 is not set
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
# end of Phase-Locked Loop (PLL) frequency synthesizers
# end of Frequency Synthesizers DDS/PLL

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
# CONFIG_ADIS16136 is not set
# CONFIG_ADIS16260 is not set
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
# CONFIG_ADIS16480 is not set
# CONFIG_BMI160_I2C is not set
# CONFIG_BMI160_SPI is not set
# CONFIG_KMX61 is not set
# CONFIG_INV_MPU6050_I2C is not set
# CONFIG_INV_MPU6050_SPI is not set
# CONFIG_IIO_ST_LSM6DSX is not set
# end of Inertial measurement units

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
# CONFIG_ADJD_S311 is not set
# CONFIG_AL3320A is not set
# CONFIG_APDS9300 is not set
# CONFIG_APDS9960 is not set
# CONFIG_BH1750 is not set
# CONFIG_BH1780 is not set
# CONFIG_CM32181 is not set
# CONFIG_CM3232 is not set
# CONFIG_CM3323 is not set
# CONFIG_CM36651 is not set
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
# Digital potentiometers
#
# CONFIG_AD5272 is not set
# CONFIG_DS1803 is not set
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
CONFIG_HID_SENSOR_PRESS=m
# CONFIG_HP03 is not set
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
# CONFIG_RFD77402 is not set
# CONFIG_SRF04 is not set
# CONFIG_SX9500 is not set
# CONFIG_SRF08 is not set
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
# CONFIG_PWM_LPSS_PCI is not set
# CONFIG_PWM_LPSS_PLATFORM is not set
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
CONFIG_ARM_GIC_MAX_NR=1
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_CPCAP_USB is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
CONFIG_THUNDERBOLT=y

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
CONFIG_PM_OPP=y
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_VALIDATE_FS_PARSER=y
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
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_REPAIR=y
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_IO_TRACE is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
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
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
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
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_NTFS_FS is not set
# end of DOS/FAT/NT Filesystems

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
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
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
CONFIG_MINIX_FS=m
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
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
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
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
CONFIG_SUNRPC_DEBUG=y
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
CONFIG_CIFS=m
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_ACL=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
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
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_COMPAT=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_WRITABLE_HOOKS=y
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
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_APPARMOR_HASH_DEFAULT=y
# CONFIG_SECURITY_APPARMOR_DEBUG is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
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
# CONFIG_IMA_ARCH_POLICY is not set
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_USER is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL is not set
# CONFIG_GCC_PLUGIN_STACKLEAK is not set
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
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
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
CONFIG_CRYPTO_WORKQUEUE=y
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

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128L is not set
# CONFIG_CRYPTO_AEGIS256 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
# CONFIG_CRYPTO_AEGIS128L_AESNI_SSE2 is not set
# CONFIG_CRYPTO_AEGIS256_AESNI_SSE2 is not set
# CONFIG_CRYPTO_MORUS640 is not set
# CONFIG_CRYPTO_MORUS640_SSE2 is not set
# CONFIG_CRYPTO_MORUS1280 is not set
# CONFIG_CRYPTO_MORUS1280_SSE2 is not set
# CONFIG_CRYPTO_MORUS1280_AVX2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CFB is not set
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set

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
CONFIG_CRYPTO_AES_X86_64=y
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
# CONFIG_CRYPTO_USER_API_AEAD is not set
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
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
CONFIG_ZSTD_DECOMPRESS=m
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
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DMA_DECLARE_COHERENT=y
CONFIG_SWIOTLB=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=200
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
# CONFIG_DDR is not set
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_UACCESS_MCSAFE=y
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
# end of printk and dmesg options

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_DEBUG_INFO_BTF is not set
# CONFIG_GDB_SCRIPTS is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_STACK_VALIDATION=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
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
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_CC_HAS_KASAN_GENERIC=y
# CONFIG_KASAN is not set
CONFIG_KASAN_STACK=1
# end of Memory Debugging

CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
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
# end of Debug Lockups and Hangs

CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
CONFIG_WW_MUTEX_SELFTEST=m
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_TORTURE_TEST=m
CONFIG_RCU_PERF_TEST=m
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_FUTEX is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAIL_FUNCTION is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
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
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_PREEMPTIRQ_EVENTS is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_TRACING_MAP=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_TRACE_EVAL_MAP_FILE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_STRSCPY is not set
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_PRINTF=m
CONFIG_TEST_BITMAP=m
# CONFIG_TEST_BITFIELD is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_IDA is not set
CONFIG_TEST_LKM=m
# CONFIG_TEST_VMALLOC is not set
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
# CONFIG_FIND_BIT_BENCHMARK is not set
CONFIG_TEST_FIRMWARE=m
CONFIG_TEST_SYSCTL=m
# CONFIG_TEST_UDELAY is not set
CONFIG_TEST_STATIC_KEYS=m
CONFIG_TEST_KMOD=m
# CONFIG_TEST_MEMCAT_P is not set
CONFIG_TEST_LIVEPATCH=m
# CONFIG_TEST_STACKINIT is not set
# CONFIG_MEMTEST is not set
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN is not set
CONFIG_UBSAN_ALIGNMENT=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_EARLY_PRINTK_USB_XDBC is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_WX is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_FPU=y
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# CONFIG_UNWINDER_GUESS is not set
# end of Kernel hacking

--By57YlnFViWR/M0S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='kernel_selftests'
	export testcase='kernel_selftests'
	export category='functional'
	export need_memory='2G'
	export need_cpu=2
	export kernel_cmdline='erst_disable'
	export job_origin='/lkp/lkp/.src-20190619-100544/allot/cyclic:vm-p1:linux-devel:devel-hourly/vm-snb-4G/kernel_selftests.yaml'
	export queue_cmdline_keys='branch
commit
queue_at_least_once'
	export queue='validate'
	export testbox='vm-snb-4G-758'
	export tbox_group='vm-snb-4G'
	export submit_id='5d0af55f8636ad1eeed7c468'
	export job_file='/lkp/jobs/scheduled/vm-snb-4G-758/kernel_selftests-kselftests-00-debian-x86_64-2018-04-03.cgz-9fe4f05d-20190620-7918-1lzxd5-3.yaml'
	export id='82228cf5c481f0f0ebd0daa2f34757115d84df20'
	export queuer_version='/lkp/lkp/src'
	export arch='x86_64'
	export need_kernel_headers=true
	export need_kernel_selftests=true
	export need_kconfig='CONFIG_RUNTIME_TESTING_MENU=y
CONFIG_TEST_FIRMWARE
CONFIG_TEST_USER_COPY
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_NOTIFIER_ERROR_INJECTION
CONFIG_FTRACE=y
CONFIG_TEST_BITMAP
CONFIG_TEST_PRINTF
CONFIG_TEST_STATIC_KEYS
CONFIG_BPF_SYSCALL=y
CONFIG_NET_CLS_BPF=m
CONFIG_BPF_EVENTS=y
CONFIG_TEST_BPF=m
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HIST_TRIGGERS=y
CONFIG_EMBEDDED=y
CONFIG_GPIO_MOCKUP=y
CONFIG_USERFAULTFD=y
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_PSTORE=y
CONFIG_PSTORE_PMSG=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_RAM=m
CONFIG_EXPERT=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_EFIVAR_FS
CONFIG_TEST_KMOD=m
CONFIG_TEST_LKM=m
CONFIG_XFS_FS=m
CONFIG_TUN=m
CONFIG_BTRFS_FS=m
CONFIG_TEST_SYSCTL=m
CONFIG_BPF_STREAM_PARSER=y
CONFIG_CGROUP_BPF=y
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_NET_L3_MASTER_DEV=y
CONFIG_NET_VRF=y
CONFIG_NET_FOU=m
CONFIG_NET_FOU_IP_TUNNELS=y
CONFIG_MACSEC=y
CONFIG_X86_INTEL_MPX=y
CONFIG_RC_LOOPBACK
CONFIG_IPV6_SEG6_LWTUNNEL=y ~ v(4\.1[0-9]|4\.20|5\.)
CONFIG_LWTUNNEL=y
CONFIG_WW_MUTEX_SELFTEST=m ~ v(4\.1[1-9]|4\.20|5\.)
CONFIG_DRM_DEBUG_SELFTEST=m ~ v(4\.1[8-9]|4\.20|5\.)
CONFIG_TEST_LIVEPATCH=m ~ v(5\.[1-9])
CONFIG_LIRC=y
CONFIG_IR_SHARP_DECODER=m
CONFIG_ANDROID=y ~ v(3\.[3-9]|3\.1[0-9]|4\.|5\.)
CONFIG_ION=y ~ v(3\.1[4-9]|4\.|5\.)
CONFIG_ION_SYSTEM_HEAP=y ~ v(4\.1[2-9]|4\.20|5\.)
CONFIG_KVM_GUEST=y'
	export commit='9fe4f05d33eae0421a065e3bced38905b789c4e8'
	export ssh_base_port=23032
	export kconfig='x86_64-rhel-7.6'
	export compiler='gcc-7'
	export rootfs='debian-x86_64-2018-04-03.cgz'
	export enqueue_time='2019-06-20 10:54:25 +0800'
	export _id='5d0af5618636ad1eeed7c469'
	export _rt='/result/kernel_selftests/kselftests-00/vm-snb-4G/debian-x86_64-2018-04-03.cgz/x86_64-rhel-7.6/gcc-7/9fe4f05d33eae0421a065e3bced38905b789c4e8'
	export user='lkp'
	export head_commit='70ec980041484fb567ac49951e4a6a9ad90f40af'
	export base_commit='9e0babf2c06c73cda2c0cd37a1653d823adb40ec'
	export branch='linux-devel/devel-hourly-2019061915'
	export result_root='/result/kernel_selftests/kselftests-00/vm-snb-4G/debian-x86_64-2018-04-03.cgz/x86_64-rhel-7.6/gcc-7/9fe4f05d33eae0421a065e3bced38905b789c4e8/3'
	export scheduler_version='/lkp/lkp/.src-20190620-084613'
	export LKP_SERVER='inn'
	export max_uptime=3600
	export initrd='/osimage/debian/debian-x86_64-2018-04-03.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/jobs/scheduled/vm-snb-4G-758/kernel_selftests-kselftests-00-debian-x86_64-2018-04-03.cgz-9fe4f05d-20190620-7918-1lzxd5-3.yaml
ARCH=x86_64
kconfig=x86_64-rhel-7.6
branch=linux-devel/devel-hourly-2019061915
commit=9fe4f05d33eae0421a065e3bced38905b789c4e8
BOOT_IMAGE=/pkg/linux/x86_64-rhel-7.6/gcc-7/9fe4f05d33eae0421a065e3bced38905b789c4e8/vmlinuz-5.2.0-rc2-00603-g9fe4f05
erst_disable
max_uptime=3600
RESULT_ROOT=/result/kernel_selftests/kselftests-00/vm-snb-4G/debian-x86_64-2018-04-03.cgz/x86_64-rhel-7.6/gcc-7/9fe4f05d33eae0421a065e3bced38905b789c4e8/3
LKP_SERVER=inn
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
	export modules_initrd='/pkg/linux/x86_64-rhel-7.6/gcc-7/9fe4f05d33eae0421a065e3bced38905b789c4e8/modules.cgz'
	export bm_initrd='/osimage/deps/debian-x86_64-2018-04-03.cgz/run-ipconfig_2018-04-03.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/lkp_2019-04-24.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/rsync-rootfs_2018-04-03.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/kernel_selftests_2019-06-02.cgz,/osimage/pkg/debian-x86_64-2018-04-03.cgz/kernel_selftests-x86_64-3ab4436f688c_2019-06-02.cgz'
	export linux_headers_initrd='/pkg/linux/x86_64-rhel-7.6/gcc-7/9fe4f05d33eae0421a065e3bced38905b789c4e8/linux-headers.cgz'
	export linux_selftests_initrd='/pkg/linux/x86_64-rhel-7.6/gcc-7/9fe4f05d33eae0421a065e3bced38905b789c4e8/linux-selftests.cgz'
	export lkp_initrd='/lkp/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export repeat_to=4
	export schedule_notify_address=
	export model='qemu-system-x86_64 -enable-kvm -cpu SandyBridge'
	export nr_cpu=2
	export memory='4G'
	export hdd_partitions='/dev/vda /dev/vdb /dev/vdc /dev/vdd /dev/vde /dev/vdf'
	export swap_partitions='/dev/vdg'
	export queue_at_least_once=1
	export vm_tbox_group='vm-snb-4G'
	export nr_vm=76
	export vm_base_id=701
	export kernel='/pkg/linux/x86_64-rhel-7.6/gcc-7/9fe4f05d33eae0421a065e3bced38905b789c4e8/vmlinuz-5.2.0-rc2-00603-g9fe4f05'
	export dequeue_time='2019-06-20 10:54:35 +0800'
	export job_initrd='/lkp/jobs/scheduled/vm-snb-4G-758/kernel_selftests-kselftests-00-debian-x86_64-2018-04-03.cgz-9fe4f05d-20190620-7918-1lzxd5-3.cgz'

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

	run_test group='kselftests-00' $LKP_SRC/tests/wrapper kernel_selftests
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	$LKP_SRC/stats/wrapper kernel_selftests
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time kernel_selftests.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--By57YlnFViWR/M0S
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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
WVo=

--By57YlnFViWR/M0S
Content-Type: application/x-xz
Content-Disposition: attachment; filename="kernel_selftests.xz"
Content-Transfer-Encoding: base64

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

--By57YlnFViWR/M0S--
