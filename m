Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EE649501F
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347192AbiATO2b convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Jan 2022 09:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347393AbiATO2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 09:28:18 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9DBC061574;
        Thu, 20 Jan 2022 06:28:17 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B07BAC000E;
        Thu, 20 Jan 2022 14:28:14 +0000 (UTC)
Date:   Thu, 20 Jan 2022 15:28:13 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [wpan-next 0/4] ieee802154: General preparation to scan support
Message-ID: <20220120152813.32e4b288@xps13>
In-Reply-To: <87r192imcy.fsf@tynnyri.adurom.net>
References: <20220120004350.308866-1-miquel.raynal@bootlin.com>
        <87r192imcy.fsf@tynnyri.adurom.net>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

kvalo@kernel.org wrote on Thu, 20 Jan 2022 15:10:37 +0200:

> Miquel Raynal <miquel.raynal@bootlin.com> writes:
> 
> > These few patches are preparation patches and light cleanups before the
> > introduction of scan support.
> >
> > David Girault (4):
> >   net: ieee802154: Move IEEE 802.15.4 Kconfig main entry
> >   net: mac802154: Include the softMAC stack inside the IEEE 802.15.4
> >     menu
> >   net: ieee802154: Move the address structure earlier
> >   net: ieee802154: Add a kernel doc header to the ieee802154_addr
> >     structure
> >
> >  include/net/cfg802154.h | 28 +++++++++++++++++++---------
> >  net/Kconfig             |  3 +--
> >  net/ieee802154/Kconfig  |  1 +
> >  3 files changed, 21 insertions(+), 11 deletions(-)  
> 
> Is there a reason why you cc linux-wireless? It looks like there's a
> separate linux-wpan list now and people who are interested about wpan
> can join that list, right?
> 

I originally was advised to cc linux-wireless@ on my scanning series,
and I ended up with too many patches, leading to numerous smaller
series.

I actually forgot to drop this list from the Cc list in the preparation
patches for this version, I did however dropped it in the v2. Sorry for
the noise.

Thanks,
Miquèl
