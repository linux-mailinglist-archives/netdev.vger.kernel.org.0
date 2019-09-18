Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC0A1B6AC5
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 20:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731191AbfIRSoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 14:44:46 -0400
Received: from mail-oi1-f178.google.com ([209.85.167.178]:34963 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbfIRSoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 14:44:46 -0400
Received: by mail-oi1-f178.google.com with SMTP id x3so537895oig.2
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 11:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XZSFgFJFMwVr2A71bQm2QOjoskHVBT36BOdr4B6xZ2g=;
        b=RmqY3fdLFJPE0xFOAuHSf09F8Wsa3DjB0Yp1hRHVcy+z34Z04NB66StG1GCCj4UHF0
         fM5HUhVfEbADmudOh+XdVzaZgtTop6soCw7G2sw8B/qKusaWJIGcvkR7Ae/GixiYikzs
         5GVqeT0WE//5Gv7E/ktvjWCALNRDNNaNgUmr6YTW6c9q6XnwJH0EHNbYcUf6XIUqtHCS
         J+52d1ydP1YulVn1ncR9LFjItMXob3Ia04A9K7AESFHl6zZO4ibeAQL0Du5nCu0Qdx9o
         XATgL8Mw5Fo1mxFmkAMqgUi98RCMTKpcmGr8RbjDRyxVHjDnYDYCJkvLYtIspykLIYwX
         bTtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XZSFgFJFMwVr2A71bQm2QOjoskHVBT36BOdr4B6xZ2g=;
        b=en7ANTrnpTqGhIyvEjvmn4y441oHdc80U8yvj/T1kuml3BXSO7w+obVpaZ/2aoP+Mv
         qfImfIvDtgSx4wEycbeUShxzI6VkVrE87KAN0n3/Zp41Tfa6IVTt910WBDHC7jYPKICa
         rfZi6HOSZXTlaJjpPxEJQos++/8I8zpnbDqXO1jIYBv7HhDeK1PUTYEHCtF+oTl7IoeQ
         Ey8CK3zGQPfF9euWszq19IENV9KVUZeKvE6VE2aYknrzyiV216du4kHMxTOfBSaczxKQ
         iVleVy+bdYEoHqyHA6jwxd7hipsFIYdAL/Ons9W+u9/PSxSyukTNgqANfE88qN3YRt5g
         YN0g==
X-Gm-Message-State: APjAAAUaSITN3mVN0MPNwtfe2yFiqn11N2KFFSfQeUZK4+2EkUuyIHNB
        ON/qNJq4zZX8wNk0B/DY4G2l7MdurdnMRviw9A==
X-Google-Smtp-Source: APXvYqz1sjKQbfCEE0uvccKU9xfNKCBLVyGhRYRTpWeiNgcJHMLZ6opq/xQiuKLQcCsUINuG/xj4XtYsObXeUHXGJ34=
X-Received: by 2002:aca:52cd:: with SMTP id g196mr3309628oib.163.1568832284670;
 Wed, 18 Sep 2019 11:44:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAFSKS=NmM9bPb0R_zoFN+9AuG=x6DUffTNXpLSNRAHuZz4ki-g@mail.gmail.com>
 <6cd331e5-4e50-d061-439a-f97417645497@gmail.com> <20190914084856.GD13294@shell.armlinux.org.uk>
 <CAFSKS=MW=0wrpdt-1n3G6KHeu0HTK8jEsEYvyA++h_7kvp+9Cw@mail.gmail.com>
In-Reply-To: <CAFSKS=MW=0wrpdt-1n3G6KHeu0HTK8jEsEYvyA++h_7kvp+9Cw@mail.gmail.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Wed, 18 Sep 2019 13:44:33 -0500
Message-ID: <CAFSKS=N_SF-S35eL=tLWOQFKiq7YKKY5B9YT6kxZc0usBayE7w@mail.gmail.com>
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

Russell,

On Mon, Sep 16, 2019 at 10:40 AM George McCollister
<george.mccollister@gmail.com> wrote:
>
> On Sat, Sep 14, 2019 at 3:49 AM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Fri, Sep 13, 2019 at 08:31:18PM -0700, Florian Fainelli wrote:
> > > +Russell, Andrew, Heiner,
> > >
> > > On 9/13/2019 9:44 AM, George McCollister wrote:
> > > > Every example of phylink SFP support I've seen is using an Ethernet
> > > > MAC with native SGMII.
> > > > Can phylink facilitate support of Fiber and Copper SFP modules
> > > > connected to an RGMII MAC if all of the following are true?
> > >
> > > I don't think that use case has been presented before, but phylink
> > > sounds like the tool that should help solve it. From your description
> > > below, it sounds like all the pieces are there to support it. Is the
> > > Ethernet MAC driver upstream?
> >
> > It has been presented, and it's something I've been trying to support
> > for the last couple of years - in fact, I have patches in my tree that
> > support a very similar scenario on the Macchiatobin with the 88x3310
> > PHYs.
> >
> > > > 1) The MAC is connected via RGMII to a transceiver/PHY (such as
> > > > Marvell 88E1512) which then connects to the SFP via SERDER/SGMII. If
> > > > you want to see a block diagram it's the first one here:
> > > > https://www.marvell.com/transceivers/assets/Alaska_88E1512-001_product_brief.pdf
> >
> > As mentioned above, this is no different from the Macchiatobin,
> > where we have:
> >
> >                   .-------- RJ45
> > MAC ---- 88x3310 PHY
> >                   `-------- SFP+
> >
> > except instead of the MAC to PHY link being 10GBASE-R, it's RGMII,
> > and the PHY to SFP+ link is 10GBASE-R instead of 1000BASE-X.

Did you test with an SFP+ module that has a PHY?

In my setup, nothing connects/attaches to the PHY (88E1111) in the
RJ45 SFP module I'm testing with (is this intended?). Apparently since
sfp_upstream_ops in the PHY driver used for the first PHY doesn't
provide a .connect_phy. This leaves .phy_link_change NULL. Eventually
phy_link_down tries to call .phy_link_change resulting in a NULL
pointer deference OOPs. If phy_link_change doesn't need to be called
for the second PHY I can just send a patch that doesn't call it if
it's NULL.

This is what I did:

I applied the following on top of net-next:
net: sfp: move fwnode parsing into sfp-bus layer
net: phy: provide phy driver start/stop hooks
net: phy: add core phylib sfp support

I then added SFP support to the marvell.c PHY driver like you did to
marvell10g.c. Just like with marvell10g.c I only provide .attach,
.detach and .module_insert sfp_upstream_ops.

I moved the sfp property from my Ethernet MAC to the PHY in DT (my DT
is a WIP and not upstream):
                ethphy1: ethernet-phy@1 {
                        reg = <1>;
+                       sfp = <&sfp>;
                };

Here is the console output, I've added some prints for debugging:

[    1.867336] sfp sfp: sfp_probe
[    1.870462] sfp sfp: sfp_probe - of_node
[    1.874520] libphy: SFP I2C Bus: probed
[    1.880290] sfp sfp: Host maximum power 2.0W
[    1.886681] sfp sfp: No tx_disable pin: SFP modules will always be emitting.
[    1.893771] sfp sfp: sfp_probe - returning 0
[    1.898392] libphy: Fixed MDIO Bus: probed
[    1.909454] fec 2188000.ethernet: Invalid MAC address: 00:00:00:00:00:00
[    1.916208] fec 2188000.ethernet: Using random MAC address: 62:2f:f1:55:56:dc
[    1.924075] libphy: fec_enet_mii_bus: probed
[    1.935382] libphy: phy_probe
[    1.938484] Marvell 88E1510 2188000.ethernet-1:00: marvell_probe
[    1.944561] Marvell 88E1510 2188000.ethernet-1:00: marvell_probe have fwnode
[    1.951688] sfp_register_upstream_node
[    1.955500] Marvell 88E1510 2188000.ethernet-1:00: sfp_bus = 00000000
[    1.968648] libphy: phy_probe
[    1.971745] Marvell 88E1510 2188000.ethernet-1:01: marvell_probe
[    1.977828] Marvell 88E1510 2188000.ethernet-1:01: marvell_probe have fwnode
[    1.984953] sfp_register_upstream_node
[    1.988895] sfp sfp: SM: enter empty:down:down event insert
[    1.994536] sfp sfp: SM: attached
[    1.997915] Marvell 88E1510 2188000.ethernet-1:01: marvell_sfp_attach
[    2.004415] Marvell 88E1510 2188000.ethernet-1:01: sfp_bus = de0ca240
[    2.012185] fec 2188000.ethernet eth0: registered PHC device 0
[    2.024656] fec 21b4000.ethernet: Invalid MAC address: 00:00:00:00:00:00
[    2.031461] fec 21b4000.ethernet: Using random MAC address: ce:e8:ce:0a:4e:3c
[    2.246517] libphy: fec_enet_mii_bus: probed
[    2.251440] fec 21b4000.ethernet eth1: registered PHC device 1
[    2.357150] sfp sfp: module OEM              SFP-GE-T         rev
   sn CSGETJ53492      dc 19050101
[    2.366568] Marvell 88E1510 2188000.ethernet-1:01: marvell_sfp_insert
[    2.373093] sfp sfp: Unknown/unsupported extended compliance code: 0x01

# ifconfig eth1 192.168.0.1
[   70.011960] libphy: phy_connect_direct
[   70.015830] Marvell 88E1510 2188000.ethernet-1:01: phy_attach_direct
[   70.025315] Marvell 88E1510 2188000.ethernet-1:01: marvell_config_init
[   70.034271] libphy: phy_resume
[   70.037955] Marvell 88E1510 2188000.ethernet-1:01: attached PHY
driver [Marvell 88E1510] (mii_bus:phy_addr=2188000.ethernet-1:01,
irq=POLL)
[   70.050591] Marvell 88E1510 2188000.ethernet-1:01: phy_start
[   70.060101] sfp sfp: SM: enter present:down:down event dev_up
[   70.131133] libphy: phy_probe
[   70.139706] Marvell 88E1111 i2c:sfp:16: marvell_probe
[   70.155806] Marvell 88E1111 i2c:sfp:16: sfp_add_phy - didnt call
connect_phy, ops = c0a4ca10
[   70.172962] sfp sfp: sfp_sm_probe_phy - calling phy_start
[   70.183163] Marvell 88E1111 i2c:sfp:16: phy_start
[   70.190973] Marvell 88E1111 i2c:sfp:16: phy_state_machine state = UP
[   70.197994] Marvell 88E1510 2188000.ethernet-1:01:
phy_state_machine state = UP
[   70.213607] Marvell 88E1510 2188000.ethernet-1:01: phy_start_aneg -
state = UP
[   70.225367] Marvell 88E1510 2188000.ethernet-1:01: phy_link_down -
calling phy_link_change
[   70.233864] Marvell 88E1510 2188000.ethernet-1:01: phy_link_change
[   70.243735] Marvell 88E1510 2188000.ethernet-1:01: PHY state change
UP -> NOLINK
[   70.251805] Marvell 88E1111 i2c:sfp:16: phy_start_aneg - state = UP
[   70.266411] Marvell 88E1111 i2c:sfp:16: phy_link_down -
phy_link_change is NULL and would be called !!!!!!!!!!!!!

It would have attempted to call the NULL .phy_link_change here but I
added a check to prevent it.

When I plug in the RJ45 cable it comes up and I'm able to ping.
[   88.282725] Marvell 88E1510 2188000.ethernet-1:01: phy_link_up -
calling phy_link_change
[   88.294628] Marvell 88E1510 2188000.ethernet-1:01: phy_link_change
[   88.303103] fec 21b4000.ethernet eth1: Link is Up - 1Gbps/Full -
flow control off
[   88.312487] Marvell 88E1510 2188000.ethernet-1:01: PHY state change
NOLINK -> RUNNING
[   88.338803] Marvell 88E1111 i2c:sfp:16: phy_state_machine state = NOLINK
[   89.364015] Marvell 88E1111 i2c:sfp:16: phy_state_machine state = NOLINK
[   89.372943] Marvell 88E1510 2188000.ethernet-1:01:
phy_state_machine state = RUNNING
[   89.386467] Marvell 88E1111 i2c:sfp:16: phy_link_up -
phy_link_change is NULL and would be called !!!!!!!!!!!!!!!

It would have attempted to call the NULL .phy_link_change again here too.

[   89.394896] Marvell 88E1111 i2c:sfp:16: PHY state change NOLINK -> RUNNING

> >
> > Note that you're abusing the term "SGMII".  SGMII is a Cisco
> > modification of the IEEE 802.3 1000BASE-X protocol.  Fiber SFPs
> > exclusively use 1000BASE-X protocol.  However, some copper SFPs
> > (with a RJ45) do use SGMII.
> >
> > > > 2) The 1G Ethernet driver has been converted to use phylink.
> >
> > This is not necessary for this scenario.  The PHY driver needs to
> > be updated to know about SFP though.
>
> Excellent, this is exactly the information I was looking for. I had
> started converting the Ethernet driver to phylink but there was still
> a lot of work to do and I fear there was a significant potential for
> regressions. I'll abandon that and see if I can get it to work by
> making similar changes to the 1G Marvell PHY driver.
>
> I'm assuming I must set the sfp property of the PHY in DT instead of the MAC.
>
> >
> > See:
> >
> > http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=phy&id=ece56785ee0e9df40dc823fdc39ee74b4a7cd1c4
> >
> > as an example of the 88x3310 supporting a SFP+ cage.  This patch is
> > also necessary:
> >
> > http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=phy&id=ef2d699397ca28c7f89e01cc9e5037989096a990
>
> Perfect.
>
> >
> > and if anything is going to stand in the way of progress on this, it
> > is likely to be that patch.  I'll be attempting to post these after
> > the next merge window (i.o.w. probably posting them in three weeks
> > time.)
>
> Please CC me on these patches as I'll follow your lead for what I do
> on the 1G Marvell PHY driver. If you don't remember, that's fine, I
> understand.
>
> >
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> > According to speedtest.net: 11.9Mbps down 500kbps up
>
> Thanks,
> George

Regards,
George
