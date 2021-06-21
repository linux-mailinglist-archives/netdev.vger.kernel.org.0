Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93813AF5F6
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhFUTWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230170AbhFUTWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 15:22:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E0A2A6124B;
        Mon, 21 Jun 2021 19:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624303203;
        bh=rbIAIkh5Z2rgwm5eiA/O4v7S9czd026nZP+YQn3l7do=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y7eT8lcTkf3giSoLd2tNH+wLQ8GrUxXGnTpftHgOrLKHlKMIn7wHAiVC5dERwzUoI
         kdUjNe0z/3srBT5dioex2rMSmgJQKt3VnvfwL6undypJyoYKG7CkRLw+VIjbjeUgd5
         az/jukbDdlpk6tYWWPgW/I8bCUQ33akOKIeE49xN2EKoaIn0Ayv+0f4cTMrvdbqybl
         LT2S+YZ4+9LqDpkP+l/BlbwSXXr+Auv/s7XXJOii5a844IdBC0/MOz9md4gejpkj2P
         Pc+9B4KcCJtyu+TCCWAcMNFeSh5FjIgl9n2JthGZUTA5PvHC0ykPD+yiHehoh8/evc
         emfWPI9a0l/Ow==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D47166094F;
        Mon, 21 Jun 2021 19:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] hv_netvsc: Set needed_headroom according to VF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162430320386.6988.2279267883191096562.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 19:20:03 +0000
References: <1624044939-10310-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1624044939-10310-1-git-send-email-haiyangz@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        kys@microsoft.com, sthemmin@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 18 Jun 2021 12:35:39 -0700 you wrote:
> Set needed_headroom according to VF if VF needs a bigger
> headroom.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/hyperv/netvsc_drv.c | 5 +++++
>  1 file changed, 5 insertions(+)

Here is the summary with links:
  - [net-next] hv_netvsc: Set needed_headroom according to VF
    https://git.kernel.org/netdev/net/c/536ba2e06d1a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


