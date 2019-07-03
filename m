Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6D05DE1A
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 08:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfGCGfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 02:35:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:36294 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726236AbfGCGfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 02:35:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 32561AB8C;
        Wed,  3 Jul 2019 06:35:17 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 57F61E0159; Wed,  3 Jul 2019 08:35:14 +0200 (CEST)
Date:   Wed, 3 Jul 2019 08:35:14 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 04/15] ethtool: introduce ethtool netlink
 interface
Message-ID: <20190703063514.GH20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <e7fa3ad7e9cf4d7a8f9a2085e3166f7260845b0a.1562067622.git.mkubecek@suse.cz>
 <20190702182956.26435d63@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702182956.26435d63@cakuba.netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 06:29:56PM -0700, Jakub Kicinski wrote:
> On Tue,  2 Jul 2019 13:49:59 +0200 (CEST), Michal Kubecek wrote:
> > diff --git a/Documentation/networking/ethtool-netlink.txt b/Documentation/networking/ethtool-netlink.txt
> > new file mode 100644
> > index 000000000000..97c369aa290b
> > --- /dev/null
> > +++ b/Documentation/networking/ethtool-netlink.txt
> > @@ -0,0 +1,208 @@
> > +                        Netlink interface for ethtool
> > +                        =============================
> > +
> > +
> > +Basic information
> > +-----------------
> 
> Probably not a blocker for initial merging, but please note a TODO to
> convert the documentation to ReST.

Yes, I want to do that. What stopped me was that I wasn't sure what to
do with the message structure descriptions. I guess I'll leave them as
preformated text (literal paragraph) for now and leave finding something
more fancy for later.

Michal
