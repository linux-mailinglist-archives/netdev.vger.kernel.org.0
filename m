Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3DC35EF65
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 10:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349698AbhDNISp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 04:18:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350031AbhDNISg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 04:18:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3A1060BBB;
        Wed, 14 Apr 2021 08:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618388295;
        bh=TGqHatrZDJj87DKmO5w//QJxWxF6AOHU5s0YwuH9IMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FUDkpwMhI5HnTxBZ0exY50tycpWiGtxV8m3Y0z6Z2M8+xqfctlPGUXWWJ1hajgy8V
         AITlXQVQ8yEKDBB9a13tFkpHyr5JriCdCWAw13r+486Y8laskX9t008t7vnGVF4rRN
         sJipIJen3aHDQ6whE9+Wmcb/C+uwVgrBKj16TdCw=
Date:   Wed, 14 Apr 2021 10:18:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Roman Mamedov <rm+bko@romanrm.net>
Subject: Re: [PATCH net] r8169: don't advertise pause in jumbo mode
Message-ID: <YHalRMnzCSS4Dmd/@kroah.com>
References: <e249e2fb-ba51-a62e-f2e7-5011c3790830@gmail.com>
 <YHaen5PAzfNcnnOG@kroah.com>
 <d038efe3-724e-f732-0171-f4321837a0cb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d038efe3-724e-f732-0171-f4321837a0cb@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 09:56:30AM +0200, Heiner Kallweit wrote:
> On 14.04.2021 09:49, Greg KH wrote:
> > On Wed, Apr 14, 2021 at 09:40:51AM +0200, Heiner Kallweit wrote:
> >> It has been reported [0] that using pause frames in jumbo mode impacts
> >> performance. There's no available chip documentation, but vendor
> >> drivers r8168 and r8125 don't advertise pause in jumbo mode. So let's
> >> do the same, according to Roman it fixes the issue.
> >>
> >> [0] https://bugzilla.kernel.org/show_bug.cgi?id=212617
> >>
> >> Fixes: 9cf9b84cc701 ("r8169: make use of phy_set_asym_pause")
> >> Reported-by: Roman Mamedov <rm+bko@romanrm.net>
> >> Tested-by: Roman Mamedov <rm+bko@romanrm.net>
> >> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> >> ---
> >> This patch doesn't apply cleanly on some kernel versions, but the needed
> >> changes are trivial.
> >> ---
> >>  drivers/net/ethernet/realtek/r8169_main.c | 9 +++++++--
> >>  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > 
> > <formletter>
> > 
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read:
> >     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this properly.
> > 
> > </formletter>
> > 
> Until recently the procedure in netdev has been to annotate the patch as
> "net" and not cc stable. IIRC there is an experiment to cc stable.
> If this isn't applicable any longer and the old process still applies,
> then please ignore the cc'ed stable.

You need to put the "Cc: stable..." in the signed-off-by area, as the
documentation link above states.

thanks,

greg k-h
