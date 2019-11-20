Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D160F1044DD
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfKTUTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:19:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59382 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfKTUTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:19:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED2AC14C1A6BC;
        Wed, 20 Nov 2019 12:19:00 -0800 (PST)
Date:   Wed, 20 Nov 2019 12:19:00 -0800 (PST)
Message-Id: <20191120.121900.1899061409098536656.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] ipv6/route: return if there is no fib_nh_gw_family
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191120073906.15258-1-liuhangbin@gmail.com>
References: <20191120073906.15258-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 12:19:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Wed, 20 Nov 2019 15:39:06 +0800

> Previously we will return directly if (!rt || !rt->fib6_nh.fib_nh_gw_family)
> in function rt6_probe(), but after commit cc3a86c802f0
> ("ipv6: Change rt6_probe to take a fib6_nh"), the logic changed to
> return if there is fib_nh_gw_family.
> 
> Fixes: cc3a86c802f0 ("ipv6: Change rt6_probe to take a fib6_nh")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied and queued up for -stable.
