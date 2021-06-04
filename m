Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605B439C0D3
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 21:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhFDTxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 15:53:47 -0400
Received: from mail-ot1-f43.google.com ([209.85.210.43]:35804 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhFDTxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 15:53:47 -0400
Received: by mail-ot1-f43.google.com with SMTP id 69-20020a9d0a4b0000b02902ed42f141e1so10222793otg.2;
        Fri, 04 Jun 2021 12:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hJ0x4oOHu3bQuGASm+jPBHpyUmZu2v+qW1jB1EYCSz8=;
        b=VzyWPGNfbub9INVBk/qeXI9dUAwBaDPj5LSOQq5yqQxKLMTg45q5T7ePyV0w2jU1fH
         9rpyWPjdV7NPksVJcWU35mmfMbEDB3eJ5Gog/W5M48w8F2PAxjsw0iMPfVYpscl9wVBj
         brT/nTOUAuUJZc+Z5kkrzWA6NqWgwddM6bX8yGp/C3rniy1eb21DIz+KK6JSIBrVSb3x
         180kpvRkOunDqxHkRBpSr61sA8t/62Uj1/qOCs5rJZRYUG1ZLInvfW+DXUZD0fMLnXEH
         Qgr5HqyH4MzozF26xTifXFr/Rqz71ynnAJD4zB1RVoZrvtv1jffa0b8iqBiUPMNZ4AtY
         soZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hJ0x4oOHu3bQuGASm+jPBHpyUmZu2v+qW1jB1EYCSz8=;
        b=f6W3ov3CG+PC6cqj4bGaaasNh3ieWM6CIVV/q3TMG+MqM/rDGNgV980QGoOw1FY6/k
         VYoQz/CQJUmSiLIP6IZTOKAY0U0KXA/8RPZfc2PR7Uq9kJrs47GGQ54Uygj4PuYRhGsY
         i41GGxaVti7ojFv68oipworEX+sxRXs0naH37FE43bWgYtMl3hNe6mfdirKxBE+ARO2a
         xnHjYtsjoul/d9jhSAYS5kr3pHDyZyQ6Aa7TLyq9PJeaLIIQFEbfbDPc6YOYuxZvU+vz
         nXiDQ3zzA2ZFx+1wj6sgApmc0soMw5CE10eChWea8stwx/OU2m7tTV/b1AYLvXxTpr/3
         nANw==
X-Gm-Message-State: AOAM533KSoXE1yXmzyqbdFy7xKOOYbqo89SJX6naq4Ufo20dl3nmTKre
        lb05nyhO1ajymdDYTzpbKLpdGfTgODDLQLpWn98s/lDMrAeb1T8=
X-Google-Smtp-Source: ABdhPJyE+lNyHydw3FUNplICtjJ/pPxgEL4mDNk43yIJEB5mJpg9AWtbV2XJ5H+xhn4SoyN0VPx1QrFZgI40ucd8B1w=
X-Received: by 2002:a9d:b86:: with SMTP id 6mr3155739oth.340.1622836243857;
 Fri, 04 Jun 2021 12:50:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210604162922.76954-1-george.mccollister@gmail.com> <20210604185511.yi5zejpz37rklzfw@skbuf>
In-Reply-To: <20210604185511.yi5zejpz37rklzfw@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Fri, 4 Jun 2021 14:50:31 -0500
Message-ID: <CAFSKS=Mdx3FH1bkiBfCitxSAP1CCYTb4jkkF0SoC72_a0KWL0Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: xrs700x: allow HSR/PRP supervision
 dupes for node_table
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 4, 2021 at 1:55 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Fri, Jun 04, 2021 at 11:29:22AM -0500, George McCollister wrote:
> > Add an inbound policy filter which matches the HSR/PRP supervision
> > MAC range and forwards to the CPU port without discarding duplicates.
> > This is required to correctly populate time_in[A] and time_in[B] in the
> > HSR/PRP node_table. Leave the policy disabled by default and
> > enable/disable it when joining/leaving hsr.
> >
> > Signed-off-by: George McCollister <george.mccollister@gmail.com>
> > ---
>
> What happens if duplicates are discarded for supervision frames and
> time_in[A] or time_in[B] is not updated in the node table?

It'll indicate an error condition that doesn't exist though everything
will work just fine.
It'll call hsr_nl_ringerror() and show only time_in[A] or time_in[B]
updating in /sys/kernel/debug/hsr/hsr0/node_table.

IEC 62439-3 specifies an SNMP MIB that contains the node_table. I've
implemented Net-SNMP mibgroup code to provide the node table data for
remote monitoring.

Basically if time_in[A] and time_in[B] aren't both updating it means:
For HSR there is a break in the ring.
For PRP: A device has a cable connecting to a switch unplugged or a failed port.

>
> >  drivers/net/dsa/xrs700x/xrs700x.c | 67 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 67 insertions(+)
> >
> > diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
> > index fde6e99274b6..a79066174a77 100644
> > --- a/drivers/net/dsa/xrs700x/xrs700x.c
> > +++ b/drivers/net/dsa/xrs700x/xrs700x.c
> > @@ -79,6 +79,9 @@ static const struct xrs700x_mib xrs700x_mibs[] = {
> >       XRS700X_MIB(XRS_EARLY_DROP_L, "early_drop", tx_dropped),
> >  };
> >
> > +static const u8 eth_hsrsup_addr[ETH_ALEN] = {
> > +     0x01, 0x15, 0x4e, 0x00, 0x01, 0x00};
> > +
>
> What if the user sets a different last address byte for supervision frames?

Below I only actually use 40 bits in the policy. See comment in the code.

>
> >  static void xrs700x_get_strings(struct dsa_switch *ds, int port,
> >                               u32 stringset, u8 *data)
> >  {
> > @@ -329,6 +332,50 @@ static int xrs700x_port_add_bpdu_ipf(struct dsa_switch *ds, int port)
> >       return 0;
> >  }
> >
> > +/* Add an inbound policy filter which matches the HSR/PRP supervision MAC
> > + * range and forwards to the CPU port without discarding duplicates.
> > + * This is required to correctly populate the HSR/PRP node_table.
> > + * Leave the policy disabled, it will be enabled as needed.
> > + */
> > +static int xrs700x_port_add_hsrsup_ipf(struct dsa_switch *ds, int port)
> > +{
> > +     struct xrs700x *priv = ds->priv;
> > +     unsigned int val = 0;
> > +     int i = 0;
> > +     int ret;
> > +
> > +     /* Compare 40 bits of the destination MAC address. */
> > +     ret = regmap_write(priv->regmap, XRS_ETH_ADDR_CFG(port, 1), 40 << 2);
> > +     if (ret)
> > +             return ret;
> > +
> > +     /* match HSR/PRP supervision destination 01:15:4e:00:01:XX */
> > +     for (i = 0; i < sizeof(eth_hsrsup_addr); i += 2) {
> > +             ret = regmap_write(priv->regmap, XRS_ETH_ADDR_0(port, 1) + i,
> > +                                eth_hsrsup_addr[i] |
> > +                                (eth_hsrsup_addr[i + 1] << 8));
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> > +     /* Mirror HSR/PRP supervision to CPU port */
> > +     for (i = 0; i < ds->num_ports; i++) {
> > +             if (dsa_is_cpu_port(ds, i))
> > +                     val |= BIT(i);
> > +     }
> > +
> > +     ret = regmap_write(priv->regmap, XRS_ETH_ADDR_FWD_MIRROR(port, 1), val);
> > +     if (ret)
> > +             return ret;
> > +
> > +     /* Allow must be set prevent duplicate discard */
> > +     ret = regmap_write(priv->regmap, XRS_ETH_ADDR_FWD_ALLOW(port, 1), val);
> > +     if (ret)
> > +             return ret;
> > +
> > +     return 0;
> > +}
> > +
> >  static int xrs700x_port_setup(struct dsa_switch *ds, int port)
> >  {
> >       bool cpu_port = dsa_is_cpu_port(ds, port);
> > @@ -358,6 +405,10 @@ static int xrs700x_port_setup(struct dsa_switch *ds, int port)
> >               ret = xrs700x_port_add_bpdu_ipf(ds, port);
> >               if (ret)
> >                       return ret;
> > +
> > +             ret = xrs700x_port_add_hsrsup_ipf(ds, port);
> > +             if (ret)
> > +                     return ret;
> >       }
> >
> >       return 0;
> > @@ -565,6 +616,14 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
> >                           XRS_PORT_FORWARDING);
> >       regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
> >
> > +     /* Enable inbound policy added by xrs700x_port_add_hsrsup_ipf()
> > +      * which allows HSR/PRP supervision forwarding to the CPU port without
> > +      * discarding duplicates.
> > +      */
> > +     regmap_update_bits(priv->regmap,
> > +                        XRS_ETH_ADDR_CFG(partner->index, 1), 1, 1);
> > +     regmap_update_bits(priv->regmap, XRS_ETH_ADDR_CFG(port, 1), 1, 1);
> > +
> >       hsr_pair[0] = port;
> >       hsr_pair[1] = partner->index;
> >       for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
> > @@ -611,6 +670,14 @@ static int xrs700x_hsr_leave(struct dsa_switch *ds, int port,
> >                           XRS_PORT_FORWARDING);
> >       regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
> >
> > +     /* Disable inbound policy added by xrs700x_port_add_hsrsup_ipf()
> > +      * which allows HSR/PRP supervision forwarding to the CPU port without
> > +      * discarding duplicates.
> > +      */
> > +     regmap_update_bits(priv->regmap,
> > +                        XRS_ETH_ADDR_CFG(partner->index, 1), 1, 0);
> > +     regmap_update_bits(priv->regmap, XRS_ETH_ADDR_CFG(port, 1), 1, 0);
> > +
> >       hsr_pair[0] = port;
> >       hsr_pair[1] = partner->index;
> >       for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
> > --
> > 2.11.0
> >
