Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202C26904CC
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjBIKay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjBIKar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:30:47 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D6E76B3;
        Thu,  9 Feb 2023 02:30:19 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 319ATkvC121886;
        Thu, 9 Feb 2023 04:29:46 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1675938586;
        bh=xIIkAV8g1rE/394M50t+Fx/8OCEy/Yl3d3tlIjdQuaI=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=nk95PVgo+1gdIbIFh9M32SNykikSAMYgyxYiGHLoPOd2IXnGZu/dDZ5o8CKKRm5er
         RlGIe3R4mN2kUR3yzRHE0m9wsuX/PrE0lal8W2y+IC9VqedPRYKIsUHTutQ6VAEUm8
         OvC244gG/NU/bSf5gJ9peazHPtIRvEfGq/Nti4cM=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 319ATkht028156
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 9 Feb 2023 04:29:46 -0600
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 9
 Feb 2023 04:29:46 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 9 Feb 2023 04:29:46 -0600
Received: from [10.24.69.114] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 319ATeDH048003;
        Thu, 9 Feb 2023 04:29:41 -0600
Message-ID: <6713252d-6f86-c674-9229-c4512ebf1d72@ti.com>
Date:   Thu, 9 Feb 2023 15:59:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH v4 2/2] net:
 ti: icssg-prueth: Add ICSSG ethernet driver
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Roger Quadros <rogerq@kernel.org>,
        MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <nm@ti.com>,
        <ssantosh@kernel.org>, <srk@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20230206060708.3574472-1-danishanwar@ti.com>
 <20230206060708.3574472-3-danishanwar@ti.com> <Y+ELeSQX+GWS5N2p@lunn.ch>
 <42503a0d-b434-bbcc-553d-a326af5b4918@ti.com>
 <e8158969-08d0-1edc-24be-8c300a71adbd@kernel.org>
 <4438fb71-7e20-6532-a858-b688bc64e826@ti.com> <Y+Ob8++GWciL127K@lunn.ch>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <Y+Ob8++GWciL127K@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 08/02/23 18:26, Andrew Lunn wrote:
>>>>>> +static int prueth_config_rgmiidelay(struct prueth *prueth,
>>>>>> +				    struct device_node *eth_np,
>>>>>> +				    phy_interface_t phy_if)
>>>>>> +{
>>>>>
>>>>> ...
>>>>>
>>>>>> +	if (phy_if == PHY_INTERFACE_MODE_RGMII_ID ||
>>>>>> +	    phy_if == PHY_INTERFACE_MODE_RGMII_TXID)
>>>>>> +		rgmii_tx_id |= ICSSG_CTRL_RGMII_ID_MODE;
>>>>>> +
>>>>>> +	regmap_update_bits(ctrl_mmr, icssgctrl_reg, ICSSG_CTRL_RGMII_ID_MODE, rgmii_tx_id);
>>>
>>> This is only applicable to some devices so you need to restrict this only
>>> to those devices.
>>>
>>
>> Currently ICSSG driver is getting upstreamed for AM65 SR2.0 device, so I don't
>> think there is any need for any device related restriction. Once support for
>> other devices are enabled for upstream, we can modify this accordingly.
> 
> The problem is, this is a board property, not a SoC property. What if
> somebody designs a board with extra long clock lines in order to add
> the delay?
> 
>> I checked the latest Technical Reference Manual [1] (Section 5.1.3.4.49, Table
>> 5-624) for AM65 Silicon Revision 2.0.
>>
>> Below is the description in Table 5-624
>>
>> BIT	    : 24
>> Field	    : RGMII0_ID_MODE
>> Type	    : R/W
>> Reset	    : 0h
>> Description : Controls the PRU_ICSSG0 RGMII0 port internal transmit delay
>> 	      0h - Internal transmit delay is enabled
>> 	      1h - Reserved
>>
>> The TX internal delay is always enabled and couldn't be disabled as 1h is
>> reserved. So hardware support for disabling TX internal delay is not there.
> 
> So if somebody passes a phy-mode which requires it disabled, you need
> to return -EINVAL, to indicate the hardware cannot actually do it.
> 

Sure, I'll do that. In the list of all phy modes described in [1], I can only
see phy-mode "rgmii-txid", for which we can return -EINVAL. Is there any other
phy-mode that requires enabling/disabling TX internal delays? Please let me
know if any other phy-mode also needs this. I will add check for that as well.

>> As, TX internal delay is always there, there is no need to enable it in MAC or
>> PHY. So no need of API prueth_config_rgmiidelay().
>>
>> My approach to handle delay would be as below.
>>
>> *) Keep phy-mode = "rgmii-id" in DT as asked by Andrew.
> 
> As i said this depends on the board, not the SoC. In theory, you could
> design a board with an extra long RX clock line, and then use phy-mode
> rgmii-txid, meaning the MAC/PHY combination needs to add the TX delay.
> 

Yes I understand that board can have any phy-mode in it's DTS. We need to be
able to handle all different phy modes.

>> *) Let TX internal delay enabled in Hardware.
>> *) Let PHY configure RX internal delay.
>> *) Remove prueth_config_rgmiidelay() API is there is no use of this. TX
>> Internal delay is always enabled.
>> *) Instead of calling prueth_config_rgmiidelay() API in prueth_netdev_init()
>> API, add below if condition.
>>
>> 	if(emac->phy_if == PHY_INTERFACE_MODE_RGMII_ID)
>> 		emac->phy_if == PHY_INTERFACE_MODE_RGMII_RXID
> 
> You should handle all cases where a TX delay is requested, not just
> ID.
> 

So there could be four different RGMII phy modes as described in [1]. Below is
the handling mechanism for different phy modes.

1)    # RGMII with internal RX and TX delays provided by the PHY,
      # the MAC should not add the RX or TX delays in this case
      - rgmii-id

For phy-mode="rgmii-id", phy needs to add both TX and RX internal delays. But
in our SoC TX internal delay is always enabled. So to handle this, we'll change
the phy-mode in driver to "rgmii-rxid" and then pass it ti PHY, so that PHY
will enable RX internal delay only.

2)    # RGMII with internal RX delay provided by the PHY, the MAC
      # should not add an RX delay in this case
      - rgmii-rxid

For phy-mode="rgmii-rxid", phy needs to add only RX internal delay. We will do
nothing in the driver and just pass the same mode to phy, so that PHY will
enable RX internal delay only.

3)    # RGMII with internal TX delay provided by the PHY, the MAC
      # should not add an TX delay in this case
      - rgmii-txid

For phy-mode="rgmii-txid", phy needs to add only TX internal delay,the MAC
should not add an TX delay in this case. But in our SoC TX internal delay is
always enabled. So this scenario can not be handled. We will return -EINVAL in
this case.


4)    # RX and TX delays are added by the MAC when required
      - rgmii

For phy-mode="rgmii", MAC needs to add both TX and RX delays. But in our SoC TX
internal delay is always enabled so no need to add TX delay. For RX I am not
sure what should we do as there is no provision of adding RX delay in MAC
currently. Should we ask PHY to add RX delay?

Andrew, Roger, Can you please comment on this.

Apart from Case 4, below code change will be able to handle all other cases.

	if(emac->phy_if == PHY_INTERFACE_MODE_RGMII_ID)
		emac->phy_if = PHY_INTERFACE_MODE_RGMII_RXID;
	if(emac->phy_if == PHY_INTERFACE_MODE_RGMII_TXID)
		return -EINVAL;

Please let me know if I am missing any other phy modes.

[1] Documentation/devicetree/bindings/net/ethernet-controller.yaml

> 	Andrew

-- 
Thanks and Regards,
Danish.
