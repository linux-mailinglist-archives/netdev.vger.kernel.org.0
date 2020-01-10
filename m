Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEBE137680
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgAJTBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:01:40 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46220 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728457AbgAJTBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:01:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dVyULsDo01EswppCtaWh6c0yi5UY2xH1+ErRHnAuFNk=; b=xgFd/a9A3rTAJxKnshSFXqvCF
        6tIdeW66BebDyH+kloKzjuAKgOcitHm0NUuGn3HKAIVs+f66FMSxN4LqBuEfR0BTQfNjR+gOG+BO0
        Ne/egJNnL+s6x8ejnEXSzD5WnlApHiTzQ09VGcy8DZCEu2uXDcxk7Yxoq4UNQphY5jwoJfS0PKYF+
        arJkLrNVxY+zSCbxw10iWoh25f5cxqCNRs1ciYeYLXlO5VK4PiaaV+cMhnuq2vwQxYaNuoh8gFCcl
        8YiwIST2mH42CWr8gio+g55TYCliSaUYUqPcZy4cvJYNWPj8Ulo9Ley2yBqjWXebiS7yZhA1RqCCD
        XWvcNH74Q==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:60732)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipzXM-0004wg-06; Fri, 10 Jan 2020 19:01:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipzXK-0001ka-Fq; Fri, 10 Jan 2020 19:01:34 +0000
Date:   Fri, 10 Jan 2020 19:01:34 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200110190134.GL25745@shell.armlinux.org.uk>
References: <20200110125305.GB25745@shell.armlinux.org.uk>
 <b4b94498-5011-1e89-db54-04916f8ef846@gmx.net>
 <20200110150955.GE25745@shell.armlinux.org.uk>
 <e9a99276-c09d-fa8d-a280-fca2abac6602@gmx.net>
 <20200110163235.GG25745@shell.armlinux.org.uk>
 <717229a4-f7f6-837d-3d58-756b516a8605@gmx.net>
 <20200110170836.GI25745@shell.armlinux.org.uk>
 <12956566-4aa3-2c5d-be1a-8612edab3b3d@gmx.net>
 <20200110173851.GJ25745@shell.armlinux.org.uk>
 <e18b0fb9-0c6d-ed5e-3a20-dc29e9cc048e@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e18b0fb9-0c6d-ed5e-3a20-dc29e9cc048e@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 06:44:18PM +0000, ѽ҉ᶬḳ℠ wrote:
> On 10/01/2020 17:38, Russell King - ARM Linux admin wrote:
> > 
> > > > On Fri, Jan 10, 2020 at 04:53:06PM +0000, ѽ҉ᶬḳ℠ wrote:
> > > > > Seems that the debug avenue has been exhausted, short of running SFP.C in
> > > > > debug mode.
> > > > You're saying you never see TX_FAULT asserted other than when the
> > > > interface is down?
> > > Yes, it never exhibits once the iif is up - it is rock-stable in that state,
> > > only ever when being transitioned from down state to up state.
> > > Pardon, if that has not been made explicitly clear previously.
> > I think if we were to have SFP debug enabled, you'll find that
> > TX_FAULT is being reported to SFP as being asserted.
> 
> If really necessary I could ask the TOS developers to assist, not sure
> whether they would oblidge. Their Master branch build bot compiles twice a
> day.
> Would it just involve setting a kernel debug flag or something more
> elaborate?
> 
> > 
> > You probably aren't running that while loop, as it will exit when
> > it sees TX_FAULT asserted.  So, here's another bit of shell code
> > for you to run:
> > 
> > ip li set dev eth2 down; \
> > ip li set dev eth2 up; \
> > date
> > while :; do
> >    cat /proc/uptime
> >    while ! grep -A5 'tx-fault.*in  hi' /sys/kernel/debug/gpio; do :; done
> >    cat /proc/uptime
> >    while ! grep -A5 'tx-fault.*in  lo' /sys/kernel/debug/gpio; do :; done
> > done
> > 
> > This will give you output such as:
> > 
> > Fri 10 Jan 17:31:06 GMT 2020
> > 774869.13 1535859.48
> >   gpio-509 (                    |tx-fault            ) in  hi ...
> > 774869.14 1535859.49
> >   gpio-509 (                    |tx-fault            ) in  lo ...
> > 774869.15 1535859.50
> > 
> > The first date and "uptime" output is the timestamp when the interface
> > was brought up.  Subsequent "uptime" outputs can be used to calculate
> > the time difference in seconds between the state printed immediately
> > prior to the uptime output, and the first "uptime" output.
> > 
> > So in the above example, the tx-fault signal was hi at 10ms, and then
> > went low 20ms after the up.
> 
> awfully nice of you to provide the code, this is the output when the iif is
> brought down and up again and exhibiting the transmit fault.
> 
> ip li set dev eth2 down; \
> > ip li set dev eth2 up; \
> > date
> Fri Jan 10 18:34:52 GMT 2020
> root@to:~# while :; do
> >   cat /proc/uptime
> >   while ! grep -A5 'tx-fault.*in  hi' /sys/kernel/debug/gpio; do :; done
> >   cat /proc/uptime
> >   while ! grep -A5 'tx-fault.*in  lo' /sys/kernel/debug/gpio; do :; done
> > done

