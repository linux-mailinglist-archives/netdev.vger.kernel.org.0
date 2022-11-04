Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818526193DE
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 10:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiKDJvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 05:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiKDJvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 05:51:19 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E27C6252;
        Fri,  4 Nov 2022 02:51:15 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2A49osJp086769;
        Fri, 4 Nov 2022 04:50:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1667555454;
        bh=g5gL/7SHAIZHQaB/oisqr6hNvtF+ltJbAqTWbAX6BmA=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=VuqXddvFP0y+fZ4NBWUiiRZsKBTzmCasdA08JxqjIYjyuV+EcciRR6A42RjQOx2RV
         ROo3tFw4meYUDipnlyoLhV+/orTfzpw3sIM+n2hhLKxsWAFpoPmslCEAfHBowu4zRR
         KngetkfnOmu+zyviNKKQg/YjARefP25hKR4q4xq4=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2A49osHF006295
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 4 Nov 2022 04:50:54 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Fri, 4 Nov
 2022 04:50:53 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Fri, 4 Nov 2022 04:50:53 -0500
Received: from [10.24.69.114] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2A49omHl005261;
        Fri, 4 Nov 2022 04:50:49 -0500
Message-ID: <ab434dee-3353-7e46-5fd3-e68b74925a2d@ti.com>
Date:   Fri, 4 Nov 2022 15:20:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
Content-Language: en-US
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
CC:     <afd@ti.com>, <andrew@lunn.ch>, <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, <edumazet@google.com>,
        <krzysztof.kozlowski+dt@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <nm@ti.com>, <robh+dt@kernel.org>, <rogerq@kernel.org>,
        <s-anna@ti.com>, <ssantosh@kernel.org>, <vigneshr@ti.com>
References: <20220531095108.21757-1-p-mohan@ti.com>
 <20220531095108.21757-3-p-mohan@ti.com>
 <3874cac9-cf3c-aa31-ecba-e2ae33935286@wanadoo.fr>
