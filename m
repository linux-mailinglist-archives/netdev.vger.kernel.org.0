Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0332D5190
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbgLJDlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:41:08 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:32859 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730351AbgLJDlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:41:08 -0500
Received: by mail-ot1-f67.google.com with SMTP id b18so3644397ots.0;
        Wed, 09 Dec 2020 19:40:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zxFdPDyVGEXhYmb/fHnJuBKhz+02dM/saG9iGDW+lVQ=;
        b=DZ8a5NBjM86n8iB7SdxaRqDYdSVN9xWdMEEy6F1xanzi2ap70ptTlc88Y697fsYBVZ
         rIBsZF62qirHwc7BtzUR/Iu2E4/PphABHb667BpB8nefZEibzHSy0g41jZr8kHYDrURj
         yP4YJCsNCqbJrhw2nwuiK7CtSDYldGulmra+//35DYZsPT1xvL/xs1EBbuaNrWU8yH50
         ByC0H2PaJ56VFCvswlhy8BVJ/M0kWI1ZdkU6xXYg/m3vgwWLvQhqa2S3ErJrrW6AXAVD
         8FociTn6dLVon+fFjXxdLfcNS7NBzy7bP85j5m2mfvcuOMU7WdTH9r0ddHzQ//yLzwKv
         FzDw==
X-Gm-Message-State: AOAM530JVhnXOJ1TOsnKo/yoRLXd1DBq3kLvVTYiQxIyenA8BK9gxcTH
        oIgLkbsacLWB7+OAUhlxUA==
X-Google-Smtp-Source: ABdhPJzOvfS5bzu0KfnGq2A2D4AMo8GXn1ksvym69lo1fY1ypTIckZ51CJSMo6xoALidH/gjZdri7Q==
X-Received: by 2002:a05:6830:2081:: with SMTP id y1mr4431166otq.341.1607571627675;
        Wed, 09 Dec 2020 19:40:27 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id n63sm746156oih.39.2020.12.09.19.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 19:40:26 -0800 (PST)
Received: (nullmailer pid 1611863 invoked by uid 1000);
        Thu, 10 Dec 2020 03:40:25 -0000
Date:   Wed, 9 Dec 2020 21:40:25 -0600
From:   Rob Herring <robh@kernel.org>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] dt-bindings: net: dsa: lantiq, lantiq-gswip: add
 example for xRX330
Message-ID: <20201210034025.GA1610317@robh.at.kernel.org>
References: <20201206132713.13452-1-olek2@wp.pl>
 <20201206132713.13452-3-olek2@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206132713.13452-3-olek2@wp.pl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 06, 2020 at 02:27:13PM +0100, Aleksander Jan Bajkowski wrote:
> Add compatible string and example for xRX300 and xRX330.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  .../bindings/net/dsa/lantiq-gswip.txt         | 110 +++++++++++++++++-
>  1 file changed, 109 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt b/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
> index 886cbe8ffb38..7a90a6a1b065 100644
> --- a/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt
> @@ -3,7 +3,8 @@ Lantiq GSWIP Ethernet switches
>  
>  Required properties for GSWIP core:
>  
> -- compatible	: "lantiq,xrx200-gswip" for the embedded GSWIP in the
> +- compatible	: "lantiq,xrx200-gswip", "lantiq,xrx300-gswip" or
> +		  "lantiq,xrx330-gswip" for the embedded GSWIP in the
>  		  xRX200 SoC
>  - reg		: memory range of the GSWIP core registers
>  		: memory range of the GSWIP MDIO registers
> @@ -141,3 +142,110 @@ switch@e108000 {
>  		};
>  	};
>  };
> +
> +Ethernet switch on the GRX330 SoC:

A new compatible string doesn't justify a new example.

Consider converting to DT schema.

> +
> +switch@e108000 {
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +	compatible = "lantiq,xrx300-gswip";
> +	reg = <	0xe108000 0x3100	/* switch */
> +		0xe10b100 0xd8		/* mdio */
> +		0xe10b1d8 0x130		/* mii */
> +		>;
> +	dsa,member = <0 0>;
> +
> +	ports {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		port@1 {
> +			reg = <1>;
> +			label = "lan1";
> +			phy-mode = "internal";
> +			phy-handle = <&phy1>;
> +		};
> +
> +		port@2 {
> +			reg = <2>;
> +			label = "lan2";
> +			phy-mode = "internal";
> +			phy-handle = <&phy2>;
> +		};
> +
> +		port@3 {
> +			reg = <3>;
> +			label = "lan3";
> +			phy-mode = "internal";
> +			phy-handle = <&phy3>;
> +		};
> +
> +		port@4 {
> +			reg = <4>;
> +			label = "lan4";
> +			phy-mode = "internal";
> +			phy-handle = <&phy4>;
> +		};
> +
> +		port@6 {
> +			reg = <0x6>;
> +			label = "cpu";
> +			ethernet = <&eth0>;
> +		};
> +	};
> +
> +	mdio {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "lantiq,xrx200-mdio";
> +		reg = <0>;
> +
> +		phy1: ethernet-phy@1 {
> +			reg = <0x1>;
> +		};
> +		phy2: ethernet-phy@2 {
> +			reg = <0x2>;
> +		};
> +		phy3: ethernet-phy@3 {
> +			reg = <0x3>;
> +		};
> +		phy4: ethernet-phy@4 {
> +			reg = <0x4>;
> +		};
> +	};
> +
> +	gphy-fw {
> +		compatible = "lantiq,xrx330-gphy-fw", "lantiq,gphy-fw";
> +		lantiq,rcu = <&rcu0>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		gphy@20 {
> +			reg = <0x20>;
> +
> +			resets = <&reset0 31 30>;
> +			reset-names = "gphy";
> +		};
> +
> +		gphy@68 {
> +			reg = <0x68>;
> +
> +			resets = <&reset0 29 28>;
> +			reset-names = "gphy";
> +		};
> +
> +		gphy@ac {
> +			reg = <0xac>;
> +
> +			resets = <&reset0 28 13>;
> +			reset-names = "gphy";
> +		};
> +
> +		gphy@264 {
> +			reg = <0x264>;
> +
> +			resets = <&reset0 10 10>;
> +			reset-names = "gphy";
> +		};
> +	};
> +};
> -- 
> 2.20.1
> 
