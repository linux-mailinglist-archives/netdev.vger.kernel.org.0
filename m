Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A3A394887
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 00:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhE1WBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 18:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhE1WBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 18:01:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AFF186135C;
        Fri, 28 May 2021 22:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622239203;
        bh=Yj2hR++uTaQ6SrplZu5Fd+of2KUSuKKJSDbvWPUfnoQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mPLVM+BXRhDfds9pAl0mZhL40IWQgIgDaiHz9FVFnNcsTkP5m1Yqfh7qvoyVPz/DP
         tw5YJgaEGaHRHRWttDkOiGkyqNulxRF2wtrehtDFS26e2q3/VhNzcnp51g67bM9IFs
         VwbXI0DivPCjs2vMuW8CwFAX9U1KqzljBf8qp/B62JAYRKUA6ysV2FZxq7RD645oET
         34QQj/YP4kFtQ9hJ+uHscdKlG7WPiVdSn3Qa8C82QeQQ9SbFNyOIqVOKKES/rmMuuq
         I056voPDgIw6vQD/lWF6a70A2Ve1pH6e03gUFMXSOIBA0vOn1sIvW5BAfRc5T0i4D+
         7jwMoIwwRc76A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A3E8F60A27;
        Fri, 28 May 2021 22:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] samples: pktgen: add UDP tx checksum support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162223920366.12511.18190581692194305181.git-patchwork-notify@kernel.org>
Date:   Fri, 28 May 2021 22:00:03 +0000
References: <cf16417902062c6ea2fd3c79e00510e36a40c31a.1622210713.git.lorenzo@kernel.org>
In-Reply-To: <cf16417902062c6ea2fd3c79e00510e36a40c31a.1622210713.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, lorenzo.bianconi@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 28 May 2021 16:06:35 +0200 you wrote:
> Introduce k parameter in pktgen samples in order to toggle UDP tx
> checksum
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - use spaces instead of tabs
> 
> [...]

Here is the summary with links:
  - [v2,net-next] samples: pktgen: add UDP tx checksum support
    https://git.kernel.org/netdev/net-next/c/460a9aa23de6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


