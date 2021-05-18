Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E6D3881A6
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 22:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352246AbhERUvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 16:51:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351949AbhERUvb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 16:51:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F403661361;
        Tue, 18 May 2021 20:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621371013;
        bh=ZsXD6a12n2WQP724uC8PsAGmyDMPJB3omfsNR5lLKl0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i95RAtKCcdKbhaykpFs4dVB+bI3YowT9AfBLbQ5Ym9nQFTRyYafgJXSgsCDIFFEVX
         ReOyV9aMI3fpe21IOx8QKf45xk6c9k0KVdG9kTHo2gi3211QXN/qAICHmEWqyw4eEN
         1BwAPxLSDTmFbaeqUoPf+k55TmVfJ6QhCavtGAYVHPPmYuz1eCRQv8eT6BH8z3bKMw
         vmQ8VZMq3vu6+ntcG8d71GFY1Zb1tb3zgZErqNWxNkL96ZrCLOGPVRcNqf6Mu551To
         SCHiaQZ6YvjmDSmUgwW9UmoJMWrJs0CDWxJHcv/fX6a2XHO4zwN4L2cLmi4HIZhg37
         9/M3NhEGGe3Zg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E4AB660CD5;
        Tue, 18 May 2021 20:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dcb: Remove unnecessary INIT_LIST_HEAD()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162137101293.13244.17645853233299810569.git-patchwork-notify@kernel.org>
Date:   Tue, 18 May 2021 20:50:12 +0000
References: <20210518130358.1304701-1-yangyingliang@huawei.com>
In-Reply-To: <20210518130358.1304701-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 18 May 2021 21:03:58 +0800 you wrote:
> The list_head dcb_app_list is initialized statically.
> It is unnecessary to initialize by INIT_LIST_HEAD().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  net/dcb/dcbnl.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - [net-next] net: dcb: Remove unnecessary INIT_LIST_HEAD()
    https://git.kernel.org/netdev/net-next/c/e2bd6bad9c1e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


