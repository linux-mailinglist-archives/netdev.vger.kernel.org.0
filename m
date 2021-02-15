Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6D631C31B
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 21:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhBOUky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 15:40:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:53670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229708AbhBOUkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 15:40:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C31D564DFF;
        Mon, 15 Feb 2021 20:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613421608;
        bh=BO/HhLLjhDFDpZGAjDPQHZqATBYu/tCU6OdFFtZvJw8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IIxqOVicL5V4mtrJQ71gF+K/lhpM29zZ/1SV3/7/VTKA6OGFJU8+jskrF1urTcOSf
         w50jxRdtIawyHea9f21ZyXFhKi/EHBwdr69P+gTKaiaM+Sgv6wl6VaR1hZMPdmvLKG
         CGzH9oy2sqw1rjl9KOIXWQwhJ3y1GzybusM2dq2sOy1nRdtmJzUYlyapMYbxJOuemN
         ndA/FyV/0Y9h1DEcCkFUHktPnWcCNwE5HU7iN9hGN7y2fkoitYotAAOzKntMdum4Hj
         j7igEzKTkpavRg7XNJITL6env1yQmRigz55eXKEngcOzXIdslojzou9WtG+Q0wn337
         nr77yNW0JRTSA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B530B609D9;
        Mon, 15 Feb 2021 20:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: fix resuming from suspend on RTL8105e if
 machine runs on battery
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161342160873.4070.5046035591246485167.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 20:40:08 +0000
References: <5b0846b2-64ca-90ee-b5a5-533286961142@gmail.com>
In-Reply-To: <5b0846b2-64ca-90ee-b5a5-533286961142@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 14 Feb 2021 17:38:30 +0100 you wrote:
> Armin reported that after referenced commit his RTL8105e is dead when
> resuming from suspend and machine runs on battery. This patch has been
> confirmed to fix the issue.
> 
> Fixes: e80bd76fbf56 ("r8169: work around power-saving bug on some chip versions")
> Reported-by: Armin Wolf <W_Armin@gmx.de>
> Tested-by: Armin Wolf <W_Armin@gmx.de>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: fix resuming from suspend on RTL8105e if machine runs on battery
    https://git.kernel.org/netdev/net-next/c/d2a04370817f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


