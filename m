Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE1C231490
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 23:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbgG1V0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 17:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgG1V0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 17:26:18 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384E2C061794;
        Tue, 28 Jul 2020 14:26:18 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z188so3887054pfc.6;
        Tue, 28 Jul 2020 14:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BP9TLOb8iWBKBaHQTDWeoXLWCu+/pxbJoNqt1adSyJs=;
        b=dNSW7pGt8tKiXt5j4gLNjxjalfFEcrRQ6O4JENKtnkFgRhxw5RPItRUyaA9Tx0a86r
         Y/UW871vgsnMrkiaHHXxNAO4XxiUZq/lHbqaY068mpme20PX1nJcRB7l+QwdEzUsdzap
         x/7krCjj25N8cDr+95zu2gyGMjZlPDAIHoMeCtbQE9B16JRFnDBJcg3mauLG0hh0DrMA
         7q6yU9WF9WWQU2SfdvOAZcc3ojm/B5Apda55mRTt+yCF7i7TfrJfZRo7mzONnw08zHIJ
         FCn/KfZfmhCMz3Mkovz0CT4r1q0pGvdmuGk5qHx+0OX+hKMZrNto94ll+O2y7gOJvaFH
         49wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BP9TLOb8iWBKBaHQTDWeoXLWCu+/pxbJoNqt1adSyJs=;
        b=cZK+pKKd4M4Hrd2JYCFdnRDvliV5+9lLdWdsWVOoBTaEXDU6QH68NNSDkbntIDflyg
         oKVJQqgy5Rg84ErWtxyKF5eAjoIJLTZB8mpHv9MlgMK2dqMPMxcxbe/pYlh49B508fy4
         TImLhiA4rP2Yi8zJA+S4K/4/n0HE0+jDHVItL3b6tnL6uLXY7J+UU2fpAokHVh2zJAB+
         LQLSZgdXx3h+hwDRZu42InWRPq208T8YNafsfA6c7kzxcaBq5uzuY3JU+uS9FTinRcwe
         //RaN9+2bnbQNXJZNTvRoNeOpwvjneUrd++8Xy8Nck0jdHRz8m1Oa+pfE+Gc4tgIvUVg
         jnLw==
X-Gm-Message-State: AOAM533sTuZHQ5ONkEf2RJ5lwb5lOOMj0ADlHg4lLHZSnNm0ZU0SE4rZ
        2oHoyBJg5D0yhv4AWFcpJtD6aleLO3thDphiJ90=
X-Google-Smtp-Source: ABdhPJxpVR1blRg4owcyJurxRUKoqHd047pD0oW2E1fMysLXCp4MoRzTlLQg2cyutbkTHDTj6EbpSOrZHPHrY0M+3+Y=
X-Received: by 2002:a63:ce41:: with SMTP id r1mr26898777pgi.203.1595971577382;
 Tue, 28 Jul 2020 14:26:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com> <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch> <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch> <20200727172136.GC8003@bogus>
 <20200728203437.GB1748118@lunn.ch> <20200728205914.GV1551@shell.armlinux.org.uk>
In-Reply-To: <20200728205914.GV1551@shell.armlinux.org.uk>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 29 Jul 2020 00:26:01 +0300
Message-ID: <CAHp75VcR9UpDfTUWN_eFn5Q2cusPr08e5pTWKxGuqpHfL2AQ5w@mail.gmail.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO PHY
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, Sudeep Holla <sudeep.holla@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, linux.cj@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Vikas Singh <vikas.singh@puresoftware.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 11:59 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Tue, Jul 28, 2020 at 10:34:37PM +0200, Andrew Lunn wrote:
> > Hi Everybody
> >
> > So i think it is time to try to bring this discussion to some sort of
> > conclusion.
> >
> > No ACPI maintainer is willing to ACK any of these patches. Nor are
> > they willing to NACK them. ACPI maintainers simply don't want to get
> > involved in making use of ACPI in networking.
> >
> > I personally don't have the knowledge to do ACPI correctly, review
> > patches, point people in the right direction. I suspect the same can
> > be said for the other PHY maintainers.
> >
> > Having said that, there is clearly a wish from vendors to make use of
> > ACPI in the networking subsystem to describe hardware.
> >
> > How do we go forward?
> >
> > For the moment, we will need to NACK all patches adding ACPI support
> > to the PHY subsystem.
> >
> > Vendors who really do want to use ACPI, not device tree, probably
> > need to get involved in standardisation. Vendors need to submit a
> > proposal to UEFI and get it accepted.
> >
> > Developers should try to engage with the ACPI maintainers and see
> > if they can get them involved in networking. Patches with an
> > Acked-by from an ACPI maintainer will be accepted, assuming they
> > fulfil all the other usual requirements. But please don't submit
> > patches until you do have an ACPI maintainer on board. We don't
> > want to spamming the lists with NACKs all the time.
>
> For the record, this statement reflects my position as well (as one
> of the named phylib maintainers).  Thanks Andrew.

Again, folks, you are discussing something without direct Cc'ing to
them (I see a subset? of the maintainers we discussed in another
mail).
I believe that many maintainers are using some type of scoring for
their emails and Cc'ing directly increases chances to get a reply.
Also you have at least two or three people in ACPI/arm64. What do they think?

-- 
With Best Regards,
Andy Shevchenko
