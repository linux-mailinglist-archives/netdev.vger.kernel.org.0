Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91D62F6678
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 17:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbhANQyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbhANQyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 11:54:09 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5955BC061574;
        Thu, 14 Jan 2021 08:53:29 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id w124so6561376oia.6;
        Thu, 14 Jan 2021 08:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+EOdxAUtT3vRFLe3ss8hT6ceHOcvFiqKOxd8XUKB+h4=;
        b=bg3dwQqIjnxoBLIrB95ooghS/aqn3/z2LSdtR0f1Au3w4QYJYjDl7ElOtpj5EVyFLj
         Z5UYcz+Myq4JkF3CGzLN2dpt9SHHtjyXx5AOXY/I3q2W8Py9ur5IPeOghM1fooYZCM+O
         db4nfIZqGfcO5Ov4kz1Kcj4kjSLBCpVGo4yH+bR7q30aVaJBY99LJdj9Yc+5BYwajFiN
         lt7zsh2PlanlV6htwy5nw7x6gDdtvmjyuTBsT3divY1gBnHup4q0qfSuI8XKZCVBYXBd
         5JlQ5FWvVCy+w5IVtlnVHtwoNN42ry6BDSvL0BzKt3cZcYM9yF1spdx2Ss7RVWF5acPZ
         IKaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+EOdxAUtT3vRFLe3ss8hT6ceHOcvFiqKOxd8XUKB+h4=;
        b=PugAi4zCO5BLd4e8In6bnI5whnSBOv4aN8u8MSDELQp5DBhtnkyKX8A4IA7qxgG49b
         xe+KEpRu0EzjORwwOlXrhxUBolo7oa5diOEafllGVkXPC5/m468zQsIpOcw++ErZ3W6B
         5cy+nIIgHKv+ztMqs0OODXHkJabD4U7srW1q/KFPkfNrQPq0nr5QX/HVGe4HAYfNLBNb
         uljZ0H5t/9trQLeuf1FowyCm/KeKgcNtWOGV2T8r72iyCUYfyPcOHiCS4WIfjpyw6h3M
         DTH+eeJqcwmhgYwXr4inoHyegiAjKybGsPQqcy+hVuIjlb60jWG+z1IXeCQy7G/ccxMS
         uTtA==
X-Gm-Message-State: AOAM531d0XBk/sVi2d0pX/dSpVu0a5TmB9T2/XX8HdwYXN+Yh51f4wYq
        uIJWDBQUd8TyKS927lAJ+9vHT2sPorung40fWg==
X-Google-Smtp-Source: ABdhPJzPJHiQ3YSKKB7tBmALGTgqSGX0Tv5SzoYNUSXFbb2WKfEj1x8cKowAzDMfujFTASN/q1weCS990RkxG0039Lc=
X-Received: by 2002:aca:b145:: with SMTP id a66mr3132179oif.92.1610643208567;
 Thu, 14 Jan 2021 08:53:28 -0800 (PST)
MIME-Version: 1.0
References: <20210113145922.92848-1-george.mccollister@gmail.com>
 <20210113145922.92848-3-george.mccollister@gmail.com> <20210114015659.33shdlfthywqdla7@skbuf>
In-Reply-To: <20210114015659.33shdlfthywqdla7@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 14 Jan 2021 10:53:16 -0600
Message-ID: <CAFSKS=NU4hrnXB5FcAFvnFnmAtK5HfYR8dAKyw3cd=5UKOBNfg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] net: dsa: add Arrow SpeedChips XRS700x driver
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 7:57 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> What PHY interface types does the switch support as of this patch?
> No RGMII delay configuration needed?
>

Port 0: RMII
Port 1-3: RGMII

For RGMII the documentation states:
"PCB is required to add 1.5 ns to 2.0 ns more delay to the clock line
than the other lines, unless the other end (PHY) has configurable RX
clock delay."

