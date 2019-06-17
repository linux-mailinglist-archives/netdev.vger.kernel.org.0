Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5994447A1F
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 08:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfFQGh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 02:37:58 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44331 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725793AbfFQGh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 02:37:58 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D525D22027;
        Mon, 17 Jun 2019 02:37:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 17 Jun 2019 02:37:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=qo6bgz
        QLKA5jCHJ0UzyPN7D44/o2djiNjT0j5Rq0oK4=; b=ShVSio0u4C59H2s6JL7k4C
        l7SPEWZ8wj4+XSZzWZhcoFYk2Pp2iDw4Jok/YFVkOyVVXQPYeGnslik3oQpP9CZJ
        h2wcf9H86mBkac2hQwS5kZCuDj2arWei5DB8U+oQmD/B+B3hREKHHw5k+XChoq46
        zoNu8rQhZGxGO1Ez3muiooGbTvkiANBkN4/mbiozKgi5mIEMAkdSVrVnnBrEs1Vr
        n5GtvboJbgp+40//X7BajevcI1RXc6egodWFymLp8XBrIYF8vcJIDF32D4OM1z6M
        /jRkGsuQgAWLDBy41P5kB92N2kDkoNwwXZ0hFwQmfGJ55bcl6gq4E/QO3Wk1tSiA
        ==
X-ME-Sender: <xms:RDUHXR4uCrNUEK2QptLkm-SjXo8einkRnDwv075Oj77wIilSIbCgzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeiiedguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepud
    elfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:RDUHXYl5-cWfCLnT47-oZzk0cRrQnvT3xXQAosPHDRWntqMKj5I1zw>
    <xmx:RDUHXXwWF0aY-0QEAFkWsc_jPm_vMscHfdjS9n31DvdgEb-A-NbpEA>
    <xmx:RDUHXSMZWeg56U40YWmvrmJrwn5KDcy8-p3fSMqHwVYZKM_s1oYPXA>
    <xmx:RDUHXSLLXn5H-UEj8C_z9pnrQw1tYxezvdc6R5OXqRYvndjOpMhzQA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9025380059;
        Mon, 17 Jun 2019 02:37:55 -0400 (EDT)
Date:   Mon, 17 Jun 2019 09:37:53 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 02/17] netlink: Add field to skip in-kernel
 notifications
Message-ID: <20190617063753.GA3810@splinter>
References: <20190615140751.17661-1-idosch@idosch.org>
 <20190615140751.17661-3-idosch@idosch.org>
 <c4ff39a6-9604-6c3c-bf2b-a2c36471e84d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4ff39a6-9604-6c3c-bf2b-a2c36471e84d@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 16, 2019 at 07:17:26PM -0600, David Ahern wrote:
> On 6/15/19 8:07 AM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@mellanox.com>
> > 
> > The struct includes a 'skip_notify' flag that indicates if netlink
> > notifications to user space should be suppressed. As explained in commit
> > 3b1137fe7482 ("net: ipv6: Change notifications for multipath add to
> > RTA_MULTIPATH"), this is useful to suppress per-nexthop RTM_NEWROUTE
> > notifications when an IPv6 multipath route is added / deleted. Instead,
> > one notification is sent for the entire multipath route.
> > 
> > This concept is also useful for in-kernel notifications. Sending one
> > in-kernel notification for the addition / deletion of an IPv6 multipath
> > route - instead of one per-nexthop - provides a significant increase in
> > the insertion / deletion rate to underlying devices.
> > 
> > Add a 'skip_notify_kernel' flag to suppress in-kernel notifications.
> > 
> > Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> > Acked-by: Jiri Pirko <jiri@mellanox.com>
> > ---
> >  include/net/netlink.h | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> 
> Unfortunate a second flag is needed.

Initially I used the existing flag, but then I realized it's also used
to suppress notifications when a device goes down.

> Reviewed-by: David Ahern <dsahern@gmail.com>

Thanks
