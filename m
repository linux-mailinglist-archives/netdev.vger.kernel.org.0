Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43346149D5A
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 23:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgAZWW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 17:22:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:45998 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgAZWW4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 17:22:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E6325B08C;
        Sun, 26 Jan 2020 22:22:53 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 8853EE06B1; Sun, 26 Jan 2020 23:22:53 +0100 (CET)
Date:   Sun, 26 Jan 2020 23:22:53 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>,
        Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200126222253.GX22304@unicorn.suse.cz>
References: <20200123130541.30473-1-leon@kernel.org>
 <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
 <20200126194110.GA3870@unreal>
 <20200126124957.78a31463@cakuba>
 <20200126210850.GB3870@unreal>
 <31c6c46a-63b2-6397-5c75-5671ee8d41c3@pensando.io>
 <20200126212424.GD3870@unreal>
 <0755f526-73cb-e926-2785-845fec0f51dd@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0755f526-73cb-e926-2785-845fec0f51dd@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 02:12:38PM -0800, Shannon Nelson wrote:
> On 1/26/20 1:24 PM, Leon Romanovsky wrote:
> > On Sun, Jan 26, 2020 at 01:17:52PM -0800, Shannon Nelson wrote:
> > > On 1/26/20 1:08 PM, Leon Romanovsky wrote:
> > > > The long-standing policy in kernel that we don't really care about
> > > > out-of-tree code.
> > > That doesn't mean we need to be aggressively against out-of-tree code.  One
> > > of the positive points about Linux and loadable modules has always been the
> > > flexibility that allows and encourages innovation, and helps enable more
> > > work and testing before a driver can become a fully-fledged part of the
> > > kernel.  This move actively discourages part of that flexibility and I think
> > > it is breaking part of the usefulness of modules.
> > You are mixing definitions, nothing stops those people to innovate and
> > develop their code inside kernel and as standalone modules too.
> > 
> > It just stops them to put useless driver version string inside ethtool.
> > If they feel that their life can't be without something from 90s, they
> > have venerable MODULE_VERSION() macro to print anything they want.
> > 
> Part of the pain of supporting our users is getting them to give us useful
> information about their problem.  The more commands I need them to run to
> get information about the environment, the less likely I will get anything
> useful.  We've been training our users over the years to use "ethtool -i" to
> get a good chunk of that info, with the knowledge that the driver version is
> only a hint, based upon the distro involved.  I don't want to lose that
> hint.  If anything, I'd prefer that we added a field for UTS_RELEASE in the
> ethtool output, but I know that's too much to ask.

At the same time, I've been trying to explain both our L1/L2 support
guys and our customers that "driver version" information reported by
"ethtool -i" is almost useless and that if they really want to identify
driver version, they should rather use srcversion as reported by modinfo
or sysfs.

Michal
