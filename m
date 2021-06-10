Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFA83A351D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhFJUwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230286AbhFJUwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:52:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BB75461410;
        Thu, 10 Jun 2021 20:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623358206;
        bh=U7LNjFx8abNmPYqpajg/EzHWz8ZdPu3fWg+a1qGbGPc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PMd89B+OXVrAiB0iV4hPkmGfRUpB8QdTEjjWVjhquNVBdjfHj3jRZHo4gVBY/iZBw
         2HCZahsUdafY3EsE1q4zBKTLVfTQZTN3L0eM+0hyZbruFxMsesSun1HRMv7fnfsKgT
         HNpmB1fDRKD1+uIBR3xFNudGBm4bWaTNHFM3rH23g2cYObqPwUMHS6FEmmYepZmwUl
         itZHxJrtp3atO9BdWcpA6QnKTVpzuU5Kz/GC4r0k4O57VqlzBLY4R3YMOxEl2jVHmb
         wKh3jpuEKRU7eXkudAMAqPMJzjQNtnZx++FLPqK8BXrzt9puFGM5E+l6R53ZmgkrJm
         w+uMG5woo33kw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B5B43609E4;
        Thu, 10 Jun 2021 20:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] af_unix: remove the repeated word "and"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335820673.975.4091644362333955050.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 20:50:06 +0000
References: <20210610030935.35402-1-13145886936@163.com>
In-Reply-To: <20210610030935.35402-1-13145886936@163.com>
To:     None <13145886936@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  9 Jun 2021 20:09:35 -0700 you wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Remove the repeated word "and".
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/unix/af_unix.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - af_unix: remove the repeated word "and"
    https://git.kernel.org/netdev/net-next/c/4e03d073afc4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


