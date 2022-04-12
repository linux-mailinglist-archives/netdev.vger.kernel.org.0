Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C2A4FDCF4
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358951AbiDLKsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356947AbiDLKpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 06:45:46 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E34F52E51;
        Tue, 12 Apr 2022 02:42:58 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 23C9ghtJ055677;
        Tue, 12 Apr 2022 04:42:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1649756563;
        bh=SyaS56JNq1J/R8rshXzLp/0sIceEISL7rGQL73Y3BK8=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=yfOD6vyCfmYXwsoN9Y+dQGT720vTjM+1ajhDpz8fOpRfik0Z25Z3fWkipiwjON6nU
         u5NzzFfftREnK0osKMyik7B+ztd4JWQfipJq5hkjy7zRzd4ls+/sxUUt+M4JCz8MSp
         Ceje9uEPi24sIN4PmueYcrR8EE7otE721WMcRNnE=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 23C9ghpF019776
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 Apr 2022 04:42:43 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 12
 Apr 2022 04:42:43 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 12 Apr 2022 04:42:42 -0500
Received: from [10.24.69.24] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 23C9gbet096869;
        Tue, 12 Apr 2022 04:42:38 -0500
Message-ID: <543b8c11-db95-29d1-29bc-ae5cbd99b2e2@ti.com>
Date:   Tue, 12 Apr 2022 15:12:37 +0530
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
        <kishon@ti.com>, Grygorii Strashko <grygorii.strashko@ti.com>,
        Roger Quadros <rogerq@kernel.org>
References: <20220406094358.7895-1-p-mohan@ti.com>
 <20220406094358.7895-14-p-mohan@ti.com> <Yk2gDGN8a2xss1UO@lunn.ch>
From:   Puranjay Mohan <p-mohan@ti.com>
In-Reply-To: <Yk2gDGN8a2xss1UO@lunn.ch>
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

