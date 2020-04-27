Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3602F1BAD87
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 21:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgD0TIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 15:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgD0TIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 15:08:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A72FC0610D5;
        Mon, 27 Apr 2020 12:08:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A35C015D59E0D;
        Mon, 27 Apr 2020 12:08:01 -0700 (PDT)
Date:   Mon, 27 Apr 2020 12:08:00 -0700 (PDT)
Message-Id: <20200427.120800.2048743248471906857.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     fthain@telegraphics.com.au, tsbogend@alpha.franken.de,
        jgarzik@pobox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/sonic: Fix a resource leak in an error handling
 path in 'jazz_sonic_probe()'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200427061803.53857-1-christophe.jaillet@wanadoo.fr>
References: <20200427061803.53857-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 12:08:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Mon, 27 Apr 2020 08:18:03 +0200

> A call to 'dma_alloc_coherent()' is hidden in 'sonic_alloc_descriptors()',
> called from 'sonic_probe1()'.
> 
> This is correctly freed in the remove function, but not in the error
> handling path of the probe function.
> Fix it and add the missing 'dma_free_coherent()' call.
> 
> While at it, rename a label in order to be slightly more informative.
> 
> Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied, thanks.
