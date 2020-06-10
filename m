Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D211F5EAA
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 01:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgFJXWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 19:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgFJXWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 19:22:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4D7C03E96B;
        Wed, 10 Jun 2020 16:22:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E3D2811F5F667;
        Wed, 10 Jun 2020 16:22:37 -0700 (PDT)
Date:   Wed, 10 Jun 2020 16:22:37 -0700 (PDT)
Message-Id: <20200610.162237.1053512967005656899.davem@davemloft.net>
To:     clabbe@baylibre.com
Cc:     antoine.tenart@bootlin.com, linux@armlinux.org.uk,
        nicolas.ferre@microchip.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: cadence: macb: disable NAPI on error
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1591782824-31654-1-git-send-email-clabbe@baylibre.com>
References: <1591782824-31654-1-git-send-email-clabbe@baylibre.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Jun 2020 16:22:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>
Date: Wed, 10 Jun 2020 09:53:44 +0000

> When the PHY is not working, the macb driver crash on a second try to
> setup it.
> [   78.545994] macb e000b000.ethernet eth0: Could not attach PHY (-19)
 ...
> This is due to NAPI left enabled if macb_phylink_connect() fail.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

Applied and queued up for v5.5+ -stable, thanks.
