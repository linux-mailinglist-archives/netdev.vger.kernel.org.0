Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4262EB69D
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbhAFABA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:01:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51982 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbhAFAA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:00:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id CC0494CE685B7;
        Tue,  5 Jan 2021 16:00:18 -0800 (PST)
Date:   Tue, 05 Jan 2021 16:00:18 -0800 (PST)
Message-Id: <20210105.160018.901800594374682376.davem@davemloft.net>
To:     fthain@telegraphics.com.au
Cc:     kuba@kernel.org, christophe.jaillet@wanadoo.fr,
        tsbogend@alpha.franken.de, chris@zankel.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net RESEND] net/sonic: Fix some resource leaks in
 error handling paths
From:   David Miller <davem@davemloft.net>
In-Reply-To: <529006a7dcd2cd345c2261d4beae0960880f4828.1609633586.git.fthain@telegraphics.com.au>
References: <529006a7dcd2cd345c2261d4beae0960880f4828.1609633586.git.fthain@telegraphics.com.au>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 16:00:19 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>
Date: Sun, 03 Jan 2021 11:26:26 +1100

> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> A call to dma_alloc_coherent() is wrapped by sonic_alloc_descriptors().
> 
> This is correctly freed in the remove function, but not in the error
> handling path of the probe function. Fix this by adding the missing
> dma_free_coherent() call.
> 
> While at it, rename a label in order to be slightly more informative.
> 
> Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Chris Zankel <chris@zankel.net>
> References: commit 10e3cc180e64 ("net/sonic: Fix a resource leak in an error handling path in 'jazz_sonic_probe()'")
> Fixes: 74f2a5f0ef64 ("xtensa: Add support for the Sonic Ethernet device for the XT2000 board.")
> Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Applied and queued up for -stable, thanks.
