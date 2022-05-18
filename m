Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE1E52B03E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbiERBzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiERBzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:55:02 -0400
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F4454BD7;
        Tue, 17 May 2022 18:55:01 -0700 (PDT)
Received: by mail-oi1-f173.google.com with SMTP id w130so1127409oig.0;
        Tue, 17 May 2022 18:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ckNmPcl7fe5xiocWvQwlJ3B7sjwM65UrQXbcw0Qh69c=;
        b=B57yfkwqMW8Hg8FpvgHOcG24D4SR2K1OGV6oQp79tT6nA6QuVkDBLfzQpPY1qYRBpu
         nWn7FTTQmde+pAdqpv1r9J7b/7HtFeKCaYE5y+14hgNgaoWt+q+dIoAc+klm57agpz9G
         WlmdpdAQ/+GmPIvTmNfoNH2xFspxyqNmCYMiUPwp4mWu5pROnMBXTAAA+OxMCLRNOiQI
         EIPqG9t6oeqFiRmj21ChmLUUfhfkCrXYbwwGYzbi75lemSYf2otHNGhCMQlPW5RXgV8u
         1voglQSPWezJF+PZ5+NNO9Q3yAC6WZXqsbPMcVj+yTHc8p4iOKzs4bO+3rwhdobDiYeP
         15xA==
X-Gm-Message-State: AOAM533R6oG0VY6jwKi7rgzsgVxiHn07Ws7AT/MSPpK1Pt2ino74WLJw
        EVmw7ofxDDS4BzBqzCV11eqexvSDaA==
X-Google-Smtp-Source: ABdhPJwKaRtIBExfohDctD5F8a5l+hdyd55lfF+Tzt7FpFR639U7gZCg8kE/+Q4JuJyS7fUtDHEamA==
X-Received: by 2002:a05:6808:188a:b0:326:7f5f:985c with SMTP id bi10-20020a056808188a00b003267f5f985cmr11975649oib.210.1652838901111;
        Tue, 17 May 2022 18:55:01 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id b11-20020acab20b000000b00326414c1bb7sm362362oif.35.2022.05.17.18.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 18:55:00 -0700 (PDT)
Received: (nullmailer pid 2063166 invoked by uid 1000);
        Wed, 18 May 2022 01:54:59 -0000
Date:   Tue, 17 May 2022 20:54:59 -0500
From:   Rob Herring <robh@kernel.org>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-rockchip@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: Re: [PATCH v3 1/6] dt-bindings: net: dsa: convert binding for
 mediatek switches
Message-ID: <20220518015459.GB2049643-robh@kernel.org>
References: <20220507170440.64005-1-linux@fw-web.de>
 <20220507170440.64005-2-linux@fw-web.de>
 <YnqymzCbabEjV7GQ@robh.at.kernel.org>
 <trinity-68761fe5-fcca-456b-ba50-ead759f0fb54-1652256165646@3c-app-gmx-bap47>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-68761fe5-fcca-456b-ba50-ead759f0fb54-1652256165646@3c-app-gmx-bap47>
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

On Wed, May 11, 2022 at 10:02:45AM +0200, Frank Wunderlich wrote:
> Hi
> 
> thanks for review
> 
> > Gesendet: Dienstag, 10. Mai 2022 um 20:44 Uhr
> > Von: "Rob Herring" <robh@kernel.org>
> > On Sat, May 07, 2022 at 07:04:35PM +0200, Frank Wunderlich wrote:
> > > From: Frank Wunderlich <frank-w@public-files.de>
> 
> > > +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> 
> > > +properties:
> > > +  compatible:
> > > +    enum:
> > > +      - mediatek,mt7530
> > > +      - mediatek,mt7531
> > > +      - mediatek,mt7621
> > > +
> >
> > > +  "#address-cells":
> > > +    const: 1
> > > +
> > > +  "#size-cells":
> > > +    const: 0
> >
> > I don't see any child nodes with addresses, so these can be removed.
> 
> dropping this (and address-cells/size-cells from examples) causes errors like this (address-/size-cells set in mdio
> node, so imho it should inherite):

I think you are off a level.


> Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.example.dts:34.25-35: Warning (reg_format):
> /example-0/mdio/switch@0/ports/port@0:reg: property has invalid length (4 bytes) (#address-cells == 2, #size-cells == 1)

That's for yet another level where 'ports' node need the properties.

> Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.example.dtb: Warning (pci_device_reg): Failed prerequisite 'reg_format'
> 
> > > +  interrupt-controller:
> > > +    type: boolean
> >
> > Already has a type. Just:
> >
> > interrupt-controller: true
> >
> > > +
> > > +  interrupts:
> > > +    maxItems: 1
> 
> > > +patternProperties:
> > > +  "^(ethernet-)?ports$":
> > > +    type: object
> >
> >        additionalProperties: false
> 
> imho this will block address-/size-cells from this level too. looks like it is needed here too (for port-regs).
> 
> > > +
> > > +    patternProperties:
> > > +      "^(ethernet-)?port@[0-9]+$":
> > > +        type: object
> > > +        description: Ethernet switch ports
> > > +
> > > +        unevaluatedProperties: false
> > > +
> > > +        properties:
> > > +          reg:
> > > +            description:
> > > +              Port address described must be 5 or 6 for CPU port and from 0
> > > +              to 5 for user ports.
> > > +
> > > +        allOf:
> > > +          - $ref: dsa-port.yaml#
> > > +          - if:
> > > +              properties:
> > > +                label:
> > > +                  items:
> > > +                    - const: cpu
> > > +            then:
> > > +              required:
> > > +                - reg
> > > +                - phy-mode
> > > +
> 
> > > +  - if:
> > > +      required:
> > > +        - interrupt-controller
> > > +    then:
> > > +      required:
> > > +        - interrupts
> >
> > This can be expressed as:
> >
> > dependencies:
> >   interrupt-controller: [ interrupts ]
> 
> ok, i will change this
> 
> > > +            ports {
> >
> > Use the preferred form: ethernet-ports
> 
> current implementation in all existing dts and examples from old binding are "ports" only.
> should they changed too?

They don't have to be the schema allows both, but the example should be 
best practice.

Rob

