Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC2553DEB0
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 00:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351654AbiFEWnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 18:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240474AbiFEWns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 18:43:48 -0400
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB124D277;
        Sun,  5 Jun 2022 15:43:47 -0700 (PDT)
Received: by mail-qv1-f43.google.com with SMTP id b17so770964qvz.0;
        Sun, 05 Jun 2022 15:43:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WHCpzsbL88UyieS9mfwLLBx6jkVyGEjtCpEWb7J2FGA=;
        b=ZCW4Aw77uRzC7Kibp4m/ND5BFOor3ZqdizUFOZrUM9YtaJMzPY56CF40QZJtF8kA//
         FAKwnQSz1lzoIONOC4KQzq5ioL7JF0Pvao5JHFI0jW0TNq2lZrMD4fD1EaHtek3Fkmm5
         YYUDSlRb+iUFnKWnZol10JdH4hiNakSz8pzIbXI9fxL2uharlqfeLCF1mBKiWDU//mc2
         vw1aQn7pBGI3aKGsoc+rZhXL6C4evf6uVKAbcw6Ix1dMiudNqFjnAuFpQCEk+lmQzKs/
         DESobylG2xloeSdD8ff0F3DpU7gHND6YMEovbOjCtwWweNBlH2pmcGqLhioqfMi/kJfu
         QAsA==
X-Gm-Message-State: AOAM533EXDmCnu67kx8as/A39uD9hmdzbdNc6aPtBNZqKE6K2DlZbodC
        zJtYcFnZI8Qbpz9kaZxq1A==
X-Google-Smtp-Source: ABdhPJzl8awkJTjp3IqvyrVtVpFHcyXx+g6RSfsnZQBxH+oLEAZKUT6/WGc4wSz7bzLVIA5pvWHLTA==
X-Received: by 2002:a05:6214:524a:b0:464:6bed:d008 with SMTP id kf10-20020a056214524a00b004646bedd008mr18416421qvb.69.1654469026134;
        Sun, 05 Jun 2022 15:43:46 -0700 (PDT)
Received: from robh.at.kernel.org ([2607:fb90:1bdb:2e61:f12:452:5315:9c7e])
        by smtp.gmail.com with ESMTPSA id v128-20020a37dc86000000b0069fc13ce244sm10338811qki.117.2022.06.05.15.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jun 2022 15:43:45 -0700 (PDT)
Received: (nullmailer pid 3664723 invoked by uid 1000);
        Sun, 05 Jun 2022 22:43:43 -0000
Date:   Sun, 5 Jun 2022 17:43:43 -0500
From:   Rob Herring <robh@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        linux@armlinux.org.uk, vladimir.oltean@nxp.com,
        grygorii.strashko@ti.com, vigneshr@ti.com, nsekhar@ti.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH v2 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J7200 CPSW5G
Message-ID: <20220605224343.GA3657277-robh@kernel.org>
References: <20220602114558.6204-1-s-vadapalli@ti.com>
 <20220602114558.6204-2-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602114558.6204-2-s-vadapalli@ti.com>
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

