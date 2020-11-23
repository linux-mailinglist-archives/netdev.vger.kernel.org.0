Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAB72C16FC
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgKWUnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgKWUnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 15:43:14 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB497C0613CF;
        Mon, 23 Nov 2020 12:43:14 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id y74so7807621oia.11;
        Mon, 23 Nov 2020 12:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YQSMeHHshmEHiclhaeVDs3fo0b1cuteOXdZuRFtkNXs=;
        b=LpIgXDYqOuPEnj4Ef+biks4tAzD8Ud+9U27quHWoCAUyFMPW6alSIz0hmbGiji9aVC
         qCdaNZzZnNlDAoioElsXtMzSpWlQzshCKORMuZkrQTU/HCThvPyHOCM5903x4fM9Tj/S
         S61cFAwpy4CVS1xkNUU4s3cjNEzYZmempIQQWHh3eyMYAgQwsJ4NefWnnQjfxESMe0Nk
         om/wlcEKmK73fdgYQ86+quKIKzUstRe9r24lHAyCjHv7BTlmNKa2DtAwu1yjAhBYOEW+
         vGqIxrDDNDhs1lKW+kbADCs2YXy55YTQqC2lpNPijJGE12JZ5NivfxgZSuREdbuOThHb
         rdhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YQSMeHHshmEHiclhaeVDs3fo0b1cuteOXdZuRFtkNXs=;
        b=dbOtYXtqdmdOViNXYv/Iw5daIyqSjpl9L33Uv1zZLPlnrbUcfnmy5IO2TcQJpguX3Z
         VcKskHMX9msYGSJ1G01EkT4Nl63W4TBDZ6GuEXqdoA+s/nvQnTk/jMnDn4inlre2XgLZ
         OPr6NGQRpwDGjNKhXOz1h/V9hksZ5jv/ubM21YjYyDMRKcTnkpcsb39Z6N8psNYd0d/+
         sQ/mc5UXMOsH8fAs02sjRDKuIDrgC9Zln7i5ETiYAEgaWrUkjOrgbD9PkOqGZPuOiLER
         gNZQefkaOvQND2I/brt8v4zSlj3zRB0aalxYEOXicYAzFEx2hylhpbFyObRLDjxXDg0k
         BdaA==
X-Gm-Message-State: AOAM532MsGM+OKghr4di3KFhJ/OVJVAsK/2aG+WU4XiEJZ9u9T0juYGj
        dGZOWaRPTPe2g2g1wHpYg2L98hQn4+Dxlr7bLA==
X-Google-Smtp-Source: ABdhPJydj+Y4G7cZhN2DeVEiepdJEuv4RNbwT9iRvCvtoIY9ClsVsrQy4VMuxZ/fSOTc6tDT+Np8XCcq2eP+oDjIE2s=
X-Received: by 2002:aca:c506:: with SMTP id v6mr494151oif.122.1606164194047;
 Mon, 23 Nov 2020 12:43:14 -0800 (PST)
MIME-Version: 1.0
References: <20201120181627.21382-1-george.mccollister@gmail.com>
 <20201120181627.21382-3-george.mccollister@gmail.com> <20201120193321.GP1853236@lunn.ch>
 <CAFSKS=P=epx3Sr3OzkCg9ycoftmXm__PaMee7HWbAGXYdqgbDw@mail.gmail.com> <20201120232439.GA1949248@lunn.ch>
