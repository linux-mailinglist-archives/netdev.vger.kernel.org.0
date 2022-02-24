Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAAB4C36AB
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 21:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbiBXUMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 15:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbiBXUM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 15:12:28 -0500
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9EA64BE8;
        Thu, 24 Feb 2022 12:11:58 -0800 (PST)
Received: by mail-oi1-f182.google.com with SMTP id i5so4716122oih.1;
        Thu, 24 Feb 2022 12:11:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aQCXZh1IKYsJrJlH9qSfBMOC7gefnG0eIRo2Y5BDw6U=;
        b=L3amgSLPtXTffEsbYyEY8TjXbAzN14aV8ggmJlX+U4yHhaHyVYRGgF7Q/LIx+/wnNz
         sS/DDsmTo7Hw4YXoKEXLpYY8QVlP+HVHvOM+rhfGFNIZkjFBa2feu689cq2RPhszFPAr
         jsC9XMUtBbWt6xsXFKUTQ0uhSiCSpK7Na9heuYQUUdXkpdUA8lCLEiE4H6ZIp5Ui8NKe
         zHyQuLIYbFTjMy5y2ma4vQPhGAsJnNeUfVPS/5ExWHqXW8IerMqnjDRPpTtnUtRMVpoy
         CYORFeD5jTwpHQfz+zQfckcPMjrd5Kyox5rY0/nT4vFReGLfr6or070by3/b0MT6sjOy
         asVA==
X-Gm-Message-State: AOAM533xxtyDiQ5Kz60Te1JHhP+j+HKciVbu5lVpY0or/A9oU+Jpr7Lz
        +6hCYAdL4Ld6krpF/iTkernfBodO2Q==
X-Google-Smtp-Source: ABdhPJwvMZHY/FLycuXsvTliMXXvMJHWr+Okbvm13l+P5zpggtPXh+pUyu2crnYPzL4MDhzq1BIxUw==
X-Received: by 2002:a05:6808:d4b:b0:2d7:e4b:bb53 with SMTP id w11-20020a0568080d4b00b002d70e4bbb53mr2344451oik.198.1645733517741;
        Thu, 24 Feb 2022 12:11:57 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id be40-20020a05680821a800b002d06df28063sm304990oib.5.2022.02.24.12.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 12:11:56 -0800 (PST)
Received: (nullmailer pid 3508003 invoked by uid 1000);
        Thu, 24 Feb 2022 20:11:55 -0000
Date:   Thu, 24 Feb 2022 14:11:55 -0600
From:   Rob Herring <robh@kernel.org>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] dt-bindings: net: dsa: add new mdio property
Message-ID: <Yhfmi2Mn6e0NMXh3@robh.at.kernel.org>
References: <20220221200102.6290-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221200102.6290-1-luizluca@gmail.com>
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

On Mon, Feb 21, 2022 at 05:01:02PM -0300, Luiz Angelo Daros de Luca wrote:
> The optional mdio property will be used by dsa switch to configure
> slave_mii_bus when the driver does not allocate it during setup.
> 
> Some drivers already offer/require a similar property but, in some
> cases, they rely on a compatible string to identify the mdio bus node.

That case will fail with this change. It precludes any binding 
referencing dsa.yaml from defining a 'mdio' node with properties other 
than what mdio.yaml defines.

The rule is becoming any common schema should not define more than one 
level of nodes if those levels can be extended.

> Each subdriver might decide to keep existing approach or migrate to this
> new common property.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> index b9d48e357e77..f9aa09052785 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> @@ -32,6 +32,12 @@ properties:
>        (single device hanging off a CPU port) must not specify this property
>      $ref: /schemas/types.yaml#/definitions/uint32-array
>  
> +  mdio:
> +    unevaluatedProperties: false
> +    description:
> +      Container of PHY and devices on the switches MDIO bus.
> +    $ref: /schemas/net/mdio.yaml#
> +
>  patternProperties:
>    "^(ethernet-)?ports$":
>      type: object
> -- 
> 2.35.1
> 
> 
