Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A1C18C122
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 21:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgCSUPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 16:15:03 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38602 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgCSUPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 16:15:03 -0400
Received: by mail-ed1-f68.google.com with SMTP id h5so4335744edn.5
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 13:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XhJaJgHHBbx6CeUEut5CiByebd0OHra++Cf/Z1iRtAc=;
        b=CXhTO3MSxKnJ+Al3OCKjItq4GEOfkRxbFZP/eatgAi0vgbFdYAKfpM4ROMiWCCzjqk
         3bY2Wsnx/rWUvpqsh5kIaP+cEtbgAbTm3xuV30u2QUBW+3M/xE0Q6h8/2OVpnCqk5g4r
         rBnHubTB6mTjSFB2aVXVMz2BGamjweEGYdaMBwdwOIfBsR8WXvXJDa0FgB4o7ZjaaxVh
         fSXriLxKgMVqOwaOo7OIqKwcPSh3mwiJ2XTrLrTzmV7KA9FVTD5YHEKmfYe5AGiQTG2+
         KPRuBmDJR5KcBUr/UxNJixjt813lXAM2cL14LwMYyYFRRJbn5XvsOruN914UPVGEmT0n
         KRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XhJaJgHHBbx6CeUEut5CiByebd0OHra++Cf/Z1iRtAc=;
        b=ULPvE7ewo9rd1WqAi0SocihQzTEjW2Cq3XPAueGY8hQJ0VEtlu4ipSzq9RSI9uQgak
         I9oQiqK7DwzPZ8EgkQRBd2k0ud1RB/eqlYvSQh4rpUrPRYsjaVWmHD1i7D5n/enQZoUJ
         K0Z6O+2VfG2YadrtLdBtLxFQxusN/PMcaOKLjFDxtAQE4loyR1uDh5DG3/GGcN3ZM57Q
         bO+IEq/9+Oc9q6iKU+ZsT86XyoJ8pLJy+On/MwsioWILUds/WCY8/QzGi5SWBdtpozYz
         XRZIOkCUFYgbXBcSMsbGrTFlnoJsNZLt6gM3HmHH3VjADomiMAUc8zUc0GLa/w2E2bXs
         9bNA==
X-Gm-Message-State: ANhLgQ3JDpB5vjuJrRmbXqWMA1FMkYxaPTtCFKNisHmOi/ZaMYjZfodO
        oG4vS6QM6yj0MwVuM/S4q/SeG5FbK0VHF6uc3Sw=
X-Google-Smtp-Source: ADFU+vvofdZVahSQ7FPnXcmwgmCgOIk11/6nVf1JYDMqw2PqpPN8GAGhWg0yR9a5nYwn8bWTLGU0VsoBDVy9TbKLPUY=
X-Received: by 2002:a17:906:4956:: with SMTP id f22mr4826870ejt.293.1584648901177;
 Thu, 19 Mar 2020 13:15:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200319185620.1581-1-olteanv@gmail.com> <20200319151714.GB3446043@t480s.localdomain>
In-Reply-To: <20200319151714.GB3446043@t480s.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 19 Mar 2020 22:14:50 +0200
Message-ID: <CA+h21hqn5BH5u+6ornb--haE2yad1Mqe_B9L5UMEBuUAdiNazw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: add a dsa_port_is_enabled helper function
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew, Vivien,

On Thu, 19 Mar 2020 at 21:17, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> Hi Vladimir,
>
> On Thu, 19 Mar 2020 20:56:19 +0200, Vladimir Oltean <olteanv@gmail.com> wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > Sometimes drivers need to do per-port operation outside the port DSA
> > methods, and in that case they typically iterate through their port list
> > themselves.
> >
> > Give them an aid to skip ports that are disabled in the device tree
> > (which the DSA core already skips).
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  include/net/dsa.h |  2 ++
> >  net/dsa/dsa2.c    | 29 +++++++++++++++++++++++++++++
> >  2 files changed, 31 insertions(+)
> >
> > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > index beeb81a532e3..813792e6f0be 100644
> > --- a/include/net/dsa.h
> > +++ b/include/net/dsa.h
> > @@ -376,6 +376,8 @@ static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
> >               return dp->vlan_filtering;
> >  }
> >
> > +bool dsa_port_is_enabled(struct dsa_switch *ds, int port);
> > +
> >  typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
> >                             bool is_static, void *data);
> >  struct dsa_switch_ops {
> > diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> > index e7c30b472034..752f21273bd6 100644
> > --- a/net/dsa/dsa2.c
> > +++ b/net/dsa/dsa2.c
> > @@ -727,6 +727,35 @@ static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
> >       return err;
> >  }
> >
> > +bool dsa_port_is_enabled(struct dsa_switch *ds, int port)
> > +{
> > +     struct device_node *dn = ds->dev->of_node;
> > +     struct device_node *ports, *port_node;
> > +     bool found = false;
> > +     int reg, err;
> > +
> > +     ports = of_get_child_by_name(dn, "ports");
> > +     if (!ports) {
> > +             dev_err(ds->dev, "no ports child node found\n");
> > +             return false;
> > +     }
> > +
> > +     for_each_available_child_of_node(ports, port_node) {
> > +             err = of_property_read_u32(port_node, "reg", &reg);
> > +             if (err)
> > +                     goto out_put_node;
> > +
> > +             if (reg == port) {
> > +                     found = true;
> > +                     break;
> > +             }
> > +     }
> > +
> > +out_put_node:
> > +     of_node_put(ports);
> > +     return found;
> > +}
>
> Why do you need to iterate on the device tree? Ideally we could make
> abstraction of that (basic platform data is supported too) and use pure DSA
> helpers, given that DSA core has already peeled all that for us.
>
> Your helper above doesn't even look at the port's state, only if it is declared
> or not. Looking at patch 2, Using !dsa_is_unused_port(ds, port) seems enough.
>

Huh, this one was too smart for me.
I wrote the patch a while ago and did not really look deep enough to
spot this one. Actually I remember I did notice the
DSA_PORT_TYPE_UNUSED keyword, but I hadn't seen the ports being set
anywhere to that value. I realized just now that it's zero so they're
unused by default.
That's exactly why code review is amazing! Thank you, I've sent a v2
with your suggestion, it works a treat.

>
> Thanks,
>
>         Vivien

Thanks,
-Vladimir
