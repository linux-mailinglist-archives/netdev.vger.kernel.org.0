Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 543744E206
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 10:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbfFUIhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 04:37:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:4222 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfFUIhC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 04:37:02 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jun 2019 01:36:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,399,1557212400"; 
   d="xz'?scan'208";a="162613060"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.6])
  by fmsmga007.fm.intel.com with ESMTP; 21 Jun 2019 01:36:47 -0700
Date:   Fri, 21 Jun 2019 16:36:58 +0800
From:   kernel test robot <rong.a.chen@intel.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andreas Steinmetz <ast@domdv.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Edward Cree <ecree@solarflare.com>, bpf <bpf@vger.kernel.org>,
        netdev@vger.kernel.org, lkp@01.org
Subject: 6c409a3aee: kernel_selftests.bpf.test_verifier.fail
Message-ID: <20190621083658.GT7221@shao2-debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gSSGYPGSs0dvYOj7"
Content-Disposition: inline
In-Reply-To: <20190618214028.y2qzbtonozr5cc7a@ast-mbp.dhcp.thefacebook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gSSGYPGSs0dvYOj7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

FYI, we noticed the following commit (built with gcc-7):

commit: 6c409a3aee945e50c6dd4109689f523dc0dc6fed ("[PATCH bpf-next] bpf: relax tracking of variable offset in packet pointers")
url: https://github.com/0day-ci/linux/commits/Alexei-Starovoitov/bpf-relax-tracking-of-variable-offset-in-packet-pointers/20190620-002512
base: https://git.kernel.org/cgit/linux/kernel/git/bpf/bpf-next.git master

in testcase: kernel_selftests
with following parameters:

	group: kselftests-00

test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
test-url: https://www.kernel.org/doc/Documentation/kselftest.txt


on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 4G

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):



