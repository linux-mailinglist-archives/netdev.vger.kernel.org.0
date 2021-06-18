Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6713AD2BD
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235744AbhFRTWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:22:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235396AbhFRTWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9CB96613F7;
        Fri, 18 Jun 2021 19:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624044006;
        bh=sP7YjnmekUZ5Bvmj8tL6NliJV1CKgtZmlG01f/E8TlU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WW1eXAisEluXwW0uCicPHwPOcvcsnCXjgyFw428KVXmAPZavzaNe+Z99SjbwnW3gd
         1TVP+Qbg7jIC2MatqMVYSzI3UeZuA/5mrEsoGAhkmecGz/ubKZ4+MiMPx3ADv8FzKQ
         NDv5sITjJLvMo38Rue6RVC7GbSqsnucvJzCRXCcdnMgL8dPVgaALybTXvNP0BczxJz
         xEIlK/ZzXIEQ1T04SuknlMrIcx98mgiwqrJwsYg6sgvkDEanBfwS6zTLU2djIxfVno
         FCFHk/88co1kEuN7nMFGhn8sYecZ/wLuq9u2pyuWut5FSfyPP3i18NQm83tYehC5Zy
         NLvn+rrkVZiCA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 894CD609D8;
        Fri, 18 Jun 2021 19:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] NFC: nxp-nci: remove unnecessary labels
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404400655.12339.10945856667476602559.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:20:06 +0000
References: <20210618091016.19500-1-samirweng1979@163.com>
In-Reply-To: <20210618091016.19500-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     charles.gorand@effinnov.com, krzysztof.kozlowski@canonical.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 17:10:16 +0800 you wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> Simplify the code by removing unnecessary labels and returning directly.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> ---
>  drivers/nfc/nxp-nci/core.c | 39 +++++++++++++--------------------------
>  1 file changed, 13 insertions(+), 26 deletions(-)

Here is the summary with links:
  - [v2] NFC: nxp-nci: remove unnecessary labels
    https://git.kernel.org/netdev/net-next/c/96a19319921c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


