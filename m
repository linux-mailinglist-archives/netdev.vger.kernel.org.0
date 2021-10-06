Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1263D423FEF
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238859AbhJFOWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231403AbhJFOV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 10:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 87CC461186;
        Wed,  6 Oct 2021 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633530007;
        bh=4A5t5h1lJ/nKnlqSS0X4DszwSt5j5PYEZm9ZGF/8onA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OhuoXoUZtoEl01k+Hsp8JVzpWcNj8XnQt2PfbOnvfopW3AqpOnb3yv80xxcan34OJ
         d9waTby4/0OcIWlzFKRu3tkRPEaMZMEEvwCsNFUUC6dIgyoAWwehwgo3uVRKhxWn5N
         EP3O1aTTn73RUvAcTZ98YJC6peEszgZjkF+YpdSijzStKD6jZbPjTsRAJgS4n0fO/w
         VReXTqWkuiO+b6ai1bqRE83aIuxKIwelCTUqB7xZ6zphirLst8uSymVCKXMjOCY2uC
         2F4vK8DUC1OPuO6mjvGIxvTdV7paB3Yxlh2zC8RUP6VWYt0uoo00xUbydRdRTV1P9K
         4mu5N2BGdoRsw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7A32A60971;
        Wed,  6 Oct 2021 14:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] gve: fix gve_get_stats()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163353000749.15249.7133115804144586829.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Oct 2021 14:20:07 +0000
References: <20211006003030.3194995-1-eric.dumazet@gmail.com>
In-Reply-To: <20211006003030.3194995-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, csully@google.com, sagis@google.com,
        jonolson@google.com, willemb@google.com, lrizzo@google.com,
        jeroendb@google.com, xliutaox@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  5 Oct 2021 17:30:30 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> gve_get_stats() can report wrong numbers if/when u64_stats_fetch_retry()
> returns true.
> 
> What is needed here is to sample values in temporary variables,
> and only use them after each loop is ended.
> 
> [...]

Here is the summary with links:
  - [net] gve: fix gve_get_stats()
    https://git.kernel.org/netdev/net/c/2f57d4975fa0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


