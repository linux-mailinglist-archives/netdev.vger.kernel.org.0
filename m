Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE6D5121BF3
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 22:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfLPViE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 16:38:04 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41377 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfLPViE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 16:38:04 -0500
Received: by mail-ed1-f67.google.com with SMTP id c26so6255238eds.8;
        Mon, 16 Dec 2019 13:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xNgDhHMX6rfsJfALYURvNY0HaS64TFbVe1sH5c4XLy0=;
        b=uc70yHje3PX7rHprLzhleCJeuyWvcKcKUEcg+dsD26CZ7dRZqFAef1Rjuc0npPAZmc
         2ogAB/NP2+dfVmIj1gWH8FyanDg0kkhTI2nMZdltE1PG/Xh7MYc+QPF8+GT2WmlDNNeD
         /sqyoyCqWY/O4erv4HceYyE7EuZs5eZVjp8eh96Mnfei6d5NOAY9WvmqZB822bjhlNaW
         jmFwZLzxK0CCsdp5/xZysiW2srRGIk6LJRNeSD4lTNmF96yocsCi9uK9S7XxUkscwzcH
         w3ZxKPll83oqBmpW0PHvKJGL1lunhQ2WAx32W8N1zmPaMybbaZm6ocrlK1o+k+mZMwR8
         g/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xNgDhHMX6rfsJfALYURvNY0HaS64TFbVe1sH5c4XLy0=;
        b=XvnnJL5LraPUNJNiNinbFPX3G/449cMhw7EDKycXwY21ifPoTbcu/YN2ax4N6oDJEM
         +yi44ku1F4KuM4D/Ac/mRWyRGyxWgOSJzCYI7NSJOiqx1LH9bvlb2AhcT4gMtRLqqZRH
         d+F08IamIc4HjmzHRvRnfOR5p8Tb6PRY7uICSDBQpxbXeHVzXtrx1WxLrJJMkktPBHRd
         uabOEPnHnjBrGyE3kRf3SXn1YEdCK4eUs+X3ZF3WiqMAqifHP0pusVnUMkPTVytBsR02
         3QsjV2GtqWjVA3i17urm471zRjM/GNBxDXLVhk+QKo+UqODNQJmYR7grI9w1MBomETXW
         zbAw==
X-Gm-Message-State: APjAAAV99Ocj2Kyrlnundy9mzKx6BXP9Bib2YFAYE3vJtN+4fcJJ+YI3
        kuJzlvldwzE3cSwyb46jpnc3LK4hDRuA9AM5MZQ=
X-Google-Smtp-Source: APXvYqzgDmvTKiZjCyLiUi5wt8/nJwvvzadxkdlzSuUxjzZLdz7Wn4PWxPS+xqEDrQMe2JheZ0j0Z9Xoha3MAyre3tA=
X-Received: by 2002:a17:906:3052:: with SMTP id d18mr1316604ejd.86.1576532281609;
 Mon, 16 Dec 2019 13:38:01 -0800 (PST)