If you fix the issue, kindly add following tag
Reported-by: kernel test robot <rong.a.chen@intel.com>


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
# #108/u calls: conditional call 3 OK
# #108/p calls: conditional call 3 OK
# #109/p calls: conditional call 4 OK
# #110/p calls: conditional call 5 OK
# #111/p calls: conditional call 6 OK
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
# #173/p calls: cross frame pruning OK
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
# #179/p loop (back-edge) OK
# #180/u loop2 (back-edge) OK
# #180/p loop2 (back-edge) OK
# #181/u conditional loop OK
# #181/p conditional loop OK
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
# #341/p direct packet access: test23 (x += pkt_ptr, 4) FAIL
# Unexpected success to load!
# verification time 17 usec
# stack depth 8
# processed 18 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 0
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
# #610/p bounded loop, count to 4 OK
# #611/p bounded loop, count to 20 OK
# #612/p bounded loop, count from positive unknown to 4 OK
# #613/p bounded loop, count from totally unknown to 4 OK
# #614/p bounded loop, count to 4 with equality OK
# #615/p bounded loop, start in the middle OK
# #616/p bounded loop containing a forward jump OK
# #617/p bounded loop that jumps out rather than in OK
# #618/p infinite loop after a conditional jump OK
# #619/p bounded recursion OK
# #620/p infinite loop in two jumps OK
# #621/p infinite loop: three-jump trick OK
# #622/p invalid direct packet write for LWT_IN OK
# #623/p invalid direct packet write for LWT_OUT OK
# #624/p direct packet write for LWT_XMIT OK
# #625/p direct packet read for LWT_IN OK
# #626/p direct packet read for LWT_OUT OK
# #627/p direct packet read for LWT_XMIT OK
# #628/p overlapping checks for direct packet access OK
# #629/p make headroom for LWT_XMIT OK
# #630/u invalid access of tc_classid for LWT_IN OK
# #630/p invalid access of tc_classid for LWT_IN OK
# #631/u invalid access of tc_classid for LWT_OUT OK
# #631/p invalid access of tc_classid for LWT_OUT OK
# #632/u invalid access of tc_classid for LWT_XMIT OK
# #632/p invalid access of tc_classid for LWT_XMIT OK
# #633/p check skb->tc_classid half load not permitted for lwt prog OK
# #634/u map in map access OK
# #634/p map in map access OK
# #635/u invalid inner map pointer OK
# #635/p invalid inner map pointer OK
# #636/u forgot null checking on the inner map pointer OK
# #636/p forgot null checking on the inner map pointer OK
# #637/p calls: two calls returning different map pointers for lookup (hash, array) OK
# #638/p calls: two calls returning different map pointers for lookup (hash, map in map) OK
# #639/u cond: two branches returning different map pointers for lookup (tail, tail) OK
# #639/p cond: two branches returning different map pointers for lookup (tail, tail) OK
# #640/u cond: two branches returning same map pointers for lookup (tail, tail) OK
# #640/p cond: two branches returning same map pointers for lookup (tail, tail) OK
# #641/u invalid map_fd for function call OK
# #641/p invalid map_fd for function call OK
# #642/u don't check return value before access OK
# #642/p don't check return value before access OK
# #643/u access memory with incorrect alignment OK
# #643/p access memory with incorrect alignment OK
# #644/u sometimes access memory with incorrect alignment OK
# #644/p sometimes access memory with incorrect alignment OK
# #645/u masking, test out of bounds 1 OK
# #645/p masking, test out of bounds 1 OK
# #646/u masking, test out of bounds 2 OK
# #646/p masking, test out of bounds 2 OK
# #647/u masking, test out of bounds 3 OK
# #647/p masking, test out of bounds 3 OK
# #648/u masking, test out of bounds 4 OK
# #648/p masking, test out of bounds 4 OK
# #649/u masking, test out of bounds 5 OK
# #649/p masking, test out of bounds 5 OK
# #650/u masking, test out of bounds 6 OK
# #650/p masking, test out of bounds 6 OK
# #651/u masking, test out of bounds 7 OK
# #651/p masking, test out of bounds 7 OK
# #652/u masking, test out of bounds 8 OK
# #652/p masking, test out of bounds 8 OK
# #653/u masking, test out of bounds 9 OK
# #653/p masking, test out of bounds 9 OK
# #654/u masking, test out of bounds 10 OK
# #654/p masking, test out of bounds 10 OK
# #655/u masking, test out of bounds 11 OK
# #655/p masking, test out of bounds 11 OK
# #656/u masking, test out of bounds 12 OK
# #656/p masking, test out of bounds 12 OK
# #657/u masking, test in bounds 1 OK
# #657/p masking, test in bounds 1 OK
# #658/u masking, test in bounds 2 OK
# #658/p masking, test in bounds 2 OK
# #659/u masking, test in bounds 3 OK
# #659/p masking, test in bounds 3 OK
# #660/u masking, test in bounds 4 OK
# #660/p masking, test in bounds 4 OK
# #661/u masking, test in bounds 5 OK
# #661/p masking, test in bounds 5 OK
# #662/u masking, test in bounds 6 OK
# #662/p masking, test in bounds 6 OK
# #663/u masking, test in bounds 7 OK
# #663/p masking, test in bounds 7 OK
# #664/u masking, test in bounds 8 OK
# #664/p masking, test in bounds 8 OK
# #665/p meta access, test1 OK
# #666/p meta access, test2 OK
# #667/p meta access, test3 OK
# #668/p meta access, test4 OK
# #669/p meta access, test5 OK
# #670/p meta access, test6 OK
# #671/p meta access, test7 OK
# #672/p meta access, test8 OK
# #673/p meta access, test9 OK
# #674/p meta access, test10 FAIL
# Unexpected success to load!
# verification time 29 usec
# stack depth 8
# processed 19 insns (limit 1000000) max_states_per_insn 0 total_states 1 peak_states 1 mark_read 0
# #675/p meta access, test11 OK
# #676/p meta access, test12 OK
# #677/p check bpf_perf_event_data->sample_period byte load permitted OK
# #678/p check bpf_perf_event_data->sample_period half load permitted OK
# #679/p check bpf_perf_event_data->sample_period word load permitted OK
# #680/p check bpf_perf_event_data->sample_period dword load permitted OK
# #681/p prevent map lookup in sockmap OK
# #682/p prevent map lookup in sockhash OK
# #683/p prevent map lookup in stack trace OK
# #684/u prevent map lookup in prog array OK
# #684/p prevent map lookup in prog array OK
# #685/p raw_stack: no skb_load_bytes OK
# #686/p raw_stack: skb_load_bytes, negative len OK
# #687/p raw_stack: skb_load_bytes, negative len 2 OK
# #688/p raw_stack: skb_load_bytes, zero len OK
# #689/p raw_stack: skb_load_bytes, no init OK
# #690/p raw_stack: skb_load_bytes, init OK
# #691/p raw_stack: skb_load_bytes, spilled regs around bounds OK
# #692/p raw_stack: skb_load_bytes, spilled regs corruption OK
# #693/p raw_stack: skb_load_bytes, spilled regs corruption 2 OK
# #694/p raw_stack: skb_load_bytes, spilled regs + data OK
# #695/p raw_stack: skb_load_bytes, invalid access 1 OK
# #696/p raw_stack: skb_load_bytes, invalid access 2 OK
# #697/p raw_stack: skb_load_bytes, invalid access 3 OK
# #698/p raw_stack: skb_load_bytes, invalid access 4 OK
# #699/p raw_stack: skb_load_bytes, invalid access 5 OK
# #700/p raw_stack: skb_load_bytes, invalid access 6 OK
# #701/p raw_stack: skb_load_bytes, large access OK
# #702/p raw_tracepoint_writable: reject variable offset OK
# #703/p reference tracking: leak potential reference OK
# #704/p reference tracking: leak potential reference to sock_common OK
# #705/p reference tracking: leak potential reference on stack OK
# #706/p reference tracking: leak potential reference on stack 2 OK
# #707/p reference tracking: zero potential reference OK
# #708/p reference tracking: zero potential reference to sock_common OK
# #709/p reference tracking: copy and zero potential references OK
# #710/p reference tracking: release reference without check OK
# #711/p reference tracking: release reference to sock_common without check OK
# #712/p reference tracking: release reference OK
# #713/p reference tracking: release reference to sock_common OK
# #714/p reference tracking: release reference 2 OK
# #715/p reference tracking: release reference twice OK
# #716/p reference tracking: release reference twice inside branch OK
# #717/p reference tracking: alloc, check, free in one subbranch OK
# #718/p reference tracking: alloc, check, free in both subbranches OK
# #719/p reference tracking in call: free reference in subprog OK
# #720/p reference tracking in call: free reference in subprog and outside OK
# #721/p reference tracking in call: alloc & leak reference in subprog OK
# #722/p reference tracking in call: alloc in subprog, release outside OK
# #723/p reference tracking in call: sk_ptr leak into caller stack OK
# #724/p reference tracking in call: sk_ptr spill into caller stack OK
# #725/p reference tracking: allow LD_ABS OK
# #726/p reference tracking: forbid LD_ABS while holding reference OK
# #727/p reference tracking: allow LD_IND OK
# #728/p reference tracking: forbid LD_IND while holding reference OK
# #729/p reference tracking: check reference or tail call OK
# #730/p reference tracking: release reference then tail call OK
# #731/p reference tracking: leak possible reference over tail call OK
# #732/p reference tracking: leak checked reference over tail call OK
# #733/p reference tracking: mangle and release sock_or_null OK
# #734/p reference tracking: mangle and release sock OK
# #735/p reference tracking: access member OK
# #736/p reference tracking: write to member OK
# #737/p reference tracking: invalid 64-bit access of member OK
# #738/p reference tracking: access after release OK
# #739/p reference tracking: direct access for lookup OK
# #740/p reference tracking: use ptr from bpf_tcp_sock() after release OK
# #741/p reference tracking: use ptr from bpf_sk_fullsock() after release OK
# #742/p reference tracking: use ptr from bpf_sk_fullsock(tp) after release OK
# #743/p reference tracking: use sk after bpf_sk_release(tp) OK
# #744/p reference tracking: use ptr from bpf_get_listener_sock() after bpf_sk_release(sk) OK
# #745/p reference tracking: bpf_sk_release(listen_sk) OK
# #746/p reference tracking: tp->snd_cwnd after bpf_sk_fullsock(sk) and bpf_tcp_sock(sk) OK
# #747/u runtime/jit: tail_call within bounds, prog once OK
# #747/p runtime/jit: tail_call within bounds, prog once OK
# #748/u runtime/jit: tail_call within bounds, prog loop OK
# #748/p runtime/jit: tail_call within bounds, prog loop OK
# #749/u runtime/jit: tail_call within bounds, no prog OK
# #749/p runtime/jit: tail_call within bounds, no prog OK
# #750/u runtime/jit: tail_call out of bounds OK
# #750/p runtime/jit: tail_call out of bounds OK
# #751/u runtime/jit: pass negative index to tail_call OK
# #751/p runtime/jit: pass negative index to tail_call OK
# #752/u runtime/jit: pass > 32bit index to tail_call OK
# #752/p runtime/jit: pass > 32bit index to tail_call OK
# #753/p scale: scale test 1 OK
# #754/p scale: scale test 2 OK
# #755/u pointer/scalar confusion in state equality check (way 1) OK
# #755/p pointer/scalar confusion in state equality check (way 1) OK
# #756/u pointer/scalar confusion in state equality check (way 2) OK
# #756/p pointer/scalar confusion in state equality check (way 2) OK
# #757/p liveness pruning and write screening OK
# #758/u varlen_map_value_access pruning OK
# #758/p varlen_map_value_access pruning OK
# #759/p search pruning: all branches should be verified (nop operation) OK
# #760/p search pruning: all branches should be verified (invalid stack access) OK
# #761/u allocated_stack OK
# #761/p allocated_stack OK
# #762/u skb->sk: no NULL check OK
# #762/p skb->sk: no NULL check OK
# #763/u skb->sk: sk->family [non fullsock field] OK
# #763/p skb->sk: sk->family [non fullsock field] OK
# #764/u skb->sk: sk->type [fullsock field] OK
# #764/p skb->sk: sk->type [fullsock field] OK
# #765/u bpf_sk_fullsock(skb->sk): no !skb->sk check OK
# #765/p bpf_sk_fullsock(skb->sk): no !skb->sk check OK
# #766/u sk_fullsock(skb->sk): no NULL check on ret OK
# #766/p sk_fullsock(skb->sk): no NULL check on ret OK
# #767/u sk_fullsock(skb->sk): sk->type [fullsock field] OK
# #767/p sk_fullsock(skb->sk): sk->type [fullsock field] OK
# #768/u sk_fullsock(skb->sk): sk->family [non fullsock field] OK
# #768/p sk_fullsock(skb->sk): sk->family [non fullsock field] OK
# #769/u sk_fullsock(skb->sk): sk->state [narrow load] OK
# #769/p sk_fullsock(skb->sk): sk->state [narrow load] OK
# #770/u sk_fullsock(skb->sk): sk->dst_port [narrow load] OK
# #770/p sk_fullsock(skb->sk): sk->dst_port [narrow load] OK
# #771/u sk_fullsock(skb->sk): sk->dst_port [load 2nd byte] OK
# #771/p sk_fullsock(skb->sk): sk->dst_port [load 2nd byte] OK
# #772/u sk_fullsock(skb->sk): sk->dst_ip6 [load 2nd byte] OK
# #772/p sk_fullsock(skb->sk): sk->dst_ip6 [load 2nd byte] OK
# #773/u sk_fullsock(skb->sk): sk->type [narrow load] OK
# #773/p sk_fullsock(skb->sk): sk->type [narrow load] OK
# #774/u sk_fullsock(skb->sk): sk->protocol [narrow load] OK
# #774/p sk_fullsock(skb->sk): sk->protocol [narrow load] OK
# #775/u sk_fullsock(skb->sk): beyond last field OK
# #775/p sk_fullsock(skb->sk): beyond last field OK
# #776/u bpf_tcp_sock(skb->sk): no !skb->sk check OK
# #776/p bpf_tcp_sock(skb->sk): no !skb->sk check OK
# #777/u bpf_tcp_sock(skb->sk): no NULL check on ret OK
# #777/p bpf_tcp_sock(skb->sk): no NULL check on ret OK
# #778/u bpf_tcp_sock(skb->sk): tp->snd_cwnd OK
# #778/p bpf_tcp_sock(skb->sk): tp->snd_cwnd OK
# #779/u bpf_tcp_sock(skb->sk): tp->bytes_acked OK
# #779/p bpf_tcp_sock(skb->sk): tp->bytes_acked OK
# #780/u bpf_tcp_sock(skb->sk): beyond last field OK
# #780/p bpf_tcp_sock(skb->sk): beyond last field OK
# #781/u bpf_tcp_sock(bpf_sk_fullsock(skb->sk)): tp->snd_cwnd OK
# #781/p bpf_tcp_sock(bpf_sk_fullsock(skb->sk)): tp->snd_cwnd OK
# #782/p bpf_sk_release(skb->sk) OK
# #783/p bpf_sk_release(bpf_sk_fullsock(skb->sk)) OK
# #784/p bpf_sk_release(bpf_tcp_sock(skb->sk)) OK
# #785/p sk_storage_get(map, skb->sk, NULL, 0): value == NULL OK
# #786/p sk_storage_get(map, skb->sk, 1, 1): value == 1 OK
# #787/p sk_storage_get(map, skb->sk, &stack_value, 1): stack_value OK
# #788/p sk_storage_get(map, skb->sk, &stack_value, 1): partially init stack_value OK
# #789/p bpf_map_lookup_elem(smap, &key) OK
# #790/p bpf_map_lookup_elem(xskmap, &key); xs->queue_id SKIP (unsupported map type 17)
# #791/u check valid spill/fill OK
# #791/p check valid spill/fill OK
# #792/u check valid spill/fill, skb mark OK
# #792/p check valid spill/fill, skb mark OK
# #793/u check corrupted spill/fill OK
# #793/p check corrupted spill/fill OK
# #794/u check corrupted spill/fill, LSB OK
# #794/p check corrupted spill/fill, LSB OK
# #795/u check corrupted spill/fill, MSB OK
# #795/p check corrupted spill/fill, MSB OK
# #796/u spin_lock: test1 success OK
# #796/p spin_lock: test1 success OK
# #797/u spin_lock: test2 direct ld/st OK
# #797/p spin_lock: test2 direct ld/st OK
# #798/u spin_lock: test3 direct ld/st OK
# #798/p spin_lock: test3 direct ld/st OK
# #799/u spin_lock: test4 direct ld/st OK
# #799/p spin_lock: test4 direct ld/st OK
# #800/u spin_lock: test5 call within a locked region OK
# #800/p spin_lock: test5 call within a locked region OK
# #801/u spin_lock: test6 missing unlock OK
# #801/p spin_lock: test6 missing unlock OK
# #802/u spin_lock: test7 unlock without lock OK
# #802/p spin_lock: test7 unlock without lock OK
# #803/u spin_lock: test8 double lock OK
# #803/p spin_lock: test8 double lock OK
# #804/u spin_lock: test9 different lock OK
# #804/p spin_lock: test9 different lock OK
# #805/u spin_lock: test10 lock in subprog without unlock OK
# #805/p spin_lock: test10 lock in subprog without unlock OK
# #806/p spin_lock: test11 ld_abs under lock OK
# #807/u PTR_TO_STACK store/load OK
# #807/p PTR_TO_STACK store/load OK
# #808/u PTR_TO_STACK store/load - bad alignment on off OK
# #808/p PTR_TO_STACK store/load - bad alignment on off OK
# #809/u PTR_TO_STACK store/load - bad alignment on reg OK
# #809/p PTR_TO_STACK store/load - bad alignment on reg OK
# #810/u PTR_TO_STACK store/load - out of bounds low OK
# #810/p PTR_TO_STACK store/load - out of bounds low OK
# #811/u PTR_TO_STACK store/load - out of bounds high OK
# #811/p PTR_TO_STACK store/load - out of bounds high OK
# #812/u PTR_TO_STACK check high 1 OK
# #812/p PTR_TO_STACK check high 1 OK
# #813/u PTR_TO_STACK check high 2 OK
# #813/p PTR_TO_STACK check high 2 OK
# #814/u PTR_TO_STACK check high 3 OK
# #814/p PTR_TO_STACK check high 3 OK
# #815/u PTR_TO_STACK check high 4 OK
# #815/p PTR_TO_STACK check high 4 OK
# #816/u PTR_TO_STACK check high 5 OK
# #816/p PTR_TO_STACK check high 5 OK
# #817/u PTR_TO_STACK check high 6 OK
# #817/p PTR_TO_STACK check high 6 OK
# #818/u PTR_TO_STACK check high 7 OK
# #818/p PTR_TO_STACK check high 7 OK
# #819/u PTR_TO_STACK check low 1 OK
# #819/p PTR_TO_STACK check low 1 OK
# #820/u PTR_TO_STACK check low 2 OK
# #820/p PTR_TO_STACK check low 2 OK
# #821/u PTR_TO_STACK check low 3 OK
# #821/p PTR_TO_STACK check low 3 OK
# #822/u PTR_TO_STACK check low 4 OK
# #822/p PTR_TO_STACK check low 4 OK
# #823/u PTR_TO_STACK check low 5 OK
# #823/p PTR_TO_STACK check low 5 OK
# #824/u PTR_TO_STACK check low 6 OK
# #824/p PTR_TO_STACK check low 6 OK
# #825/u PTR_TO_STACK check low 7 OK
# #825/p PTR_TO_STACK check low 7 OK
# #826/u PTR_TO_STACK mixed reg/k, 1 OK
# #826/p PTR_TO_STACK mixed reg/k, 1 OK
# #827/u PTR_TO_STACK mixed reg/k, 2 OK
# #827/p PTR_TO_STACK mixed reg/k, 2 OK
# #828/u PTR_TO_STACK mixed reg/k, 3 OK
# #828/p PTR_TO_STACK mixed reg/k, 3 OK
# #829/u PTR_TO_STACK reg OK
# #829/p PTR_TO_STACK reg OK
# #830/u stack pointer arithmetic OK
# #830/p stack pointer arithmetic OK
# #831/u read uninitialized register OK
# #831/p read uninitialized register OK
# #832/u read invalid register OK
# #832/p read invalid register OK
# #833/u program doesn't init R0 before exit OK
# #833/p program doesn't init R0 before exit OK
# #834/u program doesn't init R0 before exit in all branches OK
# #834/p program doesn't init R0 before exit in all branches OK
# #835/u unpriv: return pointer OK
# #835/p unpriv: return pointer OK
# #836/u unpriv: add const to pointer OK
# #836/p unpriv: add const to pointer OK
# #837/u unpriv: add pointer to pointer OK
# #837/p unpriv: add pointer to pointer OK
# #838/u unpriv: neg pointer OK
# #838/p unpriv: neg pointer OK
# #839/u unpriv: cmp pointer with const OK
# #839/p unpriv: cmp pointer with const OK
# #840/u unpriv: cmp pointer with pointer OK
# #840/p unpriv: cmp pointer with pointer OK
# #841/p unpriv: check that printk is disallowed OK
# #842/u unpriv: pass pointer to helper function OK
# #842/p unpriv: pass pointer to helper function OK
# #843/u unpriv: indirectly pass pointer on stack to helper function OK
# #843/p unpriv: indirectly pass pointer on stack to helper function OK
# #844/u unpriv: mangle pointer on stack 1 OK
# #844/p unpriv: mangle pointer on stack 1 OK
# #845/u unpriv: mangle pointer on stack 2 OK
# #845/p unpriv: mangle pointer on stack 2 OK
# #846/u unpriv: read pointer from stack in small chunks OK
# #846/p unpriv: read pointer from stack in small chunks OK
# #847/u unpriv: write pointer into ctx OK
# #847/p unpriv: write pointer into ctx OK
# #848/u unpriv: spill/fill of ctx OK
# #848/p unpriv: spill/fill of ctx OK
# #849/p unpriv: spill/fill of ctx 2 OK
# #850/p unpriv: spill/fill of ctx 3 OK
# #851/p unpriv: spill/fill of ctx 4 OK
# #852/p unpriv: spill/fill of different pointers stx OK
# #853/p unpriv: spill/fill of different pointers stx - ctx and sock OK
# #854/p unpriv: spill/fill of different pointers stx - leak sock OK
# #855/p unpriv: spill/fill of different pointers stx - sock and ctx (read) OK
# #856/p unpriv: spill/fill of different pointers stx - sock and ctx (write) OK
# #857/p unpriv: spill/fill of different pointers ldx OK
# #858/u unpriv: write pointer into map elem value OK
# #858/p unpriv: write pointer into map elem value OK
# #859/u alu32: mov u32 const OK
# #859/p alu32: mov u32 const OK
# #860/u unpriv: partial copy of pointer OK
# #860/p unpriv: partial copy of pointer OK
# #861/u unpriv: pass pointer to tail_call OK
# #861/p unpriv: pass pointer to tail_call OK
# #862/u unpriv: cmp map pointer with zero OK
# #862/p unpriv: cmp map pointer with zero OK
# #863/u unpriv: write into frame pointer OK
# #863/p unpriv: write into frame pointer OK
# #864/u unpriv: spill/fill frame pointer OK
# #864/p unpriv: spill/fill frame pointer OK
# #865/u unpriv: cmp of frame pointer OK
# #865/p unpriv: cmp of frame pointer OK
# #866/u unpriv: adding of fp OK
# #866/p unpriv: adding of fp OK
# #867/u unpriv: cmp of stack pointer OK
# #867/p unpriv: cmp of stack pointer OK
# #868/u map element value store of cleared call register OK
# #868/p map element value store of cleared call register OK
# #869/u map element value with unaligned store OK
# #869/p map element value with unaligned store OK
# #870/u map element value with unaligned load OK
# #870/p map element value with unaligned load OK
# #871/u map element value is preserved across register spilling OK
# #871/p map element value is preserved across register spilling OK
# #872/u map element value is preserved across register spilling OK
# #872/p map element value is preserved across register spilling OK
# #873/u map element value or null is marked on register spilling OK
# #873/p map element value or null is marked on register spilling OK
# #874/u map element value illegal alu op, 1 OK
# #874/p map element value illegal alu op, 1 OK
# #875/u map element value illegal alu op, 2 OK
# #875/p map element value illegal alu op, 2 OK
# #876/u map element value illegal alu op, 3 OK
# #876/p map element value illegal alu op, 3 OK
# #877/u map element value illegal alu op, 4 OK
# #877/p map element value illegal alu op, 4 OK
# #878/u map element value illegal alu op, 5 OK
# #878/p map element value illegal alu op, 5 OK
# #879/p multiple registers share map_lookup_elem result OK
# #880/p alu ops on ptr_to_map_value_or_null, 1 OK
# #881/p alu ops on ptr_to_map_value_or_null, 2 OK
# #882/p alu ops on ptr_to_map_value_or_null, 3 OK
# #883/p invalid memory access with multiple map_lookup_elem calls OK
# #884/p valid indirect map_lookup_elem access with 2nd lookup in branch OK
# #885/u invalid map access from else condition OK
# #885/p invalid map access from else condition OK
# #886/u map access: known scalar += value_ptr from different maps OK
# #886/p map access: known scalar += value_ptr from different maps OK
# #887/u map access: value_ptr -= known scalar from different maps OK
# #887/p map access: value_ptr -= known scalar from different maps OK
# #888/u map access: known scalar += value_ptr from different maps, but same value properties OK
# #888/p map access: known scalar += value_ptr from different maps, but same value properties OK
# #889/u map access: mixing value pointer and scalar, 1 OK
# #889/p map access: mixing value pointer and scalar, 1 OK
# #890/u map access: mixing value pointer and scalar, 2 OK
# #890/p map access: mixing value pointer and scalar, 2 OK
# #891/u sanitation: alu with different scalars 1 OK
# #891/p sanitation: alu with different scalars 1 OK
# #892/u sanitation: alu with different scalars 2 OK
# #892/p sanitation: alu with different scalars 2 OK
# #893/u sanitation: alu with different scalars 3 OK
# #893/p sanitation: alu with different scalars 3 OK
# #894/u map access: value_ptr += known scalar, upper oob arith, test 1 OK
# #894/p map access: value_ptr += known scalar, upper oob arith, test 1 OK
# #895/u map access: value_ptr += known scalar, upper oob arith, test 2 OK
# #895/p map access: value_ptr += known scalar, upper oob arith, test 2 OK
# #896/u map access: value_ptr += known scalar, upper oob arith, test 3 OK
# #896/p map access: value_ptr += known scalar, upper oob arith, test 3 OK
# #897/u map access: value_ptr -= known scalar, lower oob arith, test 1 OK
# #897/p map access: value_ptr -= known scalar, lower oob arith, test 1 OK
# #898/u map access: value_ptr -= known scalar, lower oob arith, test 2 OK
# #898/p map access: value_ptr -= known scalar, lower oob arith, test 2 OK
# #899/u map access: value_ptr -= known scalar, lower oob arith, test 3 OK
# #899/p map access: value_ptr -= known scalar, lower oob arith, test 3 OK
# #900/u map access: known scalar += value_ptr OK
# #900/p map access: known scalar += value_ptr OK
# #901/u map access: value_ptr += known scalar, 1 OK
# #901/p map access: value_ptr += known scalar, 1 OK
# #902/u map access: value_ptr += known scalar, 2 OK
# #902/p map access: value_ptr += known scalar, 2 OK
# #903/u map access: value_ptr += known scalar, 3 OK
# #903/p map access: value_ptr += known scalar, 3 OK
# #904/u map access: value_ptr += known scalar, 4 OK
# #904/p map access: value_ptr += known scalar, 4 OK
# #905/u map access: value_ptr += known scalar, 5 OK
# #905/p map access: value_ptr += known scalar, 5 OK
# #906/u map access: value_ptr += known scalar, 6 OK
# #906/p map access: value_ptr += known scalar, 6 OK
# #907/u map access: unknown scalar += value_ptr, 1 OK
# #907/p map access: unknown scalar += value_ptr, 1 OK
# #908/u map access: unknown scalar += value_ptr, 2 OK
# #908/p map access: unknown scalar += value_ptr, 2 OK
# #909/u map access: unknown scalar += value_ptr, 3 OK
# #909/p map access: unknown scalar += value_ptr, 3 OK
# #910/u map access: unknown scalar += value_ptr, 4 OK
# #910/p map access: unknown scalar += value_ptr, 4 OK
# #911/u map access: value_ptr += unknown scalar, 1 OK
# #911/p map access: value_ptr += unknown scalar, 1 OK
# #912/u map access: value_ptr += unknown scalar, 2 OK
# #912/p map access: value_ptr += unknown scalar, 2 OK
# #913/u map access: value_ptr += unknown scalar, 3 OK
# #913/p map access: value_ptr += unknown scalar, 3 OK
# #914/u map access: value_ptr += value_ptr OK
# #914/p map access: value_ptr += value_ptr OK
# #915/u map access: known scalar -= value_ptr OK
# #915/p map access: known scalar -= value_ptr OK
# #916/u map access: value_ptr -= known scalar OK
# #916/p map access: value_ptr -= known scalar OK
# #917/u map access: value_ptr -= known scalar, 2 OK
# #917/p map access: value_ptr -= known scalar, 2 OK
# #918/u map access: unknown scalar -= value_ptr OK
# #918/p map access: unknown scalar -= value_ptr OK
# #919/u map access: value_ptr -= unknown scalar OK
# #919/p map access: value_ptr -= unknown scalar OK
# #920/u map access: value_ptr -= unknown scalar, 2 OK
# #920/p map access: value_ptr -= unknown scalar, 2 OK
# #921/u map access: value_ptr -= value_ptr OK
# #921/p map access: value_ptr -= value_ptr OK
# #922/p variable-offset ctx access OK
# #923/p variable-offset stack access OK
# #924/p indirect variable-offset stack access, unbounded OK
# #925/p indirect variable-offset stack access, max out of bound OK
# #926/p indirect variable-offset stack access, min out of bound OK
# #927/p indirect variable-offset stack access, max_off+size > max_initialized OK
# #928/p indirect variable-offset stack access, min_off < min_initialized OK
# #929/u indirect variable-offset stack access, priv vs unpriv OK
# #929/p indirect variable-offset stack access, priv vs unpriv OK
# #930/p indirect variable-offset stack access, uninitialized OK
# #931/p indirect variable-offset stack access, ok OK
# #932/p xadd/w check unaligned stack OK
# #933/p xadd/w check unaligned map OK
# #934/p xadd/w check unaligned pkt OK
# #935/p xadd/w check whether src/dst got mangled, 1 OK
# #936/p xadd/w check whether src/dst got mangled, 2 OK
# #937/p XDP, using ifindex from netdev OK
# #938/p XDP pkt read, pkt_end mangling, bad access 1 OK
# #939/p XDP pkt read, pkt_end mangling, bad access 2 OK
# #940/p XDP pkt read, pkt_data' > pkt_end, good access OK
# #941/p XDP pkt read, pkt_data' > pkt_end, bad access 1 OK
# #942/p XDP pkt read, pkt_data' > pkt_end, bad access 2 OK
# #943/p XDP pkt read, pkt_end > pkt_data', good access OK
# #944/p XDP pkt read, pkt_end > pkt_data', bad access 1 OK
# #945/p XDP pkt read, pkt_end > pkt_data', bad access 2 OK
# #946/p XDP pkt read, pkt_data' < pkt_end, good access OK
# #947/p XDP pkt read, pkt_data' < pkt_end, bad access 1 OK
# #948/p XDP pkt read, pkt_data' < pkt_end, bad access 2 OK
# #949/p XDP pkt read, pkt_end < pkt_data', good access OK
# #950/p XDP pkt read, pkt_end < pkt_data', bad access 1 OK
# #951/p XDP pkt read, pkt_end < pkt_data', bad access 2 OK
# #952/p XDP pkt read, pkt_data' >= pkt_end, good access OK
# #953/p XDP pkt read, pkt_data' >= pkt_end, bad access 1 OK
# #954/p XDP pkt read, pkt_data' >= pkt_end, bad access 2 OK
# #955/p XDP pkt read, pkt_end >= pkt_data', good access OK
# #956/p XDP pkt read, pkt_end >= pkt_data', bad access 1 OK
# #957/p XDP pkt read, pkt_end >= pkt_data', bad access 2 OK
# #958/p XDP pkt read, pkt_data' <= pkt_end, good access OK
# #959/p XDP pkt read, pkt_data' <= pkt_end, bad access 1 OK
# #960/p XDP pkt read, pkt_data' <= pkt_end, bad access 2 OK
# #961/p XDP pkt read, pkt_end <= pkt_data', good access OK
# #962/p XDP pkt read, pkt_end <= pkt_data', bad access 1 OK
# #963/p XDP pkt read, pkt_end <= pkt_data', bad access 2 OK
# #964/p XDP pkt read, pkt_meta' > pkt_data, good access OK
# #965/p XDP pkt read, pkt_meta' > pkt_data, bad access 1 OK
# #966/p XDP pkt read, pkt_meta' > pkt_data, bad access 2 OK
# #967/p XDP pkt read, pkt_data > pkt_meta', good access OK
# #968/p XDP pkt read, pkt_data > pkt_meta', bad access 1 OK
# #969/p XDP pkt read, pkt_data > pkt_meta', bad access 2 OK
# #970/p XDP pkt read, pkt_meta' < pkt_data, good access OK
# #971/p XDP pkt read, pkt_meta' < pkt_data, bad access 1 OK
# #972/p XDP pkt read, pkt_meta' < pkt_data, bad access 2 OK
# #973/p XDP pkt read, pkt_data < pkt_meta', good access OK
# #974/p XDP pkt read, pkt_data < pkt_meta', bad access 1 OK
# #975/p XDP pkt read, pkt_data < pkt_meta', bad access 2 OK
# #976/p XDP pkt read, pkt_meta' >= pkt_data, good access OK
# #977/p XDP pkt read, pkt_meta' >= pkt_data, bad access 1 OK
# #978/p XDP pkt read, pkt_meta' >= pkt_data, bad access 2 OK
# #979/p XDP pkt read, pkt_data >= pkt_meta', good access OK
# #980/p XDP pkt read, pkt_data >= pkt_meta', bad access 1 OK
# #981/p XDP pkt read, pkt_data >= pkt_meta', bad access 2 OK
# #982/p XDP pkt read, pkt_meta' <= pkt_data, good access OK
# #983/p XDP pkt read, pkt_meta' <= pkt_data, bad access 1 OK
# #984/p XDP pkt read, pkt_meta' <= pkt_data, bad access 2 OK
# #985/p XDP pkt read, pkt_data <= pkt_meta', good access OK
# #986/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 OK
# #987/p XDP pkt read, pkt_data <= pkt_meta', bad access 2 OK
# Summary: 1449 PASSED, 1 SKIPPED, 2 FAILED
not ok 1 selftests: bpf: test_verifier

