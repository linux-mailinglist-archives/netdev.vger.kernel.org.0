Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1598032F51F
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 22:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhCEVKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 16:10:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbhCEVKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 16:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3BF83650A0;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614978609;
        bh=mdg/PC0DMiK48dveOcYJjv586g3ib5adhGlG23rjx8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CkGjQpP8kaU1SPZ1a+VAADE+/gGPLGQBiM+WNnTXEJAo8blNthO/U8Q5hX5P0hEYx
         gYrzWAMf5nlSAIXLM+cU4lcmq7FQmqeRDRezNicGlIOPTvWZYApgDpFAGzzeO8taoY
         TYzT93xSM6MXa/xb8JCh7JH0I4wH0McHNRlef4UvO/xqhWmOJqxZz9ldxO08Rgqgim
         cBqsupW/1ULeN3ElVdycki612MI5nmaUpD107twDeR2RLoF797YXPapbOMiG354lWd
         bCYQWefAxwKmS0nOzdJRgGGRbXLc7me7up3r/gtBmp9fM5rMXuuwJ9UW7We8xyySmB
         OuqgWrcONbWRA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3003E609EA;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161497860919.24588.1162341745662570326.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Mar 2021 21:10:09 +0000
References: <20210305170212.146135-1-efremov@linux.com>
In-Reply-To: <20210305170212.146135-1-efremov@linux.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  5 Mar 2021 20:02:12 +0300 you wrote:
> RXMAC_BC_FRM_CNT_COUNT added to mp->rx_bcasts twice in a row
> in niu_xmac_interrupt(). Remove the second addition.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
> I don't know the code of the dirver, but this looks like a real bug.
> Otherwise, it's more readable as:
>    mp->rx_bcasts += RXMAC_BC_FRM_CNT_COUNT * 2;
> 
> [...]

Here is the summary with links:
  - sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count
    https://git.kernel.org/netdev/net/c/155b23e6e534

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


