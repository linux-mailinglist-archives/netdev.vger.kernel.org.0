Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6DF6B14B6
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 23:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCHWDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 17:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjCHWDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 17:03:18 -0500
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2094130B2D;
        Wed,  8 Mar 2023 14:03:12 -0800 (PST)
Received: by mail-ot1-f41.google.com with SMTP id f19-20020a9d5f13000000b00693ce5a2f3eso14366oti.8;
        Wed, 08 Mar 2023 14:03:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678312991;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/H1xZsO9sdRZyA8gZC8r55Vi2llw8sEWwYx39dSujuw=;
        b=mYR1Ma4cDYhLhiMLT+lWOldsVP1/uyF1oiJCbB9mNhnpT8SqWoEDynWi/h5HQEoMEX
         dqHxdlH7ei9iIjeU6G622rShNvxu/elPzOnOn81MsJdXuMEq7dFps8rvN1WCJjKanHEW
         n/uhWbH2KiZYGuCUrjpgdP9wvdLXd1k2nBFuBasijifaBm3WwcFilealnMvPjvlOAzrI
         /C5TX99cQA7G9FTZ62rXO0efWGpz5gMrchO4Eu/SYXCfuTFdHTumIH546D6JHdNTsgD0
         kdhKIrhc8MJm4K0bsNCMkX91xrQONjn4uO+3w0ueKsU6T7FjEm+crzqImPE+D1oXwR6+
         /oPA==
X-Gm-Message-State: AO0yUKWjriFQLyG71pwweh3futKH5BDRd7lM1Bo6vuG1v3AvRJBLumuP
        ZgzAvw8byNTs01xlqJdrAg==
X-Google-Smtp-Source: AK7set8j/Ty7lxEdGegJ4aQZTitSIzTHicNnBX3DhgGM19m8ws9dl2kuKR2wZrxKUQHXbvg0vyfafg==
X-Received: by 2002:a9d:3e7:0:b0:694:88ea:671a with SMTP id f94-20020a9d03e7000000b0069488ea671amr3094525otf.14.1678312991323;
        Wed, 08 Mar 2023 14:03:11 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id a26-20020a056830101a00b00693ea7bfdc2sm6856004otp.76.2023.03.08.14.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 14:03:11 -0800 (PST)
Received: (nullmailer pid 3923609 invoked by uid 1000);
        Wed, 08 Mar 2023 22:03:09 -0000
Date:   Wed, 8 Mar 2023 16:03:09 -0600
From:   Rob Herring <robh@kernel.org>
To:     Samin Guo <samin.guo@starfivetech.com>
Cc:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: Re: [PATCH v5 07/12] dt-bindings: net: starfive,jh7110-dwmac: Add
 starfive,syscon
Message-ID: <20230308220309.GA3914591-robh@kernel.org>
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-8-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303085928.4535-8-samin.guo@starfivetech.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 04:59:23PM +0800, Samin Guo wrote:
> A phandle to syscon with two arguments that configure phy mode.

This change belongs in patch 4.

> 
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  .../bindings/net/starfive,jh7110-dwmac.yaml         | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> index ca49f08d50dd..79ae635db0a5 100644
> --- a/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
> @@ -58,6 +58,18 @@ properties:
>        Tx clock is provided by external rgmii clock.
>      type: boolean
>  
> +  starfive,syscon:
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    items:
> +      - items:
> +          - description: phandle to syscon that configures phy mode
> +          - description: Offset of phy mode selection
> +          - description: Mask of phy mode selection
> +    description:
> +      A phandle to syscon with two arguments that configure phy mode.
> +      The argument one is the offset of phy mode selection, the
> +      argument two is the mask of phy mode selection.
> +
>  allOf:
>    - $ref: snps,dwmac.yaml#
>  
> @@ -96,6 +108,7 @@ examples:
>          snps,en-tx-lpi-clockgating;
>          snps,txpbl = <16>;
>          snps,rxpbl = <16>;
> +        starfive,syscon = <&aon_syscon 0xc 0x1c0000>;
>          phy-handle = <&phy0>;
>  
>          mdio {
> -- 
> 2.17.1
> 
