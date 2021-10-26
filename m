Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1DC43B269
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbhJZMcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230308AbhJZMca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 08:32:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3AA2960527;
        Tue, 26 Oct 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635251407;
        bh=7WkZpaefSc8UqWOqfAEScRVc2ldliqcnSttxIWgBZZE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P3BfHiV+na6Ovwrnd3j1x0YSCh168xPOmNIz0c8EDgrqM9X2fY/4RyfBewRuKaZr+
         ddhX1mPkUPpa3iTLMuOjQP3K1kjmcLtlmhMLq/DF9hn07blLJ4Pl30Q+rOgGwc3MQX
         eyGcedU6PCCIInpO+vRaFJ5LuzRVtgtnmt3xTA+aBVNOz/D7v71xGkX4PIfMeJ5uci
         bqUhIpyonXjyYeIzJ2pI+kG/dFyv5q/xMLuT8MRRJUg1K6J7LWASnX/0y57Xm7YNCF
         IRTJ75izf3gDp4r1ORCeMkwx/5zoQsaVUUbuD3M7niGDEIRlDwx3YcWFs3+ZEgWA5f
         +4KP8BHPlPhLA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2B6FD609CC;
        Tue, 26 Oct 2021 12:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2021-10-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525140717.31388.9568286580031063355.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 12:30:07 +0000
References: <20211025205622.1967785-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211025205622.1967785-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 25 Oct 2021 13:56:20 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Dave adds event handler for LAG NETDEV_UNREGISTER to unlink device from
> link aggregate.
> 
> Yongxin Liu adds a check for PTP support during release which would
> cause a call trace on non-PTP supported devices.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ice: Respond to a NETDEV_UNREGISTER event for LAG
    https://git.kernel.org/netdev/net/c/6a8b357278f5
  - [net,2/2] ice: check whether PTP is initialized in ice_ptp_release()
    https://git.kernel.org/netdev/net/c/fd1b5beb177a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


