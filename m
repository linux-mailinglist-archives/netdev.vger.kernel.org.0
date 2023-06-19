Return-Path: <netdev+bounces-11953-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE1FF735686
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:14:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E07F01C2037F
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96A310954;
	Mon, 19 Jun 2023 12:14:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB402D2F8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 12:14:13 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E28311D;
	Mon, 19 Jun 2023 05:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=X0lF8mpxVq8SIEVdDQfQrhh7ZGGEb6dVodZVNneyxYg=; b=SgHlF8JedUliDOUZYGdTn2HLj6
	8ohHxknL4GjCIvQVfM70i48PYc/vjNJXjOra4PLbuI1LwXjRCPKYhnSyMywPqgC+dDBiAMNbpPjwR
	LGNR7Z2a3ytdOdRsr7tEYaCOT3iQpbeDQro33xG/YGh4XN1+WjbEPa8GeywTo1O+gE9qvsAOydrKW
	nr2kwTZv0Myrs28dIPEfC8sT+hcgpRLtT+TYfkrhg0HsU5aPqoerAo3nzRIeXO2TVl/xyMO5gLTvW
	ZS+kest96UdGU9s7OTZx2RcH5k7aR6NxVQdKxXYtPX4BNrUn4Vz0s2g27DYe0/vXimRlBL5EGm8TO
	aUcZZ50w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56184)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1qBDlj-0008HR-4l; Mon, 19 Jun 2023 13:14:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1qBDli-0005dC-6F; Mon, 19 Jun 2023 13:14:02 +0100
Date: Mon, 19 Jun 2023 13:14:02 +0100
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
Subject: Re: [PATCH net v6 5/6] net: dsa: introduce
 preferred_default_local_cpu_port and use on MT7530
Message-ID: <ZJBGij0SUZr644w5@shell.armlinux.org.uk>
References: <20230617062649.28444-1-arinc.unal@arinc9.com>
 <20230617062649.28444-6-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230617062649.28444-6-arinc.unal@arinc9.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 17, 2023 at 09:26:48AM +0300, arinc9.unal@gmail.com wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> 
> Since the introduction of the OF bindings, DSA has always had a policy that
> in case multiple CPU ports are present in the device tree, the numerically
> smallest one is always chosen.
> 
> The MT7530 switch family, except the switch on the MT7988 SoC, has 2 CPU
> ports, 5 and 6, where port 6 is preferable on the MT7531BE switch because
> it has higher bandwidth.
> 
> The MT7530 driver developers had 3 options:
> - to modify DSA when the MT7531 switch support was introduced, such as to
>   prefer the better port
> - to declare both CPU ports in device trees as CPU ports, and live with the
>   sub-optimal performance resulting from not preferring the better port
> - to declare just port 6 in the device tree as a CPU port
> 
> Of course they chose the path of least resistance (3rd option), kicking the
> can down the road. The hardware description in the device tree is supposed
> to be stable - developers are not supposed to adopt the strategy of
> piecemeal hardware description, where the device tree is updated in
> lockstep with the features that the kernel currently supports.
> 
> Now, as a result of the fact that they did that, any attempts to modify the
> device tree and describe both CPU ports as CPU ports would make DSA change
> its default selection from port 6 to 5, effectively resulting in a
> performance degradation visible to users with the MT7531BE switch as can be
> seen below.
> 
> Without preferring port 6:
> 
> [ ID][Role] Interval           Transfer     Bitrate         Retr
> [  5][TX-C]   0.00-20.00  sec   374 MBytes   157 Mbits/sec  734    sender
> [  5][TX-C]   0.00-20.00  sec   373 MBytes   156 Mbits/sec    receiver
> [  7][RX-C]   0.00-20.00  sec  1.81 GBytes   778 Mbits/sec    0    sender
> [  7][RX-C]   0.00-20.00  sec  1.81 GBytes   777 Mbits/sec    receiver
> 
> With preferring port 6:
> 
> [ ID][Role] Interval           Transfer     Bitrate         Retr
> [  5][TX-C]   0.00-20.00  sec  1.99 GBytes   856 Mbits/sec  273    sender
> [  5][TX-C]   0.00-20.00  sec  1.99 GBytes   855 Mbits/sec    receiver
> [  7][RX-C]   0.00-20.00  sec  1.72 GBytes   737 Mbits/sec   15    sender
> [  7][RX-C]   0.00-20.00  sec  1.71 GBytes   736 Mbits/sec    receiver
> 
> Using one port for WAN and the other ports for LAN is a very popular use
> case which is what this test emulates.
> 
> As such, this change proposes that we retroactively modify stable kernels
> (which don't support the modification of the CPU port assignments, so as to
> let user space fix the problem and restore the throughput) to keep the
> mt7530 driver preferring port 6 even with device trees where the hardware
> is more fully described.
> 
> Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

