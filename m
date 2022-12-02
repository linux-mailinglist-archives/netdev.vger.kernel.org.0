Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2678663FE5D
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 03:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiLBCyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 21:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiLBCyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 21:54:01 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341FD8DBD6;
        Thu,  1 Dec 2022 18:54:00 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id EFF2324E059;
        Fri,  2 Dec 2022 10:53:53 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 2 Dec
 2022 10:53:53 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX173.cuchost.com
 (172.16.6.93) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 2 Dec
 2022 10:53:52 +0800
Message-ID: <22123903-ee95-a82e-d792-01417ceb63b1@starfivetech.com>
Date:   Fri, 2 Dec 2022 10:53:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 1/7] dt-bindings: net: snps,dwmac: Add compatible
 string for dwmac-5.20 version.
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
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-2-yanhong.wang@starfivetech.com>
 <277f9665-e691-b0ad-e6ef-e11acddc2006@linaro.org>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <277f9665-e691-b0ad-e6ef-e11acddc2006@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX173.cuchost.com
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



On 2022/12/2 0:18, Krzysztof Kozlowski wrote:
> On 01/12/2022 10:02, Yanhong Wang wrote:
>> Add dwmac-5.20 version to snps.dwmac.yaml
> 
> Drop full stop from subject and add it here instead.
> 

Will update in the next version.

>> 
>> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> 
> Two people contributed this one single line?
> 

Emil made this patch and I submitted it.

> Best regards,
> Krzysztof
> 