On Thu, Jun 02, 2022 at 05:15:56PM +0530, Siddharth Vadapalli wrote:
> Update bindings for TI K3 J7200 SoC which contains 5 ports (4 external
> ports) CPSW5G module and add compatible for it.
> 
> Changes made:
>     - Add new compatible ti,j7200-cpswxg-nuss for CPSW5G.
>     - Extend pattern properties for new compatible.
>     - Change maximum number of CPSW ports to 4 for new compatible.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 140 ++++++++++++------
>  1 file changed, 98 insertions(+), 42 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> index b8281d8be940..ec57bde7ac26 100644
> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> @@ -57,6 +57,7 @@ properties:
>        - ti,am654-cpsw-nuss
>        - ti,j721e-cpsw-nuss
>        - ti,am642-cpsw-nuss
> +      - ti,j7200-cpswxg-nuss
>  
>    reg:
>      maxItems: 1
> @@ -108,48 +109,103 @@ properties:
>          const: 1
>        '#size-cells':
>          const: 0
> -
> -    patternProperties:
> -      port@[1-2]:
> -        type: object
> -        description: CPSWxG NUSS external ports
> -
> -        $ref: ethernet-controller.yaml#
> -
> -        properties:
> -          reg:
> -            minimum: 1
> -            maximum: 2
> -            description: CPSW port number
> -
> -          phys:
> -            maxItems: 1
> -            description: phandle on phy-gmii-sel PHY
> -
> -          label:
> -            description: label associated with this port
> -
> -          ti,mac-only:
> -            $ref: /schemas/types.yaml#/definitions/flag
> -            description:
> -              Specifies the port works in mac-only mode.
> -
> -          ti,syscon-efuse:
> -            $ref: /schemas/types.yaml#/definitions/phandle-array
> -            items:
> -              - items:
> -                  - description: Phandle to the system control device node which
> -                      provides access to efuse
> -                  - description: offset to efuse registers???
> -            description:
> -              Phandle to the system control device node which provides access
> -              to efuse IO range with MAC addresses
> -
> -        required:
> -          - reg
> -          - phys
> -
> -    additionalProperties: false
> +    allOf:
> +      - if:
> +          properties:
> +            compatible:
> +              contains:
> +                enum:
> +                  - ti,am654-cpsw-nuss
> +                  - ti,j721e-cpsw-nuss
> +                  - ti,am642-cpsw-nuss
> +        then:
> +          patternProperties:
> +            port@[1-2]:
> +              type: object
> +              description: CPSWxG NUSS external ports
> +
> +              $ref: ethernet-controller.yaml#
> +
> +              properties:
> +                reg:
> +                  minimum: 1
> +                  maximum: 2
> +                  description: CPSW port number
> +
> +                phys:
> +                  maxItems: 1
> +                  description: phandle on phy-gmii-sel PHY
> +
> +                label:
> +                  description: label associated with this port
> +
> +                ti,mac-only:
> +                  $ref: /schemas/types.yaml#/definitions/flag
> +                  description:
> +                    Specifies the port works in mac-only mode.
> +
> +                ti,syscon-efuse:
> +                  $ref: /schemas/types.yaml#/definitions/phandle-array
> +                  items:
> +                    - items:
> +                        - description: Phandle to the system control device node which
> +                            provides access to efuse
> +                        - description: offset to efuse registers???
> +                  description:
> +                    Phandle to the system control device node which provides access
> +                    to efuse IO range with MAC addresses
> +
> +              required:
> +                - reg
> +                - phys
> +      - if:
> +          properties:
> +            compatible:
> +              contains:
> +                enum:
> +                  - ti,j7200-cpswxg-nuss
> +        then:
> +          patternProperties:
> +            port@[1-4]:
> +              type: object
> +              description: CPSWxG NUSS external ports
> +
> +              $ref: ethernet-controller.yaml#
> +
> +              properties:
> +                reg:
> +                  minimum: 1
> +                  maximum: 4
> +                  description: CPSW port number
> +
> +                phys:
> +                  maxItems: 1
> +                  description: phandle on phy-gmii-sel PHY
> +
> +                label:
> +                  description: label associated with this port
> +
> +                ti,mac-only:
> +                  $ref: /schemas/types.yaml#/definitions/flag
> +                  description:
> +                    Specifies the port works in mac-only mode.
> +
> +                ti,syscon-efuse:
> +                  $ref: /schemas/types.yaml#/definitions/phandle-array
> +                  items:
> +                    - items:
> +                        - description: Phandle to the system control device node which
> +                            provides access to efuse
> +                        - description: offset to efuse registers???
> +                  description:
> +                    Phandle to the system control device node which provides access
> +                    to efuse IO range with MAC addresses
> +
> +              required:
> +                - reg
> +                - phys

You are now defining the same properties twice. Don't do that. Just add 
an if/then schema restrict port nodes.

Rob
