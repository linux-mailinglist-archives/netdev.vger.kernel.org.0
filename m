Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D144290DA2
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 00:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393601AbgJPWP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 18:15:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60434 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391880AbgJPWPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 18:15:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTY0v-0024B4-4O; Sat, 17 Oct 2020 00:15:53 +0200
Date:   Sat, 17 Oct 2020 00:15:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201016221553.GN139700@lunn.ch>
References: <20201010154119.3537085-1-idosch@idosch.org>
 <20201010154119.3537085-2-idosch@idosch.org>
 <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865B2FBA17BABBC747190D8D8070@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201012085803.61e256e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865E4CB3854ECF70F5864D7D8040@DM6PR12MB3865.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB3865E4CB3854ECF70F5864D7D8040@DM6PR12MB3865.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Example:
> - swp1 is a 200G port with 4 lanes.
> - QSFP28 is plugged in.
> - The user wants to select configuration of 100G speed using 2 lanes, 50G each.
> 
> $ ethtool swp1
> Settings for swp1:
>         Supported ports: [ FIBRE         Backplane ]
>         Supported link modes:   1000baseT/Full
>                                 10000baseT/Full
>                                 1000baseKX/Full
>                                 10000baseKR/Full
>                                 10000baseR_FEC
>                                 40000baseKR4/Full
>                                 40000baseCR4/Full
>                                 40000baseSR4/Full
>                                 40000baseLR4/Full
>                                 25000baseCR/Full
>                                 25000baseKR/Full
>                                 25000baseSR/Full
>                                 50000baseCR2/Full
>                                 50000baseKR2/Full
>                                 100000baseKR4/Full
>                                 100000baseSR4/Full
>                                 100000baseCR4/Full
>                                 100000baseLR4_ER4/Full
>                                 50000baseSR2/Full
>                                 10000baseCR/Full
>                                 10000baseSR/Full
>                                 10000baseLR/Full
>                                 10000baseER/Full
>                                 50000baseKR/Full
>                                 50000baseSR/Full
>                                 50000baseCR/Full
>                                 50000baseLR_ER_FR/Full
>                                 50000baseDR/Full

>                                 100000baseKR2/Full
>                                 100000baseSR2/Full
>                                 100000baseCR2/Full
>                                 100000baseLR2_ER2_FR2/Full
>                                 100000baseDR2/Full

I'm not sure i fully understand all these different link modes, but i
thought these 5 are all 100G using 2 lanes? So why cannot the user
simply do

ethtool -s swp1 advertise 100000baseKR2/Full

and the driver can figure out it needs to use two lanes at 50G?

    Andrew