To reproduce:

        # build kernel
	cd linux
	cp config-5.2.0-rc2-00624-g6c409a3a .config
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


--gSSGYPGSs0dvYOj7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-5.2.0-rc2-00624-g6c409a3a"

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
CONFIG_USB_SERIAL_TI=m
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

--gSSGYPGSs0dvYOj7
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
	export job_origin='/lkp/lkp/.src-20190619-163124/allot/cyclic:vm-p1:linux-devel:devel-hourly/vm-snb-4G/kernel_selftests.yaml'
	export queue_cmdline_keys='branch
commit'
	export queue='bisect'
	export testbox='vm-snb-4G-724'
	export tbox_group='vm-snb-4G'
	export submit_id='5d0bde64925dbc0dbadcaa6d'
	export job_file='/lkp/jobs/scheduled/vm-snb-4G-724/kernel_selftests-kselftests-00-debian-x86_64-2018-04-03.cgz-6c409a3aee-20190621-3514-1portse-1.yaml'
	export id='77f15580345108c1d9982d9f35e5e3b813c8e5ad'
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
	export commit='6c409a3aee945e50c6dd4109689f523dc0dc6fed'
	export ssh_base_port=23032
	export kconfig='x86_64-rhel-7.6'
	export compiler='gcc-7'
	export rootfs='debian-x86_64-2018-04-03.cgz'
	export enqueue_time='2019-06-21 03:28:41 +0800'
	export _id='5d0bde69925dbc0dbadcaa6e'
	export _rt='/result/kernel_selftests/kselftests-00/vm-snb-4G/debian-x86_64-2018-04-03.cgz/x86_64-rhel-7.6/gcc-7/6c409a3aee945e50c6dd4109689f523dc0dc6fed'
	export user='lkp'
	export head_commit='e21f6bbbcb41e275720c51d78091c4bb12859a87'
	export base_commit='9e0babf2c06c73cda2c0cd37a1653d823adb40ec'
	export branch='linux-devel/devel-hourly-2019062009'
	export result_root='/result/kernel_selftests/kselftests-00/vm-snb-4G/debian-x86_64-2018-04-03.cgz/x86_64-rhel-7.6/gcc-7/6c409a3aee945e50c6dd4109689f523dc0dc6fed/3'
	export scheduler_version='/lkp/lkp/.src-20190620-163700'
	export LKP_SERVER='inn'
	export max_uptime=3600
	export initrd='/osimage/debian/debian-x86_64-2018-04-03.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/jobs/scheduled/vm-snb-4G-724/kernel_selftests-kselftests-00-debian-x86_64-2018-04-03.cgz-6c409a3aee-20190621-3514-1portse-1.yaml
