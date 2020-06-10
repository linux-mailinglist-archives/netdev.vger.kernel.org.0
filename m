Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545E81F5C69
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 22:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbgFJUFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 16:05:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:45112 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727877AbgFJUFm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 16:05:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A4F24AC5F;
        Wed, 10 Jun 2020 20:05:41 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 3A54760739; Wed, 10 Jun 2020 22:05:35 +0200 (CEST)
Date:   Wed, 10 Jun 2020 22:05:35 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH v4 0/3] Add support for SQI and master-slave
Message-ID: <20200610200535.zkozejqc3ssxpeam@lion.mk-sys.cz>
References: <20200610083744.21322-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610083744.21322-1-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 10:37:41AM +0200, Oleksij Rempel wrote:
> This patch set is extending ethtool to make it more usable on automotive
> PHYs like NXP TJA11XX.
> 
> They make use of new KAPI (currently in net-next, will go probably to the
> kernel 5.8-rc1):
> - PHY master-slave role configuration and status informaton. Mostly needed
>   for 100Base-T1 PHYs due the lack of autonegatiation support.
> - Signal Quality Index to investigate cable related issues.
> 
> changes v4:
> - rebase is against current ethtool master
> - pull headers from current kernel master
> - use tabs instead of spaces in the manual
> 
> changes v3:
> - rename "Port mode" to "master-slave"
> - use [preferred|forced]-[master|slave] for information and
>   configuration
> 
> changes v2:
> - add master-slave information to the "ethtool --help" and man page
> - move KAPI update changes to the separate patch. 
> 
> Oleksij Rempel (3):
>   update UAPI header copies
>   netlink: add master/slave configuration support
>   netlink: add LINKSTATE SQI support
> 
>  ethtool.8.in                 |  19 +++++
>  ethtool.c                    |   1 +
>  netlink/desc-ethtool.c       |   4 +
>  netlink/settings.c           |  66 +++++++++++++++
>  uapi/linux/ethtool.h         |  16 +++-
>  uapi/linux/ethtool_netlink.h | 153 ++++++++++++++++++++++++++++++++++-
>  uapi/linux/genetlink.h       |   2 +
>  uapi/linux/if_link.h         |   1 +
>  uapi/linux/netlink.h         | 103 +++++++++++++++++++++++
>  uapi/linux/rtnetlink.h       |   6 ++
>  10 files changed, 369 insertions(+), 2 deletions(-)
> 
> -- 
> 2.27.0
> 

The series looks good to me, I'll wait for another day or two for other
comments and apply it there are no objections.

Michal
