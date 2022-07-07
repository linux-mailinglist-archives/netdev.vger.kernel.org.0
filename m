Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE34656A7EA
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 18:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbiGGQV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 12:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235881AbiGGQV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 12:21:56 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B582B245
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 09:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657210915; x=1688746915;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jfS20c82Owhe4A7rVEXB12ChunYTYMYQMvsGEKbzCF4=;
  b=AJN/mGlF+BpAs/E2V9EsbQCZpEZ2XxGjmaUrVmENF03KIGQDwjzmiVcY
   3KHJf5dJ2truODTmLOafmlAy8fflNVBOlW3eetZkwyyC+9Zxb3YJlYeMT
   7H7OiJJpNHeFM4zSKBAkHEfriAKJxZ+XetR/zZBLZwA9RbTbThKBuAoQM
   LVpY/tPzHnpXlaLCnClx4xN/T11v6krSBD6lK7cOVcm/2ivbYNmVdAvql
   lwoIlCl2FE7dGRDFy61L9fsT180iJbvhFPdQDVBGLYYztoaia42HT7yx9
   3mIkU/wUj0FCJj4IhCXt3C9OjMlsN/zvt/gb354n5kNpPLmW47Ri43GXs
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="285192543"
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="285192543"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 09:21:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="661443939"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 07 Jul 2022 09:21:51 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o9UGF-000MDE-1m;
        Thu, 07 Jul 2022 16:21:51 +0000
