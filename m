Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146305B0922
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiIGPsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiIGPsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:48:01 -0400
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11DAB9F90;
        Wed,  7 Sep 2022 08:47:58 -0700 (PDT)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-127dca21a7dso9740590fac.12;
        Wed, 07 Sep 2022 08:47:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=P9M7/bzZ0ZMw/d0qpnlcd3bSu1NtUDhgwC52m6jfjak=;
        b=ay3OgbdOmmRKaP7uBF4xjWNyjko0xdBI/R4BTiAJ+bGYc5lyszUgyVAaMzpbM/tI2s
         8u415YkLMaaAQmXhPWnVGQHdVLQOfkZEp+osXK/HoQ/uskwBczh1e96ZdBackJ+Oe3H+
         UHiyChPYq+zTzLms++uTXAFPQ7OejVuBJ9hJEopOiar/MWMZb/JLv+2haJ5F4b5S1kiD
         Mrlpcqu7yDU1ero7nFL9y3oiytMgNBvtqMxb5ikxKR9EqADxxxrvEKpGGLrMu0bx8T2K
         xrycjTbM3reI45VbNP+9w7eE/xFY36Ivf30Ok2Wa40IzX1LnThxuHrbR+1DAE/bomJu1
         jiTQ==
X-Gm-Message-State: ACgBeo3LkQGy8lLT51Fgs74wK6ooEB7ZIaLRXA4gFv+G2RhFaGjbYoPD
        jb+TDdPGQ3Y0tdiHqDR+qg==
X-Google-Smtp-Source: AA6agR7V8XXJWCZA66/vmCNdtFQHBPBeY7vIpPYKBM+iV7v+1t93G419nZX9b4Lu3VamSExZLcbo0Q==
X-Received: by 2002:a05:6808:1489:b0:344:7ff8:54e8 with SMTP id e9-20020a056808148900b003447ff854e8mr12233447oiw.195.1662565677655;
        Wed, 07 Sep 2022 08:47:57 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id bm23-20020a0568081a9700b0034480f7eec4sm6558187oib.12.2022.09.07.08.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 08:47:57 -0700 (PDT)
Received: (nullmailer pid 3514416 invoked by uid 1000);
        Wed, 07 Sep 2022 15:47:56 -0000
Date:   Wed, 7 Sep 2022 10:47:56 -0500
From:   Rob Herring <robh@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Rafa__ Mi__ecki <zajec5@gmail.com>,
        SHA-cyfmac-dev-list@infineon.com, Sven Peter <sven@svenpeter.dev>,
        van Spriel <arend@broadcom.com>
Subject: Re: [PATCH net-next 01/12] dt-bindings: net: bcm4329-fmac: Add Apple
 properties & chips
Message-ID: <20220907154756.GA3505310-robh@kernel.org>
References: <YxhMaYOfnM+7FG+W@shell.armlinux.org.uk>
 <E1oVpmk-005LBL-5U@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1oVpmk-005LBL-5U@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 08:47:46AM +0100, Russell King wrote:
> From: Hector Martin <marcan@marcan.st>
> 
> This binding is currently used for SDIO devices, but these chips are
> also used as PCIe devices on DT platforms and may be represented in the
> DT. Re-use the existing binding and add chip compatibles used by Apple
> T2 and M1 platforms (the T2 ones are not known to be used in DT
> platforms, but we might as well document them).
> 
> Then, add properties required for firmware selection and calibration on
> M1 machines.
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  .../net/wireless/brcm,bcm4329-fmac.yaml       | 37 +++++++++++++++++--
>  1 file changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> index 53b4153d9bfc..53ded82b273a 100644
> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/net/wireless/brcm,bcm4329-fmac.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom BCM4329 family fullmac wireless SDIO devices
> +title: Broadcom BCM4329 family fullmac wireless SDIO/PCIE devices
>  
>  maintainers:
>    - Arend van Spriel <arend@broadcom.com>
> @@ -42,10 +42,16 @@ title: Broadcom BCM4329 family fullmac wireless SDIO devices
>                - cypress,cyw43012-fmac
>            - const: brcm,bcm4329-fmac
>        - const: brcm,bcm4329-fmac

If you respin, this compatible can be combined with the enum below.

> +      - enum:
> +          - pci14e4,43dc  # BCM4355
> +          - pci14e4,4464  # BCM4364
> +          - pci14e4,4488  # BCM4377
> +          - pci14e4,4425  # BCM4378
> +          - pci14e4,4433  # BCM4387


Reviewed-by: Rob Herring <robh@kernel.org>
