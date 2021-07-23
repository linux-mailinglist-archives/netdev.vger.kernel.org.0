Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA49B3D3D71
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhGWPjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229698AbhGWPjd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 11:39:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 86BFC60EE2;
        Fri, 23 Jul 2021 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627057205;
        bh=8CqYhOFpaeRc7pfpoMCW2zyWI0Z+SLzsSDb2260WKHQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BEiaGaFEHB0N4OP0+WdH5MNa6V7ZLqa5BJ7Il9fLk8A4JzeIGwEbLtHO8AOVL/1MD
         Aw5CC/+PxC1xNK2jAtg6Z0I1XT4jTi01RfLzz4ALGayrFMZr0LpVXhMK8EkALzbXYw
         xbVwOJpaxjDxgal6rCGmhm7hWCzoiG+gguPQDP/vI+esNWYZyfKmnKlQj8q9EhnAPr
         TVlftnuC0Ltm5EXLM/lKzkWz+XTPYLvYCT4ajWS6wrihfGodioDHXFWLCZC4JrceLv
         E24DU+QWB1EFlXOOMgmcaWVpB9J8krT/2tERx+HQLHbO3xDf+7xIMBUb4h/1mlIhXb
         ze1XRpuHaAfww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7F28D60721;
        Fri, 23 Jul 2021 16:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] octeontx2-af: Enhance mailbox trace entry
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705720551.6547.9817289295905236735.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 16:20:05 +0000
References: <20210722134540.644370-1-jerinj@marvell.com>
In-Reply-To: <20210722134540.644370-1-jerinj@marvell.com>
To:     <jerinj@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, hkelam@marvell.com,
        sbhatta@marvell.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        jerinjacobk@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Jul 2021 19:15:40 +0530 you wrote:
> From: Jerin Jacob <jerinj@marvell.com>
> 
> Added mailbox id to name translation on trace entry for
> better tracing output.
> 
> Before the change:
> otx2_msg_process: [0002:01:00.0] msg:(0x03) error:0
> 
> [...]

Here is the summary with links:
  - [net-next,v1] octeontx2-af: Enhance mailbox trace entry
    https://git.kernel.org/netdev/net-next/c/3bdba2c70a35

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


