Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45713145FF
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhBICA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:00:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229763AbhBICAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 21:00:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 91C5D64E24;
        Tue,  9 Feb 2021 02:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612836007;
        bh=BPGhUQRXb/0RGpMifnHqX1LPN3I9kuVyGNbc2ek4NkA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EbQwLf7MSguqvei+ykc4T+ksBbJSu2ekG+NpWX2XpSGvCUm8aCpFUCZnJ+Sls7eh8
         ytE0dxtwykTwRqUy2Ux+pmpEqtT5hCGiv6Yekwjt2wocOfYnR8TzDV9BAT/MpfHFbU
         y5JScd8II6wnZcoZMyS4Sflzlt0EANylyMsddzNH3V2xaPYd6QPucDH605Ab2y+xSa
         qY6EMeBqYH83KLUxx+SnCtBSHhTtThIwLKbugzTn3l9iucmW+1/D7S7ot7qckxDdIq
         sw0FMwqnpR8e+udglhny4YReBrWFAZhMKcdDOqwSUUBkgFhx8B393C0PlHmIB3yy/H
         dxo8LogQWal8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 81B31609DA;
        Tue,  9 Feb 2021 02:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: Simplify bool comparison
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161283600752.4994.17562431502969131989.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 02:00:07 +0000
References: <1612777416-34339-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1612777416-34339-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon,  8 Feb 2021 17:43:36 +0800 you wrote:
> Fix the following coccicheck warning:
> 
> ./tools/bpf/bpf_dbg.c:893:32-36: WARNING: Comparison to bool.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - bpf: Simplify bool comparison
    https://git.kernel.org/bpf/bpf-next/c/0a1b0fd929a8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


