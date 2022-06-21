Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83E9552F8C
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 12:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348582AbiFUKRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 06:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347417AbiFUKRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 06:17:03 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F210128706
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 03:17:01 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id d19so14839502lji.10
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 03:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mH1INl72b4b1qyntiz79cOsU7XObcsYSsqpV5JbVlA8=;
        b=tiDICGCN5jUEnTP8lLDEDMD9BBYNlmnqh8rSiZV+u2r33vs8pHaZTWlIWoIJNnTQa9
         1gBofbhO+8s/85yHEPCdLZb1pFC1D1G8VKRkB/RpZ6umm/adG5HVq5x44JqQDgPYNfWU
         ogW2cZDLbzmL7SGf5MQjrcVugAgX3G7PhvrySUo6GiOwfYz0UV0Yk2jPVF+hiOzJocBl
         Rs/QlPxt2xoHg/qicMSWpMruz9AfuCuvUWspYjfhY9AA3lPquQS4KilGHFYDjo6dxECD
         9Ez2uTRrBucQTVZD0pNdXmc0flfb03VviJmiGN0gPlmqZacgvrL0uUHABJrmj9n70RQw
         Mt3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mH1INl72b4b1qyntiz79cOsU7XObcsYSsqpV5JbVlA8=;
        b=aX8QNJY0bHLMPAuU3mVQr0gKQAM9iGv2a79PW+z4MmIahw8IokltmilJLcZsZmUwA6
         4cWBMppWGyc9/AWSthIqa5BWdEnfiMGc4mBgQ7rrxVbhUgjOP51pGpqPWp00rdvJngUf
         MDJR82FVdJihHLQyzyUkQXtfHR4X1V5VyG3u/JRvXKKPqaTez066bVsp8U4mnK30M5Wa
         EKeAabaaGHP/HARxoa7l9Dg8DoU8BBp6WXXKz5LyLg2cDphOUY6vnc/g8/v7vIBkdEom
         8FtntwJVZDkxgXcPmf8jm5gZCffNzuJIDumamNnRgfnUQSci53+LvR3s9sD82sYDWCJP
         ckCA==
X-Gm-Message-State: AJIora9HoHQxnzajcqz8dg7XJ9d/hrE8bgStyELuwaeTUzCJYaNtCj2H
        sGJsuMx4ds1KASFfHulxum19Xh7nHK0tP+aYU7opCA==
X-Google-Smtp-Source: AGRyM1tGUmhPrvkIfkYpDEL3yAufqvkWqPK+cyjmxnNYtmma2h6M9ydAJ6qRTzWykIeEsi7b+1m+xgVZ5gYjQ4VAi60=
X-Received: by 2002:a2e:bf05:0:b0:247:b233:cfba with SMTP id
 c5-20020a2ebf05000000b00247b233cfbamr13569523ljr.131.1655806620230; Tue, 21
 Jun 2022 03:17:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220620150225.1307946-1-mw@semihalf.com> <YrC0oKdDSjQTgUtM@lunn.ch>
In-Reply-To: <YrC0oKdDSjQTgUtM@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 21 Jun 2022 12:16:51 +0200
Message-ID: <CAPv3WKfVuWdhtpsMBnQCZK2yLzic1DPa2ibgn3DM1JcgYmo9hg@mail.gmail.com>
Subject: Re: [net-next: PATCH 00/12] ACPI support for DSA
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Len Brown <lenb@kernel.org>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pon., 20 cze 2022 o 19:56 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> On Mon, Jun 20, 2022 at 05:02:13PM +0200, Marcin Wojtas wrote:
> > Hi!
> >
> > This patchset introduces the support for DSA in ACPI world. A couple of
> > words about the background and motivation behind those changes:
> >
> > The DSA code is strictly dependent on the Device Tree and Open Firmware
> > (of_*) interface, both in the drivers and the common high-level net/dsa=
 API.
> > The only alternative is to pass the information about the topology via
> > platform data - a legacy approach used by older systems that compiled t=
he
> > board description into the kernel.
>
> Not true. There are deployed x86 systems which do this, and they are
> fully up to date, not legacy. There are however limitations in what
> you can do. So please drop this wording.
>

Ok, thanks for clarification, agree for rewording. Afair pdata was a
legacy derived from the Orion/Dove times, but indeed it can be used in
the new systems that lack other switch description.

> > The above constraint is problematic for the embedded devices based e.g.=
 on
> > x86_64 SoCs, which are described by ACPI tables - to use DSA, some tric=
ks
> > and workarounds have to be applied.
>
> It would be good to describe the limitations. As i said, there are x86
> systems running with marvell 6390 switches.

I'm aware of that and even saw some x86_64 + Marvell switch
contemporary examples of how lack of DT in system was worked around:
- out of tree updates to the module code
- keep small DT blob on the system storage, from where the mv88e6xxx
Those could be poor-coding / anecdotic showcases. I'd be happy to
learn if there is a proper and recommended way, how to do it properly.

>
> > It turned out that without much hassle it is possible to describe
> > DSA-compliant switches as child devices of the MDIO busses, which are
> > responsible for their enumeration based on the standard _ADR fields and
> > description in _DSD objects under 'device properties' UUID [1].
>
> No surprises there. That is how the DT binding works. And the current
> ACPI concept is basically DT in different words. Maybe the more
> important question is, is rewording DT in ACPI the correct approach,
> or should you bo doing a more native ACPI implementation? I cannot
> answer that, you need to ask the ACPI maintainers.

This is why I added linux-acpi list and the ACPI Maintainers to discuss

>
> > Note that for now cascade topology remains unsupported in ACPI world
> > (based on "dsa" label and "link" property values). It seems to be feasi=
ble,
> > but would extend this patchset due to necessity of of_phandle_iterator
> > migration to fwnode_. Leave it as a possible future step.
>
> We really do need to ensure this is possible. You are setting an ABI
> here, which everybody else in the ACPI world needs to follow. Cascaded
> switches is fundamental to DSA, it is the D in DSA. So i would prefer
> that you at least define and document the binding for D in DSA and get
> it sanity checked by the ACPI people.
>

I'm aware of the "D" importance, just kept it aside for now due to
lack of access to relevant HW and willing to discuss the overall
approach first.

WRT the technical side: multiple-phandle property is for sure
supported in _DSD, so the most straightforward would be to follow that
and simply migrate to fwnode_. The thing is in arm64 it's not widely
used and (testing that with ACPI is making it even harder).  There is
also an alternative brought by Andy - definitely a thing to discuss
further. I think we seem to have a quorum for that among recipents of
this thread.

Thanks,
Marcin
