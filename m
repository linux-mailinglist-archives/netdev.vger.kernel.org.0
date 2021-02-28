Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A045327448
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 21:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhB1UAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 15:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230167AbhB1UAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Feb 2021 15:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E28364E85;
        Sun, 28 Feb 2021 20:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614542408;
        bh=rTsfVtPwEintF1A3cpJtsWVORAo/xR7t3plun5ypTXw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V6BfzRwsU2OoEZibRCR+MYzie/6dQJDDk1OEKukkN9HNrRipeOMcjBh2ACxEjMBsI
         BIkX0LbvVMhe/fBb4llAhQtgpr/XuxqtfyxzI5+3hjgMcTf3AB0M6cicG7ie96p7vu
         OeDiuAIclgs+MmQwvkWJ2qjF6IXady8t/0HYqYEOzdQCai9iz0lIc5cG6yrBljJalP
         rnFoIoA3gb9T5Yy5aZ+8RgY7Ats3s+5z8oBwTAjMMq7AvSdLQnnKX+l4Z+ONibpzgT
         oOC2y08+92ujgM59+6dxF8XSRpOUUKKS+SpuR18mB1EQb+WNu3RctOcjgfmT/M51Dw
         R7QfZoGJnY3BA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3D98A60A13;
        Sun, 28 Feb 2021 20:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ethtool: fix the check logic of at least one channel
 for RX/TX
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161454240824.28159.15484906665567020829.git-patchwork-notify@kernel.org>
Date:   Sun, 28 Feb 2021 20:00:08 +0000
References: <20210225125102.23989-1-simon.horman@netronome.com>
In-Reply-To: <20210225125102.23989-1-simon.horman@netronome.com>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, mkubecek@suse.cz,
        yinjun.zhang@corigine.com, louis.peens@netronome.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 25 Feb 2021 13:51:02 +0100 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> The command "ethtool -L <intf> combined 0" may clean the RX/TX channel
> count and skip the error path, since the attrs
> tb[ETHTOOL_A_CHANNELS_RX_COUNT] and tb[ETHTOOL_A_CHANNELS_TX_COUNT]
> are NULL in this case when recent ethtool is used.
> 
> [...]

Here is the summary with links:
  - [net,v2] ethtool: fix the check logic of at least one channel for RX/TX
    https://git.kernel.org/netdev/net/c/a4fc088ad4ff

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


