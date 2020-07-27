Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A0B22ECFB
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 15:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgG0NRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 09:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgG0NRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 09:17:20 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25761C061794;
        Mon, 27 Jul 2020 06:17:20 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id b9so7977187plx.6;
        Mon, 27 Jul 2020 06:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5M1ztqlAmxsfJxB6TYJ36mBz6BebKaVLzv7BqF77ask=;
        b=DhUKGdN9GVxPl/HxJBHias4O/OdYHRowok0FHtqa3zT9v4UZkPcobizy2rRTmDK7iT
         J1j9Y1QQTya37khlE5r6QbrW+gQOAjgYgEboqVUHnA2thT3jvMbei8bCcJYzECoChx1k
         2UaBvnnYKiMmT3CqpT0fYpmQQqcpy82WAhfcwTPPWJAYeK6p7rG2S/k+33amqJjAXiPf
         hFeORVrQF6iIGqf3tzlO8tFFCFe4aN3acVxKJv1/aKzIqCv4YnGkOXmA0hsv0MQvR0PM
         cTpUPjEUclGB6v0wYW/jNL9EZRnubd/8kZv8l25zikID3j6NgqxIan4BXQIuDGFe4GAj
         MO0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5M1ztqlAmxsfJxB6TYJ36mBz6BebKaVLzv7BqF77ask=;
        b=Y5D/z2PC214pFZ4zR3EnaEdwgjqhuqqub24tvR/EAMrPCgcXHyrVZxL4yCT3t5SZmC
         D6xqt3ywTr1m2R9befGSSc7EyvXlIJv0SshNxGRPO6p6lyeiyN0CM6LRuMA/Qwawce8y
         CTFymhPVSfo8wBZPDklVdLAch3WXosdCvO/vfSUt3JPzL+Ur0fLJ783Zc7PfLcvQ/Orf
         ZvOSPyQjHAzGFu5eqtyFAo9CkxXs0mzOoMFAo0hKOWfgEMltPYLnEmxO3NGtHCPOYfXq
         J5ZoocHsUr61WxzQX43uQVpwXoluLUwM3sXJB8nBLaXmFjvdrOEa687wvPs7cEBDy3qh
         mOsw==
X-Gm-Message-State: AOAM531PDK57Py3nSTIICCoB2dVCToWvn8opzVDAiDr16NbeuJhtWE15
        4nxiHZ9kpeNJyrLqaG233yxtTMXwhiFB8D7JfwA=
X-Google-Smtp-Source: ABdhPJyHNARron829QMmf5qROI7BZijxKNcznaVBBQ3zn6C8gxNMcMqsLkWO1LKvEMqBFLSMwxeMwSak6T1Q4G9ODII=
X-Received: by 2002:a17:90a:a393:: with SMTP id x19mr16478818pjp.228.1595855839567;
 Mon, 27 Jul 2020 06:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200727122242.32337-1-vadym.kochan@plvision.eu> <20200727122242.32337-5-vadym.kochan@plvision.eu>
In-Reply-To: <20200727122242.32337-5-vadym.kochan@plvision.eu>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 27 Jul 2020 16:17:04 +0300
Message-ID: <CAHp75Ve6YtrAW60FfT8QYsb6B3ZQuS7dZdz7dD9zB9b1=cpfog@mail.gmail.com>
Subject: Re: [net-next v4 4/6] net: marvell: prestera: Add ethtool interface support
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 3:23 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
>
> The ethtool API provides support for the configuration of the following
> features: speed and duplex, auto-negotiation, MDI-x, forward error
> correction, port media type. The API also provides information about the
> port status, hardware and software statistic. The following limitation
> exists:
>
>     - port media type should be configured before speed setting
>     - ethtool -m option is not supported
>     - ethtool -p option is not supported
>     - ethtool -r option is supported for RJ45 port only
>     - the following combination of parameters is not supported:
>
>           ethtool -s sw1pX port XX autoneg on
>
>     - forward error correction feature is supported only on SFP ports, 10G
>       speed
>
>     - auto-negotiation and MDI-x features are not supported on
>       Copper-to-Fiber SFP module

...

