Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8621195BB6
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 11:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbfHTJy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 05:54:57 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40724 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729585AbfHTJy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 05:54:57 -0400
Received: by mail-ed1-f67.google.com with SMTP id h8so5612100edv.7
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 02:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XhMobGixGSOKrIRpXogWEHJb4+t7SAOuKQm7Licg+J8=;
        b=P+2qGrKIBWr+Z9sr8Qh6ekdV7RnvvqvevJiRIfySsnFQsP2o2kc4i1+nUYuV+EGbza
         B15KoQxNfztFDnkvFD00mwzoWGQsAWhyn+/OkQ09/OlnBk6K318s9yDVJA1SdfZ+5yEz
         GJNapg/MuOASFMnFPzEBKeppzcWh3M1S74lmlWb86GCQfJP1bPV488uJVNW9UAQ6hNhC
         9Vgh+a9RPUrU8mBEEsniz+sonJWk5nBLwLF8DjDaWSm+GlNRnDTE3pQ+2T2pXJ7Q4QIv
         KVITjLgTXbvJHivfpuyShNKZhqrWPDwqbQ9oHihEX1psrmuZt5C23T0HNJmhQtUM6llz
         axDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XhMobGixGSOKrIRpXogWEHJb4+t7SAOuKQm7Licg+J8=;
        b=CVLe8m5PVTWqOFRg82+KsfzmjWPxuVF2j9N8eyIWkP7rHHAaLRyhf4qKW6tMsXRRxR
         0dAb/uyRklIryYit4A3I/JuhLGzXaWZRevCO2PJojLOaRZnGs0iB6vq5qwqn81M7CZSL
         nGwVfl88TYtxpcMPVTABZFbJwjvJ+yqHGjXCKp/n6Cs+vwSA3n8RB9AIYKv6LDuJQ4wl
         5WdqU81d60OCBhGIpQfslOVs0mx8bVJn+bHtUZSDMoIXKyE/FlmsiGdRQVQyEMxalTk5
         hJ4+6AGH2O9PUswJLC3BKtNRRWwmuedLJLpklwQlC7r4kk6C5qxWrVRo3taAH7tHCVA2
         sK0g==
X-Gm-Message-State: APjAAAWsckB99EA0p1u3kUIwlb4Csfgf2aNeMk/SKbYVkKA0werKA8YQ
        AmCTWC5hD9p1Vb4lVo1ZSXkESHFF5tXSumhXmlc=
X-Google-Smtp-Source: APXvYqwxn6sywsuzPQqPdspNUFT5aiNadzMWGMoq9PvBOuD/InhLZpn2NGETUwQQbs6J74Y3BKh1/7oRI9/jUzXfQQY=
X-Received: by 2002:aa7:c508:: with SMTP id o8mr29831435edq.123.1566294895658;
 Tue, 20 Aug 2019 02:54:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190820000002.9776-1-olteanv@gmail.com> <20190820000002.9776-4-olteanv@gmail.com>
 <20190820015138.GB975@t480s.localdomain>
In-Reply-To: <20190820015138.GB975@t480s.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 20 Aug 2019 12:54:44 +0300
Message-ID: <CA+h21hpdDuoR5nj98EC+-W4HoBs35e_rURS1LD1jJWF5pkty9w@mail.gmail.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: Delete the VID from the upstream
 port as well
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vivien!

On Tue, 20 Aug 2019 at 08:51, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> Vladimir,
>
> On Tue, 20 Aug 2019 02:59:59 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > Commit b2f81d304cee ("net: dsa: add CPU and DSA ports as VLAN members")
> > is littering a lot. After deleting a VLAN added on a DSA port, it still
> > remains installed in the hardware filter of the upstream port. Fix this.
>
> Littering a lot, really?
>
> FYI we are not removing the target VLAN from the hardware yet because it would
> be too expensive to cache data in DSA core in order to know if the VID is not
> used by any other slave port of the fabric anymore, and thus safe to remove.
>
> Keeping the VID programmed for DSA and CPU ports is simpler for the moment,
> as an hardware VLAN with only these ports as members is unlikely to harm.
>
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  net/dsa/switch.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> > index 09d9286b27cc..84ab2336131e 100644
> > --- a/net/dsa/switch.c
> > +++ b/net/dsa/switch.c
> > @@ -295,11 +295,20 @@ static int dsa_switch_vlan_del(struct dsa_switch *ds,
> >                              struct dsa_notifier_vlan_info *info)
> >  {
> >       const struct switchdev_obj_port_vlan *vlan = info->vlan;
> > +     int port;
> >
> >       if (!ds->ops->port_vlan_del)
> >               return -EOPNOTSUPP;
> >
> > +     /* Build a mask of VLAN members */
> > +     bitmap_zero(ds->bitmap, ds->num_ports);
> >       if (ds->index == info->sw_index)
> > +             set_bit(info->port, ds->bitmap);
> > +     for (port = 0; port < ds->num_ports; port++)
> > +             if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
> > +                     set_bit(port, ds->bitmap);
> > +
> > +     for_each_set_bit(port, ds->bitmap, ds->num_ports)
> >               return ds->ops->port_vlan_del(ds, info->port, vlan);
>
> You return right away from the loop? You use info->port instead of port?
>
> >
> >       return 0;
>
> Even if you patch wasn't badly broken, "bridge vlan del" targeting a single
> switch port would also remove the VLAN from the CPU port and thus breaking
> offloaded 802.1q. It would also remove it from the DSA ports interconnecting
> multiple switches, thus breaking the 802.1q conduit for the whole fabric.
>
> So you're not fixing anything here, but you're breaking single-chip and
> cross-chip hardware VLAN. Seriously wtf is this patch?
>
> NAK!
>
>
>         Vivien

I can agree that this isn't one of my brightest moments. But at least
we get to see Cunningham's law in action :)
When dsa_8021q is cleaning up the switch's VLAN table for the bridge
to use it, it is good to really clean it up, i.e. not leave any VLAN
installed on the upstream ports.
But I think this is just an academical concern at this point. In
vlan_filtering mode, the CPU port will accept VLAN frames with the
dsa_8021q ID's, but they will eventually get dropped due to no
destination. The real breaker is the pvid change. If something like
patch 4/6 gets accepted I will drop this one.

Regards,
-Vladimir
