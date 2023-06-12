Return-Path: <netdev+bounces-10088-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F5F372C1F4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:01:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C23591C20A86
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:01:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F79113AEA;
	Mon, 12 Jun 2023 11:01:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F928134D0
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 11:01:35 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F3D5B91;
	Mon, 12 Jun 2023 04:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JWHXuE2v7XY71npjrwZZ/s4PnkNNKrmbBcmZ9MpyCUc=; b=Ugsm2iCmu+49vpJCbDSH3eFR13
	6GUog7n5Q6IAxQfzp8M/UAga2BmCcqh27JOLQzrONBZ9wNcYa2+ODc2MF7T9kxESzQcffbbQd/Hja
	ZOBkl0A4e+2WFfiYdYoYVQ4IsY+pxM0NSWi9PhzktV+RXaBXAvUoLFLpHXVkRs07m3yT2EI3I5xnR
	Qe4KUX2ichqIgYbr0jiA5Td5enXcsHrpZ0k2HaYcPl6iBuOSCpf25QBRv/dOsWg0ZEy6DtFLKg/M9
	RkfGiMO9+TJevYVckk/IISndMQgnVxN9LQwXQ1HphBawU90o2zSy77M1xUswzxeoBd15HMR7TXD+R
	e7XyVXzg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50682)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q8fIE-0005aq-HQ; Mon, 12 Jun 2023 12:01:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q8fIB-0004u0-G6; Mon, 12 Jun 2023 12:00:59 +0100
Date: Mon, 12 Jun 2023 12:00:59 +0100
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
Subject: Re: [PATCH net-next 3/8] net: ethernet: mtk_eth_soc: move MAX_DEVS
 in mtk_soc_data
Message-ID: <ZIb6604WRJsevaWN@shell.armlinux.org.uk>
References: <ZIUWxQ9H7hNSd6rJ@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIUWxQ9H7hNSd6rJ@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 11, 2023 at 01:35:17AM +0100, Daniel Golle wrote:
> @@ -1106,14 +1105,14 @@ struct mtk_eth {
>  	spinlock_t			tx_irq_lock;
>  	spinlock_t			rx_irq_lock;
>  	struct net_device		dummy_dev;
> -	struct net_device		*netdev[MTK_MAX_DEVS];
> -	struct mtk_mac			*mac[MTK_MAX_DEVS];
> +	struct net_device		**netdev;
> +	struct mtk_mac			**mac;
>  	int				irq[3];
>  	u32				msg_enable;
>  	unsigned long			sysclk;
>  	struct regmap			*ethsys;
>  	struct regmap			*infra;
> -	struct phylink_pcs		*sgmii_pcs[MTK_MAX_DEVS];
> +	struct phylink_pcs		**sgmii_pcs;
>  	struct regmap			*pctl;
>  	bool				hwlro;
>  	refcount_t			dma_refcnt;

Is it really worth the extra allocations?

There's three pointers here per device. Let's talk about modern systems,
so that's 8 bytes each, and if MTK_MAX_DEVS was two, that's 48 bytes in
all. If we expanded the array to allow three, that would be 72 bytes.

If we allocate separately, then we're allocating 16 or 24 bytes three
times depending on whether we want two or three of them.

On arm64, I'm seeing the minimum slab size as 128 bytes, which means
that's the minimum memory allocation. So, allocating three arrays will
be 384 bytes in all, irrespective of whether we want two or three
entries.

That's a waste of about 5x the memory over just expanding the arrays!

If you want to go down the route of dynamically allocating these, it
would make better sense to combine them into a single structure that
itself is an array, and thus requiring only one allocation. That
reduces the wastage to about 56 bytes for three ports or 80 bytes
for two.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

