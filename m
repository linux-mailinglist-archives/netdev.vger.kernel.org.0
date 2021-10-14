Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6929C42E47F
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 01:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbhJNXCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 19:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233564AbhJNXCO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 19:02:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E1EA061108;
        Thu, 14 Oct 2021 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634252409;
        bh=61AgqlTJ73LZGj35B3xMdd8nKgYSRrMcnHqW6gszcYE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BSpc8GHN6r9T2PY6S0bevErpCreRKMxV2/MoD2HRkBbunycbf/rEc1BTsBm1N+l5r
         go9IanNb4A1YOk+x3SuHbGsiqVo+2CxQofUCS62UwKNseLzuXCzEcQuR4v3u6Mwfq4
         YxHZ3swviGiOtGlR/lNaealm0m8wKi1HkwtmR1gApnhUk5fwV5dUr0mmsiRcaHH/AL
         BTADk7B2yfGENcgSBZ76e3BnRsbZsSzIDF9IvNWWmHnMqtkDsfMwAzbzTvx4YIoieP
         Nr7jvFx3ITvMhYDTN9j25WTHCsQBtRd69aY8GZyffVdrO1Y2H4qoriYAI/Ha2M1zOx
         F01kz6ZvltPOg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D269D60A47;
        Thu, 14 Oct 2021 23:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethernet: remove random_ether_addr()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163425240885.7869.2933638137402379748.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Oct 2021 23:00:08 +0000
References: <20211013205450.328092-1-kuba@kernel.org>
In-Reply-To: <20211013205450.328092-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        grygorii.strashko@ti.com, vigneshr@ti.com, joe@perches.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 13:54:50 -0700 you wrote:
> random_ether_addr() was the original name of the helper which
> was kept for backward compatibility (?) after the rename in
> commit 0a4dd594982a ("etherdevice: Rename random_ether_addr
> to eth_random_addr").
> 
> We have a single random_ether_addr() caller left in tree
> while there are 70 callers of eth_random_addr().
> Time to drop this define.
> 
> [...]

Here is the summary with links:
  - [net-next] ethernet: remove random_ether_addr()
    https://git.kernel.org/netdev/net-next/c/ba530fea8ca1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


