Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9340B182CAB
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 10:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgCLJpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 05:45:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:40496 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgCLJpi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 05:45:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 32E4AB00A;
        Thu, 12 Mar 2020 09:45:33 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 37823E0C79; Thu, 12 Mar 2020 10:45:32 +0100 (CET)
Date:   Thu, 12 Mar 2020 10:45:32 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 05/15] ethtool: set netdev features with
 FEATURES_SET request
Message-ID: <20200312094532.GM8012@unicorn.suse.cz>
References: <cover.1583962006.git.mkubecek@suse.cz>
 <4fda0f27da984254c3df3c9e58751134967036c9.1583962006.git.mkubecek@suse.cz>
 <20200311155632.4521c71b@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311155632.4521c71b@kicinski-fedora-PC1C0HJN>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 03:56:32PM -0700, Jakub Kicinski wrote:
> On Wed, 11 Mar 2020 22:40:28 +0100 (CET) Michal Kubecek wrote:
> > +	if (!(req_info.flags & ETHTOOL_FLAG_OMIT_REPLY)) {
> > +		bool compact = req_info.flags & ETHTOOL_FLAG_COMPACT_BITSETS;
> 
> is req_info->flags validated anywhere to make sure users get an error
> when they set a bit unrecognized by the kernel? :S

It's not and it it definitely should be. As this also affects code which
is already in mainline, I'll send a patch with the check for net tree.

Michal
