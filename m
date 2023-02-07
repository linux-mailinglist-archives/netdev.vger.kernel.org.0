Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01D468CCB1
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 03:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjBGCoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 21:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBGCoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 21:44:15 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC2E11642;
        Mon,  6 Feb 2023 18:44:12 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 58D0624E1FC;
        Tue,  7 Feb 2023 10:43:58 +0800 (CST)
Received: from EXMBX073.cuchost.com (172.16.6.83) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 7 Feb
 2023 10:43:58 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX073.cuchost.com
 (172.16.6.83) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 7 Feb
 2023 10:43:57 +0800
Message-ID: <c9ab22b5-3ffb-d034-b8b8-b056b82a96ce@starfivetech.com>
Date:   Tue, 7 Feb 2023 10:43:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 2/7] dt-bindings: net: snps,dwmac: Update the maxitems
 number of resets and reset-names
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
 <20230118061701.30047-3-yanhong.wang@starfivetech.com>
 <15a87640-d8c7-d7aa-bdfb-608fa2e497cb@linaro.org>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <15a87640-d8c7-d7aa-bdfb-608fa2e497cb@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS061.cuchost.com (172.16.6.21) To EXMBX073.cuchost.com
 (172.16.6.83)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/1/18 23:47, Krzysztof Kozlowski wrote:
> On 18/01/2023 07:16, Yanhong Wang wrote:
>> Some boards(such as StarFive VisionFive v2) require more than one value
>> which defined by resets property, so the original definition can not
>> meet the requirements. In order to adapt to different requirements,
>> adjust the maxitems number definition.
>> 
>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>> ---
>>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 9 +++------
>>  1 file changed, 3 insertions(+), 6 deletions(-)
>> 
>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> index e26c3e76ebb7..baf2c5b9e92d 100644
>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> @@ -133,12 +133,9 @@ properties:
>>          - ptp_ref
>>  
>>    resets:
>> -    maxItems: 1
> 
> Also, this does not make sense on its own and messes constraints for all
> other users. So another no for entire patch.
> 

Thanks. Change the properties of 'resets' and reset-names like this:

  resets:
    minItems: 1
    maxItems: 2

  reset-names:
    minItems: 1
    maxItems: 2

Is it right?  Do you have any other better suggestions?

> Best regards,
> Krzysztof
> 
