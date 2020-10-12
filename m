Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DED28BE26
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 18:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403885AbgJLQkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 12:40:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:46486 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403873AbgJLQkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 12:40:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 562DFAC19;
        Mon, 12 Oct 2020 16:40:07 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E221A603A2; Mon, 12 Oct 2020 18:40:06 +0200 (CEST)
Date:   Mon, 12 Oct 2020 18:40:06 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201012164006.fbigacnexy3dnvzq@lion.mk-sys.cz>
References: <20201010154119.3537085-1-idosch@idosch.org>
 <20201010154119.3537085-2-idosch@idosch.org>
 <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865B2FBA17BABBC747190D8D8070@DM6PR12MB3865.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB3865B2FBA17BABBC747190D8D8070@DM6PR12MB3865.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 03:33:45PM +0000, Danielle Ratson wrote:
> > 
> > > +/* Lanes, 1, 2, 4 or 8. */
> > > +#define ETHTOOL_LANES_1			1
> > > +#define ETHTOOL_LANES_2			2
> > > +#define ETHTOOL_LANES_4			4
> > > +#define ETHTOOL_LANES_8			8
> > 
> > Not an extremely useful set of defines, not sure Michal would agree.

I don't see much use for them either. Such defines or enums make sense
when the numbers represent some values which have symbolic names but
these values only represent number of lanes so a number is IMHO
sufficient.


> > > +#define ETHTOOL_LANES_UNKNOWN		0
> > 
> > >  struct link_mode_info {
> > >  	int				speed;
> > > +	int				lanes;
> > 
> > why signed?
> 
> I have aligned it to the speed.

For speed, signed type was used mostly because SPEED_UNKNOWN is defined
as -1 (even if it's cast to u32 in most places), I don't think there is
a reason to use a signed type.

Michal
