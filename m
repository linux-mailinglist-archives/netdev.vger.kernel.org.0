Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E08265724A
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 04:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiL1DXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 22:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiL1DXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 22:23:42 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B4A10DC;
        Tue, 27 Dec 2022 19:23:36 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 7D12C24E232;
        Wed, 28 Dec 2022 11:23:33 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 28 Dec
 2022 11:23:33 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX173.cuchost.com
 (172.16.6.93) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 28 Dec
 2022 11:23:31 +0800
Message-ID: <e03fb7bc-b196-bc8a-b396-fab8686d396b@starfivetech.com>
Date:   Wed, 28 Dec 2022 11:23:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 5/9] dt-bindings: net: motorcomm: add support for
 Motorcomm YT8531
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
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
 <20221216070632.11444-6-yanhong.wang@starfivetech.com>
 <994718d8-f3ee-af5e-bda7-f913f66597ce@linaro.org>
 <134a2ead-e272-c32e-b14f-a9e98c8924ac@starfivetech.com>
 <c296cf6b-6c50-205d-d5f5-6095c0a6c523@linaro.org>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <c296cf6b-6c50-205d-d5f5-6095c0a6c523@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/27 17:52, Krzysztof Kozlowski wrote:
> On 27/12/2022 10:38, yanhong wang wrote:
>>>
>>> This must be false. After referencing ethernet-phy this should be
>>> unevaluatedProperties: false.
>>>
>>>
>> 
>> Thanks. Parts of this patch exist already, after discussion unanimity was achieved,
>> i will remove the parts of YT8531 in the next version.
> 
> I don't understand what does it mean. You sent duplicated patch? If so,
> please do not... you waste reviewers time.
> 
> Anyway this entire patch does not meet criteria for submission at all,
> so please start over from example-schema.
> 

Sorry, maybe I didn't make it clear, which led to misunderstanding. Motorcomm Inc is also 
carrying out the upstream of YT8531, and my patch will be duplicated and conflicted 
with their submission. By communicating with the developers of Motorcomm Inc, the part 
of YT8531 will be submitted by Motorcomm Inc, so my submission about YT8531 will be withdrawn.

> Best regards,
> Krzysztof
> 
