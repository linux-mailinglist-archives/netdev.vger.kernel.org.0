Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9862FD9F4
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 20:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392545AbhATTos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 14:44:48 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34393 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391993AbhATTok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 14:44:40 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 283E65C01FA;
        Wed, 20 Jan 2021 14:43:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 20 Jan 2021 14:43:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gG8Ap4
        umiPKqAuQtN7UMWXbsCAQLVHXt0RQP7fe+h1Y=; b=aBUoiKUhXj9Mxr5C2dPYpX
        QSkJtEoPOzb+S+zNUCDsW9bAp5+tZMvA1MHeGkCeDOYupTgdLSMJl5l7b60sFd/d
        w1WSm/KBs+5awQ2y9Ssehwt4HxYYXGr/hQRkjICj+SXfhhRjMUZLNpT8r7Yq0s4V
        90pJ8Mje9FatmJnblsGhRKeercKt642RnswLa7DBGaK0d4+8Q9e+gxTpDrWx8n3N
        7RZxKQ8A0pye+97pCAzFGEVqEv+xn3Q/ADYuGKN/iJJ1fWQaflCV06Uyr0HL2Yg9
        mIRQICw3u1FOOKMTTUSxVgJVSVKPDHYSg7xfZZ22RJzZGyblmKgLUjgfGwAJSu6g
        ==
X-ME-Sender: <xms:5IcIYMzzUwFoc-AV6XaAAOVEMupRWz6iAOwZMZO00LSWq6nhmfp0fg>
    <xme:5IcIYMkCg2cqCzzeG9rO_jFgF75HMrKh5-H0XGHbSo0Z8lX4Sj7TFFzOrn5A-0DMK
    6ZyeDWGSCnuKGc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvgddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:5IcIYBHPk7VQfF5mz0zEH9yQKmfzJnsAYEuyWCTEvAJ-R_JK_2QVEg>
    <xmx:5IcIYMUPOJY282ENoSaxtnWZGcDr8u2I7_YP45tUvMCkmMQnQxb8LA>
    <xmx:5IcIYAyr7ufJQ-ABy8GPw0It9pqqUVdU82ecKYJU9dMxdIca-CwqvA>
    <xmx:5IcIYBqeARf7bPbXUHNFBG871O8ktnE04pCCkI-HQT0w1q4cIJWkdQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 97F0B108005B;
        Wed, 20 Jan 2021 14:43:31 -0500 (EST)
Date:   Wed, 20 Jan 2021 21:43:28 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] selftests/net: set link down before enslave
Message-ID: <20210120194328.GA2628348@shredder.lan>
References: <20210120102947.2887543-1-liuhangbin@gmail.com>
 <20210120104210.GA2602142@shredder.lan>
 <20210120143847.GI1421720@Leo-laptop-t470s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120143847.GI1421720@Leo-laptop-t470s>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 10:38:47PM +0800, Hangbin Liu wrote:
> Hi Ido,
> 
> On Wed, Jan 20, 2021 at 12:42:10PM +0200, Ido Schimmel wrote:
> > > diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
> > > index c9ce3dfa42ee..a26fddc63992 100755
> > > --- a/tools/testing/selftests/net/rtnetlink.sh
> > > +++ b/tools/testing/selftests/net/rtnetlink.sh
> > > @@ -1205,6 +1205,8 @@ kci_test_bridge_parent_id()
> > >  	dev20=`ls ${sysfsnet}20/net/`
> > >  
> > >  	ip link add name test-bond0 type bond mode 802.3ad
> > > +	ip link set dev $dev10 down
> > > +	ip link set dev $dev20 down
> > 
> > But these netdevs are created with their administrative state set to
> > 'DOWN'. Who is setting them to up?
> 
> Would you please point me where we set the state to 'DOWN'? Cause on my
> host it is init as UP:
> 
> ++ ls /sys/bus/netdevsim/devices/netdevsim10/net/
> + dev10=eth3
> ++ ls /sys/bus/netdevsim/devices/netdevsim20/net/
> + dev20=eth4
> + ip link add name test-bond0 type bond mode 802.3ad
> + ip link show eth3
> 66: eth3: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>     link/ether 1e:52:27:5f:a5:3c brd ff:ff:ff:ff:ff:ff

I didn't have time to look into this today, but I suspect the problem is
either:

1. Some interface manager on your end that is setting these interfaces
up after they are created

2. A bug in netdevsim that does not initialize the carrier to off.
Maybe try with this patch (didn't test):

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index aec92440eef1..1e0dc298bf20 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -312,6 +312,8 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 
        nsim_ipsec_init(ns);
 
+       netif_carrier_off(dev);
+
        err = register_netdevice(dev);
        if (err)
                goto err_ipsec_teardown;

> 
> # uname -r
> 5.11.0-rc3+
> 
> Thanks
> Hangbin
