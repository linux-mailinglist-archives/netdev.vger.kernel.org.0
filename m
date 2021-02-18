Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC9831ED63
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbhBRReS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhBRPFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 10:05:04 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B56EC061574;
        Thu, 18 Feb 2021 07:04:18 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id z15so1475332pfc.3;
        Thu, 18 Feb 2021 07:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SCWX+UOWBBJn4LzW9Yj7QYHcJVlwVskIMygyEWiC3wA=;
        b=ptTekISckA2jYFmD+CelhT4CRuY+9zmgwQo3vUOOSVTtYU+u8puIb5X6zY9O9vS4Qt
         1MVrE0TXQvA7aPaTJMlSGwlJCmmU2FjesAbdk6HWoy+6ECmBtkwBHrWfLk340T+lqtUr
         tdlpQjK67nm7aAClC/zNZtIW5TdxJTr0Nn3H3Zi5ilLW6kUonpRBd8U3ufddQMCY+XKw
         1u0NzVmgKd2Dtg8j62nf7CIB933MdcHVI+wy0MJaTfX66TYJr4epBwbhuxQ7WDefLkeb
         IzLkM4Wm9B9CfW/6kCUDReQYeXq3pXwpzi5DKlcM7ZnXDryILmtYSrRE05ziGFtkycuO
         fPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SCWX+UOWBBJn4LzW9Yj7QYHcJVlwVskIMygyEWiC3wA=;
        b=AsFwABVPeEPUgOK9qEcxcvjpuI4U+Bpb6fMOpx8u8WAg6k2Rr4FAQSXGy3oT3ExNV4
         1fX72lbpDw9lzkkrpE6muw+/ya8Ek/P3qcROA9rf31JAioBg9VpHvYLRuGABiBa3q6tD
         iWi2EfRrFpAfSC+OTf0Q1bYaimyt9HjD9QyQWZaWvLvxGxm2BX0IPByNga0maHtow8pG
         Z7Plf5qhdO3vJS789f+JbaoOLFwRZp4PSYjWNyqIAwsAiNAwx/1MdM9vGoCMqRirFDjN
         uP3t7U3kKnLtRrYaPb0yDDI+7TXWfKmYqgY7LoHzwTB9wGaFut9SYUM6E0DyW0d63qAr
         4G1g==
X-Gm-Message-State: AOAM533f9iAsL51R3dDHoMfbGtX18vTj6LlteRERNl3QeAZGJ9ldCNTr
        LuBz9OoP3iwslWqfNkM7hrQO8TAIGe34A1XGReM=
X-Google-Smtp-Source: ABdhPJwG5zE0x+hjJvBnpEznOmm5sOnqdV/YjJZRzgbBogf8unojEji7hX1GRoH0IU+rEawkdJbKxqx0xsaizjPJhNE=
X-Received: by 2002:a65:4c08:: with SMTP id u8mr4275873pgq.203.1613660658089;
 Thu, 18 Feb 2021 07:04:18 -0800 (PST)
MIME-Version: 1.0
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com> <20210218052654.28995-16-calvin.johnson@oss.nxp.com>
In-Reply-To: <20210218052654.28995-16-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 18 Feb 2021 17:04:02 +0200
Message-ID: <CAHp75VdUs8_6_bK1-TS2Bi9vQvLJLsr8C+Y5xXF2_FJHsFKeFQ@mail.gmail.com>
Subject: Re: [net-next PATCH v6 15/15] net: dpaa2-mac: Add ACPI support for
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "linux.cj" <linux.cj@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 7:29 AM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
>
> Modify dpaa2_mac_get_node() to get the dpmac fwnode from either
> DT or ACPI.
>
> Modify dpaa2_mac_get_if_mode() to get interface mode from dpmac_node
> which is a fwnode.
>
> Modify dpaa2_pcs_create() to create pcs from dpmac_node fwnode.
>
> Modify dpaa2_mac_connect() to support ACPI along with DT.

...

> +                       if (is_of_node(fwnode))

Redundant check I think. If it's not an fwnode, the dpmacs is NULL and
of_node_put() is NULL-aware.

> +                               of_node_put(dpmacs);

...

> +       if (is_of_node(fwnode))
> +               of_node_put(dpmacs);

Ditto.

...

>         mac->if_link_type = mac->attr.link_type;
> -

Do we need to remove this blank line?

...

> +       if (is_of_node(dpmac_node))
> +               fwnode_handle_put(dpmac_node);

> +       if (is_of_node(dpmac_node))
> +               fwnode_handle_put(dpmac_node);

Also not sure that you need a check in the above code excerpts.

-- 
With Best Regards,
Andy Shevchenko
