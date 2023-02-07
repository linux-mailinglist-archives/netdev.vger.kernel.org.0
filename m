Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64F968DD0B
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 16:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbjBGPaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 10:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjBGPaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 10:30:24 -0500
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863CE193E1;
        Tue,  7 Feb 2023 07:30:22 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 317FTgNt026332;
        Tue, 7 Feb 2023 09:29:42 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1675783782;
        bh=xS7YNRkhl1m6asFWjaNFQyM3xJs2jTqptFLnUMJdIFc=;
        h=Date:From:Subject:To:CC:References:In-Reply-To;
        b=sdVIeo++trtBot4DQaXO8HP4sX/V/yemDVwd00x/b0Ie904eOnmhoYWV1zoH62YWk
         YP8wbi4qTiXgVTyOjDwe08A2E1WkOAHSY3jFDiRVkJ6x2mLWIXY5+OmX0siiD4JKVf
         7Lwn/M6wcG+c5s0T0MX+2nq9Gy+7Bh1T+6CIkI0A=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 317FTfe8077353
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 7 Feb 2023 09:29:41 -0600
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 7
 Feb 2023 09:29:41 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 7 Feb 2023 09:29:41 -0600
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 317FTZv8058629;
        Tue, 7 Feb 2023 09:29:36 -0600
Message-ID: <42503a0d-b434-bbcc-553d-a326af5b4918@ti.com>
Date:   Tue, 7 Feb 2023 20:59:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Md Danish Anwar <a0501179@ti.com>
Subject: Re: [EXTERNAL] Re: [PATCH v4 2/2] net: ti: icssg-prueth: Add ICSSG
 ethernet driver
To:     Andrew Lunn <andrew@lunn.ch>, MD Danish Anwar <danishanwar@ti.com>
CC:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
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
Content-Language: en-US
Organization: Texas Instruments
In-Reply-To: <Y+ELeSQX+GWS5N2p@lunn.ch>
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

On 06/02/23 19:45, Andrew Lunn wrote:
>> +enum mii_mode {
>> +	MII_MODE_MII = 0,
>> +	MII_MODE_RGMII,
>> +	MII_MODE_SGMII
> 
> There is no mention of SGMII anywhere else. And in a couple of places,
> the code makes the assumption that if it is not RGMII it is MII.
> 
> Does the hardware really support SGMII?
> 

As far as I know, the hardware does support SGMII but it's not yet supported by
the driver. I will drop the SGMII because it's not needed as of now. If in
future support for SGMII is there, I'll add it.

>> +static int prueth_config_rgmiidelay(struct prueth *prueth,
>> +				    struct device_node *eth_np,
>> +				    phy_interface_t phy_if)
>> +{
> 
> ...
> 
>> +	if (phy_if == PHY_INTERFACE_MODE_RGMII_ID ||
>> +	    phy_if == PHY_INTERFACE_MODE_RGMII_TXID)
>> +		rgmii_tx_id |= ICSSG_CTRL_RGMII_ID_MODE;
>> +
>> +	regmap_update_bits(ctrl_mmr, icssgctrl_reg, ICSSG_CTRL_RGMII_ID_MODE, rgmii_tx_id);
> 
> Here you are adding the TX delay if the phy-mode indicates it should
> be added.
> 
>> +static int prueth_netdev_init(struct prueth *prueth,
>> +			      struct device_node *eth_node)
>> +{
> 
>> +	ret = of_get_phy_mode(eth_node, &emac->phy_if);
>> +	if (ret) {
>> +		dev_err(prueth->dev, "could not get phy-mode property\n");
>> +		goto free;
>> +	}
> 
>> +	ret = prueth_config_rgmiidelay(prueth, eth_node, emac->phy_if);
>> +	if (ret)
>> +		goto free;
>> +
> 
> Reading it from DT and calling the delay function.
> 
>> +static int prueth_probe(struct platform_device *pdev)
>> +{
> 
> 
>> +	/* register the network devices */
>> +	if (eth0_node) {
>> +		ret = register_netdev(prueth->emac[PRUETH_MAC0]->ndev);
>> +		if (ret) {
>> +			dev_err(dev, "can't register netdev for port MII0");
>> +			goto netdev_exit;
>> +		}
>> +
>> +		prueth->registered_netdevs[PRUETH_MAC0] = prueth->emac[PRUETH_MAC0]->ndev;
>> +
>> +		emac_phy_connect(prueth->emac[PRUETH_MAC0]);
> 
> And this is connecting the MAC and the PHY, where emac_phy_connect()
> passes emac->phy_if to phylib.
> 
> What i don't see anywhere is you changing emac->phy_if to indicate the
> MAC has inserted the TX delay, and so the PHY should not.
> 

Yes, there is no indication whether MAC has enabled TX delay or not. I have
changed the phy-mode in DT from "rgmii-rxid" to "rgmii-id" as per your
suggestion in previous revision. I will keep Tx Internal delay as it is(getting
configured in MAC) and inside emac_phy_connect() API, while calling
of_phy_connect() instead of passing emac->phy_if (which is rgmii-id as per DT),
I will pass PHY_INTERFACE_MODE_RGMII_RXID. This will make sure that phy only
enables Rx delay and keep the existing approach of keepping Tx delay in MAC.

Currently, in emac_phy_connect() API,

	/* connect PHY */
	ndev->phydev = of_phy_connect(emac->ndev, emac->phy_node,
				      &emac_adjust_link, 0,
				      emac->phy_if);
I will change it to,

	/* connect PHY */
	ndev->phydev = of_phy_connect(emac->ndev, emac->phy_node,
				      &emac_adjust_link, 0,
				      PHY_INTERFACE_MODE_RGMII_RXID);

Let me know if this looks OK.

>     Andrew
> 

-- 
Thanks and Regards,
Danish.