MIME-Version: 1.0
References: <20191216183248.16309-1-f.fainelli@gmail.com>
In-Reply-To: <20191216183248.16309-1-f.fainelli@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 16 Dec 2019 23:37:50 +0200
Message-ID: <CA+h21hru33CpK-DOSnsSx62BEbteCYAePVjViKg4M68NAkgk4w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: Make PHYLINK related function static again
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 at 20:32, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> Commit 77373d49de22 ("net: dsa: Move the phylink driver calls into
> port.c") moved and exported a bunch of symbols, but they are not used
> outside of net/dsa/port.c at the moment, so no reason to export them.
>
> Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Acked-by: Vladimir Oltean <olteanv@gmail.com>

>  net/dsa/dsa_priv.h | 16 ----------------
>  net/dsa/port.c     | 38 ++++++++++++++++----------------------
>  2 files changed, 16 insertions(+), 38 deletions(-)
>
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 2dd86d9bcda9..09ea2fd78c74 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -150,22 +150,6 @@ int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags);
>  int dsa_port_vid_del(struct dsa_port *dp, u16 vid);
>  int dsa_port_link_register_of(struct dsa_port *dp);
>  void dsa_port_link_unregister_of(struct dsa_port *dp);
> -void dsa_port_phylink_validate(struct phylink_config *config,
> -                              unsigned long *supported,
> -                              struct phylink_link_state *state);
> -void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
> -                                       struct phylink_link_state *state);
> -void dsa_port_phylink_mac_config(struct phylink_config *config,
> -                                unsigned int mode,
> -                                const struct phylink_link_state *state);
> -void dsa_port_phylink_mac_an_restart(struct phylink_config *config);
> -void dsa_port_phylink_mac_link_down(struct phylink_config *config,
> -                                   unsigned int mode,
> -                                   phy_interface_t interface);
> -void dsa_port_phylink_mac_link_up(struct phylink_config *config,
> -                                 unsigned int mode,
> -                                 phy_interface_t interface,
> -                                 struct phy_device *phydev);
>  extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
>
>  /* slave.c */
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 46ac9ba21987..ffb5601f7ed6 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -415,9 +415,9 @@ static struct phy_device *dsa_port_get_phy_device(struct dsa_port *dp)
>         return phydev;
>  }
>
> -void dsa_port_phylink_validate(struct phylink_config *config,
> -                              unsigned long *supported,
> -                              struct phylink_link_state *state)
> +static void dsa_port_phylink_validate(struct phylink_config *config,
> +                                     unsigned long *supported,
> +                                     struct phylink_link_state *state)
>  {
>         struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
>         struct dsa_switch *ds = dp->ds;
> @@ -427,10 +427,9 @@ void dsa_port_phylink_validate(struct phylink_config *config,
>
>         ds->ops->phylink_validate(ds, dp->index, supported, state);
>  }
> -EXPORT_SYMBOL_GPL(dsa_port_phylink_validate);
>
> -void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
> -                                       struct phylink_link_state *state)
> +static void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
> +                                              struct phylink_link_state *state)
>  {
>         struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
>         struct dsa_switch *ds = dp->ds;
> @@ -444,11 +443,10 @@ void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
>         if (ds->ops->phylink_mac_link_state(ds, dp->index, state) < 0)
>                 state->link = 0;
>  }
> -EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_pcs_get_state);
>
> -void dsa_port_phylink_mac_config(struct phylink_config *config,
> -                                unsigned int mode,
> -                                const struct phylink_link_state *state)
> +static void dsa_port_phylink_mac_config(struct phylink_config *config,
> +                                       unsigned int mode,
> +                                       const struct phylink_link_state *state)
>  {
>         struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
>         struct dsa_switch *ds = dp->ds;
> @@ -458,9 +456,8 @@ void dsa_port_phylink_mac_config(struct phylink_config *config,
>
>         ds->ops->phylink_mac_config(ds, dp->index, mode, state);
>  }
> -EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_config);
>
> -void dsa_port_phylink_mac_an_restart(struct phylink_config *config)
> +static void dsa_port_phylink_mac_an_restart(struct phylink_config *config)
>  {
>         struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
>         struct dsa_switch *ds = dp->ds;
> @@ -470,11 +467,10 @@ void dsa_port_phylink_mac_an_restart(struct phylink_config *config)
>
>         ds->ops->phylink_mac_an_restart(ds, dp->index);
>  }
> -EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_an_restart);
>
> -void dsa_port_phylink_mac_link_down(struct phylink_config *config,
> -                                   unsigned int mode,
> -                                   phy_interface_t interface)
> +static void dsa_port_phylink_mac_link_down(struct phylink_config *config,
> +                                          unsigned int mode,
> +                                          phy_interface_t interface)
>  {
>         struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
>         struct phy_device *phydev = NULL;
> @@ -491,12 +487,11 @@ void dsa_port_phylink_mac_link_down(struct phylink_config *config,
>
>         ds->ops->phylink_mac_link_down(ds, dp->index, mode, interface);
>  }
> -EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_link_down);
>
> -void dsa_port_phylink_mac_link_up(struct phylink_config *config,
> -                                 unsigned int mode,
> -                                 phy_interface_t interface,
> -                                 struct phy_device *phydev)
> +static void dsa_port_phylink_mac_link_up(struct phylink_config *config,
> +                                        unsigned int mode,
> +                                        phy_interface_t interface,
> +                                        struct phy_device *phydev)
>  {
>         struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
>         struct dsa_switch *ds = dp->ds;
> @@ -509,7 +504,6 @@ void dsa_port_phylink_mac_link_up(struct phylink_config *config,
>
>         ds->ops->phylink_mac_link_up(ds, dp->index, mode, interface, phydev);
>  }
> -EXPORT_SYMBOL_GPL(dsa_port_phylink_mac_link_up);
>
>  const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
>         .validate = dsa_port_phylink_validate,
> --
> 2.17.1
>
