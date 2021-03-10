Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6676A334A56
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 23:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbhCJWAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 17:00:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232828AbhCJWAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 17:00:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7E5E964FAB;
        Wed, 10 Mar 2021 22:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615413608;
        bh=UWOVUMz5Uk7kxc5dvofPgSuVGCnhJuzzkLv8jMm0274=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CcDGcr4NhOOzcBlymYUruvhmBPdC0Y7zm2Mu70j5hxQCVf02qnVyz5NQ8cNptGjn3
         egto9f4YPaAtyx9Bg0CYn3f5hiLxBZRqqqu5r0RO3R8J3+AdY1kG6zjxpWkt6eFPm/
         Ga/0RY9GE5XYFK9leBgBtB+pXlLWX9NmUuCNYcX+7LogGyXdP3rxbA1ZYbhG7KCe/Q
         vPsvwI+uVmkofw6ywCNadJjba7uNsNgr4WgOeGgydd5ifrXyQEgp3TADEm0RFMhCJw
         sEKJ8rfrLQqlwzyFdd/eARdYdseLXtXu5b5AcAUHLf8ZuIYJAJlcBMdJx1utJ9SbM2
         C2XsEiE4l5k9Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 76036609B8;
        Wed, 10 Mar 2021 22:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: fix warning comparing pointer to 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541360847.31690.18054636918318010302.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 22:00:08 +0000
References: <1615360714-30381-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1615360714-30381-1-git-send-email-jiapeng.chong@linux.alibaba.com>
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

On Wed, 10 Mar 2021 15:18:34 +0800 you wrote:
> Fix the following coccicheck warning:
> 
> ./tools/testing/selftests/bpf/progs/fentry_test.c:67:12-13: WARNING
> comparing pointer to 0.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - bpf: fix warning comparing pointer to 0
    https://git.kernel.org/bpf/bpf-next/c/a9c80b03e586

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


