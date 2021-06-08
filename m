Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497EB3A01AB
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbhFHSzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 14:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235470AbhFHSvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 14:51:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4062661481;
        Tue,  8 Jun 2021 18:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623177604;
        bh=Sl7cII4vsIYxWYCQSlIPiEigwabN80Fh8EQVEiss+pI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iWM9qC5r/1ZQ36J7LXUPyAj/kqTi+UXLoRTKMv0zmBGXSYp3Xp1mgACzK1KT5tOwS
         zPrJrSzv4IFyI024SfZaxVxZvhbSeVTLQgMv+f4audCvDjvf1yIHYTC1Z5OsWlAL4+
         7r2mEmh+lfauuT2pp+FGCs15m9v97efy26HmdHsx0aFTkrrRLnAycmHPpeuT5mxDCP
         n22WU9rObA7OY1J5ViI1YGdtnLiWp7+V6c1SOVP5G3DQhBqx+LgldNZJaDbV18ceSx
         Mqg4orLORpt4MCn6rpC0d237i5HwonB4+0M3jpOslEc5loeqD9kCxMxnIFqEIv8g/4
         QOf2bYaB6MlzA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2FBE360BE2;
        Tue,  8 Jun 2021 18:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: appletalk: fix the usage of preposition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162317760418.20688.15702801907224648787.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 18:40:04 +0000
References: <20210608021932.7308-1-13145886936@163.com>
In-Reply-To: <20210608021932.7308-1-13145886936@163.com>
To:     None <13145886936@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  7 Jun 2021 19:19:32 -0700 you wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> The preposition "for" should be changed to preposition "of".
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/appletalk/aarp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: appletalk: fix the usage of preposition
    https://git.kernel.org/netdev/net/c/d439aa33a9b9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


