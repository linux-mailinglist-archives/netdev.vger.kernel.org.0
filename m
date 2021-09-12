Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD4C4081AD
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 22:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236387AbhILUuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 16:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236321AbhILUuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 16:50:51 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1599C06175F
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 13:49:36 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id i13so7958901ilm.4
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 13:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4fqrnJ0RvaPV34Ys1XGOynmGvVMwS7FGS8x+jer6CM4=;
        b=vqw18g/43jU33OI4YtOS9L1fADFEcMt/EtjBzrzZqvc8r8lNbH+VmuMPPEL4T0BCvL
         iV/Iplllv6OCuu5P6Olv5ZTZ7RAN2Q7oQdmGuGFXvCBaT7aRhzVKIR7P47QjNR0PztZz
         u/8KmHN5npX+Xl8F+t3loWTm1ef9GsiKBy35STXQvPb8MvBZ4Q71WJYb+a7U8ZtQmqys
         grp5di2og8LHbj00JBSDvAf4O2CR1rJHasdJWyXy5AS0oQrHbfLyxP0s9meTqVnB7p+6
         aN8U6VqAYhm5ED8bSRNz7e8lfj9t870yhxaQvxPL//ubfgHzjW48l1HBKdGZUOQ2iX6O
         o7sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4fqrnJ0RvaPV34Ys1XGOynmGvVMwS7FGS8x+jer6CM4=;
        b=gax126Y+cLKw4Q1mZJzITEOcWHonPJdIrZjAV5P11kkkKHX1g729qHHnF5bkKwMwJ+
         ojpblc2t48gbdvkrCcrceZKY6Xxo7HeACJDTEyl3cY3uQdr7cbJoAWuwuWEwwKyKqSQO
         WLJEbg+v+3RMEjbcXa/oKXtHGpySBNkGJokHQVADB4UA4xPuKrZKQGrtZvZezfibGyaT
         o5tZIlmU7dcEIMizlTS10YSYNJS4VtJgkE8lg6+T0mwtx/NC5URGrsuJsA8W1DR6E9Yx
         siKTb4aKby+Sd4vei9zwS0hb1zCf1hO0l6ZSLvwPHozqIS21PSQc2KZDAdRyQz1k3s88
         aPyA==
X-Gm-Message-State: AOAM533bq48YfsFEXAX6ttGCin+7TaLThnU8dcFUlxhkE/i3hlmOs08f
        7T+xvvzgDHBQuDYQmLjFTIQMHOMDGZfcozKy3AfDOQ==
X-Google-Smtp-Source: ABdhPJx3SR5b1U9A1ers11IJjVaR9h+c+SsFVxccc1vquOcu1k2D9RRpFnvLlGXuf/v3SNwRhq6ROX9VBgGtSGiHl/E=
X-Received: by 2002:a92:6b10:: with SMTP id g16mr5562273ilc.147.1631479776208;
 Sun, 12 Sep 2021 13:49:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210912192805.1394305-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210912192805.1394305-1-vladimir.oltean@nxp.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Sun, 12 Sep 2021 22:49:25 +0200
Message-ID: <CANr-f5wCpcPM+FbeW+x-JmZt0-WmE=b5Ys1Pa_G7p8v3nLyCcQ@mail.gmail.com>
Subject: Re: [RFC PATCH net] Revert "net: phy: Uniform PHY driver access"
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This reverts commit 3ac8eed62596387214869319379c1fcba264d8c6.
>
> I am not actually sure I follow the patch author's logic, because the
> change does more than it says on the box, but this patch breaks
> suspend/resume on NXP LS1028A and probably on any other systems which
> have PHY devices with no driver bound, because the patch has removed the
> "!phydev->drv" check without actually explaining why that is fine.

The wrong assumption was that the driver is set for every device during probe
before suspend. Intention of the patch was only clean up of
to_phy_driver() usage.

>  static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
>  {
> +       struct device_driver *drv = phydev->mdio.dev.driver;
> +       struct phy_driver *phydrv = to_phy_driver(drv);
>         struct net_device *netdev = phydev->attached_dev;
>
> -       if (!phydev->drv->suspend)
> +       if (!drv || !phydrv->suspend)
>                 return false;
>
>         /* PHY not attached? May suspend if the PHY has not already been

I suggest to add the "!phydev->drv" check, but others may know it
better than me.

Gerhard
