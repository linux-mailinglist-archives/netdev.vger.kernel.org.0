Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC75567F933
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbjA1Pep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:34:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjA1Pem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:34:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B38426593;
        Sat, 28 Jan 2023 07:34:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D74CDB80AFC;
        Sat, 28 Jan 2023 15:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3AFC433D2;
        Sat, 28 Jan 2023 15:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674920078;
        bh=9p78P6cXR1b4UU7LmDHxucqXQwLRZGC/wmG/lLypzGo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sy0kkDvx7E1gVGfY9fcdg6jg5BXRuQjvDhZ65C8k3WA9gemy6YC6wX3Gx8hJ6J27H
         8x4NyS2i9dc7yo7IjeKLfkJbdrwJvnmDYjTa4VHC3ZyoFewAW5vk21MiodWH4XZwsX
         hne0KUqKUSiitaWQeznzMa5EsGNKQWvl+kY3QxWw+anNiuYxGsLpiX903y2CKtuGcp
         1fpsi44mIXd51SeVfoW/J74LAmTLYdVHs6Gm3e4i8FSUlAL+oM3JvIYVMzXpMO2fFv
         E1feNPP7OEIcUHmrswPBcbUTonWBEPjeef08rq4yiie66P9WWGcsokUtwiNIK3F1g9
         /JHmxQiRyr/aQ==
Date:   Sat, 28 Jan 2023 15:48:27 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc:     <Oleksii_Moisieiev@epam.com>, <gregkh@linuxfoundation.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <alexandre.torgue@foss.st.com>, <vkoul@kernel.org>,
        <olivier.moysan@foss.st.com>, <arnaud.pouliquen@foss.st.com>,
        <mchehab@kernel.org>, <fabrice.gasnier@foss.st.com>,
        <ulf.hansson@linaro.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-media@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-serial@vger.kernel.org>,
        <linux-spi@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Loic PALLARDY <loic.pallardy@st.com>
Subject: Re: [PATCH v3 3/6] dt-bindings: bus: add STM32 System Bus
Message-ID: <20230128154827.4f23534e@jic23-huawei>
In-Reply-To: <20230127164040.1047583-4-gatien.chevallier@foss.st.com>
References: <20230127164040.1047583-1-gatien.chevallier@foss.st.com>
        <20230127164040.1047583-4-gatien.chevallier@foss.st.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Jan 2023 17:40:37 +0100
Gatien Chevallier <gatien.chevallier@foss.st.com> wrote:

> Document STM32 System Bus. This bus is intended to control firewall
> access for the peripherals connected to it.
> 
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
> Signed-off-by: Loic PALLARDY <loic.pallardy@st.com>
Trivial comment on formatting.

> +
> +examples:
> +  - |
> +    // In this example, the rng1 device refers to etzpc as its domain controller.
> +    // Same goes for fmc.
> +    // Access rights are verified before creating devices.
> +
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/clock/stm32mp1-clks.h>
> +    #include <dt-bindings/reset/stm32mp1-resets.h>
> +
> +    etzpc: bus@5c007000 {
> +        compatible = "st,stm32mp15-sys-bus";
> +        reg = <0x5c007000 0x400>;
> +        #address-cells = <1>;
> +        #size-cells = <1>;
> +        ranges;
> +        feature-domain-controller;
> +        #feature-domain-cells = <1>;
> +
> +        rng1: rng@54003000 {

Odd mixture of 4 spacing and 2 spacing in this example.
I'd suggest one or the other (slight preference for 4 space indents).


> +          compatible = "st,stm32-rng";
> +          reg = <0x54003000 0x400>;
> +          clocks = <&rcc RNG1_K>;
> +          resets = <&rcc RNG1_R>;
> +          feature-domains = <&etzpc 7>;
> +          status = "disabled";
> +        };
