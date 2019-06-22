Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE9B74F2F3
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 03:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbfFVBAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 21:00:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47376 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfFVBAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 21:00:16 -0400
Received: from localhost (unknown [50.234.174.228])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A96214DB6DF3;
        Fri, 21 Jun 2019 18:00:16 -0700 (PDT)
Date:   Fri, 21 Jun 2019 21:00:13 -0400 (EDT)
Message-Id: <20190621.210013.2186064936627293600.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, cpaasch@apple.com
Subject: Re: [PATCH net] tcp: refine memory limit test in tcp_fragment()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190621130955.147974-1-edumazet@google.com>
References: <20190621130955.147974-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Jun 2019 18:00:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 21 Jun 2019 06:09:55 -0700

> tcp_fragment() might be called for skbs in the write queue.
> 
> Memory limits might have been exceeded because tcp_sendmsg() only
> checks limits at full skb (64KB) boundaries.
> 
> Therefore, we need to make sure tcp_fragment() wont punish applications
> that might have setup very low SO_SNDBUF values.
> 
> Fixes: f070ef2ac667 ("tcp: tcp_fragment() should apply sane memory limits")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Christoph Paasch <cpaasch@apple.com>

Applied and queued up for -stable.
