Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B912E7B9A
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 18:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgL3Rdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 12:33:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:37020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbgL3Rdb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 12:33:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A2022222A;
        Wed, 30 Dec 2020 17:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609349570;
        bh=m7aObzGNW8SPAju3os5UBDvHbgCm85ZRUg/3t9oklZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mM5W04Zhu9yxJqSf1eCeAA2Nk3AlLffWDYLaRUlUV9EEtBuTHiuwCQO+/nUO46VIE
         feME8icvQSh3N+2SBy8j7GG1o/b3UpbYg3JN5yAb8LcIzz8zzsBDxZgxYcrlOPEFLh
         Nf7ALh2JmYaIN8EdzwpnHba33QU+o3nHBgtxofgTypepv3TIZZ4+NbykPVmnKuhw1m
         ZCG1KHU/XQ5Ts5T2fV/Y4EWZS+7fj2d0HoVCK6WD6hRmhxIC+GqNoY9/OsvWR5XG4W
         Ph/LojlD2w3qRJIAQOfoBuBUoaGFkNH6JtGRHlU7ZUwRwgGcXcRZYAPDNgrR4U0tTH
         FGO6sJRmIeVaw==
Received: by pali.im (Postfix)
        id 42E449F8; Wed, 30 Dec 2020 18:32:48 +0100 (CET)
Date:   Wed, 30 Dec 2020 18:32:48 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] net: sfp: assume that LOS is not implemented if both
 LOS normal and inverted is set
Message-ID: <20201230173248.add4a6ihrhk6372p@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-4-pali@kernel.org>
 <20201230161310.GT1551@shell.armlinux.org.uk>
 <20201230165758.jqezvxnl44cvvodw@pali>
 <20201230170623.GV1551@shell.armlinux.org.uk>
 <X+y2NZ4LFy31aZ6M@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X+y2NZ4LFy31aZ6M@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 30 December 2020 18:17:41 Andrew Lunn wrote:
> On Wed, Dec 30, 2020 at 05:06:23PM +0000, Russell King - ARM Linux admin wrote:
> > On Wed, Dec 30, 2020 at 05:57:58PM +0100, Pali Rohár wrote:
> > > On Wednesday 30 December 2020 16:13:10 Russell King - ARM Linux admin wrote:
> > > > On Wed, Dec 30, 2020 at 04:47:54PM +0100, Pali Rohár wrote:
> > > > > Some GPON SFP modules (e.g. Ubiquiti U-Fiber Instant) have set both
> > > > > SFP_OPTIONS_LOS_INVERTED and SFP_OPTIONS_LOS_NORMAL bits in their EEPROM.
> > > > > 
> > > > > Such combination of bits is meaningless so assume that LOS signal is not
> > > > > implemented.
> > > > > 
> > > > > This patch fixes link carrier for GPON SFP module Ubiquiti U-Fiber Instant.
> > > > > 
> > > > > Co-developed-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > > 
> > > > No, this is not co-developed. The patch content is exactly what _I_
> > > > sent you, only the commit description is your own.
> > > 
> > > Sorry, in this case I misunderstood usage of this Co-developed-by tag.
> > > I will remove it in next iteration of patches.
> > 
> > You need to mark me as the author of the code at the very least...
> 
> Hi Pali
> 
> You also need to keep your own Signed-off-by, since the patch is
> coming through you.
> 
> So basically, git commit --am --author="Russell King <rmk+kernel@armlinux.org.uk>"
> and then two Signed-off-by: lines.

Got it, thank you!
