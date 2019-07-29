Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B074A792E0
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 20:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbfG2SMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 14:12:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37150 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfG2SMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 14:12:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E2CA1405336B;
        Mon, 29 Jul 2019 11:12:45 -0700 (PDT)
Date:   Mon, 29 Jul 2019 11:12:44 -0700 (PDT)
Message-Id: <20190729.111244.1579095115694062432.davem@davemloft.net>
To:     gustavo@embeddedor.com
Cc:     kou.ishizaki@toshiba.co.jp, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        keescook@chromium.org
Subject: Re: [PATCH] net: spider_net: Mark expected switch fall-through
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190729003251.GA25556@embeddedor>
References: <20190729003251.GA25556@embeddedor>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 11:12:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Date: Sun, 28 Jul 2019 19:32:51 -0500

> Mark switch cases where we are expecting to fall through.
> 
> This patch fixes the following warning:
> 
> drivers/net/ethernet/toshiba/spider_net.c: In function 'spider_net_release_tx_chain':
> drivers/net/ethernet/toshiba/spider_net.c:783:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
>     if (!brutal) {
>        ^
> drivers/net/ethernet/toshiba/spider_net.c:792:3: note: here
>    case SPIDER_NET_DESCR_RESPONSE_ERROR:
>    ^~~~
> 
> Notice that, in this particular case, the code comment is
> modified in accordance with what GCC is expecting to find.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied.
