Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8834E52AD
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 13:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241584AbiCWNAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 09:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244143AbiCWNAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 09:00:04 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E340240B2;
        Wed, 23 Mar 2022 05:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648040312; x=1679576312;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XfJY9Dz9/CIorEMilrZscP0n3Q9pGdXNn7/Ceo4d1M4=;
  b=kZXqg9q7ZgPujeKHwzhtiAtUcYy/0eEfN9mGYBEUXasJS697oZ6rtuMg
   24fFaXbYgJmvnB6f8yGg+Boz/ULayGH30X1klcd8SCj677bY6CRfENUtV
   A7Ejt5vPdKmsCoa0IOefEDe1JZXHs9XBO+JGUcPTotoYqTzf4bOgLlko0
   tX5Lr8lYqPnDROdxzkacA6lk4WwMtkInALVYjtXZrPCBkl+FSTHgiMCVN
   hlPUUmKLZXOHWo/1/me5Z45XYMXJWZPzh+pvaizf+5/kbKzUVeBmRrE8a
   csPwy6B4yKXt6YjBfOnmHWAY1Lb9DhFLjva/XTpzUm7nKQAVXaaZMpQcX
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="258290753"
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="258290753"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 05:58:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="825306011"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 23 Mar 2022 05:58:30 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nX0ZJ-000K4G-Gs; Wed, 23 Mar 2022 12:58:29 +0000
Date:   Wed, 23 Mar 2022 20:58:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Haowen Bai <baihaowen@meizu.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Haowen Bai <baihaowen@meizu.com>
Subject: Re: [PATCH] net: l2tp: Fix duplicate included trace.h
Message-ID: <202203232038.g9DSFJVx-lkp@intel.com>
References: <1648006705-30269-1-git-send-email-baihaowen@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1648006705-30269-1-git-send-email-baihaowen@meizu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Haowen,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on net/master horms-ipvs/master linus/master v5.17 next-20220323]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Haowen-Bai/net-l2tp-Fix-duplicate-included-trace-h/20220323-114023
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 4a0cb83ba6e0cd73a50fa4f84736846bf0029f2b
config: openrisc-buildonly-randconfig-r003-20220323 (https://download.01.org/0day-ci/archive/20220323/202203232038.g9DSFJVx-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/d079f4f8992c56c4d970665bad819349d4916c46
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Haowen-Bai/net-l2tp-Fix-duplicate-included-trace-h/20220323-114023
        git checkout d079f4f8992c56c4d970665bad819349d4916c46
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=openrisc SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   or1k-linux-ld: net/l2tp/l2tp_core.o: in function `trace_session_seqnum_update':
>> l2tp_core.c:(.text+0xa3c): undefined reference to `__tracepoint_session_seqnum_update'
>> or1k-linux-ld: l2tp_core.c:(.text+0xa40): undefined reference to `__tracepoint_session_seqnum_update'
>> or1k-linux-ld: l2tp_core.c:(.text+0xb10): undefined reference to `__traceiter_session_seqnum_update'
   l2tp_core.c:(.text+0xb10): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `__traceiter_session_seqnum_update'
   or1k-linux-ld: net/l2tp/l2tp_core.o: in function `l2tp_recv_dequeue':
>> l2tp_core.c:(.text+0x1e58): undefined reference to `__tracepoint_session_pkt_expired'
>> or1k-linux-ld: l2tp_core.c:(.text+0x1e90): undefined reference to `__tracepoint_session_pkt_expired'
>> or1k-linux-ld: l2tp_core.c:(.text+0x1fe0): undefined reference to `__traceiter_session_pkt_expired'
   l2tp_core.c:(.text+0x1fe0): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `__traceiter_session_pkt_expired'
>> or1k-linux-ld: l2tp_core.c:(.text+0x21ac): undefined reference to `__tracepoint_session_seqnum_reset'
   or1k-linux-ld: l2tp_core.c:(.text+0x21b8): undefined reference to `__tracepoint_session_seqnum_reset'
>> or1k-linux-ld: l2tp_core.c:(.text+0x227c): undefined reference to `__traceiter_session_seqnum_reset'
   l2tp_core.c:(.text+0x227c): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `__traceiter_session_seqnum_reset'
   or1k-linux-ld: net/l2tp/l2tp_core.o: in function `l2tp_tunnel_delete':
>> (.text+0x2c7c): undefined reference to `__tracepoint_delete_tunnel'
>> or1k-linux-ld: (.text+0x2c80): undefined reference to `__tracepoint_delete_tunnel'
>> or1k-linux-ld: (.text+0x2d4c): undefined reference to `__traceiter_delete_tunnel'
   (.text+0x2d4c): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `__traceiter_delete_tunnel'
   or1k-linux-ld: net/l2tp/l2tp_core.o: in function `l2tp_tunnel_dec_refcount':
>> (.text+0x3414): undefined reference to `__tracepoint_free_tunnel'
>> or1k-linux-ld: (.text+0x3418): undefined reference to `__tracepoint_free_tunnel'
>> or1k-linux-ld: (.text+0x34e8): undefined reference to `__traceiter_free_tunnel'
   (.text+0x34e8): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `__traceiter_free_tunnel'
   or1k-linux-ld: net/l2tp/l2tp_core.o: in function `l2tp_session_dec_refcount':
>> (.text+0x36c4): undefined reference to `__tracepoint_free_session'
>> or1k-linux-ld: (.text+0x36c8): undefined reference to `__tracepoint_free_session'
>> or1k-linux-ld: (.text+0x3798): undefined reference to `__traceiter_free_session'
   (.text+0x3798): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `__traceiter_free_session'
   or1k-linux-ld: net/l2tp/l2tp_core.o: in function `l2tp_tunnel_register':
>> (.text+0x3db8): undefined reference to `__tracepoint_register_tunnel'
>> or1k-linux-ld: (.text+0x3dbc): undefined reference to `__tracepoint_register_tunnel'
>> or1k-linux-ld: (.text+0x3e7c): undefined reference to `__traceiter_register_tunnel'
   (.text+0x3e7c): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `__traceiter_register_tunnel'
   or1k-linux-ld: net/l2tp/l2tp_core.o: in function `l2tp_recv_data_seq':
   l2tp_core.c:(.text+0x4074): undefined reference to `__tracepoint_session_pkt_outside_rx_window'
   or1k-linux-ld: l2tp_core.c:(.text+0x4078): undefined reference to `__tracepoint_session_pkt_outside_rx_window'
   or1k-linux-ld: l2tp_core.c:(.text+0x4138): undefined reference to `__traceiter_session_pkt_outside_rx_window'
   l2tp_core.c:(.text+0x4138): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `__traceiter_session_pkt_outside_rx_window'
   or1k-linux-ld: l2tp_core.c:(.text+0x43b0): undefined reference to `__tracepoint_session_pkt_oos'
   or1k-linux-ld: l2tp_core.c:(.text+0x43b4): undefined reference to `__tracepoint_session_pkt_oos'
   or1k-linux-ld: l2tp_core.c:(.text+0x446c): undefined reference to `__traceiter_session_pkt_oos'
   l2tp_core.c:(.text+0x446c): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `__traceiter_session_pkt_oos'
   or1k-linux-ld: net/l2tp/l2tp_core.o: in function `l2tp_session_delete':
   (.text+0x45dc): undefined reference to `__tracepoint_delete_session'
   or1k-linux-ld: (.text+0x45e0): undefined reference to `__tracepoint_delete_session'
   or1k-linux-ld: (.text+0x46ac): undefined reference to `__traceiter_delete_session'
   (.text+0x46ac): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `__traceiter_delete_session'
   or1k-linux-ld: net/l2tp/l2tp_core.o: in function `l2tp_session_register':
   (.text+0x525c): undefined reference to `__tracepoint_register_session'
   or1k-linux-ld: (.text+0x5260): undefined reference to `__tracepoint_register_session'
   or1k-linux-ld: (.text+0x5320): undefined reference to `__traceiter_register_session'
   (.text+0x5320): additional relocation overflows omitted from the output
   or1k-linux-ld: net/l2tp/l2tp_core.o: in function `l2tp_recv_common':
   (.text+0x55c4): undefined reference to `__tracepoint_session_seqnum_lns_enable'
   or1k-linux-ld: (.text+0x55d0): undefined reference to `__tracepoint_session_seqnum_lns_enable'
   or1k-linux-ld: (.text+0x5694): undefined reference to `__traceiter_session_seqnum_lns_enable'
   or1k-linux-ld: (.text+0x5818): undefined reference to `__tracepoint_session_seqnum_lns_disable'
   or1k-linux-ld: (.text+0x581c): undefined reference to `__tracepoint_session_seqnum_lns_disable'
   or1k-linux-ld: (.text+0x58e0): undefined reference to `__traceiter_session_seqnum_lns_disable'

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
