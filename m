Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC155E660
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfGCOSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:18:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:41582 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726473AbfGCOSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 10:18:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C2AA1AEBB;
        Wed,  3 Jul 2019 14:18:46 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 7126AE0159; Wed,  3 Jul 2019 16:18:46 +0200 (CEST)
Date:   Wed, 3 Jul 2019 16:18:46 +0200
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
Subject: Re: [PATCH net-next v6 07/15] ethtool: support for netlink
 notifications
Message-ID: <20190703141846.GM20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <4dcac81783de8686edefa262a1db75f9e961b123.1562067622.git.mkubecek@suse.cz>
 <ea84d738346b96b81550e0fd0a6c715faa323061.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea84d738346b96b81550e0fd0a6c715faa323061.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 03:39:54PM +0200, Johannes Berg wrote:
> On Tue, 2019-07-02 at 13:50 +0200, Michal Kubecek wrote:
> > 
> > +static bool ethnl_ok __read_mostly;
> 
> Not sure it makes a big difference, but it could probably be
> __ro_after_init instead?

Yes, that's more fitting; the flag is initialized to false, changes to
true once ethtool netlink is ready and never changes back. I wasn't
aware of __ro_after_init annotation.

Michal