From:   Md Danish Anwar <a0501179@ti.com>
In-Reply-To: <3874cac9-cf3c-aa31-ecba-e2ae33935286@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/06/22 21:54, Christophe JAILLET wrote:
> Hi,
> 
> Just a few comments below, for what they worth.
> 
> Le 31/05/2022 à 11:51, Puranjay Mohan a écrit :
>> From: Roger Quadros <rogerq-l0cyMroinI0@public.gmane.org>
>>
>> This is the Ethernet driver for TI AM654 Silicon rev. 2
>> with the ICSSG PRU Sub-system running dual-EMAC firmware.
>>
> 
> [...]
> 
>> +static int prueth_netdev_init(struct prueth *prueth,
>> +                  struct device_node *eth_node)
>> +{
>> +    int ret, num_tx_chn = PRUETH_MAX_TX_QUEUES;
>> +    struct prueth_emac *emac;
>> +    struct net_device *ndev;
>> +    enum prueth_port port;
>> +    enum prueth_mac mac;
>> +
>> +    port = prueth_node_port(eth_node);
>> +    if (port < 0)
>> +        return -EINVAL;
>> +
>> +    mac = prueth_node_mac(eth_node);
>> +    if (mac < 0)
>> +        return -EINVAL;
>> +
>> +    ndev = alloc_etherdev_mq(sizeof(*emac), num_tx_chn);
>> +    if (!ndev)
>> +        return -ENOMEM;
>> +
>> +    emac = netdev_priv(ndev);
>> +    prueth->emac[mac] = emac;
>> +    emac->prueth = prueth;
>> +    emac->ndev = ndev;
>> +    emac->port_id = port;
>> +    emac->cmd_wq = create_singlethread_workqueue("icssg_cmd_wq");
>> +    if (!emac->cmd_wq) {
>> +        ret = -ENOMEM;
>> +        goto free_ndev;
>> +    }
>> +    INIT_WORK(&emac->rx_mode_work, emac_ndo_set_rx_mode_work);
>> +
>> +    ret = pruss_request_mem_region(prueth->pruss,
>> +                       port == PRUETH_PORT_MII0 ?
>> +                       PRUSS_MEM_DRAM0 : PRUSS_MEM_DRAM1,
>> +                       &emac->dram);
>> +    if (ret) {
>> +        dev_err(prueth->dev, "unable to get DRAM: %d\n", ret);
>> +        return -ENOMEM;
> 
> goto free_wq; ?
> 

I'll add it.

>> +    }
>> +
>> +    emac->tx_ch_num = 1;
>> +
>> +    SET_NETDEV_DEV(ndev, prueth->dev);
>> +    spin_lock_init(&emac->lock);
>> +    mutex_init(&emac->cmd_lock);
>> +
>> +    emac->phy_node = of_parse_phandle(eth_node, "phy-handle", 0);
>> +    if (!emac->phy_node && !of_phy_is_fixed_link(eth_node)) {
>> +        dev_err(prueth->dev, "couldn't find phy-handle\n");
>> +        ret = -ENODEV;
>> +        goto free;
>> +    } else if (of_phy_is_fixed_link(eth_node)) {
>> +        ret = of_phy_register_fixed_link(eth_node);
>> +        if (ret) {
>> +            ret = dev_err_probe(prueth->dev, ret,
>> +                        "failed to register fixed-link phy\n");
>> +            goto free;
>> +        }
>> +
>> +        emac->phy_node = eth_node;
>> +    }
>> +
>> +    ret = of_get_phy_mode(eth_node, &emac->phy_if);
>> +    if (ret) {
>> +        dev_err(prueth->dev, "could not get phy-mode property\n");
>> +        goto free;
>> +    }
>> +
>> +    if (emac->phy_if != PHY_INTERFACE_MODE_MII &&
>> +        !phy_interface_mode_is_rgmii(emac->phy_if)) {
>> +        dev_err(prueth->dev, "PHY mode unsupported %s\n",
>> phy_modes(emac->phy_if));
>> +        goto free;
>> +    }
>> +
>> +    ret = prueth_config_rgmiidelay(prueth, eth_node, emac->phy_if);
>> +    if (ret)
>> +        goto free;
>> +
>> +    /* get mac address from DT and set private and netdev addr */
>> +    ret = of_get_ethdev_address(eth_node, ndev);
>> +    if (!is_valid_ether_addr(ndev->dev_addr)) {
>> +        eth_hw_addr_random(ndev);
>> +        dev_warn(prueth->dev, "port %d: using random MAC addr: %pM\n",
>> +             port, ndev->dev_addr);
>> +    }
>> +    ether_addr_copy(emac->mac_addr, ndev->dev_addr);
>> +
>> +    ndev->netdev_ops = &emac_netdev_ops;
>> +    ndev->ethtool_ops = &icssg_ethtool_ops;
>> +    ndev->hw_features = NETIF_F_SG;
>> +    ndev->features = ndev->hw_features;
>> +
>> +    netif_napi_add(ndev, &emac->napi_rx,
>> +               emac_napi_rx_poll, NAPI_POLL_WEIGHT);
>> +
>> +    return 0;
>> +
>> +free:
>> +    pruss_release_mem_region(prueth->pruss, &emac->dram);
> 
> free_wq:
> 

From what I understand, the labels would look like this.

free:
	pruss_release_mem_region(prueth->pruss, &emac->dram);
	destroy_workqueue(emac->cmd_wq);
free_wq:
	destroy_workqueue(emac->cmd_wq);

>> +    destroy_workqueue(emac->cmd_wq);
>> +free_ndev:
>> +    free_netdev(ndev);
>> +    prueth->emac[mac] = NULL;
>> +
>> +    return ret;
>> +}
>> +
>> +static void prueth_netdev_exit(struct prueth *prueth,
>> +                   struct device_node *eth_node)
>> +{
>> +    struct prueth_emac *emac;
>> +    enum prueth_mac mac;
>> +
>> +    mac = prueth_node_mac(eth_node);
>> +    if (mac < 0)
>> +        return;
>> +
>> +    emac = prueth->emac[mac];
>> +    if (!emac)
>> +        return;
>> +
>> +    if (of_phy_is_fixed_link(emac->phy_node))
>> +        of_phy_deregister_fixed_link(emac->phy_node);
>> +
>> +    netif_napi_del(&emac->napi_rx);
>> +
>> +    pruss_release_mem_region(prueth->pruss, &emac->dram);
>> +    destroy_workqueue(emac->cmd_wq);
>> +    free_netdev(emac->ndev);
>> +    prueth->emac[mac] = NULL;
>> +}
>> +
>> +static int prueth_get_cores(struct prueth *prueth, int slice)
>> +{
>> +    enum pruss_pru_id pruss_id;
>> +    struct device *dev = prueth->dev;
>> +    struct device_node *np = dev->of_node;
>> +    int idx = -1, ret;
>> +
>> +    switch (slice) {
>> +    case ICSS_SLICE0:
>> +        idx = 0;
>> +        break;
>> +    case ICSS_SLICE1:
>> +        idx = 3;
>> +        break;
>> +    default:
>> +        return -EINVAL;
>> +    }
>> +
>> +    prueth->pru[slice] = pru_rproc_get(np, idx, &pruss_id);
>> +    if (IS_ERR(prueth->pru[slice])) {
>> +        ret = PTR_ERR(prueth->pru[slice]);
>> +        prueth->pru[slice] = NULL;
>> +        if (ret != -EPROBE_DEFER)
>> +            dev_err(dev, "unable to get PRU%d: %d\n", slice, ret);
> 
> return dev_err_probe()?
> 

Sure I'll return dev_err_probe() instead of the above.

I'll add below line
return dev_err_probe(dev,ret,"unable to get PRU%d\n", slice);

>> +        return ret;
>> +    }
>> +    prueth->pru_id[slice] = pruss_id;
>> +
>> +    idx++;
>> +    prueth->rtu[slice] = pru_rproc_get(np, idx, NULL);
>> +    if (IS_ERR(prueth->rtu[slice])) {
>> +        ret = PTR_ERR(prueth->rtu[slice]);
>> +        prueth->rtu[slice] = NULL;
>> +        if (ret != -EPROBE_DEFER)
>> +            dev_err(dev, "unable to get RTU%d: %d\n", slice, ret);
> 
> Same.
> 

Sure, I'll do that.

>> +        return ret;
>> +    }
>> +
>> +    idx++;
>> +    prueth->txpru[slice] = pru_rproc_get(np, idx, NULL);
>> +    if (IS_ERR(prueth->txpru[slice])) {
>> +        ret = PTR_ERR(prueth->txpru[slice]);
>> +        prueth->txpru[slice] = NULL;
>> +        if (ret != -EPROBE_DEFER)
>> +            dev_err(dev, "unable to get TX_PRU%d: %d\n",
>> +                slice, ret);
> 
> Same.
> 

Sure, I'll do that.

>> +        return ret;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static void prueth_put_cores(struct prueth *prueth, int slice)
>> +{
>> +    if (prueth->txpru[slice])
>> +        pru_rproc_put(prueth->txpru[slice]);
>> +
>> +    if (prueth->rtu[slice])
>> +        pru_rproc_put(prueth->rtu[slice]);
>> +
>> +    if (prueth->pru[slice])
>> +        pru_rproc_put(prueth->pru[slice]);
>> +}
>> +
>> +static const struct of_device_id prueth_dt_match[];
>> +
>> +static int prueth_probe(struct platform_device *pdev)
>> +{
>> +    struct prueth *prueth;
>> +    struct device *dev = &pdev->dev;
>> +    struct device_node *np = dev->of_node;
>> +    struct device_node *eth_ports_node;
>> +    struct device_node *eth_node;
>> +    struct device_node *eth0_node, *eth1_node;
>> +    const struct of_device_id *match;
>> +    struct pruss *pruss;
>> +    int i, ret;
>> +    u32 msmc_ram_size;
>> +    struct genpool_data_align gp_data = {
>> +        .align = SZ_64K,
>> +    };
>> +
>> +    match = of_match_device(prueth_dt_match, dev);
>> +    if (!match)
>> +        return -ENODEV;
>> +
>> +    prueth = devm_kzalloc(dev, sizeof(*prueth), GFP_KERNEL);
>> +    if (!prueth)
>> +        return -ENOMEM;
>> +
>> +    dev_set_drvdata(dev, prueth);
>> +    prueth->pdev = pdev;
>> +    prueth->pdata = *(const struct prueth_pdata *)match->data;
>> +
>> +    prueth->dev = dev;
>> +    eth_ports_node = of_get_child_by_name(np, "ethernet-ports");
>> +    if (!eth_ports_node)
>> +        return -ENOENT;
>> +
>> +    for_each_child_of_node(eth_ports_node, eth_node) {
>> +        u32 reg;
>> +
>> +        if (strcmp(eth_node->name, "port"))
>> +            continue;
>> +        ret = of_property_read_u32(eth_node, "reg", &reg);
>> +        if (ret < 0) {
>> +            dev_err(dev, "%pOF error reading port_id %d\n",
>> +                eth_node, ret);
>> +        }
>> +
>> +        of_node_get(eth_node);
>> +
>> +        if (reg == 0)
>> +            eth0_node = eth_node;
>> +        else if (reg == 1)
>> +            eth1_node = eth_node;
>> +        else
>> +            dev_err(dev, "port reg should be 0 or 1\n");
>> +    }
>> +
>> +    of_node_put(eth_ports_node);
>> +
>> +    /* At least one node must be present and available else we fail */
>> +    if (!eth0_node && !eth1_node) {
>> +        dev_err(dev, "neither port0 nor port1 node available\n");
>> +        return -ENODEV;
>> +    }
>> +
>> +    if (eth0_node == eth1_node) {
>> +        dev_err(dev, "port0 and port1 can't have same reg\n");
>> +        of_node_put(eth0_node);
>> +        return -ENODEV;
>> +    }
>> +
>> +    prueth->eth_node[PRUETH_MAC0] = eth0_node;
>> +    prueth->eth_node[PRUETH_MAC1] = eth1_node;
>> +
>> +    prueth->miig_rt = syscon_regmap_lookup_by_phandle(np, "ti,mii-g-rt");
>> +    if (IS_ERR(prueth->miig_rt)) {
>> +        dev_err(dev, "couldn't get ti,mii-g-rt syscon regmap\n");
>> +        return -ENODEV;
>> +    }
>> +
>> +    prueth->mii_rt = syscon_regmap_lookup_by_phandle(np, "ti,mii-rt");
>> +    if (IS_ERR(prueth->mii_rt)) {
>> +        dev_err(dev, "couldn't get ti,mii-rt syscon regmap\n");
>> +        return -ENODEV;
>> +    }
>> +
>> +    if (eth0_node) {
>> +        ret = prueth_get_cores(prueth, ICSS_SLICE0);
>> +        if (ret)
>> +            goto put_cores;
>> +    }
>> +
>> +    if (eth1_node) {
>> +        ret = prueth_get_cores(prueth, ICSS_SLICE1);
>> +        if (ret)
>> +            goto put_cores;
>> +    }
>> +
>> +    pruss = pruss_get(eth0_node ?
>> +              prueth->pru[ICSS_SLICE0] : prueth->pru[ICSS_SLICE1]);
>> +    if (IS_ERR(pruss)) {
>> +        ret = PTR_ERR(pruss);
>> +        dev_err(dev, "unable to get pruss handle\n");
>> +        goto put_cores;
>> +    }
>> +
>> +    prueth->pruss = pruss;
>> +
>> +    ret = pruss_request_mem_region(pruss, PRUSS_MEM_SHRD_RAM2,
>> +                       &prueth->shram);
>> +    if (ret) {
>> +        dev_err(dev, "unable to get PRUSS SHRD RAM2: %d\n", ret);
>> +        goto put_mem;
> 
> Is it safe to call pruss_release_mem_region() if pruss_request_mem_region() has
> failed?
> 

There is no need to call pruss_release_mem_region() if
pruss_request_mem_region() has failed.

The label put_mem, calls pruss_release_mem_region() and pruss_put().

Here instead of going to label and calling both the functions, I will just call
pruss_put() function.

So the if condition would be something like this.

if (ret) {
    dev_err(dev, "unable to get PRUSS SHRD RAM2: %d\n", ret);
    pruss_put(prueth->pruss);
}

> The other place where it is called it is not done the same way.
> 

>> +    }
>> +
>> +    prueth->sram_pool = of_gen_pool_get(np, "sram", 0);
>> +    if (!prueth->sram_pool) {
>> +        dev_err(dev, "unable to get SRAM pool\n");
>> +        ret = -ENODEV;
>> +
>> +        goto put_mem;
>> +    }
>> +
>> +    msmc_ram_size = MSMC_RAM_SIZE;
>> +
>> +    /* NOTE: FW bug needs buffer base to be 64KB aligned */
>> +    prueth->msmcram.va =
>> +        (void __iomem *)gen_pool_alloc_algo(prueth->sram_pool,
>> +                            msmc_ram_size,
>> +                            gen_pool_first_fit_align,
>> +                            &gp_data);
>> +
>> +    if (!prueth->msmcram.va) {
>> +        ret = -ENOMEM;
>> +        dev_err(dev, "unable to allocate MSMC resource\n");
>> +        goto put_mem;
>> +    }
>> +    prueth->msmcram.pa = gen_pool_virt_to_phys(prueth->sram_pool,
>> +                           (unsigned long)prueth->msmcram.va);
>> +    prueth->msmcram.size = msmc_ram_size;
>> +    memset(prueth->msmcram.va, 0, msmc_ram_size);
>> +    dev_dbg(dev, "sram: pa %llx va %p size %zx\n", prueth->msmcram.pa,
>> +        prueth->msmcram.va, prueth->msmcram.size);
>> +
>> +    /* setup netdev interfaces */
>> +    if (eth0_node) {
>> +        ret = prueth_netdev_init(prueth, eth0_node);
>> +        if (ret) {
>> +            if (ret != -EPROBE_DEFER) {
>> +                dev_err(dev, "netdev init %s failed: %d\n",
>> +                    eth0_node->name, ret);
> 
> dev_err_probe()?
> 

Sure, I'll do that.

>> +            }
>> +            goto netdev_exit;
>> +        }
>> +    }
>> +
>> +    if (eth1_node) {
>> +        ret = prueth_netdev_init(prueth, eth1_node);
>> +        if (ret) {
>> +            if (ret != -EPROBE_DEFER) {
>> +                dev_err(dev, "netdev init %s failed: %d\n",
>> +                    eth1_node->name, ret);
> 
> dev_err_probe()?
> 

Sure, I'll do that.

>> +            }
>> +            goto netdev_exit;
>> +        }
>> +    }
>> +
>> +    /* register the network devices */
>> +    if (eth0_node) {
>> +        ret = register_netdev(prueth->emac[PRUETH_MAC0]->ndev);
>> +        if (ret) {
>> +            dev_err(dev, "can't register netdev for port MII0");
>> +            goto netdev_exit;
>> +        }
>> +
>> +        prueth->registered_netdevs[PRUETH_MAC0] =
>> prueth->emac[PRUETH_MAC0]->ndev;
>> +
>> +        emac_phy_connect(prueth->emac[PRUETH_MAC0]);
>> +        phy_attached_info(prueth->emac[PRUETH_MAC0]->ndev->phydev);
>> +    }
>> +
>> +    if (eth1_node) {
>> +        ret = register_netdev(prueth->emac[PRUETH_MAC1]->ndev);
>> +        if (ret) {
>> +            dev_err(dev, "can't register netdev for port MII1");
>> +            goto netdev_unregister;
>> +        }
>> +
>> +        prueth->registered_netdevs[PRUETH_MAC1] =
>> prueth->emac[PRUETH_MAC1]->ndev;
>> +        emac_phy_connect(prueth->emac[PRUETH_MAC1]);
>> +        phy_attached_info(prueth->emac[PRUETH_MAC1]->ndev->phydev);
>> +    }
>> +
>> +    dev_info(dev, "TI PRU ethernet driver initialized: %s EMAC mode\n",
>> +         (!eth0_node || !eth1_node) ? "single" : "dual");
>> +
>> +    if (eth1_node)
>> +        of_node_put(eth1_node);
>> +    if (eth0_node)
>> +        of_node_put(eth0_node);
>> +    return 0;
>> +
>> +netdev_unregister:
>> +    for (i = 0; i < PRUETH_NUM_MACS; i++) {
>> +        if (!prueth->registered_netdevs[i])
>> +            continue;
>> +        if (prueth->emac[i]->ndev->phydev) {
>> +            phy_disconnect(prueth->emac[i]->ndev->phydev);
>> +            prueth->emac[i]->ndev->phydev = NULL;
>> +        }
>> +        unregister_netdev(prueth->registered_netdevs[i]);
>> +    }
>> +
>> +netdev_exit:
>> +    for (i = 0; i < PRUETH_NUM_MACS; i++) {
>> +        struct device_node *eth_node;
>> +
>> +        eth_node = prueth->eth_node[i];
>> +        if (!eth_node)
>> +            continue;
>> +
>> +        prueth_netdev_exit(prueth, eth_node);
>> +    }
>> +
>> +gen_pool_free(prueth->sram_pool,
> 
> 1 tab missing.
> 

I'll indent it properly.

>> +          (unsigned long)prueth->msmcram.va, msmc_ram_size);
>> +
>> +put_mem:
>> +    pruss_release_mem_region(prueth->pruss, &prueth->shram);
>> +    pruss_put(prueth->pruss);
>> +
>> +put_cores:
>> +    if (eth1_node) {
>> +        prueth_put_cores(prueth, ICSS_SLICE1);
>> +        of_node_put(eth1_node);
>> +    }
>> +
>> +    if (eth0_node) {
>> +        prueth_put_cores(prueth, ICSS_SLICE0);
>> +        of_node_put(eth0_node);
>> +    }
>> +
>> +    return ret;
>> +}
> 
> [...]
> 
> From mboxrd@z Thu Jan  1 00:00:00 1970
> Return-Path:
> <linux-arm-kernel-bounces+linux-arm-kernel=archiver.kernel.org@lists.infradead.org>
> X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
>     aws-us-west-2-korg-lkml-1.web.codeaurora.org
> Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
>     (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
>     (No client certificate requested)
>     by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F7F7C433EF
>     for <linux-arm-kernel@archiver.kernel.org>; Sun,  5 Jun 2022 16:26:16 +0000
> (UTC)
> DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
>     d=lists.infradead.org; s=bombadil.20210309; h=Sender:Content-Type:
>     Content-Transfer-Encoding:Cc:List-Subscribe:List-Help:List-Post:List-Archive:
>     List-Unsubscribe:List-Id:In-Reply-To:From:References:To:Subject:MIME-Version:
>     Date:Message-ID:Reply-To:Content-ID:Content-Description:Resent-Date:
>     Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Owner;
>     bh=retw5Noo9wQ783k5GSJUTlmswtTyoF/rMXvDugAZLvo=; b=baY/vWlpdhEu2oKoaWVX7fSMqj
>     4iEPZKhU3fIP0fSrAWvp+GuLhE+xBGCyN7T3yk2KRiseFifslrcDKLsiwIAoHXrbu3xhjHwM5i5xT
>     N49Lq2ZnbXYPGUbm4JYJHjsVG+tHHTBzQRVlaY8lL97uSMGXjRfSgSfmjo5rLqzH+ejKHJDTTV5o5
>     Q86XVtFhutGBmY43N6lCef3dFCMXBtE4TkEFyoVxxt6kajelMNTwKeyVvjK4bu7SYSZUS7pcZQliy
>     oCVKL3fv5fSl/FMx/ju+BbQqWgMPohrLA+ENbjwio6icS1DL1t6W223iT27SebgyqR++YMYBp2Nyn
>     5BtT9Ajw==;
> Received: from localhost ([::1] helo=bombadil.infradead.org)
>     by bombadil.infradead.org with esmtp (Exim 4.94.2 #2 (Red Hat Linux))
>     id 1nxt3j-00Evbq-3A; Sun, 05 Jun 2022 16:24:59 +0000
> Received: from smtp05.smtpout.orange.fr ([80.12.242.127]
> helo=smtp.smtpout.orange.fr)
>     by bombadil.infradead.org with esmtps (Exim 4.94.2 #2 (Red Hat Linux))
>     id 1nxt3e-00EvY2-57
>     for linux-arm-kernel@lists.infradead.org; Sun, 05 Jun 2022 16:24:57 +0000
> Received: from [192.168.1.18] ([90.11.190.129])
>     by smtp.orange.fr with ESMTPA
>     id xt3OnV5YAE80Kxt3OnoLAV; Sun, 05 Jun 2022 18:24:45 +0200
> X-ME-Helo: [192.168.1.18]
> X-ME-Auth:
> YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
> X-ME-Date: Sun, 05 Jun 2022 18:24:45 +0200
> X-ME-IP: 90.11.190.129
> Message-ID: <3874cac9-cf3c-aa31-ecba-e2ae33935286@wanadoo.fr>
> Date: Sun, 5 Jun 2022 18:24:37 +0200
> MIME-Version: 1.0
> User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
> Thunderbird/91.9.1
> Subject: Re: [PATCH v2 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
> Content-Language: fr
> To: p-mohan@ti.com
> References: <20220531095108.21757-1-p-mohan@ti.com>
> <20220531095108.21757-3-p-mohan@ti.com>
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> In-Reply-To: <20220531095108.21757-3-p-mohan@ti.com>
> X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3
> X-CRM114-CacheID: sfid-20220605_092454_526921_B7623337 X-CRM114-Status: GOOD ( 
> 26.10  )
> X-BeenThere: linux-arm-kernel@lists.infradead.org
> X-Mailman-Version: 2.1.34
> Precedence: list
> List-Id: <linux-arm-kernel.lists.infradead.org>
> List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
> <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
> List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
> List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
> List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
> List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
> <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
> Cc: nm@ti.com, andrew@lunn.ch, grygorii.strashko@ti.com, vigneshr@ti.com,
> devicetree@vger.kernel.org, netdev@vger.kernel.org,
> linux-kernel@vger.kernel.org, afd@ti.com, rogerq@kernel.org,
> edumazet@google.com, robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
> ssantosh@kernel.org, kishon@ti.com, davem@davemloft.net,
> linux-arm-kernel@lists.infradead.org
> Content-Transfer-Encoding: base64
> Content-Type: text/plain; charset="utf-8"; Format="flowed"
> Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
> Errors-To:
> linux-arm-kernel-bounces+linux-arm-kernel=archiver.kernel.org@lists.infradead.org
> 
> SGksCgpKdXN0IGEgZmV3IGNvbW1lbnRzIGJlbG93LCBmb3Igd2hhdCB0aGV5IHdvcnRoLgoKTGUg
> MzEvMDUvMjAyMiDDoCAxMTo1MSwgUHVyYW5qYXkgTW9oYW4gYSDDqWNyaXTCoDoKPiBGcm9tOiBS
> b2dlciBRdWFkcm9zIDxyb2dlcnEtbDBjeU1yb2luSTBAcHVibGljLmdtYW5lLm9yZz4KPiAKPiBU
> aGlzIGlzIHRoZSBFdGhlcm5ldCBkcml2ZXIgZm9yIFRJIEFNNjU0IFNpbGljb24gcmV2LiAyCj4g
> d2l0aCB0aGUgSUNTU0cgUFJVIFN1Yi1zeXN0ZW0gcnVubmluZyBkdWFsLUVNQUMgZmlybXdhcmUu
> Cj4gCgpbLi4uXQoKPiArc3RhdGljIGludCBwcnVldGhfbmV0ZGV2X2luaXQoc3RydWN0IHBydWV0
> aCAqcHJ1ZXRoLAo+ICsJCQkgICAgICBzdHJ1Y3QgZGV2aWNlX25vZGUgKmV0aF9ub2RlKQo+ICt7
> Cj4gKwlpbnQgcmV0LCBudW1fdHhfY2huID0gUFJVRVRIX01BWF9UWF9RVUVVRVM7Cj4gKwlzdHJ1
> Y3QgcHJ1ZXRoX2VtYWMgKmVtYWM7Cj4gKwlzdHJ1Y3QgbmV0X2RldmljZSAqbmRldjsKPiArCWVu
> dW0gcHJ1ZXRoX3BvcnQgcG9ydDsKPiArCWVudW0gcHJ1ZXRoX21hYyBtYWM7Cj4gKwo+ICsJcG9y
> dCA9IHBydWV0aF9ub2RlX3BvcnQoZXRoX25vZGUpOwo+ICsJaWYgKHBvcnQgPCAwKQo+ICsJCXJl
> dHVybiAtRUlOVkFMOwo+ICsKPiArCW1hYyA9IHBydWV0aF9ub2RlX21hYyhldGhfbm9kZSk7Cj4g
> KwlpZiAobWFjIDwgMCkKPiArCQlyZXR1cm4gLUVJTlZBTDsKPiArCj4gKwluZGV2ID0gYWxsb2Nf
> ZXRoZXJkZXZfbXEoc2l6ZW9mKCplbWFjKSwgbnVtX3R4X2Nobik7Cj4gKwlpZiAoIW5kZXYpCj4g
> KwkJcmV0dXJuIC1FTk9NRU07Cj4gKwo+ICsJZW1hYyA9IG5ldGRldl9wcml2KG5kZXYpOwo+ICsJ
> cHJ1ZXRoLT5lbWFjW21hY10gPSBlbWFjOwo+ICsJZW1hYy0+cHJ1ZXRoID0gcHJ1ZXRoOwo+ICsJ
> ZW1hYy0+bmRldiA9IG5kZXY7Cj4gKwllbWFjLT5wb3J0X2lkID0gcG9ydDsKPiArCWVtYWMtPmNt
> ZF93cSA9IGNyZWF0ZV9zaW5nbGV0aHJlYWRfd29ya3F1ZXVlKCJpY3NzZ19jbWRfd3EiKTsKPiAr
> CWlmICghZW1hYy0+Y21kX3dxKSB7Cj4gKwkJcmV0ID0gLUVOT01FTTsKPiArCQlnb3RvIGZyZWVf
> bmRldjsKPiArCX0KPiArCUlOSVRfV09SSygmZW1hYy0+cnhfbW9kZV93b3JrLCBlbWFjX25kb19z
> ZXRfcnhfbW9kZV93b3JrKTsKPiArCj4gKwlyZXQgPSBwcnVzc19yZXF1ZXN0X21lbV9yZWdpb24o
> cHJ1ZXRoLT5wcnVzcywKPiArCQkJCSAgICAgICBwb3J0ID09IFBSVUVUSF9QT1JUX01JSTAgPwo+
> ICsJCQkJICAgICAgIFBSVVNTX01FTV9EUkFNMCA6IFBSVVNTX01FTV9EUkFNMSwKPiArCQkJCSAg
> ICAgICAmZW1hYy0+ZHJhbSk7Cj4gKwlpZiAocmV0KSB7Cj4gKwkJZGV2X2VycihwcnVldGgtPmRl
> diwgInVuYWJsZSB0byBnZXQgRFJBTTogJWRcbiIsIHJldCk7Cj4gKwkJcmV0dXJuIC1FTk9NRU07
> Cgpnb3RvIGZyZWVfd3E7ID8KCj4gKwl9Cj4gKwo+ICsJZW1hYy0+dHhfY2hfbnVtID0gMTsKPiAr
> Cj4gKwlTRVRfTkVUREVWX0RFVihuZGV2LCBwcnVldGgtPmRldik7Cj4gKwlzcGluX2xvY2tfaW5p
> dCgmZW1hYy0+bG9jayk7Cj4gKwltdXRleF9pbml0KCZlbWFjLT5jbWRfbG9jayk7Cj4gKwo+ICsJ
> ZW1hYy0+cGh5X25vZGUgPSBvZl9wYXJzZV9waGFuZGxlKGV0aF9ub2RlLCAicGh5LWhhbmRsZSIs
> IDApOwo+ICsJaWYgKCFlbWFjLT5waHlfbm9kZSAmJiAhb2ZfcGh5X2lzX2ZpeGVkX2xpbmsoZXRo
> X25vZGUpKSB7Cj4gKwkJZGV2X2VycihwcnVldGgtPmRldiwgImNvdWxkbid0IGZpbmQgcGh5LWhh
> bmRsZVxuIik7Cj4gKwkJcmV0ID0gLUVOT0RFVjsKPiArCQlnb3RvIGZyZWU7Cj4gKwl9IGVsc2Ug
> aWYgKG9mX3BoeV9pc19maXhlZF9saW5rKGV0aF9ub2RlKSkgewo+ICsJCXJldCA9IG9mX3BoeV9y
> ZWdpc3Rlcl9maXhlZF9saW5rKGV0aF9ub2RlKTsKPiArCQlpZiAocmV0KSB7Cj4gKwkJCXJldCA9
> IGRldl9lcnJfcHJvYmUocHJ1ZXRoLT5kZXYsIHJldCwKPiArCQkJCQkgICAgImZhaWxlZCB0byBy
> ZWdpc3RlciBmaXhlZC1saW5rIHBoeVxuIik7Cj4gKwkJCWdvdG8gZnJlZTsKPiArCQl9Cj4gKwo+
> ICsJCWVtYWMtPnBoeV9ub2RlID0gZXRoX25vZGU7Cj4gKwl9Cj4gKwo+ICsJcmV0ID0gb2ZfZ2V0
> X3BoeV9tb2RlKGV0aF9ub2RlLCAmZW1hYy0+cGh5X2lmKTsKPiArCWlmIChyZXQpIHsKPiArCQlk
> ZXZfZXJyKHBydWV0aC0+ZGV2LCAiY291bGQgbm90IGdldCBwaHktbW9kZSBwcm9wZXJ0eVxuIik7
> Cj4gKwkJZ290byBmcmVlOwo+ICsJfQo+ICsKPiArCWlmIChlbWFjLT5waHlfaWYgIT0gUEhZX0lO
> VEVSRkFDRV9NT0RFX01JSSAmJgo+ICsJICAgICFwaHlfaW50ZXJmYWNlX21vZGVfaXNfcmdtaWko
> ZW1hYy0+cGh5X2lmKSkgewo+ICsJCWRldl9lcnIocHJ1ZXRoLT5kZXYsICJQSFkgbW9kZSB1bnN1
> cHBvcnRlZCAlc1xuIiwgcGh5X21vZGVzKGVtYWMtPnBoeV9pZikpOwo+ICsJCWdvdG8gZnJlZTsK
> PiArCX0KPiArCj4gKwlyZXQgPSBwcnVldGhfY29uZmlnX3JnbWlpZGVsYXkocHJ1ZXRoLCBldGhf
> bm9kZSwgZW1hYy0+cGh5X2lmKTsKPiArCWlmIChyZXQpCj4gKwkJZ290byBmcmVlOwo+ICsKPiAr
> CS8qIGdldCBtYWMgYWRkcmVzcyBmcm9tIERUIGFuZCBzZXQgcHJpdmF0ZSBhbmQgbmV0ZGV2IGFk
> ZHIgKi8KPiArCXJldCA9IG9mX2dldF9ldGhkZXZfYWRkcmVzcyhldGhfbm9kZSwgbmRldik7Cj4g
> KwlpZiAoIWlzX3ZhbGlkX2V0aGVyX2FkZHIobmRldi0+ZGV2X2FkZHIpKSB7Cj4gKwkJZXRoX2h3
> X2FkZHJfcmFuZG9tKG5kZXYpOwo+ICsJCWRldl93YXJuKHBydWV0aC0+ZGV2LCAicG9ydCAlZDog
> dXNpbmcgcmFuZG9tIE1BQyBhZGRyOiAlcE1cbiIsCj4gKwkJCSBwb3J0LCBuZGV2LT5kZXZfYWRk
> cik7Cj4gKwl9Cj4gKwlldGhlcl9hZGRyX2NvcHkoZW1hYy0+bWFjX2FkZHIsIG5kZXYtPmRldl9h
> ZGRyKTsKPiArCj4gKwluZGV2LT5uZXRkZXZfb3BzID0gJmVtYWNfbmV0ZGV2X29wczsKPiArCW5k
> ZXYtPmV0aHRvb2xfb3BzID0gJmljc3NnX2V0aHRvb2xfb3BzOwo+ICsJbmRldi0+aHdfZmVhdHVy
> ZXMgPSBORVRJRl9GX1NHOwo+ICsJbmRldi0+ZmVhdHVyZXMgPSBuZGV2LT5od19mZWF0dXJlczsK
> PiArCj4gKwluZXRpZl9uYXBpX2FkZChuZGV2LCAmZW1hYy0+bmFwaV9yeCwKPiArCQkgICAgICAg
> ZW1hY19uYXBpX3J4X3BvbGwsIE5BUElfUE9MTF9XRUlHSFQpOwo+ICsKPiArCXJldHVybiAwOwo+
> ICsKPiArZnJlZToKPiArCXBydXNzX3JlbGVhc2VfbWVtX3JlZ2lvbihwcnVldGgtPnBydXNzLCAm
> ZW1hYy0+ZHJhbSk7CgpmcmVlX3dxOgoKPiArCWRlc3Ryb3lfd29ya3F1ZXVlKGVtYWMtPmNtZF93
> cSk7Cj4gK2ZyZWVfbmRldjoKPiArCWZyZWVfbmV0ZGV2KG5kZXYpOwo+ICsJcHJ1ZXRoLT5lbWFj
> W21hY10gPSBOVUxMOwo+ICsKPiArCXJldHVybiByZXQ7Cj4gK30KPiArCj4gK3N0YXRpYyB2b2lk
> IHBydWV0aF9uZXRkZXZfZXhpdChzdHJ1Y3QgcHJ1ZXRoICpwcnVldGgsCj4gKwkJCSAgICAgICBz
> dHJ1Y3QgZGV2aWNlX25vZGUgKmV0aF9ub2RlKQo+ICt7Cj4gKwlzdHJ1Y3QgcHJ1ZXRoX2VtYWMg
> KmVtYWM7Cj4gKwllbnVtIHBydWV0aF9tYWMgbWFjOwo+ICsKPiArCW1hYyA9IHBydWV0aF9ub2Rl
> X21hYyhldGhfbm9kZSk7Cj4gKwlpZiAobWFjIDwgMCkKPiArCQlyZXR1cm47Cj4gKwo+ICsJZW1h
> YyA9IHBydWV0aC0+ZW1hY1ttYWNdOwo+ICsJaWYgKCFlbWFjKQo+ICsJCXJldHVybjsKPiArCj4g
> KwlpZiAob2ZfcGh5X2lzX2ZpeGVkX2xpbmsoZW1hYy0+cGh5X25vZGUpKQo+ICsJCW9mX3BoeV9k
> ZXJlZ2lzdGVyX2ZpeGVkX2xpbmsoZW1hYy0+cGh5X25vZGUpOwo+ICsKPiArCW5ldGlmX25hcGlf
> ZGVsKCZlbWFjLT5uYXBpX3J4KTsKPiArCj4gKwlwcnVzc19yZWxlYXNlX21lbV9yZWdpb24ocHJ1
> ZXRoLT5wcnVzcywgJmVtYWMtPmRyYW0pOwo+ICsJZGVzdHJveV93b3JrcXVldWUoZW1hYy0+Y21k
> X3dxKTsKPiArCWZyZWVfbmV0ZGV2KGVtYWMtPm5kZXYpOwo+ICsJcHJ1ZXRoLT5lbWFjW21hY10g
> PSBOVUxMOwo+ICt9Cj4gKwo+ICtzdGF0aWMgaW50IHBydWV0aF9nZXRfY29yZXMoc3RydWN0IHBy
> dWV0aCAqcHJ1ZXRoLCBpbnQgc2xpY2UpCj4gK3sKPiArCWVudW0gcHJ1c3NfcHJ1X2lkIHBydXNz
> X2lkOwo+ICsJc3RydWN0IGRldmljZSAqZGV2ID0gcHJ1ZXRoLT5kZXY7Cj4gKwlzdHJ1Y3QgZGV2
> aWNlX25vZGUgKm5wID0gZGV2LT5vZl9ub2RlOwo+ICsJaW50IGlkeCA9IC0xLCByZXQ7Cj4gKwo+
> ICsJc3dpdGNoIChzbGljZSkgewo+ICsJY2FzZSBJQ1NTX1NMSUNFMDoKPiArCQlpZHggPSAwOwo+
> ICsJCWJyZWFrOwo+ICsJY2FzZSBJQ1NTX1NMSUNFMToKPiArCQlpZHggPSAzOwo+ICsJCWJyZWFr
> Owo+ICsJZGVmYXVsdDoKPiArCQlyZXR1cm4gLUVJTlZBTDsKPiArCX0KPiArCj4gKwlwcnVldGgt
> PnBydVtzbGljZV0gPSBwcnVfcnByb2NfZ2V0KG5wLCBpZHgsICZwcnVzc19pZCk7Cj4gKwlpZiAo
> SVNfRVJSKHBydWV0aC0+cHJ1W3NsaWNlXSkpIHsKPiArCQlyZXQgPSBQVFJfRVJSKHBydWV0aC0+
> cHJ1W3NsaWNlXSk7Cj4gKwkJcHJ1ZXRoLT5wcnVbc2xpY2VdID0gTlVMTDsKPiArCQlpZiAocmV0
> ICE9IC1FUFJPQkVfREVGRVIpCj4gKwkJCWRldl9lcnIoZGV2LCAidW5hYmxlIHRvIGdldCBQUlUl
> ZDogJWRcbiIsIHNsaWNlLCByZXQpOwoKcmV0dXJuIGRldl9lcnJfcHJvYmUoKT8KCj4gKwkJcmV0
> dXJuIHJldDsKPiArCX0KPiArCXBydWV0aC0+cHJ1X2lkW3NsaWNlXSA9IHBydXNzX2lkOwo+ICsK
> PiArCWlkeCsrOwo+ICsJcHJ1ZXRoLT5ydHVbc2xpY2VdID0gcHJ1X3Jwcm9jX2dldChucCwgaWR4
> LCBOVUxMKTsKPiArCWlmIChJU19FUlIocHJ1ZXRoLT5ydHVbc2xpY2VdKSkgewo+ICsJCXJldCA9
> IFBUUl9FUlIocHJ1ZXRoLT5ydHVbc2xpY2VdKTsKPiArCQlwcnVldGgtPnJ0dVtzbGljZV0gPSBO
> VUxMOwo+ICsJCWlmIChyZXQgIT0gLUVQUk9CRV9ERUZFUikKPiArCQkJZGV2X2VycihkZXYsICJ1
> bmFibGUgdG8gZ2V0IFJUVSVkOiAlZFxuIiwgc2xpY2UsIHJldCk7CgpTYW1lLgoKPiArCQlyZXR1
> cm4gcmV0Owo+ICsJfQo+ICsKPiArCWlkeCsrOwo+ICsJcHJ1ZXRoLT50eHBydVtzbGljZV0gPSBw
> cnVfcnByb2NfZ2V0KG5wLCBpZHgsIE5VTEwpOwo+ICsJaWYgKElTX0VSUihwcnVldGgtPnR4cHJ1
> W3NsaWNlXSkpIHsKPiArCQlyZXQgPSBQVFJfRVJSKHBydWV0aC0+dHhwcnVbc2xpY2VdKTsKPiAr
> CQlwcnVldGgtPnR4cHJ1W3NsaWNlXSA9IE5VTEw7Cj4gKwkJaWYgKHJldCAhPSAtRVBST0JFX0RF
> RkVSKQo+ICsJCQlkZXZfZXJyKGRldiwgInVuYWJsZSB0byBnZXQgVFhfUFJVJWQ6ICVkXG4iLAo+
> ICsJCQkJc2xpY2UsIHJldCk7CgpTYW1lLgoKPiArCQlyZXR1cm4gcmV0Owo+ICsJfQo+ICsKPiAr
> CXJldHVybiAwOwo+ICt9Cj4gKwo+ICtzdGF0aWMgdm9pZCBwcnVldGhfcHV0X2NvcmVzKHN0cnVj
> dCBwcnVldGggKnBydWV0aCwgaW50IHNsaWNlKQo+ICt7Cj4gKwlpZiAocHJ1ZXRoLT50eHBydVtz
> bGljZV0pCj4gKwkJcHJ1X3Jwcm9jX3B1dChwcnVldGgtPnR4cHJ1W3NsaWNlXSk7Cj4gKwo+ICsJ
> aWYgKHBydWV0aC0+cnR1W3NsaWNlXSkKPiArCQlwcnVfcnByb2NfcHV0KHBydWV0aC0+cnR1W3Ns
> aWNlXSk7Cj4gKwo+ICsJaWYgKHBydWV0aC0+cHJ1W3NsaWNlXSkKPiArCQlwcnVfcnByb2NfcHV0
> KHBydWV0aC0+cHJ1W3NsaWNlXSk7Cj4gK30KPiArCj4gK3N0YXRpYyBjb25zdCBzdHJ1Y3Qgb2Zf
> ZGV2aWNlX2lkIHBydWV0aF9kdF9tYXRjaFtdOwo+ICsKPiArc3RhdGljIGludCBwcnVldGhfcHJv
> YmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKPiArewo+ICsJc3RydWN0IHBydWV0aCAq
> cHJ1ZXRoOwo+ICsJc3RydWN0IGRldmljZSAqZGV2ID0gJnBkZXYtPmRldjsKPiArCXN0cnVjdCBk
> ZXZpY2Vfbm9kZSAqbnAgPSBkZXYtPm9mX25vZGU7Cj4gKwlzdHJ1Y3QgZGV2aWNlX25vZGUgKmV0
> aF9wb3J0c19ub2RlOwo+ICsJc3RydWN0IGRldmljZV9ub2RlICpldGhfbm9kZTsKPiArCXN0cnVj
> dCBkZXZpY2Vfbm9kZSAqZXRoMF9ub2RlLCAqZXRoMV9ub2RlOwo+ICsJY29uc3Qgc3RydWN0IG9m
> X2RldmljZV9pZCAqbWF0Y2g7Cj4gKwlzdHJ1Y3QgcHJ1c3MgKnBydXNzOwo+ICsJaW50IGksIHJl
> dDsKPiArCXUzMiBtc21jX3JhbV9zaXplOwo+ICsJc3RydWN0IGdlbnBvb2xfZGF0YV9hbGlnbiBn
> cF9kYXRhID0gewo+ICsJCS5hbGlnbiA9IFNaXzY0SywKPiArCX07Cj4gKwo+ICsJbWF0Y2ggPSBv
> Zl9tYXRjaF9kZXZpY2UocHJ1ZXRoX2R0X21hdGNoLCBkZXYpOwo+ICsJaWYgKCFtYXRjaCkKPiAr
> CQlyZXR1cm4gLUVOT0RFVjsKPiArCj4gKwlwcnVldGggPSBkZXZtX2t6YWxsb2MoZGV2LCBzaXpl
> b2YoKnBydWV0aCksIEdGUF9LRVJORUwpOwo+ICsJaWYgKCFwcnVldGgpCj4gKwkJcmV0dXJuIC1F
> Tk9NRU07Cj4gKwo+ICsJZGV2X3NldF9kcnZkYXRhKGRldiwgcHJ1ZXRoKTsKPiArCXBydWV0aC0+
> cGRldiA9IHBkZXY7Cj4gKwlwcnVldGgtPnBkYXRhID0gKihjb25zdCBzdHJ1Y3QgcHJ1ZXRoX3Bk
> YXRhICopbWF0Y2gtPmRhdGE7Cj4gKwo+ICsJcHJ1ZXRoLT5kZXYgPSBkZXY7Cj4gKwlldGhfcG9y
> dHNfbm9kZSA9IG9mX2dldF9jaGlsZF9ieV9uYW1lKG5wLCAiZXRoZXJuZXQtcG9ydHMiKTsKPiAr
> CWlmICghZXRoX3BvcnRzX25vZGUpCj4gKwkJcmV0dXJuIC1FTk9FTlQ7Cj4gKwo+ICsJZm9yX2Vh
> Y2hfY2hpbGRfb2Zfbm9kZShldGhfcG9ydHNfbm9kZSwgZXRoX25vZGUpIHsKPiArCQl1MzIgcmVn
> Owo+ICsKPiArCQlpZiAoc3RyY21wKGV0aF9ub2RlLT5uYW1lLCAicG9ydCIpKQo+ICsJCQljb250
> aW51ZTsKPiArCQlyZXQgPSBvZl9wcm9wZXJ0eV9yZWFkX3UzMihldGhfbm9kZSwgInJlZyIsICZy
> ZWcpOwo+ICsJCWlmIChyZXQgPCAwKSB7Cj4gKwkJCWRldl9lcnIoZGV2LCAiJXBPRiBlcnJvciBy
> ZWFkaW5nIHBvcnRfaWQgJWRcbiIsCj4gKwkJCQlldGhfbm9kZSwgcmV0KTsKPiArCQl9Cj4gKwo+
> ICsJCW9mX25vZGVfZ2V0KGV0aF9ub2RlKTsKPiArCj4gKwkJaWYgKHJlZyA9PSAwKQo+ICsJCQll
> dGgwX25vZGUgPSBldGhfbm9kZTsKPiArCQllbHNlIGlmIChyZWcgPT0gMSkKPiArCQkJZXRoMV9u
> b2RlID0gZXRoX25vZGU7Cj4gKwkJZWxzZQo+ICsJCQlkZXZfZXJyKGRldiwgInBvcnQgcmVnIHNo
> b3VsZCBiZSAwIG9yIDFcbiIpOwo+ICsJfQo+ICsKPiArCW9mX25vZGVfcHV0KGV0aF9wb3J0c19u
> b2RlKTsKPiArCj4gKwkvKiBBdCBsZWFzdCBvbmUgbm9kZSBtdXN0IGJlIHByZXNlbnQgYW5kIGF2
> YWlsYWJsZSBlbHNlIHdlIGZhaWwgKi8KPiArCWlmICghZXRoMF9ub2RlICYmICFldGgxX25vZGUp
> IHsKPiArCQlkZXZfZXJyKGRldiwgIm5laXRoZXIgcG9ydDAgbm9yIHBvcnQxIG5vZGUgYXZhaWxh
> YmxlXG4iKTsKPiArCQlyZXR1cm4gLUVOT0RFVjsKPiArCX0KPiArCj4gKwlpZiAoZXRoMF9ub2Rl
> ID09IGV0aDFfbm9kZSkgewo+ICsJCWRldl9lcnIoZGV2LCAicG9ydDAgYW5kIHBvcnQxIGNhbid0
> IGhhdmUgc2FtZSByZWdcbiIpOwo+ICsJCW9mX25vZGVfcHV0KGV0aDBfbm9kZSk7Cj4gKwkJcmV0
> dXJuIC1FTk9ERVY7Cj4gKwl9Cj4gKwo+ICsJcHJ1ZXRoLT5ldGhfbm9kZVtQUlVFVEhfTUFDMF0g
> PSBldGgwX25vZGU7Cj4gKwlwcnVldGgtPmV0aF9ub2RlW1BSVUVUSF9NQUMxXSA9IGV0aDFfbm9k
> ZTsKPiArCj4gKwlwcnVldGgtPm1paWdfcnQgPSBzeXNjb25fcmVnbWFwX2xvb2t1cF9ieV9waGFu
> ZGxlKG5wLCAidGksbWlpLWctcnQiKTsKPiArCWlmIChJU19FUlIocHJ1ZXRoLT5taWlnX3J0KSkg
> ewo+ICsJCWRldl9lcnIoZGV2LCAiY291bGRuJ3QgZ2V0IHRpLG1paS1nLXJ0IHN5c2NvbiByZWdt
> YXBcbiIpOwo+ICsJCXJldHVybiAtRU5PREVWOwo+ICsJfQo+ICsKPiArCXBydWV0aC0+bWlpX3J0
> ID0gc3lzY29uX3JlZ21hcF9sb29rdXBfYnlfcGhhbmRsZShucCwgInRpLG1paS1ydCIpOwo+ICsJ
> aWYgKElTX0VSUihwcnVldGgtPm1paV9ydCkpIHsKPiArCQlkZXZfZXJyKGRldiwgImNvdWxkbid0
> IGdldCB0aSxtaWktcnQgc3lzY29uIHJlZ21hcFxuIik7Cj4gKwkJcmV0dXJuIC1FTk9ERVY7Cj4g
> Kwl9Cj4gKwo+ICsJaWYgKGV0aDBfbm9kZSkgewo+ICsJCXJldCA9IHBydWV0aF9nZXRfY29yZXMo
> cHJ1ZXRoLCBJQ1NTX1NMSUNFMCk7Cj4gKwkJaWYgKHJldCkKPiArCQkJZ290byBwdXRfY29yZXM7
> Cj4gKwl9Cj4gKwo+ICsJaWYgKGV0aDFfbm9kZSkgewo+ICsJCXJldCA9IHBydWV0aF9nZXRfY29y
> ZXMocHJ1ZXRoLCBJQ1NTX1NMSUNFMSk7Cj4gKwkJaWYgKHJldCkKPiArCQkJZ290byBwdXRfY29y
> ZXM7Cj4gKwl9Cj4gKwo+ICsJcHJ1c3MgPSBwcnVzc19nZXQoZXRoMF9ub2RlID8KPiArCQkJICBw
> cnVldGgtPnBydVtJQ1NTX1NMSUNFMF0gOiBwcnVldGgtPnBydVtJQ1NTX1NMSUNFMV0pOwo+ICsJ
> aWYgKElTX0VSUihwcnVzcykpIHsKPiArCQlyZXQgPSBQVFJfRVJSKHBydXNzKTsKPiArCQlkZXZf
> ZXJyKGRldiwgInVuYWJsZSB0byBnZXQgcHJ1c3MgaGFuZGxlXG4iKTsKPiArCQlnb3RvIHB1dF9j
> b3JlczsKPiArCX0KPiArCj4gKwlwcnVldGgtPnBydXNzID0gcHJ1c3M7Cj4gKwo+ICsJcmV0ID0g
> cHJ1c3NfcmVxdWVzdF9tZW1fcmVnaW9uKHBydXNzLCBQUlVTU19NRU1fU0hSRF9SQU0yLAo+ICsJ
> CQkJICAgICAgICZwcnVldGgtPnNocmFtKTsKPiArCWlmIChyZXQpIHsKPiArCQlkZXZfZXJyKGRl
> diwgInVuYWJsZSB0byBnZXQgUFJVU1MgU0hSRCBSQU0yOiAlZFxuIiwgcmV0KTsKPiArCQlnb3Rv
> IHB1dF9tZW07CgpJcyBpdCBzYWZlIHRvIGNhbGwgcHJ1c3NfcmVsZWFzZV9tZW1fcmVnaW9uKCkg
> aWYgCnBydXNzX3JlcXVlc3RfbWVtX3JlZ2lvbigpIGhhcyBmYWlsZWQ/CgpUaGUgb3RoZXIgcGxh
> Y2Ugd2hlcmUgaXQgaXMgY2FsbGVkIGl0IGlzIG5vdCBkb25lIHRoZSBzYW1lIHdheS4KCj4gKwl9
> Cj4gKwo+ICsJcHJ1ZXRoLT5zcmFtX3Bvb2wgPSBvZl9nZW5fcG9vbF9nZXQobnAsICJzcmFtIiwg
> MCk7Cj4gKwlpZiAoIXBydWV0aC0+c3JhbV9wb29sKSB7Cj4gKwkJZGV2X2VycihkZXYsICJ1bmFi
> bGUgdG8gZ2V0IFNSQU0gcG9vbFxuIik7Cj4gKwkJcmV0ID0gLUVOT0RFVjsKPiArCj4gKwkJZ290
> byBwdXRfbWVtOwo+ICsJfQo+ICsKPiArCW1zbWNfcmFtX3NpemUgPSBNU01DX1JBTV9TSVpFOwo+
> ICsKPiArCS8qIE5PVEU6IEZXIGJ1ZyBuZWVkcyBidWZmZXIgYmFzZSB0byBiZSA2NEtCIGFsaWdu
> ZWQgKi8KPiArCXBydWV0aC0+bXNtY3JhbS52YSA9Cj4gKwkJKHZvaWQgX19pb21lbSAqKWdlbl9w
> b29sX2FsbG9jX2FsZ28ocHJ1ZXRoLT5zcmFtX3Bvb2wsCj4gKwkJCQkJCSAgICBtc21jX3JhbV9z
> aXplLAo+ICsJCQkJCQkgICAgZ2VuX3Bvb2xfZmlyc3RfZml0X2FsaWduLAo+ICsJCQkJCQkgICAg
> JmdwX2RhdGEpOwo+ICsKPiArCWlmICghcHJ1ZXRoLT5tc21jcmFtLnZhKSB7Cj4gKwkJcmV0ID0g
> LUVOT01FTTsKPiArCQlkZXZfZXJyKGRldiwgInVuYWJsZSB0byBhbGxvY2F0ZSBNU01DIHJlc291
> cmNlXG4iKTsKPiArCQlnb3RvIHB1dF9tZW07Cj4gKwl9Cj4gKwlwcnVldGgtPm1zbWNyYW0ucGEg
> PSBnZW5fcG9vbF92aXJ0X3RvX3BoeXMocHJ1ZXRoLT5zcmFtX3Bvb2wsCj4gKwkJCQkJCSAgICh1
> bnNpZ25lZCBsb25nKXBydWV0aC0+bXNtY3JhbS52YSk7Cj4gKwlwcnVldGgtPm1zbWNyYW0uc2l6
> ZSA9IG1zbWNfcmFtX3NpemU7Cj4gKwltZW1zZXQocHJ1ZXRoLT5tc21jcmFtLnZhLCAwLCBtc21j
> X3JhbV9zaXplKTsKPiArCWRldl9kYmcoZGV2LCAic3JhbTogcGEgJWxseCB2YSAlcCBzaXplICV6
> eFxuIiwgcHJ1ZXRoLT5tc21jcmFtLnBhLAo+ICsJCXBydWV0aC0+bXNtY3JhbS52YSwgcHJ1ZXRo
> LT5tc21jcmFtLnNpemUpOwo+ICsKPiArCS8qIHNldHVwIG5ldGRldiBpbnRlcmZhY2VzICovCj4g
> KwlpZiAoZXRoMF9ub2RlKSB7Cj4gKwkJcmV0ID0gcHJ1ZXRoX25ldGRldl9pbml0KHBydWV0aCwg
> ZXRoMF9ub2RlKTsKPiArCQlpZiAocmV0KSB7Cj4gKwkJCWlmIChyZXQgIT0gLUVQUk9CRV9ERUZF
> Uikgewo+ICsJCQkJZGV2X2VycihkZXYsICJuZXRkZXYgaW5pdCAlcyBmYWlsZWQ6ICVkXG4iLAo+
> ICsJCQkJCWV0aDBfbm9kZS0+bmFtZSwgcmV0KTsKCmRldl9lcnJfcHJvYmUoKT8KCj4gKwkJCX0K
> PiArCQkJZ290byBuZXRkZXZfZXhpdDsKPiArCQl9Cj4gKwl9Cj4gKwo+ICsJaWYgKGV0aDFfbm9k
> ZSkgewo+ICsJCXJldCA9IHBydWV0aF9uZXRkZXZfaW5pdChwcnVldGgsIGV0aDFfbm9kZSk7Cj4g
> KwkJaWYgKHJldCkgewo+ICsJCQlpZiAocmV0ICE9IC1FUFJPQkVfREVGRVIpIHsKPiArCQkJCWRl
> dl9lcnIoZGV2LCAibmV0ZGV2IGluaXQgJXMgZmFpbGVkOiAlZFxuIiwKPiArCQkJCQlldGgxX25v
> ZGUtPm5hbWUsIHJldCk7CgpkZXZfZXJyX3Byb2JlKCk/Cgo+ICsJCQl9Cj4gKwkJCWdvdG8gbmV0
> ZGV2X2V4aXQ7Cj4gKwkJfQo+ICsJfQo+ICsKPiArCS8qIHJlZ2lzdGVyIHRoZSBuZXR3b3JrIGRl
> dmljZXMgKi8KPiArCWlmIChldGgwX25vZGUpIHsKPiArCQlyZXQgPSByZWdpc3Rlcl9uZXRkZXYo
> cHJ1ZXRoLT5lbWFjW1BSVUVUSF9NQUMwXS0+bmRldik7Cj4gKwkJaWYgKHJldCkgewo+ICsJCQlk
> ZXZfZXJyKGRldiwgImNhbid0IHJlZ2lzdGVyIG5ldGRldiBmb3IgcG9ydCBNSUkwIik7Cj4gKwkJ
> CWdvdG8gbmV0ZGV2X2V4aXQ7Cj4gKwkJfQo+ICsKPiArCQlwcnVldGgtPnJlZ2lzdGVyZWRfbmV0
> ZGV2c1tQUlVFVEhfTUFDMF0gPSBwcnVldGgtPmVtYWNbUFJVRVRIX01BQzBdLT5uZGV2Owo+ICsK
> PiArCQllbWFjX3BoeV9jb25uZWN0KHBydWV0aC0+ZW1hY1tQUlVFVEhfTUFDMF0pOwo+ICsJCXBo
> eV9hdHRhY2hlZF9pbmZvKHBydWV0aC0+ZW1hY1tQUlVFVEhfTUFDMF0tPm5kZXYtPnBoeWRldik7
> Cj4gKwl9Cj4gKwo+ICsJaWYgKGV0aDFfbm9kZSkgewo+ICsJCXJldCA9IHJlZ2lzdGVyX25ldGRl
> dihwcnVldGgtPmVtYWNbUFJVRVRIX01BQzFdLT5uZGV2KTsKPiArCQlpZiAocmV0KSB7Cj4gKwkJ
> CWRldl9lcnIoZGV2LCAiY2FuJ3QgcmVnaXN0ZXIgbmV0ZGV2IGZvciBwb3J0IE1JSTEiKTsKPiAr
> CQkJZ290byBuZXRkZXZfdW5yZWdpc3RlcjsKPiArCQl9Cj4gKwo+ICsJCXBydWV0aC0+cmVnaXN0
> ZXJlZF9uZXRkZXZzW1BSVUVUSF9NQUMxXSA9IHBydWV0aC0+ZW1hY1tQUlVFVEhfTUFDMV0tPm5k
> ZXY7Cj4gKwkJZW1hY19waHlfY29ubmVjdChwcnVldGgtPmVtYWNbUFJVRVRIX01BQzFdKTsKPiAr
> CQlwaHlfYXR0YWNoZWRfaW5mbyhwcnVldGgtPmVtYWNbUFJVRVRIX01BQzFdLT5uZGV2LT5waHlk
> ZXYpOwo+ICsJfQo+ICsKPiArCWRldl9pbmZvKGRldiwgIlRJIFBSVSBldGhlcm5ldCBkcml2ZXIg
> aW5pdGlhbGl6ZWQ6ICVzIEVNQUMgbW9kZVxuIiwKPiArCQkgKCFldGgwX25vZGUgfHwgIWV0aDFf
> bm9kZSkgPyAic2luZ2xlIiA6ICJkdWFsIik7Cj4gKwo+ICsJaWYgKGV0aDFfbm9kZSkKPiArCQlv
> Zl9ub2RlX3B1dChldGgxX25vZGUpOwo+ICsJaWYgKGV0aDBfbm9kZSkKPiArCQlvZl9ub2RlX3B1
> dChldGgwX25vZGUpOwo+ICsJcmV0dXJuIDA7Cj4gKwo+ICtuZXRkZXZfdW5yZWdpc3RlcjoKPiAr
> CWZvciAoaSA9IDA7IGkgPCBQUlVFVEhfTlVNX01BQ1M7IGkrKykgewo+ICsJCWlmICghcHJ1ZXRo
> LT5yZWdpc3RlcmVkX25ldGRldnNbaV0pCj4gKwkJCWNvbnRpbnVlOwo+ICsJCWlmIChwcnVldGgt
> PmVtYWNbaV0tPm5kZXYtPnBoeWRldikgewo+ICsJCQlwaHlfZGlzY29ubmVjdChwcnVldGgtPmVt
> YWNbaV0tPm5kZXYtPnBoeWRldik7Cj4gKwkJCXBydWV0aC0+ZW1hY1tpXS0+bmRldi0+cGh5ZGV2
> ID0gTlVMTDsKPiArCQl9Cj4gKwkJdW5yZWdpc3Rlcl9uZXRkZXYocHJ1ZXRoLT5yZWdpc3RlcmVk
> X25ldGRldnNbaV0pOwo+ICsJfQo+ICsKPiArbmV0ZGV2X2V4aXQ6Cj4gKwlmb3IgKGkgPSAwOyBp
> IDwgUFJVRVRIX05VTV9NQUNTOyBpKyspIHsKPiArCQlzdHJ1Y3QgZGV2aWNlX25vZGUgKmV0aF9u
> b2RlOwo+ICsKPiArCQlldGhfbm9kZSA9IHBydWV0aC0+ZXRoX25vZGVbaV07Cj4gKwkJaWYgKCFl
> dGhfbm9kZSkKPiArCQkJY29udGludWU7Cj4gKwo+ICsJCXBydWV0aF9uZXRkZXZfZXhpdChwcnVl
> dGgsIGV0aF9ub2RlKTsKPiArCX0KPiArCj4gK2dlbl9wb29sX2ZyZWUocHJ1ZXRoLT5zcmFtX3Bv
> b2wsCgoxIHRhYiBtaXNzaW5nLgoKPiArCSAgICAgICh1bnNpZ25lZCBsb25nKXBydWV0aC0+bXNt
> Y3JhbS52YSwgbXNtY19yYW1fc2l6ZSk7Cj4gKwo+ICtwdXRfbWVtOgo+ICsJcHJ1c3NfcmVsZWFz
> ZV9tZW1fcmVnaW9uKHBydWV0aC0+cHJ1c3MsICZwcnVldGgtPnNocmFtKTsKPiArCXBydXNzX3B1
> dChwcnVldGgtPnBydXNzKTsKPiArCj4gK3B1dF9jb3JlczoKPiArCWlmIChldGgxX25vZGUpIHsK
> PiArCQlwcnVldGhfcHV0X2NvcmVzKHBydWV0aCwgSUNTU19TTElDRTEpOwo+ICsJCW9mX25vZGVf
> cHV0KGV0aDFfbm9kZSk7Cj4gKwl9Cj4gKwo+ICsJaWYgKGV0aDBfbm9kZSkgewo+ICsJCXBydWV0
> aF9wdXRfY29yZXMocHJ1ZXRoLCBJQ1NTX1NMSUNFMCk7Cj4gKwkJb2Zfbm9kZV9wdXQoZXRoMF9u
> b2RlKTsKPiArCX0KPiArCj4gKwlyZXR1cm4gcmV0Owo+ICt9CgpbLi4uXQoKX19fX19fX19fX19f
> X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KbGludXgtYXJtLWtlcm5lbCBtYWls
> aW5nIGxpc3QKbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnCmh0dHA6Ly9saXN0
> cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtYXJtLWtlcm5lbAo=
> 
