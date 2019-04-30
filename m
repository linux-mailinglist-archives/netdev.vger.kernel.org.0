Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE3E3101A9
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 23:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfD3VQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 17:16:34 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38069 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfD3VQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 17:16:33 -0400
Received: by mail-oi1-f195.google.com with SMTP id t70so6930426oif.5;
        Tue, 30 Apr 2019 14:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x9ZdZ6bqDGn77i1srwmu08QqiEMLIMYWir0Z07Jgos4=;
        b=tCOH4p5lTlmioAsZqTtSB+b0a25F+mDmltNf24TLMx/NVs8Ae6didfVzvIhMbq+f2v
         Ke8egsIHm3e8me3HmnRcVBsary2K0iVbV2pmQ6DbZkCPQ/5+bjt8DMOLo6YTB4VYKMzp
         87ZmW7Lz8f1d3EIqyejA4sHAY1q5gOWHhQzJkkCB/EIsDJjrTEsoG13cYKV1RUv6pT6c
         9xZt+SqnMqFrSxwtERSJregeIUUYbvlP3DwoZ14k8uQ8d6hQ+FaOJR5VA0CD1ko/DAEE
         G0xp3vXZ054tbPZ4IGASKq9oOajBFf94fQv//ibLur3dm+zDp8jpNr0zFV5vGpH6Vfow
         PknA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x9ZdZ6bqDGn77i1srwmu08QqiEMLIMYWir0Z07Jgos4=;
        b=o2CKOFZUtdTidmuBuejLkvJ3D0bLOdAKUshmtV+R3YL0ghwLhtJ9N0spErJ/mr6t32
         DIB2xKIJ1kEE2V8HFjRq/vfBu3azIEvYEDOmKVu+6BoDiFBZs1otv4eCbfAY0ijMaIUZ
         VMqUhZgLH0vbNLs96p4YwRr6Gl2umZXWK5dQELAvR+ob1GNUNPTPyWy84JmNNI4YJCq1
         da/Y9HcgOC/pHvxSZqPgl1fT8uaGbKOhK/C1EYgEAMZo2d52z+erKA1xSZX5pMJJjCMh
         UB79TjlxdYY0Ekp2Q/rD9ERrTNpwTCQTA7GpXlFLzJm9YZvNAaJwxzF25g8HImIc7jvJ
         2GPQ==
X-Gm-Message-State: APjAAAV/vACKXzZCamvgUAJy/gmy1435ZeO2xYPkD6qt02yakYJ72tjK
        2QnWgRPYggFbn54qe/isjsf+paWqC9x3/lnTxwk=
X-Google-Smtp-Source: APXvYqxpFku/XQC3iL9KSS5SgUZ1DZzVlX9Sw5r89SbJxBuDBWgOycj4EcLrUFnKQDJ6ePGahw8Lv6YYcjeUROR38us=
X-Received: by 2002:aca:4482:: with SMTP id r124mr4713694oia.39.1556658992394;
 Tue, 30 Apr 2019 14:16:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190426212112.5624-1-fancer.lancer@gmail.com>
 <20190426212112.5624-2-fancer.lancer@gmail.com> <20190426214631.GV4041@lunn.ch>
 <20190426233511.qnkgz75ag7axt5lp@mobilestation> <f27df721-47aa-a708-aaee-69be53def814@gmail.com>
 <CA+h21hpTRCrD=FxDr=ihDPr+Pdhu6hXT3xcKs47-NZZZ3D9zyg@mail.gmail.com> <20190429211225.ce7cspqwvlhwdxv6@mobilestation>
In-Reply-To: <20190429211225.ce7cspqwvlhwdxv6@mobilestation>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 30 Apr 2019 23:16:21 +0200
Message-ID: <CAFBinCBxgMr6ZkOSGfXZ9VwJML=GnzrL+FSo5jMpN27L2o5+JA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: phy: realtek: Change TX-delay setting for
 RGMII modes only
To:     Serge Semin <fancer.lancer@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Hello Serge,

