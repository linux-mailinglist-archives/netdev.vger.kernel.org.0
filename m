Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF9287147B
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 10:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387626AbfGWI7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 04:59:05 -0400
Received: from mx.0dd.nl ([5.2.79.48]:47038 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727748AbfGWI7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 04:59:04 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 1BEEE5FD59;
        Tue, 23 Jul 2019 10:58:45 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="rFodIz7y";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id C99C01D21811;
        Tue, 23 Jul 2019 10:58:44 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com C99C01D21811
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1563872324;
        bh=fssz+7N1rUNZrYR9J/UVbRd9a/sJaPCldguteBbzxmA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=rFodIz7yYRY0y69sZ+WDsStz9TtBBqlWG61e7+1kqyycmnXawnOkc7SsFnxR1TOEV
         yD/Zvt4Rf1FCL11LNTyjQhqU6IDT51XEnwsOAQ6eDVg661VEwOSIToRYNB2FssoBP0
         JHBRKHL267Z1HwsikWi5jNK4F4+g9cTBP5WbPnaKbL07DXzWLk2Gn/RcONP3DvbL0I
         kYcZ2zyItPc/hlVbReaN1zfW7/hKe2+CvHhgKl2VPC7f/AsiH8h5q5QOF07wXffVDi
         2G16i/wnARN3L6oICQsEiKnnoa6uEO/KM1fIzlgWLOCY5qBy1FDjGsF10kIH6LOwqP
         ezqNUcyoUBF9w==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Tue, 23 Jul 2019 08:58:44 +0000
Date:   Tue, 23 Jul 2019 08:58:44 +0000
Message-ID: <20190723085844.Horde.ehPsGFdWI2BCQdl_UyzJxlS@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [net-next:master 13/14]
 drivers/net/ethernet/faraday/ftgmac100.c:777:13: error: 'skb_frag_t {aka
 struct bio_vec}' has no member named 'size'
In-Reply-To: <201907231400.Q5QaKepi%lkp@intel.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matthew,

I see the same issue for the mediatek/mtk_eth_soc driver.


Build error for mips.
In file included from ./include/linux/cache.h:5:0,
                  from ./arch/mips/include/asm/cpu-info.h:15,
                  from ./arch/mips/include/asm/cpu-features.h:13,
                  from ./arch/mips/include/asm/bitops.h:21,
                  from ./include/linux/bitops.h:19,
                  from ./include/linux/kernel.h:12,
                  from ./include/linux/list.h:9,
                  from ./include/linux/kobject.h:19,
                  from ./include/linux/device.h:16,
                  from ./include/linux/node.h:18,
                  from ./include/linux/cpu.h:17,
                  from ./include/linux/of_device.h:5,
                  from drivers/net/ethernet/mediatek/mtk_eth_soc.c:9:
drivers/net/ethernet/mediatek/mtk_eth_soc.c: In function 'mtk_cal_txd_req':
drivers/net/ethernet/mediatek/mtk_eth_soc.c:969:31: error: 'skb_frag_t  
{aka struct bio_vec}' has no member named 'size'
     nfrags += DIV_ROUND_UP(frag->size, MTK_TX_DMA_BUF_LEN);
                                ^
./include/uapi/linux/kernel.h:13:40: note: in definition of macro  
'__KERNEL_DIV_ROUND_UP'
  #define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
                                         ^
drivers/net/ethernet/mediatek/mtk_eth_soc.c:969:14: note: in expansion  
of macro 'DIV_ROUND_UP'
     nfrags += DIV_ROUND_UP(frag->size, MTK_TX_DMA_BUF_LEN);
               ^~~~~~~~~~~~
make[4]: *** [scripts/Makefile.build:274:  
drivers/net/ethernet/mediatek/mtk_eth_soc.o] Error 1
make[3]: *** [scripts/Makefile.build:490:  
drivers/net/ethernet/mediatek] Error 2
make[2]: *** [scripts/Makefile.build:490: drivers/net/ethernet] Error 2
make[1]: *** [scripts/Makefile.build:490: drivers/net] Error 2

Greats,

René


