Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A57313939
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 17:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhBHQWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 11:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbhBHQWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 11:22:21 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DE9C061788;
        Mon,  8 Feb 2021 08:21:40 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id l18so9065027pji.3;
        Mon, 08 Feb 2021 08:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FwkWha3g7oAGpB4ws7tQE2d1Ep3IiBneyrvjPgo+ZlY=;
        b=c0r5N8jxVF6gKwrWgIFk8pzpa5inqJJ8IxXFim69z2u09lU41usZE+nCWufo8wzGbX
         xQGTDDnnAMsMXQm4FA2+T7yT8T1Na/dsKGh9ru3rKRUcNdTBa+DnwhHcePl67AGtIvNe
         fpKd1YiEuHmTv5UkLgVVYWCXVlNkOIn++vtiXyisvc7woTn4YLg3U1YENvqFW33tfkZN
         VJv/o7M3bNp6zDQeKw6ksavdZKHzZo2ehclHD4qqHJPCrweuWN4ikyFN7aWYEJQwWyKF
         dZ0DgxYyplPOGOLf85OWqLj64XccoT2gZzJDqgjGiX9JoCGzmkIM+kfKjL6JURNQJeMF
         FNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FwkWha3g7oAGpB4ws7tQE2d1Ep3IiBneyrvjPgo+ZlY=;
        b=QcFgnZx7oEXV5Zd4qAd+YxNHmEvsiNj64X4wVAjm6NA02yHqu2kDQGWaRFSbfKFAWT
         oFdbYCdBw1YlxqjyrdiJLEwyxJ83YMGA5fbf5PiI1gXoOSxVLuTjkfWRBXm+c7otgSmv
         XIZpqvcABpyMAI05Q+gve0vGs8BTEFvGIDIQPodqay4XSQlTg/TGxPezCjJlgD+nJNtx
         97pYDdP8UuNEQYtBcL4lMxcf52Tat3SQ6IOW2F0zkgQ4JvARpLMdMokJtoaPnQneTN0K
         WGu+5f8JaixnFylUF9/oLgkz+zbTCT5kJO3cHpHW9W/WrZZBZpRDPfNKeZtCWluzeTnG
         mHjg==
X-Gm-Message-State: AOAM5308OJ4WCChoaZZaaAPw2N0C1Xr3RG3Nyj3QBe/setfJWvpi7k9I
        W7S/3xuP9b/lODU7CXVe7qwFm0oe8P+k3VChYUU=
X-Google-Smtp-Source: ABdhPJzb6rIZJDKS/VoraARCNlcsJfBDoL00x231IpA5pGuxpSRJ5AtRSTI37rFBU7VtykBXo28JwAtQX5qXW9rTlBo=
X-Received: by 2002:a17:90a:644a:: with SMTP id y10mr18283260pjm.129.1612801300072;
 Mon, 08 Feb 2021 08:21:40 -0800 (PST)
MIME-Version: 1.0
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com> <20210208151244.16338-16-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210208151244.16338-16-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 8 Feb 2021 18:21:22 +0200
Message-ID: <CAHp75VcL1A3CxyS+KVwJsdhtQh3R12aUonPfstSgtzO4bRc1Zw@mail.gmail.com>
Subject: Re: [net-next PATCH v5 15/15] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
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

On Mon, Feb 8, 2021 at 5:15 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Modify dpaa2_mac_connect() to support ACPI along with DT.
> Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
> DT or ACPI.
>
> Replace of_get_phy_mode with fwnode_get_phy_mode to get
> phy-mode for a dpmac_node.
>
> Use helper function phylink_fwnode_phy_connect() to find phy_dev and
> connect to mac->phylink.

...

> +       if (is_of_node(dev->parent->fwnode)) {
> +               dpmacs = of_find_node_by_name(NULL, "dpmacs");
> +               if (!dpmacs)
> +                       return NULL;
> +               parent = of_fwnode_handle(dpmacs);
> +       } else if (is_acpi_node(dev->parent->fwnode)) {

> +               parent = dev->parent->fwnode;

dev_fwnode(dev->parent) ?

> +       }

...

> +               if (err) {
>                         continue;

> +               } else if (id == dpmac_id) {

Useless 'else'

> +                       if (is_of_node(dev->parent->fwnode))

dev_fwnode() ?

> +                               of_node_put(dpmacs);
> +                       return child;
> +               }

...

> +       if (is_of_node(dev->parent->fwnode))

Ditto ?

> +               of_node_put(dpmacs);

--
With Best Regards,
Andy Shevchenko
