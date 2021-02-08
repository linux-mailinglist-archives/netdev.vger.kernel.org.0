Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBBB31435F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 00:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhBHXAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 18:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhBHXAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 18:00:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DD61964E28;
        Mon,  8 Feb 2021 23:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612825206;
        bh=MAroD10xmMQUxu3TS0dW0x5CnTiTJM0qcTA6OyCh4eo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fs/KGIhv+cf+x1bUn2aLDaMuoCg6QJ01vRr3UNMNYAhMzt4QoAaYKfUG8+9k0fP24
         gT6SRgi7+kcj7laC8XJ9tlpSppPhxVDwLGZW9P23DzYxtkTUMZI/Iz69ZQtp8SHdwk
         5zdx+lvQj3WImCekjlAbeSiI8tWGWvz1UeTnNdz8nyL+NrtKjIv9Tm+n6JIEMy8Cyh
         bOaBH+0FFZp/87pZ9d//kWKk81rnVp+lB6ghDAG3Yr+5AhGBzEeBk+SGNpptrwE1IP
         eUf/JVH0CkLdFD7+P942WJboKceIxwYtneDvGv2EOsU+jz6lH2KlGMi4HHxaYEQ2jL
         /LNSYZTmoZPbQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C9283609D4;
        Mon,  8 Feb 2021 23:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests/net: so_txtime: remove unneeded semicolon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161282520682.21105.3182571344470906337.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Feb 2021 23:00:06 +0000
References: <1612776818-21930-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1612776818-21930-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     shuah@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  8 Feb 2021 17:33:38 +0800 you wrote:
> Eliminate the following coccicheck warning:
> ./tools/testing/selftests/net/so_txtime.c:199:3-4: Unneeded semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  tools/testing/selftests/net/so_txtime.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - selftests/net: so_txtime: remove unneeded semicolon
    https://git.kernel.org/netdev/net-next/c/c85b3bb7b650

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


