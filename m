Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F9E45E6A9
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358063AbhKZDzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 22:55:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242843AbhKZDxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 22:53:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 01893610F7;
        Fri, 26 Nov 2021 03:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637898611;
        bh=w8IlxZhladucXAFbChFSb0GxuhemT51p/OyAOvqGNZ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RrgTQQJ3rSFUEdtdVwe3r1p4Fk5IYGqPd2XGTz7RS/8MjmlJGGUUUmUiDnU3i8eEB
         O7BvTMwPQVvWPCp7JeH5PMvNfn25+hmZ+a1xpQrLpsgA3UEWFtPidWmh3IN5wllFYb
         ccRvvzRKhSE1yjv9KqKhoziSsBVburEfw3qCFp8g6YZz7pF9bNwDreAonJ5hyqhOU6
         yvglKpbLwiwT3LjU1EMJwl11zQXuPOGil3xred8md/YKITPsVlLQvggmqYE4mEF5ld
         zIZIZrzNRFGPJl4hUyefQXtRhg4FKiZuMVKJQB4J9R1v0ndjskpSd6MVegSl8zfhky
         nYX40E3h9nFYw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E7558609B9;
        Fri, 26 Nov 2021 03:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] net: ipa: small collected improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163789861094.16578.6840009676355251826.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 03:50:10 +0000
References: <20211124202511.862588-1-elder@linaro.org>
In-Reply-To: <20211124202511.862588-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pkurapat@codeaurora.org,
        avuyyuru@codeaurora.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        evgreen@chromium.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 14:25:04 -0600 you wrote:
> This series contains a somewhat unrelated set of changes, some
> inspired by some recent work posted for back-port.  For the most
> part they're meant to improve the code without changing it's
> functionality.  Each basically stands on its own.
> 
> 					-Alex
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: ipa: kill ipa_modem_init()
    https://git.kernel.org/netdev/net-next/c/76b5fbcd6b47
  - [net-next,2/7] net: ipa: zero unused portions of filter table memory
    https://git.kernel.org/netdev/net-next/c/dc901505fd98
  - [net-next,3/7] net: ipa: rework how HOL_BLOCK handling is specified
    https://git.kernel.org/netdev/net-next/c/e6aab6b9b600
  - [net-next,4/7] net: ipa: explicitly disable HOLB drop during setup
    https://git.kernel.org/netdev/net-next/c/01c36637aeaf
  - [net-next,5/7] net: ipa: skip SKB copy if no netdev
    https://git.kernel.org/netdev/net-next/c/1b65bbcc9a71
  - [net-next,6/7] net: ipa: GSI only needs one completion
    https://git.kernel.org/netdev/net-next/c/7ece9eaa3f16
  - [net-next,7/7] net: ipa: rearrange GSI structure fields
    https://git.kernel.org/netdev/net-next/c/faa88ecead2f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


