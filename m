Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC3F2852C8
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 22:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbgJFUA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 16:00:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:42144 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgJFUA5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 16:00:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 68A90AB54;
        Tue,  6 Oct 2020 20:00:56 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 2A555603A9; Tue,  6 Oct 2020 22:00:56 +0200 (CEST)
Date:   Tue, 6 Oct 2020 22:00:56 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH ethtool-next v2 5/6] netlink: use policy dumping to check
 if stats flag is supported
Message-ID: <20201006200056.o62d6fecypqxzprp@lion.mk-sys.cz>
References: <20201006150425.2631432-1-kuba@kernel.org>
 <20201006150425.2631432-6-kuba@kernel.org>
 <20201006193913.GA2932230@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006193913.GA2932230@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 10:39:13PM +0300, Ido Schimmel wrote:
> On Tue, Oct 06, 2020 at 08:04:24AM -0700, Jakub Kicinski wrote:
> > Older kernels don't support statistics, to avoid retries
> > make use of netlink policy dumps to figure out which
> > flags kernel actually supports.
> 
> Thanks for working on this, Jakub.
> 
> Michal, should I try something similar for the legacy flag we have been
> discussing earlier this week [1]?
> 
> [1] https://lore.kernel.org/netdev/20201005074600.xkbomksbbuliuyft@lion.mk-sys.cz/#t

Yes, using the policy dump will be the way to go. I wanted to come with
something myself but we have a virtual conference this week and today
an urgent request took the spare time I had in the morning.

Michal
