Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C34A2520CD
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 21:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgHYTnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 15:43:11 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36614 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgHYTnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 15:43:10 -0400
Received: by mail-io1-f68.google.com with SMTP id i10so8158551iow.3;
        Tue, 25 Aug 2020 12:43:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xFa4K2EMnvtSpb7MXWNHE/NvCVe7Pt+4e7+jJHBanys=;
        b=RWWyOZTC34l4psCUv40YziStvOB1Sju+6sqfXEqpMfEBjbdv5WHhV3D3QQVTonDfof
         9EDuFhEi/LdgR9uHIvIqsPOxxAphKpU2i6vD0qea5JiXseyoikJyEHI1J0PeEssqbeQk
         vPwxEPXqLPkSo8h5Y1CIXX4eDKl01Zq4JZyPGw42yKzqVBTdprFlk2Kq1U+0x+Vc3wEo
         fXSfjJ/cQMMiy4T+t2EKWJjUiIi0Bw/Um61woo8FJm3RTGGoqdnlN2Ai7HHBwQMpfARu
         m++o187vME2t90J7eLaxn3SIQ7Lx6cYpbSDz1DrZuAt1EYPiqxgMptW7KQN9wQyHhahL
         8+5Q==
X-Gm-Message-State: AOAM5319nVVIyI2n29oyjj6E795wEWPD2Z00vpEZ9sNhAFWk04djIPQ/
        DLoJ974wiavfgEcjPKVtaQ==
X-Google-Smtp-Source: ABdhPJw/xaJIuCeQO1r6j9JB2bC93O0bNOs9R51Cj4LIZPtj20c0bgEkzt2KrzZok2oxQxpiHdKeDg==
X-Received: by 2002:a6b:bfc1:: with SMTP id p184mr10370531iof.193.1598384589390;
        Tue, 25 Aug 2020 12:43:09 -0700 (PDT)
Received: from xps15 ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id f128sm9645725ilh.71.2020.08.25.12.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 12:43:08 -0700 (PDT)
Received: (nullmailer pid 1198512 invoked by uid 1000);
        Tue, 25 Aug 2020 19:43:06 -0000
Date:   Tue, 25 Aug 2020 13:43:06 -0600
From:   Rob Herring <robh@kernel.org>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@savoirfairelinux.com, matthias.bgg@gmail.com,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, davem@davemloft.net,
        sean.wang@mediatek.com, opensource@vdorst.com,
        frank-w@public-files.de, dqfext@gmail.com
Subject: Re: [PATCH net-next v2 4/7] dt-bindings: net: dsa: add new MT7531
 binding to support MT7531
Message-ID: <20200825194306.GA1160944@bogus>
References: <cover.1597729692.git.landen.chao@mediatek.com>
 <1ec38b68deec6f1c23e1236d38035b1823ea2ebf.1597729692.git.landen.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ec38b68deec6f1c23e1236d38035b1823ea2ebf.1597729692.git.landen.chao@mediatek.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 03:14:09PM +0800, Landen Chao wrote:
> Add devicetree binding to support the compatible mt7531 switch as used
> in the MediaTek MT7531 switch.
> 
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> Signed-off-by: Landen Chao <landen.chao@mediatek.com>
> ---
>  .../devicetree/bindings/net/dsa/mt7530.txt    | 71 ++++++++++++++++++-
>  1 file changed, 68 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mt7530.txt b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
> index c5ed5d25f642..50eaf40fb612 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mt7530.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
> @@ -5,6 +5,7 @@ Required properties:
>  
>  - compatible: may be compatible = "mediatek,mt7530"
>  	or compatible = "mediatek,mt7621"
> +	or compatible = "mediatek,mt7531"
>  - #address-cells: Must be 1.
>  - #size-cells: Must be 0.
>  - mediatek,mcm: Boolean; if defined, indicates that either MT7530 is the part
> @@ -32,10 +33,13 @@ Required properties for the child nodes within ports container:
>  
>  - reg: Port address described must be 6 for CPU port and from 0 to 5 for
>  	user ports.
> -- phy-mode: String, must be either "trgmii" or "rgmii" for port labeled
> -	 "cpu".
> +- phy-mode: String, the follow value would be acceptable for port labeled "cpu"
> +	If compatible mediatek,mt7530 or mediatek,mt7621 is set,
> +	must be either "trgmii" or "rgmii"
> +	If compatible mediatek,mt7531 is set,
> +	must be either "sgmii", "1000base-x" or "2500base-x"
>  
> -Port 5 of the switch is muxed between:
> +Port 5 of mt7530 and mt7621 switch is muxed between:
>  1. GMAC5: GMAC5 can interface with another external MAC or PHY.
>  2. PHY of port 0 or port 4: PHY interfaces with an external MAC like 2nd GMAC
>     of the SOC. Used in many setups where port 0/4 becomes the WAN port.
> @@ -308,3 +312,64 @@ Example 3: MT7621: Port 5 is connected to external PHY: Port 5 -> external PHY.
>  		};
>  	};
>  };
> +
> +Example 4: MT7531BE port6 -- up-clocked 2.5Gbps SGMII -- MT7622 CPU 1st GMAC

Does this really need another example?

> +
> +&eth {
> +	gmac0: mac@0 {
> +		compatible = "mediatek,eth-mac";
> +		reg = <0>;
> +		phy-mode = "2500base-x";
> +
> +		fixed-link {
> +			speed = <2500>;
> +			full-duplex;
> +			pause;
> +		};
> +	};
> +
> +	&mdio0 {
> +		switch@0 {
> +			compatible = "mediatek,mt7531";
> +			reg = <0>;
> +			reset-gpios = <&pio 54 0>;
> +
> +			ports {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				reg = <0>;
> +
> +				port@0 {
> +					reg = <0>;
> +					label = "lan0";
> +				};
> +
> +				port@1 {
> +					reg = <1>;
> +					label = "lan1";
> +				};
> +
> +				port@2 {
> +					reg = <2>;
> +					label = "lan2";
> +				};
> +
> +				port@3 {
> +					reg = <3>;
> +					label = "lan3";
> +				};
> +
> +				port@4 {
> +					reg = <4>;
> +					label = "wan";
> +				};
> +
> +				port@6 {
> +					reg = <6>;
> +					label = "cpu";
> +					ethernet = <&gmac0>;
> +					phy-mode = "2500base-x";
> +				};
> +			};
> +		};
> +	};
> -- 
> 2.17.1
