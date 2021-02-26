Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646B13264B0
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 16:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhBZPYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 10:24:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:58761 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhBZPYd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 10:24:33 -0500
IronPort-SDR: lCs7hS8dr0vu5vOsSg9zrOZTBgkvKx57OsvWtGJrIUtJK/Qy5Etfjjx6p3fAeS6MMJEpvvtOMh
 v7s+rgGBkihA==
X-IronPort-AV: E=McAfee;i="6000,8403,9907"; a="186023505"
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="gz'50?scan'50,208,50";a="186023505"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 07:23:48 -0800
IronPort-SDR: oqHGSC9ORO+yWZ+DATwmInv9Ylc92gOWQFr8i+lFjOrBsJ1fPPsprsgVFos6HnD9DK8iwIh6Cw
 xkrtG8eIZU9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="gz'50?scan'50,208,50";a="382039868"
Received: from lkp-server01.sh.intel.com (HELO 16660e54978b) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 26 Feb 2021 07:23:44 -0800
Received: from kbuild by 16660e54978b with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lFexz-0003IR-QH; Fri, 26 Feb 2021 15:23:43 +0000
Date:   Fri, 26 Feb 2021 23:23:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        maciej.fijalkowski@intel.com, hawk@kernel.org, toke@redhat.com,
        magnus.karlsson@intel.com, john.fastabend@gmail.com
Subject: Re: [PATCH bpf-next v4 1/2] bpf, xdp: make bpf_redirect_map() a map
 operation
Message-ID: <202102262331.DbZzOkps-lkp@intel.com>
References: <20210226112322.144927-2-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210226112322.144927-2-bjorn.topel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi "Björn,

I love your patch! Perhaps something to improve:

[auto build test WARNING on 9c8f21e6f8856a96634e542a58ef3abf27486801]