Hmm, I missed a ; \ at the end of "date", so this isn't quite what
I wanted, but it'll do.  What that means is that:

> 1865.20 3224.67

doesn't bear the relationship that I wanted to the interface coming
up.

>  gpio-504 (                    |tx-fault            ) in  hi IRQ
>  gpio-505 (                    |tx-disable          ) out hi
>  gpio-506 (                    |rate-select0        ) in  lo
>  gpio-507 (                    |los                 ) in  lo IRQ
>  gpio-508 (                    |mod-def0            ) in  lo IRQ
> 1871.77 3230.71

TX_FAULT is high at 1871.77 and TX_DISABLE is high, so the interface
is down.

>  gpio-504 (                    |tx-fault            ) in  lo IRQ
>  gpio-505 (                    |tx-disable          ) out lo
>  gpio-506 (                    |rate-select0        ) in  lo
>  gpio-507 (                    |los                 ) in  lo IRQ
>  gpio-508 (                    |mod-def0            ) in  lo IRQ
> 1919.06 3309.55

Almost 47.3s later, TX_FAULT has gone low.

>  gpio-504 (                    |tx-fault            ) in  hi IRQ
>  gpio-505 (                    |tx-disable          ) out lo
>  gpio-506 (                    |rate-select0        ) in  lo
>  gpio-507 (                    |los                 ) in  lo IRQ
>  gpio-508 (                    |mod-def0            ) in  lo IRQ
> 1919.07 3309.57

After 10ms, it goes high again - this will cause the first report of
a transmit fault.

>  gpio-504 (                    |tx-fault            ) in  lo IRQ
>  gpio-505 (                    |tx-disable          ) out lo
>  gpio-506 (                    |rate-select0        ) in  lo
>  gpio-507 (                    |los                 ) in  lo IRQ
>  gpio-508 (                    |mod-def0            ) in  lo IRQ
> 1920.68 3312.28

About 1.6s later, it goes low, maybe as a result of the first attempt
to clear the fault by a brief pulse on TX_DISABLE.

So, we wait 1s before asserting TX_DISABLE for 10us, which would have
happened around 1920.07.  We then have 300ms for initialisation, which
would've taken us to 1920.37, so this may have been interpreted as the
fault still being present.  The next clearance attempt would have been
scheduled for about 1921.37.

>  gpio-504 (                    |tx-fault            ) in  hi IRQ
>  gpio-505 (                    |tx-disable          ) out lo
>  gpio-506 (                    |rate-select0        ) in  lo
>  gpio-507 (                    |los                 ) in  lo IRQ
>  gpio-508 (                    |mod-def0            ) in  lo IRQ
> 1921.86 3314.21

1.2s later, it re-asserts.

>  gpio-504 (                    |tx-fault            ) in  lo IRQ
>  gpio-505 (                    |tx-disable          ) out lo
>  gpio-506 (                    |rate-select0        ) in  lo
>  gpio-507 (                    |los                 ) in  lo IRQ
>  gpio-508 (                    |mod-def0            ) in  lo IRQ
> 1921.86 3314.21

and deasserts within the same 10ms.

> > However, bear in mind that even this will not be good enough to spot
> > transitory changes on TX_FAULT - as your I2C GPIO expander is interrupt
> > capable, watching /proc/interrupts may tell you more.
> > 
> > If the TX_FAULT signal is as stable as you claim it is, you should see
> > the interrupt count for it remaining the same.
> 
> Once the iif is up those values remain stable indeed.
> 
> cat /proc/interrupts | grep sfp
>  52:          0          0   pca953x   4 Edge      sfp
>  53:          0          0   pca953x   3 Edge      sfp
>  54:          6          0   pca953x   0 Edge      sfp
> 
> and only incrementing with ifupdown action (which would be logical)
> 
> cat /proc/interrupts | grep sfp
>  52:          0          0   pca953x   4 Edge      sfp
>  53:          0          0   pca953x   3 Edge      sfp
>  54:         11          0   pca953x   0 Edge      sfp

According to this, TX_FAULT has toggled five times.

This would seem to negate your previous comment about TX_FAULT being
stable.

Therefore, I'd say that the SFP state machines are operating as
designed, and as per the SFP MSA, and what we have is a module that
likes to assert TX_FAULT for unknown reasons, and this confirms the
hypothesis I've been putting forward.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
