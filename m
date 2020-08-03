Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2CC23B096
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgHCXBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgHCXBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:01:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6F1C06174A;
        Mon,  3 Aug 2020 16:01:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4CC7612779184;
        Mon,  3 Aug 2020 15:44:21 -0700 (PDT)
Date:   Mon, 03 Aug 2020 16:01:06 -0700 (PDT)
Message-Id: <20200803.160106.2190172984461163076.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     ralf@linux-mips.org, kuba@kernel.org, tbogendoerfer@suse.de,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: sgi: ioc3-eth: Fix the size used in some
 'dma_free_coherent()' calls
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200802135204.690832-1-christophe.jaillet@wanadoo.fr>
References: <20200802135204.690832-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:44:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun,  2 Aug 2020 15:52:04 +0200

> Update the size used in 'dma_free_coherent()' in order to match the one
> used in the corresponding 'dma_alloc_coherent()'.
> 
> Fixes: 369a782af0f1 ("net: sgi: ioc3-eth: ensure tx ring is 16k aligned.")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied.
