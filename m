Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D193D3E05
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhGWQTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhGWQTb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 12:19:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DA98D60EAF;
        Fri, 23 Jul 2021 17:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627059604;
        bh=mRo6BjyDtVQ1vFvtwhl4otTL1j+wr8E7OZErkmbj9Dw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c7NEE53I51PTDwclggclOOVuTd6FYc7YEVWTTqOwylQF41+AsEwDO4pytSVg5sDJ1
         1f8mjo844VvD3hv866qKscCrTFGbZj1NjIGg2AUJPeosGfNMJDmqVvyK3zOLBXEGAs
         mFxsLuz5OM1W5HsVxj0IB+s1f2jHkcRcvy/Unwh1YGmIHp2o2yjcf3L3Zgw3M94L8G
         a+b/L22G3X+iuRr5kfx/3iXOUML9CkkubkoAODAjTKxj8Zz1OMS9sq8nww6R3PoCGc
         QLMDjWBAcrIE7bgMotzAhPSkVomy4jABCaB8S5QSEG4QgWeW/1CvYl5JQ0Jym5GiWq
         sbrkVFQYxO0ww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CEC8860721;
        Fri, 23 Jul 2021 17:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: port100: constify protocol list array
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705960484.25754.8759339069170035865.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 17:00:04 +0000
References: <20210723092034.22603-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210723092034.22603-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Jul 2021 11:20:34 +0200 you wrote:
> File-scope "port100_protocol" array is read-only and passed as pointer
> to const, so it can be made a const to increase code safety.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  drivers/nfc/port100.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - nfc: port100: constify protocol list array
    https://git.kernel.org/netdev/net-next/c/c65e7025c603

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


