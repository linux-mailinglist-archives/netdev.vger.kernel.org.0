Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EC131A989
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbhBMBqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:46:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230376AbhBMBqa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 20:46:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A6B8264E01;
        Sat, 13 Feb 2021 01:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613180749;
        bh=kyiXHGm3f/wS256hTH0PXCd5z11hIrnQEAoWy7n9OFM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B0PWbttUQpXOJaFC32mxOZssGsl99Wz2+YJX8N06TjqGSCYHZYX+o8ouWme00LxkL
         NFUf3rV7rK3kETekwHfNxHM4AAbKsgZE84vR7En3Vgym109YpALqOsc8QP6qN4soUb
         yLWBdLmWBz382662riCuTeXobG09NWb2JH8uCMwyBbag9qjHXiMWU+fVU7/GUMttOL
         kH8C5xIN/CB8I0IJN2Te1igc2PsL7MxL7jpHMpS2ePeq4sVprJwOTTvvlLIpsYAW4B
         jk6R9TpywvObxiR1I/trJYouKyt+gnRMNdovoriEkmMznVXiSQI4xE7JBGWKLwhA4y
         qHAUizOvlZGuQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 95EC360A2F;
        Sat, 13 Feb 2021 01:45:49 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: axienet: Handle deferred probe on clock properly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161318074961.24767.15053675195382667062.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Feb 2021 01:45:49 +0000
References: <20210213001748.2556885-1-robert.hancock@calian.com>
In-Reply-To: <20210213001748.2556885-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 12 Feb 2021 18:17:48 -0600 you wrote:
> This driver is set up to use a clock mapping in the device tree if it is
> present, but still work without one for backward compatibility. However,
> if getting the clock returns -EPROBE_DEFER, then we need to abort and
> return that error from our driver initialization so that the probe can
> be retried later after the clock is set up.
> 
> Move clock initialization to earlier in the process so we do not waste as
> much effort if the clock is not yet available. Switch to use
> devm_clk_get_optional and abort initialization on any error reported.
> Also enable the clock regardless of whether the controller is using an MDIO
> bus, as the clock is required in any case.
> 
> [...]

Here is the summary with links:
  - [net] net: axienet: Handle deferred probe on clock properly
    https://git.kernel.org/netdev/net/c/57baf8cc70ea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


