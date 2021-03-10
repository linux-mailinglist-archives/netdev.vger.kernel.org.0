Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8600334CB5
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 00:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbhCJXkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 18:40:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:40756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233146AbhCJXkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 18:40:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0008364FD6;
        Wed, 10 Mar 2021 23:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615419613;
        bh=OkOOTAZ5YyQq+PNEMEU2dmQ4sn0GA6V5fQRroyUi1MM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ebhfZGx5w4J4dEtlPmqF12nYkOWKfjwkyXsX/41NycGw3oVNNYTHUwvvkjhamayJX
         XMZtQ2Wfz/RiUlSf9bfpVJAtx9laWrLY5r5O+lIzBA1qcYPth8RWYQrudD7wcbhTEO
         qWW7tArQIow98a+ICNp88at1hrNuf17DpJ5W2u7uUNwHFMHptZgfFW7lCINrDjll6D
         CG+8U0MYBKy2VjSRkpgf+Y7QUUmZ559frCbgDqiZyto3pJm7txyQxPyHQa6zrHYcHg
         MnWu4oZWkPm3+ZmF4RomQ9ILs4Fjkay9FbNBZGV64tABV8zun48SkNGa1QxS+zW/VE
         f6TKUVyaKeNZw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EFD21609BB;
        Wed, 10 Mar 2021 23:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] ionic Rx updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541961297.10035.17549484699846993439.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 23:40:12 +0000
References: <20210310192631.20022-1-snelson@pensando.io>
In-Reply-To: <20210310192631.20022-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Mar 2021 11:26:25 -0800 you wrote:
> The ionic driver's Rx path is due for an overhaul in order to
> better use memory buffers and to clean up the data structures.
> 
> The first two patches convert the driver to using page sharing
> between buffers so as to lessen the  page alloc and free overhead.
> 
> The remaining patches clean up the structs and fastpath code for
> better efficency.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] ionic: move rx_page_alloc and free
    https://git.kernel.org/netdev/net-next/c/2b5720f26908
  - [net-next,2/6] ionic: implement Rx page reuse
    https://git.kernel.org/netdev/net-next/c/4b0a7539a372
  - [net-next,3/6] ionic: optimize fastpath struct usage
    https://git.kernel.org/netdev/net-next/c/f37bc3462e80
  - [net-next,4/6] ionic: simplify rx skb alloc
    https://git.kernel.org/netdev/net-next/c/89e572e7369f
  - [net-next,5/6] ionic: rebuild debugfs on qcq swap
    https://git.kernel.org/netdev/net-next/c/55eda6bbe0c8
  - [net-next,6/6] ionic: simplify use of completion types
    https://git.kernel.org/netdev/net-next/c/a25edab93b28

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


