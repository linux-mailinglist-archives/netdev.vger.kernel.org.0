Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8497743E269
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhJ1Nmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229887AbhJ1Nmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 09:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A4BFF61040;
        Thu, 28 Oct 2021 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635428407;
        bh=uK7ie7KAKiZhtrzFqzj+h/gE1GTRgbU2IousUDEDts8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZW+hX7oGCUjY7gZW1o217UvpRmp96vD3SjdMciXeL6pSQEtHTll+k/YZ+EfCHKF6W
         oOTcY2xa5bYqhmx4Hlm0NBjItKA/Pu6fQy0MIAixjNpVTpb0oEsQ1wwl2WMCM4ET/r
         i7O/4+8SsSBJRWWysfue58Ht9wNkw6QG5kQ1/j+GxnsTldcqWn00nP8JRaOvGA9eFm
         cmz/z1l92dRq1jICpeYTP4BmpxHz6pA5RinNqCV1Ng9TxpNgYL28EbH6N0t6hot8u0
         dPbxNNxH13Gr2SbmCrqFWf6qKSt6aQw/255/l+IGZzpMNxU5krTMQ7s1Tt76GBpqOf
         dT16Gd6w+qu2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9666F60A25;
        Thu, 28 Oct 2021 13:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sch_htb: Add extack messages for EOPNOTSUPP errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542840761.2633.4634424745848970452.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 13:40:07 +0000
References: <20211028122436.4089238-1-maximmi@nvidia.com>
In-Reply-To: <20211028122436.4089238-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, tariqt@nvidia.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 15:24:36 +0300 you wrote:
> In order to make the "Operation not supported" message clearer to the
> user, add extack messages explaining why exactly adding offloaded HTB
> could be not supported in each case.
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] sch_htb: Add extack messages for EOPNOTSUPP errors
    https://git.kernel.org/netdev/net-next/c/648a991cf316

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


