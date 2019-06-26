Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C60956E58
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfFZQIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:08:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37166 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZQIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:08:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E9C8E14A8CC77;
        Wed, 26 Jun 2019 09:08:50 -0700 (PDT)
Date:   Wed, 26 Jun 2019 09:08:50 -0700 (PDT)
Message-Id: <20190626.090850.689822675524126526.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, sbrivio@redhat.com,
        dsahern@gmail.com
Subject: Re: [PATCH net] ipv6: fix suspicious RCU usage in rt6_dump_route()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190626100528.218097-1-edumazet@google.com>
References: <20190626100528.218097-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 09:08:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 26 Jun 2019 03:05:28 -0700

> syzbot reminded us that rt6_nh_dump_exceptions() needs to be called
> with rcu_read_lock()
> 
> net/ipv6/route.c:1593 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
...
> Fixes: 1e47b4837f3b ("ipv6: Dump route exceptions if requested")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>

Applied.