url:    https://github.com/0day-ci/linux/commits/Bj-rn-T-pel/Optimize-bpf_redirect_map-xdp_do_redirect/20210226-192840
base:   9c8f21e6f8856a96634e542a58ef3abf27486801
config: mips-randconfig-r026-20210226 (attached as .config)
compiler: mips64-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/1f7606274f17503baf1c0908dad3462981840749
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Bj-rn-T-pel/Optimize-bpf_redirect_map-xdp_do_redirect/20210226-192840
        git checkout 1f7606274f17503baf1c0908dad3462981840749
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=mips 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/linux/bpf_verifier.h:9,
                    from kernel/bpf/verifier.c:12:
   kernel/bpf/verifier.c: In function 'jit_subprogs':
   include/linux/filter.h:363:4: warning: cast between incompatible function types from 'unsigned int (*)(const void *, const struct bpf_insn *)' to 'u64 (*)(u64,  u64,  u64,  u64,  u64)' {aka 'long long unsigned int (*)(long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int)'} [-Wcast-function-type]
     363 |   ((u64 (*)(u64, u64, u64, u64, u64))(x))
         |    ^
   kernel/bpf/verifier.c:11421:16: note: in expansion of macro 'BPF_CAST_CALL'
   11421 |    insn->imm = BPF_CAST_CALL(func[subprog]->bpf_func) -
         |                ^~~~~~~~~~~~~
   kernel/bpf/verifier.c: In function 'fixup_bpf_calls':
   include/linux/filter.h:363:4: warning: cast between incompatible function types from 'void * (* const)(struct bpf_map *, void *)' to 'u64 (*)(u64,  u64,  u64,  u64,  u64)' {aka 'long long unsigned int (*)(long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int)'} [-Wcast-function-type]
     363 |   ((u64 (*)(u64, u64, u64, u64, u64))(x))
         |    ^
   kernel/bpf/verifier.c:11814:17: note: in expansion of macro 'BPF_CAST_CALL'
   11814 |     insn->imm = BPF_CAST_CALL(ops->map_lookup_elem) -
         |                 ^~~~~~~~~~~~~
   include/linux/filter.h:363:4: warning: cast between incompatible function types from 'int (* const)(struct bpf_map *, void *, void *, u64)' {aka 'int (* const)(struct bpf_map *, void *, void *, long long unsigned int)'} to 'u64 (*)(u64,  u64,  u64,  u64,  u64)' {aka 'long long unsigned int (*)(long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int)'} [-Wcast-function-type]
     363 |   ((u64 (*)(u64, u64, u64, u64, u64))(x))
         |    ^
   kernel/bpf/verifier.c:11818:17: note: in expansion of macro 'BPF_CAST_CALL'
   11818 |     insn->imm = BPF_CAST_CALL(ops->map_update_elem) -
         |                 ^~~~~~~~~~~~~
   include/linux/filter.h:363:4: warning: cast between incompatible function types from 'int (* const)(struct bpf_map *, void *)' to 'u64 (*)(u64,  u64,  u64,  u64,  u64)' {aka 'long long unsigned int (*)(long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int)'} [-Wcast-function-type]
     363 |   ((u64 (*)(u64, u64, u64, u64, u64))(x))
         |    ^
   kernel/bpf/verifier.c:11822:17: note: in expansion of macro 'BPF_CAST_CALL'
   11822 |     insn->imm = BPF_CAST_CALL(ops->map_delete_elem) -
         |                 ^~~~~~~~~~~~~
   include/linux/filter.h:363:4: warning: cast between incompatible function types from 'int (* const)(struct bpf_map *, void *, u64)' {aka 'int (* const)(struct bpf_map *, void *, long long unsigned int)'} to 'u64 (*)(u64,  u64,  u64,  u64,  u64)' {aka 'long long unsigned int (*)(long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int)'} [-Wcast-function-type]
     363 |   ((u64 (*)(u64, u64, u64, u64, u64))(x))
         |    ^
   kernel/bpf/verifier.c:11826:17: note: in expansion of macro 'BPF_CAST_CALL'
   11826 |     insn->imm = BPF_CAST_CALL(ops->map_push_elem) -
         |                 ^~~~~~~~~~~~~
   include/linux/filter.h:363:4: warning: cast between incompatible function types from 'int (* const)(struct bpf_map *, void *)' to 'u64 (*)(u64,  u64,  u64,  u64,  u64)' {aka 'long long unsigned int (*)(long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int)'} [-Wcast-function-type]
     363 |   ((u64 (*)(u64, u64, u64, u64, u64))(x))
         |    ^
   kernel/bpf/verifier.c:11830:17: note: in expansion of macro 'BPF_CAST_CALL'
   11830 |     insn->imm = BPF_CAST_CALL(ops->map_pop_elem) -
         |                 ^~~~~~~~~~~~~
   include/linux/filter.h:363:4: warning: cast between incompatible function types from 'int (* const)(struct bpf_map *, void *)' to 'u64 (*)(u64,  u64,  u64,  u64,  u64)' {aka 'long long unsigned int (*)(long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int)'} [-Wcast-function-type]
     363 |   ((u64 (*)(u64, u64, u64, u64, u64))(x))
         |    ^
   kernel/bpf/verifier.c:11834:17: note: in expansion of macro 'BPF_CAST_CALL'
   11834 |     insn->imm = BPF_CAST_CALL(ops->map_peek_elem) -
         |                 ^~~~~~~~~~~~~
>> include/linux/filter.h:363:4: warning: cast between incompatible function types from 'int (* const)(struct bpf_map *, u32,  u64)' {aka 'int (* const)(struct bpf_map *, unsigned int,  long long unsigned int)'} to 'u64 (*)(u64,  u64,  u64,  u64,  u64)' {aka 'long long unsigned int (*)(long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int,  long long unsigned int)'} [-Wcast-function-type]
     363 |   ((u64 (*)(u64, u64, u64, u64, u64))(x))
         |    ^
   kernel/bpf/verifier.c:11838:17: note: in expansion of macro 'BPF_CAST_CALL'
   11838 |     insn->imm = BPF_CAST_CALL(ops->xdp_redirect_map) - __bpf_call_base;
         |                 ^~~~~~~~~~~~~


vim +363 include/linux/filter.h

f8f6d679aaa78b Daniel Borkmann 2014-05-29  361  
09772d92cd5ad9 Daniel Borkmann 2018-06-02  362  #define BPF_CAST_CALL(x)					\
09772d92cd5ad9 Daniel Borkmann 2018-06-02 @363  		((u64 (*)(u64, u64, u64, u64, u64))(x))
09772d92cd5ad9 Daniel Borkmann 2018-06-02  364  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--DocE+STaALJfprDB
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
ZZdIPOEbsJu3DC9yAQA=

--DocE+STaALJfprDB--
