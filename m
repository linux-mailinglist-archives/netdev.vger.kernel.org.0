Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C5F2E2159
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgLWUas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbgLWUar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 15:30:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 51B2B223E4;
        Wed, 23 Dec 2020 20:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608755407;
        bh=gbXA0HiiLMnD82+h+/O/OdCLuqUhAUhQX7L2oVlfYuQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UM/xnOiSPLGclqL3NvB472HGytJevGC/Z7jr5UF1Tf2GwcbpD8r/rvuRoPN/lliXa
         QJWjnNeFY1poNef+whiZL41RoIpJRhWz/Hkc3hIa68DbHj5Xa+xUF0PJxHy8YRTRKt
         0zkWaGu0q9hCwOYpwHf8pjkL0V2BisPJ44FQq4Poyu/psTW4tdhpkwLG4n4M5ZVTvU
         jWKB54e4ZBY9aZaFtGE9jskI4NPr/SXKvswDn6VGV4uS16Od2lln9sLWoOG/TR+y8R
         l4IAndGLsOJmZmBmveekX+tUUafsIcJm9fssSl5G+yEtQ4w4MRaa56sZuAjd3EJ6T0
         U53VBQ2ylZj7Q==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 4495260591;
        Wed, 23 Dec 2020 20:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/ncsi: Use real net-device for response handler
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160875540727.22675.4014902394187524909.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Dec 2020 20:30:07 +0000
References: <20201223055523.2069-1-wangzhiqiang.bj@bytedance.com>
In-Reply-To: <20201223055523.2069-1-wangzhiqiang.bj@bytedance.com>
To:     John Wang <wangzhiqiang.bj@bytedance.com>
Cc:     xuxiaohan@bytedance.com, yulei.sh@bytedance.com,
        chenbo.gil@bytedance.com, joel@jms.id.au, sam@mendozajonas.com,
        davem@davemloft.net, kuba@kernel.org, gwshan@linux.vnet.ibm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 23 Dec 2020 13:55:23 +0800 you wrote:
> When aggregating ncsi interfaces and dedicated interfaces to bond
> interfaces, the ncsi response handler will use the wrong net device to
> find ncsi_dev, so that the ncsi interface will not work properly.
> Here, we use the original net device to fix it.
> 
> Fixes: 138635cc27c9 ("net/ncsi: NCSI response packet handler")
> Signed-off-by: John Wang <wangzhiqiang.bj@bytedance.com>
> 
> [...]

Here is the summary with links:
  - [v2] net/ncsi: Use real net-device for response handler
    https://git.kernel.org/netdev/net/c/427c94055856

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


