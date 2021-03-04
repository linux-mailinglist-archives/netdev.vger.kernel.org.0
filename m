Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0853132DCA4
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241173AbhCDWBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:01:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240113AbhCDWAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E1B8B64FF1;
        Thu,  4 Mar 2021 22:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614895207;
        bh=kAdRuXURO3FsVryQQBu91lpf91+JpUniHKNGNZGdp58=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JZe44fmlbPyZ5i6qefRl8w9bK2nfuRbE2yu0eueaWtvNpajUnFPxf5cR/1FuW/Ehd
         H0CXcC8gk/dtcZjeGWXhDy4LxnI4z94CtwlqUpR8TdehL9jgWJp3c5y0HVL9/P0Eeq
         YGCB7iAIKg2xUfvFxG81YGpfzk32HebWxuIVWyJoJCkNZfZ9AoaQOWv/hdzo6OeSN6
         732rZ7dSsYbkgqSaliR8Brbzm3ncOMhZVs4tSAUgsZQ6W+qjXGDfFuvlL8x7nTQYwj
         kUQqFaXyZpwIxea4vATZ7NfXzUm7UTnL/pdV6Mb0JU7QrMBF4K1sQSLmvKhJEhGEtX
         k6sAsIW2BR7YA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D5DE360139;
        Thu,  4 Mar 2021 22:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sctp: trivial: fix typo in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161489520787.31844.6061045890075653097.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Mar 2021 22:00:07 +0000
References: <20210304055548.56829-1-drew@beagleboard.org>
In-Reply-To: <20210304055548.56829-1-drew@beagleboard.org>
To:     Drew Fustini <drew@beagleboard.org>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gustavoars@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  3 Mar 2021 21:55:49 -0800 you wrote:
> Fix typo of 'overflow' for comment in sctp_tsnmap_check().
> 
> Reported-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Signed-off-by: Drew Fustini <drew@beagleboard.org>
> ---
>  net/sctp/tsnmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: sctp: trivial: fix typo in comment
    https://git.kernel.org/netdev/net/c/d93ef301644e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


