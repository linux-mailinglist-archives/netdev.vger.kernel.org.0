Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD504225FE
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 14:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbhJEML7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 08:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234413AbhJEML5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 08:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8BD2861529;
        Tue,  5 Oct 2021 12:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633435807;
        bh=FlQ5U1SiwLBxWd+OdFGjO4nljobd2vkKZw7udn78aGA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cV1w8ytl4UFzHj7tSpIeJJLQPxHnq1Y9r8W66tAmIlfS6hjOGJOaxpyV3DnSkPMXN
         kNImpcf8sOoj/rikYGNgPW8wwQ7ZA+V3Dl9y3clSRHPIkBgNQ6IXLWBCKDbgY4YRiY
         rs7c2y+HhY1HZNQuE2bN3NEvGiJze40W7YFh44uYWhjwDBuxIN7WLz+jG3w67A5Udc
         LdBaoUXW94rHOntBft9nf97dJqC5vWBv56bfMqgAtaUfbiCdRWy3XxScu+zCML8GhS
         5A19zlnfGUmKeLzH2oMSeAWrP3aj5p9G+vLfIsDsDM8lNEIKzJ21ePYeKSe0dkcL25
         R3SgJd4jTLkiQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8630160971;
        Tue,  5 Oct 2021 12:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netlink: remove netlink_broadcast_filtered
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163343580754.21299.10621182011227135752.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Oct 2021 12:10:07 +0000
References: <20211005115242.9630-1-fw@strlen.de>
In-Reply-To: <20211005115242.9630-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, christian.brauner@ubuntu.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  5 Oct 2021 13:52:42 +0200 you wrote:
> No users in tree since commit a3498436b3a0 ("netns: restrict uevents"),
> so remove this functionality.
> 
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/netlink.h  |  4 ----
>  net/netlink/af_netlink.c | 23 ++---------------------
>  2 files changed, 2 insertions(+), 25 deletions(-)

Here is the summary with links:
  - [net-next] netlink: remove netlink_broadcast_filtered
    https://git.kernel.org/netdev/net-next/c/549017aa1bb7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


