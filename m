Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A343718F7
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 18:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhECQMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 12:12:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:42904 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231150AbhECQMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 12:12:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2CF5EB20F;
        Mon,  3 May 2021 16:11:16 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 04992607D5; Mon,  3 May 2021 18:11:16 +0200 (CEST)
Date:   Mon, 3 May 2021 18:11:15 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool-next v2 7/7] netlink: stats: add on --all-groups
 option
Message-ID: <20210503161115.3vjsn5uxm5wuj55k@lion.mk-sys.cz>
References: <20210422154050.3339628-1-kuba@kernel.org>
 <20210422154050.3339628-8-kuba@kernel.org>
 <20210502213640.lqykslgktlvjpaa5@lion.mk-sys.cz>
 <20210503085901.63cc248e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210503085901.63cc248e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 08:59:01AM -0700, Jakub Kicinski wrote:
> On Sun, 2 May 2021 23:36:40 +0200 Michal Kubecek wrote:
> > > Add a switch for querying all statistic groups available
> > > in the kernel.
> > > 
> > > To reject --groups and --all-groups being specified
> > > for one request add a concept of "parameter equivalency"  
> > 
> > I like the idea but the term "equivalency" may be a bit misleading.
> > Maybe "alternatives" would express the relation better.
> 
> Thanks for the review! I take it you mean to rename the code as well?
> Not just the commit message?

Yes, if we agree that the term is a bit misleading, I would rather see
the struct member renamed.

Michal
