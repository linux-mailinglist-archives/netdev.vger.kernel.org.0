Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDDA29276D
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgJSMio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:38:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34620 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgJSMin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 08:38:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUUQv-002Unx-7a; Mon, 19 Oct 2020 14:38:37 +0200
Date:   Mon, 19 Oct 2020 14:38:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Danielle Ratson <danieller@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201019123837.GP456889@lunn.ch>
References: <20201010154119.3537085-1-idosch@idosch.org>
 <20201010154119.3537085-2-idosch@idosch.org>
 <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865B2FBA17BABBC747190D8D8070@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201012085803.61e256e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865E4CB3854ECF70F5864D7D8040@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201016221553.GN139700@lunn.ch>
 <20201019122428.GB11282@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019122428.GB11282@nanopsycho.orion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >>                                 100000baseKR2/Full
> >>                                 100000baseSR2/Full
> >>                                 100000baseCR2/Full
> >>                                 100000baseLR2_ER2_FR2/Full
> >>                                 100000baseDR2/Full
> >
> >I'm not sure i fully understand all these different link modes, but i
> >thought these 5 are all 100G using 2 lanes? So why cannot the user
> >simply do
> >
> >ethtool -s swp1 advertise 100000baseKR2/Full
> >
> >and the driver can figure out it needs to use two lanes at 50G?
> 
> 100000baseKR2 is 2 lanes. No need to figure anything out. What do you
> mean by that?

I'm just thinking, rather than add a new UAPI for the number of lanes,
why not use one we already have, if the number of lanes is implied by
the link mode.

    Andrew