On 06/04/22 19:43, Andrew Lunn wrote:
>> +static int emac_set_link_ksettings(struct net_device *ndev,
>> +				   const struct ethtool_link_ksettings *ecmd)
>> +{
>> +	struct prueth_emac *emac = netdev_priv(ndev);
>> +
>> +	if (!emac->phydev || phy_is_pseudo_fixed_link(emac->phydev))
>> +		return -EOPNOTSUPP;
>> +
>> +	return phy_ethtool_ksettings_set(emac->phydev, ecmd);
>> +}
>> +
>> +static int emac_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
>> +{
>> +	struct prueth_emac *emac = netdev_priv(ndev);
>> +
>> +	if (!emac->phydev || phy_is_pseudo_fixed_link(emac->phydev))
>> +		return -EOPNOTSUPP;
>> +
>> +	return phy_ethtool_get_eee(emac->phydev, edata);
>> +}
> 
> Why do you need the phy_is_pseudo_fixed_link() calls here?
> 
>> +/* called back by PHY layer if there is change in link state of hw port*/
>> +static void emac_adjust_link(struct net_device *ndev)
>> +{
> 
> ...
> 
>> +	if (emac->link) {
>> +		/* link ON */
>> +		netif_carrier_on(ndev);
>> +		/* reactivate the transmit queue */
>> +		netif_tx_wake_all_queues(ndev);
>> +	} else {
>> +		/* link OFF */
>> +		netif_carrier_off(ndev);
>> +		netif_tx_stop_all_queues(ndev);
>> +	}
> 
> phylib should of set the carrier for you.
> 
>> + * emac_ndo_open - EMAC device open
>> + * @ndev: network adapter device
>> + *
>> + * Called when system wants to start the interface.
>> + *
>> + * Returns 0 for a successful open, or appropriate error code
>> + */
>> +static int emac_ndo_open(struct net_device *ndev)
>> +{
>> +	struct prueth_emac *emac = netdev_priv(ndev);
>> +	int ret, i, num_data_chn = emac->tx_ch_num;
>> +	struct prueth *prueth = emac->prueth;
>> +	int slice = prueth_emac_slice(emac);
>> +	struct device *dev = prueth->dev;
>> +	int max_rx_flows;
>> +	int rx_flow;
>> +
>> +	/* clear SMEM and MSMC settings for all slices */
>> +	if (!prueth->emacs_initialized) {
>> +		memset_io(prueth->msmcram.va, 0, prueth->msmcram.size);
>> +		memset_io(prueth->shram.va, 0, ICSSG_CONFIG_OFFSET_SLICE1 * PRUETH_NUM_MACS);
>> +	}
>> +
>> +	/* set h/w MAC as user might have re-configured */
>> +	ether_addr_copy(emac->mac_addr, ndev->dev_addr);
>> +
>> +	icssg_class_set_mac_addr(prueth->miig_rt, slice, emac->mac_addr);
>> +	icssg_ft1_set_mac_addr(prueth->miig_rt, slice, emac->mac_addr);
>> +
>> +	icssg_class_default(prueth->miig_rt, slice, 0);
>> +
>> +	netif_carrier_off(ndev);
> 
> phylib should take care of this.
> 
>> +
>> +	/* Notify the stack of the actual queue counts. */
>> +	ret = netif_set_real_num_tx_queues(ndev, num_data_chn);
>> +	if (ret) {
>> +		dev_err(dev, "cannot set real number of tx queues\n");
>> +		return ret;
>> +	}
>> +
>> +	init_completion(&emac->cmd_complete);
>> +	ret = prueth_init_tx_chns(emac);
>> +	if (ret) {
>> +		dev_err(dev, "failed to init tx channel: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	max_rx_flows = PRUETH_MAX_RX_FLOWS;
>> +	ret = prueth_init_rx_chns(emac, &emac->rx_chns, "rx",
>> +				  max_rx_flows, PRUETH_MAX_RX_DESC);
>> +	if (ret) {
>> +		dev_err(dev, "failed to init rx channel: %d\n", ret);
>> +		goto cleanup_tx;
>> +	}
>> +
>> +	ret = prueth_ndev_add_tx_napi(emac);
>> +	if (ret)
>> +		goto cleanup_rx;
>> +
>> +	/* we use only the highest priority flow for now i.e. @irq[3] */
>> +	rx_flow = PRUETH_RX_FLOW_DATA;
>> +	ret = request_irq(emac->rx_chns.irq[rx_flow], prueth_rx_irq,
>> +			  IRQF_TRIGGER_HIGH, dev_name(dev), emac);
>> +	if (ret) {
>> +		dev_err(dev, "unable to request RX IRQ\n");
>> +		goto cleanup_napi;
>> +	}
>> +
>> +	/* reset and start PRU firmware */
>> +	ret = prueth_emac_start(prueth, emac);
>> +	if (ret)
>> +		goto free_rx_irq;
>> +
>> +	/* Prepare RX */
>> +	ret = prueth_prepare_rx_chan(emac, &emac->rx_chns, PRUETH_MAX_PKT_SIZE);
>> +	if (ret)
>> +		goto stop;
>> +
>> +	ret = k3_udma_glue_enable_rx_chn(emac->rx_chns.rx_chn);
>> +	if (ret)
>> +		goto reset_rx_chn;
>> +
>> +	for (i = 0; i < emac->tx_ch_num; i++) {
>> +		ret = k3_udma_glue_enable_tx_chn(emac->tx_chns[i].tx_chn);
>> +		if (ret)
>> +			goto reset_tx_chan;
>> +	}
>> +
>> +	/* Enable NAPI in Tx and Rx direction */
>> +	for (i = 0; i < emac->tx_ch_num; i++)
>> +		napi_enable(&emac->tx_chns[i].napi_tx);
>> +	napi_enable(&emac->napi_rx);
>> +
>> +	emac_phy_connect(emac);
> 
> Why don't you check the error code?
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
> 
> Do you need to do a units conversion here, or does the register
> already take pico seconds?
> 
> 	Andrew
