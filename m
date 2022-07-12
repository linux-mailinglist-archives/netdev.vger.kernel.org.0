Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0F6572648
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 21:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbiGLTqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 15:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbiGLTqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 15:46:18 -0400
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365A8B7D77;
        Tue, 12 Jul 2022 12:36:55 -0700 (PDT)
Received: by mail-io1-f42.google.com with SMTP id y2so8860534ior.12;
        Tue, 12 Jul 2022 12:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FCz9giN1y8D5RRiEJxyyLtO77K8fLr29mBbOuViLcRQ=;
        b=5HhT9URiVhFbelrJhE18xnoI0exSsfEUvej+9wkqEly1paxEqsjznlX6N62erLf/ut
         DYyToZWQZCSM7+61aGJTDwrn/hZKyKMGMpZPTh5kXQ+HDr0d2VQdP/3v2UbzWi5RK29A
         qUFWXetvyRLDoLI4ll1JqEcMFnBNXEASoN7yGUvA1PcBSDk/QN7K2iA8GAVHcKJVMODB
         DCdMUC7aFop7aKj6MRpj1t+GlOvQPsA97DMKmk5K2OY1BKSZkaOdx8vTdS8UrfxGMWPm
         arCCOC1xIDdxS6v8+40/I9HFrZ0IF6In/Z2uHj2GM3Sj0xGMnuVazyH87iciKPi1vJsr
         8aOA==
X-Gm-Message-State: AJIora8ZNeCkhfUv1a+Qa7Nt8k3Q3A2oCbc5BD/apogw8+qVR7ulWlUz
        3x0ICyiooXLCfLlQD1ae2g==
X-Google-Smtp-Source: AGRyM1vadDEy7jk0/x/ZutR1thOuPrFfdoKFa0KdUYoX8sbTqqYQvnInt9StfljBWfdfaXfcafRpkA==
X-Received: by 2002:a05:6638:1406:b0:33f:5eae:a52d with SMTP id k6-20020a056638140600b0033f5eaea52dmr5225907jad.243.1657654614343;
        Tue, 12 Jul 2022 12:36:54 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id w3-20020a02b0c3000000b0033f3dd2e7e7sm4397870jah.44.2022.07.12.12.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 12:36:53 -0700 (PDT)
Received: (nullmailer pid 2238514 invoked by uid 1000);
        Tue, 12 Jul 2022 19:36:51 -0000
Date:   Tue, 12 Jul 2022 13:36:51 -0600
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 03/35] dt-bindings: net: fman: Add additional
 interface properties
Message-ID: <20220712193651.GL1823936-robh@kernel.org>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-4-sean.anderson@seco.com>
 <20220630160156.GA2745952-robh@kernel.org>
 <e154ff02-7bcd-916a-0ec4-56bf624ccf7b@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e154ff02-7bcd-916a-0ec4-56bf624ccf7b@seco.com>
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

