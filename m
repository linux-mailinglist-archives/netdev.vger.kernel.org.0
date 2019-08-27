Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB7F39F601
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 00:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfH0WWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 18:22:54 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45676 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfH0WWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 18:22:54 -0400
Received: by mail-ot1-f68.google.com with SMTP id m24so732302otp.12;
        Tue, 27 Aug 2019 15:22:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=/f04tIn5dv2BqiWtl+8rS9yAZ1i1dMhiBr7VR2zkjdA=;
        b=blbkKJcaOwkneTqarAZDF+WH+3a7xsECok6vCbyOrSjsvQpTAKfFlWYid8bIv1CMVG
         L0ciGNwaBHzHNAhQSL3hHdi0M32qFDS6yVQc5ojKHb+WPn4HPIvUhOtw51ObaT1wOjX4
         LPRkfSTONLDgcslhdaRAA2Hq6m3hguLJz45aNx+3V+lHGzxetEZqHX5/CZaW1TG+Kv6E
         lhQ/aSwyGCU5rp3RXtbkPijnvPJaTz4VhyJT6aRopKr7JK1yGKEHnVNmtNdXOJhFOlZP
         Ncvjo/WMdOvpBDyNWQFnf/ynhiKs0DbU2tckLrXQb3B43S6ABP6F7NDAZESBpCPOhim4
         fvBQ==
X-Gm-Message-State: APjAAAXzPZ1rDzKyiGmbQSEb5UuOxDq75bn+6axePAhUwf+jFfoaXFD8
        Hat/UJDc5Snjw9BcC+b1uA==
X-Google-Smtp-Source: APXvYqyDWDcwoGu4GXcRZQPI12Q/xb1BMkv3c7WcYIGJYvNtN0YVCgQvRwOlnUG4wUHAERWjdAPGsQ==
X-Received: by 2002:a9d:6754:: with SMTP id w20mr766330otm.82.1566944572658;
        Tue, 27 Aug 2019 15:22:52 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 11sm261076otc.45.2019.08.27.15.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 15:22:52 -0700 (PDT)
Date:   Tue, 27 Aug 2019 17:22:51 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>, linux-mips@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] dt-bindings: net: dsa: mt7530: Add
 support for port 5
Message-ID: <20190827222251.GA30507@bogus>
References: <20190821144547.15113-1-opensource@vdorst.com>
 <20190821144547.15113-3-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190821144547.15113-3-opensource@vdorst.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 04:45:46PM +0200, René van Dorst wrote:
> MT7530 port 5 has many modes/configurations.
> Update the documentation how to use port 5.
> 
> Signed-off-by: René van Dorst <opensource@vdorst.com>
> Cc: devicetree@vger.kernel.org
> Cc: Rob Herring <robh@kernel.org>

> v1->v2:
> * Adding extra note about RGMII2 and gpio use.
> rfc->v1:
> * No change

The changelog goes below the '---'

