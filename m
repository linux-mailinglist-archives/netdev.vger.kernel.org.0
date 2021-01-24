Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348A73019A8
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 06:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbhAXFVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 00:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbhAXFUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 00:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 19EF522BF3;
        Sun, 24 Jan 2021 05:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611465610;
        bh=BSorslGzXHnB97pN2xFLRxE2skaccq3rjkVhvcvpnGs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GNIQk1a9pndjvzxrKcl70bSFshtvEZ1NZo6rSvpKSKz+ZVUqtPpCHPCuTNr6p3ypl
         9DAr79Rlhz0uFzPmZ9IhT3bR67VdCE8y0CPcv61iYjt9uxf9lcBbF3LrcN0uuYV51K
         7+N3YakiPUqA5Es/mNuAmZ+D/tniTZ583CLEb5zvt/pIkqWZMCXjKXOvo6sNBHYGjU
         eQFne9cn6Om5CXmyJbNIooHP4mBKeQMOhfZY9z15BKQbIwub6CKYDZ5dgeu6Y6vw3C
         E9Nmt78CAzdqIoeViKHGjQs6CIg/fTMC5jhJJIOV+xbxXQVBjjvnPIdl3G8W68OYtN
         fpg/8k+g4L11w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0A453652E4;
        Sun, 24 Jan 2021 05:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next]  net: mhi: Set wwan device type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161146561003.2035.18375956754632949910.git-patchwork-notify@kernel.org>
Date:   Sun, 24 Jan 2021 05:20:10 +0000
References: <1611328554-1414-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1611328554-1414-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 22 Jan 2021 16:15:54 +0100 you wrote:
> The 'wwan' devtype is meant for devices that require additional
> configuration to be used, like WWAN specific APN setup over AT/QMI
> commands, rmnet link creation, etc. This is the case for MHI (Modem
> host Interface) netdev which targets modem/WWAN endpoints.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: mhi: Set wwan device type
    https://git.kernel.org/netdev/net-next/c/b80b5dbf118f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


