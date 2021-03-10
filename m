Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AF5334CAE
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 00:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbhCJXkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 18:40:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232948AbhCJXkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 18:40:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B11DA64FD0;
        Wed, 10 Mar 2021 23:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615419611;
        bh=puAacWCf00HWlmhb5k32BwDV2YxaIga2cu0KOjiS/MQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N5rozPJZ3w2h8M8ZpeoB1z2GKdybdHb0vZFTod+Y6wllWCChPhde13aiC2Mx6yriL
         cgY0bxBLKFkCNPk0d6wiROPNvIpm/B84RaIaCXMx15URZt6mldi8/ROPbhsYHR9tRI
         JWef9qmkOZE4k76nR3Vu74hr5R8WF/RA4nvQe1OFWCtnseAhj+oNlo4/J5Hi4kQ+Ek
         8PV0KZo7flLGlYHdEepaCBjl0UqWYn8lXyltwipdUTGU+LXH58ind1FFyF2c5WNpht
         bzT4OOquGJ3lNhrOlHwzOvGT23cFFAWKqh4eD3MwdeFpP+IFlAhQN2r69j/JW3AD66
         mQ6aGj8Z4o7Ew==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A7B986096F;
        Wed, 10 Mar 2021 23:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] drop_monitor: Perform cleanup upon probe registration
 failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541961168.10035.10689770985511848301.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 23:40:11 +0000
References: <20210310102801.2531062-1-idosch@idosch.org>
In-Reply-To: <20210310102801.2531062-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        nhorman@tuxdriver.com, jiri@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 10 Mar 2021 12:28:01 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> In the rare case that drop_monitor fails to register its probe on the
> 'napi_poll' tracepoint, it will not deactivate its hysteresis timer as
> part of the error path. If the hysteresis timer was armed by the shortly
> lived 'kfree_skb' probe and user space retries to initiate tracing, a
> warning will be emitted for trying to initialize an active object [1].
> 
> [...]

Here is the summary with links:
  - [net] drop_monitor: Perform cleanup upon probe registration failure
    https://git.kernel.org/netdev/net/c/9398e9c0b1d4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


