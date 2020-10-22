Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB6B2962A8
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 18:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901747AbgJVQ1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 12:27:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:48746 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897127AbgJVQ1m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 12:27:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 68D73AC48;
        Thu, 22 Oct 2020 16:27:40 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 0D4F0604F6; Thu, 22 Oct 2020 18:27:40 +0200 (CEST)
Date:   Thu, 22 Oct 2020 18:27:40 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201022162740.nisrhdzc4keuosgw@lion.mk-sys.cz>
References: <20201016221553.GN139700@lunn.ch>
 <DM6PR12MB3865B000BE04105A4373FD08D81E0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201019110422.gj3ebxttwtfssvem@lion.mk-sys.cz>
 <20201019122643.GC11282@nanopsycho.orion>
 <20201019132446.tgtelkzmfjdonhfx@lion.mk-sys.cz>
 <DM6PR12MB386532E855FD89F87072D0D7D81F0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201021070820.oszrgnsqxddi2m43@lion.mk-sys.cz>
 <DM6PR12MB38651062E363459E66140B23D81C0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201021084733.sb4rpzwyzxgczvrg@lion.mk-sys.cz>
 <DM6PR12MB3865D0B8F8F1BD32532D1DDFD81D0@DM6PR12MB3865.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB3865D0B8F8F1BD32532D1DDFD81D0@DM6PR12MB3865.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 06:15:48AM +0000, Danielle Ratson wrote:
> > -----Original Message-----
> > From: Michal Kubecek <mkubecek@suse.cz>
> > Sent: Wednesday, October 21, 2020 11:48 AM
> > 
> > Ah, right, it does. But as you extend struct ethtool_link_ksettings
> > and drivers will need to be updated to provide this information,
> > wouldn't it be more useful to let the driver provide link mode in
> > use instead (and derive number of lanes from it)?
> 
> This is the way it is done with the speed parameter, so I have aligned
> it to it. Why the lanes should be done differently comparing to the
> speed?

Speed and duplex have worked this way since ages and the interface was
probably introduced back in times when combination of speed and duplex
was sufficient to identify the link mode. This is no longer the case and
even adding number of lanes wouldn't make the combination unique. So if
we are going to extend the interface now and update drivers to provide
extra information, I believe it would be more useful to provide full
information.

Michal
