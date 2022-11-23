Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8417E636CEF
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 23:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiKWWNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 17:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKWWNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 17:13:44 -0500
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD052C668;
        Wed, 23 Nov 2022 14:13:43 -0800 (PST)
Received: by mail-il1-f175.google.com with SMTP id x13so54882ilp.8;
        Wed, 23 Nov 2022 14:13:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q87qXZC226hu78NzbfxizHwI49QoPdMNwaF2clTtxOA=;
        b=AZRSfx89jWRP11mgYFs5ZzFSChW3WCr3McVGNMsiNol2lBgvMeCzw4FM3hJhVQosOE
         Qv21opvFkxG7ku1ZrFPpJbbPjloOdC6CNgMRPnjKb//nFsMh2c1OeukmM+p+bqwMZsp3
         L0PXvxyuXjU55vcibEpx52R746R3dMFyygLY6dxkyrEvrdK6ZiC4k8XB4DwqQbfFKJL2
         SP1eaZ6InRhQ/UrIrqmRhZBIfG3zDiYlAcdwkJRQuQI0mxz6qr0GC0nX8Ni6A/rd/74S
         1buIGmbFtffZ+a2vSFyaVxpH7zX05iznOPZeGWeCckrvFwrEXIFKE8bQrcG0Hp4riH0s
         eI8g==
X-Gm-Message-State: ANoB5pmHBbEt8OUyNKQlvPk93EzboLtEeO24JNab17o+FSCGsEJkRO8h
        tpY/WPhqaICeU/M4jCSrsw==
X-Google-Smtp-Source: AA0mqf7LzM4I6ggytAOrMmBYRLRAfM5DiOv4cQPoS7dQx4pulzdlQzfhgkQnI7OOk5NA1ImdkULn5w==
X-Received: by 2002:a92:c80e:0:b0:300:e232:e0c3 with SMTP id v14-20020a92c80e000000b00300e232e0c3mr4631999iln.320.1669241622484;
        Wed, 23 Nov 2022 14:13:42 -0800 (PST)
Received: from robh_at_kernel.org ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id b2-20020a92ce02000000b00302aa2a202dsm5463509ilo.64.2022.11.23.14.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 14:13:42 -0800 (PST)
Received: (nullmailer pid 2599122 invoked by uid 1000);
        Wed, 23 Nov 2022 22:13:43 -0000
Date:   Wed, 23 Nov 2022 16:13:43 -0600
From:   Rob Herring <robh@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH 4/6] dt-bindings: net: marvell,prestera: Describe PCI
 devices of the prestera family
Message-ID: <20221123221343.GA2595383-robh@kernel.org>
References: <20221117215557.1277033-1-miquel.raynal@bootlin.com>
 <20221117215557.1277033-5-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117215557.1277033-5-miquel.raynal@bootlin.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 10:55:55PM +0100, Miquel Raynal wrote:
> Even though the devices have very little in common beside the name and
> the main "switch" feature, Marvell Prestera switch family is also
> composed of PCI-only devices which can receive additional static
> properties, like nvmem cells to point at MAC addresses, for
> instance. Let's describe them.
> 
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  .../bindings/net/marvell,prestera.yaml        | 55 ++++++++++++++++---
>  1 file changed, 48 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/marvell,prestera.yaml b/Documentation/devicetree/bindings/net/marvell,prestera.yaml
> index b0a3ecca406e..f159fadf86ec 100644
> --- a/Documentation/devicetree/bindings/net/marvell,prestera.yaml
> +++ b/Documentation/devicetree/bindings/net/marvell,prestera.yaml
> @@ -4,19 +4,24 @@
>  $id: http://devicetree.org/schemas/net/marvell,prestera.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Marvell Prestera AlleyCat3 switch
> +title: Marvell Prestera switch family
>  
>  maintainers:
>    - Miquel Raynal <miquel.raynal@bootlin.com>
>  
>  properties:
>    compatible:
> -    items:
> +    oneOf:
> +      - items:
> +          - enum:
> +              - marvell,prestera-98dx3236
> +              - marvell,prestera-98dx3336
> +              - marvell,prestera-98dx4251
> +          - const: marvell,prestera
>        - enum:
> -          - marvell,prestera-98dx3236
> -          - marvell,prestera-98dx3336
> -          - marvell,prestera-98dx4251
> -      - const: marvell,prestera
> +          - pci11ab,c804
> +          - pci11ab,c80c
> +          - pci11ab,cc1e
>  
>    reg:
>      maxItems: 1
> @@ -28,10 +33,33 @@ properties:
>      description: Reference to the DFX Server bus node.
>      $ref: /schemas/types.yaml#/definitions/phandle
>  
> +  nvmem-cells: true
> +
> +  nvmem-cell-names: true
> +
> +if:
> +  properties:
> +    compatible:
> +      contains:
> +        const: marvell,prestera
> +
> +# Memory mapped AlleyCat3 family
> +then:
> +  properties:
> +    nvmem-cells: false
> +    nvmem-cell-names: false
> +  required:
> +    - interrupts
> +
> +# PCI Aldrin family
> +else:
> +  properties:
> +    interrupts: false
> +    dfx: false
> +
>  required:
>    - compatible
>    - reg
> -  - interrupts
>  
>  additionalProperties: false
>  
> @@ -43,3 +71,16 @@ examples:
>          interrupts = <33>, <34>, <35>;
>          dfx = <&dfx>;
>      };
> +
> +  - |
> +    pcie {
> +        #address-cells = <3>;
> +        #size-cells = <2>;

           ranges;
           device_type = "pci";

With that,

Reviewed-by: Rob Herring <robh@kernel.org>

> +
> +        switch@0,0 {
> +            reg = <0x0 0x0 0x0 0x0 0x0>;
> +            compatible = "pci11ab,c80c";
> +            nvmem-cells = <&mac_address 0>;
> +            nvmem-cell-names = "mac-address";
> +        };
> +    };
> -- 
> 2.34.1
> 
> 
