Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B52A187B18
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 09:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgCQIXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 04:23:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:50918 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgCQIXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 04:23:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B6013AF5D;
        Tue, 17 Mar 2020 08:23:12 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id C9F0DE00A9; Tue, 17 Mar 2020 09:23:10 +0100 (CET)
Date:   Tue, 17 Mar 2020 09:23:10 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "John W. Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>
Subject: Re: [PATCH ethtool] ethtool: Add support for Low Latency Reed Solomon
Message-ID: <20200317082310.GE10043@unicorn.suse.cz>
References: <1584025923-5385-1-git-send-email-tariqt@mellanox.com>
 <20200313192803.GB1230@tuxdriver.com>
 <19010e9f-1847-717e-1ade-a4157205503a@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19010e9f-1847-717e-1ade-a4157205503a@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 10:06:26AM +0200, Tariq Toukan wrote:
> On 3/13/2020 9:28 PM, John W. Linville wrote:
> > On Thu, Mar 12, 2020 at 05:12:03PM +0200, Tariq Toukan wrote:
> > > From: Aya Levin <ayal@mellanox.com>
> > > 
> > > Introduce a new FEC mode LL-RS: Low Latency Reed Solomon, update print
> > > and initialization functions accordingly. In addition, update related
> > > man page.
> > > 
> > > Signed-off-by: Aya Levin <ayal@mellanox.com>
> > > Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> > > ---
> > >   ethtool-copy.h |  3 +++
> > >   ethtool.8.in   |  5 +++--
> > >   ethtool.c      | 12 +++++++++++-
> > >   3 files changed, 17 insertions(+), 3 deletions(-)
> > 
> > Hey...
> > 
> > Thanks for the patch! Unfortunately for you, I just merged "[PATCH
> > ethtool v3 01/25] move UAPI header copies to a separate directory"
> > from Michal Kubecek <mkubecek@suse.cz>, and that patch did this:
> > 
> >   ethtool-copy.h => uapi/linux/ethtool.h       | 0
> >   rename ethtool-copy.h => uapi/linux/ethtool.h (100%)
> > 
> > Could you please rework your patch against the current kernel.org tree?
> 
> Hi John,
> Sure, we'll rework and respin.

When you do, please update also link_modes[] array in netlink/settings.c
I'll have to think of some long term solution (like kernel providing
this information) but that is something for the future development.

Michal
