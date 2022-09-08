Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E535B15D5
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 09:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiIHHmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 03:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiIHHmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 03:42:04 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D8BCD509;
        Thu,  8 Sep 2022 00:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662622923; x=1694158923;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/WhuhHRr+qNbzKaxn/IfB3Tc7Nozbtt3QSWS3t4bqwg=;
  b=Nnfj8rt2689XlO5gi6HTvjKS/xVboysaleU0EOgeaVP3cIxWwS6qB24N
   Icdhjnrt24EB3Ldz9HSggesP6K22kUoV+meNw5rX3Fn5sPOYfuVrf3yG/
   Feq/bgUbG5xQrjwLCNjvVNReBDQwEm1oofTeseu5PRiHIAjvhT9fEc/rP
   zM9jlWDjT80YIH3+DOSaPcFA1H4S5j7XuuWrW4/zEA0dg/3F84RM1WwoM
   Z4OqCViEH9uID7Eku2bZv71nsKTk7dZ1bWqzMGdC32xXt6OJaP04QoskC
   M+eEu6ygkqtZbREFA/rbH6TpH05MfGfBGgIo3vNS7NIeLRYqRSpWsyTpN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10463"; a="284116733"
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="284116733"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 00:42:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="647945150"
Received: from lkp-server02.sh.intel.com (HELO 95dfd251caa2) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 08 Sep 2022 00:41:56 -0700
Received: from kbuild by 95dfd251caa2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oWCAd-0007VF-10;
        Thu, 08 Sep 2022 07:41:55 +0000
Date:   Thu, 8 Sep 2022 15:41:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jingyu Wang <jingyuwang_vip@163.com>, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingyu Wang <jingyuwang_vip@163.com>
Subject: Re: [PATCH] net: ipv4: Fix some coding style in ah4.c file
Message-ID: <202209081543.BAjUZP1r-lkp@intel.com>
References: <20220908022118.57973-1-jingyuwang_vip@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908022118.57973-1-jingyuwang_vip@163.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jingyu,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on 5957ac6635a1a12d4aa2661bbf04d3085a73372a]

url:    https://github.com/intel-lab-lkp/linux/commits/Jingyu-Wang/net-ipv4-Fix-some-coding-style-in-ah4-c-file/20220908-102444
base:   5957ac6635a1a12d4aa2661bbf04d3085a73372a
config: i386-randconfig-a015 (https://download.01.org/0day-ci/archive/20220908/202209081543.BAjUZP1r-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/603895160512cd6e8f03a032b6523d1b90aa2d7c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jingyu-Wang/net-ipv4-Fix-some-coding-style-in-ah4-c-file/20220908-102444
        git checkout 603895160512cd6e8f03a032b6523d1b90aa2d7c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/ipv4/ah4.c:168:38: error: extraneous ')' before ';'
           err = skb_cow_data(skb, 0, &trailer));
                                               ^
   1 error generated.


