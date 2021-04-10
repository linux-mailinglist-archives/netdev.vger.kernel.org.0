Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13ACD35A9A1
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 02:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhDJAkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 20:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235315AbhDJAkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 20:40:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 03F3761186;
        Sat, 10 Apr 2021 00:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618015210;
        bh=OnBb1ADRAE4YKtEuiO5DjKanjnJAUKptUuJWxLK8MtU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QFzeY0jey7vddhooCwIZJne/VKi2e9GXisSTYzAUvH2LjjRzILyqN4YdNjgDoV7ns
         5fsPuft3BaLBZyuTDQF1iSznFHYy4mYj87mDoJdVVIxwkf9LJ5TZR0eZDUa4PiA3aS
         KBR6faijZHYsasQlbqIgcZghKdTT2f6jxyMmvMqiQZJxY4gN+JlzeHm48r+oZfB1BR
         wDesOh3qbU6j5X0yvRQt1NsKsne2F7rCDs7llRdemOvRY9H5QWjbE5BdmefSmPy29S
         A5186ZfcqnmvlXe14fkYQuCSLL/7WTUNVV9Rne6aCo6Ms3mA2dlzfQWZ/M7NmAtusW
         dEcQAFNegd/+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EC61960C08;
        Sat, 10 Apr 2021 00:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] cxgb4: remove unneeded if-null-free check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161801520996.30931.14037111698882614941.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Apr 2021 00:40:09 +0000
References: <20210409115339.4598-1-linqiheng@huawei.com>
In-Reply-To: <20210409115339.4598-1-linqiheng@huawei.com>
To:     Qiheng Lin <linqiheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 9 Apr 2021 19:53:39 +0800 you wrote:
> Eliminate the following coccicheck warning:
> 
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c:529:3-9: WARNING:
>  NULL check before some freeing functions is not needed.
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c:533:2-8: WARNING:
>  NULL check before some freeing functions is not needed.
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c:161:2-7: WARNING:
>  NULL check before some freeing functions is not needed.
> drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c:327:3-9: WARNING:
>  NULL check before some freeing functions is not needed.
> 
> [...]

Here is the summary with links:
  - [net-next] cxgb4: remove unneeded if-null-free check
    https://git.kernel.org/netdev/net-next/c/524e001b7dca

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


