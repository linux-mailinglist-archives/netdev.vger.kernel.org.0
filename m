Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB243A34F9
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhFJUmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:42:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhFJUmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:42:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7111061419;
        Thu, 10 Jun 2021 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623357607;
        bh=aO4K6/jBgH801B2DguKrjFR4LerJDVVqdD0Y4lBjqh4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W+go+ZAvJP8Z44K/TjMcdf2EsFFw7AmEDyU5bDtwLTjQ6paUYqlI9p4Nh8BuiAfuf
         EakylcNLZEdciaCiyHMGIu0rjroYqrN4/7gVNMFbpWyFAayvmm2i/c8XXdwVjrRTzA
         hgBCNMJNZNKet5UviY7EqHYHvs8N/XPn2dwz9nBxZ0fi35rkxmEC7WAmI/RLs13C7J
         hu6AB62zF6iMMFFmHf+m/8JV/4qzjAmVRyF7b3hrQax8cEn2mtSpiMjAeLtXkxfLoF
         LvROWiuiyhQibO7S9KS4ESyCYbpfQwX6VtAX31hMj5OP30xpErit+1EVUejSHtZbMB
         4z266pESWju5w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6511C60A6C;
        Thu, 10 Jun 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] netlink: simplify NLMSG_DATA with NLMSG_HDRLEN
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335760740.27474.16215837875566738426.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 20:40:07 +0000
References: <87r1hemosc.wl-chenli@uniontech.com>
In-Reply-To: <87r1hemosc.wl-chenli@uniontech.com>
To:     Chen Li <chenli@uniontech.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 07 Jun 2021 09:44:35 +0800 you wrote:
> The NLMSG_LENGTH(0) may confuse the API users,
> NLMSG_HDRLEN is much more clear.
> 
> Besides, some code style problems are also fixed.
> Signed-off-by: Chen Li <chenli@uniontech.com>
> ---
>  include/uapi/linux/netlink.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Here is the summary with links:
  - netlink: simplify NLMSG_DATA with NLMSG_HDRLEN
    https://git.kernel.org/netdev/net-next/c/d409989b59ad

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


