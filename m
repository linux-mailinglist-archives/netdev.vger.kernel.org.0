Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C27CEBEA
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 20:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbfJGSaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 14:30:30 -0400
Received: from mx.0dd.nl ([5.2.79.48]:58346 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729433AbfJGSaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 14:30:30 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 9DE365FBBE;
        Mon,  7 Oct 2019 20:30:28 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="mm8Yuqtx";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 6BE083BE06;
        Mon,  7 Oct 2019 20:30:28 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 6BE083BE06
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1570473028;
        bh=oeUXtc8+vJUoOsszOZiNMTAuDgvF7gVaUUppHe+ivDs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mm8YuqtxOrunMTWQvqae1DMbOjOq5dOxsJMqYnJJKWaI5MWLaBA9W95gRc+IzvxAB
         VPV0/5ViKt+5mrvD/UmWsWZRXWG02J1D/1T8YrUl2pjpH8G07AMOkaYEKrk63/hnKn
         kG69zGZnI79LTFLHhWOT07W+eBytmiWFvPcCa+8WYf7/KCrYlvLvSkPKxvZNP4C5nq
         6vsPF++aHxIk888XzyvcVXFVKNJfe7XfarD+0WG8SC9SoA4tc0ZouCV8XAHhsFJajG
         AQR4d4AievSJPr03oIQHeajuYJMG1b+vuVXjAdeHWWnRH69aVDQmeYueLGZglbL9RG
         kDwRLx6+4SdLQ==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Mon, 07 Oct 2019 18:30:28 +0000
Date:   Mon, 07 Oct 2019 18:30:28 +0000
Message-ID: <20191007183028.Horde.dCYJA3Xp9mBh_Bs9Ixa7Sh0@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     MarkLee <Mark-MC.Lee@mediatek.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Nelson Chang <nelson.chang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net,v2 2/2] arm: dts: mediatek: Fix mt7629 dts to
 reflect the latest dt-binding
References: <20191007070844.14212-1-Mark-MC.Lee@mediatek.com>
 <20191007070844.14212-3-Mark-MC.Lee@mediatek.com>
In-Reply-To: <20191007070844.14212-3-Mark-MC.Lee@mediatek.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting MarkLee <Mark-MC.Lee@mediatek.com>:

> * Removes mediatek,physpeed property from dtsi that is useless in PHYLINK
> * Use the fixed-link property speed = <2500> to set the phy in 2.5Gbit.
> * Set gmac1 to gmii mode that connect to a internal gphy
>
> Signed-off-by: MarkLee <Mark-MC.Lee@mediatek.com>
> --
> v1->v2:
> * SGMII port only support BASE-X at 2.5Gbit.
> ---
>  arch/arm/boot/dts/mt7629-rfb.dts | 13 ++++++++++++-
>  arch/arm/boot/dts/mt7629.dtsi    |  2 --
>  2 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/boot/dts/mt7629-rfb.dts  
> b/arch/arm/boot/dts/mt7629-rfb.dts
> index 3621b7d2b22a..9980c10c6e29 100644
> --- a/arch/arm/boot/dts/mt7629-rfb.dts
> +++ b/arch/arm/boot/dts/mt7629-rfb.dts
> @@ -66,9 +66,21 @@
>  	pinctrl-1 = <&ephy_leds_pins>;
>  	status = "okay";
>
> +	gmac0: mac@0 {
> +		compatible = "mediatek,eth-mac";
> +		reg = <0>;
> +		phy-mode = "2500base-x";
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

Reviewed-by: René van Dorst <opensource@vdorst.com>


