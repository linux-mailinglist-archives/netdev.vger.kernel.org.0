Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335E26A2F0B
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 11:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBZKEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 05:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBZKEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 05:04:01 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E434E1BFB;
        Sun, 26 Feb 2023 02:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677405838; x=1708941838;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QwTEK0J6utcQTtPjH6/V0c2fY4joL6RNddLp51Dy5WA=;
  b=XzMovi17oWFPi6oAf3G/+5G5D4yXVqQV1VuC03v81ZfgOvhxn9c+95ZI
   Ch4yCcGk0FnKd2UCjBy7oIWM9aMpMJQQl2BtC84ihpGSFs1ZTF1hoteef
   qkMfwHy1CN+QNqF3jKUeyb7ZYei+9jFuNsUWs+k12Nmeg1nE+DyIxBd6k
   n0Zuh5ebHDumajVqAg81V9912jo/ZVNq26jGnxGtr6fnZg+uW8WPYboc1
   tiOjJoEEe6aWPb0CfBAMTgY93u1Q/Q6vjlw6/4FErTd/cio0WJWO/aNrN
   KuUHcr5FnBMgCZgjEIpM3WVEiQMb05/n5gmzG+EEeMMdOVP4ArQqIbPn0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10632"; a="314125937"
X-IronPort-AV: E=Sophos;i="5.97,329,1669104000"; 
   d="scan'208";a="314125937"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2023 02:03:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10632"; a="918939627"
X-IronPort-AV: E=Sophos;i="5.97,329,1669104000"; 
   d="scan'208";a="918939627"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 26 Feb 2023 02:03:54 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pWDsn-0003gn-14;
        Sun, 26 Feb 2023 10:03:53 +0000
Date:   Sun, 26 Feb 2023 18:03:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Joanne Koong <joannelkoong@gmail.com>, bpf@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH v12 bpf-next 09/10] bpf: Add bpf_dynptr_slice and
 bpf_dynptr_slice_rdwr
