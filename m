Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAB6458EAD
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 13:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbhKVMxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 07:53:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:48678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239406AbhKVMxQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 07:53:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E3A0960F9F;
        Mon, 22 Nov 2021 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637585409;
        bh=I0SXDP5o1qsKKixdojKiKcjkAMeJKXwpKOmOs8gxwkw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H7tbLLV53ybdKMs1B7hHKKZExmvGcb0FfCTBStb2Y8aMD2G/O3jlRLvzMhIg+B3OL
         Id8CvMVnCdsFySmPMUC2xkZPrp92o7f55x2fB5Mfzwhi7huHyCM2pnWF9C1GKfWnUI
         FQZZQSBFhg6pWCA6V33nQeJHDk7DAThWhXyXE1453qYyZzR0oJCeR8xeEGepjA7eNe
         aUZnVTFLc/Kt6f2eWL9JUT0SylU7NBCv95TJm+GMuYujLtqDiVyIKSj9Ql7I+VJTfB
         9CbksckvK98tOtP06XOhUPdRbhpFv1nKaT8RoAuerF+2sU0qwD+3Jtvl5tY7K/DNAJ
         OZq0tmICZqELw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D7A2C609B9;
        Mon, 22 Nov 2021 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: checking parameter process for rx-usecs/tx-usecs is
 invalid
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163758540987.16054.8750901617918116634.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 12:50:09 +0000
References: <20211119133803.28749-1-simon.horman@corigine.com>
In-Reply-To: <20211119133803.28749-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, na.wang@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 19 Nov 2021 14:38:03 +0100 you wrote:
> From: Diana Wang <na.wang@corigine.com>
> 
> Use nn->tlv_caps.me_freq_mhz instead of nn->me_freq_mhz to check whether
> rx-usecs/tx-usecs is valid.
> 
> This is because nn->tlv_caps.me_freq_mhz represents the clock_freq (MHz) of
> the flow processing cores (FPC) on the NIC. While nn->me_freq_mhz is not
> be set.
> 
> [...]

Here is the summary with links:
  - [net] nfp: checking parameter process for rx-usecs/tx-usecs is invalid
    https://git.kernel.org/netdev/net/c/3bd6b2a838ba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


