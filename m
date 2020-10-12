Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86FC28BFF6
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 20:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgJLSrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 14:47:11 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42255 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgJLSrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 14:47:11 -0400
Received: by mail-oi1-f195.google.com with SMTP id 16so19697259oix.9;
        Mon, 12 Oct 2020 11:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ShzR9BFgdZy6aX77/dQqedNv88AGouB9z1qi5m+uYJs=;
        b=Tbb0EkhkC6qIPgUA2Coa0rIxyfJ/p3GTFgu1jC8k3wQzTQuUcvd6GRNNFhAmn0S7HB
         dIadtJw82lYi2ZKQwTrWvN+uHvHCEO6hq+VyKm/m3TityyYe/nLqTiljNXxWBdP9WQFs
         tk4/caJvkgEjBpL/cfEIbJsaj0qqM7O1lj7CG4WWtB0/AVOx24wvYxnufaLgBqUMojwZ
         RqSuxGu1GcE91Qjl+2u5mcFrsu7pP7mVmMF3oog+G3Sch6lxgrOQL1baYTflvCMVwmKn
         JYMos9JZ8wSqmSmK2FvFGjCmDlp6qsAnYfY/00WEjqMKAS/qsnUvJi8yfMHY0UWR1cSA
         jUCg==
X-Gm-Message-State: AOAM533vpJHXQV5XwAxK1uZjjhnyqy+uLdYZ3to16RGJ/uqhAYnsvumP
        peVUHpA6HJtrA2NfEF8SgQ==
X-Google-Smtp-Source: ABdhPJxPCOPh4o7eRXcC0ipKeU26urXpl74/q1WhBuuliH0Me58Pcjr5cEGWJf6WE95zbJ7TwZM5ZA==
X-Received: by 2002:a05:6808:35a:: with SMTP id j26mr12201964oie.105.1602528429535;
        Mon, 12 Oct 2020 11:47:09 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id n128sm460859oif.14.2020.10.12.11.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 11:47:08 -0700 (PDT)
Received: (nullmailer pid 1893832 invoked by uid 1000);
        Mon, 12 Oct 2020 18:47:07 -0000
Date:   Mon, 12 Oct 2020 13:47:07 -0500
From:   Rob Herring <robh@kernel.org>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, kurt@linutronix.de
Subject: Re: [PATCH net-next 2/2] dt-bindings: net: dsa: b53: Drop old
 bindings
Message-ID: <20201012184707.GA1886314@bogus>
References: <20201010164627.9309-1-kurt@kmk-computers.de>
 <20201010164627.9309-3-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201010164627.9309-3-kurt@kmk-computers.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 06:46:27PM +0200, Kurt Kanzenbach wrote:
> The device tree bindings have been converted to YAML. No need to keep
> the text file around. Update MAINTAINERS file accordingly.

You can squash this into the previous patch.

> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
> ---
>  .../devicetree/bindings/net/dsa/b53.txt       | 149 ------------------
>  MAINTAINERS                                   |   2 +-
>  2 files changed, 1 insertion(+), 150 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/b53.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/b53.txt b/Documentation/devicetree/bindings/net/dsa/b53.txt
> deleted file mode 100644
> index f1487a751b1a..000000000000
> --- a/Documentation/devicetree/bindings/net/dsa/b53.txt
> +++ /dev/null
> @@ -1,149 +0,0 @@
> -Broadcom BCM53xx Ethernet switches
> -==================================
> -
> -Required properties:
> -
> -- compatible: For external switch chips, compatible string must be exactly one
> -  of: "brcm,bcm5325"
> -      "brcm,bcm53115"
> -      "brcm,bcm53125"
> -      "brcm,bcm53128"
> -      "brcm,bcm5365"
> -      "brcm,bcm5395"
> -      "brcm,bcm5389"
> -      "brcm,bcm5397"
> -      "brcm,bcm5398"
> -
> -  For the BCM11360 SoC, must be:
> -      "brcm,bcm11360-srab" and the mandatory "brcm,cygnus-srab" string
> -
> -  For the BCM5310x SoCs with an integrated switch, must be one of:
> -      "brcm,bcm53010-srab"
> -      "brcm,bcm53011-srab"
> -      "brcm,bcm53012-srab"
> -      "brcm,bcm53018-srab"
> -      "brcm,bcm53019-srab" and the mandatory "brcm,bcm5301x-srab" string
> -
> -  For the BCM5831X/BCM1140x SoCs with an integrated switch, must be one of:
> -      "brcm,bcm11404-srab"
> -      "brcm,bcm11407-srab"
> -      "brcm,bcm11409-srab"
> -      "brcm,bcm58310-srab"
> -      "brcm,bcm58311-srab"
> -      "brcm,bcm58313-srab" and the mandatory "brcm,omega-srab" string
> -
> -  For the BCM585xx/586XX/88312 SoCs with an integrated switch, must be one of:
> -      "brcm,bcm58522-srab"
> -      "brcm,bcm58523-srab"
> -      "brcm,bcm58525-srab"
> -      "brcm,bcm58622-srab"
> -      "brcm,bcm58623-srab"
> -      "brcm,bcm58625-srab"
> -      "brcm,bcm88312-srab" and the mandatory "brcm,nsp-srab string
> -
> -  For the BCM63xx/33xx SoCs with an integrated switch, must be one of:
> -      "brcm,bcm3384-switch"
> -      "brcm,bcm6328-switch"
> -      "brcm,bcm6368-switch" and the mandatory "brcm,bcm63xx-switch"
> -
> -Required properties for BCM585xx/586xx/88312 SoCs:
> -
> - - reg: a total of 3 register base addresses, the first one must be the
> -   Switch Register Access block base, the second is the port 5/4 mux
> -   configuration register and the third one is the SGMII configuration
> -   and status register base address.
> -
> - - interrupts: a total of 13 interrupts must be specified, in the following
> -   order: port 0-5, 7-8 link status change, then the integrated PHY interrupt,
> -   then the timestamping interrupt and the sleep timer interrupts for ports
> -   5,7,8.
> -
> -Optional properties for BCM585xx/586xx/88312 SoCs:
> -
> -  - reg-names: a total of 3 names matching the 3 base register address, must
> -    be in the following order:
> -	"srab"
> -	"mux_config"
> -	"sgmii_config"
> -
> -  - interrupt-names: a total of 13 names matching the 13 interrupts specified
> -    must be in the following order:
> -	"link_state_p0"
> -	"link_state_p1"
> -	"link_state_p2"
> -	"link_state_p3"
> -	"link_state_p4"
> -	"link_state_p5"
> -	"link_state_p7"
> -	"link_state_p8"
> -	"phy"
> -	"ts"
> -	"imp_sleep_timer_p5"
> -	"imp_sleep_timer_p7"
> -	"imp_sleep_timer_p8"
> -
> -See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list of additional
> -required and optional properties.
> -
> -Examples:
> -
> -Ethernet switch connected via MDIO to the host, CPU port wired to eth0:
> -
> -	eth0: ethernet@10001000 {
> -		compatible = "brcm,unimac";
> -		reg = <0x10001000 0x1000>;
> -
> -		fixed-link {
> -			speed = <1000>;
> -			full-duplex;
> -		};
> -	};
> -
> -	mdio0: mdio@10000000 {
> -		compatible = "brcm,unimac-mdio";
> -		#address-cells = <1>;
> -		#size-cells = <0>;
> -
> -		switch0: ethernet-switch@1e {
> -			compatible = "brcm,bcm53125";
> -			reg = <30>;
> -			#address-cells = <1>;
> -			#size-cells = <0>;
> -
> -			ports {
> -				#address-cells = <1>;
> -				#size-cells = <0>;
> -
> -				port0@0 {
> -					reg = <0>;
> -					label = "lan1";
> -				};
> -
> -				port1@1 {
> -					reg = <1>;
> -					label = "lan2";
> -				};
> -
> -				port5@5 {
> -					reg = <5>;
> -					label = "cable-modem";
> -					fixed-link {
> -						speed = <1000>;
> -						full-duplex;
> -					};
> -					phy-mode = "rgmii-txid";
> -				};
> -
> -				port8@8 {
> -					reg = <8>;
> -					label = "cpu";
> -					fixed-link {
> -						speed = <1000>;
> -						full-duplex;
> -					};
> -					phy-mode = "rgmii-txid";
> -					ethernet = <&eth0>;
> -				};
> -			};
> -		};
> -	};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 14c2b168e077..79dca6ec803d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3393,7 +3393,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
>  L:	netdev@vger.kernel.org
>  L:	openwrt-devel@lists.openwrt.org (subscribers-only)
>  S:	Supported
> -F:	Documentation/devicetree/bindings/net/dsa/b53.txt
> +F:	Documentation/devicetree/bindings/net/dsa/b53.yaml
>  F:	drivers/net/dsa/b53/*
>  F:	include/linux/platform_data/b53.h
>  
> -- 
> 2.26.2
> 
