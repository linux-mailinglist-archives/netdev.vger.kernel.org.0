Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECE622552C
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 03:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgGTBHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 21:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgGTBHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 21:07:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB9EC0619D2;
        Sun, 19 Jul 2020 18:07:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1196312848241;
        Sun, 19 Jul 2020 18:07:39 -0700 (PDT)
Date:   Sun, 19 Jul 2020 18:07:38 -0700 (PDT)
Message-Id: <20200719.180738.1978402817458356702.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v1] net: phy: at803x: add mdix configuration
 support for AR9331 and AR8035
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200719080530.24370-1-o.rempel@pengutronix.de>
References: <20200719080530.24370-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jul 2020 18:07:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Sun, 19 Jul 2020 10:05:30 +0200

> This patch add MDIX configuration ability for AR9331 and AR8035. Theoretically
> it should work on other Atheros PHYs, but I was able to test only this
> two.
> 
> Since I have no certified reference HW able to detect or configure MDIX, this
> functionality was confirmed by oscilloscope.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Applied, thank you.
