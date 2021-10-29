Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7708243FCA5
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhJ2Mwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231367AbhJ2Mwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 08:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 03C3B611C3;
        Fri, 29 Oct 2021 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635511809;
        bh=Ir5AqHPTVA6ls3NhaH39nBMLAS4uAOL+78kKnKyvoec=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jqB5k2r05gXnDSliXgYSOnBXa7ntBwgPUGbTRFiFMxxOZD11W7HK9PiylBRZ9R7iF
         nro5Sd7jyDoCF0177dDa7WQYuIJD7EYvGV5TNa6LGhGf+imK7qtR7Gxst3FI7DLKIE
         QmE3onUIP7Wx7Q/JoXDcPOAhcosaS+d/5Ky8yxQ13wrp5fioAb/ISr2+bTxqIzdUdN
         g4gzKXg40+4Qk48u4OW6iZAO9cBMb7/Zae3cBOl4zmE3RroqUqi9HvQIoWnAhPRsmb
         58P3fvxjWVbxz1OvJaNQWG40VkZ2m0luNFHFjQa2K2D4D3bxSPR6AJD6fy/UTEmwMk
         nehmTRuXWdw+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F2E4A60A17;
        Fri, 29 Oct 2021 12:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: make all symbols GPL-only
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163551180899.32606.6428806417794966582.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 12:50:08 +0000
References: <20211028211913.22862-1-kuba@kernel.org>
In-Reply-To: <20211028211913.22862-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@nvidia.com,
        idosch@idosch.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 14:19:13 -0700 you wrote:
> devlink_alloc() and devlink_register() are both GPL.
> A non-GPL module won't get far, so for consistency
> we can make all symbols GPL without risking any real
> life breakage.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: make all symbols GPL-only
    https://git.kernel.org/netdev/net-next/c/c52ef04d5920

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


