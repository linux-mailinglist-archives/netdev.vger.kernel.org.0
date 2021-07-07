Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDD63BEC02
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhGGQWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230087AbhGGQWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 12:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 56AAA61CC5;
        Wed,  7 Jul 2021 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625674805;
        bh=Kb6qq5W7yE8CW8mN9DhQfKw+DZK9P+X65+n47ftl1jc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M6k4cXh3/atQpdiCn0PLQB6w9mtXLFV0bbIFpzAqyN/lYdPFHYl1RVRKvs6P0WgEe
         rqAkT48S8wVSFZCUCuRgFcyHktM3Uc0LYLMmLVsaOZXBl66orYJgBqpFQt6fJKexz8
         m1RrxDpo1Q+Mo5Ip0yqCd/L1g+WkzAgtaBu+2Y/OVKrfbJcegvDPuZqUUpbEK7XuSB
         bWyL0fB9A9myQbYsicXfYWF/V4z1cAZ2QuOn4RIVgvwmUdalnI/zfepAL5revW+wlG
         H/HIStSHrI7FI2cNscSE5lv5NI+gHCp0ljHpUaGrYhZntx3Nl4P8DaxBsBaHOtlpVV
         0lg5eZHRFnnSw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4A13B60A00;
        Wed,  7 Jul 2021 16:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tools/runqslower: Change state to __state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162567480529.26315.18159195835921682294.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Jul 2021 16:20:05 +0000
References: <20210706204005.92541-1-jolsa@kernel.org>
In-Reply-To: <20210706204005.92541-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, peterz@infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Tue,  6 Jul 2021 22:40:05 +0200 you wrote:
> The task_struct state got renamed to __state, causing
> compile fail:
> 
>   runqslower.bpf.c:77:12: error: no member named 'state' in 'struct task_struct'
>         if (prev->state == TASK_RUNNING)
> 
> As this is tracing prog, I think we don't need to use
> READ_ONCE to access __state.
> 
> [...]

Here is the summary with links:
  - tools/runqslower: Change state to __state
    https://git.kernel.org/bpf/bpf/c/cced7490b172

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


