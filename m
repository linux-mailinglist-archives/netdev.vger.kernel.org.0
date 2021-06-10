Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95FC3A351E
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhFJUwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230294AbhFJUwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:52:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C58A96141D;
        Thu, 10 Jun 2021 20:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623358206;
        bh=OLCtVh65ZZU77JY37oRtbRO+WOtkt2lNHnP3NDBNhgY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EV3xdYcCusyEb6JMiFEEAN7etTWJmibglbbJudJTbEKKq5rL4qVjSiJ58YU+Iq1oF
         tBe8D9JYEq461LufvnFDUb/I0ivHNB9p9OizM08BZXuUFiTrJnMAR7maPywm/iCRJI
         1Yydv11JNlm7hDPMK1qPUPR91X/PXjY572jxcMJj0BxHOUZ4mVKccgOPA3fmGbkfbi
         grS0uogMIAqkjvgVxd8dINgaNkP4q52YkdLJnpe6nXB00nUBBY1hSdb+BM+rdpvyGH
         56a93AAG2rVLChTm2iBkXQYVsowkuT9freaTmg7a+LxC2XIVArP0kj7mdtT9ihHZRH
         XQNYOf0tuaKGw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BF61F60BE2;
        Thu, 10 Jun 2021 20:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tipc: socket.c: fix the use of copular verb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335820677.975.10680513951676624271.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 20:50:06 +0000
References: <20210610061853.38137-1-13145886936@163.com>
In-Reply-To: <20210610061853.38137-1-13145886936@163.com>
To:     None <13145886936@163.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, gushengxian@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  9 Jun 2021 23:18:53 -0700 you wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Fix the use of copular verb.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/tipc/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - tipc: socket.c: fix the use of copular verb
    https://git.kernel.org/netdev/net-next/c/326af505ca1f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