On Mon, Apr 29, 2019 at 11:12 PM Serge Semin <fancer.lancer@gmail.com> wrote:
[...]
> > > > Apparently the current config_init method doesn't support RXID setting.
> > > > The patch introduced current function code was submitted by
> > > > Martin Blumenstingl in 2016:
> > > > https://patchwork.kernel.org/patch/9447581/
> > > > and was reviewed by Florian. So we'd better ask him why it was ok to mark
> > > > the RGMII_ID as supported while only TX-delay could be set.
> > > > I also failed to find anything regarding programmatic rtl8211f delays setting
> > > > in the Internet. So at this point we can set TX-delay only for f-model of the PHY.
let me give you a bit of context on that patch:
most boards (SBCs and TV boxes) with an Amlogic SoC and a Gigabit
Ethernet PHY use a Realtek RTL8211F PHY. we were seeing high packet
loss when transmitting from the board to another device.
it took us very long to understand that a combination of different
hardware and driver pieces lead to this issue:
- in the MAC driver we enabled a 2ns TX delay by default, like Amlogic
does it in their vendor (BSP) kernel
- we used the upstream Realtek RTL8211F PHY driver which only enabled
the TX delay if requested (it never disabled the TX delay)
- hardware defaults or pin strapping of the Realtek RTL8211F PHY
enabled the TX delay in the PHY

This means that the TX delay was applied twice: once at the MAC and
once at the PHY.
That lead to high packet loss when transmitting data.
To solve that I wrote the patch you mentioned, which has since been
ported over to u-boot (for a non-Amlogic related board)

> > > > Anyway lets clarify the situation before to proceed further. You are suggesting
> > > > to return an error in case if either RGMII_ID or RGMII_RXID interface mode is
> > > > requested to be enabled for the PHY. It's fair seeing the driver can't fully
> > > > support either of them.
I don't have any datasheet for the Realtek RTL8211F PHY and I'm not in
the position to get one (company contracts seem to be required for
this).
Linux is not my main job, I do driver development in my spare time.

there may or may not be a register or pin strapping to configure the RX delay.
due to this I decided to leave the RX delay behavior "not defined"
instead of rejecting RGMII_RXID and RGMII_ID.

> > > That is how I read Andrew's suggestion and it is reasonable. WRT to the
> > > original changes from Martin, he is probably the one you would want to
> > > add to this conversation in case there are any RX delay control knobs
> > > available, I certainly don't have the datasheet, and Martin's change
> > > looks and looked reasonable, seemingly independent of the direction of
> > > this very conversation we are having.
the changes in patch 1 are looking good to me (except that I would use
phy_modify_paged instead of open-coding it, functionally it's
identical with what you have already)

I'm not sure about patch 2:
personally I would wait for someone to come up with the requirement to
use RGMII_RXID with a RTL8211F PHY.
that person will then a board to test the changes and (hopefully) a
datasheet to explain the RX delay situation with that PHY.
that way we only change the RGMII_RXID behavior once (when someone
requests support for it) instead of twice (now with your change, later
on when someone needs RGMII_RXID support in the RTL8211F driver)

that said, the change in patch 2 itself looks fine on Amlogic boards
(because all upstream .dts let the MAC generate the TX delay). I
haven't runtime-tested your patch there yet.
but there seem to be other boards (than the Amlogic ones, the RTL8211F
PHY driver discussion in u-boot was not related to an Amlogic board)
out there with a RTL8211F PHY (these may or may not be supported in
mainline Linux or u-boot and may or may not use RGMII_RXID where you
are now changing the behavior). that's not a problem by itself, but
you should be aware of this.

[...]
> rtl8211(e|f) TX/RX delays can be configured either by external pins
> strapping or via software registers. This is one of the clue to provide
> a proper config_init method code. But not all rtl8211f phys provide
> that software register, and if they do it only concerns TX-delay (as we
> aware of). So we need to take this into account when creating the updated
> versions of these functions.
>
> (Martin, I also Cc'ed you in this discussion, so if you have anything to
> say in this matter, please don't hesitate to comment.)
Amlogic boards, such as the Hardkernel Odroid-C1 and Odroid-C2 as well
as the Khadas VIM2 use a "RTL8211F" RGMII PHY. I don't know whether
there are multiple versions of this PHY. all RTL8211F I have seen so
far did behave exactly the same.

I also don't know whether the RX delay is configurable (by pin
strapping or some register) on RTL8211F PHYs because I don't have
access to the datasheet.


Martin
