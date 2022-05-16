Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D2F527CFF
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 07:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238587AbiEPFJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 01:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbiEPFJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 01:09:49 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2BF28991;
        Sun, 15 May 2022 22:09:47 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 24G59NY7086792;
        Mon, 16 May 2022 00:09:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1652677763;
        bh=/z8oplWf9RSWaittYINIFexlqAXiWjMlkFiA5nmmoYU=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=r4nnrlnpqplRCyzn6VGT6+AfQjnBRw3KDNXaNX7ytkARud3afDWhP0hQOesnhoPNU
         y52n0NjZYcvbVcQ+q+5owau7fI5C8e7DwgwYIZ64KOzNFYURU0Lb+cad7etmcINtC1
         oTLYtLvDYSzx5pQFV7hZaccmWGo7cA0Q7laHLKZs=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 24G59Nrg004775
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 May 2022 00:09:23 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 16
 May 2022 00:09:22 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 16 May 2022 00:09:22 -0500
Received: from [172.24.220.119] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 24G59FTt004004;
        Mon, 16 May 2022 00:09:16 -0500
Message-ID: <a5e14871-db4f-54ce-b925-0787750ab6c2@ti.com>
Date:   Mon, 16 May 2022 10:39:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <krzysztof.kozlowski+dt@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <nm@ti.com>, <ssantosh@kernel.org>, <s-anna@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <rogerq@kernel.org>,
        <grygorii.strashko@ti.com>, <vigneshr@ti.com>, <kishon@ti.com>,
        <robh+dt@kernel.org>, <afd@ti.com>
References: <20220506052433.28087-1-p-mohan@ti.com>
 <20220506052433.28087-3-p-mohan@ti.com> <YnVQW7xpSWEE2/HP@lunn.ch>
 <f674c56c-0621-f471-9517-5c349940d362@ti.com> <YnkJ5bFd72d0FagD@lunn.ch>
From:   Puranjay Mohan <p-mohan@ti.com>
In-Reply-To: <YnkJ5bFd72d0FagD@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 09/05/22 18:02, Andrew Lunn wrote:
>>>> +static void icssg_init_emac_mode(struct prueth *prueth)
>>>> +{
>>>> +	u8 mac[ETH_ALEN] = { 0 };
>>>> +
>>>> +	if (prueth->emacs_initialized)
>>>> +		return;
>>>> +
>>>> +	regmap_update_bits(prueth->miig_rt, FDB_GEN_CFG1, SMEM_VLAN_OFFSET_MASK, 0);
>>>> +	regmap_write(prueth->miig_rt, FDB_GEN_CFG2, 0);
>>>> +	/* Clear host MAC address */
>>>> +	icssg_class_set_host_mac_addr(prueth->miig_rt, mac);
>>>
>>> Seems an odd thing to do, set it to 00:00:00:00:00:00. You probably
>>> want to add a comment why you do this odd thing.
>>
>> Actually, this is when the device is configured as a bridge, the host
>> mac address has to be set to zero to while bringing it back to emac
>> mode. I will add a comment to explain this.
> 
> I don't see any switchdev interface. How does it get into bridge mode?

I will be sending patches to add the switch mode support after this
series gets merged.

> 
>>>> +	} else if (emac->link) {
>>>> +		new_state = true;
>>>> +		emac->link = 0;
>>>> +		/* defaults for no link */
>>>> +
>>>> +		/* f/w should support 100 & 1000 */
>>>> +		emac->speed = SPEED_1000;
>>>> +
>>>> +		/* half duplex may not supported by f/w */
>>>> +		emac->duplex = DUPLEX_FULL;
>>>
>>> Why set speed and duplex when you have just lost the link? They are
>>> meaningless until the link comes back.
>>
>> These were just the default values that we added.
>> What do you suggest I put here?
> 
> Nothing. If the link is down, they are meaningless. If something is
> accessing them when the link is down, that code is broken. So i
> suppose you could give them poison values to help find your broken
> code.

Okay, I will remove it in next version.

> 
>>>> +	for_each_child_of_node(eth_ports_node, eth_node) {
>>>> +		u32 reg;
>>>> +
>>>> +		if (strcmp(eth_node->name, "port"))
>>>> +			continue;
>>>> +		ret = of_property_read_u32(eth_node, "reg", &reg);
>>>> +		if (ret < 0) {
>>>> +			dev_err(dev, "%pOF error reading port_id %d\n",
>>>> +				eth_node, ret);
>>>> +		}
>>>> +
>>>> +		if (reg == 0)
>>>> +			eth0_node = eth_node;
>>>> +		else if (reg == 1)
>>>> +			eth1_node = eth_node;
>>>
>>> and if reg == 4
>>>
>>> Or reg 0 appears twice?
>>
>> In both of the cases that you mentioned, the device tree schema check
>> will fail, hence, we can safely assume that this will be 0 and 1 only.
> 
> Nothing forces you to run the scheme checker. It is not run by the
> kernel before it starts accessing the DT blob. You should assume it is
> invalid until you have proven it to be valid.

I will add error checking here to make sure it is handled.

> 
> 	Andrew

Thanks,
Puranjay Mohan
