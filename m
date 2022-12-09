Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30A7647C40
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 03:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiLIC1I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Dec 2022 21:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiLIC1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 21:27:07 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD25E442FE;
        Thu,  8 Dec 2022 18:27:04 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 2ED5F24DD6E;
        Fri,  9 Dec 2022 10:26:58 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 9 Dec
 2022 10:26:58 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX173.cuchost.com
 (172.16.6.93) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 9 Dec
 2022 10:26:56 +0800
Message-ID: <236b1b83-9bda-ac09-ea09-9701dccb4ac6@starfivetech.com>
Date:   Fri, 9 Dec 2022 10:26:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 2/7] net: stmmac: platform: Add snps,dwmac-5.20 IP
 compatible string
Content-Language: en-US
To:     Ben Dooks <ben.dooks@codethink.co.uk>
CC:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-3-yanhong.wang@starfivetech.com>
 <f6fd99d22a025377e176890cc7641ab9@codethink.co.uk>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <f6fd99d22a025377e176890cc7641ab9@codethink.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/9 9:59, Ben Dooks wrote:
> 
> 
> On 2022-12-01 09:02, Yanhong Wang wrote:
>> Add "snps,dwmac-5.20" compatible string for 5.20 version that can avoid
>> to define some platform data in the glue layer.
>>
>> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>> ---
>>  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
>> b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
>> index 50f6b4a14be4..cc3b701af802 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
>> @@ -519,7 +519,8 @@ stmmac_probe_config_dt(struct platform_device
>> *pdev, u8 *mac)
>>      if (of_device_is_compatible(np, "snps,dwmac-4.00") ||
>>          of_device_is_compatible(np, "snps,dwmac-4.10a") ||
>>          of_device_is_compatible(np, "snps,dwmac-4.20a") ||
>> -        of_device_is_compatible(np, "snps,dwmac-5.10a")) {
>> +        of_device_is_compatible(np, "snps,dwmac-5.10a") ||
>> +        of_device_is_compatible(np, "snps,dwmac-5.20")) {
>>          plat->has_gmac4 = 1;
>>          plat->has_gmac = 0;
>>          plat->pmt = 1;
> 
> out of interest, is the version of the ip autodetectable yet?
> also, we would be better off if having an if (version > 4) check if we use the standard snps ip block code headers
> 

Yes, the version of the ip is autodetectable. It is also possible to use the standard "snps, dwmac-5.10a" definition on JH7110（has been tested on the VisionFive v2 boards and works normally）, do you have any better suggestions?
