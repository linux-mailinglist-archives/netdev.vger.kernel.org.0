Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52CD29E476
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgJ2HYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbgJ2HYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:37 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98496C0613DE
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 20:32:49 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id x7so1715340ili.5
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 20:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AsiV4LnA+WsAIcfsMfOV3Z6JnZh0EVY6VY/TiEVRYGc=;
        b=Je+OERTyyYnWtegiDUipd6LgVpBgin2zzE3RRmjviv0EYqfH8bBM7X91V6e1cvCb0C
         b343IlV5SX8cIx6xqcCUcOb2zAel0vA1DhnmE8qJIoDAWyInLIHqNKTWp67bzy8fbizm
         RkS8vP5Vg4Ay+XwPaC9Em+pCpIlZynGKPOkoK0lm7HbWs1wUaqwfwnHgQdhInBZRlCT2
         ZNLRmFswHTrk6g+7reBEIYwxKPgxBjDsY4e3rcL8AkJG2xXot/cxqHksUtfHWT/qhVIi
         sLiZgPaDSMukYfUgCob3r0OehtSfVUzU862mSnR035EFRGbyKjoG+8CLsLQIPEpUJjoq
         fLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AsiV4LnA+WsAIcfsMfOV3Z6JnZh0EVY6VY/TiEVRYGc=;
        b=O/7Wrylr8xXB+wzIj+cYb+rMLGfWQqY9pcGFZD8OFozX+u+4lI/YrzUemPoMXe6E/x
         i01FljGPetkRsDvhz73puztwxgczON4X8rtpMQ9os6UUNZT0kS0fFjzSoJSu1WzEMXo+
         WQkvgG7Y7quDUSqrMYrsE6f6LkYlE/IHluI2rHtnLnRCh3HNUXo4YTloZvkMZfcEIvwN
         bD6m4ILYP14UaJFcbQkhxL2o549kW0YHoXXIY+bBC2WaHCu1/Wj0k8HY3DMiuzZs6bLB
         6OuCrVDJ2GCUFdoDXxZRzcAh1267eZEe/n/5WlvfbtIMNJzZm6rWwqn5DA5RmEGAy747
         VAaw==
X-Gm-Message-State: AOAM530DX5n7DPXdGhTVKBTa/blOmEDktrnczmvASIvTFAMbEbaWeEi+
        Famk8mGK1f74X02SWqFQr6KEtXP8zhiQ+yW5P3U=
X-Google-Smtp-Source: ABdhPJyJuQJ5NXoCtP4TGKmvW5ZssXu4e6oPOg90fkB7wTzaMbhE0HfOJ2VYBkCZ/KbZh+HeRvJ5pO+Zpy8wyjUCk30=
X-Received: by 2002:a92:bacb:: with SMTP id t72mr1856455ill.241.1603942368868;
 Wed, 28 Oct 2020 20:32:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201028181221.30419-1-dqfext@gmail.com> <20201028183131.d4mxlqwl5v2hy2tb@skbuf>
In-Reply-To: <20201028183131.d4mxlqwl5v2hy2tb@skbuf>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Thu, 29 Oct 2020 11:32:36 +0800
Message-ID: <CALW65jYa9rTRaE2jn67iWG3=w=CFYvR0VWDNqtj5Vc3L=s6Jpg@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: mt7530: support setting MTU
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Jonathan McDowell <noodles@earth.li>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 2:31 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, Oct 29, 2020 at 02:12:21AM +0800, DENG Qingfang wrote:
> > MT7530/7531 has a global RX packet length register, which can be used
> > to set MTU.
> >
> > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> > ---
>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
>
> Also, please format your patches with --subject-prefix="PATCH net-next"
> in the future. Jakub installed some patchwork scripts that "guess" the
> tree based on the commit message, but maybe sometimes they might fail:
>
> https://patchwork.ozlabs.org/project/netdev/patch/e5fdcddeda21884a21162e441d1e8a04994f2825.1603837679.git.pavana.sharma@digi.com/
>
> >  drivers/net/dsa/mt7530.c | 36 ++++++++++++++++++++++++++++++++++++
> >  drivers/net/dsa/mt7530.h | 12 ++++++++++++
> >  2 files changed, 48 insertions(+)
> >
> > diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> > index de7692b763d8..7764c66a47c9 100644
> > --- a/drivers/net/dsa/mt7530.c
> > +++ b/drivers/net/dsa/mt7530.c
> > @@ -1021,6 +1021,40 @@ mt7530_port_disable(struct dsa_switch *ds, int port)
> >       mutex_unlock(&priv->reg_mutex);
> >  }
> >
> > +static int
> > +mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> > +{
> > +     struct mt7530_priv *priv = ds->priv;
> > +     int length;
> > +
> > +     /* When a new MTU is set, DSA always set the CPU port's MTU to the largest MTU
> > +      * of the slave ports. Because the switch only has a global RX length register,
> > +      * only allowing CPU port here is enough.
> > +      */
>
> Good point, please tell that to Linus (cc) - I'm talking about
> e0b2e0d8e669 ("net: dsa: rtl8366rb: Roof MTU for switch"),

And 6ae5834b983a ("net: dsa: b53: add MTU configuration support"),
1baf0fac10fb ("net: dsa: mv88e6xxx: Use chip-wide max frame size for MTU"),
f58d2598cf70 ("net: dsa: qca8k: implement the port MTU callbacks")

CC'd them as well.

Also, the commit e0b2e0d8e669 states that the new_mtu parameter is L2
frame length instead of L2 payload. But according to my tests, it is
L2 payload (i.e. the same as the MTU shown in `ip link` or `ifconfig`.
Is that right?

>
> > +     if (!dsa_is_cpu_port(ds, port))
> > +             return 0;
> > +
> > +     /* RX length also includes Ethernet header, MTK tag, and FCS length */
> > +     length = new_mtu + ETH_HLEN + MTK_HDR_LEN + ETH_FCS_LEN;
> > +     if (length <= 1522)
> > +             mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1522);
> > +     else if (length <= 1536)
> > +             mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1536);
> > +     else if (length <= 1552)
> > +             mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_PKT_LEN_MASK, MAX_RX_PKT_LEN_1552);
> > +     else
> > +             mt7530_rmw(priv, MT7530_GMACCR, MAX_RX_JUMBO_MASK | MAX_RX_PKT_LEN_MASK,
> > +                     MAX_RX_JUMBO(DIV_ROUND_UP(length, 1024)) | MAX_RX_PKT_LEN_JUMBO);
> > +
> > +     return 0;
> > +}
> > +
> > +static int
> > +mt7530_port_max_mtu(struct dsa_switch *ds, int port)
> > +{
> > +     return MT7530_MAX_MTU;
> > +}
> > +
> >  static void
> >  mt7530_stp_state_set(struct dsa_switch *ds, int port, u8 state)
> >  {
> > @@ -2519,6 +2553,8 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
> >       .get_sset_count         = mt7530_get_sset_count,
> >       .port_enable            = mt7530_port_enable,
> >       .port_disable           = mt7530_port_disable,
> > +     .port_change_mtu        = mt7530_port_change_mtu,
> > +     .port_max_mtu           = mt7530_port_max_mtu,
> >       .port_stp_state_set     = mt7530_stp_state_set,
> >       .port_bridge_join       = mt7530_port_bridge_join,
> >       .port_bridge_leave      = mt7530_port_bridge_leave,
