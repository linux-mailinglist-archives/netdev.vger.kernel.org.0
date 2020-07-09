Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B6121A94C
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgGIUsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgGIUsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 16:48:20 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BDEC08C5CE;
        Thu,  9 Jul 2020 13:48:20 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u185so1526511pfu.1;
        Thu, 09 Jul 2020 13:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nShq3a9m6qrSDUArKSCVQs5j4cI4QWD1el0qUFNbUE0=;
        b=W/xERrb6z2EbUyNLZh0+SCqTm381AStWBy+Fbm6vqRJRFIuVvffeyGvw9KJsltFMry
         1Ljf2/GRZ+8VnHawSvikoLWWB4nRAwLL38lhK+lFbd+b08b8xlBzhFsX24wzJxzqRkG3
         QFhCRVApSojs1LcxewxCT6DeVJ+QbNrvqOaNMPxUvbwaBfa0LsI7TpKkICYS/F0wOGR1
         Wxnb4vXoK5w4rDBU6IcqdG32u/1ScTLHcDDepNFhwd94H6FtmylrAxu3HEuJ8UYCFrSB
         Qic7NygFcwCfLTD94K3YQvzDqQLMBACQbaue2q6J6fqgtyv+Xhj1wrlwFid2nR41kuLI
         OL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nShq3a9m6qrSDUArKSCVQs5j4cI4QWD1el0qUFNbUE0=;
        b=NJ2gM3PX7q+dfQySjaKQ0cFwBX8wEw3LQBxQEk2heYQvQqBKZFSPR05mDeELm/I9V6
         jw97X9pk4kjYQog4a8oCGBwf6AmhFTL+HzzcZPKyIiNe14Gy4vDi9PzegWBaPZP0r/4+
         eAMC+S6gui0cyWQ35Lfrak77ZMB85ZLpBJCFJ2U30q8+5Xm8nOJv+9Hx/8VYoJiHo8hD
         /3/cW4eN/NSGE2Us9xW09eqdgf9Owm0nenjc2pkJiqol+aXUE7LR0IG0vWj2d9IdXtgb
         qP1tMNHp9txPUU+prtnJWjhOjhhKrIgh8xYp+mUcblqkuueXSk7yUSdWDaX41BgB29wu
         b2bQ==
X-Gm-Message-State: AOAM530iYiUU1wzNGHV6728q49BCyNK4yhLVwQ7LwRUbDntoY2tz7u+O
        Ge6z0/w1aNNA6Dy6BpSv67JuypHx1XwWBqb/oco=
X-Google-Smtp-Source: ABdhPJzQHkrJiCrUl0DifE7uEH8pX/JEDjH0Bq0/6+V7wyZ6jyjun/w343v0ZqyD5X8pl2tUP3vX8QiP9LQQ9uMUbNk=
X-Received: by 2002:aa7:8bcb:: with SMTP id s11mr45708900pfd.170.1594327699658;
 Thu, 09 Jul 2020 13:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200709175722.5228-1-calvin.johnson@oss.nxp.com> <20200709175722.5228-6-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200709175722.5228-6-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 9 Jul 2020 23:48:03 +0300
Message-ID: <CAHp75VdOF2qXFQOAyYVFLY-_JbGUAZ-6Cq-q_LRzKeV69RrJgg@mail.gmail.com>
Subject: Re: [net-next PATCH v4 5/6] phylink: introduce phylink_fwnode_phy_connect()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 8:58 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Define phylink_fwnode_phy_connect() to connect phy specified by
> a fwnode to a phylink instance.

...

> +       if (is_of_node(fwnode)) {
> +               ret = phylink_of_phy_connect(pl, to_of_node(fwnode), flags);
> +       } else if (is_acpi_device_node(fwnode)) {
> +               phy_dev = phy_find_by_fwnode(fwnode);
> +               if (!phy_dev)
> +                       return -ENODEV;
> +               ret = phylink_connect_phy(pl, phy_dev);
> +       }

Looking at this more I really don't like how this if-else-if looks like.

I would rather expect something like

               phy_dev = phy_find_by_fwnode(fwnode);
               if (!phy_dev)
                       return -ENODEV;
               ret = phylink_connect_phy(pl, phy_dev);

Where phy_find_by_fwnode() will take care about OF or any other
possible fwnode cases.

-- 
With Best Regards,
Andy Shevchenko
