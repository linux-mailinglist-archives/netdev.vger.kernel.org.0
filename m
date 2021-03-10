Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6254F3348FF
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 21:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhCJUkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:40:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhCJUkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 15:40:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5F4D264FB3;
        Wed, 10 Mar 2021 20:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615408808;
        bh=A68JRHIoYCj+WflGyfP8tO1T4Kp+8dIPA+nZr1NTvjM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XdyfzJZZimcsY6M0IeBLT0EjLF3W5/jpML2pRBUvOL16M643/ytXD5z50EbEUY6hd
         rGHFr5m/cyru0lolHs3NTtLyTt6vhmBz6xxZjyccvi/MjfL20md1FyXLfVIXtQBI1o
         ow1EWibeip389l8zIxoi6XLCDrKeuJ99jmEBoH+7flytC3rS6HBdNKin2TMdbL0TsB
         ULtPljtVhFSBRylR0NxEBa+f8vkzsu4btBVhIPnVCk1QGqcFcmBu4tdqG0mXNXU1QE
         2ttZj/pYyVvVRDvgE20AOcll9sYllKkbGpBpD8L+UNhaAHQAiuDKLdh07uk8oUZT2B
         aHYEjuxeJAcTw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5655E609BB;
        Wed, 10 Mar 2021 20:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] Fix ip6ip6 crash for collect_md skbs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161540880834.27914.7790735940165550711.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 20:40:08 +0000
References: <cover.1615331093.git.daniel@iogearbox.net>
In-Reply-To: <cover.1615331093.git.daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, john.fastabend@gmail.com,
        ast@kernel.org, willemb@google.com, edumazet@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 10 Mar 2021 01:38:08 +0100 you wrote:
> Fix a NULL pointer deref panic I ran into for regular ip6ip6 tunnel devices
> when collect_md populated skbs were redirected to them for xmit. See patches
> for further details, thanks!
> 
> Daniel Borkmann (2):
>   net: Consolidate common blackhole dst ops
>   net, bpf: Fix ip6ip6 crash with collect_md populated skbs
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: Consolidate common blackhole dst ops
    https://git.kernel.org/netdev/net/c/c4c877b27324
  - [net,2/2] net, bpf: Fix ip6ip6 crash with collect_md populated skbs
    https://git.kernel.org/netdev/net/c/a188bb5638d4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


