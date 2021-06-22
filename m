Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D0E3B0B98
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhFVRmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232258AbhFVRmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:42:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 348AE613AB;
        Tue, 22 Jun 2021 17:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624383605;
        bh=lo/kyg3/kqqRc5+03g0g99YevdWouogd9RgriEtqcec=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SPEhcjwbo6RS+hQkZ/unAe/kvssVvK3eE+WOWLVPzckg7OiGqAwNWEY/07aAdpRTX
         b40fbFdWY7XrbW49HsyNfAwhR6f7xtwsoofvTy7NSkNKMLJPwe9CFEEOE0mTdSala/
         2RR4ESOIIsAQWLbBYVI3AgaLEnfWkSfCsgngvPI7+5OHpu+coNgvnNxlOSMKGR95R+
         SxadzbpFmR15I5BtXK1ASyOFolev3RAwPJMt/CCUVOukumkVJVdjHnoFxA6SPxo+qo
         jD6Mm9fz6KXAfqBgfClnnePzEv0uMry4Y/N4FWlIUizcn/wqn2MN0VBV3VfnUqvlmK
         jnrHQmAR7ykjA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2F1E060A6C;
        Tue, 22 Jun 2021 17:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bridge: cfm: remove redundant return
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438360518.26881.9422562633513835121.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 17:40:05 +0000
References: <20210622060519.318930-1-13145886936@163.com>
In-Reply-To: <20210622060519.318930-1-13145886936@163.com>
To:     None <13145886936@163.com>
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 21 Jun 2021 23:05:19 -0700 you wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Return statements are not needed in Void function.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/bridge/br_cfm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - bridge: cfm: remove redundant return
    https://git.kernel.org/netdev/net-next/c/98534fce52ef

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


