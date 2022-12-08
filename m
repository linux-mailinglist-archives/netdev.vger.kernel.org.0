Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74AE646686
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiLHBeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiLHBeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:34:23 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E47B88B41;
        Wed,  7 Dec 2022 17:34:20 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 036A524E1BE;
        Thu,  8 Dec 2022 09:34:18 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 8 Dec
 2022 09:34:18 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX173.cuchost.com
 (172.16.6.93) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 8 Dec
 2022 09:34:16 +0800
Message-ID: <c897c858-14d1-3059-7307-84df9460e86e@starfivetech.com>
Date:   Thu, 8 Dec 2022 09:34:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 1/7] dt-bindings: net: snps,dwmac: Add compatible
 string for dwmac-5.20 version.
Content-Language: en-US
To:     Emil Renner Berthing <emil.renner.berthing@canonical.com>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>
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
 <20221201090242.2381-2-yanhong.wang@starfivetech.com>
 <277f9665-e691-b0ad-e6ef-e11acddc2006@linaro.org>
 <22123903-ee95-a82e-d792-01417ceb63b1@starfivetech.com>
 <3a9ef360-73c3-cf26-3eca-4903b9a04ea3@linaro.org>
 <CAJM55Z-iLy1fZmoyk3FU7oDQcKBk6APYf-cbamKr7Gjx+NaoTQ@mail.gmail.com>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <CAJM55Z-iLy1fZmoyk3FU7oDQcKBk6APYf-cbamKr7Gjx+NaoTQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/7 21:56, Emil Renner Berthing wrote:
> On Fri, 2 Dec 2022 at 09:04, Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org> wrote:
>>
>> On 02/12/2022 03:53, yanhong wang wrote:
>> >
>> >
>> > On 2022/12/2 0:18, Krzysztof Kozlowski wrote:
>> >> On 01/12/2022 10:02, Yanhong Wang wrote:
>> >>> Add dwmac-5.20 version to snps.dwmac.yaml
>> >>
>> >> Drop full stop from subject and add it here instead.
>> >>
>> >
>> > Will update in the next version.
>> >
>> >>>
>> >>> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
>> >>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>> >>
>> >> Two people contributed this one single line?
>> >>
>> >
>> > Emil made this patch and I submitted it.
>>
>> If Emil made this patch, then your From field is incorrect.
> 
> Yes, please don't change the author of the commits you cherry-picked
> from my tree.
> 
> But now I'm curious. Did you check with your colleagues that the dwmac
> IP on the SoC is in fact version 5.20?

I can confirm that the IP version is 5.20 on JH7110 SoC.

> This was just an educated guess from my side.
> 
> /Emil
> 
>> Best regards,
>> Krzysztof
>>
>>
>> _______________________________________________
>> linux-riscv mailing list
>> linux-riscv@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-riscv
