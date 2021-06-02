Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD5839953E
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 23:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhFBVLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 17:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229623AbhFBVLt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 17:11:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4DC2E613EB;
        Wed,  2 Jun 2021 21:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622668206;
        bh=yCo2E3dQEYdMg3XcrtMStpSbLH8zf71bsb60HNkdwRo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WeFRKJlpKnQxBZtrIjd6ivqssTAcw5zjZ8HAdvoBlV+ItwlJpeRxrP4IyJzzcCWEc
         oAWKqDrDhXb6Ht5llSqsdOQBEIIUu4xwqpM0hFpMdwNsd4EppvGTxtqPaPjI1lYbIO
         9ecwb/u3nSm5Fcpzs8DUfnfRzu/E5BlWlcaHLvb91Bk20r12WuTRmQhHNAqzyH5ksi
         L0Iv6C3IuhOULAcYkW8OHcSrwSOG1iDl2V3p/hu8nllAiaEWC6cRLUX1tuDfYwZvp7
         C6DEFoq3ChfE/i1KqAEvF/XGhY6qof8CRJ9sDEpJ9PggUaBcPLB2FGEkqeGbSknYAj
         PmUSTHKrYW1VA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 433C660CE1;
        Wed,  2 Jun 2021 21:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] rxrpc: Fix a typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162266820627.24657.8656846589054266284.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 21:10:06 +0000
References: <20210602065508.105232-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210602065508.105232-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com,
        marc.dionne@auristor.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 2 Jun 2021 14:55:08 +0800 you wrote:
> targetted  ==> targeted
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/rxrpc/local_event.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] rxrpc: Fix a typo
    https://git.kernel.org/netdev/net-next/c/fe6c0262bdf9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