> ---
>  .../devicetree/bindings/net/dsa/mt7530.txt    | 218 ++++++++++++++++++
>  1 file changed, 218 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mt7530.txt b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
> index 47aa205ee0bd..43993aae3f9c 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mt7530.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
> @@ -35,6 +35,42 @@ Required properties for the child nodes within ports container:
>  - phy-mode: String, must be either "trgmii" or "rgmii" for port labeled
>  	 "cpu".
>  
> +Port 5 of the switch is muxed between:
> +1. GMAC5: GMAC5 can interface with another external MAC or PHY.
> +2. PHY of port 0 or port 4: PHY interfaces with an external MAC like 2nd GMAC
> +   of the SOC. Used in many setups where port 0/4 becomes the WAN port.
> +   Note: On a MT7621 SOC with integrated switch: 2nd GMAC can only connected to
> +	 GMAC5 when the gpios for RGMII2 (GPIO 22-33) are not used and not
> +	 connected to external component!
> +
> +Port 5 modes/configurations:
> +1. Port 5 is disabled and isolated: An external phy can interface to the 2nd
> +   GMAC of the SOC.
> +   In the case of a build-in MT7530 switch, port 5 shares the RGMII bus with 2nd
> +   GMAC and an optional external phy. Mind the GPIO/pinctl settings of the SOC!
> +2. Port 5 is muxed to PHY of port 0/4: Port 0/4 interfaces with 2nd GMAC.
> +   It is a simple MAC to PHY interface, port 5 needs to be setup for xMII mode
> +   and RGMII delay.
> +3. Port 5 is muxed to GMAC5 and can interface to an external phy.
> +   Port 5 becomes an extra switch port.
> +   Only works on platform where external phy TX<->RX lines are swapped.
> +   Like in the Ubiquiti ER-X-SFP.
> +4. Port 5 is muxed to GMAC5 and interfaces with the 2nd GAMC as 2nd CPU port.
> +   Currently a 2nd CPU port is not supported by DSA code.
> +
> +Depending on how the external PHY is wired:
> +1. normal: The PHY can only connect to 2nd GMAC but not to the switch
> +2. swapped: RGMII TX, RX are swapped; external phy interface with the switch as
> +   a ethernet port. But can't interface to the 2nd GMAC.
> +
> +Based on the DT the port 5 mode is configured.
> +
> +Driver tries to lookup the phy-handle of the 2nd GMAC of the master device.
> +When phy-handle matches PHY of port 0 or 4 then port 5 set-up as mode 2.
> +phy-mode must be set, see also example 2 below!
> + * mt7621: phy-mode = "rgmii-txid";
> + * mt7623: phy-mode = "rgmii";
> +
>  See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list of additional
>  required, optional properties and how the integrated switch subnodes must
>  be specified.
> @@ -94,3 +130,185 @@ Example:
>  			};
>  		};
>  	};
> +
> +Example 2: MT7621: Port 4 is WAN port: 2nd GMAC -> Port 5 -> PHY port 4.
> +
> +&eth {
> +	status = "okay";

Don't show status in examples.

This should show the complete node.

> +
> +	gmac0: mac@0 {
> +		compatible = "mediatek,eth-mac";
> +		reg = <0>;
> +		phy-mode = "rgmii";
> +
> +		fixed-link {
> +			speed = <1000>;
> +			full-duplex;
> +			pause;
> +		};
> +	};
> +
> +	gmac1: mac@1 {
> +		compatible = "mediatek,eth-mac";
> +		reg = <1>;
> +		phy-mode = "rgmii-txid";
> +		phy-handle = <&phy4>;
> +	};
> +
> +	mdio: mdio-bus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		/* Internal phy */
> +		phy4: ethernet-phy@4 {
> +			reg = <4>;
> +		};
> +
> +		mt7530: switch@1f {
> +			compatible = "mediatek,mt7621";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			reg = <0x1f>;
> +			pinctrl-names = "default";
> +			mediatek,mcm;
> +
> +			resets = <&rstctrl 2>;
> +			reset-names = "mcm";
> +
> +			ports {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
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
> +/* Commented out. Port 4 is handled by 2nd GMAC.
> +				port@4 {
> +					reg = <4>;
> +					label = "lan4";
> +				};
> +*/
> +
> +				cpu_port0: port@6 {
> +					reg = <6>;
> +					label = "cpu";
> +					ethernet = <&gmac0>;
> +					phy-mode = "rgmii";
> +
> +					fixed-link {
> +						speed = <1000>;
> +						full-duplex;
> +						pause;
> +					};
> +				};
> +			};
> +		};
> +	};
> +};
> +
> +Example 3: MT7621: Port 5 is connected to external PHY: Port 5 -> external PHY.
> +
> +&eth {
> +	status = "okay";
> +
> +	gmac0: mac@0 {
> +		compatible = "mediatek,eth-mac";
> +		reg = <0>;
> +		phy-mode = "rgmii";
> +
> +		fixed-link {
> +			speed = <1000>;
> +			full-duplex;
> +			pause;
> +		};
> +	};
> +
> +	mdio: mdio-bus {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		/* External phy */
> +		ephy5: ethernet-phy@7 {
> +			reg = <7>;
> +		};
> +
> +		mt7530: switch@1f {
> +			compatible = "mediatek,mt7621";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			reg = <0x1f>;
> +			pinctrl-names = "default";
> +			mediatek,mcm;
> +
> +			resets = <&rstctrl 2>;
> +			reset-names = "mcm";
> +
> +			ports {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
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
> +					label = "lan4";
> +				};
> +
> +				port@5 {
> +					reg = <5>;
> +					label = "lan5";
> +					phy-mode = "rgmii";
> +					phy-handle = <&ephy5>;
> +				};
> +
> +				cpu_port0: port@6 {
> +					reg = <6>;
> +					label = "cpu";
> +					ethernet = <&gmac0>;
> +					phy-mode = "rgmii";
> +
> +					fixed-link {
> +						speed = <1000>;
> +						full-duplex;
> +						pause;
> +					};
> +				};
> +			};
> +		};
> +	};
> +};
> -- 
> 2.20.1
> 
