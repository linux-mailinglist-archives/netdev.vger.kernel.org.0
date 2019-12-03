Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6670610F7B7
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 07:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfLCGTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 01:19:37 -0500
Received: from mail-qk1-f179.google.com ([209.85.222.179]:44303 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfLCGTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 01:19:37 -0500
Received: by mail-qk1-f179.google.com with SMTP id i18so2313690qkl.11
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 22:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PsQEtskFOB3WD8tJuehKt8qdWrKKcZtWqIFG6S94mOc=;
        b=Eo0mLPvq7UqDkTPOnc7b+56Fg7sT8J0r+IT4d9j21nD4KK14QMj0imP04mN5sCNOBU
         JeSrG72jxzfZP6VRAC77zYJL99IJ/HwAdBi0m5uJbTTq5l9nAl/NO9M04rWfOtgSY+2f
         h9je4Si9Eo9mHZoIMCIbC5PVXY1rvA633CcJHM6VDnxd4o5wlWiTfwL8922vd84NHexl
         Vhvq0r4ESVvfwFj/HDvkh6jwJaj9dfxY8g/9y4+iVrmPaj/hBX3n2hB/QQ+iePIsC/Ih
         ONhYfdhhuiM0P25kc/JFxyL5qmiG6kppyVvK5nnqjxW+JcWFOEAo/+NhzierUJdes650
         rfKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PsQEtskFOB3WD8tJuehKt8qdWrKKcZtWqIFG6S94mOc=;
        b=XtrS3ugaI97tuRA9GCR5/a2+d/XVXIfmJ4CKKPJOD8BfPvOMM5WZOmhDzBvps4JVpm
         p1TeKcfu7yUpH9DWelkfF40w/VvqyRSU4OfPPBNsFJZDK9Sea+eJ4jh0vj/NgTCEsiKX
         sSBeVlmOOlRy6GyYqkqystup5KnGV6C8wwLaeSpBA1WwxdrgrkfeH84WGbt3MURAvcsI
         dIulYt927XfBNxjc6GIscefWbBTnYlW7YpTj5AYcdvkD9MPJB2C91g7iaFkFgtPIgjgZ
         hqsLeqDbt35KzvTz8BsJiGzf8XyqAbq+rL+Hp58+s74cTOHhJlo8asMAjJ5/qsBdd1+X
         cKlQ==
X-Gm-Message-State: APjAAAVWePIlVK2oHdYbqar9Zk3AqYLrJLnYthcrlnxf5gExcRJ+GaRM
        0lVb+UceBqpLRIwFmRsIrJonf5zA2JMKCcom+7U=
X-Google-Smtp-Source: APXvYqwveyg582CaLTlsb0UkiZE0f6Ai80NBC5ighLN0lwzn+DPrwUSmAFbGFCmWrPc85ibTsQX4ZuUECn47+/BoIr8=
X-Received: by 2002:a05:620a:128c:: with SMTP id w12mr3564386qki.470.1575353976466;
 Mon, 02 Dec 2019 22:19:36 -0800 (PST)
MIME-Version: 1.0
References: <CA+ZLECteuEZJM_4gtbxiEAAKbKnJ_3UfGN4zg_m2EVxk_9=WiA@mail.gmail.com>
 <20191202134606.GA1234@lunn.ch>
In-Reply-To: <20191202134606.GA1234@lunn.ch>
From:   Sam Lewis <sam.vr.lewis@gmail.com>
Date:   Tue, 3 Dec 2019 17:19:25 +1100
Message-ID: <CA+ZLECv7AcQSa1VZeeiOFJ43Vh=nfn_ptMB6XwXsfbRSz9VJ6A@mail.gmail.com>
Subject: Re: PROBLEM: smsc95xx loses config on link down/up
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Dec 2019 at 00:46, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Nov 28, 2019 at 06:19:14PM +1100, Sam Lewis wrote:
> > I'm using a LAN9514 chip in my embedded Linux device and have noticed
> > that changing Ethernet configuration (with ethtool for example) does
> > not persist after putting the link up.
>
> Hi Sam
>
> Did you ever get a reply to this?
>

Hi Andrew - I hadn't, but I understand that it's a quiet time of year.
:) Thanks for getting back to me!

> > I've hacked through the driver code (without really knowing what I'm
> > doing, just adding various print statements) and I think this happens
> > because setting a link up causes the `smsc95xx_reset` function to be
> > called which seems to clear all configuration through:
> >
> > 1) Doing a PHY reset (with `smsc95xx_write_reg(dev, PM_CTRL, PM_CTL_PHY_RST_)`)
> > 2) Doing (another?) PHY reset (with `smsc95xx_mdio_write(dev->net,
> > dev->mii.phy_id, MII_BMCR, BMCR_RESET)`)
>
> In general, BMCR_RESET does not clear configuration registers such as
> auto-neg etc. It generally just gives the PHY a kick to restart itself
> using the configuration as set. So i would initially point a finger at
> PM_CTL_PHY_RST_.
>
> Is there a full datasheet somewhere?
>
> You might want to think about using PM_CTL_PHY_RST_ once during probe,
> and only BMCR_RESET in open.
>

Thanks, doing the PM_CTL_PHY_RST_ reset only during probing does sound
a good (& necessary) fix but it unfortunately doesn't look like it'll
get it all the way there.

I managed to track down the datasheet for the PHY, available here:
http://ww1.microchip.com/downloads/en//softwarelibrary/man-lan95xx-dat/lan9514_lan9514i%20databook%20rev.%201.2%20(03-01-12).pdf

Basically it looks as though doing a BMCR_RESET does, in fact, reset
every PHY R/W register bit except for those marked as "Not Affected by
Software Reset" (NASR). This means it will reset, to the default
value:

- Autonegotiation
- Speed
- Duplex
- Auto MDIX
- Energy Detect Power-Down
- Auto Negotiation Advertisement
- PHY Identification (although I don't know why you'd change this?)
- Power down
- Loopback

I tested this by checking the value of the BMCR register before and
after doing a BMCR_RESET and it did reset the BMCR register to its
default values.

The PHY does provide a NASR "Special Modes Register" which effectively
allows you to set 'default' values for the duplex, speed and autoneg
that are applied after a BMCR_RESET. See page 205 of the datasheet for
more details. Setting this to 0x0061 allowed me to set the PHY to be
full duplex, 100M and no autoneg on after a BMCR_RESET, for example.

However, given that the Special Modes register only allows saving a
subset of settings it perhaps isn't the best solution? (Auto MDIX is
something else I'd like to set differently to the default value in my
application and I imagine the other settings probably shouldn't be
lost either). The only other fix that I can think of is to save all
the PHY R/W registers before doing a BMCR_RESET and then restoring
them after the reset. Would this be an acceptable solution?

I do have to ask though - is it strictly necessary to do the
BMCR_RESET (& the PHY initialisation) every time on link up/open? What
is the reasoning behind doing it? Excuse my ignorance on this if it's
a dumb question! If it was only done on probing, it would make this
easier (well, easier for me at least :)).

Interested to know what you think - I'm still keen on seeing if I can
make a generic patch for this. I think I know enough now that I can
hack together a patch that'll work for my particular application, but
it would be cool to upstream something that will benefit everyone.

Sam
