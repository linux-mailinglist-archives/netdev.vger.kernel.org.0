Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAC43F848F
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 11:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241093AbhHZJbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 05:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241123AbhHZJa7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 05:30:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AA0FF610CB;
        Thu, 26 Aug 2021 09:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629970206;
        bh=U32UKk9AEK+bW9H734oQ7GcAnOH8zai/E1TYLGDW+pA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sV3Hh6Bag9gdu795wLaBpMZxKBs6o6uZJshlagSt3bZ7MqCMo1JySm01dkqAQqfP2
         PUu6l9FKtgNT+vZb6Vzy8F36t2s9bvucV+K0Gp+YsWXADBx60/u4v61V+/sWstHQPE
         a9aWcu4UgW6/BMvodC8RgYLCRUdckDm1aWp4MPaxBXzK4Lj+WngCb0lmPeqUOlMmkf
         LjYT2Uw8B3olvKe5sK41PeS/uK9fgfXARm4oWTcQE6ScYbcrKPW+DDGWMoxnlxAED2
         XfmNywC9rPd9sVExSCeUC1mIw4+6vTFEamWVPlzrUPh4yIUrTm2LoQ0lpOZruZRNe7
         l11lGVVy4fypA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9ED8A60A27;
        Thu, 26 Aug 2021 09:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: dsa: hellcreek: 802.1Qbv Fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162997020664.28182.6520317976223307326.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Aug 2021 09:30:06 +0000
References: <20210825135813.73436-1-kurt@linutronix.de>
In-Reply-To: <20210825135813.73436-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, bigeasy@linutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 25 Aug 2021 15:58:11 +0200 you wrote:
> Hi,
> 
> while using TAPRIO offloading on the Hirschmann hellcreek switch, I've noticed
> two issues in the current implementation:
> 
> 1. The gate control list is incorrectly programmed
> 2. The admin base time is not set properly
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: dsa: hellcreek: Fix incorrect setting of GCL
    https://git.kernel.org/netdev/net/c/a7db5ed8632c
  - [net,2/2] net: dsa: hellcreek: Adjust schedule look ahead window
    https://git.kernel.org/netdev/net/c/b7658ed35a5f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


