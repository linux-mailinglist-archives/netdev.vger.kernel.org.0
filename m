Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDF26972B2
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 01:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjBOAeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 19:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBOAea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 19:34:30 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6922977C;
        Tue, 14 Feb 2023 16:34:29 -0800 (PST)
Received: from [192.168.1.90] (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 402C0660217D;
        Wed, 15 Feb 2023 00:34:26 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676421268;
        bh=GPRpB7l0KFvDAe90l47jGxlxu/5Kcdt9J/hi24/5C7w=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=KGwXRBM+CqsY8WuVEfFGb/3XE6k5Po4N/V7S5ZYtvlN9vFIQGjvcSa80xB+QIKeNu
         nLP/oA1H5uIjgN/mRBN1QDxHG+RER1Q/j6jnvPPM6DdDMLZN8ieUtg3ARbQ8XGAKdQ
         DuYxDMbfPlM5EsnNFnlIWZ7oQ4xKlwvvcxGsbJWrclFzyrD/zP7icr+xtrhCCBnY/A
         Mi+ycV2kn42zsBBiGOr9OvgoXz6x2i0TQIfF0KdM4BO7RRYVK52qEsvnin9rSNKyn7
         iXTQk09k1+rOU5CDn28q1vB64m62J9RTYcCCVFOLohT2yv+B+1K8P/TjbJktfwRRYX
         B5LfeJ39Hm8Ow==
Message-ID: <586971af-2d78-456d-a605-6c7b2aefda91@collabora.com>
Date:   Wed, 15 Feb 2023 02:34:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 07/12] dt-bindings: net: Add StarFive JH7100 SoC
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
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
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-8-cristian.ciocaltea@collabora.com>
 <Y+e74UIV/Td91lKB@lunn.ch>
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
In-Reply-To: <Y+e74UIV/Td91lKB@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/23 18:01, Andrew Lunn wrote:
>> +  starfive,gtxclk-dlychain:
>> +    $ref: /schemas/types.yaml#/definitions/uint32
>> +    description: GTX clock delay chain setting
> 
> Please could you add more details to this. Is this controlling the
> RGMII delays? 0ns or 2ns?

This is what gets written to JH7100_SYSMAIN_REGISTER49 and it's 
currently set to 4 in patch 12/12. As already mentioned, I don't have 
the register information in the datasheet, but I'll update this as soon 
as we get some details.

>> +    gmac: ethernet@10020000 {
>> +      compatible = "starfive,jh7100-dwmac", "snps,dwmac";
>> +      reg = <0x0 0x10020000 0x0 0x10000>;
>> +      clocks = <&clkgen JH7100_CLK_GMAC_ROOT_DIV>,
>> +               <&clkgen JH7100_CLK_GMAC_AHB>,
>> +               <&clkgen JH7100_CLK_GMAC_PTP_REF>,
>> +               <&clkgen JH7100_CLK_GMAC_GTX>,
>> +               <&clkgen JH7100_CLK_GMAC_TX_INV>;
>> +      clock-names = "stmmaceth", "pclk", "ptp_ref", "gtxc", "tx";
>> +      resets = <&rstgen JH7100_RSTN_GMAC_AHB>;
>> +      reset-names = "ahb";
>> +      interrupts = <6>, <7>;
>> +      interrupt-names = "macirq", "eth_wake_irq";
>> +      max-frame-size = <9000>;
>> +      phy-mode = "rgmii-txid";
> 
> This is unusual. Does your board have a really long RX clock line to
> insert the 2ns delay needed on the RX side?

Just tested with "rgmii" and didn't notice any issues. If I'm not 
missing anything, I'll do the change in the next revision.

>         Andrew

Thanks,
Cristian
