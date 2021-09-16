Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C10E40DA25
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239949AbhIPMlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239560AbhIPMl3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 08:41:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 661926103B;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631796008;
        bh=ROt/vqF8b09zzTG6cBpyCdJaO1PwBm5r2NxYAu1FYSc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lJmh0scj2Coovo380g6rMLYzZ2svfVboLaFjM4lYAntJDE0YYvRwBIMAE06LMhWPa
         nMXiDV3eksmOR7YUc9+IeyGQ1vnQDS3KXshJ4iqgzjmg4V8q5Wuda5DvFBOUpxOTwP
         mel+TdDKzrhpE9PeeyDmfSWcfH9gxEy11u5252vhL6JYpuXYREyo4Jh5hm/nE1CfZi
         w+T3tTwPNvVl3fRXsCrRCM8xSOhboXFh2RTpujaI7SmuSi0wcIqvPHM+oGM5if4nqc
         HKATlRzZGo0OEnNy45jRi3bM4QJkEN4QvP+myVgyWsxqOgH7DsB09eIobq3xjVRQdj
         /kXn+MwAf1Vjw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 52100609CD;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: chelsio: cxgb4vf: Make use of the helper function
 dev_err_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163179600833.19379.16621947399859300185.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 12:40:08 +0000
References: <20210915145812.7410-1-caihuoqing@baidu.com>
In-Reply-To: <20210915145812.7410-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 15 Sep 2021 22:58:11 +0800 you wrote:
> When possible use dev_err_probe help to properly deal with the
> PROBE_DEFER error, the benefit is that DEFER issue will be logged
> in the devices_deferred debugfs file.
> And using dev_err_probe() can reduce code size, and simplify the code.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> 
> [...]

Here is the summary with links:
  - net: chelsio: cxgb4vf: Make use of the helper function dev_err_probe()
    https://git.kernel.org/netdev/net-next/c/9eda994d4b57

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


