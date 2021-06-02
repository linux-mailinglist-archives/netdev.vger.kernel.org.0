Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF6E397D8F
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235501AbhFBAMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235288AbhFBALu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5B630613DD;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622592608;
        bh=0+gY4zU8Qo9TskwiIThoO1m3qafAMjc/Qd1Whn5mep8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D0QGVFAuN2Vl8EgOrozvbIFCVkXJBAC4rI/0QTlaabvDOr1arHjS/zU5eW5Iq5ANQ
         ku17DbYcbhA0ww3bWDjOQ/82ZbB6JdH0NwvyXcUnhavyMgwuG5uo6ayLHkUKp/mc3b
         pL9NdQ3+gD2Y0hJzUf2y6o1+o70eRbwddPDwURSJgjL43lV800SBvLgatdG9wPaV7q
         xAwnNs0zkiyHPIgIgwHJ58xjbI6OeTluOUb9LDjYDp/U7ksLmVKVRVT6niYXVHHD74
         LYhyFGuYdBhK9xZTRLN7XuIab6b/lRrV6ZdJOk1+S9vL87k5lepmtXzXk96NpmGIiZ
         FvgbealjvfNJQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 55664609EA;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] vrf: Fix a typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259260834.22595.646802601444241835.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:10:08 +0000
References: <20210601141635.4131513-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210601141635.4131513-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     dsahern@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 22:16:35 +0800 you wrote:
> possibile  ==> possible
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  drivers/net/vrf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] vrf: Fix a typo
    https://git.kernel.org/netdev/net-next/c/e9a0bf6d002f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


