Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9775B6400F6
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 08:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbiLBHQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 02:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiLBHQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 02:16:34 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF5F60B75;
        Thu,  1 Dec 2022 23:16:33 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 1C61624E15C;
        Fri,  2 Dec 2022 15:16:32 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 2 Dec
 2022 15:16:32 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX173.cuchost.com
 (172.16.6.93) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 2 Dec
 2022 15:16:30 +0800
Message-ID: <1d3f1334-b6bf-57cb-7f7e-48e3c08a5560@starfivetech.com>
Date:   Fri, 2 Dec 2022 15:16:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 3/7] dt-bindings: net: Add bindings for StarFive dwmac
Content-Language: en-US
To:     Conor Dooley <conor@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
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
 <20221201090242.2381-4-yanhong.wang@starfivetech.com>
 <36565cc1-3c48-0fa8-f98b-414a7ac8f5bf@linaro.org> <Y4jl6awCMFgZsQGC@spud>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <Y4jl6awCMFgZsQGC@spud>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS065.cuchost.com (172.16.6.25) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/2 1:35, Conor Dooley wrote:
> On Thu, Dec 01, 2022 at 05:21:04PM +0100, Krzysztof Kozlowski wrote:
>> On 01/12/2022 10:02, Yanhong Wang wrote:
>> > Add bindings for the StarFive dwmac module on the StarFive RISC-V SoCs.
>> 
>> Subject: drop second, redundant "bindings".
>> 
>> > 
>> > Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>> > ---
>> >  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>> > +properties:
>> > +  compatible:
>> > +    oneOf:
>> 
>> Drop oneOf. You do not have more cases here.
>> 
>> > +      - items:
>> > +          - enum:
>> > +               - starfive,dwmac
>> 
>> Wrong indentation.... kind of expected since you did not test the bindings.
>> 
>> > +          - const: snps,dwmac-5.20
> 
> Disclaimer: no familiarity with the version info with DW stuff
> 
> Is it a bit foolish to call this binding "starfive,dwmac"? Could there
> not be another StarFive SoC in the future that uses another DW mac IP
> version & this would be better off as "starfive,jh7110-dwmac" or similar?
> 

The StarFive JH8100 SoC in the future that uses the same mac IP version, so call this binding "starfive,dwmac".

> Thanks,
> Conor.
> 
