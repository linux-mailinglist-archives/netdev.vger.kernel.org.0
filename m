Return-Path: <netdev+bounces-11376-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D003732D14
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:09:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DC5B1C20B5A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 753BC18B10;
	Fri, 16 Jun 2023 10:07:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6806079D3
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:07:54 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D92835A3;
	Fri, 16 Jun 2023 03:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=CN5z6yqj1tqEFliZI81j5Oh/vP4LbpjN18lNA0r+5gc=; b=xF0qVwuWG/LttaBQxfRVx6ay+y
	Bb+oeoLhhqgGdYrBQyPSWcSA/ED7hOWalkmJ4HZQCbTXITHUQFVd6+UptZ8bdZiJgoR5xMki/rUIn
	4sBE/25wVZeBeFo9bTVxDA999+qjVteJwn0GpwfSk+KeFdFu7vpXoRGXDoemnhwHPghTpIXnFfkCc
	NYSTtMp9hPRMJ/d+rgSM0Z0oHSqvw4fnom+lgT5e4FUUUZij8yyKpETBY25BiZIJAqx4HjJwitIUo
	LV0sWfs6za3PR7q06xGXhYH3FQzED2kQIPM1iIt96KChtAGPsS36e71hFctU6kiDoS+vq+y6Gp0YA
	djCdVTXQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35780)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qA6Mf-0004k6-Ed; Fri, 16 Jun 2023 11:07:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qA6MW-0002PI-V2; Fri, 16 Jun 2023 11:07:25 +0100
Date: Fri, 16 Jun 2023 11:07:24 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: arinc9.unal@gmail.com
Cc: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v5 1/6] net: dsa: mt7530: set all CPU ports in
 MT7531_CPU_PMAP
Message-ID: <ZIw0XDhHIjbMvgC9@shell.armlinux.org.uk>
References: <20230616025327.12652-1-arinc.unal@arinc9.com>
 <20230616025327.12652-2-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230616025327.12652-2-arinc.unal@arinc9.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 05:53:22AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> MT7531_CPU_PMAP represents the destination port mask for trapped-to-CPU
> frames (further restricted by PCR_MATRIX).
> 
> Currently the driver sets the first CPU port as the single port in this bit
> mask, which works fine regardless of whether the device tree defines port
> 5, 6 or 5+6 as CPU ports. This is because the logic coincides with DSA's
> logic of picking the first CPU port as the CPU port that all user ports are
> affine to, by default.
> 
> An upcoming change would like to influence DSA's selection of the default
> CPU port to no longer be the first one, and in that case, this logic needs
> adaptation.
> 
> Since there is no observed leakage or duplication of frames if all CPU
> ports are defined in this bit mask, simply include them all.

Nice and clear commit message, thanks.

> +	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
> +	 * the MT7988 SoC. Trapped frames will be trapped to the CPU port that
> +	 * is affine to the inbound user port.

As a general rule, English doesn't like repetition in sentences, which
means that having "trapped" twice (or more times) makes the sentence
awkward.

"Trapped frames will be forwarded to the CPU port that is affine to the
inbound user port."

reads much better.

Apart from that...

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

