Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6156D1C19
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbjCaJ02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbjCaJ0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:26:23 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD1D1D2DD;
        Fri, 31 Mar 2023 02:26:22 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32V9Q0Wg056198;
        Fri, 31 Mar 2023 04:26:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1680254760;
        bh=gIvlurnr4TzVrOK7Fbvtp8wI7+jYvwfr27GEkxvhbPA=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=IzQLNJF/SDsPyx/Fc36h8FywkXOM7ig6ENaHw0drRrR8/BCcEQ3GLTmNVII8rDi4z
         YSialPbAahobwZCkpZxpUIc+bdY4YQWjx3kK3ed8ZGMkBLrZzeHbHtIoMWyOhu5fK7
         pIdSENoXx9/uSowHlqOExZDjNIG6gK5rAxGt2wNo=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32V9Q0H8016793
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Mar 2023 04:26:00 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 31
 Mar 2023 04:26:00 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 31 Mar 2023 04:26:00 -0500
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32V9PuHs031936;
        Fri, 31 Mar 2023 04:25:57 -0500
Message-ID: <7a9c96f4-6a94-4a2c-18f5-95f7246e10d5@ti.com>
Date:   Fri, 31 Mar 2023 14:55:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <rogerq@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next 2/2] net: ethernet: ti: am65-cpsw: Enable USXGMII
 mode for J784S4 CPSW9G
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
References: <20230331065110.604516-1-s-vadapalli@ti.com>
 <20230331065110.604516-3-s-vadapalli@ti.com>
 <ZCaSXQFZ/e/JIDEj@shell.armlinux.org.uk>
 <54c3964b-5dd8-c55e-08db-61df4a07797c@ti.com>
 <ZCaYve8wYl15YRxh@shell.armlinux.org.uk>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <ZCaYve8wYl15YRxh@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Russell,

On 31/03/23 13:54, Russell King (Oracle) wrote:
> On Fri, Mar 31, 2023 at 01:35:10PM +0530, Siddharth Vadapalli wrote:
>> Hello Russell,
>>
>> Thank you for reviewing the patch.
>>
>> On 31/03/23 13:27, Russell King (Oracle) wrote:
>>> On Fri, Mar 31, 2023 at 12:21:10PM +0530, Siddharth Vadapalli wrote:
>>>> TI's J784S4 SoC supports USXGMII mode. Add USXGMII mode to the
>>>> extra_modes member of the J784S4 SoC data. Additionally, configure the
>>>> MAC Control register for supporting USXGMII mode. Also, for USXGMII
>>>> mode, include MAC_5000FD in the "mac_capabilities" member of struct
>>>> "phylink_config".
>>>
>>> I don't think TI "get" phylink at all...
>>>
>>>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>> index 4b4d06199b45..ab33e6fe5b1a 100644
>>>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>>>> @@ -1555,6 +1555,8 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
>>>>  		mac_control |= CPSW_SL_CTL_GIG;
>>>>  	if (interface == PHY_INTERFACE_MODE_SGMII)
>>>>  		mac_control |= CPSW_SL_CTL_EXT_EN;
>>>> +	if (interface == PHY_INTERFACE_MODE_USXGMII)
>>>> +		mac_control |= CPSW_SL_CTL_XGIG | CPSW_SL_CTL_XGMII_EN;
>>>
>>> The configuration of the interface mode should *not* happen in
>>> mac_link_up(), but should happen in e.g. mac_config().
>>
>> I will move all the interface mode associated configurations to mac_config() in
>> the v2 series.
> 
> Looking at the whole of mac_link_up(), could you please describe what
> effect these bits are having:
> 
> 	CPSW_SL_CTL_GIG
> 	CPSW_SL_CTL_EXT_EN
> 	CPSW_SL_CTL_IFCTL_A

CPSW_SL_CTL_GIG corresponds to enabling Gigabit mode (full duplex only).
CPSW_SL_CTL_EXT_EN when set enables in-band mode of operation and when cleared
enables forced mode of operation.
CPSW_SL_CTL_IFCTL_A is used to set the RMII link speed (0=10 mbps, 1=100 mbps).

Regards,
Siddharth.
