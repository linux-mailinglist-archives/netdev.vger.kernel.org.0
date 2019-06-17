Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1DBC47A2E
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 08:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbfFQGqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 02:46:49 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42755 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbfFQGqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 02:46:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6B074221C2;
        Mon, 17 Jun 2019 02:46:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 Jun 2019 02:46:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ve0tsH
        gPTAhnVQgn96czieF4coBgYLk0PwHhn3on3Wo=; b=XFLsvrXC7EPWIMJ+U1neBn
        o4Ea2de7ufcnhGRQPBk+nIpHZoJ82xRDqPwwwGEnUGTGwTxDTl17Hutk9PFToCl8
        VRgy1rUH4NmEGPWEM37i4lFSyzKdcCE+Ft7M4C+JSpjLC/uAnlVvmQTJ838TZLIu
        8VuHphqUIbIwhAfHTHqu+TeBvO96nkbiCxU6XzkZ1AabRL5XBoJr04bJW510V4OF
        nG7JYWVH2YvrwOyB5VlRepFNbgFSrQjPhwCjA1BqZW05Pegocf/+vzYisic6FxxQ
        +1KYZGYbiw+5qaj0gKA58YZ9cA9mjDHKbW90vAF70Yzp3kd851sUGSGa2pHgOvqA
        ==
X-ME-Sender: <xms:VzcHXXMT7npV5BQw8UrDS2i8VOur9qQuyDXe74neXBMFImXUFf7ErQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeiiedguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:VzcHXWOPAIZzJU42nrphuyhRyAXvvBxuOxxQbftuQt7O5eovGH64tw>
    <xmx:VzcHXRTs_llZ80aTr1yCzq9jUOftE1mUCNob_CRkdjsh-bP1STr5rg>
    <xmx:VzcHXQCGE2OOoIPwpya9ArzlSk5gtXUGZws3bMLNfZ4guovA0ex7iQ>
    <xmx:WDcHXTfdl-tey3WnHgg7tZuPwzL9ScsDrYQFOIg3AXB0ZUyrGyJGyQ>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5AB88380088;
        Mon, 17 Jun 2019 02:46:47 -0400 (EDT)
Date:   Mon, 17 Jun 2019 09:46:45 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 03/17] ipv6: Extend notifier info for multipath
 routes
Message-ID: <20190617064645.GB3810@splinter>
References: <20190615140751.17661-1-idosch@idosch.org>
 <20190615140751.17661-4-idosch@idosch.org>
 <0bd8a588-0c6a-de20-c2d4-39e46e433a7e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bd8a588-0c6a-de20-c2d4-39e46e433a7e@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 16, 2019 at 07:22:44PM -0600, David Ahern wrote:
> On 6/15/19 8:07 AM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@mellanox.com>
> > 
> > Extend the IPv6 FIB notifier info with number of sibling routes being
> > notified.
> > 
> > This will later allow listeners to process one notification for a
> > multipath routes instead of N, where N is the number of nexthops.
> > 
> > Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> > Acked-by: Jiri Pirko <jiri@mellanox.com>
> > ---
> >  include/net/ip6_fib.h |  7 +++++++
> >  net/ipv6/ip6_fib.c    | 17 +++++++++++++++++
> >  2 files changed, 24 insertions(+)
> > 
> 
> The need for a second notifier stems from the append case? versus using
> call_fib6_entry_notifiers and letting the nsiblings fallout from
> rt->fib6_nsiblings? The append case is a weird thing for userspace to
> maintain order, but it seems like the offload case should not care.

It's not a second notifier, it's just another wrapper around
call_fib6_notifiers().

Yes, it's needed for append. The notification is sent after the route
was appended, so reading 'rt->fib6_nsiblings' would indicate to
listeners that 'rt->fib6_nsiblings + 1' routes need to be programmed,
whereas only one needs to be.

> Also, .multipath_rt seems redundant with .nsiblings > 1

Yes, I wanted to make it more explicit that a multipath route is
notified. I'll remove it.
