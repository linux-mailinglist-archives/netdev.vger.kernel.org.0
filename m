Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCDAC0E3C
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 01:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbfI0XA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 19:00:57 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39144 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728305AbfI0XA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 19:00:57 -0400
Received: by mail-qk1-f195.google.com with SMTP id 4so3315525qki.6
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 16:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BeIekf8tah3xajcMSgUyVuI3R+P20kz8tpmgdit+c+U=;
        b=qk7RDb8E5ZTAhVAMK+/5yRdPk2e1AVoF8ZQwfCafmaXIPX8OuhnKmJBMqpwynoU0MD
         R37ULDktRXPeU9mRx0mqrI+VUsk2abvfp5OoUnkFC+aUv+1LjXhKPbBgcH0VNAKP41dC
         wuMFBaGEhYNjpHPMO61mLvfpjEMYfWt29vq0G/jVKtyB1CA6gKL3vp4lvJkfQu1UBk1G
         zKvvCNbzXgKyMELTGObHwBht4ux4QzWNTR2gTbmoPnFz5rXnAQphW6hAO82KSQMPv2dh
         89k4NEIVTRzepRF/2ofvq/5lberyLjYpLNCL7g1BDBJ2Rb4q0vnwZzma4JCheSGK33Xp
         Bfdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BeIekf8tah3xajcMSgUyVuI3R+P20kz8tpmgdit+c+U=;
        b=pK+7GFLbd5HFPTD6gQeI3rCFbYbbg5oFwxJPgnFaTTv1CAxnrEQWUvFvSEmBwKF23e
         W5+0YZYbI/vVU4YUFap7XhZiFvZoCu9t5TVoqGoHEHRbzcedRKgPnz5Lc5HiD+1IaH0W
         3/+TGBzMmpQsAVHkvptxUUMgUHYpCX28jfQCfh1QCflbWG+M3YSbZFawFUDnqxVhFBGB
         Vp3jJqJubftMQdRkNDcrwqSAxmw9m2ANgrnFSqNM4aHWXJQGKOFY8Qs77IP/9kyIgKjw
         Kp+rUiQlBL3GfMm9aTrUSytuYeP1YG1BL4shUZTj7oYRVkdnBMG7RGHQiqsSiqrpPxCW
         c2yw==
X-Gm-Message-State: APjAAAUW6LTRURfkSQ96yxsOt+naQLPX06kcY257JS7gApGHaHp9AMpE
        YaOnofOoA1X+YIyVmnMGQljmvuaFaugakQnyCQN6BwfI8WFrTA==
X-Google-Smtp-Source: APXvYqwDzhkKPjcyEc+iAndDLO2nJvTEYFQQqFy/c0WbuRuaZkvDkFPQfa96+nwA5lpJt+XYQxH3rsrFL8nxx9Q80zQ=
X-Received: by 2002:a05:620a:147:: with SMTP id e7mr7304854qkn.227.1569625255839;
 Fri, 27 Sep 2019 16:00:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAGAf8LzeyrMSHCYMxn1FNtMQVyhhLYbJaczhe2AMj+7T_nBt7Q@mail.gmail.com>
 <20190923191713.GB28770@lunn.ch> <CAGAf8LyQpi_R-A2Zx72bJhSBqnFo-r=KCnfVCTD9N8cNNtbhrQ@mail.gmail.com>
 <20190926133810.GD20927@lunn.ch>
In-Reply-To: <20190926133810.GD20927@lunn.ch>
From:   Zoran Stojsavljevic <zoran.stojsavljevic@gmail.com>
Date:   Sat, 28 Sep 2019 01:00:43 +0200
Message-ID: <CAGAf8LxAbDK7AUueCv-2kcEG8NZApNjQ+WQ1XO89+5C-SLAbPw@mail.gmail.com>
Subject: Re: DSA driver kernel extension for dsa mv88e6190 switch
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

> You should not need any kernel patches for switch side RGMII
> delays. rgmii-id in the DT for the switch CPU port should be enough.
> Some of the vf610-zii platforms use it.

It should, but it does NOT work. IT is clearly stated in port.c, in f-n:
static int mv88e6xxx_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
                                          phy_interface_t mode)

The logic analyser shows MDIO write to register 0x01, which is 0x6003.
Seems the correct value.

But, at the very end, ethtool shows that this clock skew is NOT
inserted. I see on RX side CRC errors. Every ethernet frame while
pinging.

I see another interesting fact, the dmesg, which you could see here:
https://pastebin.com/igXS6eXe

