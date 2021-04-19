Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E0D364E9F
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 01:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhDSXaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 19:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232027AbhDSXak (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 19:30:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 96A826127C;
        Mon, 19 Apr 2021 23:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618875009;
        bh=PZK4FIb0mfZlPf4mIWBSVB82+flmWFB1xhO0fWIiGmg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BR+NvKztRHYniEIcXVBU88eLgHofieEWBJWH7RjVVlhX94l7Lc0OifmCbedz02v9t
         WMwWEhdwFKPbFtBQsdd4vH22uOxwdcX9NUEwMhjUwIuvN2z3uT3gEYbduWgniGZXWz
         8sGizPr0sPk0wwZipYNPQCk/auJafQO3aLynbe0zA3rAbR9bEmW3trJl3qNSsDDCRk
         wJdaZ6i06jAO9FlCWrrBp6vCOh46OrdK08nKcCZStVkcmWgLZvhTBmDpGpxmF7GUeb
         MS7R+XB4rWy/g+N9bMS4yAE7XvY2j1X8cFA8Et1M147tU08Hlg3doI82p90aG9IMuP
         WDTLSTBTOLfow==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8A87560A13;
        Mon, 19 Apr 2021 23:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] bnxt: add more ethtool standard stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887500956.9960.511883425241206243.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 23:30:09 +0000
References: <20210419200242.2984499-1-kuba@kernel.org>
In-Reply-To: <20210419200242.2984499-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Apr 2021 13:02:42 -0700 you wrote:
> Michael suggest a few more stats we can expose.
> 
> $ ethtool -S eth0 --groups eth-mac
> Standard stats for eth0:
> eth-mac-FramesTransmittedOK: 902623288966
> eth-mac-FramesReceivedOK: 28727667047
> eth-mac-FrameCheckSequenceErrors: 1
> eth-mac-AlignmentErrors: 0
> eth-mac-OutOfRangeLengthField: 0
> $ ethtool -S eth0 | grep '\(fcs\|align\|oor\)'
>      rx_fcs_err_frames: 1
>      rx_align_err_frames: 0
>      tx_fcs_err_frames: 0
> 
> [...]

Here is the summary with links:
  - [net-next] bnxt: add more ethtool standard stats
    https://git.kernel.org/netdev/net-next/c/37434782d63f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


