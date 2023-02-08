Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601A468E947
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 08:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjBHHq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 02:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbjBHHqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 02:46:55 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AEFCC37;
        Tue,  7 Feb 2023 23:46:52 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3187kLhI110308;
        Wed, 8 Feb 2023 01:46:21 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1675842381;
        bh=l3sDaWLrxFOhs3q+eL4hlccIhI/l0WNUeqiWmr85ktQ=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=iBzDbk5wjcoMsf99jcUZ6WQvz8rk84eiIKyGG+j6vVi9aCkP54LmMCSYQnxv72xuo
         Y8KfpIcCNHwGBgIuI9vM55Ox109aursQb7/7wOgIa/JwzCP0+ag1j+eHLaztzpFnhx
         rkt+H/Vhwkf7PQy4VoFQpVj7tBf35vwxx5i3qJ0k=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3187kLSj023348
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 8 Feb 2023 01:46:21 -0600
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 8
 Feb 2023 01:46:20 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 8 Feb 2023 01:46:21 -0600
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3187kFgZ114602;
        Wed, 8 Feb 2023 01:46:15 -0600
Message-ID: <4438fb71-7e20-6532-a858-b688bc64e826@ti.com>
Date:   Wed, 8 Feb 2023 13:16:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH v4 2/2] net: ti:
 icssg-prueth: Add ICSSG ethernet driver
To:     Roger Quadros <rogerq@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        MD Danish Anwar <danishanwar@ti.com>
CC:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
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
Content-Language: en-US
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <e8158969-08d0-1edc-24be-8c300a71adbd@kernel.org>
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

Hi Roger and Andrew,

