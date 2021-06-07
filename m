Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E700039E8E2
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhFGVMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230333AbhFGVL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9EEE26120F;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623100205;
        bh=NYMQLaCxBytQK9uw8wHYuzMpYL6Xz6SauNgfeumC7hY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UNekh9qvqzLCN3f6hI4w9Px02KSS7w1EkoKJMdV1QWEg+7gliueJ0kEqfQ1lNLNH+
         MqH+wMhE4VzJVcv4x8KI2MdlYKl80z6clBZov91LQTFn4dl/kYkAk4gOEnm/+i6Lnu
         tVJMkJdfvD2JlbV6UYr2pnoVCsL68oX3489lEmmP6JNNl6I1M51X/ffI8qUWtyy3OQ
         ttnE6LhXv/ArUC2AzPX5vKyF4OAheXLlbkOG8ky3491oh8s+pkoP78MXbm+9n8G6zt
         v0mz5r59mQvRM9pj8UBsa3l5xn5g6NfSP6Z7EUIHF18i5lnSRSq9ezO3T2II0BEOk8
         V7lQGVQULxq6w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8C84F60CD1;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: enetc: Use
 devm_platform_get_and_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310020557.31357.10427446540643483901.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:10:05 +0000
References: <20210607135714.3979032-1-yangyingliang@huawei.com>
In-Reply-To: <20210607135714.3979032-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 7 Jun 2021 21:57:14 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc_ierb.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: enetc: Use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/b5d64b43f8cc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