Date:   Fri, 8 Jul 2022 00:21:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 5/6] tls: create an internal header
Message-ID: <202207080051.XdhPoIde-lkp@intel.com>
References: <20220707013510.1372695-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707013510.1372695-6-kuba@kernel.org>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Kicinski/tls-pad-strparser-internal-header-decrypt_ctx-etc/20220707-120420
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git cd355d0bc60df51266d228c0f69570cdcfa1e6ba
config: i386-randconfig-a015 (https://download.01.org/0day-ci/archive/20220708/202207080051.XdhPoIde-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 66ae1d60bb278793fd651cece264699d522bab84)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/4088937ef16f0f7a85bc39bb89ab75b33d5e8774
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jakub-Kicinski/tls-pad-strparser-internal-header-decrypt_ctx-etc/20220707-120420
        git checkout 4088937ef16f0f7a85bc39bb89ab75b33d5e8774
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/ethernet/netronome/nfp/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/ethernet/netronome/nfp/nfp_net_common.c:636:4: error: call to undeclared function 'tls_offload_tx_resync_request'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                           tls_offload_tx_resync_request(nskb->sk, seq,
                           ^
   drivers/net/ethernet/netronome/nfp/nfp_net_common.c:636:4: note: did you mean 'tls_offload_rx_resync_request'?
   include/net/tls.h:420:20: note: 'tls_offload_rx_resync_request' declared here
   static inline void tls_offload_rx_resync_request(struct sock *sk, __be32 seq)
                      ^
   1 error generated.


vim +/tls_offload_tx_resync_request +636 drivers/net/ethernet/netronome/nfp/nfp_net_common.c

4c3523623dc0b98 Jakub Kicinski     2015-12-01  585  
62d033309d62653 Jakub Kicinski     2022-03-21  586  struct sk_buff *
51a5e563298db5c Jakub Kicinski     2019-06-05  587  nfp_net_tls_tx(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
51a5e563298db5c Jakub Kicinski     2019-06-05  588  	       struct sk_buff *skb, u64 *tls_handle, int *nr_frags)
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  589  {
c8d3928ea7e7e53 Jakub Kicinski     2019-07-08  590  #ifdef CONFIG_TLS_DEVICE
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  591  	struct nfp_net_tls_offload_ctx *ntls;
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  592  	struct sk_buff *nskb;
9ed431c1d7cf8c3 Jakub Kicinski     2019-06-10  593  	bool resync_pending;
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  594  	u32 datalen, seq;
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  595  
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  596  	if (likely(!dp->ktls_tx))
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  597  		return skb;
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  598  	if (!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk))
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  599  		return skb;
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  600  
504148fedb85429 Eric Dumazet       2022-06-30  601  	datalen = skb->len - skb_tcp_all_headers(skb);
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  602  	seq = ntohl(tcp_hdr(skb)->seq);
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  603  	ntls = tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
9ed431c1d7cf8c3 Jakub Kicinski     2019-06-10  604  	resync_pending = tls_offload_tx_resync_pending(skb->sk);
9ed431c1d7cf8c3 Jakub Kicinski     2019-06-10  605  	if (unlikely(resync_pending || ntls->next_seq != seq)) {
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  606  		/* Pure ACK out of order already */
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  607  		if (!datalen)
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  608  			return skb;
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  609  
51a5e563298db5c Jakub Kicinski     2019-06-05  610  		u64_stats_update_begin(&r_vec->tx_sync);
51a5e563298db5c Jakub Kicinski     2019-06-05  611  		r_vec->tls_tx_fallback++;
51a5e563298db5c Jakub Kicinski     2019-06-05  612  		u64_stats_update_end(&r_vec->tx_sync);
51a5e563298db5c Jakub Kicinski     2019-06-05  613  
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  614  		nskb = tls_encrypt_skb(skb);
51a5e563298db5c Jakub Kicinski     2019-06-05  615  		if (!nskb) {
51a5e563298db5c Jakub Kicinski     2019-06-05  616  			u64_stats_update_begin(&r_vec->tx_sync);
51a5e563298db5c Jakub Kicinski     2019-06-05  617  			r_vec->tls_tx_no_fallback++;
51a5e563298db5c Jakub Kicinski     2019-06-05  618  			u64_stats_update_end(&r_vec->tx_sync);
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  619  			return NULL;
51a5e563298db5c Jakub Kicinski     2019-06-05  620  		}
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  621  		/* encryption wasn't necessary */
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  622  		if (nskb == skb)
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  623  			return skb;
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  624  		/* we don't re-check ring space */
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  625  		if (unlikely(skb_is_nonlinear(nskb))) {
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  626  			nn_dp_warn(dp, "tls_encrypt_skb() produced fragmented frame\n");
51a5e563298db5c Jakub Kicinski     2019-06-05  627  			u64_stats_update_begin(&r_vec->tx_sync);
51a5e563298db5c Jakub Kicinski     2019-06-05  628  			r_vec->tx_errors++;
51a5e563298db5c Jakub Kicinski     2019-06-05  629  			u64_stats_update_end(&r_vec->tx_sync);
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  630  			dev_kfree_skb_any(nskb);
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  631  			return NULL;
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  632  		}
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  633  
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  634  		/* jump forward, a TX may have gotten lost, need to sync TX */
9ed431c1d7cf8c3 Jakub Kicinski     2019-06-10  635  		if (!resync_pending && seq - ntls->next_seq < U32_MAX / 4)
8538d29cea9530f Jakub Kicinski     2019-10-04 @636  			tls_offload_tx_resync_request(nskb->sk, seq,
8538d29cea9530f Jakub Kicinski     2019-10-04  637  						      ntls->next_seq);
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  638  
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  639  		*nr_frags = 0;
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  640  		return nskb;
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  641  	}
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  642  
51a5e563298db5c Jakub Kicinski     2019-06-05  643  	if (datalen) {
51a5e563298db5c Jakub Kicinski     2019-06-05  644  		u64_stats_update_begin(&r_vec->tx_sync);
427545b3046326c Jakub Kicinski     2019-07-08  645  		if (!skb_is_gso(skb))
51a5e563298db5c Jakub Kicinski     2019-06-05  646  			r_vec->hw_tls_tx++;
427545b3046326c Jakub Kicinski     2019-07-08  647  		else
427545b3046326c Jakub Kicinski     2019-07-08  648  			r_vec->hw_tls_tx += skb_shinfo(skb)->gso_segs;
51a5e563298db5c Jakub Kicinski     2019-06-05  649  		u64_stats_update_end(&r_vec->tx_sync);
51a5e563298db5c Jakub Kicinski     2019-06-05  650  	}
51a5e563298db5c Jakub Kicinski     2019-06-05  651  
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  652  	memcpy(tls_handle, ntls->fw_handle, sizeof(ntls->fw_handle));
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  653  	ntls->next_seq += datalen;
c8d3928ea7e7e53 Jakub Kicinski     2019-07-08  654  #endif
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  655  	return skb;
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  656  }
c3991d397f2a4d8 Dirk van der Merwe 2019-06-05  657  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
