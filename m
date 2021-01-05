Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECEB2EB23F
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 19:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbhAESMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 13:12:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:56244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbhAESMm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 13:12:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1791722D06;
        Tue,  5 Jan 2021 18:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609870321;
        bh=/reYBV40Ygz4hCARqF75dpeeGG0UhQDuHeRU1Mh/CCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dz7ZYIQwZi2PGezSrfZYXMAyFlGgRS3XZShhWjyXT3ufXIdHDHMXjuLt80KX6GoPf
         GG9vLFuw58bgfcX32hBzQHrbWIbM7IXR3efJsGv2iQnRdRw/2HGqFmSWyIJMZ/uav6
         zW8xJU3VSIzNihZH289zC2LwLXOyr6xIMVOafDGE=
Date:   Tue, 5 Jan 2021 19:13:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Stephen Boyd <sboyd@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Add missing array size constraints
Message-ID: <X/SsRVbYVXRX8Psq@kroah.com>
References: <20210104230253.2805217-1-robh@kernel.org>
 <X/RjziK30y56uZUj@kroah.com>
 <20210105174008.GB1875909@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105174008.GB1875909@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 10:40:08AM -0700, Rob Herring wrote:
> On Tue, Jan 05, 2021 at 02:04:14PM +0100, Greg Kroah-Hartman wrote:
> > On Mon, Jan 04, 2021 at 04:02:53PM -0700, Rob Herring wrote:
> > > DT properties which can have multiple entries need to specify what the
> > > entries are and define how many entries there can be. In the case of
> > > only a single entry, just 'maxItems: 1' is sufficient.
> > > 
> > > Add the missing entry constraints. These were found with a modified
> > > meta-schema. Unfortunately, there are a few cases where the size
> > > constraints are not defined such as common bindings, so the meta-schema
> > > can't be part of the normal checks.
> > > 
> > > Cc: Jens Axboe <axboe@kernel.dk>
> > > Cc: Stephen Boyd <sboyd@kernel.org>
> > > Cc: Thierry Reding <thierry.reding@gmail.com>
> > > Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> > > Cc: Chanwoo Choi <cw00.choi@samsung.com>
> > > Cc: Linus Walleij <linus.walleij@linaro.org>
> > > Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > > Cc: Jonathan Cameron <jic23@kernel.org>
> > > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Marc Zyngier <maz@kernel.org>
> > > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > > Cc: Chen-Yu Tsai <wens@csie.org>
> > > Cc: Ulf Hansson <ulf.hansson@linaro.org>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Sebastian Reichel <sre@kernel.org>
> > > Cc: Ohad Ben-Cohen <ohad@wizery.com>
> > > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Rob Herring <robh@kernel.org>
> > 
> > <snip>
> > 
> > > diff --git a/Documentation/devicetree/bindings/usb/generic-ehci.yaml b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
> > > index 247ef00381ea..f76b25f7fc7a 100644
> > > --- a/Documentation/devicetree/bindings/usb/generic-ehci.yaml
> > > +++ b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
> > > @@ -83,6 +83,7 @@ properties:
> > >        Phandle of a companion.
> > >  
> > >    phys:
> > > +    maxItems: 1
> > >      description: PHY specifier for the USB PHY
> > >  
> > >    phy-names:
> > > diff --git a/Documentation/devicetree/bindings/usb/generic-ohci.yaml b/Documentation/devicetree/bindings/usb/generic-ohci.yaml
> > > index 2178bcc401bc..8e2bd61f2075 100644
> > > --- a/Documentation/devicetree/bindings/usb/generic-ohci.yaml
> > > +++ b/Documentation/devicetree/bindings/usb/generic-ohci.yaml
> > > @@ -71,6 +71,7 @@ properties:
> > >        Overrides the detected port count
> > >  
> > >    phys:
> > > +    maxItems: 1
> > >      description: PHY specifier for the USB PHY
> > >  
> > >    phy-names:
> > > diff --git a/Documentation/devicetree/bindings/usb/ingenic,musb.yaml b/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
> > > index 678396eeeb78..f506225a4d57 100644
> > > --- a/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
> > > +++ b/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
> > > @@ -40,7 +40,7 @@ properties:
> > >        - const: mc
> > >  
> > >    phys:
> > > -    description: PHY specifier for the USB PHY
> > > +    maxItems: 1
> > >  
> > >    usb-role-switch:
> > >      type: boolean
> > 
> > Any reason you dropped the description for this entry, but not the other
> > ones above?
> 
> No, I should have dropped those too. I dropped cases of genericish 
> descriptions on common properties. There's nothing specific to this 
> binding here really.
> 
> > 
> > > diff --git a/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml b/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
> > > index 388245b91a55..adce36e48bc9 100644
> > > --- a/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
> > > +++ b/Documentation/devicetree/bindings/usb/ti,j721e-usb.yaml
> > > @@ -15,13 +15,14 @@ properties:
> > >        - const: ti,j721e-usb
> > >  
> > >    reg:
> > > -    description: module registers
> > > +    maxItems: 1
> > >  
> > >    power-domains:
> > >      description:
> > >        PM domain provider node and an args specifier containing
> > >        the USB device id value. See,
> > >        Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
> > > +    maxItems: 1
> > >  
> > >    clocks:
> > >      description: Clock phandles to usb2_refclk and lpm_clk
> > 
> > Same here, why remove the description?
> 
> Really, the question is why keep 'description' on power-domains. Perhaps 
> there's a little value in the reference to sci-pm-domain.txt, so I left 
> it.

Ok, if you are fine with this, that's ok with me, just didn't look very
consistent :)
