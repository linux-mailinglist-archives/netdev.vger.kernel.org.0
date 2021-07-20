Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499BF3CFA09
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbhGTMV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:21:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35928 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237684AbhGTMVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 08:21:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Xq6tVPylKNXKeoHt/pzC2ChIqzDtqVkAQQyGKozNL2Y=; b=3b+SMCZM/Hy/y+sk4ApE0INHZ4
        RoM1DsVEQDi3X5axNSgN9PeMTwkhLlzhhCzI6JDE63LOkgeGRWM5TSCFlUYf3gQeexjfDCx9jx7bS
        ltLBDFlGusWLrgMD+mo2Fd+IOYbYDP9fzRQKryHvwJQJwqLjfGdl6yzsK0R9cubNCat8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5pOB-00E3Jw-MF; Tue, 20 Jul 2021 15:02:23 +0200
Date:   Tue, 20 Jul 2021 15:02:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Liang Xu <lxu@maxlinear.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "mohammad.athari.ismail@intel.com" <mohammad.athari.ismail@intel.com>
Subject: Re: [PATCH v6 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YPbJX34DG5gYFkEq@lunn.ch>
References: <20210719053212.11244-1-lxu@maxlinear.com>
 <20210719053212.11244-2-lxu@maxlinear.com>
 <YPXlAFZCU3T+ua93@lunn.ch>
 <c21ac03c-28dc-1bb1-642a-ba309e39c08b@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c21ac03c-28dc-1bb1-642a-ba309e39c08b@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 03:35:17AM +0000, Liang Xu wrote:
> On 20/7/2021 4:48 am, Andrew Lunn wrote:
> > This email was sent from outside of MaxLinear.
> >
> >
> >> +/* PHY ID */
> >> +#define PHY_ID_GPYx15B_MASK  0xFFFFFFFC
> >> +#define PHY_ID_GPY21xB_MASK  0xFFFFFFF9
> > That is an odd mask. Is that really correct?
> >
> >       Andrew
> >
> Hi Andrew,
> 
> 
> Yes, this is correct and has been tested.
> 
> It's special because of a PHY ID scheme change during manufacturing.

O.K. It is just a really odd mask. And putting the revision in the
middle, not at the end? And none of the IDs have bit 0 set. It just
all adds up to it looking wrong. So i had to ask.

    Andrew
