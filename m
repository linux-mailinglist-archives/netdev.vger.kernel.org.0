Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D4E6930BA
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 12:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjBKLyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 06:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjBKLyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 06:54:49 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1683F23121;
        Sat, 11 Feb 2023 03:54:18 -0800 (PST)
Received: from [192.168.1.90] (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id A68AF6602111;
        Sat, 11 Feb 2023 11:53:48 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676116430;
        bh=pg4cvypY8FQKYrpV9fWDZ348Gx/msla9+ReQno8Gwf4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TTpyL64WvTvjHDWR4s8teHDz+yxz7/0DnZ/kaLk9N9qvglrWYAPmktHIo44GAPyYM
         IS9aG4ozuS/c/j0GYEnQJzRRzOVQsEiyCw66j/flJaAQYmU64KNuqMlM62Hbm9Uw79
         tnHmsoTqFX7G8pwinGvFonBYPwbdcSXEy/ltMvBSgB1YnBCqiCRHWmF74eUoYnsHCQ
         S+BLhNB6xh17yQCRVtx3QPWslvxpr+CgZY5h2yYIpwBwZb+jKza/QvCZGdvw7JrNG6
         JP7mobsbJLD0IOfQw/t1JxgzAufgSsgFgdPQw3HtAw1NtL5igpApMWPUS9qKUnuw4H
         8IVCYNKbkvfDQ==
Message-ID: <b5fa8148-1dc6-b8a7-2f5d-95f0354197e6@collabora.com>
Date:   Sat, 11 Feb 2023 13:53:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH 00/12] Enable networking support for StarFive JH7100 SoC
Content-Language: en-US
To:     Conor Dooley <conor@kernel.org>
Cc:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com,
        arnd@arndb.de, prabhakar.csengg@gmail.com
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <Y+d36nz0xdfXmDI1@spud>
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
In-Reply-To: <Y+d36nz0xdfXmDI1@spud>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Conor,

On 2/11/23 13:11, Conor Dooley wrote:
> Hey Cristian!
> 
> +CC Arnd, Prabhakar
> 
> On Sat, Feb 11, 2023 at 05:18:09AM +0200, Cristian Ciocaltea wrote:
>> This patch series adds ethernet support for the StarFive JH7100 SoC and
>> makes it available for the StarFive VisionFive V1 and BeagleV Starlight
>> boards, although I could only validate on the former SBC.
>>
>> The work is heavily based on the reference implementation [1] and requires
>> the non-coherent DMA support provided by Emil via the Sifive Composable
>> Cache controller.
>>
>> Also note there is an overlap in "[PATCH 08/12] net: stmmac: Add glue layer
>> for StarFive JH7100 SoC" with the Yanhong Wang's upstreaming attempt [2]:
>> "[PATCH v4 5/7] net: stmmac: Add glue layer for StarFive JH7110 SoCs".
>>
>> Since I cannot test the JH7110 SoC, I dropped the support for it from Emil's
>> variant of the stmmac glue layer. Hence, we might need a bit of coordination
>> in order to get this properly merged.
> 
> To be honest, that one is the least of your worries sequencing wise.
> Anything doing non-coherent DMA on RISC-V that doesn't use instructions is
> dependant on Prabhakar's series:
> https://lore.kernel.org/linux-riscv/20230106185526.260163-1-prabhakar.mahadev-lad.rj@bp.renesas.com/#t
> That's kinda stalled out though, waiting on Arnd to make some changes to
> the cross-arch DMA code:
> https://lore.kernel.org/linux-riscv/ea4cb121-97e9-4365-861a-b3635fd34721@app.fastmail.com/

Thank you for pointing this out, I wasn't aware of it!

> I was talking to Emil about the non-coherent support at FOSDEM actually,
> and I see no real reason not to bring the JH7100 non-coherent support in
> if we are doing it for other SoCs.
> 
> So yeah, hopefully we shall get there at some point soonTM...

That would be great, I'll try to monitor the progress and re-spin the 
series as soon as the non-coherent support is figured out.

Regards,
Cristian

> Sorry,
> Conor.

>> [1] https://github.com/starfive-tech/linux/commits/visionfive
>> [2] https://lore.kernel.org/linux-riscv/20230118061701.30047-6-yanhong.wang@starfivetech.com/
>>
>> Cristian Ciocaltea (7):
>>    dt-bindings: riscv: sifive-ccache: Add compatible for StarFive JH7100
>>      SoC
>>    dt-bindings: riscv: sifive-ccache: Add 'uncached-offset' property
>>    dt-bindings: net: Add StarFive JH7100 SoC
>>    riscv: dts: starfive: Add dma-noncoherent for JH7100 SoC
>>    riscv: dts: starfive: jh7100: Add ccache DT node
>>    riscv: dts: starfive: jh7100: Add sysmain and gmac DT nodes
>>    riscv: dts: starfive: jh7100-common: Setup pinmux and enable gmac
>>
>> Emil Renner Berthing (5):
>>    soc: sifive: ccache: Add StarFive JH7100 support
>>    soc: sifive: ccache: Add non-coherent DMA handling
>>    riscv: Implement non-coherent DMA support via SiFive cache flushing
>>    dt-bindings: mfd: syscon: Add StarFive JH7100 sysmain compatible
>>    net: stmmac: Add glue layer for StarFive JH7100 SoC
>>
>>   .../devicetree/bindings/mfd/syscon.yaml       |   1 +
>>   .../devicetree/bindings/net/snps,dwmac.yaml   |  15 +-
>>   .../bindings/net/starfive,jh7100-dwmac.yaml   | 106 ++++++++++++
>>   .../bindings/riscv/sifive,ccache0.yaml        |  33 +++-
>>   MAINTAINERS                                   |   6 +
>>   arch/riscv/Kconfig                            |   6 +-
>>   .../boot/dts/starfive/jh7100-common.dtsi      |  78 +++++++++
>>   arch/riscv/boot/dts/starfive/jh7100.dtsi      |  55 +++++++
>>   arch/riscv/mm/dma-noncoherent.c               |  37 ++++-
>>   drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
>>   drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>>   .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 155 ++++++++++++++++++
>>   drivers/soc/sifive/Kconfig                    |   1 +
>>   drivers/soc/sifive/sifive_ccache.c            |  71 +++++++-
>>   include/soc/sifive/sifive_ccache.h            |  21 +++
>>   15 files changed, 587 insertions(+), 11 deletions(-)
>>   create mode 100644 Documentation/devicetree/bindings/net/starfive,jh7100-dwmac.yaml
>>   create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>>
>> -- 
>> 2.39.1
>>
