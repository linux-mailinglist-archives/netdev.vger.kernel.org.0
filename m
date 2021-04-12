Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C5E35D27D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 23:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245367AbhDLVUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 17:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240456AbhDLVU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 17:20:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 40E71613A9;
        Mon, 12 Apr 2021 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618262410;
        bh=McdKSr2lIRx4HpyFmlsBhy4KpZ1+yo9DQcE8iHKS40U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MMUhvQadzkqTyxsIQoiXxeQMgt22NFyLbn99TJ4IjqPsOEVFM0qEXgpPipW6vY4hh
         5OLqrN5PBv15XJNet+k7yvcdMizo0/fknxTEUCrA6rKK5t3jslDzrRXoG5M5jLYZiw
         dcfhFN04OaPigUdNTwV2j3HR5M9/Ktw8f0r9eukKNEMilHHTWlzUQniIf2lGkDcjWf
         JKcYrcL2RnGMiUpmVXxcfuLsnNVLpWWy7AJfxJKDOVMPB+KRcpm9cAP3St2tQ+sZed
         c40SexpWu51WyypZJBqNAz9X7WQTJ1tGGiJNnayQ1xHhvt+w/rzJJT6bxtEplkWDys
         AesFJb2XUK3Hw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2F44260CCF;
        Mon, 12 Apr 2021 21:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V4 1/2] dt-bindings: net: renesas,etheravb: Add additional
 clocks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161826241018.26087.15056633928793158329.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 21:20:10 +0000
References: <20210412132619.7896-1-aford173@gmail.com>
In-Reply-To: <20210412132619.7896-1-aford173@gmail.com>
To:     Adam Ford <aford173@gmail.com>
Cc:     netdev@vger.kernel.org, aford@beaconembedded.com,
        sergei.shtylyov@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 12 Apr 2021 08:26:18 -0500 you wrote:
> The AVB driver assumes there is an external crystal, but it could
> be clocked by other means.  In order to enable a programmable
> clock, it needs to be added to the clocks list and enabled in the
> driver.  Since there currently only one clock, there is no
> clock-names list either.
> 
> Update bindings to add the additional optional clock, and explicitly
> name both of them.
> 
> [...]

Here is the summary with links:
  - [V4,1/2] dt-bindings: net: renesas,etheravb: Add additional clocks
    https://git.kernel.org/netdev/net-next/c/6f43735b6da6
  - [V4,2/2] net: ethernet: ravb: Enable optional refclk
    https://git.kernel.org/netdev/net-next/c/8ef7adc6beb2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


