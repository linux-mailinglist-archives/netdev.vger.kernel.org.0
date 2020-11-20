Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B4F2BB97E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgKTWz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728197AbgKTWz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:55:57 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E4AC0613CF;
        Fri, 20 Nov 2020 14:55:56 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id o25so12298339oie.5;
        Fri, 20 Nov 2020 14:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j2q4yB63jpRKfPiKlVxQWYY9iYkFvzEgdWCDK/79Pks=;
        b=E4pmW8+9X1sGgWvtQFKf5MPkrYPBp8fd38bbwQVNz/jgI4CgvGd2D+BGU7x6IMRcJX
         VdOoZTwbQghXZY4I2jliLrhSeVYHgoIQPX8kS9yXTa0gLZwu4fOeGK77I0+rkN4ykl38
         MM7aThu8/YNXFfMBp3jn3lfCj7PSChM00NqE6e6VPPraCFDir6hZIgoc80wQ1nq0QGyv
         tSosZO6SYyIK5Yhrq200Wi/QiDE9gUqsXaV6ju9otNm8my/MTvffq/Dda8NpRi5Evmkj
         oSM5OKqbwZ/GN+FbA2L0cB+Oq01F6nJRn0GxTGYRQItq9vPNzxOeqvrUDtZsrG05BXTk
         ZRWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j2q4yB63jpRKfPiKlVxQWYY9iYkFvzEgdWCDK/79Pks=;
        b=cdMq39U5dbSAf6WFY7kSKLFECI3TKh9WIPnekWpc9T4Yg3E6KJ9MkBHsD9+iSzJev4
         92n3xsRPIj/vEiCda9cDUnMED+EaEqm7Efq8ZKHewC3riwrXWA9Z2wDmd8BTBgxlWLNN
         34JGb/BsTkt8J6wUvVjD7k53mCJ2CtKdqyoYKMRrR3Vt+uGnGJFiuLs8u8tMIP4lwae8
         Oi0nX2eGKyBHxPtJPOw07/F8XGiMSQQA8yYvx11f2x03yv4FMP/ncTVpkwGtzlzPHzwA
         6eqXSyZM1UpmIuY2Z6hbkydaq2CA9YWzcRgdmRFiXDQ0cJ2WF79TtT0Mo+ubXwIux0yz
         SadA==
X-Gm-Message-State: AOAM533ZrUlhPxSi+dZVyFM5AgstOSIa0FgKzKpif4i42BKTVKdQ4Qu+
        YtnrFedggRyrGiG2cSpYrn75Bx+CUV9RjBK3p80207hvJA==
X-Google-Smtp-Source: ABdhPJxawIsnxnGWf0GwETGk4r5NMxmJmhPb7zIpZx6YD+pFQGfiFl2pVJ+kdKOuJGC3NNvsJMkDIunacXh37aYjsic=
X-Received: by 2002:aca:b145:: with SMTP id a66mr8293416oif.92.1605912956298;
 Fri, 20 Nov 2020 14:55:56 -0800 (PST)
MIME-Version: 1.0
References: <20201120181627.21382-1-george.mccollister@gmail.com>
 <20201120181627.21382-3-george.mccollister@gmail.com> <20201120193321.GP1853236@lunn.ch>
In-Reply-To: <20201120193321.GP1853236@lunn.ch>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Fri, 20 Nov 2020 16:55:44 -0600
Message-ID: <CAFSKS=P=epx3Sr3OzkCg9ycoftmXm__PaMee7HWbAGXYdqgbDw@mail.gmail.com>
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

