Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8055D4C2D4
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 23:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbfFSVPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 17:15:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40218 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfFSVPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 17:15:12 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4ADB4146D811B;
        Wed, 19 Jun 2019 14:15:12 -0700 (PDT)
Date:   Wed, 19 Jun 2019 17:15:11 -0400 (EDT)
Message-Id: <20190619.171511.53176507747555774.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] ipv6: Default fib6_type to RTN_UNICAST when not set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190619175024.17936-1-dsahern@kernel.org>
References: <20190619175024.17936-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 14:15:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed, 19 Jun 2019 10:50:24 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> A user reported that routes are getting installed with type 0 (RTN_UNSPEC)
> where before the routes were RTN_UNICAST. One example is from accel-ppp
> which apparently still uses the ioctl interface and does not set
> rtmsg_type. Another is the netlink interface where ipv6 does not require
> rtm_type to be set (v4 does). Prior to the commit in the Fixes tag the
> ipv6 stack converted type 0 to RTN_UNICAST, so restore that behavior.
> 
> Fixes: e8478e80e5a7 ("net/ipv6: Save route type in rt6_info")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied and queued up for -stable, thanks David.
