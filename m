Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958B239ACE8
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhFCVbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 17:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbhFCVbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 17:31:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6E79961400;
        Thu,  3 Jun 2021 21:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622755807;
        bh=QxXRi5CSZhCoRuAWSZcT61lQaiG1SxBapaO/MYoy3RU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qf4cqRkaUaSWexWIEJx3ZNvUSmT5ABIY9CLDG2QU/bnxREx9Cy5/DFzVK7VCgLrjf
         b0o9JJiY8y58iz6PA13t7XUI4vecZHcmA+/CCl83fkF3pM3x2JK9FZw5/BGK5L2RPu
         joi6kpOn+MOEl4IEXNqg7d/QOV7bQVQyIk5AxHMTkAhU3fkuQbwjMm33YMRNjIt9qB
         xLxNqmZEDwLFacZH9uOwYXxwDqz5i9KXUXv2b9fBcHV/MMtJq0chTGSvOGeCrQ9cBZ
         TYKTpYvn7n67IS/XzJaMGKrt0DI8/brZ+zjkSXl+H5YpSlpWxDUlbPZ6DfQMGqmokh
         QzrSPXsISyQHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5D3C960CD2;
        Thu,  3 Jun 2021 21:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: vlan: Avoid using strncpy()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275580737.14468.12685460364104219875.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 21:30:07 +0000
References: <20210602202741.4078789-1-keescook@chromium.org>
In-Reply-To: <20210602202741.4078789-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        zhudi21@huawei.com, pablo@netfilter.org, xiyou.wangcong@gmail.com,
        ap420073@gmail.com, gustavoars@kernel.org, nbd@nbd.name,
        eranbe@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  2 Jun 2021 13:27:41 -0700 you wrote:
> Use strscpy_pad() instead of strncpy() which is considered deprecated:
> https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  net/8021q/vlan.c     | 3 ++-
>  net/8021q/vlan.h     | 3 ++-
>  net/8021q/vlan_dev.c | 6 +++---
>  3 files changed, 7 insertions(+), 5 deletions(-)

Here is the summary with links:
  - net: vlan: Avoid using strncpy()
    https://git.kernel.org/netdev/net-next/c/9c153d388976

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


