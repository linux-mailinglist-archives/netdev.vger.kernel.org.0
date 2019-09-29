Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD844C13B3
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 08:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbfI2GzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 02:55:14 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36471 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfI2GzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 02:55:14 -0400
Received: by mail-qk1-f195.google.com with SMTP id y189so5182987qkc.3
        for <netdev@vger.kernel.org>; Sat, 28 Sep 2019 23:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2CdWdHo7AU9qPBk+JnRE64WObTaSpZvcvDwB5BRdfaA=;
        b=hogWdm6qYjj6my0YUuvpgUYRgi7JXSnwZzbY1bMhlaS3oo07EN031x/Uh/AsFuHe2a
         N/Qni2tzPsnTr7MutwhBFZ1xlV4FMAeq8EEhG9jQGmJwIQ6G3Fi31Ex+vTuWWWV4LmED
         77u5y6zs9CYWzrhgn47L2TCMUA1/x6+7tpUtoKcq8oIcnsXUMAHOwFKZnvnOxVtU4fvt
         rE0zWxCq6foK0D6A2Bd4t5D0bqSulLGoDx9nkAZoe0dznSXCeUVmqjVxm/bEIS7+tM9k
         UIb44I+8VkE9+V0vuhwu9uxAsnoVV7c+Y/uqetB8mjWyKGZGcGpEw8wmcAiQq3xX1DeU
         IVtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2CdWdHo7AU9qPBk+JnRE64WObTaSpZvcvDwB5BRdfaA=;
        b=SwfLTPqz9GtX2il3HrgGhslgb0GEw+lWdpGaqMpuRP1GzHjjg2qrG+nrX6bD9S/5py
         F5SssdiUFrJvGt0nHUhOT/4lLP0UCaGoUOBJa63gkvF6FTsKU/QFnIEOHnShcSAo12SE
         s7FRlxQO3LJ4SC3t7Coeql33uppAEEfM0Fdm44HUnNfbobv9E4m9Pf/nNtMuQ4zBJU3k
         9om29CroM6A5LSAx4q03xFk2BnK1A8Y2DuZJGaXxewoe+6hzN47J/oeq//lyk0hd3EaD
         Hcdj8/PsezVlw98428svTa3tVhg5o8Gn/HKJ8nttzqbwyzVE6+uxxu/3dzK8fWpnsyUx
         OurQ==
X-Gm-Message-State: APjAAAXZr5S+yQpZivGxYGfTAtUVY9ilCPApxcQbSEXVABzXfqIjhUfM
        wjx2v+0FuUCmWn4cQUyyKimZUO+kQM0hf9gW/TDuRYdzP8M=
X-Google-Smtp-Source: APXvYqwpuX5ixYiZKcDRSQxs8eR4jZ6ya+nyUH1y8yahK1VFTBY/lUEOsBjxZPu25nN7lxnRluPI/fCGI6UsxsC9ocg=
X-Received: by 2002:a05:620a:147:: with SMTP id e7mr13265460qkn.227.1569740112739;
 Sat, 28 Sep 2019 23:55:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAGAf8LzeyrMSHCYMxn1FNtMQVyhhLYbJaczhe2AMj+7T_nBt7Q@mail.gmail.com>
 <20190923191713.GB28770@lunn.ch> <CAGAf8LyQpi_R-A2Zx72bJhSBqnFo-r=KCnfVCTD9N8cNNtbhrQ@mail.gmail.com>
 <20190926133810.GD20927@lunn.ch> <CAGAf8LxAbDK7AUueCv-2kcEG8NZApNjQ+WQ1XO89+5C-SLAbPw@mail.gmail.com>
 <20190928152022.GE25474@lunn.ch>
In-Reply-To: <20190928152022.GE25474@lunn.ch>
From:   Zoran Stojsavljevic <zoran.stojsavljevic@gmail.com>
Date:   Sun, 29 Sep 2019 08:55:01 +0200
Message-ID: <CAGAf8LzJ56wjWxywnGWB1aOFm9B8xQhMgHFQfkVgOFWePzDfsw@mail.gmail.com>
Subject: Re: DSA driver kernel extension for dsa mv88e6190 switch
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

I see dead people... Really i do! After your reply.

> This happens when the driver is missing a resource during probe.  It
> returns the error -EPROBE_DEFER, and the linux driver core will try
> the probe again later. Probably the second time all the resources it
> needs will be present and the probe will be successful.

