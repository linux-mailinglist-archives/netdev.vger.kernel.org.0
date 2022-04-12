Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DDA4FDCFB
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358564AbiDLKtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357289AbiDLKpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 06:45:55 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE462F386;
        Tue, 12 Apr 2022 02:45:48 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 23C9jUKe067665;
        Tue, 12 Apr 2022 04:45:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1649756730;
        bh=VDZc9Kk2A5AD9uS5jLQGDKo7YqCKDe0p6HsXL4ysfhI=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=iv8hwZ5BypRzsvkov7dNiU9fES4zKD4AeB2e2tT3+IZ2IG/soRzihAEobXxhPnn1w
         oKcYmdxfOt35wXl3f2vA2v8XTwsSrdbvJSowEbnP0I2nK4fFWEuy/DXYMghvNxi/Q4
         t9indP3WDNhlqvzmwclK8zlA/i2MSfpAqVA0PYuQ=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 23C9jUhf021475
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 Apr 2022 04:45:30 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 12
 Apr 2022 04:45:29 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 12 Apr 2022 04:45:29 -0500
Received: from [10.24.69.24] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 23C9jOXs106716;
        Tue, 12 Apr 2022 04:45:24 -0500
Message-ID: <468d4d9b-44b4-2894-2a75-4caab1e72147@ti.com>
Date:   Tue, 12 Apr 2022 15:15:23 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC 13/13] net: ti: icssg-prueth: Add ICSSG ethernet driver
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>, <bjorn.andersson@linaro.org>,
        <mathieu.poirier@linaro.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <linux-remoteproc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <nm@ti.com>, <ssantosh@kernel.org>, <s-anna@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>, <vigneshr@ti.com>,
        <kishon@ti.com>, Roger Quadros <rogerq@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
References: <20220406094358.7895-1-p-mohan@ti.com>
 <20220406094358.7895-14-p-mohan@ti.com> <Yk3d/cC36fhNmfY2@lunn.ch>
From:   Puranjay Mohan <p-mohan@ti.com>
In-Reply-To: <Yk3d/cC36fhNmfY2@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Roger, Grygorii

On 07/04/22 00:07, Andrew Lunn wrote:
>> +static int emac_phy_connect(struct prueth_emac *emac)
>> +{
>> +	struct prueth *prueth = emac->prueth;
>> +
>> +	/* connect PHY */
>> +	emac->phydev = of_phy_connect(emac->ndev, emac->phy_node,
>> +				      &emac_adjust_link, 0, emac->phy_if);
> 
>> +static int prueth_config_rgmiidelay(struct prueth *prueth,
>> +				    struct device_node *eth_np,
>> +				    phy_interface_t phy_if)
>> +{
>> +	struct device *dev = prueth->dev;
>> +	struct regmap *ctrl_mmr;
>> +	u32 rgmii_tx_id = 0;
>> +	u32 icssgctrl_reg;
>> +
>> +	if (!phy_interface_mode_is_rgmii(phy_if))
>> +		return 0;
>> +
>> +	ctrl_mmr = syscon_regmap_lookup_by_phandle(eth_np, "ti,syscon-rgmii-delay");
>> +	if (IS_ERR(ctrl_mmr)) {
>> +		dev_err(dev, "couldn't get ti,syscon-rgmii-delay\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (of_property_read_u32_index(eth_np, "ti,syscon-rgmii-delay", 1,
>> +				       &icssgctrl_reg)) {
>> +		dev_err(dev, "couldn't get ti,rgmii-delay reg. offset\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (phy_if == PHY_INTERFACE_MODE_RGMII_ID ||
>> +	    phy_if == PHY_INTERFACE_MODE_RGMII_TXID)
>> +		rgmii_tx_id |= ICSSG_CTRL_RGMII_ID_MODE;
>> +
>> +	regmap_update_bits(ctrl_mmr, icssgctrl_reg, ICSSG_CTRL_RGMII_ID_MODE, rgmii_tx_id);
>> +
>> +	return 0;
>> +}
>>
> 
> O.K, so this does not do what i initially thought it was doing. I was
> thinking it was to fine tune the delay, ti,syscon-rgmii-delay would be
> a small pico second value to allow the 2ns delay to be tuned to the
> board.
> 
> But now i think this is actually inserting the full 2ns delay?
> 
> The problem is, you also pass phy_if to of_phy_connect() so the PHY
> will also insert the delay if requested. So you end up with double
> delays for rgmii_id and rgmii_txid.
> 
> The general recommendation is that the PHY inserts the delay, based on
> phy-mode. The MAC does not add a delay, so i suggest you always write
> 0 here, just to ensure the system is in a deterministic state, and the
> bootloader and not being messing around with things.
> 
> 	   Andrew
