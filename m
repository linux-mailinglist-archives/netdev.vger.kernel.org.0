Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4E45842DC
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiG1PSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiG1PS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:18:29 -0400
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8144E872;
        Thu, 28 Jul 2022 08:18:28 -0700 (PDT)
Received: by mail-il1-f179.google.com with SMTP id g18so1087580ilk.4;
        Thu, 28 Jul 2022 08:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Ls3JiwmJiYnShJa3Bd4qG+DnJ7AXD6lVMWiDMb9zReM=;
        b=dVGnYNa4lVNrmpnAFZYiGEZBfYkC3HCWW6Ko2N9jUKhtzk/htubATlKZYHRyCaEx1V
         +sU+93hpM5dHADlp+0hrphEDWe5lHyBu1rMoWhIkD4V6VD37kJhUIaIAPH8LdClgQuKe
         y8/BV6fIlZMN7GargEtnU7TWR22lw0WUHGoZ8T+AgWW1Sh+mFLD4oGICyapcJT9rvYJa
         b6EtJtbBny8i3luj7NQHKV6opvDmop1Qlh2kev0wXhLJK1+w8TjqK7Y+SoN0u4Shj0Bv
         pyd2FZVyF4nfrCS3aMRWFDof1/xhMfMo3x/eQGOxzNhVaBNQFZC87FnDeTUF6oY1e7/w
         2ERQ==
X-Gm-Message-State: AJIora92925JKPBmsJCJ6LACa7PFv6sXmCvlwe+djJYBpEGTY0JRbR2m
        1nGsM6OmshV8wm9c6LJl6w==
X-Google-Smtp-Source: AGRyM1s9jv0cpkUY/QpbAsgHZc/CwhX9Bqdm6Ubf0jkIS51YGAV/oOwEBjmvjlqz1WZnDg5UOb3LaA==
X-Received: by 2002:a05:6e02:1181:b0:2dd:bd7a:26c5 with SMTP id y1-20020a056e02118100b002ddbd7a26c5mr3673515ili.8.1659021507770;
        Thu, 28 Jul 2022 08:18:27 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id q8-20020a02a988000000b0033f22c2e5b3sm477024jam.98.2022.07.28.08.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 08:18:27 -0700 (PDT)
Received: (nullmailer pid 901441 invoked by uid 1000);
        Thu, 28 Jul 2022 15:18:24 -0000
Date:   Thu, 28 Jul 2022 09:18:24 -0600
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>,
        Kalle Valo <kvalo@kernel.org>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Tony Lindgren <tony@atomide.com>, devicetree@vger.kernel.org,
        =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        linux-wireless@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: Re: [PATCH 2/2] dt-bindings: wireless: use spi-peripheral-props.yaml
Message-ID: <20220728151824.GA901389-robh@kernel.org>
References: <20220727164130.385411-1-krzysztof.kozlowski@linaro.org>
 <20220727164130.385411-2-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727164130.385411-2-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 18:41:30 +0200, Krzysztof Kozlowski wrote:
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
> 
> [1] https://lore.kernel.org/all/20220722191539.90641-2-krzysztof.kozlowski@linaro.org/
> ---
>  .../net/wireless/microchip,wilc1000.yaml      |  7 ++--
>  .../bindings/net/wireless/silabs,wfx.yaml     | 15 +++------
>  .../bindings/net/wireless/ti,wlcore.yaml      | 32 +++++++++----------
>  3 files changed, 25 insertions(+), 29 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
