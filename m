Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB3243993E
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhJYOww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233696AbhJYOwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 10:52:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 904C061039;
        Mon, 25 Oct 2021 14:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635173407;
        bh=jYOtjHPCtlfoXpNUGdU/aP/8EDMtH7R8Xiek4vi1dyw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CkJmjD57ca0DJl8Lj8eJSv4HJyR0V/5ourT87XirDfo6gcB23QrWgZ83O/HwjETMj
         7pfppAFEx094lGzLntGInX6pt4MqVwgILWRyH8iU/LZoYEZECz29efzIoi6M/AfB9C
         Swy6ixqAwBbKDUM/v1Bb5HKCsnCuPxfsEhYPDj1uSfoKqVPxZkBOekxo3A9FSjnXsZ
         cQAkvD2/ZDTG/mjgTSy7MqBp//iRy6zOtVixFBt/S1aZvsV9lohoeSXmMpLimtvIma
         Yk4V7ad2e8r5GLj6N5KjECDo5dF7gVMx3WmmcmskmMz8zICqbUIl8f6leQKjVjeF8t
         +ddL/8iTYv1ug==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 89A4660A17;
        Mon, 25 Oct 2021 14:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mlxsw: spectrum: Use 'bitmap_zalloc()' when applicable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163517340755.13749.8331433462524363080.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 14:50:07 +0000
References: <daae11381ba197d91702cb23c6c1120571cb0b87.1635103002.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <daae11381ba197d91702cb23c6c1120571cb0b87.1635103002.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jiri@nvidia.com, idosch@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 24 Oct 2021 21:17:51 +0200 you wrote:
> Use 'bitmap_zalloc()' to simplify code, improve the semantic and avoid
> some open-coded arithmetic in allocator arguments.
> 
> Also change the corresponding 'kfree()' into 'bitmap_free()' to keep
> consistency.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - mlxsw: spectrum: Use 'bitmap_zalloc()' when applicable
    https://git.kernel.org/netdev/net-next/c/2c087dfcc9d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


