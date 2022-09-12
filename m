Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4B45B59EA
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 14:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiILMFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 08:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiILMFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 08:05:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC4419034;
        Mon, 12 Sep 2022 05:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=j6/6NyXkABDxPCoFNLrWNq2Gb8X6ZHRRd6O2jMaYp0c=; b=ZWmUzhiPgjJUB/qR83co0s5hBp
        kSc7QNaxkVwuQAM/geUwV3NdRHfFLPFL1/yf8DbeqaQdnb1vCOFzlDXlNH766Mgn1M5GzbH1zlKgi
        Xc9BUf0kIhjTWw04YJZNMNT6wO1QlP5eJAQPHS/ptf6pEITKk/4Fl9EEdmauXdrszisEmpNCdfUQA
        OfOfTHzyYa29bOKMDOGqV7E3/tQOk+4BazgY20gaKOCWz7pCwOuFMkIBUMkRRt2pXg2h+2yjzp0ru
        tcNl6ENZq+WfpUgFxdskzikOj2b4ek7xYIB7alCg78nYFaFzbZkxcqtPiP3y4UnNyFIki0VcfSGpI
        aiI6gk9g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34260)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oXiBS-0001ev-Kz; Mon, 12 Sep 2022 13:05:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oXiBO-00085S-Fm; Mon, 12 Sep 2022 13:04:58 +0100
Date:   Mon, 12 Sep 2022 13:04:58 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rafa__ Mi__ecki <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        Sven Peter <sven@svenpeter.dev>,
        van Spriel <arend@broadcom.com>
Subject: Re: [PATCH wireless-next v2 01/12] dt-bindings: net: bcm4329-fmac:
 Add Apple properties & chips
Message-ID: <Yx8gasTCj90Q5qZz@shell.armlinux.org.uk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
 <E1oXg7N-0064ug-9l@rmk-PC.armlinux.org.uk>
 <20220912115911.e7dlm2xugfq57mei@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220912115911.e7dlm2xugfq57mei@bang-olufsen.dk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 11:59:17AM +0000, Alvin Šipraga wrote:
> On Mon, Sep 12, 2022 at 10:52:41AM +0100, Russell King wrote:
> > From: Hector Martin <marcan@marcan.st>
> > 
> > This binding is currently used for SDIO devices, but these chips are
> > also used as PCIe devices on DT platforms and may be represented in the
> > DT. Re-use the existing binding and add chip compatibles used by Apple
> > T2 and M1 platforms (the T2 ones are not known to be used in DT
> > platforms, but we might as well document them).
> > 
> > Then, add properties required for firmware selection and calibration on
> > M1 machines.
> > 
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Hector Martin <marcan@marcan.st>
> > Reviewed-by: Mark Kettenis <kettenis@openbsd.org>
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> >  .../net/wireless/brcm,bcm4329-fmac.yaml       | 39 +++++++++++++++++--
> >  1 file changed, 35 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> > index 53b4153d9bfc..fec1cc9b9a08 100644
> > --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> > +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> > @@ -4,7 +4,7 @@
> >  $id: http://devicetree.org/schemas/net/wireless/brcm,bcm4329-fmac.yaml#
> >  $schema: http://devicetree.org/meta-schemas/core.yaml#
> >  
> > -title: Broadcom BCM4329 family fullmac wireless SDIO devices
> > +title: Broadcom BCM4329 family fullmac wireless SDIO/PCIE devices
> >  
> >  maintainers:
> >    - Arend van Spriel <arend@broadcom.com>
> > @@ -41,11 +41,17 @@ title: Broadcom BCM4329 family fullmac wireless SDIO devices
> >                - cypress,cyw4373-fmac
> >                - cypress,cyw43012-fmac
> >            - const: brcm,bcm4329-fmac
> > -      - const: brcm,bcm4329-fmac
> > +      - enum:
> > +          - brcm,bcm4329-fmac
> > +          - pci14e4,43dc  # BCM4355
> > +          - pci14e4,4464  # BCM4364
> > +          - pci14e4,4488  # BCM4377
> > +          - pci14e4,4425  # BCM4378
> > +          - pci14e4,4433  # BCM4387
> >  
> >    reg:
> > -    description: SDIO function number for the device, for most cases
> > -      this will be 1.
> > +    description: SDIO function number for the device (for most cases
> > +      this will be 1) or PCI device identifier.
> >  
> >    interrupts:
> >      maxItems: 1
> > @@ -85,6 +91,31 @@ title: Broadcom BCM4329 family fullmac wireless SDIO devices
> >        takes precedence.
> >      type: boolean
> >  
> > +  brcm,cal-blob:
> > +    $ref: /schemas/types.yaml#/definitions/uint8-array
> > +    description: A per-device calibration blob for the Wi-Fi radio. This
> > +      should be filled in by the bootloader from platform configuration
> > +      data, if necessary, and will be uploaded to the device if present.
> 
> Is this a leftover from a previous revision of the patchset? Because as
> far as I can tell, the CLM blob is (still) being loaded via firmware,
> and no additional parsing has been added for this particular OF
> property. Should it be dropped?

It does appear to be unparsed, but I don't know whether it's needed for
the binding or not. I'll wait for the Asahi folk to review your comment
before possibly removing it.

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
