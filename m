Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A0F201FFA
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 05:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732222AbgFTC74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 22:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732074AbgFTC7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 22:59:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC11CC06174E;
        Fri, 19 Jun 2020 19:59:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 300A512784D15;
        Fri, 19 Jun 2020 19:59:55 -0700 (PDT)
Date:   Fri, 19 Jun 2020 19:59:54 -0700 (PDT)
Message-Id: <20200619.195954.1222983733521693534.davem@davemloft.net>
To:     claudiu.beznea@microchip.com
Cc:     nicolas.ferre@microchip.com, kuba@kernel.org,
        linux@armlinux.org.uk, antoine.tenart@bootlin.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: macb: undo operations in case of failure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592469460-17825-1-git-send-email-claudiu.beznea@microchip.com>
References: <1592469460-17825-1-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 19:59:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>
Date: Thu, 18 Jun 2020 11:37:40 +0300

> Undo previously done operation in case macb_phylink_connect()
> fails. Since macb_reset_hw() is the 1st undo operation the
> napi_exit label was renamed to reset_hw.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Applied and queued up for -stable, thank you.