vim +168 net/ipv4/ah4.c

   146	
   147	static int ah_output(struct xfrm_state *x, struct sk_buff *skb)
   148	{
   149		int err;
   150		int nfrags;
   151		int ihl;
   152		u8 *icv;
   153		struct sk_buff *trailer;
   154		struct crypto_ahash *ahash;
   155		struct ahash_request *req;
   156		struct scatterlist *sg;
   157		struct iphdr *iph, *top_iph;
   158		struct ip_auth_hdr *ah;
   159		struct ah_data *ahp;
   160		int seqhi_len = 0;
   161		__be32 *seqhi;
   162		int sglists = 0;
   163		struct scatterlist *seqhisg;
   164	
   165		ahp = x->data;
   166		ahash = ahp->ahash;
   167	
 > 168		err = skb_cow_data(skb, 0, &trailer));
   169		if (err < 0)
   170			goto out;
   171		nfrags = err;
   172	
   173		skb_push(skb, -skb_network_offset(skb));
   174		ah = ip_auth_hdr(skb);
   175		ihl = ip_hdrlen(skb);
   176	
   177		if (x->props.flags & XFRM_STATE_ESN) {
   178			sglists = 1;
   179			seqhi_len = sizeof(*seqhi);
   180		}
   181		err = -ENOMEM;
   182		iph = ah_alloc_tmp(ahash, nfrags + sglists, ihl + seqhi_len);
   183		if (!iph)
   184			goto out;
   185		seqhi = (__be32 *)((char *)iph + ihl);
   186		icv = ah_tmp_icv(ahash, seqhi, seqhi_len);
   187		req = ah_tmp_req(ahash, icv);
   188		sg = ah_req_sg(ahash, req);
   189		seqhisg = sg + nfrags;
   190	
   191		memset(ah->auth_data, 0, ahp->icv_trunc_len);
   192	
   193		top_iph = ip_hdr(skb);
   194	
   195		iph->tos = top_iph->tos;
   196		iph->ttl = top_iph->ttl;
   197		iph->frag_off = top_iph->frag_off;
   198	
   199		if (top_iph->ihl != 5) {
   200			iph->daddr = top_iph->daddr;
   201			memcpy(iph+1, top_iph+1, top_iph->ihl*4 - sizeof(struct iphdr));
   202			err = ip_clear_mutable_options(top_iph, &top_iph->daddr);
   203			if (err)
   204				goto out_free;
   205		}
   206	
   207		ah->nexthdr = *skb_mac_header(skb);
   208		*skb_mac_header(skb) = IPPROTO_AH;
   209	
   210		top_iph->tos = 0;
   211		top_iph->tot_len = htons(skb->len);
   212		top_iph->frag_off = 0;
   213		top_iph->ttl = 0;
   214		top_iph->check = 0;
   215	
   216		if (x->props.flags & XFRM_STATE_ALIGN4)
   217			ah->hdrlen  = (XFRM_ALIGN4(sizeof(*ah) + ahp->icv_trunc_len) >> 2) - 2;
   218		else
   219			ah->hdrlen  = (XFRM_ALIGN8(sizeof(*ah) + ahp->icv_trunc_len) >> 2) - 2;
   220	
   221		ah->reserved = 0;
   222		ah->spi = x->id.spi;
   223		ah->seq_no = htonl(XFRM_SKB_CB(skb)->seq.output.low);
   224	
   225		sg_init_table(sg, nfrags + sglists);
   226		err = skb_to_sgvec_nomark(skb, sg, 0, skb->len);
   227		if (unlikely(err < 0))
   228			goto out_free;
   229	
   230		if (x->props.flags & XFRM_STATE_ESN) {
   231			/* Attach seqhi sg right after packet payload */
   232			*seqhi = htonl(XFRM_SKB_CB(skb)->seq.output.hi);
   233			sg_set_buf(seqhisg, seqhi, seqhi_len);
   234		}
   235		ahash_request_set_crypt(req, sg, icv, skb->len + seqhi_len);
   236		ahash_request_set_callback(req, 0, ah_output_done, skb);
   237	
   238		AH_SKB_CB(skb)->tmp = iph;
   239	
   240		err = crypto_ahash_digest(req);
   241		if (err) {
   242			if (err == -EINPROGRESS)
   243				goto out;
   244	
   245			if (err == -ENOSPC)
   246				err = NET_XMIT_DROP;
   247			goto out_free;
   248		}
   249	
   250		memcpy(ah->auth_data, icv, ahp->icv_trunc_len);
   251	
   252		top_iph->tos = iph->tos;
   253		top_iph->ttl = iph->ttl;
   254		top_iph->frag_off = iph->frag_off;
   255		if (top_iph->ihl != 5) {
   256			top_iph->daddr = iph->daddr;
   257			memcpy(top_iph+1, iph+1, top_iph->ihl*4 - sizeof(struct iphdr));
   258		}
   259	
   260	out_free:
   261		kfree(iph);
   262	out:
   263		return err;
   264	}
   265	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
