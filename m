Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB115B5BC8
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 16:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiILOBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 10:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiILOBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 10:01:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F3F25EA2;
        Mon, 12 Sep 2022 07:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RU+T8Uf+o61IUFzmgdPBOFc/XVJr6YEIpQ2GfXFvfZE=; b=m1KUt9sAvVB7sHf1vzTt1mT4e2
        h04cE1UEKlSmAStNvek3cKsp/cksRAe7OlnfLU/KBzeKXpEl+28yw8zRK3Qmaj8SVfRnGQg0uqYdX
        oP/1cnH/CDHJGeuKekncuFh+Ne0WilgZHz3jXqc3uPS5Lo23ucDg5kHNtRNm8+06oHduJYOq7F2IM
        nGa8o9LV4IvdvHUTZZklRqmjhChimalG8qBuQ72UbUJzF3tLqWw1yz08EkiVLZ/YF7o2zd5vK8Vt/
        mcDs1Gq83wt2k1yia5ma00l6ujj6VmMA411gFu3jAegFcJ65QzUFvlrEOiNT0oGfvihtoXieSBzNN
        ZkB8KkIg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34264)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oXjzr-0001kf-60; Mon, 12 Sep 2022 15:01:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oXjzm-00089o-Fm; Mon, 12 Sep 2022 15:01:06 +0100
Date:   Mon, 12 Sep 2022 15:01:06 +0100
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
Message-ID: <Yx87omI/la1o+Aye@shell.armlinux.org.uk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
 <E1oXg7N-0064ug-9l@rmk-PC.armlinux.org.uk>
 <20220912115911.e7dlm2xugfq57mei@bang-olufsen.dk>
 <Yx8gasTCj90Q5qZz@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yx8gasTCj90Q5qZz@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 01:04:58PM +0100, Russell King (Oracle) wrote:
> On Mon, Sep 12, 2022 at 11:59:17AM +0000, Alvin Šipraga wrote:
> > On Mon, Sep 12, 2022 at 10:52:41AM +0100, Russell King wrote:
> > > From: Hector Martin <marcan@marcan.st>
> > > 
> > > This binding is currently used for SDIO devices, but these chips are
> > > also used as PCIe devices on DT platforms and may be represented in the
> > > DT. Re-use the existing binding and add chip compatibles used by Apple
> > > T2 and M1 platforms (the T2 ones are not known to be used in DT
> > > platforms, but we might as well document them).
> > > 
> > > Then, add properties required for firmware selection and calibration on
> > > M1 machines.
> > > 
> > > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > > Signed-off-by: Hector Martin <marcan@marcan.st>
> > > Reviewed-by: Mark Kettenis <kettenis@openbsd.org>
> > > Reviewed-by: Rob Herring <robh@kernel.org>
> > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  .../net/wireless/brcm,bcm4329-fmac.yaml       | 39 +++++++++++++++++--
> > >  1 file changed, 35 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> > > index 53b4153d9bfc..fec1cc9b9a08 100644
> > > --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> > > +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> > > @@ -4,7 +4,7 @@
> > >  $id: http://devicetree.org/schemas/net/wireless/brcm,bcm4329-fmac.yaml#
> > >  $schema: http://devicetree.org/meta-schemas/core.yaml#
> > >  
> > > -title: Broadcom BCM4329 family fullmac wireless SDIO devices
> > > +title: Broadcom BCM4329 family fullmac wireless SDIO/PCIE devices
> > >  
> > >  maintainers:
> > >    - Arend van Spriel <arend@broadcom.com>
> > > @@ -41,11 +41,17 @@ title: Broadcom BCM4329 family fullmac wireless SDIO devices
> > >                - cypress,cyw4373-fmac
> > >                - cypress,cyw43012-fmac
> > >            - const: brcm,bcm4329-fmac
> > > -      - const: brcm,bcm4329-fmac
> > > +      - enum:
> > > +          - brcm,bcm4329-fmac
> > > +          - pci14e4,43dc  # BCM4355
> > > +          - pci14e4,4464  # BCM4364
> > > +          - pci14e4,4488  # BCM4377
> > > +          - pci14e4,4425  # BCM4378
> > > +          - pci14e4,4433  # BCM4387
> > >  
> > >    reg:
> > > -    description: SDIO function number for the device, for most cases
> > > -      this will be 1.
> > > +    description: SDIO function number for the device (for most cases
> > > +      this will be 1) or PCI device identifier.
> > >  
> > >    interrupts:
> > >      maxItems: 1
> > > @@ -85,6 +91,31 @@ title: Broadcom BCM4329 family fullmac wireless SDIO devices
> > >        takes precedence.
> > >      type: boolean
> > >  
> > > +  brcm,cal-blob:
> > > +    $ref: /schemas/types.yaml#/definitions/uint8-array
> > > +    description: A per-device calibration blob for the Wi-Fi radio. This
> > > +      should be filled in by the bootloader from platform configuration
> > > +      data, if necessary, and will be uploaded to the device if present.
> > 
> > Is this a leftover from a previous revision of the patchset? Because as
> > far as I can tell, the CLM blob is (still) being loaded via firmware,
> > and no additional parsing has been added for this particular OF
> > property. Should it be dropped?
> 
> It does appear to be unparsed, but I don't know whether it's needed for
> the binding or not. I'll wait for the Asahi folk to review your comment
> before possibly removing it.

Okay, the answer is, it is still very much part of the binding, and
the m1n1 boot loader populates it.

This series is a subset of a larger series (remember the previous 34
or 35 patch series?), so there are things in the binding document
which are not included in this series.

I don't think it makes sense to break up the binding document given
that it has already been reviewed several times in its current state,
should we really remove this one property and throw away all that
review effort.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
