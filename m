Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164F43D41FD
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 23:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhGWU3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 16:29:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhGWU3d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 16:29:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EFDEF60F35;
        Fri, 23 Jul 2021 21:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627074607;
        bh=OJkZpQplzXA3oS1BlTbHZ8z7blvr1gFbtfqGx0ViYdY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hOOuEpsunjRfnWUl5VLC5DiblyUiemWxdr7/7VOZ8pVcuqnUtJpcxje3y3uQmBxVd
         W1iCKNmyHWZ2JPxYFDgXRlzhLm2JYcFXLurzXi4U8DzR2+utuZSfLJGe96bqt6y7kn
         aOJXwkM6h9tpSPGZ99msYh9t2j3Nio8MlLmxkeOBt+BBrRma0AYTm+T68oJoaGS7hK
         /mDkz1xZrZubGzQCPiiw1w6RTJEB+GAn/CC9sNnGoit69tovJZaHfw5xyNvbe1tsoG
         qxoqkhaZkrFHGq2N3PVwu/TuQlmAoy5LDFjSATdBE0fWYtLNdZStfMFYBFS/FBkH/N
         E/d634DJWXB+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E2D3360972;
        Fri, 23 Jul 2021 21:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5] ionic: bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162707460692.15525.10969111362468035549.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 21:10:06 +0000
References: <20210723180249.57599-1-snelson@pensando.io>
In-Reply-To: <20210723180249.57599-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Jul 2021 11:02:44 -0700 you wrote:
> Fix a thread race in rx_mode, remove unnecessary log message,
> fix dynamic coalescing issues, and count all csum_none cases.
> 
> Shannon Nelson (5):
>   ionic: make all rx_mode work threadsafe
>   ionic: catch no ptp support earlier
>   ionic: remove intr coalesce update from napi
>   ionic: fix up dim accounting for tx and rx
>   ionic: count csum_none when offload enabled
> 
> [...]

Here is the summary with links:
  - [net,1/5] ionic: make all rx_mode work threadsafe
    https://git.kernel.org/netdev/net/c/6840e17b8ea9
  - [net,2/5] ionic: catch no ptp support earlier
    https://git.kernel.org/netdev/net/c/f79eef711eb5
  - [net,3/5] ionic: remove intr coalesce update from napi
    https://git.kernel.org/netdev/net/c/a6ff85e0a2d9
  - [net,4/5] ionic: fix up dim accounting for tx and rx
    https://git.kernel.org/netdev/net/c/76ed8a4a00b4
  - [net,5/5] ionic: count csum_none when offload enabled
    https://git.kernel.org/netdev/net/c/f07f9815b704

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


