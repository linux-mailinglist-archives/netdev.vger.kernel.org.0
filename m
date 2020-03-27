Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39FB2195EFC
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgC0ToB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:44:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:60384 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgC0ToA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 15:44:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AB9D8B241;
        Fri, 27 Mar 2020 19:43:58 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E37B2E009C; Fri, 27 Mar 2020 20:43:54 +0100 (CET)
Date:   Fri, 27 Mar 2020 20:43:54 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 11/12] ethtool: add timestamping related
 string sets
Message-ID: <20200327194354.GI31519@unicorn.suse.cz>
References: <cover.1585316159.git.mkubecek@suse.cz>
 <9115b20867b6914eec70a58f3ba3b9deef4eb2b0.1585316159.git.mkubecek@suse.cz>
 <20200327185344.GA28023@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327185344.GA28023@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 11:53:44AM -0700, Richard Cochran wrote:
> On Fri, Mar 27, 2020 at 03:08:12PM +0100, Michal Kubecek wrote:
> > +const char ts_tx_type_names[][ETH_GSTRING_LEN] = {
> > +	[HWTSTAMP_TX_OFF]		= "off",
> > +	[HWTSTAMP_TX_ON]		= "on",
> > +	[HWTSTAMP_TX_ONESTEP_SYNC]	= "one-step-sync",
> > +	[HWTSTAMP_TX_ONESTEP_P2P]	= "one-step-p2p",
> > +};
> 
> Suggest "onestep-sync" and "onestep-p2p".

I copied "one-step-sync" from (userspace) ethtool but I guess we don't
have to be 100% backward compatible. It would match the constant name
better without dash.

Michal

> Acked-by: Richard Cochran <richardcochran@gmail.com>
