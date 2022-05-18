Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E627C52C0A6
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 19:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239909AbiERQS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 12:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiERQS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 12:18:56 -0400
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6A51E3EEC;
        Wed, 18 May 2022 09:18:55 -0700 (PDT)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-e5e433d66dso3346137fac.5;
        Wed, 18 May 2022 09:18:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/MyoCGq2VWVpo7SBIB/58064GZHtt0wZs5K/WZdIRXs=;
        b=u5jsFe1kRB/NMRTq7pgA9pZRlsumJUjVYckHamXWPycEMZyAtl7wPoQwbiXiclHTx1
         0FcslZOTnvBpdhxXy3iMQ1IQcBRctp92lo2iu81/iyuvL16YXaYrXsd1zlIYjQaTxYec
         Q0i+4hS+Dcl3URKLqmVi8kkVHlGi46ynRbIlcti5IvEwDWJ4iLAgHNIGU6u8NJO3svwK
         9nlLz30gNGmp7yfn1pAKgjM5sLqICgVxE/sSi7/FHPKQCLSNJQ+DcBTSbdAd68lxJoIP
         1xqn+3tVsTSg/xmbK6NLonxShDBb1zrUR5LuDb/n1wzg8myBAFFZgtu5sVEpq3HmS3+y
         vLCg==
X-Gm-Message-State: AOAM531Anw6B4zZlQZDPKK828a1kdjhdf82ofvqbkFPGXnj+5Np0g9yy
        7SpPABvD12xPsSid6SjAJw==
X-Google-Smtp-Source: ABdhPJwz/GPmboPN+VTSPPUD+3tp6HbBBOg0MGYEw2Di9OctH7CvK91XSdkKH2SVORLP2sLllNHRfA==
X-Received: by 2002:a05:6870:79a:b0:e9:109a:1391 with SMTP id en26-20020a056870079a00b000e9109a1391mr116683oab.105.1652890734317;
        Wed, 18 May 2022 09:18:54 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id q15-20020a056870828f00b000e686d13887sm1093978oae.33.2022.05.18.09.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 09:18:53 -0700 (PDT)
Received: (nullmailer pid 3430964 invoked by uid 1000);
        Wed, 18 May 2022 16:18:52 -0000
Date:   Wed, 18 May 2022 11:18:52 -0500
From:   Rob Herring <robh@kernel.org>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH v2] dt-bindings: net: orion-mdio: Convert to JSON schema
Message-ID: <20220518161852.GD3302100-robh@kernel.org>
References: <20220505210621.3637268-1-chris.packham@alliedtelesis.co.nz>
 <20220516181639.GB2997786-robh@kernel.org>
 <0c67af76-df5e-1684-820c-f28aa6f50fe1@alliedtelesis.co.nz>
 <cf956c25-f505-6ec0-260c-496c7d1322a1@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf956c25-f505-6ec0-260c-496c7d1322a1@alliedtelesis.co.nz>
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

