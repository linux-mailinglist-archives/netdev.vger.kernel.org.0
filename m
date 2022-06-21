Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251835535F4
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 17:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352816AbiFUPXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 11:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352669AbiFUPXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 11:23:43 -0400
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397971C12A;
        Tue, 21 Jun 2022 08:23:42 -0700 (PDT)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-3178ea840easo96466527b3.13;
        Tue, 21 Jun 2022 08:23:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/a0pyIcOYl26db8m1sX/0Miiqmbj2FyPnWoXKC6/IHU=;
        b=g0w5kGTY86P3tO+QmLjzxBN7Z6Bx7ndVmKP2hJatbTxmVPXwGOTom/w0EDI2hUkbZQ
         ZNtTUnpSDJCK6KcXlQi4P5475Vj8+xUjLuuvp8yCNKD889gIZ+28W60ZVS6XVfm7WliD
         rkw9sfo276sqWlSpdg3lmtcU3ziXrR/IGtDXqG0m8cqen3OeO8D998vXonXHQCRMij7e
         W0UQn8axosIVtlD73V8+ilAIVQZBY2gpDGpO9DURW9FjyIgKCmmAj0Z08/iRrPZ1qtcJ
         X4DAAqC4VK/62HSNQLZjNPvaNR/EAgD9ppwsFn5MG2YnmN0n/21Fc/+bBuD5bgRbKjmg
         wo5g==
X-Gm-Message-State: AJIora80p1swhpGhS22vaWnEYyyLofNuRXNukb89txO1wlKMuPuE6qSX
        kN0YLBDF301sn4o2och8qpHRpN5hHMF39g+FxWU=
X-Google-Smtp-Source: AGRyM1txVWd3v4xkkUJjohiG0OwsIZ4IxwRt8xwyYZx7y1E2PBGXu6kiZPccXqu3bztJTOOCNJhfl+ogYL62bpFx9O0=
X-Received: by 2002:a81:68d7:0:b0:318:11df:a40d with SMTP id
 d206-20020a8168d7000000b0031811dfa40dmr4140039ywc.196.1655825021450; Tue, 21
 Jun 2022 08:23:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220620150225.1307946-1-mw@semihalf.com> <20220620150225.1307946-10-mw@semihalf.com>
 <20220621094556.5ev3nencnw7a5xwv@bogus> <YrGoXXBgHvyifny3@smile.fi.intel.com>
 <YrGqg5fHB4s+Y7wx@lunn.ch> <20220621132836.wiyexi4y6vjeumrv@bogus>
In-Reply-To: <20220621132836.wiyexi4y6vjeumrv@bogus>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 21 Jun 2022 17:23:30 +0200
Message-ID: <CAJZ5v0gJPdWnu7u5+zxKbGvGvRrOeh6OxsHTXxvBaP7MOb1coA@mail.gmail.com>
Subject: Re: [net-next: PATCH 09/12] Documentation: ACPI: DSD: introduce DSA description
To:     Sudeep Holla <sudeep.holla@arm.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 3:28 PM Sudeep Holla <sudeep.holla@arm.com> wrote:
>
> On Tue, Jun 21, 2022 at 01:24:51PM +0200, Andrew Lunn wrote:
> > On Tue, Jun 21, 2022 at 02:15:41PM +0300, Andy Shevchenko wrote:
> > > On Tue, Jun 21, 2022 at 10:45:56AM +0100, Sudeep Holla wrote:
> > > > On Mon, Jun 20, 2022 at 05:02:22PM +0200, Marcin Wojtas wrote:
> > > > > Describe the Distributed Switch Architecture (DSA) - compliant
> > > > > MDIO devices. In ACPI world they are represented as children
> > > > > of the MDIO busses, which are responsible for their enumeration
> > > > > based on the standard _ADR fields and description in _DSD objects
> > > > > under device properties UUID [1].
> > > > >
> > > > > [1] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> > >
> > > > Why is this document part of Linux code base ?
> > >
> > > It's fine, but your are right with your latter questions.
> > >
> > > > How will the other OSes be aware of this ?
> > >
> > > Should be a standard somewhere.
> > >
> > > > I assume there was some repository to maintain such DSDs so that it
> > > > is accessible for other OSes. I am not agreeing or disagreeing on the
> > > > change itself, but I am concerned about this present in the kernel
> > > > code.
> > >
> > > I dunno we have a such, but the closest I may imagine is MIPI standardization,
> > > that we have at least for cameras and sound.
> > >
> > > I would suggest to go and work with MIPI for network / DSA / etc area, so
> > > everybody else will be aware of the standard.
> >
> > It is the same argument as for DT. Other OSes and bootloaders seem to
> > manage digging around in Linux for DT binding documentation. I don't
> > see why bootloaders and other OSes can not also dig around in Linux
> > for ACPI binding documentations.
> >
>
> Theoretically you are right. But in DT case majority of non-standard(by
> standard I am referring to the one's in Open Firmware specification) are
> in the kernel. But that is not true for ACPI. And that is the reason for
> objecting it. One of the main other OS using ACPI may not look here for
> any ACPI bindings(we may not care, but still OS neutral place is better
> for this).
>
> > Ideally, somebody will submit all this for acceptance into ACPI, but
> > into somebody does, i suspect it will just remain a defacto standard
> > in Linux.
> >
>
> DSD is not integral part of ACPI spec, so the process is never clear.
> However there is this project[1], IIUC it is just guidance and doesn't
> include any bindings IIUC. But we need something similar here for better
> visibility and to remain OS agnostic. Even with DT, there is a strong
> desire to separate it out, but it has grown so much that it is getting
> harder to do that with every release. I was just trying to avoid getting
> into that situation.
>
> [1] https://github.com/UEFI/DSD-Guide

Here's my personal take on this.

This patch series essentially makes the kernel recognize a few generic
(that is, not tied on any specific device ID) device properties
supplied by the firmware via _DSD.  They are generic, because there is
some library code in the kernel that can consume them and that library
code is used in multiple places (and it is better to supply data from
the firmware directly to it).

If we all agree that it is a good idea for the kernel to allow these
properties to be supplied via _DSD this way, there is no reason to
avoid admitting that fact in the kernel documentation.

IMV, there's nothing wrong with stating officially that these
properties are recognized by the kernel and what they are used for and
it has no bearing on whether or not they are also used by someone
else.
