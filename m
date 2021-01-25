Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7720F302264
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbhAYHVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbhAYHTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:19:03 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1274AC061574;
        Sun, 24 Jan 2021 23:17:17 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id c12so11121139wrc.7;
        Sun, 24 Jan 2021 23:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=imWT8x1VfryttURB+c34I8Arc6eUr4tH8HBx9rwr9xo=;
        b=jREqfwxefNy5Y87Sq6GebSt1vKDv7nGlj9BDHWyxRAZJEPqLerEIb+gdfuO4ydRmWo
         U9OJJJjq7wVhWzhmTBVBhg09kA7eIAPdVPBg2bOORpQHq7ZLbjOl0QCO5LiU6IRSbQli
         9KjfOGJh2wgdQxGTslYa0thTDKz22YxXkdrfv7B9gYIfiG27zLEh4ZX6svVdgtMcljUK
         n3ootdfsLZsZJpAdU2gTeAZ3lINEW+2oMVu5CvCjfpfRNBA2UlDhr/gVzSnvsYAFZWda
         dIYRCZKvRW1fO6K0/4OD6iAGkISauqS2Q/PJurO7yZCJSyH/HUOSaYQWs9WIf/vPYj52
         X2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=imWT8x1VfryttURB+c34I8Arc6eUr4tH8HBx9rwr9xo=;
        b=i9TmOM8qmELjaJ57XS+cCBoJrBxJYLoxC2nEKP8FOcfpHvvwD1Ts9iJGbbyGoISLH+
         HWGFJWxGCvv4kselt/LgoxsAsVFByeuDWIzn3MIlX1Jk56f/gdeN6z3+c6PDOi5YtNk7
         iE4rx04aehtUMpiXlthUD7ZZMtJYch45+oim7wyo2SL/bGhPwzV+SPGYPKGLb6GYiDXN
         FTLCzf0Uhee6tz7F9yx0cq39D6nl60LcZbYzPOXVjUM+bNGPU9yLada4uYZTjTrhhfsn
         Cr8iboz46ZfiRaQk2PBVGlkawcOgZ7tsH11/bVsh3IK25ljBwx/puulMJ6MSvO1wzUaR
         aM9w==
X-Gm-Message-State: AOAM531PiKAV6+E2UgHeQzvDOMZgCRs5QxWOj19Nl9xcVIbY3lMi+vys
        vUHi4Q8iglBG1faQDuyLdrIkatPrDnzAexHfcEk=
X-Google-Smtp-Source: ABdhPJwtm6odGy232UaZ1X3WYhhohSIieZm+YOcT7f0r6yDUSSV+ca/5N5wFRrOvPBdpQJ6T2HWbqBw3t3btbylsAS8=
X-Received: by 2002:adf:de92:: with SMTP id w18mr1224860wrl.264.1611559035776;
 Sun, 24 Jan 2021 23:17:15 -0800 (PST)
MIME-Version: 1.0
References: <20210120063019.1989081-1-paweldembicki@gmail.com> <20210121224505.nwfipzncw2h5d3rw@skbuf>
In-Reply-To: <20210121224505.nwfipzncw2h5d3rw@skbuf>
From:   =?UTF-8?Q?Pawe=C5=82_Dembicki?= <paweldembicki@gmail.com>
Date:   Mon, 25 Jan 2021 08:17:04 +0100
Message-ID: <CAJN1KkyCopZLzHc76GC9fi4nPf_y52syKZHQ1J4zbx7Z9sauyQ@mail.gmail.com>
Subject: Re: [PATCH] dsa: vsc73xx: add support for vlan filtering
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Linus Wallej <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

czw., 21 sty 2021 o 23:45 Vladimir Oltean <olteanv@gmail.com> napisa=C5=82(=
a):
>
> Hi Pawel,
>

Hi Vladimir,
Thank You for Your answer.

> On Wed, Jan 20, 2021 at 07:30:18AM +0100, Pawel Dembicki wrote:
> > This patch adds support for vlan filtering in vsc73xx driver.
> >
> > After vlan filtering enable, CPU_PORT is configured as trunk, without
> > non-tagged frames. This allows to avoid problems with transmit untagged
> > frames because vsc73xx is DSA_TAG_PROTO_NONE.
> >
> > Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
>
> What are the issues that are preventing you from getting rid of
> DSA_TAG_PROTO_NONE? Not saying that making the driver VLAN aware is a
> bad idea, but maybe also adding a tagging driver should really be the
> path going forward. If there are hardware issues surrounding the native
> tagging support, then DSA can make use of your VLAN features by
> transforming them into a software-defined tagger, see
> net/dsa/tag_8021q.c. But using a trunk CPU port with 8021q uppers on top
> of the DSA master is a poor job of achieving that.
>

