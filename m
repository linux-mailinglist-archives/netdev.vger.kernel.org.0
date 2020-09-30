Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB0327DD4E
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 02:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbgI3AQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 20:16:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34950 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728701AbgI3AQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 20:16:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNPnU-00Gps0-Gz; Wed, 30 Sep 2020 02:16:40 +0200
Date:   Wed, 30 Sep 2020 02:16:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Igor Russkikh <irusskikh@marvell.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/3] net: atlantic: phy tunables from mac driver
Message-ID: <20200930001640.GB4012000@lunn.ch>
References: <20200929161307.542-1-irusskikh@marvell.com>
 <20200929170413.GA3996795@lunn.ch>
 <20200929103320.6a5de6f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200929184723.GE3996795@lunn.ch>
 <20200929170948.545826c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929170948.545826c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 05:09:48PM -0700, Jakub Kicinski wrote:
> On Tue, 29 Sep 2020 20:47:23 +0200 Andrew Lunn wrote:
> > > Do you mean report supported range via extack?  
> > 
> > Yes.
> > 
> > 811ac400ea33 ("net: phy: dp83869: Add speed optimization feature")
> > 
> > was merged recently. It has:
> > 
> > +       default:
> > +               phydev_err(phydev,
> > +                          "Downshift count must be 1, 2, 4 or 8\n");
> > +               return -EINVAL;
> > 
> > and there are more examples in PHY drivers where it would be good to
> > tell the uses what the valid values are. I guess most won't see this
> > kernel message, but if netlink ethtool printed:
> > 
> > Invalid Argument: Downshift count must be 1, 2, 4 or 8
> > 
> > it would be a lot more user friendly.
> 
> Ah, now I recall, we already discussed this.
> 
> FWIW we could provision for the extack and just pass NULL for now?
> Would that be too ugly?

If Michal does not have any code lying around in a drawer, what might
be a good idea. For the old IOCTL we will need to pass a NULL anyway.

  Andrew
