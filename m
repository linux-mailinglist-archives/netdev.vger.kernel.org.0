Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2806C33A1A7
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 23:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbhCMWaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 17:30:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232974AbhCMWaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Mar 2021 17:30:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D312964ECE;
        Sat, 13 Mar 2021 22:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615674607;
        bh=AoRl5PN34oZXShy+dJzPxdTQCQvlXfS0glTpi1y+XI8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OUMpN4qOwMxPrvIXwN9mOlVuu3D5OpyQKj//beQj5QQfwMVFeo0QKeN/bGsg8VNIm
         8ZohVHJLqSVHpZ9dicSbPyC2l1o3UoYcZpK+ynaxjEl2d0w5VVDm82ddKXJQqsptbJ
         rBGKqmESANtmNre0trsOt0GuW0fKimpq1UPudh9lNSlTA9OVwMWFBhOD/1rYTaCZPk
         54Grx+vVaTfzrRCBp+fIMH6hUcz7bQSmBl8U5cUE/bko/AAmpOen2BPJD9rcQ+LjHI
         Lkv4IWUOOJsGgmmrMeDYkApNDV1B3b3FADV1MktsItmBv1b1WXvrKNrf9cwNQICha9
         NoKWxlzNJ2p+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C5E6660971;
        Sat, 13 Mar 2021 22:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ipa: terminate message handler arrays
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161567460780.27846.16946733515989586689.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Mar 2021 22:30:07 +0000
References: <20210312151249.481395-1-elder@linaro.org>
In-Reply-To: <20210312151249.481395-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, sujitka@chromium.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 12 Mar 2021 09:12:48 -0600 you wrote:
> When a QMI handle is initialized, an array of message handler
> structures is provided, defining how any received message should
> be handled based on its type and message ID.  The QMI core code
> traverses this array when a message arrives and calls the function
> associated with the (type, msg_id) found in the array.
> 
> The array is supposed to be terminated with an empty (all zero)
> entry though.  Without it, an unsupported message will cause
> the QMI core code to go past the end of the array.
> 
> [...]

Here is the summary with links:
  - [net] net: ipa: terminate message handler arrays
    https://git.kernel.org/netdev/net/c/3a9ef3e11c5d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