I was planning to prepare tagging for the next step. Without VLAN
filtering and/or tagging it is usable only as a full bridge.
Vsc73xx devices support QinQ. I can use double tagging for port
separation, but then it's impossible to filter vlans.
So, I'm planning to start working with tagging based on
net/dsa/tag_8021q.c. Should I wait with this patch and send the
corrected version with tagging support?

> > ---
> > +static int
> > +vsc73xx_port_read_vlan_table_entry(struct dsa_switch *ds, u16 vid, u8 =
*portmap)
> > +{
> > +     struct vsc73xx *vsc =3D ds->priv;
> > +     u32 val;
> > +     int ret;
> > +
> > +     if (vid > 4095)
> > +             return -EPERM;
>
> This is a paranoid check and should be removed (not only here but
> everywhere).
>
> > +static int vsc73xx_port_vlan_prepare(struct dsa_switch *ds, int port,
> > +                                  const struct switchdev_obj_port_vlan=
 *vlan)
> > +{
> > +     /* nothing needed */
> > +     return 0;
> > +}
>
> Can you please rebase your work on top of the net-next/master branch?
> You will see that the API has changed.
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
>
> > +
> > +static void vsc73xx_port_vlan_add(struct dsa_switch *ds, int port,
> > +                               const struct switchdev_obj_port_vlan *v=
lan)
> > +{
> > +     bool untagged =3D vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> > +     bool pvid =3D vlan->flags & BRIDGE_VLAN_INFO_PVID;
> > +     struct vsc73xx *vsc =3D ds->priv;
> > +     int ret;
> > +     u32 tmp;
> > +
> > +     if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
> > +             return;
>
> Sorry, but no. You need to support the case where the bridge (or 8021q
> module) adds a VLAN even when the port is not enforcing VLAN filtering.
> See commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commi=
t/?id=3D0ee2af4ebbe3c4364429859acd571018ebfb3424
>
> > +
> > +     ret =3D vsc73xx_port_update_vlan_table(ds, port, vlan->vid_begin,
> > +                                          vlan->vid_end, 1);
> > +     if (ret)
> > +             return;
> > +
> > +     if (untagged && port !=3D CPU_PORT) {
> > +             /* VSC73xx can have only one untagged vid per port. */
> > +             vsc73xx_read(vsc, VSC73XX_BLOCK_MAC, port,
> > +                          VSC73XX_TXUPDCFG, &tmp);
> > +
> > +             if (tmp & VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_ENA)
> > +                     dev_warn(vsc->dev,
> > +                              "Chip support only one untagged VID per =
port. Overwriting...\n");
>
> Just return an error, don't overwrite, this leaves the bridge VLAN
> information out of sync with the hardware otherwise, which is not a
> great idea.
>

But it's a void return function. It always will be out of sync after
the second untagged VID attemption.
Should I give warning without changing untagged vlan?

> FWIW the drivers/net/dsa/ocelot/felix.c and drivers/net/mscc/ocelot.c
> files support switching chips from the same vendor. The VSC73XX family
> is much older, but some of the limitations apply to both architectures
> nonetheless (like this one), you can surely borrow some ideas from
> ocelot - in this case search for ocelot_vlan_prepare.
>

As Linus said, It's impossible because vsc73xx doesn't support tags
for external cpu via rgmii or regular port. This chip is very limited.

> > +
> > +             vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
> > +                                 VSC73XX_TXUPDCFG,
> > +                                 VSC73XX_TXUPDCFG_TX_UNTAGGED_VID,
> > +                                 (vlan->vid_end <<
> > +                                 VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_SHIF=
T) &
> > +                                 VSC73XX_TXUPDCFG_TX_UNTAGGED_VID);
> > +             vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
> > +                                 VSC73XX_TXUPDCFG,
> > +                                 VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_ENA,
> > +                                 VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_ENA)=
;
> > +     }
> > +     if (pvid && port !=3D CPU_PORT) {
> > +             vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
> > +                                 VSC73XX_CAT_DROP,
> > +                                 VSC73XX_CAT_DROP_UNTAGGED_ENA,
> > +                                 ~VSC73XX_CAT_DROP_UNTAGGED_ENA);
> > +             vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
> > +                                 VSC73XX_CAT_PORT_VLAN,
> > +                                 VSC73XX_CAT_PORT_VLAN_VLAN_VID,
> > +                                 vlan->vid_end &
> > +                                 VSC73XX_CAT_PORT_VLAN_VLAN_VID);
> > +     }
> > +}


Best Regards,
Pawel Dembicki
