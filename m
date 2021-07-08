Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AFC3BF45F
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 06:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhGHECq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 00:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhGHECo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 00:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 798C061CC4;
        Thu,  8 Jul 2021 04:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625716803;
        bh=P/n/X9uK6pJDvyw/tlwybZbz3mde4XAtza5STxXvtpM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eRl6fP9ka7D3PlYxJwDVfTsDJ/g1DVyA2nsu+oA2giXFF5AO3+7lwRTOpCABtvlZq
         hLne+mjNYMMzBszJ+4aPyNuwwHL3nME5Km+Ib++kPandI2TnGLw+VWBhLPPee3cwxh
         2yr5PA1G0oTPCshpV5cCRJfrVl5hL8atfrh2HtdiPtXolbJT8SmT0VJuJem2jmzQQS
         KsOCNINPlP/0q4tkpQVSbf0M2utk2sCpjf+KaV/MMzJEQJsEdtnnTkLFSiOtE5D9gH
         QpP4CCMsabQr+MS0Zb3dONOs/6VCRqK4rDY12jU1mBkjaMu8DgGCntixIsNnFhrlhB
         nm6vZPYAcwC2A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6973860A4D;
        Thu,  8 Jul 2021 04:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipmr: Fix indentation issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162571680342.17275.9309566042808024713.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Jul 2021 04:00:03 +0000
References: <20210707181833.165-1-royujjal@gmail.com>
In-Reply-To: <20210707181833.165-1-royujjal@gmail.com>
To:     UjjaL Roy <royujjal@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  7 Jul 2021 23:48:33 +0530 you wrote:
> From: "Roy, UjjaL" <royujjal@gmail.com>
> 
> Fixed indentation by removing extra spaces.
> 
> Signed-off-by: Roy, UjjaL <royujjal@gmail.com>
> ---
>  net/ipv4/ipmr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - ipmr: Fix indentation issue
    https://git.kernel.org/netdev/net/c/92c4bed59bc0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


