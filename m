Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF86A43B82A
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236344AbhJZRcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:32:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235192AbhJZRcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 13:32:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6C9CD6103C;
        Tue, 26 Oct 2021 17:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635269407;
        bh=vDxPmAg4oiIcRX+QLYYu6zI4FPw4gqv+fVRKh4h//BA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ij+u6ibMClm03YILWGzOYl5Vt3GkTWB0uKJfeveV8zKdqqGfToRhfbFzkJ9djlUP5
         7yC8uEwTqzf1vJa7TSRttFx5l/0zAFGVVR9x/4AN2DZGjdpXAcOJD4frBQmhFfZhmT
         mrufX4HOynNyR3JT6bxSUdXNk8kganMeVU2rcbtoDOs/O5Qax0LxFpA157ABzTEdFM
         gLkannLaCDhg6lq/vyYUaoAtVQSpRyDrCHual55aaCWGmaUUpJSYvnZ3v/qh0juwuw
         C3D8JjxFUR6nMyej3N2DqawND1Q57GbEXdGCL9lnu5/FEdJ627JxrCOtAmz1xehr3H
         L4xxKBKeLbqkA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5DFEB60726;
        Tue, 26 Oct 2021 17:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5: remove the recent devlink params
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163526940738.14989.1405994833076830797.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 17:30:07 +0000
References: <20211026152939.3125950-1-kuba@kernel.org>
In-Reply-To: <20211026152939.3125950-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, saeedm@nvidia.com, netdev@vger.kernel.org,
        leonro@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Oct 2021 08:29:39 -0700 you wrote:
> revert commit 46ae40b94d88 ("net/mlx5: Let user configure io_eq_size param")
> revert commit a6cb08daa3b4 ("net/mlx5: Let user configure event_eq_size param")
> revert commit 554604061979 ("net/mlx5: Let user configure max_macs param")
> 
> The EQE parameters are applicable to more drivers, they should
> be configured via standard API, probably ethtool. Example of
> another driver needing something similar:
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5: remove the recent devlink params
    https://git.kernel.org/netdev/net-next/c/6b3671746a8a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


