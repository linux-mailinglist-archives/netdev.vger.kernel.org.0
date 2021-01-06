Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44492EBB02
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 09:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbhAFISM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 03:18:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:27224 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbhAFISM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 03:18:12 -0500
IronPort-SDR: C7dtjpo2Sh9bDqtyDCIebZ6VxgnDIE39wl4NMKvhuATjgD4pQ/6NohA+O/e5mp0VIP3LQa+mVy
 AO76Pd46Dtsw==
X-IronPort-AV: E=McAfee;i="6000,8403,9855"; a="173738285"
X-IronPort-AV: E=Sophos;i="5.78,479,1599548400"; 
   d="gz'50?scan'50,208,50";a="173738285"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 00:17:30 -0800
IronPort-SDR: ewJ1+L85CVLSTvwUyxa/42OL4Y2xQf96Re8MmXe5WU87DHXnUoB7WUmHCBZQGePj2qqpxeKYgu
 UtjQUReWtd0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,479,1599548400"; 
   d="gz'50?scan'50,208,50";a="361479889"
Received: from lkp-server02.sh.intel.com (HELO 4242b19f17ef) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 06 Jan 2021 00:17:26 -0800
Received: from kbuild by 4242b19f17ef with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kx40S-0008of-Hd; Wed, 06 Jan 2021 08:17:24 +0000
Date:   Wed, 6 Jan 2021 16:16:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     kbuild-all@lists.01.org, andrii@kernel.org, kernel-team@fb.com,
        Hao Luo <haoluo@google.com>
Subject: Re: [PATCH bpf-next  2/4] bpf: support BPF ksym variables in kernel
 modules
Message-ID: <202101061625.D0C0F3ZJ-lkp@intel.com>
References: <20210106064048.2554276-3-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <20210106064048.2554276-3-andrii@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrii,

I love your patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Andrii-Nakryiko/Support-kernel-module-ksym-variables/20210106-144531
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: nds32-defconfig (attached as .config)
compiler: nds32le-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/1dde2eabb1a7670d0e764e46dae1ef0a9abf0466
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Andrii-Nakryiko/Support-kernel-module-ksym-variables/20210106-144531
        git checkout 1dde2eabb1a7670d0e764e46dae1ef0a9abf0466
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=nds32 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   kernel/bpf/core.c:1350:12: warning: no previous prototype for 'bpf_probe_read_kernel' [-Wmissing-prototypes]
    1350 | u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
         |            ^~~~~~~~~~~~~~~~~~~~~
   In file included from kernel/bpf/core.c:21:
   kernel/bpf/core.c: In function '___bpf_prog_run':
   include/linux/filter.h:888:3: warning: cast between incompatible function types from 'u64 (*)(u64,  u64,  u64,  u64,  u64)' {aka 'long long unsigned int (*)(long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int)'} to 'u64 (*)(u64,  u64,  u64,  u64,  u64,  const struct bpf_insn *)' {aka 'long long unsigned int (*)(long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int,  const struct bpf_insn *)'} [-Wcast-function-type]
     888 |  ((u64 (*)(u64, u64, u64, u64, u64, const struct bpf_insn *)) \
         |   ^
   kernel/bpf/core.c:1518:13: note: in expansion of macro '__bpf_call_base_args'
    1518 |   BPF_R0 = (__bpf_call_base_args + insn->imm)(BPF_R1, BPF_R2,
         |             ^~~~~~~~~~~~~~~~~~~~
   kernel/bpf/core.c: At top level:
   kernel/bpf/core.c:1704:6: warning: no previous prototype for 'bpf_patch_call_args' [-Wmissing-prototypes]
    1704 | void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth)
         |      ^~~~~~~~~~~~~~~~~~~
   In file included from kernel/bpf/core.c:21:
   kernel/bpf/core.c: In function 'bpf_patch_call_args':
   include/linux/filter.h:888:3: warning: cast between incompatible function types from 'u64 (*)(u64,  u64,  u64,  u64,  u64)' {aka 'long long unsigned int (*)(long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int)'} to 'u64 (*)(u64,  u64,  u64,  u64,  u64,  const struct bpf_insn *)' {aka 'long long unsigned int (*)(long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int,  const struct bpf_insn *)'} [-Wcast-function-type]
     888 |  ((u64 (*)(u64, u64, u64, u64, u64, const struct bpf_insn *)) \
         |   ^
   kernel/bpf/core.c:1709:3: note: in expansion of macro '__bpf_call_base_args'
    1709 |   __bpf_call_base_args;
         |   ^~~~~~~~~~~~~~~~~~~~
   kernel/bpf/core.c: At top level:
   kernel/bpf/core.c:2102:6: warning: no previous prototype for '__bpf_free_used_maps' [-Wmissing-prototypes]
    2102 | void __bpf_free_used_maps(struct bpf_prog_aux *aux,
         |      ^~~~~~~~~~~~~~~~~~~~
>> kernel/bpf/core.c:2122:6: warning: no previous prototype for '__bpf_free_used_btfs' [-Wmissing-prototypes]
    2122 | void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
         |      ^~~~~~~~~~~~~~~~~~~~


vim +/__bpf_free_used_btfs +2122 kernel/bpf/core.c

  2121	
> 2122	void __bpf_free_used_btfs(struct bpf_prog_aux *aux,
  2123				  struct btf_mod_pair *used_btfs, u32 len)
  2124	{
  2125	#ifdef CONFIG_BPF_SYSCALL
  2126		struct btf_mod_pair *btf_mod;
  2127		u32 i;
  2128	
  2129		for (i = 0; i < len; i++) {
  2130			btf_mod = &used_btfs[i];
  2131			if (btf_mod->module)
  2132				module_put(btf_mod->module);
  2133			btf_put(btf_mod->btf);
  2134		}
  2135	#endif
  2136	}
  2137	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--n8g4imXOkfNTN/H1
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--n8g4imXOkfNTN/H1--
