Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52ED667F925
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbjA1PcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjA1PcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:32:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1669623DAD;
        Sat, 28 Jan 2023 07:32:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A37BEB80919;
        Sat, 28 Jan 2023 15:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C1EC433EF;
        Sat, 28 Jan 2023 15:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674919937;
        bh=6bUIRH8u5Cxb143fKnG2xu5Mame0Rqrt7wtVXi/pBI0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B/UHPiLasadsoRWpYuGJDp1GLMSeZmlfVRTmB/u7+euzi1jGnfanl6/0d+JYc2Anh
         w7UO6aa2RsLgUjI1TkHXjO36kqVYHhfXz/NCtaRI8OBIp/Q2pEZFlv4mub7gKuB0qI
         1Mc7qpLn6KKILoT9rYANmy7LzgbATjPALJjEwNQejFsO1M7vRDp0lv6AF9qG6JMfUy
         5lpHy0ZUkiHDj2il7+hETu3TJKnGEz59b4YBLnwu8O8u6aCEuUKLoI0SiudsfUi4Fr
         1BAyerZrGeDn7mhab+7xjaNDPuPf2DsSywJWmBDFLs9BxgUuYRquba0R/ZzEBRsQJE
         Hlj1/II1JU4cQ==
Date:   Sat, 28 Jan 2023 15:46:06 +0000
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
        <linux-spi@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 2/6] dt-bindings: treewide: add feature-domains
 description in binding files
Message-ID: <20230128154606.18b70629@jic23-huawei>
In-Reply-To: <20230127164040.1047583-3-gatien.chevallier@foss.st.com>
References: <20230127164040.1047583-1-gatien.chevallier@foss.st.com>
        <20230127164040.1047583-3-gatien.chevallier@foss.st.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Jan 2023 17:40:36 +0100
Gatien Chevallier <gatien.chevallier@foss.st.com> wrote:

> feature-domains is an optional property that allows a peripheral to
> refer to one or more feature domain controller(s).
> 
> Description of this property is added to all peripheral binding files of
> the peripheral under the STM32 System Bus. It allows an accurate
> representation of the hardware, where various peripherals are connected
> to this firewall bus. The firewall can then check the peripheral accesses
> before allowing it to probe.
> 
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>

There was probably a cleaner way to ensure that this could go via the various
subsystem trees, but hopefully there won't be any clashes with other work going in
and if there is, the resolution should be simple. Hence I'm fine with
this going via the dt tree.

So for the IIO ones below,

Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
> index 1c340c95df16..c68b7b0e1903 100644
> --- a/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
> @@ -93,6 +93,11 @@ properties:
>    '#size-cells':
>      const: 0
>  
> +  feature-domains:
> +    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
> +    minItems: 1
> +    maxItems: 3
> +
>  allOf:
>    - if:
>        properties:
> diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> index 1970503389aa..d01f60765e48 100644
> --- a/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml
> @@ -59,6 +59,11 @@ properties:
>        If not, SPI CLKOUT frequency will not be accurate.
>      maximum: 20000000
>  
> +  feature-domains:
> +    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
> +    minItems: 1
> +    maxItems: 3
> +
>  required:
>    - compatible
>    - reg
> diff --git a/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml b/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml
> index 0f1bf1110122..f6fe58d2f9b8 100644
> --- a/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml
> +++ b/Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml
> @@ -45,6 +45,11 @@ properties:
>    '#size-cells':
>      const: 0
>  
> +  feature-domains:
> +    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains
> +    minItems: 1
> +    maxItems: 3
> +
>  additionalProperties: false
