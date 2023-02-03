Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2EC68A3DC
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 21:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbjBCU5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 15:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBCU5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 15:57:52 -0500
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C104F928F2;
        Fri,  3 Feb 2023 12:57:50 -0800 (PST)
Received: by mail-ot1-f46.google.com with SMTP id 70-20020a9d084c000000b0068bccf754f1so1742405oty.7;
        Fri, 03 Feb 2023 12:57:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DTUpcYkNxPIlJHACYCYR7pDb1Buy+e4lFP4bk5Zgp34=;
        b=D6kjA0iDCoHbJoW0/A85Gd/DEhgeFoqvSv2XUAWEbb1o+0YfaV5M3siOzoHq6v+lem
         V8B6SLkgyxx/W3zB640h3M9fhSuQRaR8LNQQOuiUzmt1QdoYEVcn76JrF6ewHHqp3BxN
         Hy2T0sAe3/8AOzMRx9zYqk92gEFBgmAH0ufB0/8eI8xfuhJfuVaupJ3T1XZ1archyji/
         Nola6qXtDnqlRQdvhMBBBSETrlm+Jd6/+GcxoM2hwr0JFnTnXCwe2grgSZIh27ikr6Um
         mpX2POkA56H64IeN4GJVZ1uydAwgcMldwGbymiD8KpgUN+uUj18tRkFOctge3sIMEhyG
         8cTg==
X-Gm-Message-State: AO0yUKVPGuB7WkOnxV5ZFvTP+YeGM2mRoFmSfcEhOqt90HjqZ1lrYGhk
        EH1ec8I1KvYGvqaHgJ3Iqw==
X-Google-Smtp-Source: AK7set/idxy63+ygBDyPnMqtJWkCkCzx9MyU4A+nT1Br4FymPkR4Z0JILK7N/Htqiz/3btTinW8cgQ==
X-Received: by 2002:a05:6830:1e57:b0:68b:b721:8f1c with SMTP id e23-20020a0568301e5700b0068bb7218f1cmr6718583otj.27.1675457869992;
        Fri, 03 Feb 2023 12:57:49 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id c22-20020a9d6856000000b0068bd5af9b82sm1611458oto.43.2023.02.03.12.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 12:57:49 -0800 (PST)
Received: (nullmailer pid 873929 invoked by uid 1000);
        Fri, 03 Feb 2023 20:57:48 -0000
Date:   Fri, 3 Feb 2023 14:57:48 -0600
From:   Rob Herring <robh@kernel.org>
To:     Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc:     Oleksii_Moisieiev@epam.com, gregkh@linuxfoundation.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        krzysztof.kozlowski+dt@linaro.org, alexandre.torgue@foss.st.com,
        vkoul@kernel.org, jic23@kernel.org, olivier.moysan@foss.st.com,
        arnaud.pouliquen@foss.st.com, mchehab@kernel.org,
        fabrice.gasnier@foss.st.com, ulf.hansson@linaro.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-iio@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 2/6] dt-bindings: treewide: add feature-domains
 description in binding files
Message-ID: <20230203205748.GA860175-robh@kernel.org>
References: <20230127164040.1047583-1-gatien.chevallier@foss.st.com>
 <20230127164040.1047583-3-gatien.chevallier@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127164040.1047583-3-gatien.chevallier@foss.st.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 05:40:36PM +0100, Gatien Chevallier wrote:
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
> ---
> 
> Patch not present in V1 and V2.
> 
>  Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml | 5 +++++
>  Documentation/devicetree/bindings/dma/st,stm32-dma.yaml     | 5 +++++
>  Documentation/devicetree/bindings/dma/st,stm32-dmamux.yaml  | 5 +++++
>  Documentation/devicetree/bindings/i2c/st,stm32-i2c.yaml     | 5 +++++
>  Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml | 5 +++++
>  .../devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml     | 5 +++++
>  Documentation/devicetree/bindings/iio/dac/st,stm32-dac.yaml | 5 +++++
>  Documentation/devicetree/bindings/media/st,stm32-cec.yaml   | 5 +++++
>  Documentation/devicetree/bindings/media/st,stm32-dcmi.yaml  | 5 +++++
>  .../bindings/memory-controllers/st,stm32-fmc2-ebi.yaml      | 5 +++++
>  Documentation/devicetree/bindings/mfd/st,stm32-lptimer.yaml | 5 +++++
>  Documentation/devicetree/bindings/mfd/st,stm32-timers.yaml  | 6 ++++++
>  Documentation/devicetree/bindings/mmc/arm,pl18x.yaml        | 5 +++++
>  Documentation/devicetree/bindings/net/stm32-dwmac.yaml      | 5 +++++
>  .../devicetree/bindings/phy/phy-stm32-usbphyc.yaml          | 5 +++++
>  .../devicetree/bindings/regulator/st,stm32-vrefbuf.yaml     | 5 +++++
>  Documentation/devicetree/bindings/rng/st,stm32-rng.yaml     | 5 +++++
>  Documentation/devicetree/bindings/serial/st,stm32-uart.yaml | 5 +++++
>  Documentation/devicetree/bindings/sound/st,stm32-i2s.yaml   | 5 +++++
>  Documentation/devicetree/bindings/sound/st,stm32-sai.yaml   | 5 +++++
>  .../devicetree/bindings/sound/st,stm32-spdifrx.yaml         | 5 +++++
>  Documentation/devicetree/bindings/spi/st,stm32-qspi.yaml    | 5 +++++
>  Documentation/devicetree/bindings/spi/st,stm32-spi.yaml     | 5 +++++
>  Documentation/devicetree/bindings/usb/dwc2.yaml             | 5 +++++
>  24 files changed, 121 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
> index 4ccb335e8063..cb2ad7d5fdb5 100644
> --- a/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
> +++ b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
> @@ -41,6 +41,11 @@ properties:
>      maximum: 2
>      default: 0
>  
> +  feature-domains:
> +    $ref: /schemas/feature-controllers/feature-domain-controller.yaml#/properties/feature-domains

Not how common properties work. Consumer properties should be in a 
schema with 'select: true' (the one you are referencing) and here you 
just need to define the entries. Like clocks, power-domains, etc.

> +    minItems: 1
> +    maxItems: 3

Why is this variable and what is each entry?

I still don't like the naming. Everything is a feature and a domain... 

It might be a bit easier to come up with a name with multiple users of 
this binding presented. I'm hesistant to define any new common binding 
with only 1 user as I've said multiple times on this binding.

Rob
