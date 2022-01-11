Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C8148A760
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 06:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346119AbiAKFaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 00:30:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56220 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343853AbiAKFaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 00:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33195B818AF;
        Tue, 11 Jan 2022 05:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4396C36AE9;
        Tue, 11 Jan 2022 05:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641879009;
        bh=6iJxN2MjgPAq0103lhGptUXdi0bh1hrnAZyMRBS6Dew=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VmoaJc1gtsDe2pD9fipJguNYaP+eIZCJ4GEPBzMIaIOW1PS1uvfnWR/0uawwf0/de
         LOxYXZJA6q/cLIny7QzYN3WP4JdjK3KoYn9xfFpaNpv3q5mPu6P5cTV/YPjoJs+bFu
         YtU9mbHnJxiNJ+fEAtwSZJWPw+4d7DFlFgQ5OiDPeHmDzAbMSf41stmgw8m0GiaH/O
         gQNdWg0OHy3M2qM1HWAX8u5ih04ZNjwlrxWMDZEcJy3mu5tQQ+v9MvVdWCZCA3YUzs
         etXsvhG6HAuOUHwFWZitWm0m+zQcPkPnS4o+HUrn/UwVXjwI4KvVrNP5WkfHQ83Me2
         aLb63/flmtk+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B4E15F60795;
        Tue, 11 Jan 2022 05:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netfilter: nf_tables: typo NULL check in _clone()
 function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164187900973.26519.12070934336813677088.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Jan 2022 05:30:09 +0000
References: <20220110194817.53481-1-pablo@netfilter.org>
In-Reply-To: <20220110194817.53481-1-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, jwiedmann.dev@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 10 Jan 2022 20:48:17 +0100 you wrote:
> This should check for NULL in case memory allocation fails.
> 
> Reported-by: Julian Wiedmann <jwiedmann.dev@gmail.com>
> Fixes: 3b9e2ea6c11b ("netfilter: nft_limit: move stateful fields out of expression data")
> Fixes: 37f319f37d90 ("netfilter: nft_connlimit: move stateful fields out of expression data")
> Fixes: 33a24de37e81 ("netfilter: nft_last: move stateful fields out of expression data")
> Fixes: ed0a0c60f0e5 ("netfilter: nft_quota: move stateful fields out of expression data")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net-next] netfilter: nf_tables: typo NULL check in _clone() function
    https://git.kernel.org/netdev/net/c/51edb2ff1c6f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


