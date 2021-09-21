Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EE5412BD3
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350889AbhIUCib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:38:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344291AbhIUCUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 22:20:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 946B461245;
        Tue, 21 Sep 2021 02:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632190750;
        bh=Z+11tE516+e0V1bcSE+sqc/byA+rMuk9RbFhyqq7PYk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d90ZZKy8uQqKCKsdlcPvk8V+Wg37YRYMGkKcES9+Dp7tMmqpK2DNANFneNOaJcTI2
         b4ZDwbRcpjJEi59AMJct89FFTyI2XQW4U9OVG94kCpYOwKDtoGxIhrZlFEkfukoQmJ
         LVcx4Of36Y+mtMne9kJFCnfjgN6NS0kQnG+SRqLlC01hSPA4UAKh2FaFK8hmeTPGr4
         u4KgNPsbR2urWO0se7ZrGB+6/jd1GfpBe2FRo9FVU6f1MJIb8X2jCdbh8Sv1pDd+Hl
         i4qvy5Uyr2VqLXN8sv0VpTZHYtbCOGjhcAZDU/DJTWaGXnZQbwKgVg+ZCO8QyLw+Wy
         Mqc3qkth7VV4g==
Date:   Tue, 21 Sep 2021 05:19:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Manish Chopra <manishc@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next] devlink: Make devlink_register to be void
Message-ID: <YUlBGk2Mq3iYhtku@unreal>
References: <2e089a45e03db31bf451d768fc588c02a2f781e8.1632148852.git.leonro@nvidia.com>
 <20210920133915.59ddfeef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210920140407.0732b3d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920140407.0732b3d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 02:04:07PM -0700, Jakub Kicinski wrote:
> On Mon, 20 Sep 2021 13:39:15 -0700 Jakub Kicinski wrote:
> > On Mon, 20 Sep 2021 17:41:44 +0300 Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > devlink_register() can't fail and always returns success, but all drivers
> > > are obligated to check returned status anyway. This adds a lot of boilerplate
> > > code to handle impossible flow.
> > > 
> > > Make devlink_register() void and simplify the drivers that use that
> > > API call.  
> > 
> > Unlike unused functions bringing back error handling may be
> > non-trivial. I'd rather you deferred such cleanups until you're 
> > ready to post your full rework and therefore give us some confidence 
> > the revert will not be needed.
> 
> If you disagree you gotta repost, new devlink_register call got added
> in the meantime.

This is exactly what I afraid, new devlink API users are added faster
than I can cleanup them.

For example, let's take a look on newly added ipc_devlink_init(), it is
called conditionally "if (stage == IPC_MEM_EXEC_STAGE_BOOT) {". How can
it be different stage if we are in driver .probe() routine?

They also introduced devlink_sio.devlink_read_pend and
devlink_sio.read_sem to protect from something that right position of
devlink_register() will fix. I also have serious doubts that their
current protection is correct, once they called to devlink_params_publish()
the user can crash the system, because he can access the parameters before
they initialized their protection.

So yes, I disagree. We will need to make sure that devlink_register()
can't fail and it will make life easier for everyone (no need to unwind)
while we put that command  being last in probe sequence.

If I repost, will you take it? I don't want to waste anyone time if it
is not.

Thanks