ARCH=x86_64
kconfig=x86_64-rhel-7.6
branch=linux-devel/devel-hourly-2019062009
commit=6c409a3aee945e50c6dd4109689f523dc0dc6fed
BOOT_IMAGE=/pkg/linux/x86_64-rhel-7.6/gcc-7/6c409a3aee945e50c6dd4109689f523dc0dc6fed/vmlinuz-5.2.0-rc2-00624-g6c409a3a
erst_disable
max_uptime=3600
RESULT_ROOT=/result/kernel_selftests/kselftests-00/vm-snb-4G/debian-x86_64-2018-04-03.cgz/x86_64-rhel-7.6/gcc-7/6c409a3aee945e50c6dd4109689f523dc0dc6fed/3
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
	export modules_initrd='/pkg/linux/x86_64-rhel-7.6/gcc-7/6c409a3aee945e50c6dd4109689f523dc0dc6fed/modules.cgz'
	export bm_initrd='/osimage/deps/debian-x86_64-2018-04-03.cgz/run-ipconfig_2018-04-03.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/lkp_2019-04-24.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/rsync-rootfs_2018-04-03.cgz,/osimage/deps/debian-x86_64-2018-04-03.cgz/kernel_selftests_2019-06-02.cgz,/osimage/pkg/debian-x86_64-2018-04-03.cgz/kernel_selftests-x86_64-3ab4436f688c_2019-06-02.cgz'
	export linux_headers_initrd='/pkg/linux/x86_64-rhel-7.6/gcc-7/6c409a3aee945e50c6dd4109689f523dc0dc6fed/linux-headers.cgz'
	export linux_selftests_initrd='/pkg/linux/x86_64-rhel-7.6/gcc-7/6c409a3aee945e50c6dd4109689f523dc0dc6fed/linux-selftests.cgz'
	export lkp_initrd='/lkp/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export schedule_notify_address=
	export model='qemu-system-x86_64 -enable-kvm -cpu SandyBridge'
	export nr_cpu=2
	export memory='4G'
	export hdd_partitions='/dev/vda /dev/vdb /dev/vdc /dev/vdd /dev/vde /dev/vdf'
	export swap_partitions='/dev/vdg'
	export vm_tbox_group='vm-snb-4G'
	export nr_vm=76
	export vm_base_id=701
	export kernel='/pkg/linux/x86_64-rhel-7.6/gcc-7/6c409a3aee945e50c6dd4109689f523dc0dc6fed/vmlinuz-5.2.0-rc2-00624-g6c409a3a'
	export dequeue_time='2019-06-21 03:44:34 +0800'
	export job_initrd='/lkp/jobs/scheduled/vm-snb-4G-724/kernel_selftests-kselftests-00-debian-x86_64-2018-04-03.cgz-6c409a3aee-20190621-3514-1portse-1.cgz'

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

--gSSGYPGSs0dvYOj7
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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

--gSSGYPGSs0dvYOj7
Content-Type: application/x-xz
Content-Disposition: attachment; filename="kernel_selftests.xz"
Content-Transfer-Encoding: base64

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
scRn+wIAAAAABFla

--gSSGYPGSs0dvYOj7--
