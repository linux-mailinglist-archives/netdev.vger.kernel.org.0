Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226406E660A
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 15:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjDRNez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 09:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjDRNey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 09:34:54 -0400
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E712E40;
        Tue, 18 Apr 2023 06:34:49 -0700 (PDT)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 496C124DBBD;
        Tue, 18 Apr 2023 21:34:47 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 18 Apr
 2023 21:34:47 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 18 Apr
 2023 21:34:45 +0800
Message-ID: <44908c89-1e77-8521-d5cd-2bbe7affa04c@starfivetech.com>
Date:   Tue, 18 Apr 2023 21:34:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [-net-next v12 0/6] Add Ethernet driver for StarFive JH7110 SoC
Content-Language: en-US
To:     <patchwork-bot+netdevbpf@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <kernel@esmil.dk>,
        <pmmoreir@synopsys.com>, <richardcochran@gmail.com>,
        <conor@kernel.org>, <paul.walmsley@sifive.com>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <pgwipeout@gmail.com>,
        <yanhong.wang@starfivetech.com>, <tomm.merciai@gmail.com>
References: <20230417100251.11871-1-samin.guo@starfivetech.com>
 <168181742075.8442.13068337635820008574.git-patchwork-notify@kernel.org>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <168181742075.8442.13068337635820008574.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Re: [-net-next v12 0/6] Add Ethernet driver for StarFive JH7110 SoC
From: patchwork-bot+netdevbpf@kernel.org
to: Samin Guo <samin.guo@starfivetech.com>
data: 2023/4/18

> Hello:
> 
> This series was applied to netdev/net-next.git (main)
> by Paolo Abeni <pabeni@redhat.com>:
> 
> On Mon, 17 Apr 2023 18:02:45 +0800 you wrote:
>> This series adds ethernet support for the StarFive JH7110 RISC-V SoC,
>> which includes a dwmac-5.20 MAC driver (from Synopsys DesignWare).
>> This series has been tested and works fine on VisionFive-2 v1.2A and
>> v1.3B SBC boards.
>>
>> For more information and support, you can visit RVspace wiki[1].
>> You can simply review or test the patches at the link [2].
>> This patchset should be applied after the patchset [3] [4].
>>
>> [...]
> 
> Here is the summary with links:
>   - [-net-next,v12,1/6] dt-bindings: net: snps,dwmac: Add dwmac-5.20 version
>     https://git.kernel.org/netdev/net-next/c/13f9351180aa
>   - [-net-next,v12,2/6] net: stmmac: platform: Add snps,dwmac-5.20 IP compatible string
>     https://git.kernel.org/netdev/net-next/c/65a1d72f0c7c
>   - [-net-next,v12,3/6] dt-bindings: net: snps,dwmac: Add 'ahb' reset/reset-name
>     https://git.kernel.org/netdev/net-next/c/843f603762a5
>   - [-net-next,v12,4/6] dt-bindings: net: Add support StarFive dwmac
>     https://git.kernel.org/netdev/net-next/c/b76eaf7d7ede
>   - [-net-next,v12,5/6] net: stmmac: Add glue layer for StarFive JH7110 SoC
>     https://git.kernel.org/netdev/net-next/c/4bd3bb7b4526
>   - [-net-next,v12,6/6] net: stmmac: dwmac-starfive: Add phy interface settings
>     https://git.kernel.org/netdev/net-next/c/b4a5afa51cee
> 
> You are awesome, thank you!


Thank you so much! Looking forward to seeing it in v6.4.

Best regards,
Samin
