Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A708375D6C
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 01:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhEFXbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 19:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231733AbhEFXbI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 19:31:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C70D0613BA;
        Thu,  6 May 2021 23:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620343809;
        bh=8xc5NtSbYWSE84pOymur97rxebkDQvJm+1HT+DfT5MA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AHQsURpqhnSJB5ilXO803cX8dKNvTY+6ZkQQSaY6c7iYirI8EK3R9Dspk10h3+Zz6
         SpRL63y7yLXYBoGNMbrvfV/rjaTaZziHWgNEfrfQeki+ZpE7BZ3X01jmb6MTzjqbv7
         VgNKO9clf8hE7w8bSXpaFhyaFnQQrkVitp0Zud7zv0Ry9MAF3ZvIohRJhPP9uMkpkn
         o08tkyiPZOR8PWlCyxKCt9seNu9Qyp7iCCVH5GZ4g2uduiHxe5mqjrmN5VhYH8xNMC
         5c4qOeinSic35nufP8tfU7oJRfQ//iRRI4j2pxj3qhHU4BTr8FBj5Hf+YK1/OKDTwI
         Kfej/zUkA5hiQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BB84A609E8;
        Thu,  6 May 2021 23:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: Forbid trampoline attach for functions with variable
 arguments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162034380976.14975.13821771720470799714.git-patchwork-notify@kernel.org>
Date:   Thu, 06 May 2021 23:30:09 +0000
References: <20210505132529.401047-1-jolsa@kernel.org>
In-Reply-To: <20210505132529.401047-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed,  5 May 2021 15:25:29 +0200 you wrote:
> We can't currently allow to attach functions with variable arguments.
> The problem is that we should save all the registers for arguments,
> which is probably doable, but if caller uses more than 6 arguments,
> we need stack data, which will be wrong, because of the extra stack
> frame we do in bpf trampoline, so we could crash.
> 
> Also currently there's malformed trampoline code generated for such
> functions at the moment as described in:
>   https://lore.kernel.org/bpf/20210429212834.82621-1-jolsa@kernel.org/
> 
> [...]

Here is the summary with links:
  - bpf: Forbid trampoline attach for functions with variable arguments
    https://git.kernel.org/bpf/bpf/c/0a1a616720d9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


