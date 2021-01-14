Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540F92F699E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbhANSd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbhANSd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 13:33:26 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40145C061757;
        Thu, 14 Jan 2021 10:32:46 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id l9so3928645ejx.3;
        Thu, 14 Jan 2021 10:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y0c5Nx8W2urmWex5m6DmBEl26zCZs3A4t+gb05nA8VQ=;
        b=Qaxn2PkC9f4GQ4NOnPQlgmbIoooJsOh30WVZhiuDSdkNEUZuZvPS5zshqw4M7Li1YL
         3CblAXn8XX5fQ8GKgg02Z1L3mHlZir0y6qO09+CY6pX2p9n6fETMde1o9uwl646UAQ0Z
         lzDrT8ucpxUe7vUcR03vYmCY7S6Y8XEghc271X00Ud2VqJ72GdE7LkmcKJ2KOwzGeRe5
         neCaCAfGnVQBgAIaIVoyg3TmH2Qdyr9n3IgBJjNza1FOAXOCzh0BcqZ5r5BVOOriGrig
         DsVOh+OpYznkXz18dWeBXGIR7Aw+ybUUetM4wj1l8EvgA7aJrdLC7PShew1ls8z5BH/S
         jUUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y0c5Nx8W2urmWex5m6DmBEl26zCZs3A4t+gb05nA8VQ=;
        b=hwiXt5CidFDwGKT2fQVnHmYOgbmKsc/Jwn9/8uUUgUDuFstlTBJGmme+sAwCScAs1U
         B6Nkjgtizv4Ske8e7D+AnDA8GYEa8d78bRxQ7kmXJyjdrI2n8j5sfWIWkv1su0ujPlZI
         Z8LFwmjt8w+WYUVbB6gexOiJaqaS9k+1acdDfkv13Db6BUu12kMJP70riGwV0idxXzSl
         RuyFY49idiHwj010u3O/PvkM1JFSBt9bFyJbAyEMn3sIvmntXmOoKkl3C/t3nf55z2Bf
         mLkY+4njWiXqxgAF7ID7j3zhdFUE9Z2ky7y6/oFBr9b9lAS7nb5HfB5lllN83CQxQctb
         1XHg==
X-Gm-Message-State: AOAM532xa3t1REyxTAp0v6NK48bp+ClH0xB7GI7egc6VEB9xdx3q9Os5
        aaFMXvBpW6GDIoJyJQCs1a8=
X-Google-Smtp-Source: ABdhPJyfq2WDYDXrAKqF8SE0Tw84cm/1O2KlVkbuOm9xO+UAvMcNLZ7zUzIdNyZEhD616hB0Hv2/Sw==
X-Received: by 2002:a17:906:b244:: with SMTP id ce4mr988278ejb.159.1610649164964;
        Thu, 14 Jan 2021 10:32:44 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id jt8sm719248ejc.40.2021.01.14.10.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 10:32:44 -0800 (PST)
Date:   Thu, 14 Jan 2021 20:32:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v4 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20210114183243.4kse75ksw3u7h4uz@skbuf>
References: <20210113145922.92848-1-george.mccollister@gmail.com>
 <20210113145922.92848-3-george.mccollister@gmail.com>
 <20210114015659.33shdlfthywqdla7@skbuf>
 <CAFSKS=NU4hrnXB5FcAFvnFnmAtK5HfYR8dAKyw3cd=5UKOBNfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=NU4hrnXB5FcAFvnFnmAtK5HfYR8dAKyw3cd=5UKOBNfg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 10:53:16AM -0600, George McCollister wrote:
> On Wed, Jan 13, 2021 at 7:57 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > What PHY interface types does the switch support as of this patch?
> > No RGMII delay configuration needed?
> >
> 
> Port 0: RMII
> Port 1-3: RGMII
> 
> For RGMII the documentation states:
> "PCB is required to add 1.5 ns to 2.0 ns more delay to the clock line
> than the other lines, unless the other end (PHY) has configurable RX
> clock delay."

