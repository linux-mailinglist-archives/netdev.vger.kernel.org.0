Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7285931424A
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 22:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbhBHVvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 16:51:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236966AbhBHVus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 16:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7214464EA1;
        Mon,  8 Feb 2021 21:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612821006;
        bh=Fcu/FReFOPh9QkXjJSEkh0Q8nvJlLktqEuueX3iwpZA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s9CriMN2kktLleFCx8sPSvqsKwR7cBjrKHE5QLId8gFpxAjgk2Y/xA5wISvuvMtzS
         yxBwQAF1Lg1G3y1H3n2hQn8L5a9NlxlQP/Mn34wQ1l3n6XPLP2OfMhOUshDjA8kS40
         FWZOs+3bt4G8OEsK9kSWI9Aune1nStYtqALL6rjmzujIX/YN/qj7JRKe/OyqZJyTwB
         MtybJC3oZ7WCLNsF3Cfs9Y+MMz1CrJhoUP6xdu+Vavwi/nR35DZ2vQXUj2vcHn7Wp4
         6vogI+Hi4eIyERfp7InHuirp7aLkKJpjoJlWnvq5yrxyw2Ap/px/YyI+QRFLMWkZPT
         2jWLztqm59Mow==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5B6F260981;
        Mon,  8 Feb 2021 21:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf/benchs/bench_ringbufs: remove unneeded semicolon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161282100637.19080.17842293087429651326.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Feb 2021 21:50:06 +0000
References: <1612684360-115910-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1612684360-115910-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Sun,  7 Feb 2021 15:52:40 +0800 you wrote:
> Eliminate the following coccicheck warning:
> ./tools/testing/selftests/bpf/benchs/bench_ringbufs.c:322:2-3: Unneeded
> semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - bpf/benchs/bench_ringbufs: remove unneeded semicolon
    https://git.kernel.org/bpf/bpf-next/c/215cb7d3823e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


