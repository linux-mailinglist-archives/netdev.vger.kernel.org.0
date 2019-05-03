Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 267C313322
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 19:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfECR3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 13:29:35 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40000 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbfECR3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 13:29:35 -0400
Received: by mail-ot1-f66.google.com with SMTP id w6so5992908otl.7;
        Fri, 03 May 2019 10:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fs+EFpB44vl9L8MXB9GUsGanJ/o9Rm0lulJHNWYqDtU=;
        b=HUKXNtEmS7fH2FT5jOqZEgXGt/0Ba/6lnmBjYrDU0cT+AynIB29qyBuGpwiKTB95AN
         Ft3wXWo/A50RiNAZXTohtaFQtCDqYv0NGe9Vp2bVD/Sd9UTMF28m/NfHe9cqwypS+dCK
         s8UFeJMP8fTdxbXDJK4RE+VxeRY9mSQrDYG6gM739tX3rzQPmG11cauuQzW5/73vZHfM
         km+FtoeAxFFPA0nmVUhDgjTvcyNTQwECT6FJ+2HuVd661+46BCrPnKQTEmf+TEwPRvkS
         /MruVOIvi2ko8Ja2TN3fLi8o4J/Mwef/4ZIQcTeEwTz8l2Zg2HQna2nfJIjXuXyv4/vy
         JM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fs+EFpB44vl9L8MXB9GUsGanJ/o9Rm0lulJHNWYqDtU=;
        b=j38DBGJoZcxenP5Tybt/RobTQ6favlkbiuyM0qgAkCcGIBReg1VNwZkDoxE+4kfYEh
         n4a+Tnr52N1L34icEhwYW5tTvSMPwPYCYhcdilCVOurojkYkk18Q+5Yvb4N0YOSBKut1
         PKs1NYIC1vtnQe+bN650PEdXAY/sg7HLKhNBQgQ1Smnw9l7FLWu2ZwG6Rf2CyDNucu+h
         +fi6ZPpt8MGp7UIVRKzPrYbxPAJ1E0Q6esPA1zM3o0ddRvQs8Ob0gIyj2ZIlo6TJRP8F
         c6decJz9pJeOt6YMvsQWjbJ0P7swsItfNASy5KsnyFdrU6R9lY1LLTIxGj9p/LqW259/
         8whA==
X-Gm-Message-State: APjAAAWlBSaGqk2KRwFpuvxSfUhayjQW2q1IpW7JlvldQuZz/b47OCDX
        828EYyb2EB0ZdruWUVDQpKJFgqb7PawB8p6KsLE=
X-Google-Smtp-Source: APXvYqzr/dqPjv2/To1QgLY8WQlGgA+UlEyvtPnIkSRX7nV25j8R07+SmzU14kDO+mQzarAgMawaXfYFV/aSKAKcnjA=
X-Received: by 2002:a9d:5504:: with SMTP id l4mr7523118oth.131.1556904573987;
 Fri, 03 May 2019 10:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190426212112.5624-1-fancer.lancer@gmail.com>
 <20190426212112.5624-2-fancer.lancer@gmail.com> <20190426214631.GV4041@lunn.ch>
 <20190426233511.qnkgz75ag7axt5lp@mobilestation> <f27df721-47aa-a708-aaee-69be53def814@gmail.com>
 <CA+h21hpTRCrD=FxDr=ihDPr+Pdhu6hXT3xcKs47-NZZZ3D9zyg@mail.gmail.com>
 <20190429211225.ce7cspqwvlhwdxv6@mobilestation> <CAFBinCBxgMr6ZkOSGfXZ9VwJML=GnzrL+FSo5jMpN27L2o5+JA@mail.gmail.com>
 <CA+h21hq_4rMXaOgr4ZQjiwwvpKSZmRoTg__PZisWZCz3pzCPOA@mail.gmail.com>
In-Reply-To: <CA+h21hq_4rMXaOgr4ZQjiwwvpKSZmRoTg__PZisWZCz3pzCPOA@mail.gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 3 May 2019 19:29:22 +0200
Message-ID: <CAFBinCAzK7KqprjUTK9hMxPVHu3ZYWg1AX=1jp+dwKLh02sr_g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: phy: realtek: Change TX-delay setting for
 RGMII modes only
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
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

Hi Vladimir,

