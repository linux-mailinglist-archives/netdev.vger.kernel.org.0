Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA4E55372A
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 18:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353631AbiFUQCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 12:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353572AbiFUQBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 12:01:47 -0400
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA3C2F652;
        Tue, 21 Jun 2022 09:00:55 -0700 (PDT)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-3178ea840easo97552427b3.13;
        Tue, 21 Jun 2022 09:00:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yB/ZL6+L5GNkzKBj3jiXJtIZGsVXC7IFjlzFHfvTBlU=;
        b=5dAuMB3sn0b2trnrS1PU3/CnWR3M8yvDXUeh6KPLxRQv+uAgcSzBI2ZA8VM7istEnO
         AMAB18xsxDg8ha6Qcvmw4F5FbfdCcMULY8KIv5eVpiCHobrt+CBIO4/tXpd51WNNslT9
         MuYmAoGECQskNB/PATkOKwUcc5orL6vW4fxJ6LWF1UqXcZsiwmXWZiSZTd55Rxn3+Gmq
         gusc5IpV8d618/+zPnvHYLROMcFbc2TUTkDl2ZApfT1upy47v9fpTHIrhP14CIJGNRYX
         UyBY/Z2s9lJTNTGk3SnwD76NwxGZLC54E0WpSCHdGkZs3zaFyOvX/ZTVs6Fz/U3/CWq9
         z8Vg==
X-Gm-Message-State: AJIora9PR/5JGo1niRmV0ZAiLv9b6n6+MtFqe0OSqm082MS7Hb3gP9dH
        gPEwPfzI5tP8B0bsA6Sm0yxCh50I07T/gF/yIEg=
X-Google-Smtp-Source: AGRyM1sJPeLHl6/X7kbl3ocuzFFryFFXILIu/vDEsiSDQsRYODqS2xDzIskFU8JXUnhe+2o6THbRRbjgxY1VS1hrLRc=
X-Received: by 2002:a0d:e804:0:b0:317:9c5f:97a4 with SMTP id
 r4-20020a0de804000000b003179c5f97a4mr19864176ywe.19.1655827253268; Tue, 21
 Jun 2022 09:00:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220620150225.1307946-1-mw@semihalf.com> <20220620150225.1307946-10-mw@semihalf.com>
 <20220621094556.5ev3nencnw7a5xwv@bogus> <YrGoXXBgHvyifny3@smile.fi.intel.com>
 <YrGqg5fHB4s+Y7wx@lunn.ch> <20220621132836.wiyexi4y6vjeumrv@bogus>
 <CAJZ5v0gJPdWnu7u5+zxKbGvGvRrOeh6OxsHTXxvBaP7MOb1coA@mail.gmail.com> <20220621153718.p7z6v655gpijzedi@bogus>
In-Reply-To: <20220621153718.p7z6v655gpijzedi@bogus>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 21 Jun 2022 18:00:42 +0200
Message-ID: <CAJZ5v0gvs20PgdX1cR0PzMnQcv-bg8yQ4v8qQZRvKn1z-7=y8Q@mail.gmail.com>
Subject: Re: [net-next: PATCH 09/12] Documentation: ACPI: DSD: introduce DSA description
To:     Sudeep Holla <sudeep.holla@arm.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Len Brown <lenb@kernel.org>,
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

