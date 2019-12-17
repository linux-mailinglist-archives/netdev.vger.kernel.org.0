Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EED1212227A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 04:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfLQDUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 22:20:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59272 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfLQDUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 22:20:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4BBC414249633;
        Mon, 16 Dec 2019 19:20:46 -0800 (PST)
Date:   Mon, 16 Dec 2019 19:20:45 -0800 (PST)
Message-Id: <20191216.192045.2284012320875217079.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, andrew@lunn.ch,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net: ag71xx: fix compile warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191216064407.32310-1-o.rempel@pengutronix.de>
References: <20191216064407.32310-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 19:20:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Mon, 16 Dec 2019 07:44:07 +0100

> drivers/net/ethernet/atheros/ag71xx.c: In function 'ag71xx_probe':
> drivers/net/ethernet/atheros/ag71xx.c:1776:30: warning: passing argument 2 of
>  'of_get_phy_mode' makes pointer from integer without a cast [-Wint-conversion]
> In file included from drivers/net/ethernet/atheros/ag71xx.c:33:
> ./include/linux/of_net.h:15:69: note: expected 'phy_interface_t *'
>  {aka 'enum <anonymous> *'} but argument is of type 'int'
> 
> Fixes: 0c65b2b90d13c1 ("net: of_get_phy_mode: Change API to solve int/unit warnings")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

This patch does not apply to the net tree.
