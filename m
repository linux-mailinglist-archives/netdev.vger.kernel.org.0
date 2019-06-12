Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E31342E71
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfFLSQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:16:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39500 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfFLSQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:16:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A056915283828;
        Wed, 12 Jun 2019 11:16:11 -0700 (PDT)
Date:   Wed, 12 Jun 2019 11:16:11 -0700 (PDT)
Message-Id: <20190612.111611.1041149504005677875.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     sfr@canb.auug.org.au, netdev@vger.kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org
Subject: Re: [RESEND PATCH net-next] net: ethernet: ti: cpts: fix build
 failure for powerpc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190611111632.9444-1-grygorii.strashko@ti.com>
References: <20190611111632.9444-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 11:16:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Tue, 11 Jun 2019 14:16:32 +0300

> Add dependency to TI CPTS from Common CLK framework COMMON_CLK to fix
> allyesconfig build for Powerpc:
> 
> drivers/net/ethernet/ti/cpts.c: In function 'cpts_of_mux_clk_setup':
> drivers/net/ethernet/ti/cpts.c:567:2: error: implicit declaration of function 'of_clk_parent_fill'; did you mean 'of_clk_get_parent_name'? [-Werror=implicit-function-declaration]
>   of_clk_parent_fill(refclk_np, parent_names, num_parents);
>   ^~~~~~~~~~~~~~~~~~
>   of_clk_get_parent_name
> 
> Fixes: a3047a81ba13 ("net: ethernet: ti: cpts: add support for ext rftclk selection")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  Resending due to missed netdev@vger.kernel.org list in prev post.

Applied, thanks.
