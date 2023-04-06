Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A42B6D8E8D
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 06:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbjDFEvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 00:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjDFEvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 00:51:45 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25846EB8;
        Wed,  5 Apr 2023 21:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680756704; x=1712292704;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WAk4a5YPZyL+Po9HZxq/HOFKVLqFQTC42kxDfeTqoiU=;
  b=n76neJJe6U/RmbTU05lw9u9MbjUFzZBr3NGFCp/6zvPYF5/FoDCm2lqQ
   UR7azFBPIU0p2KCG2q9a4FSWwr38lLF489LADeg5p961/M+MMLEF3cEzp
   PcEJqbwFgda/UO8YhQa+jwSpXTYW91+WY7hQjGRp9pyb+/X1Yi546Ocy0
   6+RWCae1FEJM7uJeTnRhhcBpcrOwcUcVXAB8ZuARbUftbP/sSh/FYKFnv
   CUXB2neTOlC2g0eZmtD3LxH5FMnz1kxG4vzGt2NY2KHHk4YuSnLtxno/M
   3/inh0mfrtKhVSYrk+16zxCbosza7yJ9qGVLFaAmbd7BlYK9llmdHiJeK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="405421823"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="405421823"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 21:51:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="680521713"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="680521713"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 05 Apr 2023 21:51:42 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pkHay-000R3G-2K;
        Thu, 06 Apr 2023 04:51:36 +0000
Date:   Thu, 6 Apr 2023 12:50:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
        bpf@vger.kernel.org, dxu@dxuuu.xyz, qde@naccy.de,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH bpf-next 1/6] bpf: add bpf_link support for BPF_NETFILTER
 programs
Message-ID: <202304061228.XRcVvxoL-lkp@intel.com>
References: <20230405161116.13565-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405161116.13565-2-fw@strlen.de>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

kernel test robot noticed the following build errors:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/bpf-add-bpf_link-support-for-BPF_NETFILTER-programs/20230406-001447
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/20230405161116.13565-2-fw%40strlen.de
patch subject: [PATCH bpf-next 1/6] bpf: add bpf_link support for BPF_NETFILTER programs
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20230406/202304061228.XRcVvxoL-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/f373efb623e6ff708403b172fafb506028de6cb8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Florian-Westphal/bpf-add-bpf_link-support-for-BPF_NETFILTER-programs/20230406-001447
        git checkout f373efb623e6ff708403b172fafb506028de6cb8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304061228.XRcVvxoL-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: vmlinux.o: in function `link_create':
>> kernel/bpf/syscall.c:4671: undefined reference to `bpf_nf_link_attach'


