Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51BB4174BF5
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 06:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCAF4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 00:56:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38960 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgCAF4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 00:56:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 88F7515BDA709;
        Sat, 29 Feb 2020 21:56:36 -0800 (PST)
Date:   Sat, 29 Feb 2020 21:56:35 -0800 (PST)
Message-Id: <20200229.215635.2114179824389352796.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, jishi@redhat.com,
        roopa@cumulusnetworks.com
Subject: Re: [PATCHv2 net] net/ipv6: use configured metric when add peer
 route
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200229092713.29433-1-liuhangbin@gmail.com>
References: <20200228091858.19729-1-liuhangbin@gmail.com>
        <20200229092713.29433-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Feb 2020 21:56:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Sat, 29 Feb 2020 17:27:13 +0800

> When we add peer address with metric configured, IPv4 could set the dest
> metric correctly, but IPv6 do not. e.g.
> 
> ]# ip addr add 192.0.2.1 peer 192.0.2.2/32 dev eth1 metric 20
> ]# ip route show dev eth1
> 192.0.2.2 proto kernel scope link src 192.0.2.1 metric 20
> ]# ip addr add 2001:db8::1 peer 2001:db8::2/128 dev eth1 metric 20
> ]# ip -6 route show dev eth1
> 2001:db8::1 proto kernel metric 20 pref medium
> 2001:db8::2 proto kernel metric 256 pref medium
> 
> Fix this by using configured metric instead of default one.
> 
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Fixes: 8308f3ff1753 ("net/ipv6: Add support for specifying metric of connected routes")
> Reviewed-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> ---
> v2: fix metric typo

Applied and queued up for -stable, thank you.
