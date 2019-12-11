Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD3811A5CE
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 09:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfLKIYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 03:24:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:57576 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726988AbfLKIYz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 03:24:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8D17DADFF;
        Wed, 11 Dec 2019 08:24:53 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id AB3D8E0184; Wed, 11 Dec 2019 09:24:49 +0100 (CET)
Date:   Wed, 11 Dec 2019 09:24:49 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/5] ethtool: move string arrays into common
 file
Message-ID: <20191211082449.GC22512@unicorn.suse.cz>
References: <cover.1575982069.git.mkubecek@suse.cz>
 <dc15c317b1979aec8276cc2eb36f541f29a67b6e.1575982069.git.mkubecek@suse.cz>
 <b48794642a7982e2ba97b571fadfd90e08d64d02.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b48794642a7982e2ba97b571fadfd90e08d64d02.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 09:27:54PM +0100, Johannes Berg wrote:
> 
> > +++ b/net/ethtool/common.c
> > @@ -0,0 +1,85 @@
> > +// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
> 
> Is the Linux-syscall-note relevant here? This isn't really used for
> syscalls directly?
> 
> The exception says it's "to mark user space API (uapi) header files so
> they can be included into non GPL compliant user space application
> code".

I'm hardly an expert but almost all occurences of "Linux-syscall-note"
are in UAPI headers so you are most likely right. IIRC I copied the line
into include/uapi/linux/ethtool_netlink.h (which was the first new file)
from neighbor ethtool.h and then used the same in all other files.

I'll send a v3 with "GPL-2.0-only" (as there also seems to be a trend of
moving to SPDX v3 identifiers) in a moment.

Michal

> 
> > +++ b/net/ethtool/common.h
> > @@ -0,0 +1,17 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> 
> Same here.
> 
> johannes
> 
