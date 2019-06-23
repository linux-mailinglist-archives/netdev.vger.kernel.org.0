Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A90084FD8B
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 20:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfFWS1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 14:27:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43524 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfFWS1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 14:27:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1BAF126A7C51;
        Sun, 23 Jun 2019 11:27:16 -0700 (PDT)
Date:   Sun, 23 Jun 2019 11:27:16 -0700 (PDT)
Message-Id: <20190623.112716.2247998657903069805.davem@davemloft.net>
To:     tracywwnj@gmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, kafai@fb.com,
        dsahern@gmail.com, maheshb@google.com, weiwan@google.com
Subject: Re: [PATCH v3 net-next 0/5] ipv6: avoid taking refcnt on dst
 during route lookup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190621003641.168591-1-tracywwnj@gmail.com>
References: <20190621003641.168591-1-tracywwnj@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Jun 2019 11:27:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <tracywwnj@gmail.com>
Date: Thu, 20 Jun 2019 17:36:36 -0700

> v2->v3:
> - Handled fib6_rule_lookup() when CONFIG_IPV6_MULTIPLE_TABLES is not
>   configured in patch 03 (suggested by David Ahern)
> - Removed the renaming of l3mdev_link_scope_lookup() in patch 05
>   (suggested by David Ahern)
> - Moved definition of ip6_route_output_flags() from an inline function
>   in /net/ipv6/route.c to net/ipv6/route.c in order to address kbuild
>   error in patch 05

I'll give David A. a chance to review this before applying.
