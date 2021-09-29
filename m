Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD8B41C2E6
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244691AbhI2Kow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243396AbhI2Kov (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:44:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A563161159;
        Wed, 29 Sep 2021 10:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632912190;
        bh=+dWbv6MK792jqAAiE3Iu+92XjoDmSSphFkEX4olyN/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kkT0wJpXtOU1jKHLvTLEHDcFzyGsaTW2KbNFDDkSceiRF44orOxlmvEdUXPiAg1ne
         T9iBP5MvAqpqlvvpT2eQB5LUHDWmHoBVhcaxAgfyBZK3m0dp5WUM2VzbZTPT1Q2vDn
         TGpnO6rLO17kCzczJQTqNS6nN6cJkMUC9kAhjLV2CX+gL4IkIfAtJuTnHOB4GnObl5
         f6AOUTYLHsTOjT+xKpBB8WraodAp0Rvr8Ol2OtCxF+vGeaZ48SswJ/7MMLvV00Wto8
         70Uen1mLSDQS6ubpjqE94UZnhj+4JQMmVTwAgxMEhyVRUvZkuZ0qdZEMSs6jN352r7
         LTzEfohSacJDQ==
Date:   Wed, 29 Sep 2021 13:43:06 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Eric Dumazet <eric.dumazet@gmail.com>,
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
        Moshe Shemesh <moshe@nvidia.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Shannon Nelson <snelson@pensando.io>,
        Shay Drory <shayd@nvidia.com>,
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
Subject: Re: [PATCH net-next 3/5] devlink: Allow set specific ops callbacks
 dynamically
Message-ID: <YVRDOijPHji2vg82@unreal>
References: <cover.1632909221.git.leonro@nvidia.com>
 <4e99e3996118ce0e2da5367b8fc2a427095dfffd.1632909221.git.leonro@nvidia.com>
 <20210929103823.GK2048@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929103823.GK2048@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 01:38:23PM +0300, Dan Carpenter wrote:
> On Wed, Sep 29, 2021 at 01:16:37PM +0300, Leon Romanovsky wrote:
> > +void devlink_set_ops(struct devlink *devlink, struct devlink_ops *ops)
> > +{
> > +	struct devlink_ops *dev_ops = devlink->ops;
> > +
> > +	WARN_ON(!devlink_reload_actions_valid(ops));
> > +
> > +#define SET_DEVICE_OP(ptr, name)                                               \
> > +	do {                                                                   \
> > +		if (ops->name)                                                 \
> 
> Could you make "ops" a parameter of the macro instead of hard coding it?

Sure

> 
> regards,
> dan carpenter
> 
> > +			if (!((ptr)->name))				       \
> > +				(ptr)->name = ops->name;                       \
> > +	} while (0)
> > +
> > +	/* Keep sorted */
> > +	SET_DEVICE_OP(dev_ops, reload_actions);
> > +	SET_DEVICE_OP(dev_ops, reload_down);
> > +	SET_DEVICE_OP(dev_ops, reload_limits);
> > +	SET_DEVICE_OP(dev_ops, reload_up);
> > +
> > +#undef SET_DEVICE_OP
> > +}
> > +EXPORT_SYMBOL_GPL(devlink_set_ops);
> 
