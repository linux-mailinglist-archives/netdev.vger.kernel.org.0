Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01943A3ACF
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 06:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhFKEV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 00:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhFKEV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 00:21:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC841C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 21:19:59 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lrYe4-00087e-3s; Fri, 11 Jun 2021 06:19:48 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lrYdz-0005Mf-KI; Fri, 11 Jun 2021 06:19:43 +0200
Date:   Fri, 11 Jun 2021 06:19:43 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     13145886936@163.com
Cc:     robin@protonic.nl, linux@rempel-privat.de, kernel@pengutronix.de,
        socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: Re: [PATCH] can: j1939: socket: correct a grammatical error
Message-ID: <20210611041943.2glykucbueqrsr5s@pengutronix.de>
References: <20210611035202.16833-1-13145886936@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210611035202.16833-1-13145886936@163.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:15:21 up 190 days, 18:21, 38 users,  load average: 0.21, 0.17,
 0.10
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

please use [PATCH net-next] tag.

On Fri, Jun 11, 2021 at 11:52:02AM +0800, 13145886936@163.com wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Correct a grammatical error.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  net/can/j1939/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
> index 56aa66147d5a..31ec493a0fca 100644
> --- a/net/can/j1939/socket.c
> +++ b/net/can/j1939/socket.c
> @@ -352,7 +352,7 @@ static void j1939_sk_sock_destruct(struct sock *sk)
>  {
>  	struct j1939_sock *jsk = j1939_sk(sk);
>  
> -	/* This function will be call by the generic networking code, when then
> +	/* This function will be called by the generic networking code, when
>  	 * the socket is ultimately closed (sk->sk_destruct).
>  	 *
>  	 * The race between
> -- 
> 2.25.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
