Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EAB265A29
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 09:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgIKHMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 03:12:12 -0400
Received: from mx1.tq-group.com ([62.157.118.193]:11060 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgIKHMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 03:12:09 -0400
IronPort-SDR: SyXmEn57cxbxzJvZJFB1g54o+W16x2Pt4/TFiiIw/IEiKFLK3i075xP9NbcF2jkwBTJGcYJ8S4
 2zf+b1v/xTC7hLxChCZNLLRYaTxiopKCWUAmuxG9D2Pf6+3XMpD/BulowSvr1Nwg0TDmqRYymW
 r0pCnZwnbeLoy/DNURKiwA4tp/xSufQdIi18fQY1/ZrhKD9JWlYqESekmtQD5mnmC+phL1x2D7
 UyZ7/sCRiIIDpwun7ZUkUPRUl45T6/YHZEb3aVmgdFI/+yhmfzlugV0v5MUYvdyy++tGtWixyr
 P+w=
X-IronPort-AV: E=Sophos;i="5.76,414,1592863200"; 
   d="scan'208";a="13823043"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 11 Sep 2020 09:12:03 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 11 Sep 2020 09:12:03 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Fri, 11 Sep 2020 09:12:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1599808323; x=1631344323;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AU2k/ol3F6+4MhfoxYv9B+n0tw9osfMsfh6doDTGS/o=;
  b=D8+Pk7ncAWYuHgeOfIIH4Vr+RaoDDd+RC11jZvdC6trvlSnHLr3cUQaA
   n6lbniSO3kb+Qtt2ApmOwGk0539Zi9hKGy2kR51GZNtrBPFGsaIvLSwRS
   KCpXwsNxAujcxlY6YKCZA6PK3Je/M2a/n7Yho9syvthEy2WLe9r+1lGFM
   LT2nV+qbUtGwxln8DTn7DrVNSnbEwQukPqIyG8QWQs7BKRhr5PUNcI9gi
   Wh14+YBaLdiXSRBbpHljTMvgEEDe04zDy4K9dEcW+UyjW//BEE2J/NhBu
   mlzYeDWE6wk/Tzy/SageCvEnWnZH18B214qsv0zz2qON/USaNNc+HZu8y
   A==;
IronPort-SDR: tdg5TWJpJeznQONhTjrUmSngaYfE3e1ZD2zfheC2M4x1UAIvqCs3achhaqFBCXvIPFJn7nMVOR
 xH+OR7FF3dGFb0A00XuMyI5qJJiSMDdyNEoPW1/vb09Ul0qQyxMYz3hdFpeMtbeR+DI4KsaG5y
 PdEc9IPNVSKODvyhgFnmBYE1KxvJM8fjJwZIDtfUSVhTmynYm/pfR1bt8aQRbxhX7KCvr6quLC
 xj+Py0W6DPmFrVAj7dM4lajCGB5pFqBaJe6Rt9pd0ENROWNUevwxasaefCm/nvE4/rYOYytWfp
 9s0=
X-IronPort-AV: E=Sophos;i="5.76,414,1592863200"; 
   d="scan'208";a="13823042"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 11 Sep 2020 09:12:03 +0200
Received: from schifferm-ubuntu4 (unknown [10.117.49.134])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id B6605280070;
        Fri, 11 Sep 2020 09:12:03 +0200 (CEST)
Message-ID: <3d4dd05f2597c66fb429580095eed91c2b3be76a.camel@ew.tq-group.com>
Subject: Re: [PATCH net-next + leds v2 6/7] net: phy: marvell: add support
 for LEDs controlled by Marvell PHYs
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Pavel Machek <pavel@ucw.cz>, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date:   Fri, 11 Sep 2020 09:12:01 +0200
In-Reply-To: <20200910150040.GB3354160@lunn.ch>
References: <20200909162552.11032-1-marek.behun@nic.cz>
         <20200909162552.11032-7-marek.behun@nic.cz>
         <20200910122341.GC7907@duo.ucw.cz> <20200910131541.GD3316362@lunn.ch>
         <20200910161522.3cf3ad63@dellmb.labs.office.nic.cz>
         <20200910150040.GB3354160@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-09-10 at 17:00 +0200, Andrew Lunn wrote:
> > I propose that at least these HW modes should be available (and
> > documented) for ethernet PHY controlled LEDs:
> >   mode to determine link on:
> >     - `link`
> >   mode for activity (these should blink):
> >     - `activity` (both rx and tx), `rx`, `tx`
> >   mode for link (on) and activity (blink)
> >     - `link/activity`, maybe `link/rx` and `link/tx`
> >   mode for every supported speed:
> >     - `1Gbps`, `100Mbps`, `10Mbps`, ...
> >   mode for every supported cable type:
> >     - `copper`, `fiber`, ... (are there others?)
> 
> In theory, there is AUI and BNC, but no modern device will have
> these.
> 
> >   mode that allows the user to determine link speed
> >     - `speed` (or maybe `linkspeed` ?)
> >     - on some Marvell PHYs the speed can be determined by how fast
> >       the LED is blinking (ie. 1Gbps blinks with default blinking
> >       frequency, 100Mbps with half blinking frequeny of 1Gbps,
> > 10Mbps
> >       of half blinking frequency of 100Mbps)
> >     - on other Marvell PHYs this is instead:
> >       1Gpbs blinks 3 times, pause, 3 times, pause, ...
> >       100Mpbs blinks 2 times, pause, 2 times, pause, ...
> >       10Mpbs blinks 1 time, pause, 1 time, pause, ...
> >     - we don't need to differentiate these modes with different
> > names,
> >       because the important thing is just that this mode allows the
> >       user to determine the speed from how the LED blinks
> >   mode to just force blinking
> >     - `blink`
> > The nice thing is that all this can be documented and done in
> > software
> > as well.
> 
> Have you checked include/dt-bindings/net/microchip-lan78xx.h and
> mscc-phy-vsc8531.h ? If you are defining something generic, we need
> to
> make sure the majority of PHYs can actually do it. There is no
> standardization in this area. I'm sure there is some similarity,
> there
> is only so many ways you can blink an LED, but i suspect we need a
> mixture of standardized modes which we hope most PHYs implement, and
> the option to support hardware specific modes.
> 
>     Andrew


FWIW, these are the LED HW trigger modes supported by the TI DP83867
PHY:

- Receive Error
- Receive Error or Transmit Error
- Link established, blink for transmit or receive activity
- Full duplex
- 100/1000BT link established
- 10/100BT link established
- 10BT link established
- 100BT link established
- 1000BT link established
- Collision detected
- Receive activity
- Transmit activity
- Receive or Transmit activity
- Link established

AFAIK, the "Link established, blink for transmit or receive activity"
is the only trigger that involves blinking; all other modes simply make
the LED light up when the condition is met. Setting the output level in
software is also possible.

Regarding the option to emulate unsupported HW triggers in software,
two questions come to my mind:

- Do all PHYs support manual setting of the LED level, or are the PHYs
that can only work with HW triggers?
- Is setting PHY registers always efficiently possible, or should SW
triggers be avoided in certain cases? I'm thinking about setups like
mdio-gpio. I guess this can only become an issue for triggers that
blink.


Kind regards,
Matthias

