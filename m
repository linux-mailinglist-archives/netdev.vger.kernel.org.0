Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFE9423FF1
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238953AbhJFOWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238807AbhJFOV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 10:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9B3D1611C5;
        Wed,  6 Oct 2021 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633530007;
        bh=/601lZPJvMezJjFN1pGuShGv5oKu3moekdfTsjfRVMI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aV3W9S/gYjG6GI0NMvm8EqmsCoNcSQIoG2PXtnK/psLCM5ezhfa1Xnj3Np4sWzi1b
         vceA0X8LqaePbd77id832nnBd0al928lRzDdL5uMCPxQ7ypWt3FdfknSKDd7NMEIm6
         MrzYgpEC9PtAq3hLCxibOO+P02YwA5f0w9LTpGsG8ehaPc2XwZ45O7NteeU4u5VZgC
         TbRuP4TgR0KzTaSJR4gIOpf6kIPmJH8zaxbE6OE+0Agxt6p4HoM7U/6pvzp7SESnli
         VUgs+PAuy0Qac0B1vzsTUDGKxwCj8qGgInnDzZAmHMmUXnnKagx9ngO0x/iYMmCR6y
         uw64G+PGW4dTg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9613260A54;
        Wed,  6 Oct 2021 14:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rtnetlink: fix if_nlmsg_stats_size() under estimation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163353000761.15249.9904374351678021605.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Oct 2021 14:20:07 +0000
References: <20211005210417.2624297-1-eric.dumazet@gmail.com>
In-Reply-To: <20211005210417.2624297-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, roopa@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  5 Oct 2021 14:04:17 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> rtnl_fill_statsinfo() is filling skb with one mandatory if_stats_msg structure.
> 
> nlmsg_put(skb, pid, seq, type, sizeof(struct if_stats_msg), flags);
> 
> But if_nlmsg_stats_size() never considered the needed storage.
> 
> [...]

Here is the summary with links:
  - [net] rtnetlink: fix if_nlmsg_stats_size() under estimation
    https://git.kernel.org/netdev/net/c/d34367991933

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


