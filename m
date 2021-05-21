Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD5A38CFA0
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbhEUVLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhEUVLe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 17:11:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B68AB613EC;
        Fri, 21 May 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621631410;
        bh=Quznc9ykDZm76b0eNOOmDtBrESF2t6Gu/cHJIwWBTK8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tYv+pCOyjOibkUIq0OGEJhVNX2HeGK40oBKVpcfCbhKsvr32MfeWSCPmRZtr8BVyK
         G8J2vYQ0e7laqLUmReIxqWxw23valTUmTjEknj8nazYRTPLlNKTnhr1mRNvvd9CL+f
         Vu/i7yIKOAhdAIBA66YoFzP1gFbr+wJYEkVMA65/flMhHEoSnKeHvb74QxmvZ6s7N6
         cnkEL9rr4P/Y/YFCu3v1qir8c7gVoQ3DxVDPj5cp/57POKcCwaTFf4c8F+kRyYSTfj
         QQF1aL9zCGRacyDlOvXu7e7q6ZwjutWGL3nuZcw00ePklXBThOSwoXj1yJ77sq9XKk
         Qki2o2y41ojBg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B162A6096D;
        Fri, 21 May 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] dpaa2-eth: setup the of_node
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162163141072.28899.13731779035905881699.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 21:10:10 +0000
References: <20210521132530.2784829-1-ciorneiioana@gmail.com>
In-Reply-To: <20210521132530.2784829-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 21 May 2021 16:25:28 +0300 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch set allows DSA to work with a DPAA2 master device by setting
> up the of_node to point to the corresponding MAC DTS node, so that
> of_find_net_device_by_node() can find it.
> As an added benefit, udev rules can now be used to create a naming
> scheme based on the physical MAC.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] dpaa2-eth: setup the of_node field of the device
    https://git.kernel.org/netdev/net-next/c/b193f2ed533f
  - [net-next,2/2] dpaa2-eth: name the debugfs directory after the DPNI object
    https://git.kernel.org/netdev/net-next/c/30f43d6f1cab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