vim +4671 kernel/bpf/syscall.c

  4578	
  4579	#define BPF_LINK_CREATE_LAST_FIELD link_create.kprobe_multi.cookies
  4580	static int link_create(union bpf_attr *attr, bpfptr_t uattr)
  4581	{
  4582		enum bpf_prog_type ptype;
  4583		struct bpf_prog *prog;
  4584		int ret;
  4585	
  4586		if (CHECK_ATTR(BPF_LINK_CREATE))
  4587			return -EINVAL;
  4588	
  4589		if (attr->link_create.attach_type == BPF_STRUCT_OPS)
  4590			return bpf_struct_ops_link_create(attr);
  4591	
  4592		prog = bpf_prog_get(attr->link_create.prog_fd);
  4593		if (IS_ERR(prog))
  4594			return PTR_ERR(prog);
  4595	
  4596		ret = bpf_prog_attach_check_attach_type(prog,
  4597							attr->link_create.attach_type);
  4598		if (ret)
  4599			goto out;
  4600	
  4601		switch (prog->type) {
  4602		case BPF_PROG_TYPE_EXT:
  4603		case BPF_PROG_TYPE_NETFILTER:
  4604			break;
  4605		case BPF_PROG_TYPE_PERF_EVENT:
  4606		case BPF_PROG_TYPE_TRACEPOINT:
  4607			if (attr->link_create.attach_type != BPF_PERF_EVENT) {
  4608				ret = -EINVAL;
  4609				goto out;
  4610			}
  4611			break;
  4612		case BPF_PROG_TYPE_KPROBE:
  4613			if (attr->link_create.attach_type != BPF_PERF_EVENT &&
  4614			    attr->link_create.attach_type != BPF_TRACE_KPROBE_MULTI) {
  4615				ret = -EINVAL;
  4616				goto out;
  4617			}
  4618			break;
  4619		default:
  4620			ptype = attach_type_to_prog_type(attr->link_create.attach_type);
  4621			if (ptype == BPF_PROG_TYPE_UNSPEC || ptype != prog->type) {
  4622				ret = -EINVAL;
  4623				goto out;
  4624			}
  4625			break;
  4626		}
  4627	
  4628		switch (prog->type) {
  4629		case BPF_PROG_TYPE_CGROUP_SKB:
  4630		case BPF_PROG_TYPE_CGROUP_SOCK:
  4631		case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
  4632		case BPF_PROG_TYPE_SOCK_OPS:
  4633		case BPF_PROG_TYPE_CGROUP_DEVICE:
  4634		case BPF_PROG_TYPE_CGROUP_SYSCTL:
  4635		case BPF_PROG_TYPE_CGROUP_SOCKOPT:
  4636			ret = cgroup_bpf_link_attach(attr, prog);
  4637			break;
  4638		case BPF_PROG_TYPE_EXT:
  4639			ret = bpf_tracing_prog_attach(prog,
  4640						      attr->link_create.target_fd,
  4641						      attr->link_create.target_btf_id,
  4642						      attr->link_create.tracing.cookie);
  4643			break;
  4644		case BPF_PROG_TYPE_LSM:
  4645		case BPF_PROG_TYPE_TRACING:
  4646			if (attr->link_create.attach_type != prog->expected_attach_type) {
  4647				ret = -EINVAL;
  4648				goto out;
  4649			}
  4650			if (prog->expected_attach_type == BPF_TRACE_RAW_TP)
  4651				ret = bpf_raw_tp_link_attach(prog, NULL);
  4652			else if (prog->expected_attach_type == BPF_TRACE_ITER)
  4653				ret = bpf_iter_link_attach(attr, uattr, prog);
  4654			else if (prog->expected_attach_type == BPF_LSM_CGROUP)
  4655				ret = cgroup_bpf_link_attach(attr, prog);
  4656			else
  4657				ret = bpf_tracing_prog_attach(prog,
  4658							      attr->link_create.target_fd,
  4659							      attr->link_create.target_btf_id,
  4660							      attr->link_create.tracing.cookie);
  4661			break;
  4662		case BPF_PROG_TYPE_FLOW_DISSECTOR:
  4663		case BPF_PROG_TYPE_SK_LOOKUP:
  4664			ret = netns_bpf_link_create(attr, prog);
  4665			break;
  4666	#ifdef CONFIG_NET
  4667		case BPF_PROG_TYPE_XDP:
  4668			ret = bpf_xdp_link_attach(attr, prog);
  4669			break;
  4670		case BPF_PROG_TYPE_NETFILTER:
> 4671			ret = bpf_nf_link_attach(attr, prog);
  4672			break;
  4673	#endif
  4674		case BPF_PROG_TYPE_PERF_EVENT:
  4675		case BPF_PROG_TYPE_TRACEPOINT:
  4676			ret = bpf_perf_link_attach(attr, prog);
  4677			break;
  4678		case BPF_PROG_TYPE_KPROBE:
  4679			if (attr->link_create.attach_type == BPF_PERF_EVENT)
  4680				ret = bpf_perf_link_attach(attr, prog);
  4681			else
  4682				ret = bpf_kprobe_multi_link_attach(attr, prog);
  4683			break;
  4684		default:
  4685			ret = -EINVAL;
  4686		}
  4687	
  4688	out:
  4689		if (ret < 0)
  4690			bpf_prog_put(prog);
  4691		return ret;
  4692	}
  4693	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
