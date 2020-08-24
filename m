Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851F0250BED
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 00:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgHXWx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 18:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgHXWx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 18:53:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA5CC061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 15:53:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E100D12919711;
        Mon, 24 Aug 2020 15:37:10 -0700 (PDT)
Date:   Mon, 24 Aug 2020 15:53:56 -0700 (PDT)
Message-Id: <20200824.155356.1368492903180973758.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ipvlan: advertise link netns via netlink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200821174732.8181-1-ap420073@gmail.com>
References: <20200821174732.8181-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 15:37:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Fri, 21 Aug 2020 17:47:32 +0000

> Assign rtnl_link_ops->get_link_net() callback so that IFLA_LINK_NETNSID is
> added to rtnetlink messages.
> 
> Test commands:
>     ip netns add nst
>     ip link add dummy0 type dummy
>     ip link add ipvlan0 link dummy0 type ipvlan
>     ip link set ipvlan0 netns nst
>     ip netns exec nst ip link show ipvlan0
> 
> Result:
>     ---Before---
>     6: ipvlan0@if5: <BROADCAST,MULTICAST> ...
>         link/ether 82:3a:78:ab:60:50 brd ff:ff:ff:ff:ff:ff
> 
>     ---After---
>     12: ipvlan0@if11: <BROADCAST,MULTICAST> ...
>         link/ether 42:b1:ad:57:4e:27 brd ff:ff:ff:ff:ff:ff link-netnsid 0
>                                                            ~~~~~~~~~~~~~~
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied, thank you.
