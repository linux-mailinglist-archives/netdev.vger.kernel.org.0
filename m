Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D48C1B9405
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 22:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgDZUuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 16:50:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:53722 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgDZUuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 16:50:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BA108ABBD;
        Sun, 26 Apr 2020 20:50:16 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id D6AA2602EE; Sun, 26 Apr 2020 22:50:16 +0200 (CEST)
Date:   Sun, 26 Apr 2020 22:50:16 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next v1 3/9] net: ethtool: netlink: Add support for
 triggering a cable test
Message-ID: <20200426205016.GE23225@lion.mk-sys.cz>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200425180621.1140452-4-andrew@lunn.ch>
 <20200426193634.GB23225@lion.mk-sys.cz>
 <20200426203833.GB1183480@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426203833.GB1183480@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 10:38:33PM +0200, Andrew Lunn wrote:
> > 
> > As you don't send a reply message, you don't need
> > ETHTOOL_MSG_CABLE_TEST_ACT_REPLY either (we may introduce it later if
> > there is a reply message).
> 
> One thing i was thinking about is sending user space a cookie at this
> point, to help pair the request to the multicasted results. Then the
> reply would be useful.

You could use nl_set_extack_cookie_u64() for this - it would be similar
to the nl80211 use case it was introduced for. Of course, there may be
other reasons to introduce a reply, I only suggest not to add the
message type id until we actually use it.

Michal
