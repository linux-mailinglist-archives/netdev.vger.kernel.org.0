Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358006AFD32
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 04:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjCHDBq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Mar 2023 22:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjCHDBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 22:01:45 -0500
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABE0AA701;
        Tue,  7 Mar 2023 19:01:37 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id A528424E2E2;
        Wed,  8 Mar 2023 11:01:24 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 8 Mar
 2023 11:01:24 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 8 Mar
 2023 11:01:23 +0800
Message-ID: <aa404236-9845-3a3a-3327-b3a075b37a32@starfivetech.com>
Date:   Wed, 8 Mar 2023 11:01:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 11/12] riscv: dts: starfive: visionfive-2-v1.2a: Add
 gmac+phy's delay configuration
Content-Language: en-US
To:     Emil Renner Berthing <emil.renner.berthing@canonical.com>
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
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-12-samin.guo@starfivetech.com>
 <CAJM55Z_8m42vfoPDicTP18S6Z1ZXYbFeS1edTjzYVB3Kq2xFeQ@mail.gmail.com>
 <8bd8654e-4bba-c718-4b17-5291e70f05fe@starfivetech.com>
 <CAJM55Z8-65ENJHfSUOTd+FSNx2b-mYF1L64CKT+Gez2jK3Qr2Q@mail.gmail.com>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <CAJM55Z8-65ENJHfSUOTd+FSNx2b-mYF1L64CKT+Gez2jK3Qr2Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS063.cuchost.com (172.16.6.23) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



-------- 原始信息 --------
主题: Re: [PATCH v5 11/12] riscv: dts: starfive: visionfive-2-v1.2a: Add gmac+phy's delay configuration
From: Emil Renner Berthing <emil.renner.berthing@canonical.com>
收件人: Guo Samin <samin.guo@starfivetech.com>
日期: 2023/3/7

> On Tue, 7 Mar 2023 at 02:43, Guo Samin <samin.guo@starfivetech.com> wrote:
>> 在 2023/3/6 21:00:19, Emil Renner Berthing 写道:
>>> On Fri, 3 Mar 2023 at 10:01, Samin Guo <samin.guo@starfivetech.com> wrote:
>>>> v1.2A gmac0 uses motorcomm YT8531(rgmii-id) PHY, and needs delay
>>>> configurations.
>>>>
>>>> v1.2A gmac1 uses motorcomm YT8512(rmii) PHY, and needs to
>>>> switch rx and rx to external clock sources.
>>>>
>>>> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
>>>> ---
>>>>  .../starfive/jh7110-starfive-visionfive-2-v1.2a.dts | 13 +++++++++++++
>>>>  1 file changed, 13 insertions(+)
>>>>
>>>> diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts
>>>> index 4af3300f3cf3..205a13d8c8b1 100644
>>>> --- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts
>>>> +++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts
>>>> @@ -11,3 +11,16 @@
>>>>         model = "StarFive VisionFive 2 v1.2A";
>>>>         compatible = "starfive,visionfive-2-v1.2a", "starfive,jh7110";
>>>>  };
>>>> +
>>>> +&gmac1 {
>>>> +       phy-mode = "rmii";
>>>> +       assigned-clocks = <&syscrg JH7110_SYSCLK_GMAC1_TX>,
>>>> +                         <&syscrg JH7110_SYSCLK_GMAC1_RX>;
>>>> +       assigned-clock-parents = <&syscrg JH7110_SYSCLK_GMAC1_RMII_RTX>,
>>>> +                                <&syscrg JH7110_SYSCLK_GMAC1_RMII_RTX>;
>>>> +};
>>>> +
>>>> +&phy0 {
>>>> +       rx-internal-delay-ps = <1900>;
>>>> +       tx-internal-delay-ps = <1350>;
>>>> +};
>>>
>>> Here you're not specifying the internal delays for phy1 which means it
>>> defaults to 1950ps for both rx and tx. Is that right or did you mean
>>> to set them to 0 like the v1.3b phy1?
>>
>> Hi, emil, usually, only 1000M (rgmii) needs to configure the delay, and 100M(rmii) does not.
> 
> Ah, I see.
> 
>>> Also your u-boot seems to set what the linux phy driver calls
>>> motorcomm,keep-pll-enabled and motorcomm,auto-sleep-disabled for all
>>> the phys. Did you leave those out on purpose?
>>
>> Hi, Emil, We did configure motorcomm,auto-sleep-disabled for yt8512 in uboot,
>> but Yutai upstream's Linux driver only yt8521/yt8531 supports this property.
> 
> I'm confused. Is Yutai also Frank Sae? Because he is the one who added
> support for the yt8531 upstream.

My fault , Frank Sae is from Motorcomm, also known as Yutai. 
yt8531 ==> Yutai 8531
> 
>> Yt8512 is a Generic PHY driver and does not support the configuration of
>> motorcomm,auto-sleep-disabled and motorcomm,keep-pll-enabled.
> 
> Right phy1 of the 1.2a might use a different phy, but I'm also talking
> about phy0 and the v1.3b which does use the yt8531 right?
Right:
v1.3b: gmac0:yt8531   gmac1:yt8531
v1.2a: gmac0:yt8531   gmac1:yt8512
> 
>> And without configuring these two attributes, vf2-1.2a gmac1 also works normally.
> 
> Yes, but what I'm worried about is that it only works because u-boot
> initialises the PHYs and ethernet may stop working if you're using a
> different bootloader or Linux gains support for resetting the PHYs
> before use.
> 
I have tested that in uboot, use the sd card to start Linux, do not run network programs (do not use uboot to initialize phy and gmac),
and the network works normally in Linux.

Best regards,
Samin

>>
>> Best regards,
>> Samin
>>>
>>>> --
>>>> 2.17.1
>>>>
>>>>
>>>> _______________________________________________
>>>> linux-riscv mailing list
>>>> linux-riscv@lists.infradead.org
>>>> http://lists.infradead.org/mailman/listinfo/linux-riscv
>>
>> --
>> Best regards,
>> Samin

-- 
Best regards,
Samin
