Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669123DDA53
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbhHBONW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:13:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237721AbhHBOKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:10:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7BE7C60F51;
        Mon,  2 Aug 2021 14:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627913406;
        bh=MokKjbLd+TWnE20EECV1/MDJ/uN8t+VRIEr1v+SwJdk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LTeS46miJnE+iv4IYGW2d3/pPhXdyfw42RHta62aJeiLCXcAZCgmZL30bJD60bjHR
         /LfSycQwcikwaVmnIoWslA7G4KpDR09hpGY70Ev+dVkuQTjyxhR1XJZJI4SZnikxxU
         0B6iidkwuFdlVGFDpUfpIFX9vefJzO53xeVpgonieUOLDrx+wVz0/0ypesdepU+d6y
         54ydegkBalZwYZ1Ij1cz0dFjjZd2UdZIPC95wpj5O+ljj4gGQ4gOy0EI8vV/kK8Wy2
         FcEUiL8ePz/jflkH6O//C7mrw4hMGOsi5izAAjug/KXWv+oy4f25aDU+Wai+PvOiIc
         +FJI8YB1rfrBg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 772CC60A44;
        Mon,  2 Aug 2021 14:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH 0/2] cn10k: DWRR MTU and weights configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162791340648.12354.1207492713207355529.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 14:10:06 +0000
References: <1627645754-18131-1-git-send-email-sgoutham@marvell.com>
In-Reply-To: <1627645754-18131-1-git-send-email-sgoutham@marvell.com>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 30 Jul 2021 17:19:12 +0530 you wrote:
> On OcteonTx2 DWRR quantum is directly configured into each of
> the transmit scheduler queues. And PF/VF drivers were free to
> config any value upto 2^24.
> 
> On CN10K, HW is modified, the quantum configuration at scheduler
> queues is in terms of weight. And SW needs to setup a base DWRR MTU
> at NIX_AF_DWRR_RPM_MTU / NIX_AF_DWRR_SDP_MTU. HW will do
> 'DWRR MTU * weight' to get the quantum.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] octeontx2-af: cn10k: DWRR MTU configuration
    https://git.kernel.org/netdev/net-next/c/76660df2b4a2
  - [net-next,2/2] octeontx2-pf: cn10k: Config DWRR weight based on MTU
    https://git.kernel.org/netdev/net-next/c/c39830a4ce4d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


