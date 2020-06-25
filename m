Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CAA20A884
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407632AbgFYXAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728280AbgFYXAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:00:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77538C08C5C1;
        Thu, 25 Jun 2020 16:00:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0BF471299BAE1;
        Thu, 25 Jun 2020 16:00:38 -0700 (PDT)
Date:   Thu, 25 Jun 2020 16:00:37 -0700 (PDT)
Message-Id: <20200625.160037.879221379667078763.davem@davemloft.net>
To:     claudiu.beznea@microchip.com
Cc:     nicolas.ferre@microchip.com, kuba@kernel.org,
        alexandre.belloni@bootlin.com, antoine.tenart@bootlin.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: macb: free resources on failure path of
 at91ether_open()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592993298-26533-2-git-send-email-claudiu.beznea@microchip.com>
References: <1592993298-26533-1-git-send-email-claudiu.beznea@microchip.com>
        <1592993298-26533-2-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 16:00:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>
Date: Wed, 24 Jun 2020 13:08:18 +0300

> DMA buffers were not freed on failure path of at91ether_open().
> Along with changes for freeing the DMA buffers the enable/disable
> interrupt instructions were moved to at91ether_start()/at91ether_stop()
> functions and the operations on at91ether_stop() were done in
> their reverse order (compared with how is done in at91ether_start()):
> before this patch the operation order on interface open path
> was as follows:
> 1/ alloc DMA buffers
> 2/ enable tx, rx
> 3/ enable interrupts
> and the order on interface close path was as follows:
> 1/ disable tx, rx
> 2/ disable interrupts
> 3/ free dma buffers.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Also applied and queued up for -stable.

Please submit a proper header posting "[PATCH 0/N] " in the future
when you submit a patch series.  Thank you.
