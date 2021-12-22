Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF9447CFFB
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 11:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244167AbhLVKaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 05:30:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37844 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239976AbhLVKaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 05:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF12F61961;
        Wed, 22 Dec 2021 10:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2FB29C36AEA;
        Wed, 22 Dec 2021 10:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640169010;
        bh=CnCfu8r3z6aKBJvma1TAD0GNjKGW2cZq6pGkkAtdW40=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J+IFqebvYpPIsaurVBAka0lYY0v72/+9GT4Wzx+iMcS2hSOG0IvEqqid1/mrleBou
         BWmN7sGtdQDHttft4PwMu+eA41o9veoeRKYdFBP5BkUJ0IW5n2mRbK2rCJyL/8VV5w
         x5G1Qxi9ovQppUvq60YLoZ2CYfRz/14rA6iDa3MbEnm/NTi6zV+Ya74dBpOFsxzkO+
         bZwWgKlOVSS65yZxak8nUlYZUwY9r84jXHlkNVWz4ey9sVPW1Qi7b1yl55AiKsoumB
         a/gSeQWPp56gdrYcKxHAmb87sjU5KtTCZO6E4j7gr7IxUeDVg2j7HGsP3gmDIueapU
         mnc34iYxx1wiA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0D3EA60A59;
        Wed, 22 Dec 2021 10:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] fjes: Check for error irq
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164016901004.30322.5440211136446629947.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Dec 2021 10:30:10 +0000
References: <20211222071207.1072787-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20211222071207.1072787-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     davem@davemloft.net, kuba@kernel.org, yangyingliang@huawei.com,
        sashal@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 22 Dec 2021 15:12:07 +0800 you wrote:
> I find that platform_get_irq() will not always succeed.
> It will return error irq in case of the failure.
> Therefore, it might be better to check it if order to avoid the use of
> error irq.
> 
> Fixes: 658d439b2292 ("fjes: Introduce FUJITSU Extended Socket Network Device driver")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> [...]

Here is the summary with links:
  - fjes: Check for error irq
    https://git.kernel.org/netdev/net/c/db6d6afe382d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


