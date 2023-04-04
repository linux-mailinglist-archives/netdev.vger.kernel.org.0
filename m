Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB546D56A5
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbjDDCTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjDDCTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:19:17 -0400
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A021BEA;
        Mon,  3 Apr 2023 19:19:11 -0700 (PDT)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 0494C24E251;
        Tue,  4 Apr 2023 10:19:08 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 4 Apr
 2023 10:19:08 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 4 Apr
 2023 10:19:06 +0800
Message-ID: <d7f698cb-5371-25a7-2f44-0132b4d3f63a@starfivetech.com>
Date:   Tue, 4 Apr 2023 10:19:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [-net-next v10 5/6] net: stmmac: Add glue layer for StarFive
 JH7110 SoC
Content-Language: en-US
To:     Conor Dooley <conor@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jose Abreu <joabreu@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "Palmer Dabbelt" <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        "Tommaso Merciai" <tomm.merciai@gmail.com>
References: <20230403065932.7187-1-samin.guo@starfivetech.com>
 <20230403065932.7187-6-samin.guo@starfivetech.com>
 <20230403-data-dawdler-afaaaf6fa87c@spud>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <20230403-data-dawdler-afaaaf6fa87c@spud>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.3 required=5.0 tests=NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Re: [-net-next v10 5/6] net: stmmac: Add glue layer for StarFive JH7110 SoC
From: Conor Dooley <conor@kernel.org>
to: Samin Guo <samin.guo@starfivetech.com>
data: 2023/4/4

> On Mon, Apr 03, 2023 at 02:59:31PM +0800, Samin Guo wrote:
> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 6b6b67468b8f..a9684b3c24f9 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -19909,6 +19909,7 @@ STARFIVE DWMAC GLUE LAYER
>>  M:	Emil Renner Berthing <kernel@esmil.dk>
>>  M:	Samin Guo <samin.guo@starfivetech.com>
>>  S:	Maintained
> 
>> +F:	Documentation/devicetree/bindings/net/dwmac-starfive.c
> 
> Funny name you got for a binding there mate!

Oh, can't believe I made this mistake, will Fix  :)
Also, are there any other comments?

Best regards,
Samin
