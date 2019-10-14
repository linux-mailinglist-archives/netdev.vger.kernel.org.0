Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12447D5DD1
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 10:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbfJNIsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 04:48:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:45024 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730565AbfJNIsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 04:48:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C6D49ACFA;
        Mon, 14 Oct 2019 08:48:13 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D0998E3935; Mon, 14 Oct 2019 10:48:09 +0200 (CEST)
Date:   Mon, 14 Oct 2019 10:48:09 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 14/17] ethtool: set link settings with
 LINKINFO_SET request
Message-ID: <20191014084809.GA8493@unicorn.suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
 <aef31ba798d1cfa2ae92d333ad1547f4b528ffa8.1570654310.git.mkubecek@suse.cz>
 <20191012163309.GA2219@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191012163309.GA2219@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 06:33:09PM +0200, Jiri Pirko wrote:
> Wed, Oct 09, 2019 at 10:59:43PM CEST, mkubecek@suse.cz wrote:
> 
> [...]
> 
> >+static const struct nla_policy linkinfo_hdr_policy[ETHTOOL_A_HEADER_MAX + 1] = {
> >+	[ETHTOOL_A_HEADER_UNSPEC]		= { .type = NLA_REJECT },
> >+	[ETHTOOL_A_HEADER_DEV_INDEX]		= { .type = NLA_U32 },
> >+	[ETHTOOL_A_HEADER_DEV_NAME]		= { .type = NLA_NUL_STRING,
> >+						    .len = IFNAMSIZ - 1 },
> 
> Please make ETHTOOL_A_HEADER_DEV_NAME accept alternative names as well.
> Just s/IFNAMSIZ/ALTIFNAMSIZ should be enough.

Yes, definitely. I focused on (finally) submitting v7 so I didn't left
testing how it plays with altnames for later.

Michal 

> >+	[ETHTOOL_A_HEADER_GFLAGS]		= { .type = NLA_U32 },
> >+	[ETHTOOL_A_HEADER_RFLAGS]		= { .type = NLA_REJECT },
> >+};
> 
> [...]
