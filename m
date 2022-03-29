Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4304EB4C4
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 22:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiC2UnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 16:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiC2UnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 16:43:11 -0400
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6BE91568;
        Tue, 29 Mar 2022 13:41:27 -0700 (PDT)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-de48295467so20053062fac.2;
        Tue, 29 Mar 2022 13:41:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ybAutaE4u/WcyTvDzQs8SWO5MsLDIDzeRNgubexXSOA=;
        b=5TSQC/Rxp8jDXVjqhjU8DgmB7A9hoo1Z8S3lWbhx+wGhE9OrtRLDnq5T9PtkL2QCpe
         o0Zdd2t9785jjIJhllRbbd8NCF8YCW6U9pMT2pF+ZyIFpKALiVpyYQ8FAUZmIJi48r95
         BolqkPakc8wowhHwwIWAPZ2Um5e/e0A0J4qHuPiiKwxHK4P0fn0OH4isxQRFAm4WA0zQ
         Cu9a7wiMzW1V+JqgQJ5OPMRrp8aXrO7gN9rKRJv4LXFI3rEKb2PA4d+WYt56TPd3oNy5
         enr/tACALoHG5MoYEet/yd8NAwYB9NLTp3Zy5Y4dx1ESjUDEvmPSAvyHPLoigRLaW+J4
         YgYA==
X-Gm-Message-State: AOAM533N5eNMxv7RXhw2VtHrYWu5UYiDWz0/oHPyztV/iKYT6mEhjzC6
        TzIQMj77ucr2aTvXWKt2Zg==
X-Google-Smtp-Source: ABdhPJxCAfS2SSvn7/HeTaJBn883Rg1EFxXqfORszuMJNVWm5thVyrdSCYtafvPt4wNV4Rb2Nnsq2A==
X-Received: by 2002:a05:6870:4727:b0:de:193b:cb9c with SMTP id b39-20020a056870472700b000de193bcb9cmr574815oaq.212.1648586487235;
        Tue, 29 Mar 2022 13:41:27 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j25-20020a4ad199000000b003171dfeb5bfsm8810519oor.15.2022.03.29.13.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 13:41:26 -0700 (PDT)
Received: (nullmailer pid 1232706 invoked by uid 1000);
        Tue, 29 Mar 2022 20:41:24 -0000
Date:   Tue, 29 Mar 2022 15:41:24 -0500
From:   Rob Herring <robh@kernel.org>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org, pabeni@redhat.com
Subject: Re: [RFC PATCH v11 net-next 01/10] dt-bindings: net: make
 internal-delay-ps based on phy-mode
Message-ID: <YkNu9D24qu+tIP/n@robh.at.kernel.org>
References: <20220325165341.791013-1-prasanna.vengateshan@microchip.com>
 <20220325165341.791013-2-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325165341.791013-2-prasanna.vengateshan@microchip.com>
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

On Fri, Mar 25, 2022 at 10:23:32PM +0530, Prasanna Vengateshan wrote:
> *-internal-delay-ps properties would be applicable only for RGMII interface
> modes.
> 
> It is changed as per the request,
> https://lore.kernel.org/netdev/d8e5f6a8-a7e1-dabd-f4b4-ea8ea21d0a1d@gmail.com/
> 
> Ran dt_binding_check to confirm nothing is broken.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  .../bindings/net/ethernet-controller.yaml     | 37 +++++++++++++------
>  1 file changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index 34c5463abcec..dc86a6479a86 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -123,12 +123,6 @@ properties:
>        and is useful for determining certain configuration settings
>        such as flow control thresholds.
>  
> -  rx-internal-delay-ps:
> -    description: |
> -      RGMII Receive Clock Delay defined in pico seconds.
> -      This is used for controllers that have configurable RX internal delays.
> -      If this property is present then the MAC applies the RX delay.
> -
>    sfp:
>      $ref: /schemas/types.yaml#/definitions/phandle
>      description:
> @@ -140,12 +134,6 @@ properties:
>        The size of the controller\'s transmit fifo in bytes. This
>        is used for components that can have configurable fifo sizes.
>  
> -  tx-internal-delay-ps:
> -    description: |
> -      RGMII Transmit Clock Delay defined in pico seconds.
> -      This is used for controllers that have configurable TX internal delays.
> -      If this property is present then the MAC applies the TX delay.
> -
>    managed:
>      description:
>        Specifies the PHY management type. If auto is set and fixed-link
> @@ -222,6 +210,31 @@ properties:
>            required:
>              - speed
>  
> +allOf:
> +  - if:
> +      properties:
> +        phy-mode:
> +          contains:
> +            enum:
> +              - rgmii
> +              - rgmii-rxid
> +              - rgmii-txid
> +              - rgmii-id
> +            then:

Did you test this?

The 'then' has no effect. It's at the wrong indentation. It should be 
the same as 'if'.

> +              properties:
> +                rx-internal-delay-ps:
> +                  description:
> +                    RGMII Receive Clock Delay defined in pico seconds.This is
> +                    used for controllers that have configurable RX internal
> +                    delays. If this property is present then the MAC applies
> +                    the RX delay.
> +                tx-internal-delay-ps:
> +                  description:
> +                    RGMII Transmit Clock Delay defined in pico seconds.This is
> +                    used for controllers that have configurable TX internal
> +                    delays. If this property is present then the MAC applies
> +                    the TX delay.
> +
>  additionalProperties: true
>  
>  ...
> -- 
> 2.30.2
> 
> 