On 08/02/23 01:26, Roger Quadros wrote:
> Danish,
> 
> On 07/02/2023 17:29, Md Danish Anwar wrote:
>> Hi Andrew,
>>
>> On 06/02/23 19:45, Andrew Lunn wrote:
>>>> +enum mii_mode {
>>>> +	MII_MODE_MII = 0,
>>>> +	MII_MODE_RGMII,
>>>> +	MII_MODE_SGMII
>>>
>>> There is no mention of SGMII anywhere else. And in a couple of places,
>>> the code makes the assumption that if it is not RGMII it is MII.
>>>
>>> Does the hardware really support SGMII?
>>>
>>
>> As far as I know, the hardware does support SGMII but it's not yet supported by
>> the driver. I will drop the SGMII because it's not needed as of now. If in
>> future support for SGMII is there, I'll add it.
>>
>>>> +static int prueth_config_rgmiidelay(struct prueth *prueth,
>>>> +				    struct device_node *eth_np,
>>>> +				    phy_interface_t phy_if)
>>>> +{
>>>
>>> ...
>>>
>>>> +	if (phy_if == PHY_INTERFACE_MODE_RGMII_ID ||
>>>> +	    phy_if == PHY_INTERFACE_MODE_RGMII_TXID)
>>>> +		rgmii_tx_id |= ICSSG_CTRL_RGMII_ID_MODE;
>>>> +
>>>> +	regmap_update_bits(ctrl_mmr, icssgctrl_reg, ICSSG_CTRL_RGMII_ID_MODE, rgmii_tx_id);
> 
> This is only applicable to some devices so you need to restrict this only
> to those devices.
> 

Currently ICSSG driver is getting upstreamed for AM65 SR2.0 device, so I don't
think there is any need for any device related restriction. Once support for
other devices are enabled for upstream, we can modify this accordingly.

> And only when you enable MAC TX delay you need to change emac->phy_if to PHY_INTERFACE_MODE_RGMII_RXID
> if it was PHY_INTERFACE_MODE_RGMII_ID.
> 
>>>
>>> Here you are adding the TX delay if the phy-mode indicates it should
>>> be added.
>>>
>>>> +static int prueth_netdev_init(struct prueth *prueth,
>>>> +			      struct device_node *eth_node)
>>>> +{
>>>
>>>> +	ret = of_get_phy_mode(eth_node, &emac->phy_if);
>>>> +	if (ret) {
>>>> +		dev_err(prueth->dev, "could not get phy-mode property\n");
>>>> +		goto free;
>>>> +	}
>>>
>>>> +	ret = prueth_config_rgmiidelay(prueth, eth_node, emac->phy_if);
>>>> +	if (ret)
>>>> +		goto free;
>>>> +
>>>
>>> Reading it from DT and calling the delay function.
>>>
>>>> +static int prueth_probe(struct platform_device *pdev)
>>>> +{
>>>
>>>
>>>> +	/* register the network devices */
>>>> +	if (eth0_node) {
>>>> +		ret = register_netdev(prueth->emac[PRUETH_MAC0]->ndev);
>>>> +		if (ret) {
>>>> +			dev_err(dev, "can't register netdev for port MII0");
>>>> +			goto netdev_exit;
>>>> +		}
>>>> +
>>>> +		prueth->registered_netdevs[PRUETH_MAC0] = prueth->emac[PRUETH_MAC0]->ndev;
>>>> +
>>>> +		emac_phy_connect(prueth->emac[PRUETH_MAC0]);
>>>
>>> And this is connecting the MAC and the PHY, where emac_phy_connect()
>>> passes emac->phy_if to phylib.
>>>
>>> What i don't see anywhere is you changing emac->phy_if to indicate the
>>> MAC has inserted the TX delay, and so the PHY should not.
>>>
>>
>> Yes, there is no indication whether MAC has enabled TX delay or not. I have
>> changed the phy-mode in DT from "rgmii-rxid" to "rgmii-id" as per your
>> suggestion in previous revision. I will keep Tx Internal delay as it is(getting
>> configured in MAC) and inside emac_phy_connect() API, while calling
>> of_phy_connect() instead of passing emac->phy_if (which is rgmii-id as per DT),
>> I will pass PHY_INTERFACE_MODE_RGMII_RXID. This will make sure that phy only
>> enables Rx delay and keep the existing approach of keepping Tx delay in MAC.
>>
>> Currently, in emac_phy_connect() API,
>>
>> 	/* connect PHY */
>> 	ndev->phydev = of_phy_connect(emac->ndev, emac->phy_node,
>> 				      &emac_adjust_link, 0,
>> 				      emac->phy_if);
>> I will change it to,
>>
>> 	/* connect PHY */
>> 	ndev->phydev = of_phy_connect(emac->ndev, emac->phy_node,
>> 				      &emac_adjust_link, 0,
>> 				      PHY_INTERFACE_MODE_RGMII_RXID);
>>
>> Let me know if this looks OK.
> 
> No, this is not OK.
> 
> Please keep this as emac->phy_if.
> 
> In prueth_config_rgmiidelay(), you can change emac->phy_if to
> PHY_INTERFACE_MODE_RGMII_RXID only if it was RGMII mode
> *and* MAC TX delay was enabled.
> 

I checked the latest Technical Reference Manual [1] (Section 5.1.3.4.49, Table
5-624) for AM65 Silicon Revision 2.0.

Below is the description in Table 5-624

BIT	    : 24
Field	    : RGMII0_ID_MODE
Type	    : R/W
Reset	    : 0h
Description : Controls the PRU_ICSSG0 RGMII0 port internal transmit delay
	      0h - Internal transmit delay is enabled
	      1h - Reserved

The TX internal delay is always enabled and couldn't be disabled as 1h is
reserved. So hardware support for disabling TX internal delay is not there.

As, TX internal delay is always there, there is no need to enable it in MAC or
PHY. So no need of API prueth_config_rgmiidelay().

My approach to handle delay would be as below.

*) Keep phy-mode = "rgmii-id" in DT as asked by Andrew.
*) Let TX internal delay enabled in Hardware.
*) Let PHY configure RX internal delay.
*) Remove prueth_config_rgmiidelay() API is there is no use of this. TX
Internal delay is always enabled.
*) Instead of calling prueth_config_rgmiidelay() API in prueth_netdev_init()
API, add below if condition.

	if(emac->phy_if == PHY_INTERFACE_MODE_RGMII_ID)
		emac->phy_if == PHY_INTERFACE_MODE_RGMII_RXID

This will check if phy-mode is "rgmii-id", then change the phy-mode to
"rgmii-rxid". The same emac->phy_if is passed to emac_phy_connect which passes
emac->phy_if to phylib. So that PHY will only enable RX internal delay and TX
internal delay is always enabled by default(in Hardware)

As of now ICSSG driver is getting upstreamed with support for only AM65 SR2.0,
In future when ICSSG driver starts supporting other devices, we can modify this
condition to something like below

	if(device_is_AM65 && emac->phy_if == PHY_INTERFACE_MODE_RGMII_ID)
		emac->phy_if == PHY_INTERFACE_MODE_RGMII_RXID

So that, for other devices, phy-mode should remain as it is, as other devices
don't have hardware restriction.

Please let me know if this is the right approach.

[1]
https://www.ti.com/lit/ug/spruid7e/spruid7e.pdf?ts=1675841023830&ref_url=https%253A%252F%252Fwww.ti.com%252Fproduct%252FAM6548#%5B%7B%22num%22%3A1706%2C%22gen%22%3A0%7D%2C%7B%22name%22%3A%22XYZ%22%7D%2C0%2C717.9%2C0%5D

> cheers,
> -roger
-- 
Thanks and Regards,
Danish.
