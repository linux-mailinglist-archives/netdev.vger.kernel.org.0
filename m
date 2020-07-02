Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF5D21200A
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgGBJfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgGBJfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:35:06 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB95C08C5C1;
        Thu,  2 Jul 2020 02:35:05 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 67so8230319pfg.5;
        Thu, 02 Jul 2020 02:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1MSOyhRxeOlZZV64ERgtop/oxnrPChw5nLGPyTva4Vo=;
        b=TVEnUSpK1abcjZ10U2QydBOOnzNT5Wgz11XhjEaZmJNpQo5VNiuwzY07xp477pR1mb
         h3WadbpIkM2HrXm8eTkP9nvzYDcoXLRPJLLaw8pFw0Sn9dRdDlU3SiauVqTK3uNg/4cs
         8uVyrWW3EwKuPNxmCjxlVSzbxVKU+kq8AiqewqwiDuD8+JGVoIArG8tJRFogHNf0v0JL
         EfWSq+Rt7LshYeYoOmSWcFnz7fqddRiAzR9k+RvQDg0pYRkaDLfHRna+xW7CnZTfihhG
         lQ/1JIPrPdJX3hBNOxN8gNw3fv6bCnZIv+crKfssoIWD/e2fqTi1zNuE5o0RHcDnE2/l
         Xu2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1MSOyhRxeOlZZV64ERgtop/oxnrPChw5nLGPyTva4Vo=;
        b=lSfnlhqPEVlg9uLl5Z+Nq+oPOR9mCLkd5Ns/SckG7eEdp7d3iJZsrmUdzJcWMPy0jb
         u0AIBJxgMvQP04tEsauGoOkzad/DEKviLPLhQd59r0sb6HO2KXc5ENQ+73cuqlXVawFn
         ZJUv3NmT8mY/6K9J8ewFdrY0m4F3704jvI0EZxpECoQ7hxvkNcfrkQaAUZn5z8X4YsAG
         yjGbndgFPrBsVMXusPsbkY8zInpabmlEJcUz2Byh7BOtcLiq9x7Q906cVPCm6XoNPNpM
         MHIcuah9H/t2JXLK3sP9PHcR2eoUFDcN3wKeMDr+XXBo7RpXf2mKGO0QZ69pMtq0o+WG
         JWew==
X-Gm-Message-State: AOAM5301/ni9QIbhamdJO+avjEZci1DBDi0EHbJeMeZvcOaWhS0gNC/W
        jyBE29TldZK27kSHN/cmwF8XcSGOsRusD9qEmpw=
X-Google-Smtp-Source: ABdhPJx+aVzkyyxLXExp4j2eKsWyN8fDRmTvCNbRTsS3OPkewUF1d8RWW+Ai+/aGfbaAdni+2CmOVnGZq4Bi2mFIHYc=
X-Received: by 2002:aa7:8bcb:: with SMTP id s11mr14668987pfd.170.1593682505328;
 Thu, 02 Jul 2020 02:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200701061233.31120-1-calvin.johnson@oss.nxp.com>
 <20200701061233.31120-4-calvin.johnson@oss.nxp.com> <VI1PR0402MB387145B3181911668E024264E06D0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB387145B3181911668E024264E06D0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 2 Jul 2020 12:34:48 +0300
Message-ID: <CAHp75VeFBOwN92XKJRZfpJn23bY4CGKxQCCn9n_krwxXtAdtLA@mail.gmail.com>
Subject: Re: [net-next PATCH v2 3/3] net: dpaa2-mac: Add ACPI support for
 DPAA2 MAC driver
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux.cj@gmail.com" <linux.cj@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 11:48 AM Ioana Ciornei <ioana.ciornei@nxp.com> wrote:
>
> > Subject: [net-next PATCH v2 3/3] net: dpaa2-mac: Add ACPI support for DPAA2
> > MAC driver
> >
> > Modify dpaa2_mac_connect() to support ACPI along with DT.
> > Modify dpaa2_mac_get_node() to get the dpmac fwnode from either DT or
> > ACPI.
> > Replace of_get_phy_mode with fwnode_get_phy_mode to get phy-mode for a
> > dpmac_node.
> > Define and use helper function find_phy_device() to find phy_dev that is later
> > connected to mac->phylink.

...

> > -     while ((dpmac = of_get_next_child(dpmacs, dpmac)) != NULL) {
> > -             err = of_property_read_u32(dpmac, "reg", &id);
> > -             if (err)
> > -                     continue;
> > -             if (id == dpmac_id)
> > -                     break;
> > +     if (is_of_node(fsl_mc_fwnode)) {
> > +             dpmacs = device_get_named_child_node(fsl_mc, "dpmacs");
> > +             if (!dpmacs)
> > +                     return NULL;
> > +
> > +             while ((dpmac = fwnode_get_next_child_node(dpmacs,
> > dpmac))) {
> > +                     err = fwnode_property_read_u32(dpmac, "reg", &id);
> > +                     if (err)
> > +                             continue;
> > +                     if (id == dpmac_id)
> > +                             return dpmac;
> > +             }
> > +     } else if (is_acpi_node(fsl_mc_fwnode)) {
> > +             adev = acpi_find_child_device(ACPI_COMPANION(dev->parent),
> > +                                           dpmac_id, false);
> > +             if (adev)
> > +                     return (&adev->fwnode);
> >       }
> > -
> > -     of_node_put(dpmacs);
> > -
>
> This of_node_put() on the 'dpmacs'  node still needs to happen for the OF case.

Actually this also raises the question if ACPI case increases refcount
or not and it should be fixed accordingly (Note, we have to take
reference to fwnode before return in ACPI case and drop reference to
adev).

-- 
With Best Regards,
Andy Shevchenko
