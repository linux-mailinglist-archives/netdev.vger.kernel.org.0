Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F38422B6A1
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 21:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgGWTVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 15:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgGWTVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 15:21:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BFCC0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 12:21:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5155111D69C3B;
        Thu, 23 Jul 2020 12:04:45 -0700 (PDT)
Date:   Thu, 23 Jul 2020 12:21:29 -0700 (PDT)
Message-Id: <20200723.122129.55324289504423678.davem@davemloft.net>
To:     W_Armin@gmx.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] 8390: Miscellaneous cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200723183446.GA6772@mx-linux-amd>
References: <20200723183446.GA6772@mx-linux-amd>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 12:04:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>
Date: Thu, 23 Jul 2020 20:34:46 +0200

> Include necessary librarys.

'libraries'

> @@ -64,7 +79,7 @@ const struct net_device_ops ei_netdev_ops = {
>  	.ndo_get_stats		= ei_get_stats,
>  	.ndo_set_rx_mode	= ei_set_multicast_list,
>  	.ndo_validate_addr	= eth_validate_addr,
> -	.ndo_set_mac_address 	= eth_mac_addr,
> +	.ndo_set_mac_address	= eth_mac_addr,

This has nothing to do with your change.

>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	.ndo_poll_controller	= ei_poll,
>  #endif
> @@ -74,6 +89,7 @@ EXPORT_SYMBOL(ei_netdev_ops);
>  struct net_device *__alloc_ei_netdev(int size)
>  {
>  	struct net_device *dev = ____alloc_ei_netdev(size);
> +

Neither does this.
