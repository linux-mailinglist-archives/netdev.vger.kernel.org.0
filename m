Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A150B3674F5
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 00:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343521AbhDUWFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 18:05:06 -0400
Received: from mail-ot1-f43.google.com ([209.85.210.43]:38656 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343520AbhDUWE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 18:04:56 -0400
Received: by mail-ot1-f43.google.com with SMTP id e89-20020a9d01e20000b0290294134181aeso14524824ote.5;
        Wed, 21 Apr 2021 15:04:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YyWRRR5pID7wLfiSPpITLgjBSDaDSiWNgGz2ZVQAVm4=;
        b=ae3d0T1qBMB0S5CiJdUCkqxiBbzoDZTcyk1Hv1yZGEfclEJ8a84CxuTmx6DFGBmIgb
         pJ3b83yJATEs+TrFrye2NQGk+LK9NPfmu5LZ3R6mJc8jgqJwoNRF+zc0A2AdKMOa4WJS
         0jsx5O4M0Ll2Y+TQHal+Ki8kBSgWF1an5cIiJ/Ew6BYFlpbMP+YXNXGrjK243TXbjzQD
         PlwQczhVAqYXkm+uL54ui78CR0XMdaRkXQy4UqWPOso7H2lZAOrkVVOhLUask8ABCcA3
         FodC2SSiqbMtxqTYftGhWvWKRbZNJmDm/wRibb3QMiKpi/eHuZy9Sj16j53L4KCcAUA3
         ZLXQ==
X-Gm-Message-State: AOAM530Vh7QAUovCX6O1WaCOYH2dbG0kLlnPlQpa+0IFLRsYs8VcSUw4
        x/6ISTwszo9tiXv/IQKDo3CViY126w==
X-Google-Smtp-Source: ABdhPJzSgNh0eNuEFHn0OFogk6iPvpAuniBWUk4gpFN/M9tEV9RdIvzxu7w4iRlWdvf0PZgHYwNEIQ==
X-Received: by 2002:a05:6830:158e:: with SMTP id i14mr258106otr.154.1619042584165;
        Wed, 21 Apr 2021 15:03:04 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id v12sm163185ota.63.2021.04.21.15.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 15:03:03 -0700 (PDT)
Received: (nullmailer pid 1695324 invoked by uid 1000);
        Wed, 21 Apr 2021 22:03:02 -0000
Date:   Wed, 21 Apr 2021 17:03:02 -0500
From:   Rob Herring <robh@kernel.org>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        John Crispin <john@phrozen.org>
Subject: Re: [PATCH] dt-bindings: net: mediatek/ralink: remove unused bindings
Message-ID: <20210421220302.GA1637795@robh.at.kernel.org>
References: <20210420024222.101615-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420024222.101615-1-ilya.lipnitskiy@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 07:42:22PM -0700, Ilya Lipnitskiy wrote:
> Revert commit 663148e48a66 ("Documentation: DT: net: add docs for
> ralink/mediatek SoC ethernet binding")
> 
> No in-tree drivers use the compatible strings present in these bindings,
> and some have been superseded by DSA-capable mtk_eth_soc driver, so
> remove these obsolete bindings.

Looks like maybe OpenWRT folks are using these. If so, you can't revert 
them.

> 
> Cc: John Crispin <john@phrozen.org>
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> ---
>  .../bindings/net/mediatek,mt7620-gsw.txt      | 24 --------
>  .../bindings/net/ralink,rt2880-net.txt        | 59 -------------------
>  .../bindings/net/ralink,rt3050-esw.txt        | 30 ----------
>  3 files changed, 113 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt
>  delete mode 100644 Documentation/devicetree/bindings/net/ralink,rt2880-net.txt
>  delete mode 100644 Documentation/devicetree/bindings/net/ralink,rt3050-esw.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt b/Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt
> deleted file mode 100644
> index 358fed2fab43..000000000000
> --- a/Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt
> +++ /dev/null
> @@ -1,24 +0,0 @@
> -Mediatek Gigabit Switch
> -=======================
> -
> -The mediatek gigabit switch can be found on Mediatek SoCs (mt7620, mt7621).
> -
> -Required properties:
> -- compatible: Should be "mediatek,mt7620-gsw" or "mediatek,mt7621-gsw"
> -- reg: Address and length of the register set for the device
> -- interrupts: Should contain the gigabit switches interrupt
> -- resets: Should contain the gigabit switches resets
> -- reset-names: Should contain the reset names "gsw"
> -
> -Example:
> -
> -gsw@10110000 {
> -	compatible = "ralink,mt7620-gsw";
> -	reg = <0x10110000 8000>;
> -
> -	resets = <&rstctrl 23>;
> -	reset-names = "gsw";
> -
> -	interrupt-parent = <&intc>;
> -	interrupts = <17>;
> -};
> diff --git a/Documentation/devicetree/bindings/net/ralink,rt2880-net.txt b/Documentation/devicetree/bindings/net/ralink,rt2880-net.txt
> deleted file mode 100644
> index 9fe1a0a22e44..000000000000
> --- a/Documentation/devicetree/bindings/net/ralink,rt2880-net.txt
> +++ /dev/null
> @@ -1,59 +0,0 @@
> -Ralink Frame Engine Ethernet controller
> -=======================================
> -
> -The Ralink frame engine ethernet controller can be found on Ralink and
> -Mediatek SoCs (RT288x, RT3x5x, RT366x, RT388x, rt5350, mt7620, mt7621, mt76x8).
> -
> -Depending on the SoC, there is a number of ports connected to the CPU port
> -directly and/or via a (gigabit-)switch.
> -
> -* Ethernet controller node
> -
> -Required properties:
> -- compatible: Should be one of "ralink,rt2880-eth", "ralink,rt3050-eth",
> -  "ralink,rt3050-eth", "ralink,rt3883-eth", "ralink,rt5350-eth",
> -  "mediatek,mt7620-eth", "mediatek,mt7621-eth"
> -- reg: Address and length of the register set for the device
> -- interrupts: Should contain the frame engines interrupt
> -- resets: Should contain the frame engines resets
> -- reset-names: Should contain the reset names "fe". If a switch is present
> -  "esw" is also required.
> -
> -
> -* Ethernet port node
> -
> -Required properties:
> -- compatible: Should be "ralink,eth-port"
> -- reg: The number of the physical port
> -- phy-handle: reference to the node describing the phy
> -
> -Example:
> -
> -mdio-bus {
> -	...
> -	phy0: ethernet-phy@0 {
> -		phy-mode = "mii";
> -		reg = <0>;
> -	};
> -};
> -
> -ethernet@400000 {
> -	compatible = "ralink,rt2880-eth";
> -	reg = <0x00400000 10000>;
> -
> -	#address-cells = <1>;
> -	#size-cells = <0>;
> -
> -	resets = <&rstctrl 18>;
> -	reset-names = "fe";
> -
> -	interrupt-parent = <&cpuintc>;
> -	interrupts = <5>;
> -
> -	port@0 {
> -		compatible = "ralink,eth-port";
> -		reg = <0>;
> -		phy-handle = <&phy0>;
> -	};
> -
> -};
> diff --git a/Documentation/devicetree/bindings/net/ralink,rt3050-esw.txt b/Documentation/devicetree/bindings/net/ralink,rt3050-esw.txt
> deleted file mode 100644
> index 87e315856efa..000000000000
> --- a/Documentation/devicetree/bindings/net/ralink,rt3050-esw.txt
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -Ralink Fast Ethernet Embedded Switch
> -====================================
> -
> -The ralink fast ethernet embedded switch can be found on Ralink and Mediatek
> -SoCs (RT3x5x, RT5350, MT76x8).
> -
> -Required properties:
> -- compatible: Should be "ralink,rt3050-esw"
> -- reg: Address and length of the register set for the device
> -- interrupts: Should contain the embedded switches interrupt
> -- resets: Should contain the embedded switches resets
> -- reset-names: Should contain the reset names "esw"
> -
> -Optional properties:
> -- ralink,portmap: can be used to choose if the default switch setup is
> -  llllw or wllll
> -- ralink,led_polarity: override the active high/low settings of the leds
> -
> -Example:
> -
> -esw@10110000 {
> -	compatible = "ralink,rt3050-esw";
> -	reg = <0x10110000 8000>;
> -
> -	resets = <&rstctrl 23>;
> -	reset-names = "esw";
> -
> -	interrupt-parent = <&intc>;
> -	interrupts = <17>;
> -};
> -- 
> 2.31.1
> 
