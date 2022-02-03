Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD2F4A8B00
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353000AbiBCRyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353305AbiBCRxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:53:43 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A94BC0613E8
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:52:15 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id t9so568837plg.13
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 09:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=096Ppq5v8Exvtmmsnsq3gHfM11D+76/nsWqV7r8Kxok=;
        b=PnF08dofvWXcv72TAexoUaadFvfHBM8r3Otq6zZ7PSRzUn5O8pjTtWm/+PLhONb43g
         Q+yDjaO6TN3OjkXWGhRp5M/rBD1sFx6hrrZgNDsgTl2k+ceMoGdDhnWgbHpg2Nm9icaP
         SmBVfJlgPVy+TpIDQlqA+OO4tLp7Y8lko3ZqO7tQZcObZljgGpFo+Ecy2LHhgTe/RE51
         /GmiMTuicrN2xN8YkRZxM5XEXKomgXM7Tu+rCpOoV5soDZ1LKeKRUHPPTJVbprKBo+oh
         5TwtKsvZV14q2Xh7hyFheLcoyPM+DoZqMJcBpg6RBI/1+dgzPeqvQoINxVnoMl4cD4Sr
         DA/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=096Ppq5v8Exvtmmsnsq3gHfM11D+76/nsWqV7r8Kxok=;
        b=Uyaf4hrzT2qZatNgxQ9hYhiGlHY9mAQ1KDZH0KaHzgh60ehsH1LdLNH20eE6yT4NLY
         6o5bSlma2oaI5Try/DaH7unha7bPZafesgXdDvOfGoW+pw+DSdN5rMjvzX86nkSWwJI6
         GhxaY1S463cfXkObR+jg3Fi8Nny5iiT37ERK+gjF1sbkY0FvVD00ShvsciqyM6qYp2n4
         iGezJiwQPzKtOXMFVBzb3mbX2KcG9qsB5spxnPzg+BraJG3V7ObvBJrWVGIzQC2q8Ydw
         GjZxdQUrsejP9wZGgJdTn0J32P6zGxEeTuaAGHZn1AO9gCdAl/a8WXeMufvbHtQwU1hW
         5phA==
X-Gm-Message-State: AOAM530s6NApjBW013Ka7VlP7Xos6BaFdZCP8GPuCE7ejGxuJ0BZr5pp
        QFWnRBbpeH13P9VymqHOM9F3gU4uBQFl7hep0UigIwZmZ+/Dgw==
X-Google-Smtp-Source: ABdhPJyeaMaXaAmfYN57Cn2alv2P3VcRFuaCrvUuHNUoMkgMXPGTvUxkkRoc5GYAYX6tQ70ytw3/YaoKPgT4uEbBoO4=
X-Received: by 2002:a17:90b:4a82:: with SMTP id lp2mr15210577pjb.179.1643910734453;
 Thu, 03 Feb 2022 09:52:14 -0800 (PST)
MIME-Version: 1.0
References: <20210421055047.22858-1-ms@dev.tdt.de> <CAJ+vNU1=4sDmGXEzPwp0SCq4_p0J-odw-GLM=Qyi7zQnVHwQRA@mail.gmail.com>
 <YfspazpWoKuHEwPU@lunn.ch> <CAJ+vNU2v9WD2kzB9uTD5j6DqnBBKhv-XOttKLoZ-VzkwdzwjXw@mail.gmail.com>
 <YfwEvgerYddIUp1V@lunn.ch>
