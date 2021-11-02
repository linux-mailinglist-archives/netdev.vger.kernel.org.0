Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702344425E3
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 04:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhKBDCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 23:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231878AbhKBDCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 23:02:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 31D9B60EE9;
        Tue,  2 Nov 2021 03:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635822007;
        bh=kp2pthkgmrsmmnZpOLMQQaerqGIYJ9+xwcpv6ldtBeY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DrL27+U8iZEA1TKqNsGfW7vUh1uNpHFmC0fMIWVf4gfc45mqLI7RjncyhRL/wHUZQ
         RQAfVFq87B/Lh04GBqirVVzmpg57OtRqlM+2d8f72g5EAlL0zhGPo6yGcK94Z4xY9L
         pssNITQJLxZgY0wb6JVvcVTyMkwE4npdC/TGjOuT6XbeewKmGRxcRo8oN9sVeKmT1u
         7Y6gb1IRenter75KsLpKRVLvpmgS+42OLoYX7kbXigCK7oCDJv+PxxXU+ZAqVqB5ha
         h4noJ9IZjc7XaK2jRItOMcBXaswG8e9lo3f4Ni3nw5HITv5TQvSmQZHTm7auovrWix
         fb4FCfDpubjJw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2025B60A0C;
        Tue,  2 Nov 2021 03:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: vmxnet3: remove multiple false checks in
 vmxnet3_ethtool.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163582200712.14825.5594389665764814019.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Nov 2021 03:00:07 +0000
References: <20211031012728.8325-1-sakiwit@gmail.com>
In-Reply-To: <20211031012728.8325-1-sakiwit@gmail.com>
To:     =?utf-8?q?J=CE=B5an_Sacren_=3Csakiwit=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 30 Oct 2021 19:27:28 -0600 you wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> In one if branch, (ec->rx_coalesce_usecs != 0) is checked.  When it is
> checked again in two more places, it is always false and has no effect
> on the whole check expression.  We should remove it in both places.
> 
> In another if branch, (ec->use_adaptive_rx_coalesce != 0) is checked.
> When it is checked again, it is always false.  We should remove the
> entire branch with it.
> 
> [...]

Here is the summary with links:
  - [net-next] net: vmxnet3: remove multiple false checks in vmxnet3_ethtool.c
    https://git.kernel.org/netdev/net-next/c/1d6d336fed6b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


