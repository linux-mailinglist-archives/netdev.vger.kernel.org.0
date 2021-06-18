Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFD93AD36D
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 22:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhFRUMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 16:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232740AbhFRUMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 16:12:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C54D613EB;
        Fri, 18 Jun 2021 20:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624047005;
        bh=2L2qtf9K2bRhGQSzHbaQWM/CJOpY2XRH02DE692xUiA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U6T2AWMsIOrz69fp4Wz3LArXZMbwobFItfGKsiox/tGGpxtTi7sYjikJFDKM+wVSR
         kNkDfAlOIT5HWtG7EM+xrOkLWnm8fQQk5Ql6G6uXKMww1FV6PUQGClhgU5A+pkpsNS
         jqBnmFJ/YpEQ+kRSir8jxwEs8Zjmt7vnNlZa8ETqTvONW0Wh/B70jlwOOfTKTz3Di1
         rWd12ufi30OJAT7Y1xknlGkI2huZgGoreeaxV4+x0ZMJy3Sdp1JxU/V8AlAqR0b4B3
         wBVmyx1F/oS8BjcZXYQvWPUv4rc0ZBM1TqxdJafExfCyGyqgtyDBMl7F2Ads7YMFyy
         fsriiXCLl/3Pw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 25F9160C29;
        Fri, 18 Jun 2021 20:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] vsock: small fixes for seqpacket support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404700515.5742.724635401630877210.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 20:10:05 +0000
References: <20210618133526.300347-1-sgarzare@redhat.com>
In-Reply-To: <20210618133526.300347-1-sgarzare@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, arseny.krasnov@kaspersky.com,
        kvm@vger.kernel.org, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, davem@davemloft.net,
        stefanha@redhat.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 15:35:23 +0200 you wrote:
> This series contains few patches to clean up a bit the code
> of seqpacket recently merged in the net-next tree.
> 
> No functionality changes.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] vsock: rename vsock_has_data()
    https://git.kernel.org/netdev/net-next/c/cc97141afd76
  - [net-next,2/3] vsock: rename vsock_wait_data()
    https://git.kernel.org/netdev/net-next/c/0de5b2e67275
  - [net-next,3/3] vsock/virtio: remove redundant `copy_failed` variable
    https://git.kernel.org/netdev/net-next/c/91aa49a8fa0f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


