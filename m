Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA7D68E197
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 20:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjBGT5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 14:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjBGT5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 14:57:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251B21EBF3;
        Tue,  7 Feb 2023 11:57:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8452A6115B;
        Tue,  7 Feb 2023 19:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D52C433EF;
        Tue,  7 Feb 2023 19:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675799825;
        bh=wTSzGIVVJ5e2gYLl9ScWoBcYXsaIMyB7F/krxBcdJHk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=KsQtXmO2JqnrhchH9auqKhmeEm2Q29wvzSI9zrlFF8LnCh+Ea3gO9j2UmEScsdfD0
         PeKLtmJ3Zf0jLcgzOWhFR6cLqea9XuAGrJ5SJNpKgqO4w/dJAY6C4NFwJP0sHyXzyT
         15gvP9ILwmVT0GZfB9uU4rIi4GwPgA4gLRjiRUf08V47nFhKqrfjJvVfvI2/kGPf9W
         +eDppsuymcq8Q2sL2T6nWZ+q/yQubR3SnJMX2a6HLHbjJrn9x+Dhe7x1Y3opSiBEZk
         /y+AvWOKcR/zbEW0+zPU2D0wyoC81SmCN83NrYZYjgIlL2VRMp4l1wp4FuhYY6nQGb
         IlMLWEmkLDw9g==
Message-ID: <e8158969-08d0-1edc-24be-8c300a71adbd@kernel.org>
Date:   Tue, 7 Feb 2023 21:56:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [PATCH v4 2/2] net: ti: icssg-prueth: Add ICSSG
 ethernet driver
To:     Md Danish Anwar <a0501179@ti.com>, Andrew Lunn <andrew@lunn.ch>,
        MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, nm@ti.com,
        ssantosh@kernel.org, srk@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20230206060708.3574472-1-danishanwar@ti.com>
 <20230206060708.3574472-3-danishanwar@ti.com> <Y+ELeSQX+GWS5N2p@lunn.ch>
 <42503a0d-b434-bbcc-553d-a326af5b4918@ti.com>
Content-Language: en-US
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <42503a0d-b434-bbcc-553d-a326af5b4918@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Danish,

On 07/02/2023 17:29, Md Danish Anwar wrote:
> Hi Andrew,
> 
> On 06/02/23 19:45, Andrew Lunn wrote:
>>> +enum mii_mode {
>>> +	MII_MODE_MII = 0,
>>> +	MII_MODE_RGMII,
>>> +	MII_MODE_SGMII
>>
>> There is no mention of SGMII anywhere else. And in a couple of places,
>> the code makes the assumption that if it is not RGMII it is MII.
>>
>> Does the hardware really support SGMII?
>>
> 
> As far as I know, the hardware does support SGMII but it's not yet supported by
> the driver. I will drop the SGMII because it's not needed as of now. If in
> future support for SGMII is there, I'll add it.
> 
>>> +static int prueth_config_rgmiidelay(struct prueth *prueth,
>>> +				    struct device_node *eth_np,
>>> +				    phy_interface_t phy_if)
>>> +{
>>
>> ...
>>
>>> +	if (phy_if == PHY_INTERFACE_MODE_RGMII_ID ||
>>> +	    phy_if == PHY_INTERFACE_MODE_RGMII_TXID)
>>> +		rgmii_tx_id |= ICSSG_CTRL_RGMII_ID_MODE;
>>> +
>>> +	regmap_update_bits(ctrl_mmr, icssgctrl_reg, ICSSG_CTRL_RGMII_ID_MODE, rgmii_tx_id);

This is only applicable to some devices so you need to restrict this only
to those devices.

And only when you enable MAC TX delay you need to change emac->phy_if to PHY_INTERFACE_MODE_RGMII_RXID
if it was PHY_INTERFACE_MODE_RGMII_ID.

>>
>> Here you are adding the TX delay if the phy-mode indicates it should
>> be added.
>>
>>> +static int prueth_netdev_init(struct prueth *prueth,
>>> +			      struct device_node *eth_node)
>>> +{
>>
>>> +	ret = of_get_phy_mode(eth_node, &emac->phy_if);
>>> +	if (ret) {
>>> +		dev_err(prueth->dev, "could not get phy-mode property\n");
>>> +		goto free;
>>> +	}
>>
>>> +	ret = prueth_config_rgmiidelay(prueth, eth_node, emac->phy_if);
>>> +	if (ret)
>>> +		goto free;
>>> +
>>
>> Reading it from DT and calling the delay function.
>>
>>> +static int prueth_probe(struct platform_device *pdev)
>>> +{
>>
>>
>>> +	/* register the network devices */
>>> +	if (eth0_node) {
>>> +		ret = register_netdev(prueth->emac[PRUETH_MAC0]->ndev);
>>> +		if (ret) {
>>> +			dev_err(dev, "can't register netdev for port MII0");
>>> +			goto netdev_exit;
>>> +		}
>>> +
>>> +		prueth->registered_netdevs[PRUETH_MAC0] = prueth->emac[PRUETH_MAC0]->ndev;
>>> +
>>> +		emac_phy_connect(prueth->emac[PRUETH_MAC0]);
>>
>> And this is connecting the MAC and the PHY, where emac_phy_connect()
>> passes emac->phy_if to phylib.
>>
>> What i don't see anywhere is you changing emac->phy_if to indicate the
>> MAC has inserted the TX delay, and so the PHY should not.
>>
> 
> Yes, there is no indication whether MAC has enabled TX delay or not. I have
> changed the phy-mode in DT from "rgmii-rxid" to "rgmii-id" as per your
> suggestion in previous revision. I will keep Tx Internal delay as it is(getting
> configured in MAC) and inside emac_phy_connect() API, while calling
> of_phy_connect() instead of passing emac->phy_if (which is rgmii-id as per DT),
> I will pass PHY_INTERFACE_MODE_RGMII_RXID. This will make sure that phy only
> enables Rx delay and keep the existing approach of keepping Tx delay in MAC.
> 
> Currently, in emac_phy_connect() API,
> 
> 	/* connect PHY */
> 	ndev->phydev = of_phy_connect(emac->ndev, emac->phy_node,
> 				      &emac_adjust_link, 0,
> 				      emac->phy_if);
> I will change it to,
> 
> 	/* connect PHY */
> 	ndev->phydev = of_phy_connect(emac->ndev, emac->phy_node,
> 				      &emac_adjust_link, 0,
> 				      PHY_INTERFACE_MODE_RGMII_RXID);
> 
> Let me know if this looks OK.

No, this is not OK.

Please keep this as emac->phy_if.

In prueth_config_rgmiidelay(), you can change emac->phy_if to
PHY_INTERFACE_MODE_RGMII_RXID only if it was RGMII mode
*and* MAC TX delay was enabled.

cheers,
-roger
