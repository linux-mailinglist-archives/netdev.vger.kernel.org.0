Return-Path: <netdev+bounces-10089-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AD4A72C2B8
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:20:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B41CC1C20AEE
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4700156EC;
	Mon, 12 Jun 2023 11:20:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98BFAD3C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 11:20:07 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063F77D94;
	Mon, 12 Jun 2023 04:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=TV21Jmzs5HQxIuTayrf/mU1uRUNmyAiPllP7jU37Xqc=; b=ymw/V7OeZAEdwfvrsdF0h7hem3
	P2MsH19HdcpAUn5jgAqvtrHcr1v+prQ6HGwnZwNY5HGIVTVMqR8bJpG8QL+R6BsExpfurAJoFyzgO
	mTOQryoWtvarDKOfsLxbMNlY4uYZLfspASeOE9nXQEDK8Dfo1lMqnEB3HZL8Sowmp65K7AVBv/EzY
	aasIUJmN6gAT0nfrFXjq4ZYcQTn5A69DWGB9x9Ukm4IF6hFiazutEUzl5rSluwnVo1UP1EfNzIIz1
	ibt+BUxG04j1w8PNhucatldK7t5a+HV4nsd0n4ZVyMTW2R7omrRh8b3EhZFgs+t11VfcRezgoQ0R8
	4NRkg+oA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36050)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q8faY-0005e2-JP; Mon, 12 Jun 2023 12:19:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q8faS-0004v7-27; Mon, 12 Jun 2023 12:19:52 +0100
Date: Mon, 12 Jun 2023 12:19:52 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, John Crispin <john@phrozen.org>,
	Felix Fietkau <nbd@nbd.name>, Conor Dooley <conor+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Rob Herring <robh+dt@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sam Shih <Sam.Shih@mediatek.com>
Subject: Re: [PATCH net-next 5/8] net: ethernet: mtk_eth_soc: add
 MTK_NETSYS_V3 capability bit
Message-ID: <ZIb/WKKNlzjTIu2h@shell.armlinux.org.uk>
References: <ZIUXf9APDFCNaUG1@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIUXf9APDFCNaUG1@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 11, 2023 at 01:38:23AM +0100, Daniel Golle wrote:
> @@ -1333,8 +1354,13 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
>  	mtk_tx_set_dma_desc(dev, itxd, &txd_info);
>  
>  	itx_buf->flags |= MTK_TX_FLAGS_SINGLE0;
> -	itx_buf->flags |= (!mac->id) ? MTK_TX_FLAGS_FPORT0 :
> -			  MTK_TX_FLAGS_FPORT1;
> +	if (mac->id == MTK_GMAC1_ID)
> +		itx_buf->flags |= MTK_TX_FLAGS_FPORT0;
> +	else if (mac->id == MTK_GMAC2_ID)
> +		itx_buf->flags |= MTK_TX_FLAGS_FPORT1;
> +	else
> +		itx_buf->flags |= MTK_TX_FLAGS_FPORT2;

There appears to be two places that this code structure appears, and
this is in the path for packet transmission. I wonder if it would be
more efficient to instead do:

	itx_buf->flags |= MTK_TX_FLAGS_SINGLE0 | mac->tx_flags;

with mac->tx_flags appropriately initialised?

> @@ -2170,7 +2214,9 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
>  		tx_buf = mtk_desc_to_tx_buf(ring, desc,
>  					    eth->soc->txrx.txd_size);
>  		if (tx_buf->flags & MTK_TX_FLAGS_FPORT1)
> -			mac = 1;
> +			mac = MTK_GMAC2_ID;
> +		else if (tx_buf->flags & MTK_TX_FLAGS_FPORT2)
> +			mac = MTK_GMAC3_ID;

This has me wondering whether the flags are used for hardware or just
for the driver's purposes. If it's the latter, can we instead store the
MAC index in tx_buf, rather than having to decode a bitfield?

I suspect these are just for the driver given that the addition of
MTK_TX_FLAGS_FPORT2 changes all subsequent bit numbers in this struct
member.

>  
>  		if (!tx_buf->data)
>  			break;
> @@ -3783,7 +3829,26 @@ static int mtk_hw_init(struct mtk_eth *eth, bool reset)
>  	mtk_w32(eth, eth->soc->txrx.rx_irq_done_mask, reg_map->qdma.int_grp + 4);
>  	mtk_w32(eth, 0x21021000, MTK_FE_INT_GRP);
>  
> -	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
> +	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V3)) {
> +		/* PSE should not drop port1, port8 and port9 packets */
> +		mtk_w32(eth, 0x00000302, PSE_DROP_CFG);
> +
> +		/* GDM and CDM Threshold */
> +		mtk_w32(eth, 0x00000707, MTK_CDMW0_THRES);
> +		mtk_w32(eth, 0x00000077, MTK_CDMW1_THRES);
> +
> +		/* Disable GDM1 RX CRC stripping */
> +		val = mtk_r32(eth, MTK_GDMA_FWD_CFG(0));
> +		val &= ~MTK_GDMA_STRP_CRC;
> +		mtk_w32(eth, val, MTK_GDMA_FWD_CFG(0));

mtk_m32() ?

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

