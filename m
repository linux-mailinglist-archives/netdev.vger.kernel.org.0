Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893E83E3A27
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 14:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhHHMK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 08:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229882AbhHHMKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 08:10:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4C32D61028;
        Sun,  8 Aug 2021 12:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628424606;
        bh=8Ov7tGjWgrkJ/M5RzUNzrHPe3yGh1dkqMlDdPX1Wk9E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UyVfvLDbjHwYlcfVBTY6k9EpbI7flWop1Pm4/rLLyKYYoiaBBugUEGvH0PR7WDWMz
         ddRPXBwcT6WHBhcEhoGuHn5NBhxBbFYF7Wxuv5YzGrgsqJfETsyaEw3bJfbThCv4nA
         Q9eo9V1VBS6x/YpiD9KiRGcQifL/7lqBS+pazSguhpxdGR7G03lGAY5EETqE2S1ngz
         G4ZLK2Lrw9VDs8WgaZ8h0KIRB/4CtyJdGATC6kcUtK991bYN6/Fihc63rTx3z963RJ
         AafoOBwIUpstsL7tFYCQAR+y/NyaVSHiuOoh/T81sAQcoz/2JL62fj+HdLXsbTBhoO
         t+3nZazfpYydA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3AD5060985;
        Sun,  8 Aug 2021 12:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ppp: Fix generating ppp unit id when ifname is not specified
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162842460623.22263.8898241891049192609.git-patchwork-notify@kernel.org>
Date:   Sun, 08 Aug 2021 12:10:06 +0000
References: <20210807160050.17687-1-pali@kernel.org>
In-Reply-To: <20210807160050.17687-1-pali@kernel.org>
To:     =?utf-8?b?UGFsaSBSb2jDoXIgPHBhbGlAa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     paulus@samba.org, davem@davemloft.net, kuba@kernel.org,
        g.nault@alphalink.fr, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat,  7 Aug 2021 18:00:50 +0200 you wrote:
> When registering new ppp interface via PPPIOCNEWUNIT ioctl then kernel has
> to choose interface name as this ioctl API does not support specifying it.
> 
> Kernel in this case register new interface with name "ppp<id>" where <id>
> is the ppp unit id, which can be obtained via PPPIOCGUNIT ioctl. This
> applies also in the case when registering new ppp interface via rtnl
> without supplying IFLA_IFNAME.
> 
> [...]

Here is the summary with links:
  - ppp: Fix generating ppp unit id when ifname is not specified
    https://git.kernel.org/netdev/net/c/3125f26c5148

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


