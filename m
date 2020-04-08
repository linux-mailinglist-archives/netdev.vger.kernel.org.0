Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D661A1986
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 03:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgDHB0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 21:26:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44256 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgDHB0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 21:26:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5206F1210A3E3;
        Tue,  7 Apr 2020 18:26:03 -0700 (PDT)
Date:   Tue, 07 Apr 2020 18:26:02 -0700 (PDT)
Message-Id: <20200407.182602.1498281523766862127.davem@davemloft.net>
To:     code@timstallard.me.uk
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] net: icmp6: do not select saddr from iif when
 route has prefsrc set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200403202257.1167-1-code@timstallard.me.uk>
References: <20200403202257.1167-1-code@timstallard.me.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Apr 2020 18:26:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tim Stallard <code@timstallard.me.uk>
Date: Fri,  3 Apr 2020 21:22:57 +0100

> Since commit fac6fce9bdb5 ("net: icmp6: provide input address for
> traceroute6") ICMPv6 errors have source addresses from the ingress
> interface. However, this overrides when source address selection is
> influenced by setting preferred source addresses on routes.
> 
> This can result in ICMP errors being lost to upstream BCP38 filters
> when the wrong source addresses are used, breaking path MTU discovery
> and traceroute.
> 
> This patch sets the modified source address selection to only take place
> when the route used has no prefsrc set.
 ...
> Fixes: fac6fce9bdb5 ("net: icmp6: provide input address for traceroute6")
> Signed-off-by: Tim Stallard <code@timstallard.me.uk>

Applied, thanks.
