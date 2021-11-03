Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8295E443B5F
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 03:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhKCCcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 22:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhKCCco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 22:32:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 81DF261156;
        Wed,  3 Nov 2021 02:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635906607;
        bh=A0uno/9KrnysBMy5appmIe2ruh0cakQ3bcaYvBuQNMo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Huh5ToDABoQ44rumroNL7WX6tMKtRdjPv0vaK/TgCWb5MyARI/BVt9qTi6HQdQPpz
         R6NczHOV+Ue/sEswe+L+OgaH0W28Y48sqnndF2EVyk993fRrEIwJL7DHqyn3gy8gbw
         HQdQm0cdpvfbEuOZZjCseX2ZZf3fKiivf6IVHYmZmUkcr/P+u0jNY5/lypiJrhF5KB
         rQwXXi9QVIRU2uP0No7smp00up6kxrbwgFjePSVXWrjN+48OsGNAujap2EBM9TvFRp
         i9A0AY6yHxLnnPKgEY2ZvCCCkaUmII6O/2/S69s/7/lkpajBhwf/avnLz/fKNiAmB6
         6nyyVcuNPGAkw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 70CB560BE4;
        Wed,  3 Nov 2021 02:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] amt: fix error return code in amt_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163590660745.25427.17696600257273244901.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 02:30:07 +0000
References: <20211102130353.1666999-1-yangyingliang@huawei.com>
In-Reply-To: <20211102130353.1666999-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, ap420073@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 2 Nov 2021 21:03:53 +0800 you wrote:
> Return error code when alloc_workqueue()
> fails in amt_init().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/amt.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] amt: fix error return code in amt_init()
    https://git.kernel.org/netdev/net/c/db2434343b2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


