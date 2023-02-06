Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354D768B39A
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 02:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjBFBF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 20:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBFBF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 20:05:57 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328461A973;
        Sun,  5 Feb 2023 17:05:53 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 6F6CD24E20D;
        Mon,  6 Feb 2023 09:05:45 +0800 (CST)
Received: from EXMBX073.cuchost.com (172.16.6.83) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 6 Feb
 2023 09:05:45 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX073.cuchost.com
 (172.16.6.83) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 6 Feb
 2023 09:05:43 +0800
Message-ID: <5daccff5-6f51-4ee3-29ca-a2ae32c6780e@starfivetech.com>
Date:   Mon, 6 Feb 2023 09:05:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 0/7] Add Ethernet driver for StarFive JH7110 SoC
Content-Language: en-US
To:     Conor Dooley <conor@kernel.org>
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
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
 <Y8h/D7I7/2KhgM00@spud>
 <81217dc9-5673-f7eb-3114-b39de8302687@starfivetech.com>
 <958E7B1C-E0FF-416A-85AD-783682BA8B54@kernel.org>
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <958E7B1C-E0FF-416A-85AD-783682BA8B54@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX073.cuchost.com
 (172.16.6.83)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/2/4 22:22, Conor Dooley wrote:
> 
> 
> On 3 February 2023 04:02:54 GMT+01:00, yanhong wang <yanhong.wang@starfivetech.com> wrote:
>>
>>
>>On 2023/1/19 7:21, Conor Dooley wrote:
>>> Hey Yanhong!
>>> 
>>> On Wed, Jan 18, 2023 at 02:16:54PM +0800, Yanhong Wang wrote:
>>>> This series adds ethernet support for the StarFive JH7110 RISC-V SoC. The series
>>>> includes MAC driver. The MAC version is dwmac-5.20 (from Synopsys DesignWare).
>>>> For more information and support, you can visit RVspace wiki[1].
>>>> 	
>>>> This patchset should be applied after the patchset [2], [3], [4].
>>>> [1] https://wiki.rvspace.org/
>>>> [2] https://lore.kernel.org/all/20221118010627.70576-1-hal.feng@starfivetech.com/
>>>> [3] https://lore.kernel.org/all/20221118011108.70715-1-hal.feng@starfivetech.com/
>>>> [4] https://lore.kernel.org/all/20221118011714.70877-1-hal.feng@starfivetech.com/
>>> 
>>> I've got those series applied, albeit locally, since they're not ready,
>>> but I cannot get the Ethernet to work properly on my board.
>>> I boot all of my dev boards w/ tftp, and the visionfive2 is no exception.
>>> The fact that I am getting to the kernel in the first place means the
>>> ethernet is working in the factory supplied U-Boot [1].
>>> 
>>> However, in Linux this ethernet port does not appear to work at all.
>>> The other ethernet port is functional in Linux, but not in the factory
>>> supplied U-Boot.
>>> 
>>> Is this a known issue? If it's not, I'll post the logs somewhere for
>>> you. In case it is relevant, my board is a v1.2a.
>>> 
>>> Thanks,
>>> Conor.
>>> 
>>> 1 - U-Boot 2021.10 (Oct 31 2022 - 12:11:37 +0800), Build: jenkins-VF2_515_Branch_SDK_Release-10
>>
>>
>>No, this is not a issue. 
>>These patches need to rely on the yt8531 phy driver of motorcomm company
>>and the corresponding clock delay configuration to work normally, 
>>and the yt8531 phy driver is being submitted. I have applied the
>>motorcomm patchs during my test on board v1.2b, so the ethernet cannot work without
>>the application of the motorcomm patchs. 
>>
>>For the patchs of yt8531, see [1]
>>
>>1 - https://patchwork.kernel.org/project/netdevbpf/cover/20230202030037.9075-1-Frank.Sae@motor-comm.com/
> 
> Please put that info into the cover of the next round of your submission then.
> 

I will put the info into the cover letter in the next version.

> Thanks,
> Conor.
> 
