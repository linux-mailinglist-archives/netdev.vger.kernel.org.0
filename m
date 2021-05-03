Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A89371198
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 08:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhECGWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 02:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbhECGWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 02:22:15 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71410C061756
        for <netdev@vger.kernel.org>; Sun,  2 May 2021 23:20:49 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id l2so4265852wrm.9
        for <netdev@vger.kernel.org>; Sun, 02 May 2021 23:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=CltrNoh0eYvI1vjWN4adv2w0aWXmdk6zgFIhvqFN/Jk=;
        b=Ja0BNPjTv+4EPYFnnkPro+GegUZWyQtPPgJxDddUR3Fn4pmylX50Flg2N1FM5kRMT0
         FyyZ30Qu7oVmEwrUA6826UGs2XyLKOYXSDey7yQayw+e1TOKa7GHfed2DiV6Kx5MnWO/
         mDvP1qSad1FK0la7WCHZ16KlEriGTOpyXP7S6TjxcZPW7/qLkr5Z0FCVhe2ds8JrJqg7
         BxT+Sbu5K5gjll6JJ+Zx0md505IAz5TpwvEfzixw7h48eBAnfbtMBbCB/diRFBkhQkSu
         UAks7cG6MNlB/NuC877ytz6Cznfb8L7ACUKAgTqD/sNbTFXLxQEwOU5kmAwnFi4jk9MN
         1/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CltrNoh0eYvI1vjWN4adv2w0aWXmdk6zgFIhvqFN/Jk=;
        b=eJTHKjcqiVzEZcESvSw0wVFkFn1nR97NRsSWeni0I9jGDefBFidx7RIChu4QIlNMa7
         qeK+2mToaUTV8QRxaQ+JIY6mzypy2F56C+sxo/wf0kqlF1WzUpEOXpSeS2mMX9LRVml8
         MP1h9J1DpPbBm04LL4EYR0T2PaM8ZeJaws08Ac6QXJZbDTQykDOJ3YqZkBBJ9L9bX6Sc
         61R9sxfXgiSAa8gXT055oSDsF1S1J638nIcASIyTGA7zpdamyxTkDeGQa0lJmp16C0mz
         QzIDnrBTtwSxRK8l6CIzLXqZhbM+JOUW4uM2XkBMcWzdiXa7PiiWhHPDvutyDozCLB0D
         tyEw==
X-Gm-Message-State: AOAM531im//l5iuJyMvXGrcQKxGb3ZuPA7DyX0bSNBX3zlOvdHJ8JBE8
        XXfjNxY4xkZ6HF1I8MI8tLN1xgVsGe5PaQ==
X-Google-Smtp-Source: ABdhPJzfrohhPIrRrL6Q8DB8YLmuXyqrCg6FxykbqGAztKmDX3JQu4exoYciafTS4gXx8M2MilLoXw==
X-Received: by 2002:adf:fd0c:: with SMTP id e12mr10964326wrr.111.1620022848176;
        Sun, 02 May 2021 23:20:48 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id q10sm10416141wmc.31.2021.05.02.23.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 23:20:47 -0700 (PDT)
Date:   Mon, 3 May 2021 08:20:45 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Rob Herring <robh@kernel.org>, andrew@lunn.ch
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] dt-bindings: net: Convert mdio-gpio to yaml
Message-ID: <YI+WPRAAbtmP9LC0@Red>
References: <20210430182941.915101-1-clabbe@baylibre.com>
 <20210430215325.GA3957879@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210430215325.GA3957879@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, Apr 30, 2021 at 04:53:25PM -0500, Rob Herring a écrit :
> On Fri, Apr 30, 2021 at 06:29:41PM +0000, Corentin Labbe wrote:
> > Converts net/mdio-gpio.txt to yaml
> > 
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> > Changes since v1:
> > - fixes yamllint warning about indent
> > - added maxItems 3
> > 
> > Changes since v2:
> > - fixed example (gpios need 2 entries)
> > 
> >  .../devicetree/bindings/net/mdio-gpio.txt     | 27 ---------
> >  .../devicetree/bindings/net/mdio-gpio.yaml    | 57 +++++++++++++++++++
> >  2 files changed, 57 insertions(+), 27 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/net/mdio-gpio.txt
> >  create mode 100644 Documentation/devicetree/bindings/net/mdio-gpio.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/net/mdio-gpio.txt b/Documentation/devicetree/bindings/net/mdio-gpio.txt
> > deleted file mode 100644
> > index 4d91a36c5cf5..000000000000
> > --- a/Documentation/devicetree/bindings/net/mdio-gpio.txt
> > +++ /dev/null
> > @@ -1,27 +0,0 @@
> > -MDIO on GPIOs
> > -
> > -Currently defined compatibles:
> > -- virtual,gpio-mdio
> > -- microchip,mdio-smi0
> > -
> > -MDC and MDIO lines connected to GPIO controllers are listed in the
> > -gpios property as described in section VIII.1 in the following order:
> > -
> > -MDC, MDIO.
> > -
> > -Note: Each gpio-mdio bus should have an alias correctly numbered in "aliases"
> > -node.
> > -
> > -Example:
> > -
> > -aliases {
> > -	mdio-gpio0 = &mdio0;
> > -};
> > -
> > -mdio0: mdio {
> > -	compatible = "virtual,mdio-gpio";
> > -	#address-cells = <1>;
> > -	#size-cells = <0>;
> > -	gpios = <&qe_pio_a 11
> > -		 &qe_pio_c 6>;
> > -};
> > diff --git a/Documentation/devicetree/bindings/net/mdio-gpio.yaml b/Documentation/devicetree/bindings/net/mdio-gpio.yaml
> > new file mode 100644
> > index 000000000000..183cf248d597
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/mdio-gpio.yaml
> > @@ -0,0 +1,57 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/mdio-gpio.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: MDIO on GPIOs
> > +
> > +maintainers:
> > +  - Andrew Lunn <andrew@lunn.ch>
> > +  - Florian Fainelli <f.fainelli@gmail.com>
> > +  - Heiner Kallweit <hkallweit1@gmail.com>
> > +
> > +allOf:
> > +  - $ref: "mdio.yaml#"
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - virtual,mdio-gpio
> > +      - microchip,mdio-smi0
> > +
> > +  "#address-cells":
> > +    const: 1
> > +
> > +  "#size-cells":
> > +    const: 0
> > +
> > +  gpios:
> > +    minItems: 2
> > +    maxItems: 3
> > +    description: |
> > +      MDC and MDIO lines connected to GPIO controllers are listed in
> > +      the gpios property as described in section VIII.1 in the
> > +      following order: MDC, MDIO.
> 
> section VIII.1 of what? Might be in DT spec, but if so the section is 
> different for sure.
> 

It cames from Documentation/powerpc/booting-without-of.txt and was removed more than 10 years ago.
So the reference could be removed.


> What's the order with 3 lines? In any case, define the order with 
> schema:
> 
> minItems:
> items:
>   - description: MDC signal
>   - description: MDIO or ?? signal
>   - description: ?? signal
> 

I dont know what to write in the third line, I added the "maxItems: 3" by request of Andrew Lunn.
But I have no example at hand.

Andrew could you give me an example of:	"You often find with x86 machines you don't have GPIOs, just GPI
and GPO, and you need to combine two to form the MDIO line of the MDIO bus."
Or could I drop the "maxItems: 3" until a board need it.

Regards
