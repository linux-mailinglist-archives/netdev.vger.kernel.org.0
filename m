Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4557243E069
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 14:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhJ1MCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbhJ1MCe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 08:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BFCFA61130;
        Thu, 28 Oct 2021 12:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635422407;
        bh=EFPoOzbSRGaasnO2PlS6EWDHk5rheyoOgN5sDEEmjIk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V6DdNAf/DkyOqBOEI+X1VQqrrKdKKqMbWDGDDIkm4+L6IDBHVxOnQJoqSgywmKkn4
         p7M12C2XenLgvqUSLGVdugGcOHU6DFwMU/Y6X4R4lXTXmh/qRzydD6X/MnjuCEBjMn
         NW5LD931knIhtWMmC2TnZOkKyTZYXdplZs5I4jGpkoZNEdf/yMyPLrLHto4Ut39Y3C
         z8ZQD1Ns7hg+aw55i2voJDnXUs75ns5LeuVucaYsY0rBxawP6EyxozEYKf1DLc96+t
         M9CTvHE0Wa0o9oFgvEI3Jc36kfqVT8X/ayQK/Gs+ToA37U7S9kDB635FCa2yTdNIF5
         ne5Zou5ORYE3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AE68060987;
        Thu, 28 Oct 2021 12:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] vmxnet3: do not stop tx queues after
 netif_device_detach()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542240770.19547.1805813985731436660.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 12:00:07 +0000
References: <20211026215031.5157-1-dongli.zhang@oracle.com>
In-Reply-To: <20211026215031.5157-1-dongli.zhang@oracle.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     pv-drivers@vmware.com, netdev@vger.kernel.org, doshir@vmware.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 26 Oct 2021 14:50:31 -0700 you wrote:
> The netif_device_detach() conditionally stops all tx queues if the queues
> are running. There is no need to call netif_tx_stop_all_queues() again.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> While I do not have vmware env, I did test with QEMU + vmxnet3.
> 
> [...]

Here is the summary with links:
  - [1/1] vmxnet3: do not stop tx queues after netif_device_detach()
    https://git.kernel.org/netdev/net/c/9159f102402a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


