Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D42C5842D8
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiG1PSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiG1PSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:18:06 -0400
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC8C46D93;
        Thu, 28 Jul 2022 08:18:05 -0700 (PDT)
Received: by mail-io1-f42.google.com with SMTP id v185so1586720ioe.11;
        Thu, 28 Jul 2022 08:18:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RvcitpT8SRhB8BocvR7SjrRkSCpHQg3td5uyJtapLlc=;
        b=q2ecAc9U6B+x2EsYZ06j641Btj5uuj/uI8880wnQBp8RH4oGwE3x+fRHNOHYrGlbcr
         LiPNc8tDOpumAhW6eselOP36WIh6dhmJRW3d9dazw/z7u8a1ZMPX3ueZlsqpfkXzP2fD
         9c6n4U7ZwIh3F0ujxO4Z/8XRYMR3OlumsOCvPwxthi4yHBcN+0PGjiwH1nD5n2Sq/QL+
         cwJsnsibw4PZPL3n86OiwM8oVTt9FvIKsAszBvs6IzVaWE/Fl31D/YDP2LJaiv+4MzeW
         m7lBB5VQvPfeoQJnv3RSIzLQ4I6uFUzTW8fWnnhmmIJApeaq9H5E+1x0saWQuzML6UNI
         Q+Ww==
X-Gm-Message-State: AJIora8Wg2m6S/QmbfdJeMitJuIVv+iqhDU2RjGWRPVqaN7SsYcmhlIh
        hYEFPgnORQ6jFaTiIYexvg==
X-Google-Smtp-Source: AGRyM1sXd4DPBqM1JpH9G5Vt11DrwoOOQL2Jborzd8Caj/m4YTARvPG5RH2IC9+DiqZtxkJWMfb77g==
X-Received: by 2002:a5d:8599:0:b0:67b:7d8d:9aed with SMTP id f25-20020a5d8599000000b0067b7d8d9aedmr9264709ioj.204.1659021484815;
        Thu, 28 Jul 2022 08:18:04 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id q3-20020a92c003000000b002dc33dbed87sm452951ild.39.2022.07.28.08.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 08:18:04 -0700 (PDT)
Received: (nullmailer pid 900900 invoked by uid 1000);
        Thu, 28 Jul 2022 15:18:02 -0000
Date:   Thu, 28 Jul 2022 09:18:02 -0600
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Mark Greer <mgreer@animalcreek.com>
Subject: Re: [PATCH 1/2] dt-bindings: nfc: use spi-peripheral-props.yaml
Message-ID: <20220728151802.GA900320-robh@kernel.org>
References: <20220727164130.385411-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727164130.385411-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 18:41:29 +0200, Krzysztof Kozlowski wrote:
> Instead of listing directly properties typical for SPI peripherals,
> reference the spi-peripheral-props.yaml schema.  This allows using all
> properties typical for SPI-connected devices, even these which device
> bindings author did not tried yet.
> 
> Remove the spi-* properties which now come via spi-peripheral-props.yaml
> schema, except for the cases when device schema adds some constraints
> like maximum frequency.
> 
> While changing additionalProperties->unevaluatedProperties, put it in
> typical place, just before example DTS.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> Technically, this depends on [1] merged to SPI tree, if we want to
> preserve existing behavior of not allowing SPI CPHA and CPOL in each of
> schemas in this patch.
> 
> If this patch comes independently via different tree, the SPI CPHA and
> CPOL will be allowed for brief period of time, before [1] is merged.
> This will not have negative impact, just DT schema checks will be
> loosened for that period.

I don't think these need to go via the same tree.

> 
> [1] https://lore.kernel.org/all/20220722191539.90641-2-krzysztof.kozlowski@linaro.org/
> ---
>  Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml | 4 ++--
>  Documentation/devicetree/bindings/net/nfc/st,st-nci.yaml   | 5 ++---
>  Documentation/devicetree/bindings/net/nfc/st,st95hf.yaml   | 7 ++++---
>  Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml | 7 ++++---
>  4 files changed, 12 insertions(+), 11 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
