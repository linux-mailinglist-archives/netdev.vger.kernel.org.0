Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9DFDC366C
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 15:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388831AbfJAN4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 09:56:11 -0400
Received: from mx.0dd.nl ([5.2.79.48]:60708 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbfJAN4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 09:56:10 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 12E3B5FBC5;
        Tue,  1 Oct 2019 15:56:09 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="MiBJ1OfY";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id C2B87358FB;
        Tue,  1 Oct 2019 15:56:08 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com C2B87358FB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1569938168;
        bh=VuIg/nbWnzaooWQXgf0jLELVIM9W+Vd2ZvGPUadAMPM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MiBJ1OfYk48VHA6HrblhjA6Hb3aditWR5YfLHeFqJ81AE7DkXN8+UQKKcKcjYHAnm
         zigKND8kk+B83zm98YLtU5LWqT4toLQK/YrVYyM7o68njxwvBb46NbJMYFOIqHq2+a
         Id6P3ktrp23DiZwgLPnly/D/Y9Pq3lkXKmZ0Kjt2ayaTiMeFG6Epdi+WPri9j+DM6l
         cqyuF8nMF2is2g6LcHid4qI6I2nO4LCM90z5YpJKeMVOYsT7dQ/kinbeRU913TllAE
         TLo82X/M/GHIiwM5mkxMGqC2Aa8nsH0+7scM3UL2CwVYi8VU/O1IzdFqkUia3Oiel0
         +fn3sWWHhQbUA==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Tue, 01 Oct 2019 13:56:08 +0000
Date:   Tue, 01 Oct 2019 13:56:08 +0000
Message-ID: <20191001135608.Horde.OSYef8s44rR0XHw22Bf55r8@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     MarkLee <Mark-MC.Lee@mediatek.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@openwrt.org>,
        Nelson Chang <nelson.chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] arm: dts: mediatek: Fix mt7629 dts to reflect
 the latest dt-binding
References: <20191001123150.23135-1-Mark-MC.Lee@mediatek.com>
 <20191001123150.23135-3-Mark-MC.Lee@mediatek.com>
In-Reply-To: <20191001123150.23135-3-Mark-MC.Lee@mediatek.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi MarkLee,

Quoting MarkLee <Mark-MC.Lee@mediatek.com>:

> * Removes mediatek,physpeed property from dtsi that is useless in PHYLINK
> * Set gmac0 to fixed-link sgmii 2.5Gbit mode
> * Set gmac1 to gmii mode that connect to a internal gphy
>
> Signed-off-by: MarkLee <Mark-MC.Lee@mediatek.com>
> ---
>  arch/arm/boot/dts/mt7629-rfb.dts | 13 ++++++++++++-
>  arch/arm/boot/dts/mt7629.dtsi    |  2 --
>  2 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/boot/dts/mt7629-rfb.dts  
> b/arch/arm/boot/dts/mt7629-rfb.dts
> index 3621b7d2b22a..6bf1f7d8ddb5 100644
> --- a/arch/arm/boot/dts/mt7629-rfb.dts
> +++ b/arch/arm/boot/dts/mt7629-rfb.dts
> @@ -66,9 +66,21 @@
>  	pinctrl-1 = <&ephy_leds_pins>;
>  	status = "okay";
>
> +	gmac0: mac@0 {
> +		compatible = "mediatek,eth-mac";
> +		reg = <0>;
> +		phy-mode = "sgmii";
> +		fixed-link {
> +			speed = <2500>;
> +			full-duplex;
> +			pause;
> +		};
> +	};
> +
>  	gmac1: mac@1 {
>  		compatible = "mediatek,eth-mac";
>  		reg = <1>;
> +		phy-mode = "gmii";
>  		phy-handle = <&phy0>;
>  	};
>
> @@ -78,7 +90,6 @@
>
>  		phy0: ethernet-phy@0 {
>  			reg = <0>;
> -			phy-mode = "gmii";
>  		};
>  	};
>  };
> diff --git a/arch/arm/boot/dts/mt7629.dtsi b/arch/arm/boot/dts/mt7629.dtsi
> index 9608bc2ccb3f..867b88103b9d 100644
> --- a/arch/arm/boot/dts/mt7629.dtsi
> +++ b/arch/arm/boot/dts/mt7629.dtsi
> @@ -468,14 +468,12 @@
>  			compatible = "mediatek,mt7629-sgmiisys", "syscon";
>  			reg = <0x1b128000 0x3000>;
>  			#clock-cells = <1>;
> -			mediatek,physpeed = "2500";
>  		};
>
>  		sgmiisys1: syscon@1b130000 {
>  			compatible = "mediatek,mt7629-sgmiisys", "syscon";
>  			reg = <0x1b130000 0x3000>;
>  			#clock-cells = <1>;
> -			mediatek,physpeed = "2500";
>  		};
>  	};
>  };
> --
> 2.17.1

Does MT7629 soc has the same SGMII IP block as on the MT7622?
If that is the case then phy-mode should set to "2500base-x".
See discussion about the MT7622 [1] and dts of  
mt7622-bananapi-bpi-r64.dts[2][3]

Note the code only set the phy in overclock mode if phymode =  
2500base-x and the
link is a fixed-link, see [4].
Alsp the current code doesn't support sgmii so well. Sgmii at 2.5Gbit is not
supported at all.

Greats,

René

[1]:  
https://lore.kernel.org/netdev/20190822144433.GT13294@shell.armlinux.org.uk/
[2]:  
https://lore.kernel.org/netdev/20190825174341.20750-4-opensource@vdorst.com/
[3]:  
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/tree/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts#n122
[4]:  
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/tree/drivers/net/ethernet/mediatek/mtk_sgmii.c#n72





