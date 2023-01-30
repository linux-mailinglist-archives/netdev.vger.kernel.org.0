Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B93680656
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 08:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbjA3HDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 02:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjA3HDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 02:03:39 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C63113532;
        Sun, 29 Jan 2023 23:03:37 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30U730CA127759;
        Mon, 30 Jan 2023 01:03:00 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1675062180;
        bh=r3d1MXzMmUq1pqlvkbJrJzaucSVl+EC6aoJjD3D5ck8=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=fSwXnnOuAVK5ztoI3nOhC2nwv1V96uV1POYYttesAVNRba/Tb8cEU/6VNxrZqEaxI
         CS4lwLhV9CGA7BieLlpMJ2Bk9l6avZchHA8bz/Hf8+ovdUZOOd/0LPoJQIJts6qMNS
         sQRdsIU9T7px0REgKYr1Myh9nyh131KnZodgdc4U=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30U72xq4095577
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Jan 2023 01:03:00 -0600
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 30
 Jan 2023 01:02:59 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 30 Jan 2023 01:02:59 -0600
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30U72rmo067753;
        Mon, 30 Jan 2023 01:02:54 -0600
Message-ID: <fe54244c-3d05-2d70-6bdb-f4cde9448ae5@ti.com>
Date:   Mon, 30 Jan 2023 12:32:53 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [EXTERNAL] Re: [PATCH v3 1/2] dt-bindings: net: Add ICSSG
 Ethernet Driver bindings
Content-Language: en-US
To:     Roger Quadros <rogerq@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "Md Danish Anwar" <danishanwar@ti.com>
CC:     "Andrew F. Davis" <afd@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Suman Anna <s-anna@ti.com>, YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <nm@ti.com>,
        <ssantosh@kernel.org>, <srk@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20221223110930.1337536-1-danishanwar@ti.com>
 <20221223110930.1337536-2-danishanwar@ti.com> <Y6W7FNzJEHYt6URg@lunn.ch>
 <620ce8e6-2b40-1322-364a-0099a6e2af26@kernel.org> <Y7Mjx8ZEVEcU2mK8@lunn.ch>
 <b55dec4b-4fd5-71fa-4073-b5793cafdee7@kernel.org>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <b55dec4b-4fd5-71fa-4073-b5793cafdee7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roger,

On 05/01/23 17:03, Roger Quadros wrote:
> On 02/01/2023 20:34, Andrew Lunn wrote:
>> On Mon, Jan 02, 2023 at 03:04:19PM +0200, Roger Quadros wrote:
>>>
>>>
>>> On 23/12/2022 16:28, Andrew Lunn wrote:
>>>>> +        ethernet-ports {
>>>>> +            #address-cells = <1>;
>>>>> +            #size-cells = <0>;
>>>>> +            pruss2_emac0: port@0 {
>>>>> +                reg = <0>;
>>>>> +                phy-handle = <&pruss2_eth0_phy>;
>>>>> +                phy-mode = "rgmii-rxid";
>>>>
>>>> That is unusual. Where are the TX delays coming from?
>>>
>>> >From the below property
>>>
>>> +                ti,syscon-rgmii-delay = <&scm_conf 0x4120>;
>>>
>>> The TX delay can be enabled/disabled from within the ICSSG block.
>>>
>>> If this property exists and PHY mode is neither PHY_INTERFACE_MODE_RGMII_ID
>>> nor PHY_INTERFACE_MODE_RGMII_TXID then the internal delay is enabled.
>>>
>>> This logic is in prueth_config_rgmiidelay() function in the introduced driver.
>>
>> What nearly every other MAC driver does is pass the phy-mode to the
>> PHY and lets the PHY add the delays. I would recommend you do that,
>> rather than be special and different.
> 
> 
> If I remember right we couldn't disable MAC TX delay on some earlier silicon
> so had to take this route. I don't remember why we couldn't disable it though.
> 
> In more recent Silicon Manuals I do see that MAC TX delay can be enabled/disabled.
> If this really is the case then we should change to
> 
>  phy-mode = "rgmii-id";
> 
> And let PHY handle the TX+RX delays.
> 
> Danish,
> could you please make the change and test if it works on current silicon?
> 

I changed the phy-mode to "rgmii-id" instead of "rgmii-rxid". I did the testing
on current silicon (AM654x SR 2.0) and it is working fine.

> cheers,
> -roger

Thanks and Regards,
Danish.
