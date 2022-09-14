Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CCF5B8CBC
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 18:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiINQUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 12:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiINQUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 12:20:09 -0400
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4003E759;
        Wed, 14 Sep 2022 09:20:06 -0700 (PDT)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-127d10b4f19so42292303fac.9;
        Wed, 14 Sep 2022 09:20:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=nXLhEVGz1qMo8aImbTGN6nLiSfBsJOREM/Vz/U5qmX8=;
        b=b/aiH/LXrB96+WSTfnQZme2JgcaYpeDJ28PT381kMINMTaTM0Z4ApFiXBp9KtpuTMm
         Lnj7HOj3n4M+phUOn8gZvG6BN+NhihCb2Jj9JupfvhLVBM0p100wApRX9FJqtvSg+Jl7
         SQLvRzz50vWQcb2YqAJkf7ujtiCgevOu3G3tBt0tOb+QAURDlRlXTVf5y76VZ2juJ9yO
         Asg2YK1a0QJxwWeOQc5CJVRK4bieTxbReN5lfAJez4taJjFCc84NK7/BM1snkk8NcAUG
         Qn9uBdrVwZhtubbQ0f1TQ8Z6kt1JgXHOXc4PmxzIetfIBHxyFfsqV2cbt3fQUXbcm4Gl
         FRlw==
X-Gm-Message-State: ACgBeo37G1OP4RC0aTo/XSPPSaicGAavTyqGJUuhX/5inQdkWUDYgNE4
        2Xn1L+7cROCo03XxOrivoA==
X-Google-Smtp-Source: AA6agR5RYHCagG3o1f6+CTby/sjSQ+8CfTLBxsLk+r37c+5y+Q1ZyAWXz8zlIpAZlh7jKaNdGgEKXQ==
X-Received: by 2002:a05:6870:82a8:b0:126:8942:24e3 with SMTP id q40-20020a05687082a800b00126894224e3mr2751959oae.133.1663172405607;
        Wed, 14 Sep 2022 09:20:05 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id z17-20020a9d62d1000000b00655d20b2b76sm6035651otk.33.2022.09.14.09.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 09:20:05 -0700 (PDT)
Received: (nullmailer pid 2461881 invoked by uid 1000);
        Wed, 14 Sep 2022 16:20:04 -0000
Date:   Wed, 14 Sep 2022 11:20:04 -0500
From:   Rob Herring <robh@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski@linaro.org,
        krzysztof.kozlowski+dt@linaro.org, linux@armlinux.org.uk,
        vladimir.oltean@nxp.com, grygorii.strashko@ti.com, vigneshr@ti.com,
        nsekhar@ti.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kishon@ti.com
Subject: Re: [PATCH 1/8] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J721e CPSW9G
Message-ID: <20220914162004.GA2433106-robh@kernel.org>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-2-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914095053.189851-2-s-vadapalli@ti.com>
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

On Wed, Sep 14, 2022 at 03:20:46PM +0530, Siddharth Vadapalli wrote:
> Update bindings for TI K3 J721e SoC which contains 9 ports (8 external
> ports) CPSW9G module and add compatible for it.
> 
> Changes made:
>     - Add new compatible ti,j721e-cpswxg-nuss for CPSW9G.
>     - Extend pattern properties for new compatible.
>     - Change maximum number of CPSW ports to 8 for new compatible.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 23 +++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> index 821974815dec..868b7fb58b06 100644
> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> @@ -57,6 +57,7 @@ properties:
>        - ti,am654-cpsw-nuss
>        - ti,j7200-cpswxg-nuss
>        - ti,j721e-cpsw-nuss
> +      - ti,j721e-cpswxg-nuss
>        - ti,am642-cpsw-nuss
>  
>    reg:
> @@ -111,7 +112,7 @@ properties:
>          const: 0
>  
>      patternProperties:
> -      "^port@[1-4]$":
> +      "^port@[1-8]$":
>          type: object
>          description: CPSWxG NUSS external ports
>  
> @@ -121,7 +122,7 @@ properties:
>          properties:
>            reg:
>              minimum: 1
> -            maximum: 4
> +            maximum: 8
>              description: CPSW port number
>  
>            phys:
> @@ -181,6 +182,21 @@ required:
>    - '#size-cells'
>  
>  allOf:
> +  - if:
> +      not:
> +        properties:
> +          compatible:
> +            contains:
> +              const: ti,j721e-cpswxg-nuss
> +    then:
> +      properties:
> +        ethernet-ports:
> +          patternProperties:
> +            "^port@[5-8]$": false
> +            properties:
> +              reg:
> +                maximum: 4

Your indentation is off. 'properties' here is under patternProperties 
making it a DT property.

> +
>    - if:
>        not:
>          properties:
> @@ -192,6 +208,9 @@ allOf:
>          ethernet-ports:
>            patternProperties:
>              "^port@[3-4]$": false
> +            properties:
> +              reg:
> +                maximum: 2

Same here.

>  
>  additionalProperties: false
>  
> -- 
> 2.25.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
