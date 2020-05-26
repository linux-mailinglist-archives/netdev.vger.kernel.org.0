Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2041E3222
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390953AbgEZWNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEZWNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:13:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B597C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 15:13:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 373F8120ED490;
        Tue, 26 May 2020 15:13:16 -0700 (PDT)
Date:   Tue, 26 May 2020 15:13:05 -0700 (PDT)
Message-Id: <20200526.151305.1716055086821349329.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, maze@google.com
Subject: Re: [PATCH net-next] tcp: tcp_v4_err() icmp skb is named icmp_skb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200526031524.72257-1-edumazet@google.com>
References: <20200526031524.72257-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 15:13:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 25 May 2020 20:15:24 -0700

> I missed the fact that tcp_v4_err() differs from tcp_v6_err().
> 
> After commit 4d1a2d9ec1c1 ("Rename skb to icmp_skb in tcp_v4_err()")
> the skb argument has been renamed to icmp_skb only in one function.
> 
> I will in a future patch reconciliate these functions to avoid
> this kind of confusion.
> 
> Fixes: 45af29ca761c ("tcp: allow traceroute -Mtcp for unpriv users")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied.