On Tue, Jun 21, 2022 at 5:37 PM Sudeep Holla <sudeep.holla@arm.com> wrote:
>
> On Tue, Jun 21, 2022 at 05:23:30PM +0200, Rafael J. Wysocki wrote:
> > On Tue, Jun 21, 2022 at 3:28 PM Sudeep Holla <sudeep.holla@arm.com> wrote:
> > >
> > > On Tue, Jun 21, 2022 at 01:24:51PM +0200, Andrew Lunn wrote:
> > > > On Tue, Jun 21, 2022 at 02:15:41PM +0300, Andy Shevchenko wrote:
> > > > > On Tue, Jun 21, 2022 at 10:45:56AM +0100, Sudeep Holla wrote:
> > > > > > On Mon, Jun 20, 2022 at 05:02:22PM +0200, Marcin Wojtas wrote:
> > > > > > > Describe the Distributed Switch Architecture (DSA) - compliant
> > > > > > > MDIO devices. In ACPI world they are represented as children
> > > > > > > of the MDIO busses, which are responsible for their enumeration
> > > > > > > based on the standard _ADR fields and description in _DSD objects
> > > > > > > under device properties UUID [1].
> > > > > > >
> > > > > > > [1] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> > > > >
> > > > > > Why is this document part of Linux code base ?
> > > > >
> > > > > It's fine, but your are right with your latter questions.
> > > > >
> > > > > > How will the other OSes be aware of this ?
> > > > >
> > > > > Should be a standard somewhere.
> > > > >
> > > > > > I assume there was some repository to maintain such DSDs so that it
> > > > > > is accessible for other OSes. I am not agreeing or disagreeing on the
> > > > > > change itself, but I am concerned about this present in the kernel
> > > > > > code.
> > > > >
> > > > > I dunno we have a such, but the closest I may imagine is MIPI standardization,
> > > > > that we have at least for cameras and sound.
> > > > >
> > > > > I would suggest to go and work with MIPI for network / DSA / etc area, so
> > > > > everybody else will be aware of the standard.
> > > >
> > > > It is the same argument as for DT. Other OSes and bootloaders seem to
> > > > manage digging around in Linux for DT binding documentation. I don't
> > > > see why bootloaders and other OSes can not also dig around in Linux
> > > > for ACPI binding documentations.
> > > >
> > >
> > > Theoretically you are right. But in DT case majority of non-standard(by
> > > standard I am referring to the one's in Open Firmware specification) are
> > > in the kernel. But that is not true for ACPI. And that is the reason for
> > > objecting it. One of the main other OS using ACPI may not look here for
> > > any ACPI bindings(we may not care, but still OS neutral place is better
> > > for this).
> > >
> > > > Ideally, somebody will submit all this for acceptance into ACPI, but
> > > > into somebody does, i suspect it will just remain a defacto standard
> > > > in Linux.
> > > >
> > >
> > > DSD is not integral part of ACPI spec, so the process is never clear.
> > > However there is this project[1], IIUC it is just guidance and doesn't
> > > include any bindings IIUC. But we need something similar here for better
> > > visibility and to remain OS agnostic. Even with DT, there is a strong
> > > desire to separate it out, but it has grown so much that it is getting
> > > harder to do that with every release. I was just trying to avoid getting
> > > into that situation.
> > >
> > > [1] https://github.com/UEFI/DSD-Guide
> >
> > Here's my personal take on this.
> >
> > This patch series essentially makes the kernel recognize a few generic
> > (that is, not tied on any specific device ID) device properties
> > supplied by the firmware via _DSD.  They are generic, because there is
> > some library code in the kernel that can consume them and that library
> > code is used in multiple places (and it is better to supply data from
> > the firmware directly to it).
> >
> > If we all agree that it is a good idea for the kernel to allow these
> > properties to be supplied via _DSD this way, there is no reason to
> > avoid admitting that fact in the kernel documentation.
> >
> > IMV, there's nothing wrong with stating officially that these
> > properties are recognized by the kernel and what they are used for and
> > it has no bearing on whether or not they are also used by someone
> > else.
>
> Good point. I was also suggested to make properties have prefix "linux-"
> similar to "uefi-" in the set of DSD properties list @[1]. In that case
> it makes more sense to maintain in the kernel. If they add "uefi-" prefix,
> I was also told that it can be hosted @[1] as specific in section 3.1.4 @[2]

Well, the point here is to use the same property names on both the DT
and ACPI ends IIUC and there's certain value in doing that.

The library in question already uses these names with DT and there is
no real need to change that.

Of course, if the platform firmware supplies these properties in a way
described in the document in question, it will be a provision
specifically for Linux and nothing else (unless that hypothetical
other thing decides to follow Linux in this respect, that is).  As
long as that is clear, I don't see why it would be better to introduce
different property names just for _DSD.

> I just sent an update to Documentation with the link to[1].

Thanks!

> I can also
> update the same to mention about the process as described in section 3.1.4
> if that helps and we are happy to follow that in the kernel.
>
> [1] https://github.com/UEFI/DSD-Guide
> [2] https://github.com/UEFI/DSD-Guide/blob/main/src/dsd-guide.adoc#314-adding-uefi-device-properties

IMV it would be useful to add that information, but IMO the process is
mostly relevant for new use cases, when someone wants to introduce an
entirely new property that is not yet covered by the DT bindings.

In the cases when the existing DT properties are the closest thing to
a standard way of supplying the OS with the information in question it
is most appealing to use the property names that are in use already.
