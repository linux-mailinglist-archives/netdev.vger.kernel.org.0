Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8623BEC03
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhGGQWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:22:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230099AbhGGQWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 12:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6CEAA61CC7;
        Wed,  7 Jul 2021 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625674805;
        bh=t6LUwilPolqDKUuAiVDl5lMBc+y4qahA0lspaaYvd5g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IFNSY2XzyQPNTTLr2KsYKjnqZxkTcRA7oGhOcEsJzhayWmLkm3Tex3v82qTH17drd
         Uj/FdZ3LqJmYtrF1bD1yD9dmE/UOipdPfoh31Z8WLLHnG6LzVpFmpAQRxr7lNZ/Dio
         28xLdy6xkELB+AoRL0gM/d3Gr934UElsBeelaQxCfm9mZww1LXj4WCiqeFzv3G0QHe
         lWp8zDuf7H/KadcMQkRoYLRZYTtGtGN45ARQk4wVk7vXrUn4Lzv3d1lq0kKR94m+A4
         ti+eTg57hiXRsL/WQNy+mMeG+oLqjr/4zAJJ1uemcGBV73UTnXJ5QJY4zbx2zYH43Q
         +l6hq0+BmlQlA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 61B84604EB;
        Wed,  7 Jul 2021 16:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v4] tools/runqslower: use __state instead of state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162567480539.26315.2538263759039711193.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Jul 2021 16:20:05 +0000
References: <20210707052914.21473-1-vjsanjay@gmail.com>
In-Reply-To: <20210707052914.21473-1-vjsanjay@gmail.com>
To:     Sanjay Kumar J <vjsanjay@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed,  7 Jul 2021 10:59:14 +0530 you wrote:
> Commit 2f064a59a11f: sched: Change task_struct::state
> renamed task->state to task->__state in task_struct
> 
> Acked-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: SanjayKumar Jeyakumar <vjsanjay@gmail.com>
> ---
>  tools/bpf/runqslower/runqslower.bpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [bpf,v4] tools/runqslower: use __state instead of state
    https://git.kernel.org/bpf/bpf/c/cced7490b172

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