Thank you for the explanation. It helps to understand better the logs.

> I will probably have a some patches during the next kernel merge cycle
> to make this a bit more efficient.

I am very interested on these patches. Please, keep me in the loop! Please.

> No, it is not an obstacle, but it is still wrong.

It is. Agree. This (DTS for the custom board) I'll fix Monday. It is Sunday...

> ip link set eth0 up
> ip link set lan0 up
> ip link set lan1 up
> ip link name br0 type bridge
> ip link set br0 up
> ip link lan0 master br0
> ip link lan1 master br0

Crucifix! I totally forgot to configure interfaces!!! This is why I do
NOT see pings, since rgmii management port 0 does NOT have phy
attached!!!

The whole thing MUST be configured as link layer (bridge), to work
properly on MAC/PHY layers. About STP (routing), this is not mandatory
now.

I am dumb old dog... Sorry, even dumber! I admit... Happens! :-(

I wrote my (very first) public GIST about that. Please, could you
review it, and point to the any logical bugs in there?
https://gist.github.com/ZoranStojsavljevic/423b96e2ca3bd581f7ce417cb410c465

Thank you many many times,
Zoran
_______

On Sat, Sep 28, 2019 at 5:21 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Sep 28, 2019 at 01:00:43AM +0200, Zoran Stojsavljevic wrote:
> > Hello Andrew,
> >
> > > You should not need any kernel patches for switch side RGMII
> > > delays. rgmii-id in the DT for the switch CPU port should be enough.
> > > Some of the vf610-zii platforms use it.
> >
> > It should, but it does NOT work. IT is clearly stated in port.c, in f-n:
> > static int mv88e6xxx_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
> >                                           phy_interface_t mode)
> >
> > The logic analyser shows MDIO write to register 0x01, which is 0x6003.
> > Seems the correct value.
> >
> > But, at the very end, ethtool shows that this clock skew is NOT
> > inserted.
>
> How do you see this with ethtool?
>
> > I see on RX side CRC errors. Every ethernet frame while
> > pinging.
>
> But TX works? Maybe the FEC is doing some sort of delay, even if it
> has a hardware bug.
>
> > I see another interesting fact, the dmesg, which you could see here:
> > https://pastebin.com/igXS6eXe
> >
> > [    1.182273] DEBUG INFO! <- addr: 0x00 reg: 0x03 val: 0x1901
> > [    1.187888] mv88e6085 2188000.ethernet-1:00: switch 0x1900
> > detected: Marvell 88E6190, revision 1
> > [    1.219804] random: fast init done
> > [    1.225334] libphy: mv88e6xxx SMI: probed
> > [    1.232709] fec 2188000.ethernet eth0: registered PHC device 0
> >
> > [    1.547946] DEBUG INFO! <- addr: 0x00 reg: 0x03 val: 0x1901
> > [    1.553542] mv88e6085 2188000.ethernet-1:00: switch 0x1900
> > detected: Marvell 88E6190, revision 1
> > [    1.555432]  mmcblk1: p1
> > [    1.598106] libphy: mv88e6xxx SMI: probed
> > [    1.740362] DSA: tree 0 setup
> >
> > There are two distinct accesses while driver configures the switch. Why???
>
> This happens when the driver is missing a resource during probe.  It
> returns the error -EPROBE_DEFER, and the linux driver core will try
> the probe again later. Probably the second time all the resources it
> needs will be present and the probe will be successful.
>
> I will probably have a some patches during the next kernel merge cycle
> to make this a bit more efficient.
>
> > I was not able to explain this to me... Or find explanation using google?!
> >
> > > gpios = <&gpio1 29 GPIO_ACTIVE_HIGH>; is wrong. It probably
> > > should be reset-gpios. The rest looks O.K.
> >
> > I will follow the advise, but I do not think this is an obstacle.
>
> No, it is not an obstacle, but it is still wrong.
>
> >
> > > Please show me the configuration steps you are doing? How are you
> > > configuring the FEC and the switch interfaces?
> >
> > Forgive me for my ignorance, but I have no idea what you have asked me for?
>
> ip link set eth0 up
> ip link set lan0 up
> ip link set lan1 up
> ip link name br0 type bridge
> ip link set br0 up
> ip link lan0 master br0
> ip link lan1 master br0
>
>    Andrew