Message-ID: <202302261742.iOSFw9wm-lkp@intel.com>
References: <20230226085120.3907863-10-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230226085120.3907863-10-joannelkoong@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joanne,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/bpf-Support-sk_buff-and-xdp_buff-as-valid-kfunc-arg-types/20230226-165406
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/20230226085120.3907863-10-joannelkoong%40gmail.com
patch subject: [PATCH v12 bpf-next 09/10] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
config: hexagon-randconfig-r026-20230226 (https://download.01.org/0day-ci/archive/20230226/202302261742.iOSFw9wm-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project db89896bbbd2251fff457699635acbbedeead27f)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/bc5a61c43c72539ef11e6435a168bf240a186ac1
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Joanne-Koong/bpf-Support-sk_buff-and-xdp_buff-as-valid-kfunc-arg-types/20230226-165406
        git checkout bc5a61c43c72539ef11e6435a168bf240a186ac1
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302261742.iOSFw9wm-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from kernel/bpf/verifier.c:7:
   In file included from include/linux/bpf-cgroup.h:5:
   In file included from include/linux/bpf.h:31:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:26:
   In file included from include/linux/kernel_stat.h:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
                                                     ^
   In file included from kernel/bpf/verifier.c:7:
   In file included from include/linux/bpf-cgroup.h:5:
   In file included from include/linux/bpf.h:31:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:26:
   In file included from include/linux/kernel_stat.h:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
                                                     ^
   In file included from kernel/bpf/verifier.c:7:
   In file included from include/linux/bpf-cgroup.h:5:
   In file included from include/linux/bpf.h:31:
   In file included from include/linux/memcontrol.h:13:
   In file included from include/linux/cgroup.h:26:
   In file included from include/linux/kernel_stat.h:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/hexagon/include/asm/io.h:334:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   kernel/bpf/verifier.c:6253:5: warning: no previous prototype for function 'process_dynptr_func' [-Wmissing-prototypes]
   int process_dynptr_func(struct bpf_verifier_env *env, int regno, int insn_idx,
       ^
   kernel/bpf/verifier.c:6253:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int process_dynptr_func(struct bpf_verifier_env *env, int regno, int insn_idx,
   ^
   static 
   kernel/bpf/verifier.c:9907:4: error: expected expression
                           struct bpf_reg_state *size_reg = &regs[regno + 1];
                           ^
   kernel/bpf/verifier.c:9910:40: error: use of undeclared identifier 'size_reg'; did you mean 'size_arg'?
                           ret = check_kfunc_mem_size_reg(env, size_reg, regno + 1);
                                                               ^~~~~~~~
                                                               size_arg
   kernel/bpf/verifier.c:9908:28: note: 'size_arg' declared here
                           const struct btf_param *size_arg = &args[i + 1];
                                                   ^
   kernel/bpf/verifier.c:9916:57: error: use of undeclared identifier 'size_reg'; did you mean 'size_arg'?
                           if (is_kfunc_arg_const_mem_size(meta->btf, size_arg, size_reg)) {
                                                                                ^~~~~~~~
                                                                                size_arg
   kernel/bpf/verifier.c:9908:28: note: 'size_arg' declared here
                           const struct btf_param *size_arg = &args[i + 1];
                                                   ^
   kernel/bpf/verifier.c:9921:24: error: use of undeclared identifier 'size_reg'
                                   if (!tnum_is_const(size_reg->var_off)) {
                                                      ^
   kernel/bpf/verifier.c:9926:32: error: use of undeclared identifier 'size_reg'
                                   meta->arg_constant.value = size_reg->var_off.value;
                                                              ^
>> kernel/bpf/verifier.c:9908:28: warning: mixing declarations and code is incompatible with standards before C99 [-Wdeclaration-after-statement]
                           const struct btf_param *size_arg = &args[i + 1];
                                                   ^
   8 warnings and 5 errors generated.


vim +9908 kernel/bpf/verifier.c

  9584	
  9585	static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_arg_meta *meta,
  9586				    int insn_idx)
  9587	{
  9588		const char *func_name = meta->func_name, *ref_tname;
  9589		const struct btf *btf = meta->btf;
  9590		const struct btf_param *args;
  9591		u32 i, nargs;
  9592		int ret;
  9593	
  9594		args = (const struct btf_param *)(meta->func_proto + 1);
  9595		nargs = btf_type_vlen(meta->func_proto);
  9596		if (nargs > MAX_BPF_FUNC_REG_ARGS) {
  9597			verbose(env, "Function %s has %d > %d args\n", func_name, nargs,
  9598				MAX_BPF_FUNC_REG_ARGS);
  9599			return -EINVAL;
  9600		}
  9601	
  9602		/* Check that BTF function arguments match actual types that the
  9603		 * verifier sees.
  9604		 */
  9605		for (i = 0; i < nargs; i++) {
  9606			struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[i + 1];
  9607			const struct btf_type *t, *ref_t, *resolve_ret;
  9608			enum bpf_arg_type arg_type = ARG_DONTCARE;
  9609			u32 regno = i + 1, ref_id, type_size;
  9610			bool is_ret_buf_sz = false;
  9611			int kf_arg_type;
  9612	
  9613			t = btf_type_skip_modifiers(btf, args[i].type, NULL);
  9614	
  9615			if (is_kfunc_arg_ignore(btf, &args[i]))
  9616				continue;
  9617	
  9618			if (btf_type_is_scalar(t)) {
  9619				if (reg->type != SCALAR_VALUE) {
  9620					verbose(env, "R%d is not a scalar\n", regno);
  9621					return -EINVAL;
  9622				}
  9623	
  9624				if (is_kfunc_arg_constant(meta->btf, &args[i])) {
  9625					if (meta->arg_constant.found) {
  9626						verbose(env, "verifier internal error: only one constant argument permitted\n");
  9627						return -EFAULT;
  9628					}
  9629					if (!tnum_is_const(reg->var_off)) {
  9630						verbose(env, "R%d must be a known constant\n", regno);
  9631						return -EINVAL;
  9632					}
  9633					ret = mark_chain_precision(env, regno);
  9634					if (ret < 0)
  9635						return ret;
  9636					meta->arg_constant.found = true;
  9637					meta->arg_constant.value = reg->var_off.value;
  9638				} else if (is_kfunc_arg_scalar_with_name(btf, &args[i], "rdonly_buf_size")) {
  9639					meta->r0_rdonly = true;
  9640					is_ret_buf_sz = true;
  9641				} else if (is_kfunc_arg_scalar_with_name(btf, &args[i], "rdwr_buf_size")) {
  9642					is_ret_buf_sz = true;
  9643				}
  9644	
  9645				if (is_ret_buf_sz) {
  9646					if (meta->r0_size) {
  9647						verbose(env, "2 or more rdonly/rdwr_buf_size parameters for kfunc");
  9648						return -EINVAL;
  9649					}
  9650	
  9651					if (!tnum_is_const(reg->var_off)) {
  9652						verbose(env, "R%d is not a const\n", regno);
  9653						return -EINVAL;
  9654					}
  9655	
  9656					meta->r0_size = reg->var_off.value;
  9657					ret = mark_chain_precision(env, regno);
  9658					if (ret)
  9659						return ret;
  9660				}
  9661				continue;
  9662			}
  9663	
  9664			if (!btf_type_is_ptr(t)) {
  9665				verbose(env, "Unrecognized arg#%d type %s\n", i, btf_type_str(t));
  9666				return -EINVAL;
  9667			}
  9668	
  9669			if (is_kfunc_trusted_args(meta) &&
  9670			    (register_is_null(reg) || type_may_be_null(reg->type))) {
  9671				verbose(env, "Possibly NULL pointer passed to trusted arg%d\n", i);
  9672				return -EACCES;
  9673			}
  9674	
  9675			if (reg->ref_obj_id) {
  9676				if (is_kfunc_release(meta) && meta->ref_obj_id) {
  9677					verbose(env, "verifier internal error: more than one arg with ref_obj_id R%d %u %u\n",
  9678						regno, reg->ref_obj_id,
  9679						meta->ref_obj_id);
  9680					return -EFAULT;
  9681				}
  9682				meta->ref_obj_id = reg->ref_obj_id;
  9683				if (is_kfunc_release(meta))
  9684					meta->release_regno = regno;
  9685			}
  9686	
  9687			ref_t = btf_type_skip_modifiers(btf, t->type, &ref_id);
  9688			ref_tname = btf_name_by_offset(btf, ref_t->name_off);
  9689	
  9690			kf_arg_type = get_kfunc_ptr_arg_type(env, meta, t, ref_t, ref_tname, args, i, nargs);
  9691			if (kf_arg_type < 0)
  9692				return kf_arg_type;
  9693	
  9694			switch (kf_arg_type) {
  9695			case KF_ARG_PTR_TO_ALLOC_BTF_ID:
  9696			case KF_ARG_PTR_TO_BTF_ID:
  9697				if (!is_kfunc_trusted_args(meta) && !is_kfunc_rcu(meta))
  9698					break;
  9699	
  9700				if (!is_trusted_reg(reg)) {
  9701					if (!is_kfunc_rcu(meta)) {
  9702						verbose(env, "R%d must be referenced or trusted\n", regno);
  9703						return -EINVAL;
  9704					}
  9705					if (!is_rcu_reg(reg)) {
  9706						verbose(env, "R%d must be a rcu pointer\n", regno);
  9707						return -EINVAL;
  9708					}
  9709				}
  9710	
  9711				fallthrough;
  9712			case KF_ARG_PTR_TO_CTX:
  9713				/* Trusted arguments have the same offset checks as release arguments */
  9714				arg_type |= OBJ_RELEASE;
  9715				break;
  9716			case KF_ARG_PTR_TO_KPTR:
  9717			case KF_ARG_PTR_TO_DYNPTR:
  9718			case KF_ARG_PTR_TO_LIST_HEAD:
  9719			case KF_ARG_PTR_TO_LIST_NODE:
  9720			case KF_ARG_PTR_TO_RB_ROOT:
  9721			case KF_ARG_PTR_TO_RB_NODE:
  9722			case KF_ARG_PTR_TO_MEM:
  9723			case KF_ARG_PTR_TO_MEM_SIZE:
  9724			case KF_ARG_PTR_TO_CALLBACK:
  9725				/* Trusted by default */
  9726				break;
  9727			default:
  9728				WARN_ON_ONCE(1);
  9729				return -EFAULT;
  9730			}
  9731	
  9732			if (is_kfunc_release(meta) && reg->ref_obj_id)
  9733				arg_type |= OBJ_RELEASE;
  9734			ret = check_func_arg_reg_off(env, reg, regno, arg_type);
  9735			if (ret < 0)
  9736				return ret;
  9737	
  9738			switch (kf_arg_type) {
  9739			case KF_ARG_PTR_TO_CTX:
  9740				if (reg->type != PTR_TO_CTX) {
  9741					verbose(env, "arg#%d expected pointer to ctx, but got %s\n", i, btf_type_str(t));
  9742					return -EINVAL;
  9743				}
  9744	
  9745				if (meta->func_id == special_kfunc_list[KF_bpf_cast_to_kern_ctx]) {
  9746					ret = get_kern_ctx_btf_id(&env->log, resolve_prog_type(env->prog));
  9747					if (ret < 0)
  9748						return -EINVAL;
  9749					meta->ret_btf_id  = ret;
  9750				}
  9751				break;
  9752			case KF_ARG_PTR_TO_ALLOC_BTF_ID:
  9753				if (reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
  9754					verbose(env, "arg#%d expected pointer to allocated object\n", i);
  9755					return -EINVAL;
  9756				}
  9757				if (!reg->ref_obj_id) {
  9758					verbose(env, "allocated object must be referenced\n");
  9759					return -EINVAL;
  9760				}
  9761				if (meta->btf == btf_vmlinux &&
  9762				    meta->func_id == special_kfunc_list[KF_bpf_obj_drop_impl]) {
  9763					meta->arg_obj_drop.btf = reg->btf;
  9764					meta->arg_obj_drop.btf_id = reg->btf_id;
  9765				}
  9766				break;
  9767			case KF_ARG_PTR_TO_KPTR:
  9768				if (reg->type != PTR_TO_MAP_VALUE) {
  9769					verbose(env, "arg#0 expected pointer to map value\n");
  9770					return -EINVAL;
  9771				}
  9772				ret = process_kf_arg_ptr_to_kptr(env, reg, ref_t, ref_tname, meta, i);
  9773				if (ret < 0)
  9774					return ret;
  9775				break;
  9776			case KF_ARG_PTR_TO_DYNPTR:
  9777			{
  9778				enum bpf_arg_type dynptr_arg_type = ARG_PTR_TO_DYNPTR;
  9779	
  9780				if (reg->type != PTR_TO_STACK &&
  9781				    reg->type != CONST_PTR_TO_DYNPTR) {
  9782					verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
  9783					return -EINVAL;
  9784				}
  9785	
  9786				if (reg->type == CONST_PTR_TO_DYNPTR)
  9787					dynptr_arg_type |= MEM_RDONLY;
  9788	
  9789				if (is_kfunc_arg_uninit(btf, &args[i]))
  9790					dynptr_arg_type |= MEM_UNINIT;
  9791	
  9792				if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_skb])
  9793					dynptr_arg_type |= DYNPTR_TYPE_SKB;
  9794				else if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_xdp])
  9795					dynptr_arg_type |= DYNPTR_TYPE_XDP;
  9796	
  9797				ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type);
  9798				if (ret < 0)
  9799					return ret;
  9800	
  9801				if (!(dynptr_arg_type & MEM_UNINIT)) {
  9802					int id = dynptr_id(env, reg);
  9803	
  9804					if (id < 0) {
  9805						verbose(env, "verifier internal error: failed to obtain dynptr id\n");
  9806						return id;
  9807					}
  9808					meta->initialized_dynptr.id = id;
  9809					meta->initialized_dynptr.type = dynptr_get_type(env, reg);
  9810				}
  9811	
  9812				break;
  9813			}
  9814			case KF_ARG_PTR_TO_LIST_HEAD:
  9815				if (reg->type != PTR_TO_MAP_VALUE &&
  9816				    reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
  9817					verbose(env, "arg#%d expected pointer to map value or allocated object\n", i);
  9818					return -EINVAL;
  9819				}
  9820				if (reg->type == (PTR_TO_BTF_ID | MEM_ALLOC) && !reg->ref_obj_id) {
  9821					verbose(env, "allocated object must be referenced\n");
  9822					return -EINVAL;
  9823				}
  9824				ret = process_kf_arg_ptr_to_list_head(env, reg, regno, meta);
  9825				if (ret < 0)
  9826					return ret;
  9827				break;
  9828			case KF_ARG_PTR_TO_RB_ROOT:
  9829				if (reg->type != PTR_TO_MAP_VALUE &&
  9830				    reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
  9831					verbose(env, "arg#%d expected pointer to map value or allocated object\n", i);
  9832					return -EINVAL;
  9833				}
  9834				if (reg->type == (PTR_TO_BTF_ID | MEM_ALLOC) && !reg->ref_obj_id) {
  9835					verbose(env, "allocated object must be referenced\n");
  9836					return -EINVAL;
  9837				}
  9838				ret = process_kf_arg_ptr_to_rbtree_root(env, reg, regno, meta);
  9839				if (ret < 0)
  9840					return ret;
  9841				break;
  9842			case KF_ARG_PTR_TO_LIST_NODE:
  9843				if (reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
  9844					verbose(env, "arg#%d expected pointer to allocated object\n", i);
  9845					return -EINVAL;
  9846				}
  9847				if (!reg->ref_obj_id) {
  9848					verbose(env, "allocated object must be referenced\n");
  9849					return -EINVAL;
  9850				}
  9851				ret = process_kf_arg_ptr_to_list_node(env, reg, regno, meta);
  9852				if (ret < 0)
  9853					return ret;
  9854				break;
  9855			case KF_ARG_PTR_TO_RB_NODE:
  9856				if (meta->func_id == special_kfunc_list[KF_bpf_rbtree_remove]) {
  9857					if (!type_is_non_owning_ref(reg->type) || reg->ref_obj_id) {
  9858						verbose(env, "rbtree_remove node input must be non-owning ref\n");
  9859						return -EINVAL;
  9860					}
  9861					if (in_rbtree_lock_required_cb(env)) {
  9862						verbose(env, "rbtree_remove not allowed in rbtree cb\n");
  9863						return -EINVAL;
  9864					}
  9865				} else {
  9866					if (reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
  9867						verbose(env, "arg#%d expected pointer to allocated object\n", i);
  9868						return -EINVAL;
  9869					}
  9870					if (!reg->ref_obj_id) {
  9871						verbose(env, "allocated object must be referenced\n");
  9872						return -EINVAL;
  9873					}
  9874				}
  9875	
  9876				ret = process_kf_arg_ptr_to_rbtree_node(env, reg, regno, meta);
  9877				if (ret < 0)
  9878					return ret;
  9879				break;
  9880			case KF_ARG_PTR_TO_BTF_ID:
  9881				/* Only base_type is checked, further checks are done here */
  9882				if ((base_type(reg->type) != PTR_TO_BTF_ID ||
  9883				     (bpf_type_has_unsafe_modifiers(reg->type) && !is_rcu_reg(reg))) &&
  9884				    !reg2btf_ids[base_type(reg->type)]) {
  9885					verbose(env, "arg#%d is %s ", i, reg_type_str(env, reg->type));
  9886					verbose(env, "expected %s or socket\n",
  9887						reg_type_str(env, base_type(reg->type) |
  9888								  (type_flag(reg->type) & BPF_REG_TRUSTED_MODIFIERS)));
  9889					return -EINVAL;
  9890				}
  9891				ret = process_kf_arg_ptr_to_btf_id(env, reg, ref_t, ref_tname, ref_id, meta, i);
  9892				if (ret < 0)
  9893					return ret;
  9894				break;
  9895			case KF_ARG_PTR_TO_MEM:
  9896				resolve_ret = btf_resolve_size(btf, ref_t, &type_size);
  9897				if (IS_ERR(resolve_ret)) {
  9898					verbose(env, "arg#%d reference type('%s %s') size cannot be determined: %ld\n",
  9899						i, btf_type_str(ref_t), ref_tname, PTR_ERR(resolve_ret));
  9900					return -EINVAL;
  9901				}
  9902				ret = check_mem_reg(env, reg, regno, type_size);
  9903				if (ret < 0)
  9904					return ret;
  9905				break;
  9906			case KF_ARG_PTR_TO_MEM_SIZE:
  9907				struct bpf_reg_state *size_reg = &regs[regno + 1];
> 9908				const struct btf_param *size_arg = &args[i + 1];
  9909	
  9910				ret = check_kfunc_mem_size_reg(env, size_reg, regno + 1);
  9911				if (ret < 0) {
  9912					verbose(env, "arg#%d arg#%d memory, len pair leads to invalid memory access\n", i, i + 1);
  9913					return ret;
  9914				}
  9915	
  9916				if (is_kfunc_arg_const_mem_size(meta->btf, size_arg, size_reg)) {
  9917					if (meta->arg_constant.found) {
  9918						verbose(env, "verifier internal error: only one constant argument permitted\n");
  9919						return -EFAULT;
  9920					}
  9921					if (!tnum_is_const(size_reg->var_off)) {
  9922						verbose(env, "R%d must be a known constant\n", regno + 1);
  9923						return -EINVAL;
  9924					}
  9925					meta->arg_constant.found = true;
  9926					meta->arg_constant.value = size_reg->var_off.value;
  9927				}
  9928	
  9929				/* Skip next '__sz' or '__szk' argument */
  9930				i++;
  9931				break;
  9932			case KF_ARG_PTR_TO_CALLBACK:
  9933				meta->subprogno = reg->subprogno;
  9934				break;
  9935			}
  9936		}
  9937	
  9938		if (is_kfunc_release(meta) && !meta->release_regno) {
  9939			verbose(env, "release kernel function %s expects refcounted PTR_TO_BTF_ID\n",
  9940				func_name);
  9941			return -EINVAL;
  9942		}
  9943	
  9944		return 0;
  9945	}
  9946	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
