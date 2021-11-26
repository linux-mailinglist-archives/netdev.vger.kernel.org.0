Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D37B45F52F
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbhKZTbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:31:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38208 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbhKZT3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:29:51 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 14:29:51 EST
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47D8DB82871
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 19:20:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id BD5346008E;
        Fri, 26 Nov 2021 19:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637954409;
        bh=u5lJZX58SdF+crNkFnfcU5/g8s9RhBWG0ngYOE56BVI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ooK+/uVRDXX1q5QXc5eo9M0/GIxuSW1rvPvg+sarNE81ghfP/CIBYiBCTy40LX38h
         xNwA1fQG5Sfc3E9xNhh9X3MOHhWfzKcEOwXGSKGxWopKwTqBCNdr4WgKzN9HwCIm+e
         C/wSKQD1/8l9k8pjf/FVFFcVP8g0di/PIVHNHY6ZOROClZuzJ5/eCxDhTWwXIyqoNg
         TpqhifPRc/MkZW4d4yQQl/nphGvgWix14qB4Kc27vD6fA2Ua4l6wgElvAdShZRxrnB
         TSa4puv3fGVcHaWJf+gMF3Aqs8TKwIlKBnZVT+eQHIDLoUrIWGzbGg5vhV3kJsd8q2
         rkAvy2evfdVgg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A798360BE3;
        Fri, 26 Nov 2021 19:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: stmmac: Disable Tx queues when reconfiguring the
 interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163795440968.10734.18334185994290188815.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 19:20:09 +0000
References: <20211124154731.1676949-1-yannick.vignon@oss.nxp.com>
In-Reply-To: <20211124154731.1676949-1-yannick.vignon@oss.nxp.com>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        xiaoliang.yang_1@nxp.com, kurt.kanzenbach@linutronix.de,
        vladimir.oltean@nxp.com, boon.leong.ong@intel.com,
        qiangqing.zhang@nxp.com, sebastien.laveze@oss.nxp.com,
        yannick.vignon@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 16:47:31 +0100 you wrote:
> From: Yannick Vignon <yannick.vignon@nxp.com>
> 
> The Tx queues were not disabled in situations where the driver needed to
> stop the interface to apply a new configuration. This could result in a
> kernel panic when doing any of the 3 following actions:
> * reconfiguring the number of queues (ethtool -L)
> * reconfiguring the size of the ring buffers (ethtool -G)
> * installing/removing an XDP program (ip l set dev ethX xdp)
> 
> [...]

Here is the summary with links:
  - [net,v2] net: stmmac: Disable Tx queues when reconfiguring the interface
    https://git.kernel.org/netdev/net/c/b270bfe69736

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


