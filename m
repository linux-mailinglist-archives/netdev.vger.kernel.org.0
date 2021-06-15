Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6EE3A8897
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhFOScK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229481AbhFOScI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 14:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7870A61166;
        Tue, 15 Jun 2021 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623781803;
        bh=FeG6ZoNKuhesnVYlvvNYTbrS5be2MBBqWGVFOqBW5tU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FgRPbFY/ZnQH/r/4gskyNPOfLGBEnlgwxNpHvj8kzqCmlnbUw/KcBaXgCDIMAASDS
         t3rJQPgTCJufKm/l+6LM8VZXDFPHghcVCf0WH8VPV1TqqPRtETqxRdccjyy7lmNSYo
         8Fjx35mT62ZUmc1EhkNNjhMe8ado5FmmkfLdkjtqY1MwQmS+by7I7dWJChUEEE7DL4
         kayJCyTZnM7D067vJOjf7yKpnfJKOvGHDVtzLqsIhPp1qlmQkhhVOM9+8CH0ZU/XHe
         YS44b/6cq2OF1s2DnRmUGPCexyt1bmkbhQyb6luSti24v/SrYc0jsDE60Pr7YQCmfr
         rlCfDde8wBWrg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6D29160A0A;
        Tue, 15 Jun 2021 18:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qmi_wwan: Do not call netif_rx from rx_fixup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162378180344.31286.3200730023491803021.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Jun 2021 18:30:03 +0000
References: <20210615100151.317004-1-kristian.evensen@gmail.com>
In-Reply-To: <20210615100151.317004-1-kristian.evensen@gmail.com>
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     netdev@vger.kernel.org, bjorn@mork.no
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 15 Jun 2021 12:01:51 +0200 you wrote:
> When the QMI_WWAN_FLAG_PASS_THROUGH is set, netif_rx() is called from
> qmi_wwan_rx_fixup(). When the call to netif_rx() is successful (which is
> most of the time), usbnet_skb_return() is called (from rx_process()).
> usbnet_skb_return() will then call netif_rx() a second time for the same
> skb.
> 
> Simplify the code and avoid the redundant netif_rx() call by changing
> qmi_wwan_rx_fixup() to always return 1 when QMI_WWAN_FLAG_PASS_THROUGH
> is set. We then leave it up to the existing infrastructure to call
> netif_rx().
> 
> [...]

Here is the summary with links:
  - qmi_wwan: Do not call netif_rx from rx_fixup
    https://git.kernel.org/netdev/net/c/057d49334c02

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


