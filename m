Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A485509129
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 22:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347020AbiDTUOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 16:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbiDTUOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 16:14:15 -0400
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC06337BFE;
        Wed, 20 Apr 2022 13:11:28 -0700 (PDT)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-e2afb80550so3196660fac.1;
        Wed, 20 Apr 2022 13:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=yg1QMdJD0jJidIacTdvCTSB235cSU+8ZTTNRkM2ZhJM=;
        b=c4pIxYy1XlZmICyjmUlFECXjMtsTtDdB+SOS0fPzI41ybSOyINq5r38bIuBYfQ+ziv
         IgkYJFjB1EcAnAJxdLfJmoKSbyhhEV8o4l/6v3V506iJHTwQINViNnElCLzo6uiuQmJ8
         sycqnJDi5WN7tqt0sei8zTpeacaQo+0ey+ORuwXZjQg0t56k04N+pbGkSvnTQLdtKQVF
         dAxVNwMg7cFRGy/urYDCYlq7SpGbGDYE7oejLzd0lSDCnsBq1/238uqcswXHZOV2l/f1
         wZLXX1tP/eY9xek5ui3xOCgpjnqEbZkViN1TBn5O/B4a5sCvELv29pawvxAqJcMBhZ32
         iuLQ==
X-Gm-Message-State: AOAM532mzbjlZf1c43nwqiIdawSvldirDCTjyZ4q2E5TwIpR6UFwkFAT
        L+wTZA3l6ij+S2+2LBgZSA==
X-Google-Smtp-Source: ABdhPJzk0iwR/4QLK+YIVMDxkKcItJAz53c1pSD6X7dA6YF5QyXZfuX7erDU2k1C6MEjztKQmcAGiw==
X-Received: by 2002:a05:6870:4252:b0:e6:3ad5:cff6 with SMTP id v18-20020a056870425200b000e63ad5cff6mr2290495oac.196.1650485488205;
        Wed, 20 Apr 2022 13:11:28 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id g5-20020a9d5f85000000b006057056774esm380928oti.33.2022.04.20.13.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 13:11:27 -0700 (PDT)
Received: (nullmailer pid 1770236 invoked by uid 1000);
        Wed, 20 Apr 2022 20:11:26 -0000
Date:   Wed, 20 Apr 2022 15:11:26 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 03/12] dt-bindings: net: pcs: add bindings for
 Renesas RZ/N1 MII converter
Message-ID: <YmBo7sj+PXoJaqo8@robh.at.kernel.org>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-4-clement.leger@bootlin.com>
 <Yl68k22fUw7uBgV9@robh.at.kernel.org>
 <20220419170044.450050ca@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220419170044.450050ca@fixe.home>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 05:00:44PM +0200, Clément Léger wrote:
> Le Tue, 19 Apr 2022 08:43:47 -0500,
> Rob Herring <robh@kernel.org> a écrit :
> 
> > > +  clocks:
> > > +    items:
> > > +      - description: MII reference clock
> > > +      - description: RGMII reference clock
> > > +      - description: RMII reference clock
> > > +      - description: AHB clock used for the MII converter register interface
> > > +
> > > +  renesas,miic-cfg-mode:
> > > +    description: MII mux configuration mode. This value should use one of the
> > > +                 value defined in dt-bindings/net/pcs-rzn1-miic.h.  
> > 
> > Describe possible values here as constraints. At present, I don't see 
> > the point of this property if there is only 1 possible value and it is 
> > required.
> 
> The ethernet subsystem contains a number of internal muxes that allows
> to configure ethernet routing. This configuration option allows to set
> the register that configure these muxes.
> 
> After talking with Andrew, I considered moving to something like this:
> 
> eth-miic@44030000 {
>   compatible = "renesas,rzn1-miic";
> 
>   mii_conv1: mii-conv-1 {
>     renesas,miic-input = <MIIC_GMAC1_PORT>;
>     port = <1>;

'port' is already used, find another name. Maybe 'reg' here. Don't know. 
What do 1 and 2 represent?


>   };
>   mii_conv2: mii-conv-2 {
>     renesas,miic-input = <MIIC_SWITCHD_PORT>;
>     port = <2>;
>   };
>    ...
> };
> 
> Which would allow embedding the configuration inside the port
> sub-nodes. Moreover, it allows a better validation of the values using
> the schema validation directly since only a limited number of values
> are allowed for each port.
> 
> > 
> > > +    $ref: /schemas/types.yaml#/definitions/uint32
> > > +  
> > > +patternProperties:
> > > +  "^mii-conv@[0-4]$":
> > > +    type: object  
> > 
> >        additionalProperties: false
> > 
> > > +    description: MII converter port
> > > +
> > > +    properties:
> > > +      reg:
> > > +        maxItems: 1  
> > 
> > Why do you need sub-nodes? They don't have any properties. A simple mask 
> > property could tell you which ports are present/active/enabled if that's 
> > what you are tracking. Or the SoC specific compatibles you need to add 
> > can imply the ports if they are SoC specific.
> 
> The MACs are using phandles to these sub-nodes to query a specific MII
> converter port PCS:
> 
> switch@44050000 {
>     compatible = "renesas,rzn1-a5psw";
> 
>     ports {
>         port@0 {

ethernet-ports and ethernet-port so we don't collide with the graph 
binding.


>             reg = <0>;
>             label = "lan0";
>             phy-handle = <&switch0phy3>;
>             pcs-handle = <&mii_conv4>;
>         };
>     };
> };
> 
> According to Andrew, this is not a good idea to represent the PCS as a
> bus since it is indeed not a bus. I could also switch to something like
> pcs-handle = <&eth_mii 4> but i'm not sure what you'd prefer. We could
> also remove this from the device-tree and consider each driver to
> request the MII ouput to be configured using something like this for
> instance:

I'm pretty sure we already defined pcs-handle as only a phandle. If you 
want variable cells, then it's got to be extended like all the other 
properties using that pattern.

> 
>  miic_request_pcs(pcs_np, miic_port_nr, MIIC_SWITCHD_PORT);
> 
> But I'm not really fan of this because it requires the drivers to
> assume some specificities of the MII converter (port number are not in
> the same order of the switch for instance) and thus I would prefer this
> to be in the device-tree.
> 
> Let me know if you can think of something that would suit you
> better but  keep in mind that I need to correctly match a switch/MAC
> port with a PCS port and that I also need to configure MII internal
> muxes. 
> 
> For more information, you can look at section 8 of the manual at [1].

I can't really. Other people want their bindings reviewed too.

Rob
