Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E10938E074
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 06:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbhEXEpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 00:45:52 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:55314 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229908AbhEXEpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 00:45:51 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 14O4h4Vn030287;
        Mon, 24 May 2021 06:43:04 +0200
Date:   Mon, 24 May 2021 06:43:04 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     dzp <dzp1001167@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: remove unnecessary brackets
Message-ID: <20210524044303.GA30283@1wt.eu>
References: <CAKtZ4UP8pnSOtRRFsfDJQjT9SnsXcHpxiqEHXpCrjPBuPo443Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKtZ4UP8pnSOtRRFsfDJQjT9SnsXcHpxiqEHXpCrjPBuPo443Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 11:58:43AM +0800, dzp wrote:
> hi list,
>     this patch remove unnecessary brackets for ipv4/tcp_output.c
> 
> best regards
> 
> 
> From d736a5e4a966bbffed90a0647719dde750b29d06 Mon Sep 17 00:00:00 2001
> From: Zhiping du <zhipingdu@tencent.com>
> Date: Mon, 24 May 2021 03:37:36 +0800
> Subject: [PATCH] ipv4:tcp_output:remove unnecessary brackets
> 
> There are too many brackets. Maybe only one bracket is enough.
> 
> Signed-off-by: Zhiping Du <zhipingdu@tencent.com>
> 
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index bde781f..5455de3 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2620,7 +2620,7 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
>  	}
>  
>  	max_segs = tcp_tso_segs(sk, mss_now);
> -	while ((skb = tcp_send_head(sk))) {
> +	while (skb = tcp_send_head(sk)) {

Please do not do this. They're here to avoid a compiler warning which
will suggest that it might be a "==" instead of "=", or will ask to add
extra parenthesis.

You've probably seen it when you compiled your patched code.

Willy
