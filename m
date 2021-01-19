Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112142FC380
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbhASWb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 17:31:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730379AbhASWau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 17:30:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 195EB23104;
        Tue, 19 Jan 2021 22:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611095409;
        bh=5rIQd0dcYzX9LW9juvUvJrvTDvfS5IHy01oz6JG7bWc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sfrBpT5MmULgHTMvAekAn8MB/of/GbiR2C/ATAPe7aYDfYKeFaseaxguqIe1HHdF0
         qXVL4JLmTBjXK4jW8wQf/QXWDyl7XdtboU2qpZKQcXQCr9ZsvWsl4uuPjnz7Qx/V1W
         5Aus5VZPydcZ6NvNBpd2r7/lAwiUNUrdH18qHufkYtGGCqKuPUR9xVwBBMwiIEa9vM
         lwDIG06dhqsSlE3y7lz6tllLe3P8u9adISiDIskNx0wBUBDc5L+Oxwlh2wCe3bhGSy
         eUxvLPxVs3o1zNcHobX4MB5lCGvQfrIvd4qSWIjnEhZeXoOrDXa6JllSW+q+OCWqot
         lS+ogw80Hj6zg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id EFDB760189;
        Tue, 19 Jan 2021 22:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] ipv4: Ensure ECN bits don't influence source address
 validation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161109540897.8518.1356785481446630724.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jan 2021 22:30:08 +0000
References: <cover.1610790904.git.gnault@redhat.com>
In-Reply-To: <cover.1610790904.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, fw@strlen.de, pablo@netfilter.org,
        kadlec@netfilter.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sat, 16 Jan 2021 11:44:18 +0100 you wrote:
> Functions that end up calling fib_table_lookup() should clear the ECN
> bits from the TOS, otherwise ECT(0) and ECT(1) packets can be treated
> differently.
> 
> Most functions already clear the ECN bits, but there are a few cases
> where this is not done. This series only fixes the ones related to
> source address validation.
> 
> [...]

Here is the summary with links:
  - [net,1/2] udp: mask TOS bits in udp_v4_early_demux()
    https://git.kernel.org/netdev/net/c/8d2b51b008c2
  - [net,2/2] netfilter: rpfilter: mask ecn bits before fib lookup
    https://git.kernel.org/netdev/net/c/2e5a6266fbb1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


