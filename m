Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B19EA9FA95
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 08:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfH1GfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 02:35:24 -0400
Received: from mx.0dd.nl ([5.2.79.48]:46572 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbfH1GfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 02:35:23 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 13AF85FA71;
        Wed, 28 Aug 2019 08:35:21 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="DzxTpOqP";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id CD7891DA57A4;
        Wed, 28 Aug 2019 08:35:20 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com CD7891DA57A4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566974120;
        bh=+9RZEnPgX2ksESdB/bF+PT8GofXKlxNi+RpGRFBtU3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DzxTpOqPdYiJOzKQH0sss7LLUa5wQ/g8SA9H/IZ4XGuoxWyJ0StvBJTwm+7ZdheUP
         fhb/yZcBl55A1yYRkQ7NBX1W/xknDwWRp/ZJqw7cRvFT09sFKeCC3f7ZAoYEIdX2mr
         xCKQXfM03RpibxtE/zRuWzDfHg9wUP6bXoAQfz4ogp1YHlSNdx1/M6US9A+73NZzl2
         Su50dLCGh2PJ39dHE+RAafG/4UNGHPNpvCP409FHIku4h39rjlpKhNi1kR4Gz+ErZp
         QnrSHcEIjFmw8coQwoxLqEUdO/jILB8dYj6MiCWI2lK4pwJs1B6UOjtadzF+gGmhTn
         EhU8Z+JBYunow==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Wed, 28 Aug 2019 06:35:20 +0000
Date:   Wed, 28 Aug 2019 06:35:20 +0000
Message-ID: <20190828063520.Horde.4_ak7mcmFhVJlxZWWy2wo3V@www.vdorst.com>
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
In-Reply-To: <20190827222251.GA30507@bogus>
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

Quoting Rob Herring <robh@kernel.org>:

> On Wed, Aug 21, 2019 at 04:45:46PM +0200, René van Dorst wrote:
>> MT7530 port 5 has many modes/configurations.
>> Update the documentation how to use port 5.
>>
>> Signed-off-by: René van Dorst <opensource@vdorst.com>
>> Cc: devicetree@vger.kernel.org
>> Cc: Rob Herring <robh@kernel.org>
>
>> v1->v2:
>> * Adding extra note about RGMII2 and gpio use.
>> rfc->v1:
>> * No change
>
> The changelog goes below the '---'
>

Thanks for the review,
I shall fix that.

>> ---
>>  .../devicetree/bindings/net/dsa/mt7530.txt    | 218 ++++++++++++++++++
>>  1 file changed, 218 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/dsa/mt7530.txt  
>> b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
>> index 47aa205ee0bd..43993aae3f9c 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/mt7530.txt
>> +++ b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
>> @@ -35,6 +35,42 @@ Required properties for the child nodes within  
>> ports container:
>>  - phy-mode: String, must be either "trgmii" or "rgmii" for port labeled
>>  	 "cpu".
>>
>> +Port 5 of the switch is muxed between:
>> +1. GMAC5: GMAC5 can interface with another external MAC or PHY.
>> +2. PHY of port 0 or port 4: PHY interfaces with an external MAC  
>> like 2nd GMAC
>> +   of the SOC. Used in many setups where port 0/4 becomes the WAN port.
>> +   Note: On a MT7621 SOC with integrated switch: 2nd GMAC can only  
>> connected to
>> +	 GMAC5 when the gpios for RGMII2 (GPIO 22-33) are not used and not
>> +	 connected to external component!
>> +
>> +Port 5 modes/configurations:
>> +1. Port 5 is disabled and isolated: An external phy can interface  
>> to the 2nd
>> +   GMAC of the SOC.
>> +   In the case of a build-in MT7530 switch, port 5 shares the  
>> RGMII bus with 2nd
>> +   GMAC and an optional external phy. Mind the GPIO/pinctl  
>> settings of the SOC!
>> +2. Port 5 is muxed to PHY of port 0/4: Port 0/4 interfaces with 2nd GMAC.
>> +   It is a simple MAC to PHY interface, port 5 needs to be setup  
>> for xMII mode
>> +   and RGMII delay.
>> +3. Port 5 is muxed to GMAC5 and can interface to an external phy.
>> +   Port 5 becomes an extra switch port.
>> +   Only works on platform where external phy TX<->RX lines are swapped.
>> +   Like in the Ubiquiti ER-X-SFP.
>> +4. Port 5 is muxed to GMAC5 and interfaces with the 2nd GAMC as  
>> 2nd CPU port.
>> +   Currently a 2nd CPU port is not supported by DSA code.
>> +
>> +Depending on how the external PHY is wired:
>> +1. normal: The PHY can only connect to 2nd GMAC but not to the switch
>> +2. swapped: RGMII TX, RX are swapped; external phy interface with  
>> the switch as
>> +   a ethernet port. But can't interface to the 2nd GMAC.
>> +
>> +Based on the DT the port 5 mode is configured.
>> +
>> +Driver tries to lookup the phy-handle of the 2nd GMAC of the master device.
>> +When phy-handle matches PHY of port 0 or 4 then port 5 set-up as mode 2.
>> +phy-mode must be set, see also example 2 below!
>> + * mt7621: phy-mode = "rgmii-txid";
>> + * mt7623: phy-mode = "rgmii";
>> +
>>  See Documentation/devicetree/bindings/net/dsa/dsa.txt for a list  
>> of additional
>>  required, optional properties and how the integrated switch subnodes must
>>  be specified.
>> @@ -94,3 +130,185 @@ Example:
>>  			};
>>  		};
>>  	};
>> +
>> +Example 2: MT7621: Port 4 is WAN port: 2nd GMAC -> Port 5 -> PHY port 4.
>> +
>> +&eth {
>> +	status = "okay";
>
> Don't show status in examples.

OK.

> This should show the complete node.
>

To be clear, I should take ethernet node from the mt7621.dtsi [0] or  
mt7623.dtsi
[1] and insert the example below?, right?

Greats,

René

[0]:  
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/staging/mt7621-dts/mt7621.dtsi#n397
[1]:  
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/arch/arm/boot/dts/mt7623.dtsi#n1023

>> +
>> +	gmac0: mac@0 {
>> +		compatible = "mediatek,eth-mac";
>> +		reg = <0>;
>> +		phy-mode = "rgmii";
>> +
>> +		fixed-link {
>> +			speed = <1000>;
>> +			full-duplex;
>> +			pause;
>> +		};
>> +	};
>> +
>> +	gmac1: mac@1 {
>> +		compatible = "mediatek,eth-mac";
>> +		reg = <1>;
>> +		phy-mode = "rgmii-txid";
>> +		phy-handle = <&phy4>;
>> +	};
>> +
>> +	mdio: mdio-bus {
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +
>> +		/* Internal phy */
>> +		phy4: ethernet-phy@4 {
>> +			reg = <4>;
>> +		};
>> +
>> +		mt7530: switch@1f {
>> +			compatible = "mediatek,mt7621";
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			reg = <0x1f>;
>> +			pinctrl-names = "default";
>> +			mediatek,mcm;
>> +
>> +			resets = <&rstctrl 2>;
>> +			reset-names = "mcm";
>> +
>> +			ports {
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +
>> +				port@0 {
>> +					reg = <0>;
>> +					label = "lan0";
>> +				};
>> +
>> +				port@1 {
>> +					reg = <1>;
>> +					label = "lan1";
>> +				};
>> +
>> +				port@2 {
>> +					reg = <2>;
>> +					label = "lan2";
>> +				};
>> +
>> +				port@3 {
>> +					reg = <3>;
>> +					label = "lan3";
>> +				};
>> +
>> +/* Commented out. Port 4 is handled by 2nd GMAC.
>> +				port@4 {
>> +					reg = <4>;
>> +					label = "lan4";
>> +				};
>> +*/
>> +
>> +				cpu_port0: port@6 {
>> +					reg = <6>;
>> +					label = "cpu";
>> +					ethernet = <&gmac0>;
>> +					phy-mode = "rgmii";
>> +
>> +					fixed-link {
>> +						speed = <1000>;
>> +						full-duplex;
>> +						pause;
>> +					};
>> +				};
>> +			};
>> +		};
>> +	};
>> +};
>> +
>> +Example 3: MT7621: Port 5 is connected to external PHY: Port 5 ->  
>> external PHY.
>> +
>> +&eth {
>> +	status = "okay";
>> +
>> +	gmac0: mac@0 {
>> +		compatible = "mediatek,eth-mac";
>> +		reg = <0>;
>> +		phy-mode = "rgmii";
>> +
>> +		fixed-link {
>> +			speed = <1000>;
>> +			full-duplex;
>> +			pause;
>> +		};
>> +	};
>> +
>> +	mdio: mdio-bus {
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +
>> +		/* External phy */
>> +		ephy5: ethernet-phy@7 {
>> +			reg = <7>;
>> +		};
>> +
>> +		mt7530: switch@1f {
>> +			compatible = "mediatek,mt7621";
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			reg = <0x1f>;
>> +			pinctrl-names = "default";
>> +			mediatek,mcm;
>> +
>> +			resets = <&rstctrl 2>;
>> +			reset-names = "mcm";
>> +
>> +			ports {
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +
>> +				port@0 {
>> +					reg = <0>;
>> +					label = "lan0";
>> +				};
>> +
>> +				port@1 {
>> +					reg = <1>;
>> +					label = "lan1";
>> +				};
>> +
>> +				port@2 {
>> +					reg = <2>;
>> +					label = "lan2";
>> +				};
>> +
>> +				port@3 {
>> +					reg = <3>;
>> +					label = "lan3";
>> +				};
>> +
>> +				port@4 {
>> +					reg = <4>;
>> +					label = "lan4";
>> +				};
>> +
>> +				port@5 {
>> +					reg = <5>;
>> +					label = "lan5";
>> +					phy-mode = "rgmii";
>> +					phy-handle = <&ephy5>;
>> +				};
>> +
>> +				cpu_port0: port@6 {
>> +					reg = <6>;
>> +					label = "cpu";
>> +					ethernet = <&gmac0>;
>> +					phy-mode = "rgmii";
>> +
>> +					fixed-link {
>> +						speed = <1000>;
>> +						full-duplex;
>> +						pause;
>> +					};
>> +				};
>> +			};
>> +		};
>> +	};
>> +};
>> --
>> 2.20.1
>>



