Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5506E2C7309
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389380AbgK1Vt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387602AbgK1TuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 14:50:18 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4153721D40;
        Sat, 28 Nov 2020 19:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606592978;
        bh=UvzIRuOEnhxcRWvQWY2rH7i21CBVTaYaXaK8I49Jg8A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f4NW6wnCPGx60/u0ox2g2WF9RO1RrPk7O5NYxxR1Cv6YchviTYw5i7bM/mj6PchjP
         3RDUbydlc3DLIZqKwJ/CLoHN3W8UhNDCDTFTJ6jA6mST3KCP4uyD7IEtbgTDqcJdqx
         e3cKXnb7+OJiTWmQX7pI1TryydoHjDDl8Ri2W/hs=
Date:   Sat, 28 Nov 2020 11:49:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Antoine Tenart <atenart@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, roopa@nvidia.com, nikolay@nvidia.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, sbrivio@redhat.com
Subject: Re: [PATCH net-next] netfilter: bridge: reset skb->pkt_type after
 NF_INET_POST_ROUTING traversal
Message-ID: <20201128114937.55103f65@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201128095929.GI2730@breakpoint.cc>
References: <20201123174902.622102-1-atenart@kernel.org>
        <20201123183253.GA2730@breakpoint.cc>
        <20201127160650.1f36b889@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201128095929.GI2730@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Nov 2020 10:59:29 +0100 Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 23 Nov 2020 19:32:53 +0100 Florian Westphal wrote:  
> > > That comment is 18 years old, safe bet noone thought of
> > > ipv6-in-tunnel-interface-added-as-bridge-port back then.
> > > 
> > > Reviewed-by: Florian Westphal <fw@strlen.de>  
> > 
> > Sounds like a fix. Probably hard to pin point which commit to blame,
> > but this should go to net, not net-next, right?  
> 
> The commit predates git history, so probably a good idea to add
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> 
> ... and apply it to net tree.

Done, thanks!
