Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076BA6B1898
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 02:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCIBQv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Mar 2023 20:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCIBQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 20:16:49 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C5828865;
        Wed,  8 Mar 2023 17:16:43 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 29B5524E041;
        Thu,  9 Mar 2023 09:16:36 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 9 Mar
 2023 09:16:36 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 9 Mar
 2023 09:16:35 +0800
Message-ID: <2097647b-08c4-765b-990e-432961020d17@starfivetech.com>
Date:   Thu, 9 Mar 2023 09:16:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 07/12] dt-bindings: net: starfive,jh7110-dwmac: Add
 starfive,syscon
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
CC:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-8-samin.guo@starfivetech.com>
 <20230308220309.GA3914591-robh@kernel.org>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <20230308220309.GA3914591-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



-------- 原始信息 --------
主题: Re: [PATCH v5 07/12] dt-bindings: net: starfive,jh7110-dwmac: Add starfive,syscon
From: Rob Herring <robh@kernel.org>

> On Fri, Mar 03, 2023 at 04:59:23PM +0800, Samin Guo wrote:
>> A phandle to syscon with two arguments that configure phy mode.
> 
> This change belongs in patch 4.
> 
Thank you for pointing out that the next version will be merged into patch4


Best regards,
Samin

>>
>> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
>> ---
>>  .../bindings/net/starfive,jh7110-dwmac.yaml         | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
>> index ca49f08d50dd..79ae635db0a5 100644
>> --- a/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
>> +++ b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
>> @@ -58,6 +58,18 @@ properties:
>>        Tx clock is provided by external rgmii clock.
>>      type: boolean
>>  
>> +  starfive,syscon:
>> +    $ref: /schemas/types.yaml#/definitions/phandle-array
>> +    items:
>> +      - items:
>> +          - description: phandle to syscon that configures phy mode
>> +          - description: Offset of phy mode selection
>> +          - description: Mask of phy mode selection
>> +    description:
>> +      A phandle to syscon with two arguments that configure phy mode.
>> +      The argument one is the offset of phy mode selection, the
>> +      argument two is the mask of phy mode selection.
>> +
>>  allOf:
>>    - $ref: snps,dwmac.yaml#
>>  
>> @@ -96,6 +108,7 @@ examples:
>>          snps,en-tx-lpi-clockgating;
>>          snps,txpbl = <16>;
>>          snps,rxpbl = <16>;
>> +        starfive,syscon = <&aon_syscon 0xc 0x1c0000>;
>>          phy-handle = <&phy0>;
>>  
>>          mdio {
>> -- 
>> 2.17.1
>>

