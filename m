Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594763A49B7
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhFKUCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhFKUCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 16:02:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 130EE613EA;
        Fri, 11 Jun 2021 20:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623441607;
        bh=MKypFulE5T04k9gQ3PHdRwk4/l605NOXVS4v4MxWyXM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dAbIj+ZPzluKbAmdG7vK0KO6hg+w+m1S9S9qq2ogwBLHB89b3xNTDZCvgBLKL0EiQ
         pCCGCw14a8d0A8TH+kaFk17S6J0/ThC271C9gcSxFnq1XNPzrXSZ+lKWVcU5I9YYrw
         ckQyhHYXSaowef1UDgRaZhSdf3/O78bQVuuoDc0AZtgyOdhleqg8PkSH3STUtBYf0X
         AEA53x239G0xWmzCk6Qa9FGQ5fLYM2Bd9igPxZyj80EC6iAhfF/6XzEt57ZW7v6E2b
         M2d+Us+Mzy6uFd0+f69MFw/iqJWYarI/Tnfezmob2jEuooFe1X8fENduMIrGoPzClr
         gZjzYH6iFPS/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0A9E360D07;
        Fri, 11 Jun 2021 20:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] s390/qeth: updates 2021-06-11
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344160703.3583.2800269922297994117.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 20:00:07 +0000
References: <20210611073341.1634501-1-jwi@linux.ibm.com>
In-Reply-To: <20210611073341.1634501-1-jwi@linux.ibm.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, kgraul@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 09:33:32 +0200 you wrote:
> Hi Dave & Jakub,
> 
> please apply the following patch series for qeth to netdev's net-next tree.
> 
> This enables TX NAPI for those devices that didn't use it previously, so
> that we can eventually rip out the qdio layer's internal interrupt
> machinery.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] s390/qeth: count TX completion interrupts
    https://git.kernel.org/netdev/net-next/c/e872d0c1249b
  - [net-next,2/9] s390/qeth: also use TX NAPI for non-IQD devices
    https://git.kernel.org/netdev/net-next/c/7a4b92e8e0de
  - [net-next,3/9] s390/qeth: unify the tracking of active cmds on ccw device
    https://git.kernel.org/netdev/net-next/c/3518ae76f2bb
  - [net-next,4/9] s390/qeth: use ethtool_sprintf()
    https://git.kernel.org/netdev/net-next/c/c0a0186630fb
  - [net-next,5/9] s390/qeth: consolidate completion of pending TX buffers
    https://git.kernel.org/netdev/net-next/c/f875d880f049
  - [net-next,6/9] s390/qeth: remove QAOB's pointer to its TX buffer
    https://git.kernel.org/netdev/net-next/c/838e4cc80814
  - [net-next,7/9] s390/qeth: remove TX buffer's pointer to its queue
    https://git.kernel.org/netdev/net-next/c/6b7ec41e574a
  - [net-next,8/9] s390/qeth: shrink TX buffer struct
    https://git.kernel.org/netdev/net-next/c/bb7032ddc947
  - [net-next,9/9] s390/qeth: Consider dependency on SWITCHDEV module
    https://git.kernel.org/netdev/net-next/c/953fb4dc4f4a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