On Thu, Jun 30, 2022 at 12:11:10PM -0400, Sean Anderson wrote:
> Hi Rob,
> 
> On 6/30/22 12:01 PM, Rob Herring wrote:
> > On Tue, Jun 28, 2022 at 06:13:32PM -0400, Sean Anderson wrote:
> >> At the moment, mEMACs are configured almost completely based on the
> >> phy-connection-type. That is, if the phy interface is RGMII, it assumed
> >> that RGMII is supported. For some interfaces, it is assumed that the
> >> RCW/bootloader has set up the SerDes properly. This is generally OK, but
> >> restricts runtime reconfiguration. The actual link state is never
> >> reported.
> >> 
> >> To address these shortcomings, the driver will need additional
> >> information. First, it needs to know how to access the PCS/PMAs (in
> >> order to configure them and get the link status). The SGMII PCS/PMA is
> >> the only currently-described PCS/PMA. Add the XFI and QSGMII PCS/PMAs as
> >> well. The XFI (and 1GBase-KR) PCS/PMA is a c45 "phy" which sits on the
> >> same MDIO bus as SGMII PCS/PMA. By default they will have conflicting
> >> addresses, but they are also not enabled at the same time by default.
> >> Therefore, we can let the XFI PCS/PMA be the default when
> >> phy-connection-type is xgmii. This will allow for
> >> backwards-compatibility.
> >> 
> >> QSGMII, however, cannot work with the current binding. This is because
> >> the QSGMII PCS/PMAs are only present on one MAC's MDIO bus. At the
> >> moment this is worked around by having every MAC write to the PCS/PMA
> >> addresses (without checking if they are present). This only works if
> >> each MAC has the same configuration, and only if we don't need to know
> >> the status. Because the QSGMII PCS/PMA will typically be located on a
> >> different MDIO bus than the MAC's SGMII PCS/PMA, there is no fallback
> >> for the QSGMII PCS/PMA.
> >> 
> >> mEMACs (across all SoCs) support the following protocols:
> >> 
> >> - MII
> >> - RGMII
> >> - SGMII, 1000Base-X, and 1000Base-KX
> >> - 2500Base-X (aka 2.5G SGMII)
> >> - QSGMII
> >> - 10GBase-R (aka XFI) and 10GBase-KR
> >> - XAUI and HiGig
> >> 
> >> Each line documents a set of orthogonal protocols (e.g. XAUI is
> >> supported if and only if HiGig is supported). Additionally,
> >> 
> >> - XAUI implies support for 10GBase-R
> >> - 10GBase-R is supported if and only if RGMII is not supported
> >> - 2500Base-X implies support for 1000Base-X
> >> - MII implies support for RGMII
> >> 
> >> To switch between different protocols, we must reconfigure the SerDes.
> >> This is done by using the standard phys property. We can also use it to
> >> validate whether different protocols are supported (e.g. using
> >> phy_validate). This will work for serial protocols, but not RGMII or
> >> MII. Additionally, we still need to be compatible when there is no
> >> SerDes.
> >> 
> >> While we can detect 10G support by examining the port speed (as set by
> >> fsl,fman-10g-port), we cannot determine support for any of the other
> >> protocols based on the existing binding. In fact, the binding works
> >> against us in some respects, because pcsphy-handle is required even if
> >> there is no possible PCS/PMA for that MAC. To allow for backwards-
> >> compatibility, we use a boolean-style property for RGMII (instead of
> >> presence/absence-style). When the property for RGMII is missing, we will
> >> assume that it is supported. The exception is MII, since no existing
> >> device trees use it (as far as I could tell).
> >> 
> >> Unfortunately, QSGMII support will be broken for old device trees. There
> >> is nothing we can do about this because of the PCS/PMA situation (as
> >> described above).
> >> 
> >> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> >> ---
> >> 
> >> Changes in v2:
> >> - Better document how we select which PCS to use in the default case
> >> 
> >>  .../bindings/net/fsl,fman-dtsec.yaml          | 52 +++++++++++++++++--
> >>  .../devicetree/bindings/net/fsl-fman.txt      |  5 +-
> >>  2 files changed, 51 insertions(+), 6 deletions(-)
> >> 
> >> diff --git a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
> >> index 809df1589f20..ecb772258164 100644
> >> --- a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
> >> +++ b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
> >> @@ -85,9 +85,41 @@ properties:
> >>      $ref: /schemas/types.yaml#/definitions/phandle
> >>      description: A reference to the IEEE1588 timer
> >>  
> >> +  phys:
> >> +    description: A reference to the SerDes lane(s)
> >> +    maxItems: 1
> >> +
> >> +  phy-names:
> >> +    items:
> >> +      - const: serdes
> >> +
> >>    pcsphy-handle:
> >> -    $ref: /schemas/types.yaml#/definitions/phandle
> >> -    description: A reference to the PCS (typically found on the SerDes)
> >> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> >> +    minItems: 1
> >> +    maxItems: 3
> > 
> > What determines how many entries?
> 
> It depends on what the particular MAC supports. From what I can tell, the following
> combinations are valid:
> 
> - Neither SGMII, QSGMII, or XFI
> - Just SGMII
> - Just QSGMII
> - SGMII and QSGMII
> - SGMII and XFI
> - All of SGMII, QSGMII, and XFI
> 
> All of these are used on different SoCs.

So there will be a different PCS device for SGMII, QSGMII, and XFI 
rather than 1 PCS device that supports those 3 interfaces?


> >> +    description: |
> >> +      A reference to the various PCSs (typically found on the SerDes). If
> >> +      pcs-names is absent, and phy-connection-type is "xgmii", then the first
> >> +      reference will be assumed to be for "xfi". Otherwise, if pcs-names is
> >> +      absent, then the first reference will be assumed to be for "sgmii".
> >> +
> >> +  pcs-names:
> >> +    $ref: /schemas/types.yaml#/definitions/string-array
> >> +    minItems: 1
> >> +    maxItems: 3
> >> +    contains:
> >> +      enum:
> >> +        - sgmii
> >> +        - qsgmii
> >> +        - xfi
> > 
> > This means '"foo", "xfi", "bar"' is valid. I think you want to 
> > s/contains/items/.
> > 
> >> +    description: The type of each PCS in pcsphy-handle.
> >> +
> > 
> >> +  rgmii:
> >> +    enum: [0, 1]
> >> +    description: 1 indicates RGMII is supported, and 0 indicates it is not.
> >> +
> >> +  mii:
> >> +    description: If present, indicates that MII is supported.
> > 
> > Types? Need vendor prefixes.
> 
> OK.
> 
> > Are these board specific or SoC specific? Properties are appropriate for 
> > the former. The latter case should be implied by the compatible string.
> 
> Unfortunately, there are not existing specific compatible strings for each
> device in each SoC. I suppose those could be added; however, this basically
> reflects how each device is hooked up. E.g. on one SoC a device would be
> connected to the RGMII pins, but not on another SoC. The MAC itself still
> has hardware support for RGMII, but such a configuration would not function.

A difference in instances on a given SoC would also be reason for 
properties rather than different compatible strings. However, we already 
have such properties. We have 'phy-connection-type' for which mode to 
use. Do you have some need to know all possible modes? I think there was 
something posted to allow 'phy-connection-type' to be an array of 
supported modes instead.

Rob
