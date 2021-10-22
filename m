Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319CF437C8A
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbhJVSWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233685AbhJVSWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 14:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 189D661163;
        Fri, 22 Oct 2021 18:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634926807;
        bh=FTFnIJXrKgp8ak/gzOkdPexVDIQgt61glM4WzGsFAuI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hTEUronYObOVSnLopnBtG+S2h1uFcthRqu8UPKwDp0Hp7qgAOYqR8XJlad6n2wne8
         LSo1JmmrYQtrz98wqKcoefSrLjDr0jeGvb8e+FBgZ7ApV8Rfa5PHEzyt8tWZH8MzHT
         zKeNT7EkTUWH9PiVWJIrRNJIcpwiPCeGpEwA86e5uRjCUSRGG3CI78Zrr9JekHznx8
         pH9tkycBrDGelAJ8uH2yXUFghajse1Fi1Cfu8KNukZzusLJv/2Qpiut+dxo5uyuwLf
         1WSt+ll7IvQzhuCw+Xf7XDaGNn4jBi+EIDHslZ1p9HG3n3Evt0IXsZ8daDv0Acu13+
         fEoBHeP+Mlmeg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0BC39609E2;
        Fri, 22 Oct 2021 18:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: liquidio: Make use of the helper macro kthread_run()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163492680704.22371.2580347060325541309.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Oct 2021 18:20:07 +0000
References: <20211021084158.2183-1-caihuoqing@baidu.com>
In-Reply-To: <20211021084158.2183-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 Oct 2021 16:41:58 +0800 you wrote:
> Repalce kthread_create/wake_up_process() with kthread_run()
> to simplify the code.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/net/ethernet/cavium/liquidio/lio_main.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)

Here is the summary with links:
  - net: liquidio: Make use of the helper macro kthread_run()
    https://git.kernel.org/netdev/net-next/c/47b068247aa7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


