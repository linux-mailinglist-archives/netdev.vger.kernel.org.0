Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B595545956
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 02:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238800AbiFJAw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 20:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238500AbiFJAw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 20:52:58 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D6C15242C
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 17:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654822377; x=1686358377;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E+4rrR1qLpZJaRWJf29NKNlPnsb9GS5ZFkXoXeK3wcU=;
  b=CEYpryJr4LF118gZeBUclVMJniMU4EuYdOi+5xtUAU9epPdeHn3ZkFu4
   pgaJ+d6Cm5v4XhFJxRX7yaKkp20FzbI7ecTRRNSxmdokxJ7s/Kk7jvCsO
   atweZoGjBrmMSHHQNdbu8tx5oOl3SJYW0udqapShkVARXgXLSoYnVOVQf
   WmMfDml36HOc7XKLzGJ5+3yvNUSkSUoOAGpmG0Spcs0KGLl1XHjz5vyE8
   bHOKs1Su1pRJtnV49/w1ncyVjJe4DX/5AQjf6VCEPDvKtyWSWM6CEuXrn
   kHLScCcOktXlo/fTURfKkg9/YnaeqwCYC6o/Gq6O8v0i91aRTn4ZblKJ3
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="257295924"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="257295924"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 17:52:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="556151566"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 09 Jun 2022 17:52:54 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nzStS-000GXT-3H;
        Fri, 10 Jun 2022 00:52:54 +0000
Date:   Fri, 10 Jun 2022 08:52:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Anton Makarov <antonmakarov11235@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, david.lebrun@uclouvain.be, kuba@kernel.org
Cc:     kbuild-all@lists.01.org,
        Anton Makarov <anton.makarov11235@gmail.com>
Subject: Re: [net-next 1/1] net: seg6: Add support for SRv6 Headend Reduced
 Encapsulation
Message-ID: <202206100834.gCKYSSPQ-lkp@intel.com>
References: <20220608112646.9331-1-anton.makarov11235@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608112646.9331-1-anton.makarov11235@gmail.com>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Anton,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Anton-Makarov/net-seg6-Add-support-for-SRv6-Headend-Reduced-Encapsulation/20220608-193600
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git da6e113ff010815fdd21ee1e9af2e8d179a2680f
config: parisc-randconfig-s032-20220608 (https://download.01.org/0day-ci/archive/20220610/202206100834.gCKYSSPQ-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 11.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-26-gb3cf30ba-dirty
        # https://github.com/intel-lab-lkp/linux/commit/16ea0251e14bdf1f5dea8a1a90318df7aac69038
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Anton-Makarov/net-seg6-Add-support-for-SRv6-Headend-Reduced-Encapsulation/20220608-193600
        git checkout 16ea0251e14bdf1f5dea8a1a90318df7aac69038
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=parisc SHELL=/bin/bash net/ipv6/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> net/ipv6/seg6_iptunnel.c:237:56: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected restricted __be32 [usertype] flowinfo @@     got unsigned char [usertype] tos @@
   net/ipv6/seg6_iptunnel.c:237:56: sparse:     expected restricted __be32 [usertype] flowinfo
   net/ipv6/seg6_iptunnel.c:237:56: sparse:     got unsigned char [usertype] tos

vim +237 net/ipv6/seg6_iptunnel.c

   199	
   200	/* encapsulate an IPv6 packet within an outer IPv6 header with reduced SRH */
   201	int seg6_do_srh_encap_red(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
   202	{
   203		struct dst_entry *dst = skb_dst(skb);
   204		struct net *net = dev_net(dst->dev);
   205		struct ipv6hdr *hdr, *inner_hdr6;
   206		struct iphdr *inner_hdr4;
   207		struct ipv6_sr_hdr *isrh;
   208		int hdrlen = 0, tot_len, err;
   209		__be32 flowlabel = 0;
   210	
   211		if (osrh->first_segment > 0)
   212			hdrlen = (osrh->hdrlen - 1) << 3;
   213	
   214		tot_len = hdrlen + sizeof(struct ipv6hdr);
   215	
   216		err = skb_cow_head(skb, tot_len + skb->mac_len);
   217		if (unlikely(err))
   218			return err;
   219	
   220		inner_hdr6 = ipv6_hdr(skb);
   221		inner_hdr4 = ip_hdr(skb);
   222		flowlabel = seg6_make_flowlabel(net, skb, inner_hdr6);
   223	
   224		skb_push(skb, tot_len);
   225		skb_reset_network_header(skb);
   226		skb_mac_header_rebuild(skb);
   227		hdr = ipv6_hdr(skb);
   228	
   229		memset(skb->cb, 0, 48);
   230		IP6CB(skb)->iif = skb->skb_iif;
   231	
   232		if (skb->protocol == htons(ETH_P_IPV6)) {
   233			ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr6)),
   234				     flowlabel);
   235			hdr->hop_limit = inner_hdr6->hop_limit;
   236		} else if (skb->protocol == htons(ETH_P_IP)) {
 > 237			ip6_flow_hdr(hdr, ip6_tclass(inner_hdr4->tos), flowlabel);
   238			hdr->hop_limit = inner_hdr4->ttl;
   239		}
   240	
   241		skb->protocol = htons(ETH_P_IPV6);
   242	
   243		hdr->daddr = osrh->segments[osrh->first_segment];
   244		hdr->version = 6;
   245	
   246		if (osrh->first_segment > 0) {
   247			hdr->nexthdr = NEXTHDR_ROUTING;
   248	
   249			isrh = (void *)hdr + sizeof(struct ipv6hdr);
   250			memcpy(isrh, osrh, hdrlen);
   251	
   252			isrh->nexthdr = proto;
   253			isrh->first_segment--;
   254			isrh->hdrlen -= 2;
   255		} else {
   256			hdr->nexthdr = proto;
   257		}
   258	
   259		set_tun_src(net, dst->dev, &hdr->daddr, &hdr->saddr);
   260	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
