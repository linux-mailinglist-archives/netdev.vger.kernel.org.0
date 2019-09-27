Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E477C0AC7
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfI0SH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:07:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34976 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfI0SH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:07:59 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 36268153D864E;
        Fri, 27 Sep 2019 11:07:58 -0700 (PDT)
Date:   Fri, 27 Sep 2019 20:07:53 +0200 (CEST)
Message-Id: <20190927.200753.312829429872662398.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        dsahern@gmail.com, pruddy@vyatta.att-mail.com
Subject: Re: [PATCH net] vrf: Do not attempt to create IPv6 mcast rule if
 IPv6 is disabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925145319.26801-1-dsahern@kernel.org>
References: <20190925145319.26801-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 11:07:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed, 25 Sep 2019 07:53:19 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> A user reported that vrf create fails when IPv6 is disabled at boot using
> 'ipv6.disable=1':
>    https://bugzilla.kernel.org/show_bug.cgi?id=204903
> 
> The failure is adding fib rules at create time. Add RTNL_FAMILY_IP6MR to
> the check in vrf_fib_rule if ipv6_mod_enabled is disabled.
> 
> Fixes: e4a38c0c4b27 ("ipv6: add vrf table handling code for ipv6 mcast")
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Patrick Ruddy <pruddy@vyatta.att-mail.com>

Applied.
