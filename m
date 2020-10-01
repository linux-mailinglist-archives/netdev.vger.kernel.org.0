Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E63D2802F2
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732717AbgJAPgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732417AbgJAPgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 11:36:25 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC08C0613D0;
        Thu,  1 Oct 2020 08:36:25 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d6so4847171pfn.9;
        Thu, 01 Oct 2020 08:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cg3wbDR04xmJHB+TGPRHBG7JiU528nISGUy/wwYR0YA=;
        b=T2sIPs+pWd7e9fuAwLNDnWSPDZ6NS1gAGLWZ13W5+J9jcgYuD8w0XVIL+tqDm3r6fi
         HXytKiICTlyDUrvgFtgXREM/fAUvMkkcKMLxOrZHhD+4sBL74LEuw1k8K3gaVxBsjC1z
         LFLV+gbwHfU3OdOw8rW/Bvyt0zIyM0NfXMiqLy8aIJ4ZELGfVLOZk1ht9AQLKwxwugKi
         P927bAHPcG9/f9McY+3gNLck261EN1PBOyhuGPlngi2Cimp1vocgT+300xLteG3t37vu
         pKytFTgsijEdAm+6usLDTbV9k2UOrPkqY699buhiNKkTQBGpnWhBfylkEOj+PEOpLpaA
         ABKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cg3wbDR04xmJHB+TGPRHBG7JiU528nISGUy/wwYR0YA=;
        b=r8n2f2buyadO1kTj9+LgUWAoazLbe8cwmSw9iakwELjnC3mWNbA5f+IRdPGjvyCu/Y
         MHws1rrcUjHWWuEe5gF4UGCLPIf1zTjGLcy19aLWQg4ON4rwnkGCD6t3oOghA/vtQ3Cv
         1LVry/l7u5PVm1sNndeIpRhv7lNJsKPgK+nubKRZCXwRIvm4VMXzupRZkJfKXQnOeDlq
         zrUBADKG6RQ9Boaod7FZbEbGBUParftk983IU0hzmXo4m4rehiyTyOJurRIiPkvr1sZQ
         PK4VZKUgp3mqwPj2yC98xxByAgrYgBT6EB5AF5HTWNs5UFJrK/gzBDVbpu+OcaQYU1ny
         LcQA==
X-Gm-Message-State: AOAM530aXnpYpvkfow4KOql/u3CXm+3GkWFaAE6waMyrgaTlgdUuNfRe
        Z/H9pQF8sYpCvBclAn0HEzt/5Q9npJ3W2j1MB8x0VnU+2sbftdM7
X-Google-Smtp-Source: ABdhPJx0ePV8ZxlgX4p+7m1myWdbYT0oUPnD4lXQDiT5O8wj8IfteO0VHbTZaTVt+PJDD8vNRzrLi/bjRud7qqknnM4=
X-Received: by 2002:a62:7f0e:0:b029:152:197b:e2bd with SMTP id
 a14-20020a627f0e0000b0290152197be2bdmr1721683pfd.7.1601566584648; Thu, 01 Oct
 2020 08:36:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com> <20200930160430.7908-7-calvin.johnson@oss.nxp.com>
In-Reply-To: <20200930160430.7908-7-calvin.johnson@oss.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 1 Oct 2020 18:36:06 +0300
Message-ID: <CAHp75Vfu_-=+CNYoRd141md902N2uR+K0xvHryfH9YCQi9Hp4w@mail.gmail.com>
Subject: Re: [net-next PATCH v1 6/7] net: dpaa2-mac: Add ACPI support for
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>, netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 7:06 PM Calvin Johnson
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

>  #include "dpaa2-eth.h"
>  #include "dpaa2-mac.h"

> +#include <linux/acpi.h>

Please, put generic headers first.

> +       struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> +       struct fwnode_handle *dpmacs, *dpmac = NULL;
> +       unsigned long long adr;
> +       acpi_status status;
>         int err;
> +       u32 id;
>
> -       dpmacs = of_find_node_by_name(NULL, "dpmacs");
> -       if (!dpmacs)
> -               return NULL;
> +       if (is_of_node(dev->parent->fwnode)) {
> +               dpmacs = device_get_named_child_node(dev->parent, "dpmacs");
> +               if (!dpmacs)
> +                       return NULL;
> +
> +               while ((dpmac = fwnode_get_next_child_node(dpmacs, dpmac))) {
> +                       err = fwnode_property_read_u32(dpmac, "reg", &id);
> +                       if (err)
> +                               continue;
> +                       if (id == dpmac_id)
> +                               return dpmac;
> +               }
>
> +       } else if (is_acpi_node(dev->parent->fwnode)) {
> +               device_for_each_child_node(dev->parent, dpmac) {
> +                       status = acpi_evaluate_integer(ACPI_HANDLE_FWNODE(dpmac),
> +                                                      "_ADR", NULL, &adr);
> +                       if (ACPI_FAILURE(status)) {
> +                               pr_debug("_ADR returned %d on %s\n",
> +                                        status, (char *)buffer.pointer);
> +                               continue;
> +                       } else {
> +                               id = (u32)adr;
> +                               if (id == dpmac_id)
> +                                       return dpmac;
> +                       }
> +               }

Can you rather implement generic one which will be

int fwnode_get_child_id(struct fwnode_handle *fwnode, u64 *id);

and put the logic of retrieving 'reg' or _ADR? Also, for the latter we
have a special macro
METHOD_NAME__ADR.

See [1] as well. Same idea I have shared already.

[1]: https://lore.kernel.org/linux-iio/20200824054347.3805-1-william.sung@advantech.com.tw/T/#m5f61921fa67a5b40522b7f7b17216e0d204647be

...

> -       of_node_put(dpmac_node);
> +       if (is_of_node(dpmac_node))
> +               of_node_put(to_of_node(dpmac_node));

I'm not sure why you can't use fwnode_handle_put()?

> +       if (is_of_node(dpmac_node))
> +               of_node_put(to_of_node(dpmac_node));

Ditto.

--
With Best Regards,
Andy Shevchenko
