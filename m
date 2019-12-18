Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409A6123FBA
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfLRGjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:39:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47348 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRGjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:39:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 762971500BB50;
        Tue, 17 Dec 2019 22:39:21 -0800 (PST)
Date:   Tue, 17 Dec 2019 22:39:20 -0800 (PST)
Message-Id: <20191217.223920.2253637492180028793.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, andrew@lunn.ch,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ag71xx: fix compile warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191217065145.9329-1-o.rempel@pengutronix.de>
References: <20191217065145.9329-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 22:39:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Tue, 17 Dec 2019 07:51:45 +0100

> drivers/net/ethernet/atheros/ag71xx.c: In function 'ag71xx_probe':
> drivers/net/ethernet/atheros/ag71xx.c:1776:30: warning: passing argument 2 of
>  'of_get_phy_mode' makes pointer from integer without a cast [-Wint-conversion]
> In file included from drivers/net/ethernet/atheros/ag71xx.c:33:
> ./include/linux/of_net.h:15:69: note: expected 'phy_interface_t *'
>  {aka 'enum <anonymous> *'} but argument is of type 'int'
> 
> Fixes: 0c65b2b90d13c1 ("net: of_get_phy_mode: Change API to solve int/unit warnings")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thank you.
