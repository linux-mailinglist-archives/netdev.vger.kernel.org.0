Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1D86AD42E
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 02:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjCGBn5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Mar 2023 20:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjCGBnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 20:43:53 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D110C46AF;
        Mon,  6 Mar 2023 17:43:41 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 2164C24E0D8;
        Tue,  7 Mar 2023 09:43:40 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 7 Mar
 2023 09:43:40 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 7 Mar
 2023 09:43:39 +0800
Message-ID: <8bd8654e-4bba-c718-4b17-5291e70f05fe@starfivetech.com>
Date:   Tue, 7 Mar 2023 09:43:36 +0800
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
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <CAJM55Z_8m42vfoPDicTP18S6Z1ZXYbFeS1edTjzYVB3Kq2xFeQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2023/3/6 21:00:19, Emil Renner Berthing 写道:
> On Fri, 3 Mar 2023 at 10:01, Samin Guo <samin.guo@starfivetech.com> wrote:
>> v1.2A gmac0 uses motorcomm YT8531(rgmii-id) PHY, and needs delay
>> configurations.
>>
>> v1.2A gmac1 uses motorcomm YT8512(rmii) PHY, and needs to
>> switch rx and rx to external clock sources.
>>
>> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
>> ---
>>  .../starfive/jh7110-starfive-visionfive-2-v1.2a.dts | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts
>> index 4af3300f3cf3..205a13d8c8b1 100644
>> --- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts
>> +++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.2a.dts
>> @@ -11,3 +11,16 @@
>>         model = "StarFive VisionFive 2 v1.2A";
>>         compatible = "starfive,visionfive-2-v1.2a", "starfive,jh7110";
>>  };
>> +
>> +&gmac1 {
>> +       phy-mode = "rmii";
>> +       assigned-clocks = <&syscrg JH7110_SYSCLK_GMAC1_TX>,
>> +                         <&syscrg JH7110_SYSCLK_GMAC1_RX>;
>> +       assigned-clock-parents = <&syscrg JH7110_SYSCLK_GMAC1_RMII_RTX>,
>> +                                <&syscrg JH7110_SYSCLK_GMAC1_RMII_RTX>;
>> +};
>> +
>> +&phy0 {
>> +       rx-internal-delay-ps = <1900>;
>> +       tx-internal-delay-ps = <1350>;
>> +};
> 
> Here you're not specifying the internal delays for phy1 which means it
> defaults to 1950ps for both rx and tx. Is that right or did you mean
> to set them to 0 like the v1.3b phy1?

Hi, emil, usually, only 1000M (rgmii) needs to configure the delay, and 100M(rmii) does not.
> 
> Also your u-boot seems to set what the linux phy driver calls
> motorcomm,keep-pll-enabled and motorcomm,auto-sleep-disabled for all
> the phys. Did you leave those out on purpose?

Hi, Emil, We did configure motorcomm,auto-sleep-disabled for yt8512 in uboot, 
but Yutai upstream's Linux driver only yt8521/yt8531 supports this property. 
Yt8512 is a Generic PHY driver and does not support the configuration of 
motorcomm,auto-sleep-disabled and motorcomm,keep-pll-enabled.

And without configuring these two attributes, vf2-1.2a gmac1 also works normally.


Best regards,
Samin
> 
>> --
>> 2.17.1
>>
>>
>> _______________________________________________
>> linux-riscv mailing list
>> linux-riscv@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-riscv

-- 
Best regards,
Samin
