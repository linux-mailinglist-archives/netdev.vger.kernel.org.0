Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E952C7429
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732634AbgK1Vts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729820AbgK1Saj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 13:30:39 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8A0C02B8F7;
        Sat, 28 Nov 2020 01:59:36 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kix0r-0000Y4-87; Sat, 28 Nov 2020 10:59:29 +0100
Date:   Sat, 28 Nov 2020 10:59:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Antoine Tenart <atenart@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, roopa@nvidia.com, nikolay@nvidia.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, sbrivio@redhat.com
Subject: Re: [PATCH net-next] netfilter: bridge: reset skb->pkt_type after
 NF_INET_POST_ROUTING traversal
Message-ID: <20201128095929.GI2730@breakpoint.cc>
References: <20201123174902.622102-1-atenart@kernel.org>
 <20201123183253.GA2730@breakpoint.cc>
 <20201127160650.1f36b889@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127160650.1f36b889@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 23 Nov 2020 19:32:53 +0100 Florian Westphal wrote:
> > That comment is 18 years old, safe bet noone thought of
> > ipv6-in-tunnel-interface-added-as-bridge-port back then.
> > 
> > Reviewed-by: Florian Westphal <fw@strlen.de>
> 
> Sounds like a fix. Probably hard to pin point which commit to blame,
> but this should go to net, not net-next, right?

The commit predates git history, so probably a good idea to add
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

... and apply it to net tree.
