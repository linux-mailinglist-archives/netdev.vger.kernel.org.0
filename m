Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B831731BC16
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 16:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhBOPRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 10:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhBOPQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:16:35 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0BFC061574;
        Mon, 15 Feb 2021 07:15:52 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id cv23so3895502pjb.5;
        Mon, 15 Feb 2021 07:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0rSXsWgkIPp9LcQforsSfMG6IosnkE2y+0kuGemcWec=;
        b=dpuJndH3wLvC1smjtwpWiso7TjKO+CHXqm5me8ElygIzH7E2zcebDLGoIxFvsb7sFC
         FBjKpDWWrsFAGy0zaTySceq2GNCbUmz94XAHzGfXYhsFVITqQkF1giOndmRTochCYsr2
         k8xqGMZe8569vazxMC08vUNfc/iH7+MtKCQvwyUMu09u/E2+I9vy6op3iVd+3DAnzY19
         +utxNRJW7Q+RQl8EcYOP4ZtmktDzmVsIFpIG+KGuyStvj4X4DErvq3HxqJM/KkpZwy9b
         iy+C/MY2dbLil5jvy0mag5dOOW7ajf8SfJ3iCh0Iax3GF0lcg8W6oJy9xdqq51v5w8BR
         xpfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0rSXsWgkIPp9LcQforsSfMG6IosnkE2y+0kuGemcWec=;
        b=qSU6Fl+2w0E9O4aSqzjgXufzvnQQZqrEuSqr+5xEDzcTcy6o1frqVNH1db07Ow/BH0
         qmsxocsxnOdfbwNMBu0kJdll5YKvhZV7jv1YnCsgJ3dwr+RjvVU5phg2Ef0foyn3je/i
         u7Nj0E7b7RBTFnHIGIQrS0aLvE0itFX1E06eDQqQsIG+z9U+vFFpRX69vW7LwfsuwSLU
         c1/MhUx40gC2erbSxF5J5w7PVOnKVn5IDF8J74ntT1Ypyon4Rt+cgBSoAMHroewdRAAk
         caSXWea6taPWSoxJ8BPbUOnhXkUGhqCrMoG4OQuM0MEyMolmrZRGHBkZad0Swk0V60y6
         LECA==
X-Gm-Message-State: AOAM531zP5cgk6Qu4G7S8+tlRjIWSvDN6dAIiY1H1rnSoDXqyYkBHjXk
        Q4W0qOKplGOBYPJgav888Ar+4b9vtnDuTKLrltM=
X-Google-Smtp-Source: ABdhPJxwskZcsaaZiTXp5aWn51qO6stnRxwfBmOr2xwKBhAzDXV9MTODHcnk6/nIvbr/V7VXILKWYOWjTfSGE0EcuCA=
X-Received: by 2002:a17:90a:4fc1:: with SMTP id q59mr17212917pjh.129.1613402152155;
 Mon, 15 Feb 2021 07:15:52 -0800 (PST)
MIME-Version: 1.0
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
 <20210208151244.16338-16-calvin.johnson@oss.nxp.com> <20210208162831.GM1463@shell.armlinux.org.uk>
 <20210215123309.GA5067@lsv03152.swis.in-blr01.nxp.com> <CAHp75VcpR1uf-6me9-MiXzESP9gtE0=Oz5TaFj0E93C3w4=Fgg@mail.gmail.com>
In-Reply-To: <CAHp75VcpR1uf-6me9-MiXzESP9gtE0=Oz5TaFj0E93C3w4=Fgg@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 15 Feb 2021 17:15:36 +0200
Message-ID: <CAHp75Vfcpk_4OQDpk_rvySJbXAyzAubt-n=ckFzggdo9fKvJ4A@mail.gmail.com>
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

On Mon, Feb 15, 2021 at 5:13 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Mon, Feb 15, 2021 at 2:33 PM Calvin Johnson
> <calvin.johnson@oss.nxp.com> wrote:
> > On Mon, Feb 08, 2021 at 04:28:31PM +0000, Russell King - ARM Linux admin wrote:
>
> ...
>
> > I think of_phy_is_fixed_link() needs to be fixed. I'll add below fix.
> >
> > --- a/drivers/net/mdio/of_mdio.c
> > +++ b/drivers/net/mdio/of_mdio.c
> > @@ -439,6 +439,9 @@ bool of_phy_is_fixed_link(struct device_node *np)
> >         int len, err;
> >         const char *managed;
> >
> > +       if (!np)
> > +               return false;
>
> AFAICS this doesn't add anything: all of the of_* APIs should handle
> OF nodes being NULL below.
>
> >         /* New binding */
> >         dn = of_get_child_by_name(np, "fixed-link");
> >         if (dn) {

Yes, of_get_next_child() and of_get_property() are NULL aware.

So, the check is redundant.

-- 
With Best Regards,
Andy Shevchenko
