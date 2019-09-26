Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDF5BF3FC
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 15:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfIZNYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 09:24:02 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:41541 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfIZNYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 09:24:02 -0400
Received: by mail-qt1-f174.google.com with SMTP id n1so2799013qtp.8
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 06:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sTV4CXZngTqGG28A7smp6xFmdShWMtdBruXA2FOLpQE=;
        b=bR8VduJQMM1m13Ky7X7I1KlUNwFnCMXilqYSRcBHFjGV3TV6+vsbhlDBMKtx0Nc3ED
         CzbWeOUM8X0n/n6PnfYW7d/nASltwmY4/yBYwl3L9zfz37+q0yl4u4VVDGiO/bGD54VW
         16Lh9gwG8U3DEWj9l5c+XJvvUxQbnNdwZdZR3K/h/aUBbypTOTFfnLyFOyUkNLEQhLeh
         bDerKiqG+CHFkHrcJsM+R6CQWA3mAIlADn0/8fSk3UY2z63GQg8EilJWG/2h2nFP6uvx
         kzKr87gRBLWzkrUCmp/LQ9tr6u3NALyZ9Hd22GKgcX59kxkapHolGUsaJPWGojwlKftP
         gglg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sTV4CXZngTqGG28A7smp6xFmdShWMtdBruXA2FOLpQE=;
        b=eWyOfAu8McN+4Cz07+nKo1uEsF1iwQPJoTBl4NB6Nrh7b9rf06r/5gUa0S0FPP+V8i
         +9FSQ/obFmXHyF92MgZK49j8VHywyAEQJkERgAKZmyEPnJD+zlu8RYoNSKSTrbuKXrTr
         4cw/eXXtivrmGVurOHxttVJSdrd5Ug5gFadeMYDDJt0JGAlaUerFSCFi/RBL5weLFohz
         FtcfwAmzNgeXNR+DRaYi7+sL7WEJkgRardo3srrK5ZqGKpFIqcgznu41wk0SI7eSL9TV
         25WdeWh5iELsasmGwzu5anyT/H5a/XxucdpFGOxvGD2/tYSoZfDdiJKOasI8fk6UmUM6
         xbTw==
X-Gm-Message-State: APjAAAWaPQp57U04izSO1ue93H17bCEvKZwpMZH1rCuUudLkizuzuvCQ
        MWXGb9qGiiuy6z671/1UaeITNfvMJeRyM0yXFjoBqk0W/Mc=
X-Google-Smtp-Source: APXvYqyobb9tCXQumadFHBpxJZAtzZilNpCQdTWjrvTs+tPadKylcYVgREq3HUvnJhlJ7iTBS0eCclDQ78qaJvQf3QI=
X-Received: by 2002:ac8:e82:: with SMTP id v2mr3861125qti.78.1569504241233;
 Thu, 26 Sep 2019 06:24:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAGAf8LzeyrMSHCYMxn1FNtMQVyhhLYbJaczhe2AMj+7T_nBt7Q@mail.gmail.com>
 <20190923191713.GB28770@lunn.ch>
In-Reply-To: <20190923191713.GB28770@lunn.ch>
From:   Zoran Stojsavljevic <zoran.stojsavljevic@gmail.com>
Date:   Thu, 26 Sep 2019 15:23:48 +0200
Message-ID: <CAGAf8LyQpi_R-A2Zx72bJhSBqnFo-r=KCnfVCTD9N8cNNtbhrQ@mail.gmail.com>
Subject: Re: DSA driver kernel extension for dsa mv88e6190 switch
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

I would like to thank you for the reply.

I do not know if this is the right place to post such the questions,
but my best guess is: yes.

Since till now I did not make any success to make (using DSA driver)
make mv88e6190 single switch to work with any kernel.org. :-(

I did ugly workaround as kernel dsa patch, which allowed me to
introduce TXC and RXC clock skews between I.MX6 and mv88e6190 (MAC to
MAC layer over rgmii).

And, yes, switch is working in dummy state (as you correctly described
it), passing traffic everywhere (flooding).

i.MX6 has a silicon bug, which does not allow skew configuration on
its side. PCB is out of consideration, so this ugly patch makes switch
to apply these two delays.Then, in dummy state, everything works.
_______

My DTS mv88e6190 configuration, which I adopted for the custom board I
am working on, could be seen here:
https://pastebin.com/xpXQYNRX

But on another note... I am wondering if I am setting correct kernel
configuration for it?!

Here is the part of the configuration I made while going through maze
of posts from google search results:

      Switch (and switch-ish) device support @ Networking
support->Networking options
      Distributed Switch Architecture @ Networking support->Networking options
      Tag driver for Marvell switches using DSA headers @ Networking
support->Networking options->Distributed Switch Architecture
      Tag driver for Marvell switches using EtherType DSA headers @
Networking support->Networking options->Distributed Switch
Architecture
      Marvell 88E6xxx Ethernet switch fabric support @ Device
Drivers->Network device support->Distributed Switch Architecture
drivers
      Switch Global 2 Registers support @ Device Drivers->Network
device support->Distributed Switch Architecture drivers->Marvell
88E6xxx Ethernet switch fabric support
      Freescale devices @ Device Drivers->Network device
support->Ethernet driver support
      FEC ethernet controller (of ColdFire and some i.MX CPUs) @
Device Drivers->Network device support->Ethernet driver
support->Freescale devices
      Marvell devices @ Device Drivers->Network device
support->Ethernet driver support
      Marvell MDIO interface support @ Device Drivers->Network device
support->Ethernet driver support->Marvell devices
      MDIO Bus/PHY emulation with fixed speed/link PHYs @ Device
Drivers->Network device support->PHY Device support and infrastructure

(Do we need Marvell PHYs option as =y ? I do not think so - should be:
is not set)

What possibly I made wrong here (this does not work - I could not get
through the switch, and seems that MDIO works (from the logic
analyzer), but addresses some 0x1B/0x1C ports, which should NOT be
addressed, according to the the DTS configuration shown)?

Thank you,
Zoran
_______

On Thu, Sep 26, 2019 at 1:10 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > We have the configuration problem with the Marvell 88E6190 switch.
> > What the our problem is... Is the switch is NOT configured with the
> > EEPROM (24C512), which does not exist on the board.
>
> That is pretty normal. If there is a EEPROM, i generally recommend it
> is left empty. We want Linux to configure the switch, and if it finds
> it already partially configured, things can get confused.
>
> > It is put in autoconfig by HW straps (NOCPU mode).
>
> So dumb switch mode. All ports are switched between each other.
>
> > Once the MDIO command, issued to
> > probe the switch and read the make of it, the switch jumps out of the
> > autoconfig mode.
>
> Correct. Dumb switch mode is dangerous. There is no STP, etc.
> Depending on what you have in device tree, the ports are either
> configured down, or separated.
>
> > There are some commands issued from the DSA to
> > configure the switch (to apply to switch TXC and RXC RGMII delays -
> > RGMII-ID mode), but this is not enough to make it work properly.
>
> Define 'work properly'. How are you configuring the interfaces?  Do
> you remember to bring the master interface up? Are you adding the
> interfaces to a bridge?
>
>    Andrew
