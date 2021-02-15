Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5221431BC06
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 16:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhBOPPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 10:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhBOPOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:14:41 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C04C061756;
        Mon, 15 Feb 2021 07:14:00 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id z7so3893077plk.7;
        Mon, 15 Feb 2021 07:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MQBEYDbZLUspR4Cas4xHhX333Pehv/osTwNAcBMpXuY=;
        b=CQUKDoIcRBpm4Oq6Kl/kj7pKKcYjjng52/6QuMBh7xu8ycEXXdPCjDoNHhNjaLzMAp
         PpoZjlVPrAsNKPFc7EH5vPLJ+r3BNXYfqyK9QoNOCK3IjijK1pV9vFVX+liKR6InbW3j
         N69n3pzqz0R8HCM1iSX2ek8LAg3dvWnRl+63/g1YPHuOMxzHsocmOPe3A41LPoBy7+k/
         MZJkOGkscJQNG3eEKof4/HyYeekmPO7GAVOKWL30SKNu1Y2Fe8znWlpN2fzqLvYcrb1y
         R0Cj0CuBEl2iw2QhUmqNqZ1sc21Ixmduw3FI9QDc8KcsMXgqT/3ffHiuY4Msf/eAIkv4
         ZZhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MQBEYDbZLUspR4Cas4xHhX333Pehv/osTwNAcBMpXuY=;
        b=Y114AlawLJCPG1/YkGByDzDUb26FHDJyajrs+kqXjDv1Vqgd0Tc98rFqI6lc2Vd1GX
         CqLcqyA5BMvt+tupzroSqOACkdZMlr5JeKdviW4S60e6eCM/zHMB6aTDN/r7Oumk0K6m
         JofW0uSKAkpOQQoJs+KLrbwYgic7ZIVyb3o8MLbdabVE5mjiW8+C1IHUdvIkC5vdwwHW
         jd6DEVlWOs/E1ItVbmFalMa8NUEy1mVKdeJTwanxlbwSDqU6/8BIUMode+EqZNSAdAdG
         BJlrWiDnPAEOfGj6W7K0wnZ9uQ//0I7KnJCAZgAkWfNTbJGuy+RK7J2LnVF8jggki1//
         EufQ==
X-Gm-Message-State: AOAM532sNuDatK2DReSjFSKLvvXy9WE+lJwE5ka1QnWqDrQcg/qT+cay
        y3rJCNZJD75eXt8jb6j27AmDvw0mhy2/TKWqzHA=
X-Google-Smtp-Source: ABdhPJwq/oqehvgAavm6DkE/AtYDGnrfyneBipOjVQogGyrbG7SqrPvRhcFT2I9yV3pXFKozt+yik6ovEYPQK33uQeY=
X-Received: by 2002:a17:90a:1b23:: with SMTP id q32mr16968661pjq.181.1613402040270;
 Mon, 15 Feb 2021 07:14:00 -0800 (PST)
MIME-Version: 1.0
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
 <20210208151244.16338-16-calvin.johnson@oss.nxp.com> <20210208162831.GM1463@shell.armlinux.org.uk>
 <20210215123309.GA5067@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20210215123309.GA5067@lsv03152.swis.in-blr01.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 15 Feb 2021 17:13:44 +0200
Message-ID: <CAHp75VcpR1uf-6me9-MiXzESP9gtE0=Oz5TaFj0E93C3w4=Fgg@mail.gmail.com>
Subject: Re: [net-next PATCH v5 15/15] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 2:33 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
> On Mon, Feb 08, 2021 at 04:28:31PM +0000, Russell King - ARM Linux admin wrote:

...

> I think of_phy_is_fixed_link() needs to be fixed. I'll add below fix.
>
> --- a/drivers/net/mdio/of_mdio.c
> +++ b/drivers/net/mdio/of_mdio.c
> @@ -439,6 +439,9 @@ bool of_phy_is_fixed_link(struct device_node *np)
>         int len, err;
>         const char *managed;
>
> +       if (!np)
> +               return false;

AFAICS this doesn't add anything: all of the of_* APIs should handle
OF nodes being NULL below.

>         /* New binding */
>         dn = of_get_child_by_name(np, "fixed-link");
>         if (dn) {

-- 
With Best Regards,
Andy Shevchenko
