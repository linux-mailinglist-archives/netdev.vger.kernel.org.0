Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6D721FEDD
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 22:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgGNUsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 16:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgGNUsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 16:48:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8238DC061755;
        Tue, 14 Jul 2020 13:48:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D64015E2866C;
        Tue, 14 Jul 2020 13:48:39 -0700 (PDT)
Date:   Tue, 14 Jul 2020 13:48:38 -0700 (PDT)
Message-Id: <20200714.134838.855399731021149194.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] lan743x: switch from 'pci_' to 'dma_' API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200714075224.290759-1-christophe.jaillet@wanadoo.fr>
References: <20200714075224.290759-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 13:48:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Tue, 14 Jul 2020 09:52:24 +0200

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GPF_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'lan743x_tx_ring_cleanup()' and
> 'lan743x_rx_ring_init()', GFP_KERNEL can be used because this flag is
> already used to allocate some memory in these functions.
> 
> While at it, remove a useless (void *) casting in the first hunk in so that
> the code is more consistent.
 ...
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Appied to net-next, thank you.
