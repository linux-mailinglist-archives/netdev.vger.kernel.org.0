Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8D5107599
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 17:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfKVQRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 11:17:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:37590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbfKVQRC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 11:17:02 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 292DB2071C;
        Fri, 22 Nov 2019 16:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574439421;
        bh=CfHjawKN9UV9xUzsgscR1kzkY01iaAiALZsvPAqbBMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L1kvx0v2vmN4e698N0cKxdtkaRV4YB2sehEdvgfovDd0fdAohSrZO8vSTsoxR/Hw2
         68tcrhrFOdsPGWJhgEQEDYFJ/Ht13qg/evGfjBx6OOpnEoJ7RnxWcqzpjj/WrnjFnv
         bZTvAs9bP81/4GmxAB0sye1M7YWV4YhC77v9kRPc=
Date:   Fri, 22 Nov 2019 18:16:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 1/4] net/core: Add support for getting VF GUIDs
Message-ID: <20191122161658.GD136476@unreal>
References: <20191114133126.238128-1-leon@kernel.org>
 <20191114133126.238128-3-leon@kernel.org>
 <0e99c61b-ee89-a2cb-6f7a-b0ab5d06249c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e99c61b-ee89-a2cb-6f7a-b0ab5d06249c@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 05:54:30PM -0700, David Ahern wrote:
> On 11/14/19 6:31 AM, Leon Romanovsky wrote:
> > From: Danit Goldberg <danitg@mellanox.com>
> >
> >
> > Introduce a new ndo: ndo_get_vf_guid, to get from the net
> > device the port and node GUID.
> >
> > New applications can choose to use this interface to show
> > GUIDs with iproute2 with commands such as:
> >
> > - ip link show ib4
> > ib4: <BROADCAST,MULTICAST> mtu 4092 qdisc noop state DOWN mode DEFAULT group default qlen 256
> > link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
> > vf 0     link/infiniband 00:00:0a:2d:fe:80:00:00:00:00:00:00:ec:0d:9a:03:00:44:36:8d brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff,
> > spoof checking off, NODE_GUID 22:44:33:00:33:11:00:33, PORT_GUID 10:21:33:12:00:11:22:10, link-state disable, trust off, query_rss off
> >
> > Signed-off-by: Danit Goldberg <danitg@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  include/linux/netdevice.h |  4 ++++
> >  net/core/rtnetlink.c      | 11 +++++++++++
> >  2 files changed, 15 insertions(+)
> >
>
>
> LGTM
>
> Acked-by: David Ahern <dsahern@gmail.com>

Thanks a lot.

>
>
