Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C427445CD4
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 01:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhKEACs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 20:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232040AbhKEACr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 20:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A285B61213;
        Fri,  5 Nov 2021 00:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636070408;
        bh=x/OYS7dMxW+2fJz5aisiqzeC2J+gW/AGkrHT82OrYG8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AXLO+1QnEkBgYldi8zgD+QFjq616bE5Xg1G1je1aQXAFpfLmdLQQ6pn902Df/ehi5
         ZqmgWynSM67VlDS5C3axvAfGvfbU7+z6kr8401K7TJodkV+gp8s/onnAlydJJ+vhiO
         TZfxzg9bni8ai5LB4N/6eX7Ryoo504VC2FxxIlOj+WPm5uo/YSVhhvjvQwksPU6zgS
         BO1fW5W4RhHzfesZmFY5bplsC9X6FsTU5zuX0TX1Sc6ITdeGNwb23gSwbVC7jNktm1
         BZxHZGc+nt4QKXEy4h4NcghAWNbiReV97QnHpUMwz6Ru1WKG7gAZzJqZPLNBZvs7F6
         HohCZT87Y6X5g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 945D160981;
        Fri,  5 Nov 2021 00:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] devlink: fix flexible_array.cocci warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163607040860.859.9217991818151034963.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Nov 2021 00:00:08 +0000
References: <20211103121607.27490-1-guozhengkui@vivo.com>
In-Reply-To: <20211103121607.27490-1-guozhengkui@vivo.com>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     jiri@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@vivo.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  3 Nov 2021 20:16:06 +0800 you wrote:
> Fix following coccicheck warning:
> ./net/core/devlink.c:69:6-10: WARNING use flexible-array member instead
> 
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> ---
>  net/core/devlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - devlink: fix flexible_array.cocci warning
    https://git.kernel.org/netdev/net/c/96d0c9be432d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


