Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B67689113
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjBCHkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 02:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjBCHkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:40:21 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1A392C26;
        Thu,  2 Feb 2023 23:40:14 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 2DE5824E1D4;
        Fri,  3 Feb 2023 15:40:12 +0800 (CST)
Received: from EXMBX073.cuchost.com (172.16.6.83) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 3 Feb
 2023 15:40:12 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX073.cuchost.com
 (172.16.6.83) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 3 Feb
 2023 15:40:10 +0800
Message-ID: <048b3ab0-7c13-b7f7-403c-f4e1d5574a10@starfivetech.com>
Date:   Fri, 3 Feb 2023 15:40:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 6/7] riscv: dts: starfive: jh7110: Add ethernet device
 node
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
 <20230118061701.30047-7-yanhong.wang@starfivetech.com>
 <55f020de-6058-67d2-ea68-6006186daee3@linaro.org>
 <f22614b4-80ae-8b16-b53e-e43c44722668@starfivetech.com>
 <870f6ec5-5378-760b-7a30-324ee2d178cf@linaro.org>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <870f6ec5-5378-760b-7a30-324ee2d178cf@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS061.cuchost.com (172.16.6.21) To EXMBX073.cuchost.com
 (172.16.6.83)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/2/3 15:09, Krzysztof Kozlowski wrote:
> On 03/02/2023 04:14, yanhong wang wrote:
>> 
>> 
>> On 2023/1/18 23:51, Krzysztof Kozlowski wrote:
>>> On 18/01/2023 07:17, Yanhong Wang wrote:
>>>> Add JH7110 ethernet device node to support gmac driver for the JH7110
>>>> RISC-V SoC.
>>>>
>>>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>>>> ---
>>>>  arch/riscv/boot/dts/starfive/jh7110.dtsi | 93 ++++++++++++++++++++++++
>>>>  1 file changed, 93 insertions(+)
>>>>
>>>> diff --git a/arch/riscv/boot/dts/starfive/jh7110.dtsi b/arch/riscv/boot/dts/starfive/jh7110.dtsi
>>>> index c22e8f1d2640..c6de6e3b1a25 100644
>>>> --- a/arch/riscv/boot/dts/starfive/jh7110.dtsi
>>>> +++ b/arch/riscv/boot/dts/starfive/jh7110.dtsi
>>>> @@ -433,5 +433,98 @@
>>>>  			reg-shift = <2>;
>>>>  			status = "disabled";
>>>>  		};
>>>> +
>>>> +		stmmac_axi_setup: stmmac-axi-config {
>>>
>>> Why your bindings example is different?
>>>
>> 
>> There are two gmacs on the StarFive VF2 board, and the two
>> gmacs use the same configuration on axi, so the 
>> stmmac_axi_setup is independent, which is different
>> from the bindings example.
>> 
>> 
>>> Were the bindings tested? Ahh, no they were not... Can you send only
>>> tested patches?
>>>
>>> Was this tested?
>>>
>> Yes, the bindings have been tested on the StarFive VF2 board and work normally.
> 
> Then please tell me how did you test the bindings on the board? How is
> it even possible and how the board is related to bindings? As you could
> easily see from Rob's reply they fail, so I have doubts that they were
> tested. If you still claim they were - please paste the output from
> testing command.
> 

Sorry, I didn't check all the bindings, only the modified ones, the command 
used is as follows: 
"make dt_binding_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/snps,dwmac.yaml"
"make dt_binding_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml"

> 
> Best regards,
> Krzysztof
> 
