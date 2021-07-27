Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519683D73E9
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 13:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbhG0LAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 07:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236332AbhG0LA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 07:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C7683619E8;
        Tue, 27 Jul 2021 11:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627383629;
        bh=U2G9VcqlDWvRi8pevya3xZnfot4oN1uKD+BwYDBSO3g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MrsnWgQMFlNGTGLLERIadSsaJ06HX0cPPnhBwgFeruCmRcFAJnqSOHMxFF6eFI6Mq
         1CM2cvK7i1RCRuE7q9frJQEtbPbFcx0J+mwIoMUoLTgixnyXwUKQlaiU9hEuAd4yyt
         MhqWfVGsLV9zwWXDavGZKr+idCB34CX0vckReDyPCVVEqSZLFnV85jZvRoSac2Gkw7
         PM1GLkxefat/RrWkeM5cmm1AyruW83jvRuE0gmGnLr2ySKH5KXI7KyLOxFBxt9Lxqb
         MowAilAJ9YhxkSz2RhMW6h7SYGujWluyHKM+Wdt5uSKImr+p2zC2yAIymRQWUKWzc7
         /NfyXkU5n71NQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C22A860A56;
        Tue, 27 Jul 2021 11:00:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: netlink: add the case when nlh is NULL
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162738362979.18831.14581974766032869543.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 11:00:29 +0000
References: <20210727034141.4414-1-yajun.deng@linux.dev>
In-Reply-To: <20210727034141.4414-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Jul 2021 11:41:41 +0800 you wrote:
> Add the case when nlh is NULL in nlmsg_report(),
> so that the caller doesn't need to deal with this case.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  include/net/netlink.h   | 2 +-
>  net/core/rtnetlink.c    | 6 +-----
>  net/netlink/genetlink.c | 9 ++++-----
>  3 files changed, 6 insertions(+), 11 deletions(-)

Here is the summary with links:
  - net: netlink: add the case when nlh is NULL
    https://git.kernel.org/netdev/net-next/c/f9b282b36dfa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


