Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC183B48C9
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhFYScY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhFYScY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 14:32:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8D51661474;
        Fri, 25 Jun 2021 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624645803;
        bh=CRLjIR1ijdYRZXRTTc0GN4JspXYWthvYfYDvS48/ed0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N8P4OD5wZaE/uYADmWlr9EVwQ53y8f4mzqFAfaro+pAlGY3aYBUEOLfWUgj3aWOHT
         2m3SbiGz9atE4JW61XmzSa6F7tUl5u6/bGOX6ZysHJKIgm//abSAI1uoKBNQd2eJfp
         +/yoHMxmSoC9P4RUKQQ15lKcWdnI3X/Ub3CkvaCJtWRUQHhfQzkMJBdBWui0aU+fGj
         yvENWpusKnWE4D1u44eIuM53iUbqjJ/SexaVcgQYADCAL6R5Ri8JIoTM8mLWGlFM3X
         KchTgRhjoLhpImyn3I5isGmuvORh/OEt4/F5zw1M2ZE5gZxbYlH7etiQNxjUf9/H1b
         +46XG2U6qgYvQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7B3AF60A71;
        Fri, 25 Jun 2021 18:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] gve: Fix swapped vars when fetching max queues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162464580349.23134.2747049528231866908.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Jun 2021 18:30:03 +0000
References: <20210625025542.4057943-1-bcf@google.com>
In-Reply-To: <20210625025542.4057943-1-bcf@google.com>
To:     Bailey Forrest <bcf@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 24 Jun 2021 19:55:41 -0700 you wrote:
> Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
> Signed-off-by: Bailey Forrest <bcf@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net] gve: Fix swapped vars when fetching max queues
    https://git.kernel.org/netdev/net/c/1db1a862a08f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


