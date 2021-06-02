Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2DD397D8A
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbhFBAML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235292AbhFBALu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 65BBD613E1;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622592608;
        bh=mytimOXCZb8WhuSv43zMqcMkD8/c0Vr0Yo3u0b/C+ps=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hKUiVg0u1OJ11DKsLsogTZGATtWGDqxlRhCBzDdHjKQub3sbmLpwcH1pqn5QvYP0y
         96Fplu0JpQKmd/TGYpW8OeSmWghhe91Bl+aUJfkO7wbT/PzMo/EUCrXph4RwOGozId
         TkFmgXrjD5BXjarLDV2PwKIEikr1JWNCKs+x7zcCEJ9m/vA8Q8ybvqmH9UMp/0mIXZ
         iywyPphIk8BqScphsQXTDCADapKQjvN2zIYCxSuf/lI9G9zZ9+68PekLxN1aYzYN5D
         zb6vvq5xdujXAL2X9AqkJxHjPmg/itNN09kGBPTRTVQmYI/gSQWZgkxZsiWUAEcci+
         SU3WVgQnY15zA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5F84D60953;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] gtp: Fix a typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259260838.22595.643029075526430642.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:10:08 +0000
References: <20210601141625.4131445-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210601141625.4131445-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     pablo@netfilter.org, laforge@gnumonks.org, davem@davemloft.net,
        kuba@kernel.org, osmocom-net-gprs@lists.osmocom.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 22:16:25 +0800 you wrote:
> Suppport  ==> Support
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  drivers/net/gtp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] gtp: Fix a typo
    https://git.kernel.org/netdev/net-next/c/ec674565fbc6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


