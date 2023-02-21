Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563A069DF63
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 12:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbjBUL4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 06:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbjBUL4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 06:56:11 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B3D27987;
        Tue, 21 Feb 2023 03:55:51 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0VcCOdes_1676980547;
Received: from 30.221.149.204(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VcCOdes_1676980547)
          by smtp.aliyun-inc.com;
          Tue, 21 Feb 2023 19:55:48 +0800
Message-ID: <7ff5ad40-7280-2060-4402-d3bada4ce200@linux.alibaba.com>
Date:   Tue, 21 Feb 2023 19:55:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH bpf-next 1/2] net/smc: Introduce BPF injection capability
 for SMC
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
References: <1676966191-47736-2-git-send-email-alibuda@linux.alibaba.com>
 <202302211908.BgagxpRo-lkp@intel.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <202302211908.BgagxpRo-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Thanks! I will repost a fixed patch.


On 2/21/23 7:30 PM, kernel test robot wrote:
> Hi Wythe,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on bpf-next/master]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/D-Wythe/net-smc-Introduce-BPF-injection-capability-for-SMC/20230221-155712
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> patch link:    https://lore.kernel.org/r/1676966191-47736-2-git-send-email-alibuda%40linux.alibaba.com
> patch subject: [PATCH bpf-next 1/2] net/smc: Introduce BPF injection capability for SMC
> config: i386-randconfig-a013-20230220 (https://download.01.org/0day-ci/archive/20230221/202302211908.BgagxpRo-lkp@intel.com/config)
> compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/intel-lab-lkp/linux/commit/e2b31aece49068d7a07ca4bbd5fbdbd92f45a25e
>          git remote add linux-review https://github.com/intel-lab-lkp/linux
>          git fetch --no-tags linux-review D-Wythe/net-smc-Introduce-BPF-injection-capability-for-SMC/20230221-155712
>          git checkout e2b31aece49068d7a07ca4bbd5fbdbd92f45a25e
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202302211908.BgagxpRo-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>>> net/smc/bpf_smc_struct_ops.c:61:33: error: use of undeclared identifier 'BTF_SMC_TYPE_MAX'; did you mean 'BTF_SMC_TYPE_SOCK'?
>     BTF_ID_LIST_GLOBAL(btf_smc_ids, BTF_SMC_TYPE_MAX)
>                                     ^~~~~~~~~~~~~~~~
>                                     BTF_SMC_TYPE_SOCK
>     include/linux/btf_ids.h:211:61: note: expanded from macro 'BTF_ID_LIST_GLOBAL'
>     #define BTF_ID_LIST_GLOBAL(name, n) u32 __maybe_unused name[n];
>                                                                 ^
>     include/linux/btf_ids.h:275:1: note: 'BTF_SMC_TYPE_SOCK' declared here
>     BTF_SMC_TYPE_xxx
>     ^
>     include/linux/btf_ids.h:269:15: note: expanded from macro 'BTF_SMC_TYPE_xxx'
>             BTF_SMC_TYPE(BTF_SMC_TYPE_SOCK, smc_sock)               \
>                          ^
>     1 error generated.
> 
> 
> vim +61 net/smc/bpf_smc_struct_ops.c
> 
>      59	
>      60	/* define global smc ID for smc_struct_ops */
>    > 61	BTF_ID_LIST_GLOBAL(btf_smc_ids, BTF_SMC_TYPE_MAX)
>      62	#define BTF_SMC_TYPE(name, type) BTF_ID(struct, type)
>      63	BTF_SMC_TYPE_xxx
>      64	#undef BTF_SMC_TYPE
>      65	
> 