On Thu, May 2, 2019 at 1:03 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Wed, 1 May 2019 at 00:16, Martin Blumenstingl
> <martin.blumenstingl@googlemail.com> wrote:
> >
> >  Hello Serge,
> >
> > On Mon, Apr 29, 2019 at 11:12 PM Serge Semin <fancer.lancer@gmail.com> wrote:
> > [...]
> > > > > > Apparently the current config_init method doesn't support RXID setting.
> > > > > > The patch introduced current function code was submitted by
> > > > > > Martin Blumenstingl in 2016:
> > > > > > https://patchwork.kernel.org/patch/9447581/
> > > > > > and was reviewed by Florian. So we'd better ask him why it was ok to mark
> > > > > > the RGMII_ID as supported while only TX-delay could be set.
> > > > > > I also failed to find anything regarding programmatic rtl8211f delays setting
> > > > > > in the Internet. So at this point we can set TX-delay only for f-model of the PHY.
> > let me give you a bit of context on that patch:
> > most boards (SBCs and TV boxes) with an Amlogic SoC and a Gigabit
> > Ethernet PHY use a Realtek RTL8211F PHY. we were seeing high packet
> > loss when transmitting from the board to another device.
> > it took us very long to understand that a combination of different
> > hardware and driver pieces lead to this issue:
> > - in the MAC driver we enabled a 2ns TX delay by default, like Amlogic
> > does it in their vendor (BSP) kernel
> > - we used the upstream Realtek RTL8211F PHY driver which only enabled
> > the TX delay if requested (it never disabled the TX delay)
> > - hardware defaults or pin strapping of the Realtek RTL8211F PHY
> > enabled the TX delay in the PHY
> >
> > This means that the TX delay was applied twice: once at the MAC and
> > once at the PHY.
> > That lead to high packet loss when transmitting data.
> > To solve that I wrote the patch you mentioned, which has since been
> > ported over to u-boot (for a non-Amlogic related board)
> >
> > > > > > Anyway lets clarify the situation before to proceed further. You are suggesting
> > > > > > to return an error in case if either RGMII_ID or RGMII_RXID interface mode is
> > > > > > requested to be enabled for the PHY. It's fair seeing the driver can't fully
> > > > > > support either of them.
> > I don't have any datasheet for the Realtek RTL8211F PHY and I'm not in
> > the position to get one (company contracts seem to be required for
> > this).
> > Linux is not my main job, I do driver development in my spare time.
> >
> > there may or may not be a register or pin strapping to configure the RX delay.
> > due to this I decided to leave the RX delay behavior "not defined"
> > instead of rejecting RGMII_RXID and RGMII_ID.
> >
> > > > > That is how I read Andrew's suggestion and it is reasonable. WRT to the
> > > > > original changes from Martin, he is probably the one you would want to
> > > > > add to this conversation in case there are any RX delay control knobs
> > > > > available, I certainly don't have the datasheet, and Martin's change
> > > > > looks and looked reasonable, seemingly independent of the direction of
> > > > > this very conversation we are having.
> > the changes in patch 1 are looking good to me (except that I would use
> > phy_modify_paged instead of open-coding it, functionally it's
> > identical with what you have already)
> >
> > I'm not sure about patch 2:
> > personally I would wait for someone to come up with the requirement to
> > use RGMII_RXID with a RTL8211F PHY.
> > that person will then a board to test the changes and (hopefully) a
> > datasheet to explain the RX delay situation with that PHY.
> > that way we only change the RGMII_RXID behavior once (when someone
> > requests support for it) instead of twice (now with your change, later
> > on when someone needs RGMII_RXID support in the RTL8211F driver)
> >
> > that said, the change in patch 2 itself looks fine on Amlogic boards
> > (because all upstream .dts let the MAC generate the TX delay). I
> > haven't runtime-tested your patch there yet.
> > but there seem to be other boards (than the Amlogic ones, the RTL8211F
> > PHY driver discussion in u-boot was not related to an Amlogic board)
> > out there with a RTL8211F PHY (these may or may not be supported in
> > mainline Linux or u-boot and may or may not use RGMII_RXID where you
> > are now changing the behavior). that's not a problem by itself, but
> > you should be aware of this.
> >
> > [...]
> > > rtl8211(e|f) TX/RX delays can be configured either by external pins
> > > strapping or via software registers. This is one of the clue to provide
> > > a proper config_init method code. But not all rtl8211f phys provide
> > > that software register, and if they do it only concerns TX-delay (as we
> > > aware of). So we need to take this into account when creating the updated
> > > versions of these functions.
> > >
> > > (Martin, I also Cc'ed you in this discussion, so if you have anything to
> > > say in this matter, please don't hesitate to comment.)
> > Amlogic boards, such as the Hardkernel Odroid-C1 and Odroid-C2 as well
> > as the Khadas VIM2 use a "RTL8211F" RGMII PHY. I don't know whether
> > there are multiple versions of this PHY. all RTL8211F I have seen so
> > far did behave exactly the same.
> >
> > I also don't know whether the RX delay is configurable (by pin
> > strapping or some register) on RTL8211F PHYs because I don't have
> > access to the datasheet.
> >
> >
> > Martin
>
> Hi Martin, Sergey,
>
> I had another look and it seems that Realtek has designated the same
> PHY ID for the RTL8211F and RTL8211FS. However the F is a 40-pin
> package and the FS is a 48-pin package. The datasheet for the F
> doesn't mention about the MDIO bit for TXDLY being implemented,
> whereas for FS it does. That can mean anything, really, but as I only
> have access to a board with the FS chip, I can't easily check. Maybe
> Martin can confirm that his chip's designation is really not FS.
I just checked two of my boards:
- the PHY on my Hardkernel Odroid-C1+ is marked as "RTL8211F"
- the PHY on my Khadas VIM2 is marked as "RTL8211FDI"

I have not heard of a RTL8211FS chip / package before.

> But my point still remains, though. The F and FS share the same PHY
> ID, and one supports only RGMII while the other can be configured for
> SGMII as well. Good luck being ultra-correct in the phy-mode checking
> when you can't distinguish the chip. But in general DT description is
> chief and should not be contradicted. Perhaps an argument could be
> made for the RGMII delays as they constitute an exception to the "HW
> description" rule.
PHY ID being shared across various PHY revisions and packages is also
the case for some ICPlus IP101A / IP101G PHYs, see [0]
The (32-pin QFN) IP101GR uses a register to switch a pin function
between "interrupt" and "receive error".
There's no rule in the driver to enforce that this only applies to
IP101GR PHYs, it's only described in the documentation (I don't even
know if we can enforce it in software because I'm not sure we can
detect the different variants of the IP101A / IP101G PHYs)


Martin


[0] https://github.com/torvalds/linux/blob/fdc13a9effd5359ae00705708c8c846b1cb2b69c/Documentation/devicetree/bindings/net/icplus-ip101ag.txt
