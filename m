Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F14368942
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 01:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236915AbhDVXNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 19:13:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:37228 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230353AbhDVXNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 19:13:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0A8AEB17E;
        Thu, 22 Apr 2021 23:12:31 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id D82566074E; Fri, 23 Apr 2021 01:12:30 +0200 (CEST)
Date:   Fri, 23 Apr 2021 01:12:30 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool-next 0/7] ethtool: support FEC and standard stats
Message-ID: <20210422231230.elg3iqlcehra6lpz@lion.mk-sys.cz>
References: <20210420003112.3175038-1-kuba@kernel.org>
 <YIE4gZWsjrHNrZGA@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIE4gZWsjrHNrZGA@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 11:49:05AM +0300, Ido Schimmel wrote:
> On Mon, Apr 19, 2021 at 05:31:05PM -0700, Jakub Kicinski wrote:
> > This series adds support for FEC requests via netlink
> > and new "standard" stats.
> 
> Jakub, you wrote "ethtool-next" in subject, but I only managed to apply
> the patches to the master branch.

That's my fault. When I decided to skip version 5.12 because there were
only few minor commits, I should have merged next into master. I'll do
it tomorrow.

> Michal, I assume we are expected to send new features to next? If so,
> can you please update the web page [1] ?

I don't insist on the strict division between fixes and features. The
main purpose of next branch is to queue changes to be merged after the
closest release because their kernel counterpart is in net-next and is
not going to be present in the closest kernel.

On the other hand, I also plan to use it for stuff which feels too
intrusive to be merged into master shortly before a new release. Thanks
for the reminder, I'll review the web page and update the information.

Michal

> Thanks
> 
> [1] https://mirrors.edge.kernel.org/pub/software/network/ethtool/devel.html
