Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15053B0BD7
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhFVRwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhFVRwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:52:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1645761042;
        Tue, 22 Jun 2021 17:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624384206;
        bh=dUBkNoAZdExG9xx44mp75eO46jyvxdrvH5IuVJ1+0x0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Re4Z4jFA03s6a6eh0tt2nc9ig1mChfGXs6kM+FuoL61WXb9XZvysBUtEh/Ne+M0dX
         SaXxuvYN5lfNMnXfbya1OBVwLXlslmvF4Rcc/HJxuDuLLeAitztCfUWW/pQwhaoC8B
         UXX7SjeOzh6nK402YlFb3KxgKr2aF0XPcAG4SxGMJqhCKhax6gEcLjr50bet8dXWed
         wAWSry23/FnLcE9FclrgLzAYTCzYc3BlcIqE+XlgTVoQslbSF+pgJH9IOZmLDL6V0X
         qBppInUHZjMILpi+C8S/wDN1qLcKoOzNF7ECgAB70ZBYJc2TUIdSkcBSYd7UUdVITt
         4A1F+xTRyzpvw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 063C760ACA;
        Tue, 22 Jun 2021 17:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] MAINTAINERS: network: add entry for WWAN
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438420602.559.10958137592738083442.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 17:50:06 +0000
References: <1624371700-13571-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1624371700-13571-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 22 Jun 2021 16:21:40 +0200 you wrote:
> This patch adds maintainer info for drivers/net/wwan subdir, including
> WWAN core and drivers. Adding Sergey and myself as maintainers and
> Johannes as reviewer.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  MAINTAINERS | 10 ++++++++++
>  1 file changed, 10 insertions(+)

Here is the summary with links:
  - [net-next] MAINTAINERS: network: add entry for WWAN
    https://git.kernel.org/netdev/net-next/c/1b134d8d756a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


