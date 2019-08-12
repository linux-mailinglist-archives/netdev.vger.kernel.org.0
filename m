Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3768B895E7
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbfHLECU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:02:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38256 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbfHLECT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:02:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F826133F323A;
        Sun, 11 Aug 2019 21:02:19 -0700 (PDT)
Date:   Sun, 11 Aug 2019 21:02:18 -0700 (PDT)
Message-Id: <20190811.210218.1719186095860421886.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, dsahern@gmail.com
Subject: Re: [PATCH net] netdevsim: Restore per-network namespace
 accounting for fib entries
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806191517.8713-1-dsahern@kernel.org>
References: <20190806191517.8713-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 21:02:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Tue,  6 Aug 2019 12:15:17 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Prior to the commit in the fixes tag, the resource controller in netdevsim
> tracked fib entries and rules per network namespace. Restore that behavior.
> 
> Fixes: 5fc494225c1e ("netdevsim: create devlink instance per netdevsim instance")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, thanks for bringing this to our attention and fixing it David.

Jiri, I disagree you on every single possible level.

If you didn't like how netdevsim worked in this area the opportunity to do
something about it was way back when it went in.

No matter how completely busted or disagreeable an interface is, once we have
committed it to a release (and in particular people are knowingly using and
depending upon it) you cannot break it.

It doesn't matter how much you disagree with something, you cannot break it
when it's out there and actively in use.

Do you have any idea how much stuff I'd like to break because I think the
design turned out to be completely wrong?  But I can't.
