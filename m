Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F6B2EFD30
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 03:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbhAICut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 21:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbhAICus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 21:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4786323A82;
        Sat,  9 Jan 2021 02:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610160608;
        bh=YNstX0bZWlHqiCB3uiMaSH/XmuKdqHhlwDAUUcgpPFk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AxdjrrfAKfFT2rc5hcoD6sf/0BVDrWPRaET77rktrrogNO5XvSzvqSi4wRlz2l+At
         fhaG9+PL2q8iJqDvZKPGLjuDX/xg131ki15f600jQK/GEc5DuM57EaebTft5TGPN19
         kXynabuVdZlanzmFmYmyQJH7pYXBN+xE/jw36xypif9q9ajJD1ceBKl0R+xTdJRVeD
         81iRubGgimxqp9mqIufGB4xrGuBjLzTo3un8ZV691JX7XazGZxgYrw5QQNbGsgGFZ+
         7lLB0axKj8jh3fREHudl+zfWa0sYOXBQ2UePq4mvqDpEcB1sTfWWAZGO9QCFF0tnhE
         /na6mCP5QM/dw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 3B405605AC;
        Sat,  9 Jan 2021 02:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ipa: modem: add missing SET_NETDEV_DEV() for proper
 sysfs links
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161016060823.12619.1027416756697196176.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Jan 2021 02:50:08 +0000
References: <20210106100755.56800-1-stephan@gerhold.net>
In-Reply-To: <20210106100755.56800-1-stephan@gerhold.net>
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        aleksander@aleksander.es, andrewlassalle@chromium.org,
        elder@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  6 Jan 2021 11:07:55 +0100 you wrote:
> At the moment it is quite hard to identify the network interface
> provided by IPA in userspace components: The network interface is
> created as virtual device, without any link to the IPA device.
> The interface name ("rmnet_ipa%d") is the only indication that the
> network interface belongs to IPA, but this is not very reliable.
> 
> Add SET_NETDEV_DEV() to associate the network interface with the
> IPA parent device. This allows userspace services like ModemManager
> to properly identify that this network interface is provided by IPA
> and belongs to the modem.
> 
> [...]

Here is the summary with links:
  - [net] net: ipa: modem: add missing SET_NETDEV_DEV() for proper sysfs links
    https://git.kernel.org/netdev/net/c/afba9dc1f3a5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