Ok, didn't notice that.

> > I've been there too, not the smartest of decisions in the long run. See
> > commit 0b0e299720bb ("net: dsa: sja1105: use detected device id instead
> > of DT one on mismatch") if you want a sneak preview of how this is going
> > to feel two years from now. If you can detect the device id you're
> > probably better off with a single compatible string.
> 
> Previously Andrew said:
> "Either you need to verify the compatible from day one so it is not
> wrong, or you just use a single compatible "arrow,xrs700x", which
> cannot be wrong."
> 
> I did it the first way he suggested, if you would have replied at that
> time to use a single that's the way I would have done it that way.
> 
> If you two can agree I should change it to a single string I'd be
> happy to do so. In my case I need 3 RGMII and only one of the package
> types will fit on the board so there's no risk of changing to one of
> the existing parts. Perhaps this could be an issue if a new part is
> added in the future or on someone else's design.

Ok, if the parts are not pin-compatible I guess the range of potential
issues to deal with may be lower. Don't get me wrong, I don't have a
strong opinion. I'm fine if you ignore this comment and keep the
specific compatibles, I think this is what the Open Firmware document
recommends anyway.

> > > +static int xrs700x_alloc_port_mib(struct xrs700x *dev, int port)
> > > +{
> > > +     struct xrs700x_port *p = &dev->ports[port];
> > > +     size_t mib_size = sizeof(*p->mib_data) * ARRAY_SIZE(xrs700x_mibs);
> >
> > Reverse Christmas tree ordering... sorry.
> 
> The second line uses p so that won't work. I'll change the function to
> use devm_kcalloc like you recommended below and just get rid of
> mib_size.

Yes, if you can get rid of it, that works.
Generally when somebody says "reverse xmas tree" and it's obvious that
there are data dependencies between variables, what they mean to request
is:

	struct xrs700x_port *p = &dev->ports[port];
	size_t mib_size;

	mib_size = sizeof(*p->mib_data) * ARRAY_SIZE(xrs700x_mibs);

> > > diff --git a/drivers/net/dsa/xrs700x/xrs700x_mdio.c b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
> > > new file mode 100644
> > > index 000000000000..4fa6cc8f871c
> > > --- /dev/null
> > > +++ b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
> > > +static int xrs700x_mdio_reg_read(void *context, unsigned int reg,
> > > +                              unsigned int *val)
> > > +{
> > > +     struct mdio_device *mdiodev = context;
> > > +     struct device *dev = &mdiodev->dev;
> > > +     u16 uval;
> > > +     int ret;
> > > +
> > > +     uval = (u16)FIELD_GET(GENMASK(31, 16), reg);
> > > +
> > > +     ret = mdiobus_write(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBA1, uval);
> > > +     if (ret < 0) {
> > > +             dev_err(dev, "xrs mdiobus_write returned %d\n", ret);
> > > +             return ret;
> > > +     }
> > > +
> > > +     uval = (u16)((reg & GENMASK(15, 1)) | XRS_IB_READ);
> >
> > What happened to bit 0 of "reg"?
> 
> From the datasheet:
> "Bits 15-1 of the address on the internal bus to where data is written
> or from where data is read. Address bit 0 is always 0 (because of 16
> bit registers)."
> 
> reg_stride is set to 2.
> "The register address stride. Valid register addresses are a multiple
> of this value."

Ok, clear now.

> > May boil down to preference too, but I don't believe "dev" is a happy
> > name to give to a driver private data structure.
> 
> There are other drivers in the subsystem that do this. If there was a
> consistent pattern followed in the subsystem I would have followed it.
> Trust me I was a bit frustrated with home much time I spent going
> through multiple drivers trying to determine the best practices for
> organization, naming, etc.
> If it's a big let me know and I'll change it.

Funny that you are complaining about consistency in other drivers,
because if I count correctly, out of a total of 22 occurrences of
struct xrs700x variables in yours, 13 are named priv and 9 are named
dev. So you are not even consistent with yourself. But it's not a major
issue either way.
