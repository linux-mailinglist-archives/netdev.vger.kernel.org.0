Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C225B8B89
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiINPOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiINPOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:14:17 -0400
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE3E79A5C;
        Wed, 14 Sep 2022 08:14:16 -0700 (PDT)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-11eab59db71so41774727fac.11;
        Wed, 14 Sep 2022 08:14:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=mqCUADzpoo8AFdoi8q+vW/4XMqO6zRBOxuOuOr9QdQE=;
        b=g3lmTOkQK1MrzJR0YWw9jfO7xLH479CmC4B8EXWFVYkB2JyjMvKkFlIT+6epQ25FkL
         I6608xPyXZEvcvRLGYzxnNNrOXcqJ/1YUcrE/Dk0kYXC3/kQcPRUSEZI03eQAiafiPIZ
         Gzsw/UM74l96ZUhCJ2j40VLdJC/YPtYr2JiBhstGm1wAdCgP1nvNbDSqsqHKrcYxF3y8
         H8RgFbS2S/O6w3TnWmb8T3eqWDIhaBcoke6zKW/v4IAl56xIgIxOkadSMU3AzhEawFWT
         kHWh6acfuOyYrlehUure4FfMhS0qQ9+7Q+tZJcZv4KoUZGUSMvrRNhj8wPBqlPPbmkmr
         dpBw==
X-Gm-Message-State: ACgBeo0N+9IKbbWlVgQm6VfwHcbhjEZlfvgRYAyZIJeLNgnlND51jaeG
        H8ZoyZWCENuU0Nvgiujdcg==
X-Google-Smtp-Source: AA6agR7bsAhsApH+C7wdfjNUjslyXpkMLePmDH1OXJw3zdJmRZjSzOly8XTZk4JY5P//x3SzNBNRew==
X-Received: by 2002:a05:6870:e616:b0:12b:82e8:dc53 with SMTP id q22-20020a056870e61600b0012b82e8dc53mr2767817oag.276.1663168455901;
        Wed, 14 Sep 2022 08:14:15 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id u22-20020a056871009600b0012b342d1125sm7798176oaa.13.2022.09.14.08.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 08:14:15 -0700 (PDT)
Received: (nullmailer pid 2263826 invoked by uid 1000);
        Wed, 14 Sep 2022 15:14:14 -0000
Date:   Wed, 14 Sep 2022 10:14:14 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH 04/10] dt-bindings: memory: mt7621: add syscon as
 compatible string
Message-ID: <20220914151414.GA2233841-robh@kernel.org>
References: <20220914085451.11723-1-arinc.unal@arinc9.com>
 <20220914085451.11723-5-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220914085451.11723-5-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 11:54:45AM +0300, Arınç ÜNAL wrote:
> Add syscon as a constant string on the compatible property as it's required
> for the SoC to work. Update the example accordingly.

It's not required. It's required to automagically create a regmap. That 
can be done yourself as well. The downside to adding 'syscon' is it 
requires a DT update. Maybe that's fine for this platform? I don't know.

> 
> Fixes: 5278e4a181ff ("dt-bindings: memory: add binding for Mediatek's MT7621 SDRAM memory controller")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/memory-controllers/mediatek,mt7621-memc.yaml   | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/memory-controllers/mediatek,mt7621-memc.yaml b/Documentation/devicetree/bindings/memory-controllers/mediatek,mt7621-memc.yaml
> index 85e02854f083..6ccdaf99c778 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/mediatek,mt7621-memc.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/mediatek,mt7621-memc.yaml
> @@ -11,7 +11,9 @@ maintainers:
>  
>  properties:
>    compatible:
> -    const: mediatek,mt7621-memc
> +    items:
> +      - const: mediatek,mt7621-memc
> +      - const: syscon
>  
>    reg:
>      maxItems: 1
> @@ -25,6 +27,6 @@ additionalProperties: false
>  examples:
>    - |
>      memory-controller@5000 {
> -        compatible = "mediatek,mt7621-memc";
> +        compatible = "mediatek,mt7621-memc", "syscon";
>          reg = <0x5000 0x1000>;
>      };
> -- 
> 2.34.1
> 
> 