On Mon, May 16, 2022 at 10:27:42PM +0000, Chris Packham wrote:
> 
> On 17/05/22 10:18, Chris Packham wrote:
> > Hi Rob,
> >
> > On 17/05/22 06:16, Rob Herring wrote:
> >> On Fri, May 06, 2022 at 09:06:20AM +1200, Chris Packham wrote:
> >>> Convert the marvell,orion-mdio binding to JSON schema.
> >>>
> >>> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> >>> ---
> >>>
> >>> Notes:
> >>>      This does throw up the following dtbs_check warnings for 
> >>> turris-mox:
> >>> arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004: 
> >>> switch0@10:reg: [[16], [0]] is too long
> >>>              From schema: 
> >>> Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
> >>>      arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: 
> >>> mdio@32004: switch0@2:reg: [[2], [0]] is too long
> >>>              From schema: 
> >>> Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
> >>>      arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: 
> >>> mdio@32004: switch1@11:reg: [[17], [0]] is too long
> >>>              From schema: 
> >>> Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
> >>>      arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: 
> >>> mdio@32004: switch1@2:reg: [[2], [0]] is too long
> >>>              From schema: 
> >>> Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
> >>>      arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: 
> >>> mdio@32004: switch2@12:reg: [[18], [0]] is too long
> >>>              From schema: 
> >>> Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
> >>>      arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: 
> >>> mdio@32004: switch2@2:reg: [[2], [0]] is too long
> >>>              From schema: 
> >>> Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
> >>>           I think they're all genuine but I'm hesitant to leap in 
> >>> and fix them
> >>>      without being able to test them.
> >>>           I also need to set unevaluatedProperties: true to cater 
> >>> for the L2
> >>>      switch on turris-mox (and probably others). That might be 
> >>> better tackled
> >>>      in the core mdio.yaml schema but I wasn't planning on touching 
> >>> that.
> >>>           Changes in v2:
> >>>      - Add Andrew as maintainer (thanks for volunteering)
> >>>
> >>>   .../bindings/net/marvell,orion-mdio.yaml      | 60 
> >>> +++++++++++++++++++
> >>>   .../bindings/net/marvell-orion-mdio.txt       | 54 -----------------
> >>>   2 files changed, 60 insertions(+), 54 deletions(-)
> >>>   create mode 100644 
> >>> Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
> >>>   delete mode 100644 
> >>> Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
> >>>
> >>> diff --git 
> >>> a/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml 
> >>> b/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
> >>> new file mode 100644
> >>> index 000000000000..fe3a3412f093
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
> >>> @@ -0,0 +1,60 @@
> >>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> >>> +%YAML 1.2
> >>> +---
> >>> +$id: 
> >>> http://scanmail.trustwave.com/?c=20988&d=j5WC4r_pZnDMILajH1kaKLL9oC7kQjgv_bkDWJOhEQ&u=http%3a%2f%2fdevicetree%2eorg%2fschemas%2fnet%2fmarvell%2corion-mdio%2eyaml%23
> >>> +$schema: 
> >>> http://scanmail.trustwave.com/?c=20988&d=j5WC4r_pZnDMILajH1kaKLL9oC7kQjgv_e4CDcetEw&u=http%3a%2f%2fdevicetree%2eorg%2fmeta-schemas%2fcore%2eyaml%23
> >>> +
> >>> +title: Marvell MDIO Ethernet Controller interface
> >>> +
> >>> +maintainers:
> >>> +  - Andrew Lunn <andrew@lunn.ch>
> >>> +
> >>> +description: |
> >>> +  The Ethernet controllers of the Marvel Kirkwood, Dove, Orion5x, 
> >>> MV78xx0,
> >>> +  Armada 370, Armada XP, Armada 7k and Armada 8k have an identical 
> >>> unit that
> >>> +  provides an interface with the MDIO bus. Additionally, Armada 7k 
> >>> and Armada
> >>> +  8k has a second unit which provides an interface with the xMDIO 
> >>> bus. This
> >>> +  driver handles these interfaces.
> >>> +
> >>> +allOf:
> >>> +  - $ref: "mdio.yaml#"
> >>> +
> >>> +properties:
> >>> +  compatible:
> >>> +    enum:
> >>> +      - marvell,orion-mdio
> >>> +      - marvell,xmdio
> >>> +
> >>> +  reg:
> >>> +    maxItems: 1
> >>> +
> >>> +  interrupts:
> >>> +    maxItems: 1
> >>> +
> >>> +  clocks:
> >>> +    minItems: 1
> >>> +    maxItems: 4
> >> Really this should be better defined, but the original was not.
> >>
> >>> +
> >>> +required:
> >>> +  - compatible
> >>> +  - reg
> >>> +
> >>> +unevaluatedProperties: true
> >> This must be false.
> >
> > Right now there is no way (that I have found) of dealing with non-PHY 
> > devices like the dsa switches so setting this to false generates 
> > warnings on turris-mox:
> >
> > arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dtb: mdio@32004: 
> > Unevaluated properties are not allowed ('#address-cells', 
> > '#size-cells', 'ethernet-phy@1', 'switch0@10', 'switch0@2', 
> > 'switch1@11', 'switch1@2', 'switch2@12', 'switch2@2' were unexpected)
> >         From schema: 
> > /home/chrisp/src/linux/Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml
> >
> > There are also warnings about the size of the reg property but these 
> > seem to be genuine problems that Marek is looking at.
> Actually it looks if I fix the reg problem the need for 
> unevaluatedProperties goes away. I'll whip up a small patch series on 
> top of net-next.

Yeah, it's confusing. It seems 'evaluated and failed' counts as 
unevaluated. Seems to be a quirk of json-schema itself rather than the 
specific implementation AFAICT.

Rob