> +       if (new_mode < PRESTERA_LINK_MODE_MAX)
> +               err = prestera_hw_port_link_mode_set(port, new_mode);
> +       else
> +               err = -EINVAL;
> +
> +       if (!err) {
> +               port->caps.type = type;
> +               port->autoneg = false;
> +       }
> +
> +       return err;

Again

  if (new_mode >= ...)
    return -EINVAL;

  err = ...
  if (err)
    return err;

  ...
  return 0;

...

> +       ecmd->base.speed = !err ? speed : SPEED_UNKNOWN;

Why not positive conditional?

...

> +       if (!prestera_hw_port_duplex_get(port, &duplex)) {

Ditto.

...

> +static int
> +prestera_ethtool_set_link_ksettings(struct net_device *dev,
> +                                   const struct ethtool_link_ksettings *ecmd)
> +{
> +       struct prestera_port *port = netdev_priv(dev);

> +       u64 adver_modes = 0;
> +       u8 adver_fec = 0;

Redundant assignments?

> +       int err;
> +
> +       err = prestera_port_type_set(ecmd, port);
> +       if (err)
> +               return err;
> +
> +       if (port->caps.transceiver == PRESTERA_PORT_TCVR_COPPER) {
> +               err = prestera_port_mdix_set(ecmd, port);
> +               if (err)
> +                       return err;
> +       }
> +
> +       prestera_modes_from_eth(ecmd->link_modes.advertising, &adver_modes,
> +                               &adver_fec, port->caps.type);

> +       return 0;
> +}

...

> +       struct prestera_msg_port_attr_req req = {
> +               .attr = PRESTERA_CMD_PORT_ATTR_REMOTE_CAPABILITY,
> +               .port = port->hw_id,
> +               .dev = port->dev_id

+ comma

> +       };

...

> +       struct prestera_msg_port_attr_req req = {
> +               .attr = PRESTERA_CMD_PORT_ATTR_REMOTE_FC,
> +               .port = port->hw_id,
> +               .dev = port->dev_id

Ditto.

> +       };

...

> +       switch (resp.param.fc) {
> +       case PRESTERA_FC_SYMMETRIC:
> +               *pause = true;
> +               *asym_pause = false;
> +               break;
> +       case PRESTERA_FC_ASYMMETRIC:
> +               *pause = false;
> +               *asym_pause = true;
> +               break;
> +       case PRESTERA_FC_SYMM_ASYMM:
> +               *pause = true;
> +               *asym_pause = true;
> +               break;
> +       default:
> +               *pause = false;
> +               *asym_pause = false;
> +       }
> +
> +       return err;

return 0;

...

> +int prestera_hw_port_type_get(const struct prestera_port *port, u8 *type)
> +{

> +       struct prestera_msg_port_attr_req req = {
> +               .attr = PRESTERA_CMD_PORT_ATTR_TYPE,
> +               .port = port->hw_id,
> +               .dev = port->dev_id
> +       };

> +       return err;

Same comments as above.
And seems more code needs the same.

> +}

...

> +static u8 prestera_hw_mdix_to_eth(u8 mode)
> +{
> +       switch (mode) {
> +       case PRESTERA_PORT_TP_MDI:
> +               return ETH_TP_MDI;
> +       case PRESTERA_PORT_TP_MDIX:
> +               return ETH_TP_MDI_X;
> +       case PRESTERA_PORT_TP_AUTO:
> +               return ETH_TP_MDI_AUTO;
> +       }
> +
> +       return ETH_TP_MDI_INVALID;

Use the default case.

> +}
> +
> +static u8 prestera_hw_mdix_from_eth(u8 mode)
> +{
> +       switch (mode) {
> +       case ETH_TP_MDI:
> +               return PRESTERA_PORT_TP_MDI;
> +       case ETH_TP_MDI_X:
> +               return PRESTERA_PORT_TP_MDIX;
> +       case ETH_TP_MDI_AUTO:
> +               return PRESTERA_PORT_TP_AUTO;
> +       }
> +
> +       return PRESTERA_PORT_TP_NA;

Ditto.

> +}

-- 
With Best Regards,
Andy Shevchenko
