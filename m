Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351B0495BF0
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 09:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379578AbiAUIbR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Jan 2022 03:31:17 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:38615 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349730AbiAUIbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 03:31:14 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 46B1E100008;
        Fri, 21 Jan 2022 08:31:05 +0000 (UTC)
Date:   Fri, 21 Jan 2022 09:31:04 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [wpan-next 0/4] ieee802154: General preparation to scan support
Message-ID: <20220121093104.73132c5d@xps13>
In-Reply-To: <CAB_54W5ORQ7Po3k3rjZMqxf8YfrDk6E_wKGgir9G31RVSDnyqw@mail.gmail.com>
References: <20220120004350.308866-1-miquel.raynal@bootlin.com>
        <87r192imcy.fsf@tynnyri.adurom.net>
        <CAB_54W5ORQ7Po3k3rjZMqxf8YfrDk6E_wKGgir9G31RVSDnyqw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Thu, 20 Jan 2022 18:31:58 -0500:

> Hi Kalle and Miquel,
> 
> On Thu, 20 Jan 2022 at 08:10, Kalle Valo <kvalo@kernel.org> wrote:
> >
> > Miquel Raynal <miquel.raynal@bootlin.com> writes:
> >  
> > > These few patches are preparation patches and light cleanups before the
> > > introduction of scan support.
> > >
> > > David Girault (4):
> > >   net: ieee802154: Move IEEE 802.15.4 Kconfig main entry
> > >   net: mac802154: Include the softMAC stack inside the IEEE 802.15.4
> > >     menu
> > >   net: ieee802154: Move the address structure earlier
> > >   net: ieee802154: Add a kernel doc header to the ieee802154_addr
> > >     structure
> > >
> > >  include/net/cfg802154.h | 28 +++++++++++++++++++---------
> > >  net/Kconfig             |  3 +--
> > >  net/ieee802154/Kconfig  |  1 +
> > >  3 files changed, 21 insertions(+), 11 deletions(-)  
> >
> > Is there a reason why you cc linux-wireless? It looks like there's a
> > separate linux-wpan list now and people who are interested about wpan
> > can join that list, right?
> >  
> 
> I thought it would make sense to cc wireless as they have similar
> paradigms constructs (probably due the fact both are IEEE standards?).
> As well we took some ideas from wireless as base. Moreover we were
> talking about things which wireless already solved.
> I was hoping to get some feedback if somebody knows the right do's and
> don'ts of managing a wireless subsystem and I am pretty sure some
> 802.11 developers have more knowledge about it than some 802.15.4
> developers (including myself).
> 
> I apologise for this. Please Miquel drop wireless for your future patch-series.

Ok, no problem!
 
> Miquel please slow down the amount of patches. First sending the
> fixes, then new features in small series one by one. And with one by
> one I mean after they are applied.

Yes no problem, I didn't want to flood you, but I was eager to share
the new sync tx implementation that we discussed earlier this week,
which meant I also needed to share the two 'small' series in between.

Thanks,
Miquèl