In-Reply-To: <YfwEvgerYddIUp1V@lunn.ch>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Thu, 3 Feb 2022 09:52:03 -0800
Message-ID: <CAJ+vNU1qY1VJgw1QRsbmED6-TLQP2wwxSYb+bXfqZ3wiObLgHg@mail.gmail.com>
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led functions
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Martin Schiller <ms@dev.tdt.de>, Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 8:37 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Andrew,
> >
> > I agree with the goal of having PHY drivers and dt-bindings in Linux
> > to configure everything but in the case I mention in the other thread
> > adding rgmii delay configuration which sets a default if a new dt
> > binding is missing is wrong in my opinion as it breaks backward
> > compatibility. If a new dt binding is missing then I feel that the
> > register fields those bindings act on should not be changed.
>
> I would like that understand this specific case in more detail.  We
> have seen a few cases were the DT is broken, yet works. This is often
> caused by having a wrong phy-mode, which historically the PHY driver
> was ignoring. Then support for honouring the phy-mode was added to the
> PHY driver, and all the boards with broken DT files actually break.
>
> So it could be that is what has happened here. Or it could be the
> driver is plan wrong. If i understand correctly, you say it is adding
> a default delay of 2ns. That would be correct for a phy-mode of
> rgmii-id, but wrong for a phy-mode of rgmii.
>
> > > LEDs are trickier. There is a slow on going effort to allow PHY LEDs
> > > to be configured as standard Linux LEDs. That should result in a DT
> > > binding which can be used to configure LEDs from DT.
> >
> > Can you point me to something I can look at? PHY LED bindings don't at
> > all behave like normal LED's as they are blinked internally depending
> > on a large set of rules that differ per PHY.
>
> Yes, this is what is slowing the work done, agreeing on details like
> this, and how the user space API would actually work. In the end, i
> suspect a subset of LED modes will be supported, covering the common
> blink patterns.
>
> > Completely off topic, but due to the chip shortage we have had to
> > redesign many of our boards with different PHY's that now have
> > different bindings for RGMII delays so I have to add multiple PHY
> > configurations to DT's if I am going to support the use of PHY
> > drivers. What is your suggestion there? Using DT overlays I suppose is
> > the right approach.
>
> I would try to only use phy-mode, and avoid all PHY specific tweaks.
> So long as the track lengths don't change too much on your redesign,
> and are kept about the same length, the standard 2ns delay should
> work.
>

Andrew,

The issue is that in an ideal world where all parts adhere to the
JEDEC standards 2ns would be correct but that is not reality. In my
experience with the small embedded boards I help design and support
not about trace lengths as it would take inches to skew 0.5ns but
instead differences in setup/hold values for various MAC/PHY parts
that are likely not adhering the standards.

Some examples from current boards I support:
- CN8030 MAC rgmii-rxid with intel-xway GPY111 PHY: we need to
configure this for rx_delay=1.5ns and tx_delay=0.5ns
- CN8030 MAC rgmii-rxid with dp83867 GPY111 PHY: we need to configure
this for rx_delay=2.0ns and tx_delay=2.0ns (as would be expected)
- IMX8MM FEC MAC rgmii-id with intel-xway PHY: we need to configure
this for rx_delay=2ns and tx_delay=2.5ns
- IMX8MM FEC MAC rgmii-id with dp83867 PHY: we need to configure this
for rx_delay=2.0ns and tx_delay=2.0ns (as would be expected)

The two boards above have identical well matched trace-lengths between
the two PHY variant designs so you can see here that the intel-xway
GPY111 PHY needs an extra 0.5ps delay to avoid RX errors on the
far-off board. I really hate this GPY111 PHY but it's the only PHY we
can source currently; it's full of errata and to make things worse the
only available pin strapping options are for 0ns or 1.5ns (how is
1.5ns useful?) so we must rely on software configuration. So having
the intel-xway PHY driver set the delays to 2.0ns delays in the
absence of dt props (vs leaving them untouched) is what bothered me
there. The LED blink configuration has much more flexible strapping
options which we are able to use until this driver goes and changes
them to something else.

The way I determine the correct delay values is by looking for MAC RX
errors on the RX side and by looking for RX errors on the off-board
receiving end (typically via a managed switch). I know of no better
way to do this because the timing happens inside the MAC and PHY thus
scope measurements don't help here.

Best regards,

Tim
