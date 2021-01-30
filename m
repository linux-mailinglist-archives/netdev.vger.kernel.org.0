Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A49309249
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 06:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbhA3Fl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 00:41:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233826AbhA3FiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 00:38:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98D0164DDE;
        Sat, 30 Jan 2021 05:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611985063;
        bh=O7gUiLmThPz3xqnmNCVRJznYl1bUntj77i5W4NKUpg0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H+WWnduVgWEoI/Y94mLSkT9rzX342RY/50HH5Hpc7idI1m+eOeynVjQNWFddUHtwt
         Nun1L3YBvUelcBUKJ2GhvRGtnkgAL+bWK4WeFUrNkVuKapJRM7JlzJo8AhwT17j/SN
         h41lzk2KRqrxz2YgONx3xYiJyRl2T8tUAlWTLMQ910f+72unp3ZEuLJXQkgdJKPZwP
         Z8SN7y0AypGI/WX7cX9Ehe1x/Pdqu8wBu3OIsFsceYlA9weuzQOwZHo0gLin/uZy0g
         77ctOhwKzGgZ5Mi/nMSW8oSVDX8N2AYRsebjSNCjzhKu+yp0Y7BW+bhdUaURFnRomp
         SidOnHWo/yXfw==
Date:   Fri, 29 Jan 2021 21:37:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        <netdev@vger.kernel.org>, <roopa@nvidia.com>,
        <bridge@lists.linux-foundation.org>, <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/2] net: bridge: drop hosts limit sysfs and
 add a comment
Message-ID: <20210129213742.7da125ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e0c38c2a-3e72-2ee0-c48d-900e63227528@nvidia.com>
References: <20210129115142.188455-1-razor@blackwall.org>
        <e0c38c2a-3e72-2ee0-c48d-900e63227528@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 13:55:24 +0200 Nikolay Aleksandrov wrote:
> On 29/01/2021 13:51, Nikolay Aleksandrov wrote:
> > From: Nikolay Aleksandrov <nikolay@nvidia.com>
> > 
> > Hi,
> > As recently discussed[1] we should stop extending the bridge sysfs
> > support for new options and move to using netlink only, so patch 01
> > drops the recently added hosts limit sysfs support which is still in
> > net-next only and patch 02 adds comments in br_sysfs_br/if.c to warn
> > against adding new sysfs options.
> > 
> > Thanks,
> >  Nik
> > 
> > Nikolay Aleksandrov (2):
> >   net: bridge: mcast: drop hosts limit sysfs support
> >   net: bridge: add warning comments to avoid extending sysfs
> > 
> >  net/bridge/br_sysfs_br.c |  4 ++++
> >  net/bridge/br_sysfs_if.c | 30 ++++--------------------------
> >  2 files changed, 8 insertions(+), 26 deletions(-)
> >   
> 
> Oops :) the [1] addendum should be:
> 
> [1] https://lore.kernel.org/netdev/20210128105201.7c6bed82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/T/#mda7265b2e57b52bdab863f286efa85291cf83822
> 
> Since this is in the cover letter I don't think v2 is needed.
> Please let me know if you'd like me to resend.

Seems that vger ate the cover letter completely, but not the patches,
so I was putting the merge commit message together by hand, anyway :)

Applied, thanks!