On Fri, Nov 20, 2020 at 1:33 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +static const struct xrs700x_mib xrs700x_mibs[] = {
> > +     {XRS_RX_GOOD_OCTETS_L(0), "rx_good_octets"},
> > +     {XRS_RX_BAD_OCTETS_L(0), "rx_bad_octets"},
> > +     {XRS_RX_UNICAST_L(0), "rx_unicast"},
> > +     {XRS_RX_BROADCAST_L(0), "rx_broadcast"},
> > +     {XRS_RX_MULTICAST_L(0), "rx_multicast"},
> > +     {XRS_RX_UNDERSIZE_L(0), "rx_undersize"},
> > +     {XRS_RX_FRAGMENTS_L(0), "rx_fragments"},
> > +     {XRS_RX_OVERSIZE_L(0), "rx_oversize"},
> > +     {XRS_RX_JABBER_L(0), "rx_jabber"},
> > +     {XRS_RX_ERR_L(0), "rx_err"},
> > +     {XRS_RX_CRC_L(0), "rx_crc"},
> > +     {XRS_RX_64_L(0), "rx_64"},
> > +     {XRS_RX_65_127_L(0), "rx_65_127"},
> > +     {XRS_RX_128_255_L(0), "rx_128_255"},
> > +     {XRS_RX_256_511_L(0), "rx_256_511"},
> > +     {XRS_RX_512_1023_L(0), "rx_512_1023"},
> > +     {XRS_RX_1024_1536_L(0), "rx_1024_1536"},
> > +     {XRS_RX_HSR_PRP_L(0), "rx_hsr_prp"},
> > +     {XRS_RX_WRONGLAN_L(0), "rx_wronglan"},
> > +     {XRS_RX_DUPLICATE_L(0), "rx_duplicate"},
> > +     {XRS_TX_OCTETS_L(0), "tx_octets"},
> > +     {XRS_TX_UNICAST_L(0), "tx_unicast"},
> > +     {XRS_TX_BROADCAST_L(0), "tx_broadcast"},
> > +     {XRS_TX_MULTICAST_L(0), "tx_multicast"},
> > +     {XRS_TX_HSR_PRP_L(0), "tx_hsr_prp"},
> > +     {XRS_PRIQ_DROP_L(0), "priq_drop"},
> > +     {XRS_EARLY_DROP_L(0), "early_drop"},
>
> Can we drop the (0). It does not seem to have any purpose, always
> being 0.

It hurts my OCD when the register macros don't match the same pattern but okay.

>
> > +};
> > +
>
>
> > +static void xrs700x_read_port_counters(struct xrs700x *priv, int port)
> > +{
> > +     int i;
> > +     struct xrs700x_port *p = &priv->ports[port];
>
> Reverse christmas tree. Please check and fix everywhere.

done. I left the order in xrs700x_setup_regmap_range as is because
they're almost the same length and I want them in the order they're in
in the register. Let me know if that's an issue and I'll change it.

>
> > +static void xrs700x_port_stp_state_set(struct dsa_switch *ds, int port,
> > +                                    u8 state)
> > +{
> > +     struct xrs700x *priv = ds->priv;
> > +     unsigned int val;
> > +
> > +     switch (state) {
> > +     case BR_STATE_DISABLED:
> > +             val = XRS_PORT_DISABLED;
> > +             break;
> > +     case BR_STATE_LISTENING:
> > +             val = XRS_PORT_DISABLED;
> > +             break;
>
> No listening state?

No, just forwarding, learning and disabled. See:
https://www.flexibilis.com/downloads/xrs/SpeedChip_XRS7000_3000_User_Manual.pdf
page 82.

>
> > +     case BR_STATE_LEARNING:
> > +             val = XRS_PORT_LEARNING;
> > +             break;
> > +     case BR_STATE_FORWARDING:
> > +             val = XRS_PORT_FORWARDING;
> > +             break;
> > +     case BR_STATE_BLOCKING:
> > +             val = XRS_PORT_DISABLED;
> > +             break;
>
> Hum. What exactly does XRS_PORT_DISABLED mean? When blocking, it is
> expected you can still send/receive BPDUs.

Datasheet says: "Disabled. Port neither learns MAC addresses nor forwards data."

>
> > +struct xrs700x *xrs700x_switch_alloc(struct device *base, void *priv)
> > +{
> > +     struct dsa_switch *ds;
> > +     struct xrs700x *dev;
> > +
> > +     ds = devm_kzalloc(base, sizeof(*ds), GFP_KERNEL);
> > +     if (!ds)
> > +             return NULL;
> > +
> > +     ds->dev = base;
> > +     ds->num_ports = DSA_MAX_PORTS;
>
> Is this needed? detect should fill it in.

Removed. I added this before I added detect and forgot to take it out.

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
> > +     if (ret)
> > +             cancel_delayed_work_sync(&dev->mib_work);
>
> It would be nice to have to symmetry here. It is not obvious what is
> starting this? It happens in the setup op? So can this be moved
> into the teardown op?

Agreed. Moved to teardown.

>
> > +static int xrs700x_i2c_reg_read(void *context, unsigned int reg,
> > +                             unsigned int *val)
> > +{
> > +     int ret;
> > +     unsigned char buf[4];
> > +     struct device *dev = context;
> > +     struct i2c_client *i2c = to_i2c_client(dev);
> > +
> > +     buf[0] = reg >> 23 & 0xff;
> > +     buf[1] = reg >> 15 & 0xff;
> > +     buf[2] = reg >> 7 & 0xff;
> > +     buf[3] = (reg & 0x7f) << 1;
> > +
> > +     ret = i2c_master_send(i2c, buf, sizeof(buf));
>
> Are you allowed to perform transfers on stack buffers? I think any I2C
> bus driver using DMA is going to be unhappy.

It should be fine. See the following file, there is a good write up about this:
See Documentation/i2c/dma-considerations.rst

>
> > +static const struct of_device_id xrs700x_i2c_dt_ids[] = {
> > +     { .compatible = "arrow,xrs7003" },
> > +     { .compatible = "arrow,xrs7004" },
> > +     {},
>
> Please validate that the compatible string actually matches the switch
> found. Otherwise we can get into all sorts of horrible backward
> compatibility issues.

Okay. What kind of compatibility issues? Do you have a hypothetical
example? I guess I will just use of_device_is_compatible() to check.

>
> > +static const struct of_device_id xrs700x_mdio_dt_ids[] = {
> > +     { .compatible = "arrow,xrs7003" },
> > +     { .compatible = "arrow,xrs7004" },
> > +     {},
>
> Same here.
>
>      Andrew

Thanks
