Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB407195EFF
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgC0Tpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:45:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:33376 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgC0Tpe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 15:45:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F23D8AE2A;
        Fri, 27 Mar 2020 19:45:32 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id A4F3CE009C; Fri, 27 Mar 2020 20:45:32 +0100 (CET)
Date:   Fri, 27 Mar 2020 20:45:32 +0100
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
Subject: Re: [PATCH net-next v2 12/12] ethtool: provide timestamping
 information with TIMESTAMP_GET request
Message-ID: <20200327194532.GJ31519@unicorn.suse.cz>
References: <cover.1585316159.git.mkubecek@suse.cz>
 <5a3af8d892cafe9d9a2dc367e9ae463691261305.1585316159.git.mkubecek@suse.cz>
 <20200327185613.GB28023@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327185613.GB28023@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 11:56:13AM -0700, Richard Cochran wrote:
> On Fri, Mar 27, 2020 at 03:08:17PM +0100, Michal Kubecek wrote:
> > +/* TIMESTAMP */
> > +
> > +enum {
> > +	ETHTOOL_A_TIMESTAMP_UNSPEC,
> 
> I suggest using ETHTOOL_A_TSINFO_ throughout.  After all, this API
> does not provide time stamps, and we want to avoid confusion.

I'll send v3 with *_TSINFO_*, "onestep-sync" and "onestep-p2p".

Michal

> > +	ETHTOOL_A_TIMESTAMP_HEADER,			/* nest - _A_HEADER_* */
> > +	ETHTOOL_A_TIMESTAMP_TIMESTAMPING,		/* bitset */
> > +	ETHTOOL_A_TIMESTAMP_TX_TYPES,			/* bitset */
> > +	ETHTOOL_A_TIMESTAMP_RX_FILTERS,			/* bitset */
> > +	ETHTOOL_A_TIMESTAMP_PHC_INDEX,			/* u32 */
> > +
> > +	/* add new constants above here */
> > +	__ETHTOOL_A_TIMESTAMP_CNT,
> > +	ETHTOOL_A_TIMESTAMP_MAX = (__ETHTOOL_A_TIMESTAMP_CNT - 1)
> > +};
> 
> Acked-by: Richard Cochran <richardcochran@gmail.com>