[    1.182273] DEBUG INFO! <- addr: 0x00 reg: 0x03 val: 0x1901
[    1.187888] mv88e6085 2188000.ethernet-1:00: switch 0x1900
detected: Marvell 88E6190, revision 1
[    1.219804] random: fast init done
[    1.225334] libphy: mv88e6xxx SMI: probed
[    1.232709] fec 2188000.ethernet eth0: registered PHC device 0

[    1.547946] DEBUG INFO! <- addr: 0x00 reg: 0x03 val: 0x1901
[    1.553542] mv88e6085 2188000.ethernet-1:00: switch 0x1900
detected: Marvell 88E6190, revision 1
[    1.555432]  mmcblk1: p1
[    1.598106] libphy: mv88e6xxx SMI: probed
[    1.740362] DSA: tree 0 setup

There are two distinct accesses while driver configures the switch. Why???

I was not able to explain this to me... Or find explanation using google?!

> gpios = <&gpio1 29 GPIO_ACTIVE_HIGH>; is wrong. It probably
> should be reset-gpios. The rest looks O.K.

I will follow the advise, but I do not think this is an obstacle.

> Please show me the configuration steps you are doing? How are you
> configuring the FEC and the switch interfaces?

Forgive me for my ignorance, but I have no idea what you have asked me for?

Did you ask me to attach .config file? If not, could you, please,
explain to me more concrete, what did you ask for? Some example would
be perfect!

Thank you,
Zoran
_______

On Thu, Sep 26, 2019 at 3:39 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Sep 26, 2019 at 03:23:48PM +0200, Zoran Stojsavljevic wrote:
> > Hello Andrew,
> >
> > I would like to thank you for the reply.
> >
> > I do not know if this is the right place to post such the questions,
> > but my best guess is: yes.
> >
> > Since till now I did not make any success to make (using DSA driver)
> > make mv88e6190 single switch to work with any kernel.org. :-(
> >
> > I did ugly workaround as kernel dsa patch, which allowed me to
> > introduce TXC and RXC clock skews between I.MX6 and mv88e6190 (MAC to
> > MAC layer over rgmii).
>
> You should not need any kernel patches for switch side RGMII
> delays. rgmii-id in the DT for the switch CPU port should be enough.
> Some of the vf610-zii platforms use it.
>
> > My DTS mv88e6190 configuration, which I adopted for the custom board I
> > am working on, could be seen here:
> > https://pastebin.com/xpXQYNRX
>
> So you have the FEC using rgmii-id. Which you say does not work?  So
> why not use plain rgmii. What you have in port@0 looks correct.
>
> gpios = <&gpio1 29 GPIO_ACTIVE_HIGH>; is wrong. It probably should be
> reset-gpios. The rest looks O.K.
>
>
> > But on another note... I am wondering if I am setting correct kernel
> > configuration for it?!
> >
> > Here is the part of the configuration I made while going through maze
> > of posts from google search results:
> >
> >       Switch (and switch-ish) device support @ Networking
> > support->Networking options
> >       Distributed Switch Architecture @ Networking support->Networking options
> >       Tag driver for Marvell switches using DSA headers @ Networking
> > support->Networking options->Distributed Switch Architecture
> >       Tag driver for Marvell switches using EtherType DSA headers @
> > Networking support->Networking options->Distributed Switch
> > Architecture
> >       Marvell 88E6xxx Ethernet switch fabric support @ Device
> > Drivers->Network device support->Distributed Switch Architecture
> > drivers
> >       Switch Global 2 Registers support @ Device Drivers->Network
> > device support->Distributed Switch Architecture drivers->Marvell
> > 88E6xxx Ethernet switch fabric support
> >       Freescale devices @ Device Drivers->Network device
> > support->Ethernet driver support
> >       FEC ethernet controller (of ColdFire and some i.MX CPUs) @
> > Device Drivers->Network device support->Ethernet driver
> > support->Freescale devices
> >       Marvell devices @ Device Drivers->Network device
> > support->Ethernet driver support
> >       Marvell MDIO interface support @ Device Drivers->Network device
> > support->Ethernet driver support->Marvell devices
> >       MDIO Bus/PHY emulation with fixed speed/link PHYs @ Device
> > Drivers->Network device support->PHY Device support and infrastructure
> >
> > (Do we need Marvell PHYs option as =y ? I do not think so - should be:
> > is not set)
>
> Yes you do. The PHYs inside the switch are Marvell.
>
> > What possibly I made wrong here (this does not work - I could not get
> > through the switch, and seems that MDIO works (from the logic
> > analyzer), but addresses some 0x1B/0x1C ports, which should NOT be
> > addressed, according to the the DTS configuration shown)?
>
> 0x1b is global1, and 0x1c is global2. These are registers shared by
> all ports.
>
> Please show me the configuration steps you are doing? How are you
> configuring the FEC and the switch interfaces?
>
>     Andrew
