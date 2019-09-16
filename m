Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEAA0B3DD0
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 17:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbfIPPkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 11:40:36 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:37038 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728417AbfIPPkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 11:40:36 -0400
Received: by mail-oi1-f196.google.com with SMTP id i16so145159oie.4
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 08:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GXt9FHdYjj64swWt0A9OdBivfzzsGtFOitYr/LtgGtw=;
        b=ROtlbF12InB0dH3fAYktHPVFWTtXGXtJhbBj/2AsfMxcr5JgrDg+VOrEb0MNvmWiTF
         /Q3qjWSVXkEhy0wuL57xFhpEBzTP6ijpTZegUg5dMxDWRVQGyne7W17y/x0m7L5vPxcv
         4sELP3D+DO6WfqKIX6XhsMwKYmTD1CHK8uoaYasPN/feqbUO5N2HvnHPimLShDcdqReO
         QzlZ1ndUM5Q+CnHurWvkR9hrCPH/fD9KgGz1U5fOoE8+0yaDwZWrVc5uehEwNS4EVt86
         8qX+iWO16jA8LnavX/XICTkxk5MgiKQXitbHoOffB46Z7WMERd07CFFhserhMqyVlEg9
         9KMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GXt9FHdYjj64swWt0A9OdBivfzzsGtFOitYr/LtgGtw=;
        b=DZO9xbh/tdKgBUuRnG/fqi81/Mg2lDSO78HM9syaGjOIQl+uGFEVjz5C7HtxjIbxlR
         yLmPqvu0/N7IGgXKAGkDqYRvVaVRUEsbvOK4TYGvo6piXjBybSdGoW81szs+HTNxphzs
         bkxmVDXTOktoXXWBsVsx6iFZIwzPbx2bvt3/4cqfLs8lA69Ncz6ALaz2JlGMMAQfr6ma
         pGqp5UCasRNk1zbYWz4o30MEtsVmIf65s0IewegK2Btl/JI1HS+CsseYuwYm2ArnbeS3
         MHE3MxawVwtEE6Cu0TsSe0S1kyItD8bmdQK3ydkvwl5jC1TzXRXMFKAIplcfU7deHqk8
         88mw==
X-Gm-Message-State: APjAAAXrkn5TNZMl7xr+MrUHsZLHdM6VsTQuf0CyeguDL42wdpbbO+kc
        0Jy00CfKi/hdfvTUlz7oXDRCjrlZGyqhs7flvA==
X-Google-Smtp-Source: APXvYqxo7O4mur3PCuR1A2pZGUSlKd65vJnKj9Vl1enxQsatq1xO8rbybHugwjcSVorOfHohKbv3bE0j2IBnF+zqIr8=
X-Received: by 2002:a05:6808:302:: with SMTP id i2mr182792oie.176.1568648435462;
 Mon, 16 Sep 2019 08:40:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAFSKS=NmM9bPb0R_zoFN+9AuG=x6DUffTNXpLSNRAHuZz4ki-g@mail.gmail.com>
 <6cd331e5-4e50-d061-439a-f97417645497@gmail.com> <20190914084856.GD13294@shell.armlinux.org.uk>
In-Reply-To: <20190914084856.GD13294@shell.armlinux.org.uk>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 16 Sep 2019 10:40:24 -0500
Message-ID: <CAFSKS=MW=0wrpdt-1n3G6KHeu0HTK8jEsEYvyA++h_7kvp+9Cw@mail.gmail.com>
Subject: Re: SFP support with RGMII MAC via RGMII to SERDES/SGMII PHY?
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 14, 2019 at 3:49 AM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Fri, Sep 13, 2019 at 08:31:18PM -0700, Florian Fainelli wrote:
> > +Russell, Andrew, Heiner,
> >
> > On 9/13/2019 9:44 AM, George McCollister wrote:
> > > Every example of phylink SFP support I've seen is using an Ethernet
> > > MAC with native SGMII.
> > > Can phylink facilitate support of Fiber and Copper SFP modules
> > > connected to an RGMII MAC if all of the following are true?
> >
> > I don't think that use case has been presented before, but phylink
> > sounds like the tool that should help solve it. From your description
> > below, it sounds like all the pieces are there to support it. Is the
> > Ethernet MAC driver upstream?
>
> It has been presented, and it's something I've been trying to support
> for the last couple of years - in fact, I have patches in my tree that
> support a very similar scenario on the Macchiatobin with the 88x3310
> PHYs.
>
> > > 1) The MAC is connected via RGMII to a transceiver/PHY (such as
> > > Marvell 88E1512) which then connects to the SFP via SERDER/SGMII. If
> > > you want to see a block diagram it's the first one here:
> > > https://www.marvell.com/transceivers/assets/Alaska_88E1512-001_product_brief.pdf
>
> As mentioned above, this is no different from the Macchiatobin,
> where we have:
>
>                   .-------- RJ45
> MAC ---- 88x3310 PHY
>                   `-------- SFP+
>
> except instead of the MAC to PHY link being 10GBASE-R, it's RGMII,
> and the PHY to SFP+ link is 10GBASE-R instead of 1000BASE-X.
>
> Note that you're abusing the term "SGMII".  SGMII is a Cisco
> modification of the IEEE 802.3 1000BASE-X protocol.  Fiber SFPs
> exclusively use 1000BASE-X protocol.  However, some copper SFPs
> (with a RJ45) do use SGMII.
>
> > > 2) The 1G Ethernet driver has been converted to use phylink.
>
> This is not necessary for this scenario.  The PHY driver needs to
> be updated to know about SFP though.

Excellent, this is exactly the information I was looking for. I had
started converting the Ethernet driver to phylink but there was still
a lot of work to do and I fear there was a significant potential for
regressions. I'll abandon that and see if I can get it to work by
making similar changes to the 1G Marvell PHY driver.

I'm assuming I must set the sfp property of the PHY in DT instead of the MAC.

>
> See:
>
> http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=phy&id=ece56785ee0e9df40dc823fdc39ee74b4a7cd1c4
>
> as an example of the 88x3310 supporting a SFP+ cage.  This patch is
> also necessary:
>
> http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=phy&id=ef2d699397ca28c7f89e01cc9e5037989096a990

Perfect.

>
> and if anything is going to stand in the way of progress on this, it
> is likely to be that patch.  I'll be attempting to post these after
> the next merge window (i.o.w. probably posting them in three weeks
> time.)

Please CC me on these patches as I'll follow your lead for what I do
on the 1G Marvell PHY driver. If you don't remember, that's fine, I
understand.

>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Thanks,
George
