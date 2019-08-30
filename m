Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8003A3CD1
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 19:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfH3RQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 13:16:07 -0400
Received: from mx.0dd.nl ([5.2.79.48]:57086 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbfH3RQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 13:16:06 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id E7DA95FC82;
        Fri, 30 Aug 2019 19:16:03 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="cFkj3+8T";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id A430A1DAE219;
        Fri, 30 Aug 2019 19:16:03 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com A430A1DAE219
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1567185363;
        bh=YVARbI/Cl7CtDXBi2526daUB1XB9B3qC3CMJs1E2HFI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cFkj3+8TkpuqANEkNHa+uM0tE7IqSIIh6pTsz9WJfUHR9IHR0Q3MaX5EHTFEcxnUx
         +NqjMjiHyulWG+mllj2rvznkNpMhJmqQA/Qn/ZmZJTxejrz0D+1+YtrN/HWSpMRBMo
         4UVUk+pQ53S6Hp1mrCEGMalp4UtuqJzdz8xFIZWd7AmehujnofaddiE6bkkawI3WBr
         dhz2/perY2Qk9y6hjGmVhJbcgTnt8VyT89VH5KvjtCWKLY1/9FKQH4oJrUxVvW6LER
         vCxgKonf/CcEe8xV0K28cQ1jEAPNoBXBtd5g2M5VJ2Ye+r0mTDa9d3mygtjwrVb+cv
         qB8RjBjqheYCg==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Fri, 30 Aug 2019 17:16:03 +0000
Date:   Fri, 30 Aug 2019 17:16:03 +0000
Message-ID: <20190830171603.Horde.UeVVg_YU-C4f8bcYmFJ_1Gv@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Rob Herring <robh@kernel.org>
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
References: <20190821144547.15113-1-opensource@vdorst.com>
 <20190821144547.15113-3-opensource@vdorst.com>
 <20190827222251.GA30507@bogus>
 <20190828063520.Horde.4_ak7mcmFhVJlxZWWy2wo3V@www.vdorst.com>
In-Reply-To: <20190828063520.Horde.4_ak7mcmFhVJlxZWWy2wo3V@www.vdorst.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

<snip>

>>> See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list  
>>> of additional
>>> required, optional properties and how the integrated switch subnodes must
>>> be specified.
>>> @@ -94,3 +130,185 @@ Example:
>>> 			};
>>> 		};
>>> 	};
>>> +
>>> +Example 2: MT7621: Port 4 is WAN port: 2nd GMAC -> Port 5 -> PHY port 4.
>>> +
>>> +&eth {
>>> +	status = "okay";
>>
>> Don't show status in examples.
>
> OK.
>
>> This should show the complete node.
>>
>

I asked this question below in my previous email.
May be you missed it, I hope that you have time soon to answer this so that I
can send a new version.

> To be clear, I should take ethernet node from the mt7621.dtsi [0] or  
> mt7623.dtsi [1] and insert the example below?, right?

Greats,

René

>
> Greats,
>
> René
>
> [0]:  
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/staging/mt7621-dts/mt7621.dtsi#n397
> [1]:  
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/arch/arm/boot/dts/mt7623.dtsi#n1023
>
>>> +
>>> +	gmac0: mac@0 {
>>> +		compatible = "mediatek,eth-mac";
>>> +		reg = <0>;
>>> +		phy-mode = "rgmii";
>>> +
>>> +		fixed-link {
>>> +			speed = <1000>;
>>> +			full-duplex;
>>> +			pause;
>>> +		};
>>> +	};
>>> +
>>> +	gmac1: mac@1 {
>>> +		compatible = "mediatek,eth-mac";
>>> +		reg = <1>;
>>> +		phy-mode = "rgmii-txid";
>>> +		phy-handle = <&phy4>;
>>> +	};
>>> +
>>> +	mdio: mdio-bus {
>>> +		#address-cells = <1>;
>>> +		#size-cells = <0>;
>>> +
>>> +		/* Internal phy */
>>> +		phy4: ethernet-phy@4 {
>>> +			reg = <4>;
>>> +		};
>>> +
>>> +		mt7530: switch@1f {
>>> +			compatible = "mediatek,mt7621";
>>> +			#address-cells = <1>;
>>> +			#size-cells = <0>;
>>> +			reg = <0x1f>;
>>> +			pinctrl-names = "default";
>>> +			mediatek,mcm;
>>> +
>>> +			resets = <&rstctrl 2>;
>>> +			reset-names = "mcm";
>>> +
>>> +			ports {
>>> +				#address-cells = <1>;
>>> +				#size-cells = <0>;
>>> +
>>> +				port@0 {
>>> +					reg = <0>;
>>> +					label = "lan0";
>>> +				};
>>> +
>>> +				port@1 {
>>> +					reg = <1>;
>>> +					label = "lan1";
>>> +				};
>>> +
>>> +				port@2 {
>>> +					reg = <2>;
>>> +					label = "lan2";
>>> +				};
>>> +
>>> +				port@3 {
>>> +					reg = <3>;
>>> +					label = "lan3";
>>> +				};
>>> +
>>> +/* Commented out. Port 4 is handled by 2nd GMAC.
>>> +				port@4 {
>>> +					reg = <4>;
>>> +					label = "lan4";
>>> +				};
>>> +*/
>>> +
>>> +				cpu_port0: port@6 {
>>> +					reg = <6>;
>>> +					label = "cpu";
>>> +					ethernet = <&gmac0>;
>>> +					phy-mode = "rgmii";
>>> +
>>> +					fixed-link {
>>> +						speed = <1000>;
>>> +						full-duplex;
>>> +						pause;
>>> +					};
>>> +				};
>>> +			};
>>> +		};
>>> +	};
>>> +};
>>> +
>>> +Example 3: MT7621: Port 5 is connected to external PHY: Port 5 ->  
>>> external PHY.
>>> +
>>> +&eth {
>>> +	status = "okay";
>>> +
>>> +	gmac0: mac@0 {
>>> +		compatible = "mediatek,eth-mac";
>>> +		reg = <0>;
>>> +		phy-mode = "rgmii";
>>> +
>>> +		fixed-link {
>>> +			speed = <1000>;
>>> +			full-duplex;
>>> +			pause;
>>> +		};
>>> +	};
>>> +
>>> +	mdio: mdio-bus {
>>> +		#address-cells = <1>;
>>> +		#size-cells = <0>;
>>> +
>>> +		/* External phy */
>>> +		ephy5: ethernet-phy@7 {
>>> +			reg = <7>;
>>> +		};
>>> +
>>> +		mt7530: switch@1f {
>>> +			compatible = "mediatek,mt7621";
>>> +			#address-cells = <1>;
>>> +			#size-cells = <0>;
>>> +			reg = <0x1f>;
>>> +			pinctrl-names = "default";
>>> +			mediatek,mcm;
>>> +
>>> +			resets = <&rstctrl 2>;
>>> +			reset-names = "mcm";
>>> +
>>> +			ports {
>>> +				#address-cells = <1>;
>>> +				#size-cells = <0>;
>>> +
>>> +				port@0 {
>>> +					reg = <0>;
>>> +					label = "lan0";
>>> +				};
>>> +
>>> +				port@1 {
>>> +					reg = <1>;
>>> +					label = "lan1";
>>> +				};
>>> +
>>> +				port@2 {
>>> +					reg = <2>;
>>> +					label = "lan2";
>>> +				};
>>> +
>>> +				port@3 {
>>> +					reg = <3>;
>>> +					label = "lan3";
>>> +				};
>>> +
>>> +				port@4 {
>>> +					reg = <4>;
>>> +					label = "lan4";
>>> +				};
>>> +
>>> +				port@5 {
>>> +					reg = <5>;
>>> +					label = "lan5";
>>> +					phy-mode = "rgmii";
>>> +					phy-handle = <&ephy5>;
>>> +				};
>>> +
>>> +				cpu_port0: port@6 {
>>> +					reg = <6>;
>>> +					label = "cpu";
>>> +					ethernet = <&gmac0>;
>>> +					phy-mode = "rgmii";
>>> +
>>> +					fixed-link {
>>> +						speed = <1000>;
>>> +						full-duplex;
>>> +						pause;
>>> +					};
>>> +				};
>>> +			};
>>> +		};
>>> +	};
>>> +};
>>> --
>>> 2.20.1
>>>



