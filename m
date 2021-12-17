Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E2F47842B
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 05:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhLQEkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 23:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhLQEkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 23:40:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A72C061574;
        Thu, 16 Dec 2021 20:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F1CF62012;
        Fri, 17 Dec 2021 04:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF18CC36AE1;
        Fri, 17 Dec 2021 04:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639716010;
        bh=2CsWWtAHCm+l0ZkLS+oAoYIPBPoAdtnqvNR7sVQ6I4c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U7dIHx/fXRFSKFSzc2eJqMJlDnKjA+ji6pr+BBGWcyiOoK7bhijJJNn2GYevHYljF
         tTgiN4vv6fZVFvE5jt/8oJB5PygXGsyW1hUENC1W7Pbjum7UQv2/1g8KoG5/0/ulC2
         zVns/gH07raI94sPnEbNxuSGcht63wUI3IUvbCA1dPa4GwPw8NrHN73hkCJ59CGxI1
         sJJidlzTbRpw0d9tfmG5T6RqGeT3EuBVSvRyBxfkqKcekIBQiJ6IQAdPR8t02xl0A5
         +PF6EZderwPupfjd5ZDbp4IkPlrMpHR216JkhvtbiBrgfDxHQrNVQvBVh9ZN4qA/U5
         0fIXf+ZqjLCpA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 98BA660A27;
        Fri, 17 Dec 2021 04:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: vertexcom: remove unneeded semicolon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163971601062.6242.8119580778387345247.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Dec 2021 04:40:10 +0000
References: <20211216015433.83383-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20211216015433.83383-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, abaci@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Dec 2021 09:54:33 +0800 you wrote:
> Eliminate the following coccicheck warning:
> ./drivers/net/ethernet/vertexcom/mse102x.c:414:2-3: Unneeded semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/ethernet/vertexcom/mse102x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [-next] net: vertexcom: remove unneeded semicolon
    https://git.kernel.org/netdev/net-next/c/431b9b4d9789

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


