Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C07433E1CE
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhCPXAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhCPXAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 24FD864F4D;
        Tue, 16 Mar 2021 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615935608;
        bh=TFUXBS9QCupYRhw07OCcD4xQmzxCDE+RXBRBHC7b41c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uTCfIv9cbP31bpSJCi/e2jqTk3sM+NNRWFxbBAB81B+4Hem0I5e5J4R/Lw30+0tvI
         teA2ldoSE+KhCUprM43V4vSyWRZl5uQvzNLLQNp1lahlZ5WbXpYlJbWm1tHUNvcAgL
         HLi+u1p5msJvqmWf5FlUkctytZsKzHn0yhYI6ZFNSV/O+LaLFOZCYRGoXa/sqR7Fkp
         iCSe9qBVLZE78pdeXvIuuupfFf8grsBEDAskCwX5QC/MDirHO5PSJsXGptf08No7p+
         2a08ZtmOS5SA1hZQzMgEFnMw3rW1kpT00ULoXAHprtkDouvsClt/OA8PH1WZsOzC3H
         mGTt7e1Xzx9eA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1454960A3D;
        Tue, 16 Mar 2021 23:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests/bpf: fix warning comparing pointer to 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593560807.19756.14716242106660092379.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 23:00:08 +0000
References: <1615881577-3493-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1615881577-3493-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
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

On Tue, 16 Mar 2021 15:59:37 +0800 you wrote:
> Fix the following coccicheck warning:
> 
> ./tools/testing/selftests/bpf/progs/fexit_test.c:77:15-16: WARNING
> comparing pointer to 0.
> 
> ./tools/testing/selftests/bpf/progs/fexit_test.c:68:12-13: WARNING
> comparing pointer to 0.
> 
> [...]

Here is the summary with links:
  - selftests/bpf: fix warning comparing pointer to 0
    https://git.kernel.org/bpf/bpf-next/c/ebda107e5f22

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


