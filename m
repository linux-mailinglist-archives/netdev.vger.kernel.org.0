Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9109A1D181E
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 16:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389077AbgEMO7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 10:59:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:53646 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728692AbgEMO7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 10:59:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BD3C1AD5B;
        Wed, 13 May 2020 14:59:37 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 68682602FD; Wed, 13 May 2020 16:59:34 +0200 (CEST)
Date:   Wed, 13 May 2020 16:59:34 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] net: ethernet: validate pause autoneg
 setting
Message-ID: <20200513145934.GD9071@lion.mk-sys.cz>
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-2-git-send-email-opendmb@gmail.com>
 <20200512004714.GD409897@lunn.ch>
 <ae63b295-b6e3-6c34-c69d-9e3e33bf7119@gmail.com>
 <20200512185503.GD1551@shell.armlinux.org.uk>
 <0cf740ed-bd13-89d5-0f36-1e5305210e97@gmail.com>
 <20200513053405.GE1551@shell.armlinux.org.uk>
 <20200513092050.GB1605@shell.armlinux.org.uk>
 <20200513134925.GE499265@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513134925.GE499265@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 03:49:25PM +0200, Andrew Lunn wrote:
> > So, I think consistency of implementation is more important than fixing
> > this; the current behaviour has been established for many years now.
> 
> With netlink ethtool we have the possibility of adding a new API to
> control this. And we can leave the IOCTL API alone, and the current
> ethtool commands. We can add a new command to ethtool which uses the new API.
> 
> Question is, do we want to do this? Would we be introducing yet more
> confusion, rather than making the situation better?

For the record, netlink interface for pause parameters which is based on
existing ioctl and ethtool_ops is in mainline but not in v5.6. If there
is a consensus that it should be rethought, it might still be possible
to drop these two request types and come with a better API later (i.e.
in 5.8 or 5.9 cycle).

Michal