> > +
> > +static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
> > +                              struct net_device *bridge, bool join)
> > +{
> > +     unsigned int i, cpu_mask = 0, mask = 0;
> > +     struct xrs700x *priv = ds->priv;
> > +     int ret;
> > +
> > +     for (i = 0; i < ds->num_ports; i++) {
> > +             if (dsa_is_cpu_port(ds, i))
> > +                     continue;
> > +
> > +             cpu_mask |= BIT(i);
> > +
> > +             if (dsa_to_port(ds, i)->bridge_dev == bridge)
> > +                     continue;
> > +
> > +             mask |= BIT(i);
> > +     }
> > +
> > +     for (i = 0; i < ds->num_ports; i++) {
> > +             if (dsa_to_port(ds, i)->bridge_dev != bridge)
> > +                     continue;
> > +
> > +             ret = regmap_write(priv->regmap, XRS_PORT_FWD_MASK(i), mask);
>
> Maybe it would be worth mentioning in a comment that PORT_FWD_MASK's
> encoding is "1 = Disable forwarding to the port", otherwise this is
> confusing.

Okay, done.

>
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> > +     if (!join) {
> > +             ret = regmap_write(priv->regmap, XRS_PORT_FWD_MASK(port),
> > +                                cpu_mask);
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> > +     return 0;
> > +}
>
> > +static int xrs700x_detect(struct xrs700x *dev)
> > +{
> > +     const struct xrs700x_info *info;
> > +     unsigned int id;
> > +     int ret;
> > +
> > +     ret = regmap_read(dev->regmap, XRS_DEV_ID0, &id);
> > +     if (ret) {
> > +             dev_err(dev->dev, "error %d while reading switch id.\n",
> > +                     ret);
> > +             return ret;
> > +     }
> > +
> > +     info = of_device_get_match_data(dev->dev);
> > +     if (!info)
> > +             return -EINVAL;
> > +
> > +     if (info->id == id) {
> > +             dev->ds->num_ports = info->num_ports;
> > +             dev_info(dev->dev, "%s detected.\n", info->name);
> > +             return 0;
> > +     }
> > +
> > +     dev_err(dev->dev, "expected switch id 0x%x but found 0x%x.\n",
> > +             info->id, id);
>
> I've been there too, not the smartest of decisions in the long run. See
> commit 0b0e299720bb ("net: dsa: sja1105: use detected device id instead
> of DT one on mismatch") if you want a sneak preview of how this is going
> to feel two years from now. If you can detect the device id you're
> probably better off with a single compatible string.

Previously Andrew said:
"Either you need to verify the compatible from day one so it is not
wrong, or you just use a single compatible "arrow,xrs700x", which
cannot be wrong."

I did it the first way he suggested, if you would have replied at that
time to use a single that's the way I would have done it that way.

If you two can agree I should change it to a single string I'd be
happy to do so. In my case I need 3 RGMII and only one of the package
types will fit on the board so there's no risk of changing to one of
the existing parts. Perhaps this could be an issue if a new part is
added in the future or on someone else's design.

>
> > +
> > +     return -ENODEV;
> > +}
> > +
> > +static int xrs700x_alloc_port_mib(struct xrs700x *dev, int port)
> > +{
> > +     struct xrs700x_port *p = &dev->ports[port];
> > +     size_t mib_size = sizeof(*p->mib_data) * ARRAY_SIZE(xrs700x_mibs);
>
> Reverse Christmas tree ordering... sorry.

The second line uses p so that won't work. I'll change the function to
use devm_kcalloc like you recommended below and just get rid of
mib_size.

>
> > +int xrs700x_switch_register(struct xrs700x *dev)
> > +{
> > +     int ret;
> > +     int i;
> > +
> > +     ret = xrs700x_detect(dev);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret = xrs700x_setup_regmap_range(dev);
> > +     if (ret)
> > +             return ret;
> > +
> > +     dev->ports = devm_kzalloc(dev->dev,
> > +                               sizeof(*dev->ports) * dev->ds->num_ports,
> > +                               GFP_KERNEL);
>
> devm_kcalloc?

Ok, done.


>
> > +     if (!dev->ports)
> > +             return -ENOMEM;
> > +
> > +     for (i = 0; i < dev->ds->num_ports; i++) {
> > +             ret = xrs700x_alloc_port_mib(dev, i);
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> > +     ret = dsa_register_switch(dev->ds);
> > +
> > +     return ret;
>
> return dsa_register_switch
>
> > +}
> > +EXPORT_SYMBOL(xrs700x_switch_register);
> > +
> > +void xrs700x_switch_remove(struct xrs700x *dev)
> > +{
> > +     cancel_delayed_work_sync(&dev->mib_work);
>
> Is it not enough that this is called from xrs700x_teardown too, which is
> in the call path of dsa_unregister_switch below?

yeah, looks like it. I'll remove this.

>
> > +
> > +     dsa_unregister_switch(dev->ds);
> > +}
> > +EXPORT_SYMBOL(xrs700x_switch_remove);
> > diff --git a/drivers/net/dsa/xrs700x/xrs700x_mdio.c b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
> > new file mode 100644
> > index 000000000000..4fa6cc8f871c
> > --- /dev/null
> > +++ b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
> > +static int xrs700x_mdio_reg_read(void *context, unsigned int reg,
> > +                              unsigned int *val)
> > +{
> > +     struct mdio_device *mdiodev = context;
> > +     struct device *dev = &mdiodev->dev;
> > +     u16 uval;
> > +     int ret;
> > +
> > +     uval = (u16)FIELD_GET(GENMASK(31, 16), reg);
> > +
> > +     ret = mdiobus_write(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBA1, uval);
> > +     if (ret < 0) {
> > +             dev_err(dev, "xrs mdiobus_write returned %d\n", ret);
> > +             return ret;
> > +     }
> > +
> > +     uval = (u16)((reg & GENMASK(15, 1)) | XRS_IB_READ);
>
> What happened to bit 0 of "reg"?

From the datasheet:
"Bits 15-1 of the address on the internal bus to where data is written
or from where data is read. Address bit 0 is always 0 (because of 16
bit registers)."

reg_stride is set to 2.
"The register address stride. Valid register addresses are a multiple
of this value."

>
> > +
> > +     ret = mdiobus_write(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBA0, uval);
> > +     if (ret < 0) {
> > +             dev_err(dev, "xrs mdiobus_write returned %d\n", ret);
> > +             return ret;
> > +     }
> > +
> > +     ret = mdiobus_read(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBD);
> > +     if (ret < 0) {
> > +             dev_err(dev, "xrs mdiobus_read returned %d\n", ret);
> > +             return ret;
> > +     }
> > +
> > +     *val = (unsigned int)ret;
> > +
> > +     return 0;
> > +}
>
> > +static int xrs700x_mdio_probe(struct mdio_device *mdiodev)
> > +{
> > +     struct xrs700x *dev;
>
> May boil down to preference too, but I don't believe "dev" is a happy
> name to give to a driver private data structure.

There are other drivers in the subsystem that do this. If there was a
consistent pattern followed in the subsystem I would have followed it.
Trust me I was a bit frustrated with home much time I spent going
through multiple drivers trying to determine the best practices for
organization, naming, etc.
If it's a big let me know and I'll change it.

Thanks,
George