In-Reply-To: <20201120232439.GA1949248@lunn.ch>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 23 Nov 2020 14:43:01 -0600
Message-ID: <CAFSKS=M-2rwM2UC58xf8n0ORuwxHq06BjLj7QP=JuU19-tCpGg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: dsa: add Arrow SpeedChips XRS700x driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 5:24 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Hi George
>
> > > > +static void xrs700x_port_stp_state_set(struct dsa_switch *ds, int port,
> > > > +                                    u8 state)
> > > > +{
> > > > +     struct xrs700x *priv = ds->priv;
> > > > +     unsigned int val;
> > > > +
> > > > +     switch (state) {
> > > > +     case BR_STATE_DISABLED:
> > > > +             val = XRS_PORT_DISABLED;
> > > > +             break;
> > > > +     case BR_STATE_LISTENING:
> > > > +             val = XRS_PORT_DISABLED;
> > > > +             break;
> > >
> > > No listening state?
> >
> > No, just forwarding, learning and disabled. See:
> > https://www.flexibilis.com/downloads/xrs/SpeedChip_XRS7000_3000_User_Manual.pdf
> > page 82.
> >
> > >
> > > > +     case BR_STATE_LEARNING:
> > > > +             val = XRS_PORT_LEARNING;
> > > > +             break;
> > > > +     case BR_STATE_FORWARDING:
> > > > +             val = XRS_PORT_FORWARDING;
> > > > +             break;
> > > > +     case BR_STATE_BLOCKING:
> > > > +             val = XRS_PORT_DISABLED;
> > > > +             break;
> > >
> > > Hum. What exactly does XRS_PORT_DISABLED mean? When blocking, it is
> > > expected you can still send/receive BPDUs.
> >
> > Datasheet says: "Disabled. Port neither learns MAC addresses nor forwards data."
>
> I think you need to do some testing here. Put the device into a loop
> with another switch, the bridge will block a port, and see if it still
> can send/receive BPDUs on the blocked port.
>
> If it cannot send/receive BPDUs, it might get into an oscillating
> state. They see each other via BPDUs, decide there is a loop, and
> block a port. The BPDUs stop, they think the loop has been broken and
> so unblock. They see each other via BPUS, decide there is a loop,...

Yeah, this is messed up. The switch doesn't seem to pass up BPDUs in
either disabled or learning mode, only forward mode.
Can I just replace .port_stp_state_set with .port_enable (setting
switch port to forward mode) and .port_disable (setting switch port to
disabled mode)? I don't see any other way around this. It looks like
rtl8366rb.c also has no .port_stp_state_set.

>
> > > > +static int xrs700x_i2c_reg_read(void *context, unsigned int reg,
> > > > +                             unsigned int *val)
> > > > +{
> > > > +     int ret;
> > > > +     unsigned char buf[4];
> > > > +     struct device *dev = context;
> > > > +     struct i2c_client *i2c = to_i2c_client(dev);
> > > > +
> > > > +     buf[0] = reg >> 23 & 0xff;
> > > > +     buf[1] = reg >> 15 & 0xff;
> > > > +     buf[2] = reg >> 7 & 0xff;
> > > > +     buf[3] = (reg & 0x7f) << 1;
> > > > +
> > > > +     ret = i2c_master_send(i2c, buf, sizeof(buf));
> > >
> > > Are you allowed to perform transfers on stack buffers? I think any I2C
> > > bus driver using DMA is going to be unhappy.
> >
> > It should be fine. See the following file, there is a good write up about this:
> > See Documentation/i2c/dma-considerations.rst
>
> O.K, thanks for the pointer.
>
> > > > +static const struct of_device_id xrs700x_i2c_dt_ids[] = {
> > > > +     { .compatible = "arrow,xrs7003" },
> > > > +     { .compatible = "arrow,xrs7004" },
> > > > +     {},
> > >
> > > Please validate that the compatible string actually matches the switch
> > > found. Otherwise we can get into all sorts of horrible backward
> > > compatibility issues.
> >
> > Okay. What kind of compatibility issues? Do you have a hypothetical
> > example? I guess I will just use of_device_is_compatible() to check.
>
> Since it currently does not matter, you can expect 50% of the boards
> to get it wrong. Sometime later, you find some difference between the
> two, you want to add additional optional properties dependent on the
> compatible string. But that is made hard, because 50% of the boards
> are broken, and the compatible string is now worthless.
>
> Either you need to verify the compatible from day one so it is not
> wrong, or you just use a single compatible "arrow,xrs700x", which
> cannot be wrong.

okay I'll make sure an error is returned if the detected switch does
not match compatible.

>
>   Andrew