Quoting kbuild test robot <lkp@intel.com>:
> tree:    
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/davem/net-next.git  
> master
> head:   d5c3a62d0bb9b763e9378fe8f4cd79502e16cce8
> commit: 8842d285bafa9ff7719f4107b6545a11dcd41995 [13/14] net:  
> Convert skb_frag_t to bio_vec
> config: m68k-allyesconfig (attached as .config)
> compiler: m68k-linux-gcc (GCC) 7.4.0
> reproduce:
>         wget  
> https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O  
> ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 8842d285bafa9ff7719f4107b6545a11dcd41995
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.4.0 make.cross ARCH=m68k
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    drivers/net/ethernet/faraday/ftgmac100.c: In function  
> 'ftgmac100_hard_start_xmit':
>>> drivers/net/ethernet/faraday/ftgmac100.c:777:13: error:  
>>> 'skb_frag_t {aka struct bio_vec}' has no member named 'size'
>       len = frag->size;
>                 ^~
>
> vim +777 drivers/net/ethernet/faraday/ftgmac100.c
>
> 05690d633f309d7 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   701
> 0a715156656bddf drivers/net/ethernet/faraday/ftgmac100.c YueHaibing   
>            2018-09-26   702  static netdev_tx_t  
> ftgmac100_hard_start_xmit(struct sk_buff *skb,
> 43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   703  					     struct net_device *netdev)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   704  {
> 43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   705  	struct ftgmac100 *priv =  
> netdev_priv(netdev);
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   706  	struct ftgmac100_txdes *txdes,  
> *first;
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   707  	unsigned int pointer, nfrags, len,  
> i, j;
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   708  	u32 f_ctl_stat, ctl_stat, csum_vlan;
> 43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   709  	dma_addr_t map;
> 43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   710
> 9b0f7711d92bf44 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   711  	/* The HW doesn't pad small frames */
> 9b0f7711d92bf44 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   712  	if (eth_skb_pad(skb)) {
> 9b0f7711d92bf44 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   713  		netdev->stats.tx_dropped++;
> 9b0f7711d92bf44 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   714  		return NETDEV_TX_OK;
> 9b0f7711d92bf44 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   715  	}
> 9b0f7711d92bf44 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   716
> 9b0f7711d92bf44 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   717  	/* Reject oversize packets */
> 43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   718  	if (unlikely(skb->len >  
> MAX_PKT_SIZE)) {
> 43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   719  		if (net_ratelimit())
> 43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   720  			netdev_dbg(netdev, "tx packet too  
> big\n");
> 3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   721  		goto drop;
> 43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   722  	}
> 43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   723
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   724  	/* Do we have a limit on #fragments  
> ? I yet have to get a reply
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   725  	 * from Aspeed. If there's one I  
> haven't hit it.
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   726  	 */
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   727  	nfrags = skb_shinfo(skb)->nr_frags;
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   728
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   729  	/* Get header len */
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   730  	len = skb_headlen(skb);
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   731
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   732  	/* Map the packet head */
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   733  	map = dma_map_single(priv->dev,  
> skb->data, len, DMA_TO_DEVICE);
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   734  	if (dma_mapping_error(priv->dev,  
> map)) {
> 43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   735  		if (net_ratelimit())
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   736  			netdev_err(netdev, "map tx packet  
> head failed\n");
> 3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   737  		goto drop;
> 43b25ee712f72ec drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   738  	}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   739
> 83617317d2136ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   740  	/* Grab the next free tx descriptor  
> */
> 83617317d2136ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   741  	pointer = priv->tx_pointer;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   742  	txdes = first =  
> &priv->txdes[pointer];
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   743
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   744  	/* Setup it up with the packet  
> head. Don't write the head to the
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   745  	 * ring just yet
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   746  	 */
> 83617317d2136ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   747  	priv->tx_skbs[pointer] = skb;
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   748  	f_ctl_stat =  
> ftgmac100_base_tx_ctlstat(priv, pointer);
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   749  	f_ctl_stat |=  
> FTGMAC100_TXDES0_TXDMA_OWN;
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   750  	f_ctl_stat |=  
> FTGMAC100_TXDES0_TXBUF_SIZE(len);
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   751  	f_ctl_stat |= FTGMAC100_TXDES0_FTS;
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   752  	if (nfrags == 0)
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   753  		f_ctl_stat |= FTGMAC100_TXDES0_LTS;
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   754  	txdes->txdes3 = cpu_to_le32(map);
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   755
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   756  	/* Setup HW checksumming */
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   757  	csum_vlan = 0;
> 05690d633f309d7 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   758  	if (skb->ip_summed ==  
> CHECKSUM_PARTIAL &&
> 05690d633f309d7 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   759  	    !ftgmac100_prep_tx_csum(skb,  
> &csum_vlan))
> 05690d633f309d7 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   760  		goto drop;
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18   761
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18   762  	/* Add VLAN tag */
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18   763  	if (skb_vlan_tag_present(skb)) {
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18   764  		csum_vlan |=  
> FTGMAC100_TXDES1_INS_VLANTAG;
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18   765  		csum_vlan |= skb_vlan_tag_get(skb)  
> & 0xffff;
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18   766  	}
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18   767
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   768  	txdes->txdes1 =  
> cpu_to_le32(csum_vlan);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   769
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   770  	/* Next descriptor */
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   771  	pointer =  
> ftgmac100_next_tx_pointer(priv, pointer);
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   772
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   773  	/* Add the fragments */
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   774  	for (i = 0; i < nfrags; i++) {
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   775  		skb_frag_t *frag =  
> &skb_shinfo(skb)->frags[i];
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   776
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  @777  		len = frag->size;
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   778
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   779  		/* Map it */
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   780  		map = skb_frag_dma_map(priv->dev,  
> frag, 0, len,
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   781  				       DMA_TO_DEVICE);
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   782  		if (dma_mapping_error(priv->dev,  
> map))
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   783  			goto dma_err;
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   784
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   785  		/* Setup descriptor */
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   786  		priv->tx_skbs[pointer] = skb;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   787  		txdes = &priv->txdes[pointer];
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   788  		ctl_stat =  
> ftgmac100_base_tx_ctlstat(priv, pointer);
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   789  		ctl_stat |=  
> FTGMAC100_TXDES0_TXDMA_OWN;
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   790  		ctl_stat |=  
> FTGMAC100_TXDES0_TXBUF_SIZE(len);
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   791  		if (i == (nfrags - 1))
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   792  			ctl_stat |= FTGMAC100_TXDES0_LTS;
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   793  		txdes->txdes0 =  
> cpu_to_le32(ctl_stat);
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   794  		txdes->txdes1 = 0;
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   795  		txdes->txdes3 = cpu_to_le32(map);
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   796
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   797  		/* Next one */
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   798  		pointer =  
> ftgmac100_next_tx_pointer(priv, pointer);
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   799  	}
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   800
> 4a2712b2f0b6895 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   801  	/* Order the previous packet and  
> descriptor udpates
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   802  	 * before setting the OWN bit on  
> the first descriptor.
> 4a2712b2f0b6895 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   803  	 */
> 4a2712b2f0b6895 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   804  	dma_wmb();
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   805  	first->txdes0 =  
> cpu_to_le32(f_ctl_stat);
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   806
> 83617317d2136ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   807  	/* Update next TX pointer */
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   808  	priv->tx_pointer = pointer;
> 83617317d2136ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   809
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   810  	/* If there isn't enough room for  
> all the fragments of a new packet
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   811  	 * in the TX ring, stop the queue.  
> The sequence below is race free
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   812  	 * vs. a concurrent restart in  
> ftgmac100_poll()
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   813  	 */
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   814  	if  
> (unlikely(ftgmac100_tx_buf_avail(priv) < TX_THRESHOLD)) {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   815  		netif_stop_queue(netdev);
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   816  		/* Order the queue stop with the  
> test below */
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   817  		smp_mb();
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   818  		if (ftgmac100_tx_buf_avail(priv)  
> >= TX_THRESHOLD)
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   819  			netif_wake_queue(netdev);
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   820  	}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   821
> 8eecf7caad8687e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   822  	/* Poke transmitter to read the  
> updated TX descriptors */
> 8eecf7caad8687e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   823  	iowrite32(1, priv->base +  
> FTGMAC100_OFFSET_NPTXPD);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   824
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   825  	return NETDEV_TX_OK;
> 3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   826
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   827   dma_err:
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   828  	if (net_ratelimit())
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   829  		netdev_err(netdev, "map tx  
> fragment failed\n");
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   830
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   831  	/* Free head */
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   832  	pointer = priv->tx_pointer;
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   833  	ftgmac100_free_tx_packet(priv,  
> pointer, skb, first, f_ctl_stat);
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   834  	first->txdes0 =  
> cpu_to_le32(f_ctl_stat & priv->txdes0_edotr_mask);
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   835
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   836  	/* Then all fragments */
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   837  	for (j = 0; j < i; j++) {
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   838  		pointer =  
> ftgmac100_next_tx_pointer(priv, pointer);
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   839  		txdes = &priv->txdes[pointer];
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   840  		ctl_stat =  
> le32_to_cpu(txdes->txdes0);
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   841  		ftgmac100_free_tx_packet(priv,  
> pointer, skb, txdes, ctl_stat);
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   842  		txdes->txdes0 =  
> cpu_to_le32(ctl_stat & priv->txdes0_edotr_mask);
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   843  	}
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   844
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   845  	/* This cannot be reached if we  
> successfully mapped the
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   846  	 * last fragment, so we know  
> ftgmac100_free_tx_packet()
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   847  	 * hasn't freed the skb yet.
> 6db7470445f0757 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   848  	 */
> 3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   849   drop:
> 3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   850  	/* Drop the packet */
> 3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   851  	dev_kfree_skb_any(skb);
> 3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   852  	netdev->stats.tx_dropped++;
> 3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   853
> 3e427a3363edbc8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   854  	return NETDEV_TX_OK;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   855  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   856
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   857  static void  
> ftgmac100_free_buffers(struct ftgmac100 *priv)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   858  {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   859  	int i;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   860
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   861  	/* Free all RX buffers */
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   862  	for (i = 0; i < priv->rx_q_entries;  
> i++) {
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   863  		struct ftgmac100_rxdes *rxdes =  
> &priv->rxdes[i];
> 7b49cd1c9eca4ac drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   864  		struct sk_buff *skb =  
> priv->rx_skbs[i];
> 4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   865  		dma_addr_t map =  
> le32_to_cpu(rxdes->rxdes3);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   866
> 7b49cd1c9eca4ac drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   867  		if (!skb)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   868  			continue;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   869
> 7b49cd1c9eca4ac drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   870  		priv->rx_skbs[i] = NULL;
> 7b49cd1c9eca4ac drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   871  		dma_unmap_single(priv->dev, map,  
> RX_BUF_SIZE, DMA_FROM_DEVICE);
> 7b49cd1c9eca4ac drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   872  		dev_kfree_skb_any(skb);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   873  	}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   874
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   875  	/* Free all TX buffers */
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   876  	for (i = 0; i < priv->tx_q_entries;  
> i++) {
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   877  		struct ftgmac100_txdes *txdes =  
> &priv->txdes[i];
> 83617317d2136ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   878  		struct sk_buff *skb =  
> priv->tx_skbs[i];
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   879
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   880  		if (!skb)
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   881  			continue;
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   882  		ftgmac100_free_tx_packet(priv, i,  
> skb, txdes,
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   883  					 le32_to_cpu(txdes->txdes0));
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   884  	}
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   885  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   886
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   887  static void  
> ftgmac100_free_rings(struct ftgmac100 *priv)
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   888  {
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   889  	/* Free skb arrays */
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   890  	kfree(priv->rx_skbs);
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   891  	kfree(priv->tx_skbs);
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   892
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   893  	/* Free descriptors */
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   894  	if (priv->rxdes)
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   895  		dma_free_coherent(priv->dev,  
> MAX_RX_QUEUE_ENTRIES *
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   896  				  sizeof(struct ftgmac100_rxdes),
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   897  				  priv->rxdes, priv->rxdes_dma);
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   898  	priv->rxdes = NULL;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   899
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   900  	if (priv->txdes)
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   901  		dma_free_coherent(priv->dev,  
> MAX_TX_QUEUE_ENTRIES *
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   902  				  sizeof(struct ftgmac100_txdes),
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   903  				  priv->txdes, priv->txdes_dma);
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   904  	priv->txdes = NULL;
> d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   905
> d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   906  	/* Free scratch packet buffer */
> d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   907  	if (priv->rx_scratch)
> d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   908  		dma_free_coherent(priv->dev,  
> RX_BUF_SIZE,
> d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   909  				  priv->rx_scratch,  
> priv->rx_scratch_dma);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   910  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   911
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   912  static int  
> ftgmac100_alloc_rings(struct ftgmac100 *priv)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   913  {
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   914  	/* Allocate skb arrays */
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   915  	priv->rx_skbs =  
> kcalloc(MAX_RX_QUEUE_ENTRIES, sizeof(void *),
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   916  				GFP_KERNEL);
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   917  	if (!priv->rx_skbs)
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   918  		return -ENOMEM;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   919  	priv->tx_skbs =  
> kcalloc(MAX_TX_QUEUE_ENTRIES, sizeof(void *),
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   920  				GFP_KERNEL);
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   921  	if (!priv->tx_skbs)
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   922  		return -ENOMEM;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   923
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   924  	/* Allocate descriptors */
> 750afb08ca71310 drivers/net/ethernet/faraday/ftgmac100.c Luis  
> Chamberlain       2019-01-04   925  	priv->rxdes =  
> dma_alloc_coherent(priv->dev,
> 750afb08ca71310 drivers/net/ethernet/faraday/ftgmac100.c Luis  
> Chamberlain       2019-01-04   926  					 MAX_RX_QUEUE_ENTRIES *  
> sizeof(struct ftgmac100_rxdes),
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   927  					 &priv->rxdes_dma, GFP_KERNEL);
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   928  	if (!priv->rxdes)
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   929  		return -ENOMEM;
> 750afb08ca71310 drivers/net/ethernet/faraday/ftgmac100.c Luis  
> Chamberlain       2019-01-04   930  	priv->txdes =  
> dma_alloc_coherent(priv->dev,
> 750afb08ca71310 drivers/net/ethernet/faraday/ftgmac100.c Luis  
> Chamberlain       2019-01-04   931  					 MAX_TX_QUEUE_ENTRIES *  
> sizeof(struct ftgmac100_txdes),
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   932  					 &priv->txdes_dma, GFP_KERNEL);
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   933  	if (!priv->txdes)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   934  		return -ENOMEM;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   935
> d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   936  	/* Allocate scratch packet buffer */
> d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   937  	priv->rx_scratch =  
> dma_alloc_coherent(priv->dev,
> d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   938  					      RX_BUF_SIZE,
> d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   939  					      &priv->rx_scratch_dma,
> d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   940  					      GFP_KERNEL);
> d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   941  	if (!priv->rx_scratch)
> d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   942  		return -ENOMEM;
> d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   943
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   944  	return 0;
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   945  }
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   946
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   947  static void  
> ftgmac100_init_rings(struct ftgmac100 *priv)
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   948  {
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   949  	struct ftgmac100_rxdes *rxdes = NULL;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   950  	struct ftgmac100_txdes *txdes = NULL;
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   951  	int i;
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   952
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   953  	/* Update entries counts */
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   954  	priv->rx_q_entries =  
> priv->new_rx_q_entries;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   955  	priv->tx_q_entries =  
> priv->new_tx_q_entries;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   956
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   957  	if (WARN_ON(priv->rx_q_entries <  
> MIN_RX_QUEUE_ENTRIES))
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   958  		return;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   959
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   960  	/* Initialize RX ring */
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   961  	for (i = 0; i < priv->rx_q_entries;  
> i++) {
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   962  		rxdes = &priv->rxdes[i];
> d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   963  		rxdes->rxdes0 = 0;
> 4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   964  		rxdes->rxdes3 =  
> cpu_to_le32(priv->rx_scratch_dma);
> d72e01a0430f8a1 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   965  	}
> 4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   966  	/* Mark the end of the ring */
> 4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   967  	rxdes->rxdes0 |=  
> cpu_to_le32(priv->rxdes0_edorr_mask);
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   968
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   969  	if (WARN_ON(priv->tx_q_entries <  
> MIN_RX_QUEUE_ENTRIES))
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   970  		return;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   971
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   972  	/* Initialize TX ring */
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   973  	for (i = 0; i < priv->tx_q_entries;  
> i++) {
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   974  		txdes = &priv->txdes[i];
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   975  		txdes->txdes0 = 0;
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   976  	}
> 52c0cae8746513e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10   977  	txdes->txdes0 |=  
> cpu_to_le32(priv->txdes0_edotr_mask);
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   978  }
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   979
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   980  static int  
> ftgmac100_alloc_rx_buffers(struct ftgmac100 *priv)
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   981  {
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   982  	int i;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   983
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   984  	for (i = 0; i < priv->rx_q_entries;  
> i++) {
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12   985  		struct ftgmac100_rxdes *rxdes =  
> &priv->rxdes[i];
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   986
> 7b49cd1c9eca4ac drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06   987  		if (ftgmac100_alloc_rx_buf(priv,  
> i, rxdes, GFP_KERNEL))
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   988  			return -ENOMEM;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   989  	}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   990  	return 0;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   991  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   992
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   993  static void  
> ftgmac100_adjust_link(struct net_device *netdev)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   994  {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   995  	struct ftgmac100 *priv =  
> netdev_priv(netdev);
> b3c40adcc9891a7 drivers/net/ethernet/faraday/ftgmac100.c Philippe  
> Reynes        2016-05-16   996  	struct phy_device *phydev =  
> netdev->phydev;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18   997  	bool tx_pause, rx_pause;
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05   998  	int new_speed;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08   999
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1000  	/* We store "no link" as speed 0 */
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1001  	if (!phydev->link)
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1002  		new_speed = 0;
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1003  	else
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1004  		new_speed = phydev->speed;
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1005
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1006  	/* Grab pause settings from PHY if  
> configured to do so */
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1007  	if (priv->aneg_pause) {
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1008  		rx_pause = tx_pause = phydev->pause;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1009  		if (phydev->asym_pause)
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1010  			tx_pause = !rx_pause;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1011  	} else {
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1012  		rx_pause = priv->rx_pause;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1013  		tx_pause = priv->tx_pause;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1014  	}
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1015
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1016  	/* Link hasn't changed, do nothing */
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1017  	if (phydev->speed ==  
> priv->cur_speed &&
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1018  	    phydev->duplex ==  
> priv->cur_duplex &&
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1019  	    rx_pause == priv->rx_pause &&
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1020  	    tx_pause == priv->tx_pause)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1021  		return;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1022
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1023  	/* Print status if we have a link  
> or we had one and just lost it,
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1024  	 * don't print otherwise.
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1025  	 */
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1026  	if (new_speed || priv->cur_speed)
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1027  		phy_print_status(phydev);
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1028
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1029  	priv->cur_speed = new_speed;
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1030  	priv->cur_duplex = phydev->duplex;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1031  	priv->rx_pause = rx_pause;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1032  	priv->tx_pause = tx_pause;
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1033
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1034  	/* Link is down, do nothing else */
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1035  	if (!new_speed)
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1036  		return;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1037
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1038  	/* Disable all interrupts */
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1039  	iowrite32(0, priv->base +  
> FTGMAC100_OFFSET_IER);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1040
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1041  	/* Reset the adapter asynchronously  
> */
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1042  	schedule_work(&priv->reset_task);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1043  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1044
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1045  static int  
> ftgmac100_mii_probe(struct ftgmac100 *priv, phy_interface_t intf)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1046  {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1047  	struct net_device *netdev =  
> priv->netdev;
> e574f39816f0227 drivers/net/ethernet/faraday/ftgmac100.c Guenter  
> Roeck          2016-01-10  1048  	struct phy_device *phydev;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1049
> e574f39816f0227 drivers/net/ethernet/faraday/ftgmac100.c Guenter  
> Roeck          2016-01-10  1050  	phydev =  
> phy_find_first(priv->mii_bus);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1051  	if (!phydev) {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1052  		netdev_info(netdev, "%s: no PHY  
> found\n", netdev->name);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1053  		return -ENODEV;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1054  	}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1055
> 84eff6d194df442 drivers/net/ethernet/faraday/ftgmac100.c Andrew Lunn  
>            2016-01-06  1056  	phydev = phy_connect(netdev,  
> phydev_name(phydev),
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1057  			     &ftgmac100_adjust_link, intf);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1058
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1059  	if (IS_ERR(phydev)) {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1060  		netdev_err(netdev, "%s: Could  
> not attach to PHY\n", netdev->name);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1061  		return PTR_ERR(phydev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1062  	}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1063
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1064  	/* Indicate that we support PAUSE  
> frames (see comment in
> cb1aaebea8d7986 drivers/net/ethernet/faraday/ftgmac100.c Mauro  
> Carvalho Chehab  2019-06-07  1065  	 *  
> Documentation/networking/phy.rst)
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1066  	 */
> af8d9bb2f2f405a drivers/net/ethernet/faraday/ftgmac100.c Andrew Lunn  
>            2018-09-12  1067  	phy_support_asym_pause(phydev);
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1068
> 33de693248b4564 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1069  	/* Display what we found */
> 33de693248b4564 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1070  	phy_attached_info(phydev);
> 33de693248b4564 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1071
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1072  	return 0;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1073  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1074
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1075  static int  
> ftgmac100_mdiobus_read(struct mii_bus *bus, int phy_addr, int regnum)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1076  {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1077  	struct net_device *netdev =  
> bus->priv;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1078  	struct ftgmac100 *priv =  
> netdev_priv(netdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1079  	unsigned int phycr;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1080  	int i;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1081
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1082  	phycr = ioread32(priv->base +  
> FTGMAC100_OFFSET_PHYCR);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1083
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1084  	/* preserve MDC cycle threshold */
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1085  	phycr &=  
> FTGMAC100_PHYCR_MDC_CYCTHR_MASK;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1086
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1087  	phycr |=  
> FTGMAC100_PHYCR_PHYAD(phy_addr) |
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1088  		 FTGMAC100_PHYCR_REGAD(regnum) |
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1089  		 FTGMAC100_PHYCR_MIIRD;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1090
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1091  	iowrite32(phycr, priv->base +  
> FTGMAC100_OFFSET_PHYCR);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1092
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1093  	for (i = 0; i < 10; i++) {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1094  		phycr = ioread32(priv->base +  
> FTGMAC100_OFFSET_PHYCR);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1095
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1096  		if ((phycr &  
> FTGMAC100_PHYCR_MIIRD) == 0) {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1097  			int data;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1098
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1099  			data = ioread32(priv->base +  
> FTGMAC100_OFFSET_PHYDATA);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1100  			return  
> FTGMAC100_PHYDATA_MIIRDATA(data);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1101  		}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1102
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1103  		udelay(100);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1104  	}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1105
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1106  	netdev_err(netdev, "mdio read  
> timed out\n");
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1107  	return -EIO;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1108  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1109
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1110  static int  
> ftgmac100_mdiobus_write(struct mii_bus *bus, int phy_addr,
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1111  				   int regnum, u16 value)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1112  {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1113  	struct net_device *netdev =  
> bus->priv;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1114  	struct ftgmac100 *priv =  
> netdev_priv(netdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1115  	unsigned int phycr;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1116  	int data;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1117  	int i;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1118
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1119  	phycr = ioread32(priv->base +  
> FTGMAC100_OFFSET_PHYCR);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1120
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1121  	/* preserve MDC cycle threshold */
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1122  	phycr &=  
> FTGMAC100_PHYCR_MDC_CYCTHR_MASK;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1123
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1124  	phycr |=  
> FTGMAC100_PHYCR_PHYAD(phy_addr) |
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1125  		 FTGMAC100_PHYCR_REGAD(regnum) |
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1126  		 FTGMAC100_PHYCR_MIIWR;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1127
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1128  	data =  
> FTGMAC100_PHYDATA_MIIWDATA(value);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1129
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1130  	iowrite32(data, priv->base +  
> FTGMAC100_OFFSET_PHYDATA);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1131  	iowrite32(phycr, priv->base +  
> FTGMAC100_OFFSET_PHYCR);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1132
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1133  	for (i = 0; i < 10; i++) {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1134  		phycr = ioread32(priv->base +  
> FTGMAC100_OFFSET_PHYCR);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1135
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1136  		if ((phycr &  
> FTGMAC100_PHYCR_MIIWR) == 0)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1137  			return 0;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1138
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1139  		udelay(100);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1140  	}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1141
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1142  	netdev_err(netdev, "mdio write  
> timed out\n");
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1143  	return -EIO;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1144  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1145
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1146  static void  
> ftgmac100_get_drvinfo(struct net_device *netdev,
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1147  				  struct ethtool_drvinfo *info)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1148  {
> 7826d43f2db45c9 drivers/net/ethernet/faraday/ftgmac100.c Jiri Pirko   
>            2013-01-06  1149  	strlcpy(info->driver, DRV_NAME,  
> sizeof(info->driver));
> 7826d43f2db45c9 drivers/net/ethernet/faraday/ftgmac100.c Jiri Pirko   
>            2013-01-06  1150  	strlcpy(info->version, DRV_VERSION,  
> sizeof(info->version));
> 7826d43f2db45c9 drivers/net/ethernet/faraday/ftgmac100.c Jiri Pirko   
>            2013-01-06  1151  	strlcpy(info->bus_info,  
> dev_name(&netdev->dev), sizeof(info->bus_info));
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1152  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1153
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1154  static void  
> ftgmac100_get_ringparam(struct net_device *netdev,
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1155  				    struct ethtool_ringparam  
> *ering)
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1156  {
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1157  	struct ftgmac100 *priv =  
> netdev_priv(netdev);
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1158
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1159  	memset(ering, 0, sizeof(*ering));
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1160  	ering->rx_max_pending =  
> MAX_RX_QUEUE_ENTRIES;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1161  	ering->tx_max_pending =  
> MAX_TX_QUEUE_ENTRIES;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1162  	ering->rx_pending =  
> priv->rx_q_entries;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1163  	ering->tx_pending =  
> priv->tx_q_entries;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1164  }
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1165
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1166  static int  
> ftgmac100_set_ringparam(struct net_device *netdev,
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1167  				   struct ethtool_ringparam  
> *ering)
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1168  {
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1169  	struct ftgmac100 *priv =  
> netdev_priv(netdev);
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1170
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1171  	if (ering->rx_pending >  
> MAX_RX_QUEUE_ENTRIES ||
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1172  	    ering->tx_pending >  
> MAX_TX_QUEUE_ENTRIES ||
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1173  	    ering->rx_pending <  
> MIN_RX_QUEUE_ENTRIES ||
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1174  	    ering->tx_pending <  
> MIN_TX_QUEUE_ENTRIES ||
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1175  	     
> !is_power_of_2(ering->rx_pending) ||
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1176  	     
> !is_power_of_2(ering->tx_pending))
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1177  		return -EINVAL;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1178
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1179  	priv->new_rx_q_entries =  
> ering->rx_pending;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1180  	priv->new_tx_q_entries =  
> ering->tx_pending;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1181  	if (netif_running(netdev))
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1182  		schedule_work(&priv->reset_task);
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1183
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1184  	return 0;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1185  }
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1186
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1187  static void  
> ftgmac100_get_pauseparam(struct net_device *netdev,
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1188  				     struct ethtool_pauseparam  
> *pause)
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1189  {
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1190  	struct ftgmac100 *priv =  
> netdev_priv(netdev);
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1191
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1192  	pause->autoneg = priv->aneg_pause;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1193  	pause->tx_pause = priv->tx_pause;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1194  	pause->rx_pause = priv->rx_pause;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1195  }
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1196
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1197  static int  
> ftgmac100_set_pauseparam(struct net_device *netdev,
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1198  				    struct ethtool_pauseparam  
> *pause)
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1199  {
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1200  	struct ftgmac100 *priv =  
> netdev_priv(netdev);
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1201  	struct phy_device *phydev =  
> netdev->phydev;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1202
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1203  	priv->aneg_pause = pause->autoneg;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1204  	priv->tx_pause = pause->tx_pause;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1205  	priv->rx_pause = pause->rx_pause;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1206
> 70814e819c1139e drivers/net/ethernet/faraday/ftgmac100.c Andrew Lunn  
>            2018-09-12  1207  	if (phydev)
> 70814e819c1139e drivers/net/ethernet/faraday/ftgmac100.c Andrew Lunn  
>            2018-09-12  1208  		phy_set_asym_pause(phydev,  
> pause->rx_pause, pause->tx_pause);
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1209
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1210  	if (netif_running(netdev)) {
> 70814e819c1139e drivers/net/ethernet/faraday/ftgmac100.c Andrew Lunn  
>            2018-09-12  1211  		if (!(phydev && priv->aneg_pause))
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1212  			ftgmac100_config_pause(priv);
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1213  	}
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1214
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1215  	return 0;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1216  }
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1217
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1218  static const struct ethtool_ops  
> ftgmac100_ethtool_ops = {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1219  	.get_drvinfo		=  
> ftgmac100_get_drvinfo,
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1220  	.get_link		= ethtool_op_get_link,
> fd24d72ca9b5255 drivers/net/ethernet/faraday/ftgmac100.c Philippe  
> Reynes        2016-05-16  1221  	.get_link_ksettings	=  
> phy_ethtool_get_link_ksettings,
> fd24d72ca9b5255 drivers/net/ethernet/faraday/ftgmac100.c Philippe  
> Reynes        2016-05-16  1222  	.set_link_ksettings	=  
> phy_ethtool_set_link_ksettings,
> e98233a6192d75d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1223  	.nway_reset		=  
> phy_ethtool_nway_reset,
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1224  	.get_ringparam		=  
> ftgmac100_get_ringparam,
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1225  	.set_ringparam		=  
> ftgmac100_set_ringparam,
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1226  	.get_pauseparam		=  
> ftgmac100_get_pauseparam,
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1227  	.set_pauseparam		=  
> ftgmac100_set_pauseparam,
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1228  };
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1229
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1230  static irqreturn_t  
> ftgmac100_interrupt(int irq, void *dev_id)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1231  {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1232  	struct net_device *netdev =  
> dev_id;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1233  	struct ftgmac100 *priv =  
> netdev_priv(netdev);
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1234  	unsigned int status, new_mask =  
> FTGMAC100_INT_BAD;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1235
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1236  	/* Fetch and clear interrupt bits,  
> process abnormal ones */
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1237  	status = ioread32(priv->base +  
> FTGMAC100_OFFSET_ISR);
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1238  	iowrite32(status, priv->base +  
> FTGMAC100_OFFSET_ISR);
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1239  	if (unlikely(status &  
> FTGMAC100_INT_BAD)) {
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1240
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1241  		/* RX buffer unavailable */
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1242  		if (status & FTGMAC100_INT_NO_RXBUF)
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1243  			netdev->stats.rx_over_errors++;
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1244
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1245  		/* received packet lost due to RX  
> FIFO full */
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1246  		if (status &  
> FTGMAC100_INT_RPKT_LOST)
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1247  			netdev->stats.rx_fifo_errors++;
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1248
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1249  		/* sent packet lost due to  
> excessive TX collision */
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1250  		if (status &  
> FTGMAC100_INT_XPKT_LOST)
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1251  			netdev->stats.tx_fifo_errors++;
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1252
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1253  		/* AHB error -> Reset the chip */
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1254  		if (status &  
> FTGMAC100_INT_AHB_ERR) {
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1255  			if (net_ratelimit())
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1256  				netdev_warn(netdev,
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1257  					   "AHB bus error ! Resetting  
> chip.\n");
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1258  			iowrite32(0, priv->base +  
> FTGMAC100_OFFSET_IER);
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1259  			schedule_work(&priv->reset_task);
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1260  			return IRQ_HANDLED;
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1261  		}
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1262
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1263  		/* We may need to restart the MAC  
> after such errors, delay
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1264  		 * this until after we have freed  
> some Rx buffers though
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1265  		 */
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1266  		priv->need_mac_restart = true;
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1267
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1268  		/* Disable those errors until we  
> restart */
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1269  		new_mask &= ~status;
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1270  	}
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1271
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1272  	/* Only enable "bad" interrupts  
> while NAPI is on */
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1273  	iowrite32(new_mask, priv->base +  
> FTGMAC100_OFFSET_IER);
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1274
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1275  	/* Schedule NAPI bh */
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1276  	napi_schedule_irqoff(&priv->napi);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1277
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1278  	return IRQ_HANDLED;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1279  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1280
> 4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06  1281  static bool  
> ftgmac100_check_rx(struct ftgmac100 *priv)
> 4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06  1282  {
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1283  	struct ftgmac100_rxdes *rxdes =  
> &priv->rxdes[priv->rx_pointer];
> 4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06  1284
> 4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06  1285  	/* Do we have a packet ? */
> 4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06  1286  	return !!(rxdes->rxdes0 &  
> cpu_to_le32(FTGMAC100_RXDES0_RXPKT_RDY));
> 4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06  1287  }
> 4ca24152d891950 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-06  1288
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1289  static int ftgmac100_poll(struct  
> napi_struct *napi, int budget)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1290  {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1291  	struct ftgmac100 *priv =  
> container_of(napi, struct ftgmac100, napi);
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1292  	int work_done = 0;
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1293  	bool more;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1294
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1295  	/* Handle TX completions */
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1296  	if (ftgmac100_tx_buf_cleanable(priv))
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1297  		ftgmac100_tx_complete(priv);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1298
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1299  	/* Handle RX packets */
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1300  	do {
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1301  		more = ftgmac100_rx_packet(priv,  
> &work_done);
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1302  	} while (more && work_done < budget);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1303
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1304
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1305  	/* The interrupt is telling us to  
> kick the MAC back to life
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1306  	 * after an RX overflow
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1307  	 */
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1308  	if  
> (unlikely(priv->need_mac_restart)) {
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1309  		ftgmac100_start_hw(priv);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1310
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1311  		/* Re-enable "bad" interrupts */
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1312  		iowrite32(FTGMAC100_INT_BAD,
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1313  			  priv->base +  
> FTGMAC100_OFFSET_IER);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1314  	}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1315
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1316  	/* As long as we are waiting for  
> transmit packets to be
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1317  	 * completed we keep NAPI going
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1318  	 */
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1319  	if (ftgmac100_tx_buf_cleanable(priv))
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1320  		work_done = budget;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1321
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1322  	if (work_done < budget) {
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1323  		/* We are about to re-enable all  
> interrupts. However
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1324  		 * the HW has been latching RX/TX  
> packet interrupts while
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1325  		 * they were masked. So we clear  
> them first, then we need
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1326  		 * to re-check if there's  
> something to process
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1327  		 */
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1328  		iowrite32(FTGMAC100_INT_RXTX,
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1329  			  priv->base +  
> FTGMAC100_OFFSET_ISR);
> ccaf725a1fd7904 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1330
> ccaf725a1fd7904 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1331  		/* Push the above (and provides a  
> barrier vs. subsequent
> ccaf725a1fd7904 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1332  		 * reads of the descriptor).
> ccaf725a1fd7904 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1333  		 */
> ccaf725a1fd7904 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1334  		ioread32(priv->base +  
> FTGMAC100_OFFSET_ISR);
> ccaf725a1fd7904 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1335
> ccaf725a1fd7904 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1336  		/* Check RX and TX descriptors for  
> more work to do */
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1337  		if (ftgmac100_check_rx(priv) ||
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1338  		     
> ftgmac100_tx_buf_cleanable(priv))
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1339  			return budget;
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1340
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1341  		/* deschedule NAPI */
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1342  		napi_complete(napi);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1343
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1344  		/* enable all interrupts */
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1345  		iowrite32(FTGMAC100_INT_ALL,
> fc6061cf93524c3 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1346  			  priv->base + FTGMAC100_OFFSET_IER);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1347  	}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1348
> 6ad3d7edcbdae23 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1349  	return work_done;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1350  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1351
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1352  static int ftgmac100_init_all(struct  
> ftgmac100 *priv, bool ignore_alloc_err)
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1353  {
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1354  	int err = 0;
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1355
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1356  	/* Re-init descriptors (adjust  
> queue sizes) */
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1357  	ftgmac100_init_rings(priv);
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1358
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1359  	/* Realloc rx descriptors */
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1360  	err =  
> ftgmac100_alloc_rx_buffers(priv);
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1361  	if (err && !ignore_alloc_err)
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1362  		return err;
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1363
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1364  	/* Reinit and restart HW */
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1365  	ftgmac100_init_hw(priv);
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1366  	ftgmac100_config_pause(priv);
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1367  	ftgmac100_start_hw(priv);
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1368
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1369  	/* Re-enable the device */
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1370  	napi_enable(&priv->napi);
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1371  	netif_start_queue(priv->netdev);
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1372
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1373  	/* Enable all interrupts */
> 10cbd640760991b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1374  	iowrite32(FTGMAC100_INT_ALL,  
> priv->base + FTGMAC100_OFFSET_IER);
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1375
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1376  	return err;
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1377  }
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1378
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1379  static void  
> ftgmac100_reset_task(struct work_struct *work)
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1380  {
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1381  	struct ftgmac100 *priv =  
> container_of(work, struct ftgmac100,
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1382  					      reset_task);
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1383  	struct net_device *netdev =  
> priv->netdev;
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1384  	int err;
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1385
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1386  	netdev_dbg(netdev, "Resetting  
> NIC...\n");
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1387
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1388  	/* Lock the world */
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1389  	rtnl_lock();
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1390  	if (netdev->phydev)
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1391  		mutex_lock(&netdev->phydev->lock);
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1392  	if (priv->mii_bus)
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1393   
> 		mutex_lock(&priv->mii_bus->mdio_lock);
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1394
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1395
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1396  	/* Check if the interface is still  
> up */
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1397  	if (!netif_running(netdev))
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1398  		goto bail;
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1399
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1400  	/* Stop the network stack */
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1401  	netif_trans_update(netdev);
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1402  	napi_disable(&priv->napi);
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1403  	netif_tx_disable(netdev);
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1404
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1405  	/* Stop and reset the MAC */
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1406  	ftgmac100_stop_hw(priv);
> 874b55bf62330ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1407  	err =  
> ftgmac100_reset_and_config_mac(priv);
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1408  	if (err) {
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1409  		/* Not much we can do ... it might  
> come back... */
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1410  		netdev_err(netdev, "attempting to  
> continue...\n");
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1411  	}
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1412
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1413  	/* Free all rx and tx buffers */
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1414  	ftgmac100_free_buffers(priv);
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1415
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1416  	/* Setup everything again and  
> restart chip */
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1417  	ftgmac100_init_all(priv, true);
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1418
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1419  	netdev_dbg(netdev, "Reset done !\n");
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1420   bail:
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1421  	if (priv->mii_bus)
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1422   
> 		mutex_unlock(&priv->mii_bus->mdio_lock);
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1423  	if (netdev->phydev)
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1424  		mutex_unlock(&netdev->phydev->lock);
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1425  	rtnl_unlock();
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1426  }
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1427
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1428  static int ftgmac100_open(struct  
> net_device *netdev)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1429  {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1430  	struct ftgmac100 *priv =  
> netdev_priv(netdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1431  	int err;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1432
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1433  	/* Allocate ring buffers  */
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1434  	err = ftgmac100_alloc_rings(priv);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1435  	if (err) {
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1436  		netdev_err(netdev, "Failed to  
> allocate descriptors\n");
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1437  		return err;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1438  	}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1439
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1440  	/* When using NC-SI we force the  
> speed to 100Mbit/s full duplex,
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1441  	 *
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1442  	 * Otherwise we leave it set to 0  
> (no link), the link
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1443  	 * message from the PHY layer will  
> handle setting it up to
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1444  	 * something else if needed.
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1445  	 */
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1446  	if (priv->use_ncsi) {
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1447  		priv->cur_duplex = DUPLEX_FULL;
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1448  		priv->cur_speed = SPEED_100;
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1449  	} else {
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1450  		priv->cur_duplex = 0;
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1451  		priv->cur_speed = 0;
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1452  	}
> 51764777354664b drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1453
> 874b55bf62330ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1454  	/* Reset the hardware */
> 874b55bf62330ca drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1455  	err =  
> ftgmac100_reset_and_config_mac(priv);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1456  	if (err)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1457  		goto err_hw;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1458
> b8dbecff9bab825 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1459  	/* Initialize NAPI */
> b8dbecff9bab825 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1460  	netif_napi_add(netdev, &priv->napi,  
> ftgmac100_poll, 64);
> b8dbecff9bab825 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1461
> 81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1462  	/* Grab our interrupt */
> 81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1463  	err = request_irq(netdev->irq,  
> ftgmac100_interrupt, 0, netdev->name, netdev);
> 81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1464  	if (err) {
> 81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1465  		netdev_err(netdev, "failed to  
> request irq %d\n", netdev->irq);
> 81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1466  		goto err_irq;
> 81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1467  	}
> 81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1468
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1469  	/* Start things up */
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1470  	err = ftgmac100_init_all(priv,  
> false);
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1471  	if (err) {
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1472  		netdev_err(netdev, "Failed to  
> allocate packet buffers\n");
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1473  		goto err_alloc;
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1474  	}
> 08c9c126004e999 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-09-22  1475
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1476  	if (netdev->phydev) {
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1477  		/* If we have a PHY, start polling  
> */
> b3c40adcc9891a7 drivers/net/ethernet/faraday/ftgmac100.c Philippe  
> Reynes        2016-05-16  1478  		phy_start(netdev->phydev);
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1479  	} else if (priv->use_ncsi) {
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1480  		/* If using NC-SI, set our carrier  
> on and start the stack */
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1481  		netif_carrier_on(netdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1482
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1483  		/* Start the NCSI device */
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1484  		err = ncsi_start_dev(priv->ndev);
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1485  		if (err)
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1486  			goto err_ncsi;
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1487  	}
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1488
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1489  	return 0;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1490
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1491   err_ncsi:
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1492  	napi_disable(&priv->napi);
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1493  	netif_stop_queue(netdev);
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1494   err_alloc:
> da40d9d4b5932d2 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1495  	ftgmac100_free_buffers(priv);
> 60b28a1167749c5 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1496  	free_irq(netdev->irq, netdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1497   err_irq:
> 81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1498  	netif_napi_del(&priv->napi);
> 81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1499   err_hw:
> 81f1eca663c070e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1500  	iowrite32(0, priv->base +  
> FTGMAC100_OFFSET_IER);
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1501  	ftgmac100_free_rings(priv);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1502  	return err;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1503  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1504
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1505  static int ftgmac100_stop(struct  
> net_device *netdev)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1506  {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1507  	struct ftgmac100 *priv =  
> netdev_priv(netdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1508
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1509  	/* Note about the reset task: We  
> are called with the rtnl lock
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1510  	 * held, so we are synchronized  
> against the core of the reset
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1511  	 * task. We must not try to  
> synchronously cancel it otherwise
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1512  	 * we can deadlock. But since it  
> will test for netif_running()
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1513  	 * which has already been cleared  
> by the net core, we don't
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1514  	 * anything special to do.
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1515  	 */
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1516
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1517  	/* disable all interrupts */
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1518  	iowrite32(0, priv->base +  
> FTGMAC100_OFFSET_IER);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1519
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1520  	netif_stop_queue(netdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1521  	napi_disable(&priv->napi);
> b8dbecff9bab825 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1522  	netif_napi_del(&priv->napi);
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1523  	if (netdev->phydev)
> b3c40adcc9891a7 drivers/net/ethernet/faraday/ftgmac100.c Philippe  
> Reynes        2016-05-16  1524  		phy_stop(netdev->phydev);
> 2c15f25b2923435 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-10-04  1525  	else if (priv->use_ncsi)
> 2c15f25b2923435 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-10-04  1526  		ncsi_stop_dev(priv->ndev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1527
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1528  	ftgmac100_stop_hw(priv);
> 60b28a1167749c5 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1529  	free_irq(netdev->irq, netdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1530  	ftgmac100_free_buffers(priv);
> 87d18757ec1677c drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1531  	ftgmac100_free_rings(priv);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1532
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1533  	return 0;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1534  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1535
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1536  /* optional */
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1537  static int  
> ftgmac100_do_ioctl(struct net_device *netdev, struct ifreq *ifr, int  
> cmd)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1538  {
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1539  	if (!netdev->phydev)
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1540  		return -ENXIO;
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1541
> b3c40adcc9891a7 drivers/net/ethernet/faraday/ftgmac100.c Philippe  
> Reynes        2016-05-16  1542  	return  
> phy_mii_ioctl(netdev->phydev, ifr, cmd);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1543  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1544
> d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1545  static void  
> ftgmac100_tx_timeout(struct net_device *netdev)
> d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1546  {
> d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1547  	struct ftgmac100 *priv =  
> netdev_priv(netdev);
> d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1548
> d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1549  	/* Disable all interrupts */
> d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1550  	iowrite32(0, priv->base +  
> FTGMAC100_OFFSET_IER);
> d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1551
> d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1552  	/* Do the reset outside of  
> interrupt context */
> d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1553  	schedule_work(&priv->reset_task);
> d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1554  }
> d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1555
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1556  static int  
> ftgmac100_set_features(struct net_device *netdev,
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1557  				  netdev_features_t features)
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1558  {
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1559  	struct ftgmac100 *priv =  
> netdev_priv(netdev);
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1560  	netdev_features_t changed =  
> netdev->features ^ features;
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1561
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1562  	if (!netif_running(netdev))
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1563  		return 0;
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1564
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1565  	/* Update the vlan filtering bit */
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1566  	if (changed &  
> NETIF_F_HW_VLAN_CTAG_RX) {
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1567  		u32 maccr;
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1568
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1569  		maccr = ioread32(priv->base +  
> FTGMAC100_OFFSET_MACCR);
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1570  		if (priv->netdev->features &  
> NETIF_F_HW_VLAN_CTAG_RX)
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1571  			maccr |= FTGMAC100_MACCR_RM_VLAN;
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1572  		else
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1573  			maccr &= ~FTGMAC100_MACCR_RM_VLAN;
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1574  		iowrite32(maccr, priv->base +  
> FTGMAC100_OFFSET_MACCR);
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1575  	}
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1576
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1577  	return 0;
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1578  }
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1579
> 030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1580  #ifdef CONFIG_NET_POLL_CONTROLLER
> 030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1581  static void  
> ftgmac100_poll_controller(struct net_device *netdev)
> 030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1582  {
> 030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1583  	unsigned long flags;
> 030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1584
> 030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1585  	local_irq_save(flags);
> 030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1586  	ftgmac100_interrupt(netdev->irq,  
> netdev);
> 030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1587  	local_irq_restore(flags);
> 030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1588  }
> 030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1589  #endif
> 030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1590
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1591  static const struct  
> net_device_ops ftgmac100_netdev_ops = {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1592  	.ndo_open		= ftgmac100_open,
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1593  	.ndo_stop		= ftgmac100_stop,
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1594  	.ndo_start_xmit		=  
> ftgmac100_hard_start_xmit,
> 113ce107afe9799 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1595  	.ndo_set_mac_address	=  
> ftgmac100_set_mac_addr,
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1596  	.ndo_validate_addr	=  
> eth_validate_addr,
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1597  	.ndo_do_ioctl		=  
> ftgmac100_do_ioctl,
> d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1598  	.ndo_tx_timeout		=  
> ftgmac100_tx_timeout,
> f48b3c0d5b6ab4d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1599  	.ndo_set_rx_mode	=  
> ftgmac100_set_rx_mode,
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1600  	.ndo_set_features	=  
> ftgmac100_set_features,
> 030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1601  #ifdef CONFIG_NET_POLL_CONTROLLER
> 030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1602  	.ndo_poll_controller	=  
> ftgmac100_poll_controller,
> 030d9828703ec7e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1603  #endif
> 51564585d8c6de2 drivers/net/ethernet/faraday/ftgmac100.c Samuel  
> Mendoza-Jonas   2017-08-28  1604  	.ndo_vlan_rx_add_vid	=  
> ncsi_vlan_rx_add_vid,
> 51564585d8c6de2 drivers/net/ethernet/faraday/ftgmac100.c Samuel  
> Mendoza-Jonas   2017-08-28  1605  	.ndo_vlan_rx_kill_vid	=  
> ncsi_vlan_rx_kill_vid,
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1606  };
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1607
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1608  static int ftgmac100_setup_mdio(struct  
> net_device *netdev)
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1609  {
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1610  	struct ftgmac100 *priv =  
> netdev_priv(netdev);
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1611  	struct platform_device *pdev =  
> to_platform_device(priv->dev);
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1612  	int phy_intf =  
> PHY_INTERFACE_MODE_RGMII;
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1613  	struct device_node *np =  
> pdev->dev.of_node;
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1614  	int i, err = 0;
> e07dc63ba22df2d drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2016-09-22  1615  	u32 reg;
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1616
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1617  	/* initialize mdio bus */
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1618  	priv->mii_bus = mdiobus_alloc();
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1619  	if (!priv->mii_bus)
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1620  		return -EIO;
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1621
> 78d28543a6093fa drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1622  	if (priv->is_aspeed) {
> e07dc63ba22df2d drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2016-09-22  1623  		/* This driver supports the  
> old MDIO interface */
> e07dc63ba22df2d drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2016-09-22  1624  		reg = ioread32(priv->base +  
> FTGMAC100_OFFSET_REVR);
> e07dc63ba22df2d drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2016-09-22  1625  		reg &=  
> ~FTGMAC100_REVR_NEW_MDIO_INTERFACE;
> e07dc63ba22df2d drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2016-09-22  1626  		iowrite32(reg, priv->base +  
> FTGMAC100_OFFSET_REVR);
> f819cd926ca7c91 drivers/net/ethernet/faraday/ftgmac100.c YueHaibing   
>            2019-03-01  1627  	}
> e07dc63ba22df2d drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2016-09-22  1628
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1629  	/* Get PHY mode from device-tree */
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1630  	if (np) {
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1631  		/* Default to RGMII. It's a  
> gigabit part after all */
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1632  		phy_intf = of_get_phy_mode(np);
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1633  		if (phy_intf < 0)
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1634  			phy_intf =  
> PHY_INTERFACE_MODE_RGMII;
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1635
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1636  		/* Aspeed only supports these. I  
> don't know about other IP
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1637  		 * block vendors so I'm going to  
> just let them through for
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1638  		 * now. Note that this is only a  
> warning if for some obscure
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1639  		 * reason the DT really means to  
> lie about it or it's a newer
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1640  		 * part we don't know about.
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1641  		 *
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1642  		 * On the Aspeed SoC there are  
> additionally straps and SCU
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1643  		 * control bits that could tell us  
> what the interface is
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1644  		 * (or allow us to configure it  
> while the IP block is held
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1645  		 * in reset). For now I chose to  
> keep this driver away from
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1646  		 * those SoC specific bits and  
> assume the device-tree is
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1647  		 * right and the SCU has been  
> configured properly by pinmux
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1648  		 * or the firmware.
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1649  		 */
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1650  		if (priv->is_aspeed &&
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1651  		    phy_intf !=  
> PHY_INTERFACE_MODE_RMII &&
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1652  		    phy_intf !=  
> PHY_INTERFACE_MODE_RGMII &&
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1653  		    phy_intf !=  
> PHY_INTERFACE_MODE_RGMII_ID &&
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1654  		    phy_intf !=  
> PHY_INTERFACE_MODE_RGMII_RXID &&
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1655  		    phy_intf !=  
> PHY_INTERFACE_MODE_RGMII_TXID) {
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1656  			netdev_warn(netdev,
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1657  				   "Unsupported PHY mode %s !\n",
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1658  				   phy_modes(phy_intf));
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1659  		}
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1660  	}
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1661
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1662  	priv->mii_bus->name = "ftgmac100_mdio";
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1663  	snprintf(priv->mii_bus->id,  
> MII_BUS_ID_SIZE, "%s-%d",
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1664  		 pdev->name, pdev->id);
> d57b9db1ae0cde3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-07-24  1665  	priv->mii_bus->parent = priv->dev;
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1666  	priv->mii_bus->priv = priv->netdev;
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1667  	priv->mii_bus->read =  
> ftgmac100_mdiobus_read;
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1668  	priv->mii_bus->write =  
> ftgmac100_mdiobus_write;
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1669
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1670  	for (i = 0; i < PHY_MAX_ADDR; i++)
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1671  		priv->mii_bus->irq[i] = PHY_POLL;
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1672
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1673  	err = mdiobus_register(priv->mii_bus);
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1674  	if (err) {
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1675  		dev_err(priv->dev, "Cannot register  
> MDIO bus!\n");
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1676  		goto err_register_mdiobus;
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1677  	}
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1678
> abcc3eb00e10af3 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1679  	err = ftgmac100_mii_probe(priv,  
> phy_intf);
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1680  	if (err) {
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1681  		dev_err(priv->dev, "MII Probe  
> failed!\n");
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1682  		goto err_mii_probe;
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1683  	}
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1684
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1685  	return 0;
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1686
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1687  err_mii_probe:
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1688  	mdiobus_unregister(priv->mii_bus);
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1689  err_register_mdiobus:
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1690  	mdiobus_free(priv->mii_bus);
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1691  	return err;
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1692  }
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1693
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1694  static void  
> ftgmac100_destroy_mdio(struct net_device *netdev)
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1695  {
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1696  	struct ftgmac100 *priv =  
> netdev_priv(netdev);
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1697
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1698  	if (!netdev->phydev)
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1699  		return;
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1700
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1701  	phy_disconnect(netdev->phydev);
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1702  	mdiobus_unregister(priv->mii_bus);
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1703  	mdiobus_free(priv->mii_bus);
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1704  }
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1705
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1706  static void  
> ftgmac100_ncsi_handler(struct ncsi_dev *nd)
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1707  {
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1708  	if (unlikely(nd->state !=  
> ncsi_dev_state_functional))
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1709  		return;
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1710
> 87975a0117815b9 drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2018-06-19  1711  	netdev_dbg(nd->dev, "NCSI  
> interface %s\n",
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1712  		   nd->link_up ? "up" : "down");
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1713  }
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1714
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1715  static void  
> ftgmac100_setup_clk(struct ftgmac100 *priv)
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1716  {
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1717  	priv->clk =  
> devm_clk_get(priv->dev, NULL);
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1718  	if (IS_ERR(priv->clk))
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1719  		return;
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1720
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1721  	clk_prepare_enable(priv->clk);
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1722
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1723  	/* Aspeed specifies a 100MHz  
> clock is required for up to
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1724  	 * 1000Mbit link speeds. As  
> NCSI is limited to 100Mbit, 25MHz
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1725  	 * is sufficient
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1726  	 */
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1727  	clk_set_rate(priv->clk,  
> priv->use_ncsi ? FTGMAC_25MHZ :
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1728  			FTGMAC_100MHZ);
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1729  }
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1730
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1731  static int ftgmac100_probe(struct  
> platform_device *pdev)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1732  {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1733  	struct resource *res;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1734  	int irq;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1735  	struct net_device *netdev;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1736  	struct ftgmac100 *priv;
> 78d28543a6093fa drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1737  	struct device_node *np;
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1738  	int err = 0;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1739
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1740  	if (!pdev)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1741  		return -ENODEV;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1742
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1743  	res =  
> platform_get_resource(pdev, IORESOURCE_MEM, 0);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1744  	if (!res)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1745  		return -ENXIO;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1746
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1747  	irq = platform_get_irq(pdev, 0);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1748  	if (irq < 0)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1749  		return irq;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1750
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1751  	/* setup net_device */
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1752  	netdev =  
> alloc_etherdev(sizeof(*priv));
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1753  	if (!netdev) {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1754  		err = -ENOMEM;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1755  		goto err_alloc_etherdev;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1756  	}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1757
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1758  	SET_NETDEV_DEV(netdev,  
> &pdev->dev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1759
> 7ad24ea4bf620a3 drivers/net/ethernet/faraday/ftgmac100.c Wilfried  
> Klaebe        2014-05-11  1760  	netdev->ethtool_ops =  
> &ftgmac100_ethtool_ops;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1761  	netdev->netdev_ops =  
> &ftgmac100_netdev_ops;
> d3ca8fb180dbec8 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-10  1762  	netdev->watchdog_timeo = 5 * HZ;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1763
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1764  	platform_set_drvdata(pdev,  
> netdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1765
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1766  	/* setup private data */
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1767  	priv = netdev_priv(netdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1768  	priv->netdev = netdev;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1769  	priv->dev = &pdev->dev;
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1770  	INIT_WORK(&priv->reset_task,  
> ftgmac100_reset_task);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1771
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1772  	/* map io memory */
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1773  	priv->res =  
> request_mem_region(res->start, resource_size(res),
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1774  				       dev_name(&pdev->dev));
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1775  	if (!priv->res) {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1776  		dev_err(&pdev->dev, "Could not  
> reserve memory region\n");
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1777  		err = -ENOMEM;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1778  		goto err_req_mem;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1779  	}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1780
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1781  	priv->base = ioremap(res->start,  
> resource_size(res));
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1782  	if (!priv->base) {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1783  		dev_err(&pdev->dev, "Failed to  
> ioremap ethernet registers\n");
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1784  		err = -EIO;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1785  		goto err_ioremap;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1786  	}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1787
> 60b28a1167749c5 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1788  	netdev->irq = irq;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1789
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1790  	/* Enable pause */
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1791  	priv->tx_pause = true;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1792  	priv->rx_pause = true;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1793  	priv->aneg_pause = true;
> 7c8e5141ca633ae drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1794
> 113ce107afe9799 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1795  	/* MAC address from chip or random one  
> */
> ba1b1234d6a3ecb drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1796  	ftgmac100_initial_mac(priv);
> 113ce107afe9799 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1797
> 78d28543a6093fa drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1798  	np = pdev->dev.of_node;
> 78d28543a6093fa drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1799  	if (np &&  
> (of_device_is_compatible(np, "aspeed,ast2400-mac") ||
> 78d28543a6093fa drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1800  		   of_device_is_compatible(np,  
> "aspeed,ast2500-mac"))) {
> 2a0ab8ebbec6341 drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2016-09-22  1801  		priv->rxdes0_edorr_mask =  
> BIT(30);
> 2a0ab8ebbec6341 drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2016-09-22  1802  		priv->txdes0_edotr_mask =  
> BIT(30);
> 78d28543a6093fa drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1803  		priv->is_aspeed = true;
> 2a0ab8ebbec6341 drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2016-09-22  1804  	} else {
> 2a0ab8ebbec6341 drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2016-09-22  1805  		priv->rxdes0_edorr_mask =  
> BIT(15);
> 2a0ab8ebbec6341 drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2016-09-22  1806  		priv->txdes0_edotr_mask =  
> BIT(15);
> 2a0ab8ebbec6341 drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2016-09-22  1807  	}
> 2a0ab8ebbec6341 drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2016-09-22  1808
> 78d28543a6093fa drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1809  	if (np && of_get_property(np,  
> "use-ncsi", NULL)) {
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1810  		if (!IS_ENABLED(CONFIG_NET_NCSI)) {
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1811  			dev_err(&pdev->dev, "NCSI stack not  
> enabled\n");
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1812  			goto err_ncsi_dev;
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1813  		}
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1814
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1815  		dev_info(&pdev->dev, "Using NCSI  
> interface\n");
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1816  		priv->use_ncsi = true;
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1817  		priv->ndev =  
> ncsi_register_dev(netdev, ftgmac100_ncsi_handler);
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1818  		if (!priv->ndev)
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1819  			goto err_ncsi_dev;
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1820  	} else {
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1821  		priv->use_ncsi = false;
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1822  		err = ftgmac100_setup_mdio(netdev);
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1823  		if (err)
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1824  			goto err_setup_mdio;
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1825  	}
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1826
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1827  	if (priv->is_aspeed)
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1828  		ftgmac100_setup_clk(priv);
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1829
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1830  	/* Default ring sizes */
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1831  	priv->rx_q_entries =  
> priv->new_rx_q_entries = DEF_RX_QUEUE_ENTRIES;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1832  	priv->tx_q_entries =  
> priv->new_tx_q_entries = DEF_TX_QUEUE_ENTRIES;
> 52d9138fb31ac2d drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1833
> 6aff0bf641cf69e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1834  	/* Base feature set */
> 8c3ed1315e129e9 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1835  	netdev->hw_features =  
> NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1836  		NETIF_F_GRO | NETIF_F_SG |  
> NETIF_F_HW_VLAN_CTAG_RX |
> 0fb9968876c3866 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-18  1837  		NETIF_F_HW_VLAN_CTAG_TX;
> 6aff0bf641cf69e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1838
> 51564585d8c6de2 drivers/net/ethernet/faraday/ftgmac100.c Samuel  
> Mendoza-Jonas   2017-08-28  1839  	if (priv->use_ncsi)
> 51564585d8c6de2 drivers/net/ethernet/faraday/ftgmac100.c Samuel  
> Mendoza-Jonas   2017-08-28  1840  		netdev->hw_features |=  
> NETIF_F_HW_VLAN_CTAG_FILTER;
> 51564585d8c6de2 drivers/net/ethernet/faraday/ftgmac100.c Samuel  
> Mendoza-Jonas   2017-08-28  1841
> 6aff0bf641cf69e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1842  	/* AST2400  doesn't have working HW  
> checksum generation */
> 6aff0bf641cf69e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1843  	if (np &&  
> (of_device_is_compatible(np, "aspeed,ast2400-mac")))
> 8c3ed1315e129e9 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1844  		netdev->hw_features &=  
> ~NETIF_F_HW_CSUM;
> 6aff0bf641cf69e drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1845  	if (np && of_get_property(np,  
> "no-hw-checksum", NULL))
> 8c3ed1315e129e9 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1846  		netdev->hw_features &=  
> ~(NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
> 8c3ed1315e129e9 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-12  1847  	netdev->features |=  
> netdev->hw_features;
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1848
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1849  	/* register network device */
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1850  	err = register_netdev(netdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1851  	if (err) {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1852  		dev_err(&pdev->dev, "Failed to  
> register netdev\n");
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1853  		goto err_register_netdev;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1854  	}
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1855
> 60b28a1167749c5 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1856  	netdev_info(netdev, "irq %d, mapped  
> at %p\n", netdev->irq, priv->base);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1857
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1858  	return 0;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1859
> bd466c3fb5a4ff8 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1860  err_ncsi_dev:
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1861  err_register_netdev:
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1862  	ftgmac100_destroy_mdio(netdev);
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1863  err_setup_mdio:
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1864  	iounmap(priv->base);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1865  err_ioremap:
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1866  	release_resource(priv->res);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1867  err_req_mem:
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1868  	free_netdev(netdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1869  err_alloc_etherdev:
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1870  	return err;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1871  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1872
> be12502e2e64854 drivers/net/ethernet/faraday/ftgmac100.c Dmitry  
> Torokhov        2017-03-01  1873  static int ftgmac100_remove(struct  
> platform_device *pdev)
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1874  {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1875  	struct net_device *netdev;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1876  	struct ftgmac100 *priv;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1877
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1878  	netdev =  
> platform_get_drvdata(pdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1879  	priv = netdev_priv(netdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1880
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1881  	unregister_netdev(netdev);
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1882
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1883  	clk_disable_unprepare(priv->clk);
> 4b70c62b9eafcee drivers/net/ethernet/faraday/ftgmac100.c Joel  
> Stanley           2017-10-13  1884
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1885  	/* There's a small chance the reset  
> task will have been re-queued,
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1886  	 * during stop, make sure it's gone  
> before we free the structure.
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1887  	 */
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1888  	cancel_work_sync(&priv->reset_task);
> 855944ce1cc4037 drivers/net/ethernet/faraday/ftgmac100.c Benjamin  
> Herrenschmidt 2017-04-05  1889
> eb4181849f58f31 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1890  	ftgmac100_destroy_mdio(netdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1891
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1892  	iounmap(priv->base);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1893  	release_resource(priv->res);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1894
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1895  	netif_napi_del(&priv->napi);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1896  	free_netdev(netdev);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1897  	return 0;
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1898  }
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1899
> bb168e2e9e512e6 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1900  static const struct of_device_id  
> ftgmac100_of_match[] = {
> bb168e2e9e512e6 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1901  	{ .compatible = "faraday,ftgmac100" },
> bb168e2e9e512e6 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1902  	{ }
> bb168e2e9e512e6 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1903  };
> bb168e2e9e512e6 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1904  MODULE_DEVICE_TABLE(of,  
> ftgmac100_of_match);
> bb168e2e9e512e6 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1905
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1906  static struct platform_driver  
> ftgmac100_driver = {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1907  	.probe	= ftgmac100_probe,
> be12502e2e64854 drivers/net/ethernet/faraday/ftgmac100.c Dmitry  
> Torokhov        2017-03-01  1908  	.remove	= ftgmac100_remove,
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1909  	.driver	= {
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1910  		.name		= DRV_NAME,
> bb168e2e9e512e6 drivers/net/ethernet/faraday/ftgmac100.c Gavin Shan   
>            2016-07-19  1911  		.of_match_table	= ftgmac100_of_match,
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1912  	},
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1913  };
> 14f645d0deb4d18 drivers/net/ethernet/faraday/ftgmac100.c Sachin  
> Kamat           2013-03-18  1914   
> module_platform_driver(ftgmac100_driver);
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1915
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1916  MODULE_AUTHOR("Po-Yu Chuang  
> <ratbert@faraday-tech.com>");
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1917  MODULE_DESCRIPTION("FTGMAC100  
> driver");
> 69785b79ca9b1ac drivers/net/ftgmac100.c                  Po-Yu  
> Chuang           2011-06-08  1918  MODULE_LICENSE("GPL");
>
> :::::: The code at line 777 was first introduced by commit
> :::::: 6db7470445f0757d2e8f23f57d86611338717ebe ftgmac100: Add  
> support for fragmented tx
>
> :::::: TO: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> :::::: CC: David S. Miller <davem@davemloft.net>
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation



