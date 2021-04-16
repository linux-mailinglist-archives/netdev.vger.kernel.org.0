Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B58362B32
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbhDPWki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:40:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230258AbhDPWkg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 18:40:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E6FD1613C1;
        Fri, 16 Apr 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618612811;
        bh=aKl6tQkOqJGaq1pJDw+YSJmiWZuLO14doD1YlqmapTQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OwfqydL9zmPTTj67/Swwg1aPyDBXNjHiOER/LDsam332+EEzSnw8574C6gnFPe/g2
         vlBVqeNtDuTWboaJA2c+ZgVpiEb4I2/kbTfdIvtJny/BrnLfUXW2Xex+xRpL2PUJPd
         SIx49HuFxf97nhABHNa/6POht6h2McMpMZ7nWDnQ4WWhK5uqhQ2nLDQ0qI6yHUOBck
         gQsfV7wgVa75fWu/f2JVLNCDxO2vXFMOy28hbqUt96ztjAeCnyXAf66hTp33iUvE+d
         j8TNqGI6qttWGOrCqv3JfS+6eXAfuEJQHDAaeWjtnvaS/JgvVKIUkGRQnzXRHas0dB
         wYSqITyUI+PpQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D5BE060CD8;
        Fri, 16 Apr 2021 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v11 1/2] net: Add a WWAN subsystem
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861281087.23739.8947719236426723975.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Apr 2021 22:40:10 +0000
References: <1618562194-31913-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1618562194-31913-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        aleksander@aleksander.es, dcbw@redhat.com, mpearson@lenovo.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Apr 2021 10:36:33 +0200 you wrote:
> This change introduces initial support for a WWAN framework. Given the
> complexity and heterogeneity of existing WWAN hardwares and interfaces,
> there is no strict definition of what a WWAN device is and how it should
> be represented. It's often a collection of multiple devices that perform
> the global WWAN feature (netdev, tty, chardev, etc).
> 
> One usual way to expose modem controls and configuration is via high
> level protocols such as the well known AT command protocol, MBIM or
> QMI. The USB modems started to expose them as character devices, and
> user daemons such as ModemManager learnt to use them.
> 
> [...]

Here is the summary with links:
  - [net-next,v11,1/2] net: Add a WWAN subsystem
    https://git.kernel.org/netdev/net-next/c/9a44c1cc6388
  - [net-next,v11,2/2] net: Add Qcom WWAN control driver
    https://git.kernel.org/netdev/net-next/c/fa588eba632d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


