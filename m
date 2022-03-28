Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9A94EA30C
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 00:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiC1Wly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 18:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiC1Wlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 18:41:51 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CF74BFE6;
        Mon, 28 Mar 2022 15:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648507209; x=1680043209;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kxHtyv1OvHfrvSGyJvFYbtAiABXBZhmuk/LYZY9JqYU=;
  b=IKuYe/4eUbMvs2El5gE0BAGo2JtclV8mX0e/7XDQA7RzQ3tp9ZKsi8mz
   5Q/fbzA2nljWSxFmTMVvQeWoQ6cK3EXV8II5+O9VG72RnnWM37CLu9A82
   xJcVYr6F+zr96L7pgeV23qgmrvkRkSAGFAw/bKl3Y1Nyyp/QTpWc/5Vwe
   IkdQmfXdp3rwo+Zjs/zyzq7q1ZkFkTqf3o3gxSSRR9HsU+6ft4I0DKoDt
   NEQBA1kJZ3b7q1VhS69tOq1xcgem3RXU+KXaR1wHoksKFDm86bKNtSJCq
   YBgUsCTbYxP5+U0p38YhEXf561PtVba7dA1hPohSnIICuMTv46ex5qAaJ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="319815014"
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="319815014"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 15:36:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="546138651"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 28 Mar 2022 15:36:31 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nYxyQ-0002N6-Ub; Mon, 28 Mar 2022 22:36:30 +0000
Date:   Tue, 29 Mar 2022 06:36:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next 2/7] bpf: per-cgroup lsm flavor
Message-ID: <202203290637.4bOtec7I-lkp@intel.com>
References: <20220328181644.1748789-3-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328181644.1748789-3-sdf@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stanislav,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220329-021809
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: riscv-randconfig-r042-20220328 (https://download.01.org/0day-ci/archive/20220329/202203290637.4bOtec7I-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 0f6d9501cf49ce02937099350d08f20c4af86f3d)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/cf70645346b1affcc956902a44671c1d0eaa451a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220329-021809
        git checkout cf70645346b1affcc956902a44671c1d0eaa451a
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from kernel/bpf/cgroup.c:10:
   In file included from include/linux/cgroup.h:26:
   In file included from include/linux/kernel_stat.h:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:464:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                     ^
   In file included from kernel/bpf/cgroup.c:10:
   In file included from include/linux/cgroup.h:26:
   In file included from include/linux/kernel_stat.h:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
                                                     ^
   In file included from kernel/bpf/cgroup.c:10:
   In file included from include/linux/cgroup.h:26:
   In file included from include/linux/kernel_stat.h:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/riscv/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/riscv/include/asm/io.h:136:
   include/asm-generic/io.h:501:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:511:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:521:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:1024:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
                                                     ~~~~~~~~~~ ^
   In file included from kernel/bpf/cgroup.c:11:
   In file included from include/linux/filter.h:9:
   include/linux/bpf.h:878:2: error: void function 'bpf_trampoline_unlink_cgroup_shim' should not return a value [-Wreturn-type]
           return -EOPNOTSUPP;
           ^      ~~~~~~~~~~~
>> kernel/bpf/cgroup.c:499:12: error: use of undeclared identifier 'CGROUP_LSM_START'
                           atype = CGROUP_LSM_START + bpf_lsm_hook_idx(p->aux->attach_btf_id);
                                   ^
   7 warnings and 2 errors generated.


vim +/CGROUP_LSM_START +499 kernel/bpf/cgroup.c

   445	
   446	/**
   447	 * __cgroup_bpf_attach() - Attach the program or the link to a cgroup, and
   448	 *                         propagate the change to descendants
   449	 * @cgrp: The cgroup which descendants to traverse
   450	 * @prog: A program to attach
   451	 * @link: A link to attach
   452	 * @replace_prog: Previously attached program to replace if BPF_F_REPLACE is set
   453	 * @type: Type of attach operation
   454	 * @flags: Option flags
   455	 *
   456	 * Exactly one of @prog or @link can be non-null.
   457	 * Must be called with cgroup_mutex held.
   458	 */
   459	static int __cgroup_bpf_attach(struct cgroup *cgrp,
   460				       struct bpf_prog *prog, struct bpf_prog *replace_prog,
   461				       struct bpf_cgroup_link *link,
   462				       enum bpf_attach_type type, u32 flags)
   463	{
   464		u32 saved_flags = (flags & (BPF_F_ALLOW_OVERRIDE | BPF_F_ALLOW_MULTI));
   465		struct bpf_prog *old_prog = NULL;
   466		struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
   467		struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
   468		struct bpf_attach_target_info tgt_info = {};
   469		enum cgroup_bpf_attach_type atype;
   470		struct bpf_prog_list *pl;
   471		struct list_head *progs;
   472		int err;
   473	
   474		if (((flags & BPF_F_ALLOW_OVERRIDE) && (flags & BPF_F_ALLOW_MULTI)) ||
   475		    ((flags & BPF_F_REPLACE) && !(flags & BPF_F_ALLOW_MULTI)))
   476			/* invalid combination */
   477			return -EINVAL;
   478		if (link && (prog || replace_prog))
   479			/* only either link or prog/replace_prog can be specified */
   480			return -EINVAL;
   481		if (!!replace_prog != !!(flags & BPF_F_REPLACE))
   482			/* replace_prog implies BPF_F_REPLACE, and vice versa */
   483			return -EINVAL;
   484	
   485		if (type == BPF_LSM_CGROUP) {
   486			struct bpf_prog *p = prog ? : link->link.prog;
   487	
   488			if (replace_prog) {
   489				/* Reusing shim from the original program.
   490				 */
   491				atype = replace_prog->aux->cgroup_atype;
   492			} else {
   493				err = bpf_check_attach_target(NULL, p, NULL,
   494							      p->aux->attach_btf_id,
   495							      &tgt_info);
   496				if (err)
   497					return -EINVAL;
   498	
 > 499				atype = CGROUP_LSM_START + bpf_lsm_hook_idx(p->aux->attach_btf_id);
   500			}
   501	
   502			p->aux->cgroup_atype = atype;
   503		} else {
   504			atype = to_cgroup_bpf_attach_type(type);
   505			if (atype < 0)
   506				return -EINVAL;
   507		}
   508	
   509		progs = &cgrp->bpf.progs[atype];
   510	
   511		if (!hierarchy_allows_attach(cgrp, atype))
   512			return -EPERM;
   513	
   514		if (!list_empty(progs) && cgrp->bpf.flags[atype] != saved_flags)
   515			/* Disallow attaching non-overridable on top
   516			 * of existing overridable in this cgroup.
   517			 * Disallow attaching multi-prog if overridable or none
   518			 */
   519			return -EPERM;
   520	
   521		if (prog_list_length(progs) >= BPF_CGROUP_MAX_PROGS)
   522			return -E2BIG;
   523	
   524		pl = find_attach_entry(progs, prog, link, replace_prog,
   525				       flags & BPF_F_ALLOW_MULTI);
   526		if (IS_ERR(pl))
   527			return PTR_ERR(pl);
   528	
   529		if (bpf_cgroup_storages_alloc(storage, new_storage, type,
   530					      prog ? : link->link.prog, cgrp))
   531			return -ENOMEM;
   532	
   533		if (pl) {
   534			old_prog = pl->prog;
   535		} else {
   536			pl = kmalloc(sizeof(*pl), GFP_KERNEL);
   537			if (!pl) {
   538				bpf_cgroup_storages_free(new_storage);
   539				return -ENOMEM;
   540			}
   541			list_add_tail(&pl->node, progs);
   542		}
   543	
   544		pl->prog = prog;
   545		pl->link = link;
   546		bpf_cgroup_storages_assign(pl->storage, storage);
   547		cgrp->bpf.flags[atype] = saved_flags;
   548	
   549		err = update_effective_progs(cgrp, atype);
   550		if (err)
   551			goto cleanup;
   552	
   553		bpf_cgroup_storages_link(new_storage, cgrp, type);
   554	
   555		if (type == BPF_LSM_CGROUP && !old_prog) {
   556			struct bpf_prog *p = prog ? : link->link.prog;
   557			int err;
   558	
   559			err = bpf_trampoline_link_cgroup_shim(p, &tgt_info);
   560			if (err)
   561				goto cleanup_trampoline;
   562		}
   563	
   564		if (old_prog)
   565			bpf_prog_put(old_prog);
   566		else
   567			static_branch_inc(&cgroup_bpf_enabled_key[atype]);
   568	
   569		return 0;
   570	
   571	cleanup_trampoline:
   572		bpf_cgroup_storages_unlink(new_storage);
   573	
   574	cleanup:
   575		if (old_prog) {
   576			pl->prog = old_prog;
   577			pl->link = NULL;
   578		}
   579		bpf_cgroup_storages_free(new_storage);
   580		if (!old_prog) {
   581			list_del(&pl->node);
   582			kfree(pl);
   583		}
   584		return err;
   585	}
   586	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
