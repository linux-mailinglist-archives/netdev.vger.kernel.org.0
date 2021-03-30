Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288BB34F2CD
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 23:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhC3VK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 17:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232589AbhC3VKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 17:10:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7812F619CA;
        Tue, 30 Mar 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617138609;
        bh=ofX2F6Yie2lWLeng2lkUxg6P511GpTQdjoE0D9zx0K0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dmL54/tCmFDoIONYyUxyuaJBU7S6C4XykNV5c2TcHBcnTnQrwW/djE+68xkzHWS2L
         KRaia3CoV/0unH1qMkS1bfJnnuxySoy9XuXQcjJo/ZhJ19/ce2ao7izifKVZcc4BaU
         klwOBsRICKNTuVBYMmxtPp42m5PSSg0bW/1QS3ZAjx52F3xABo3NLggxpDCT5Sw026
         FB3GtM7yIO76Mqz06DabZ/ITiTj1KLiYEr490viQUvVVlzks2OQZ/YOChsn5xlblTj
         xj+0FMl/fstqBUAfTX3ryABbrNjXhJEWnu+OayRDO3E8TMMCP8R+LgZowPrTcPzrDb
         06ZKJFI43EVYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6D6A560A5B;
        Tue, 30 Mar 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: remove redundant assignment of variable id
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161713860944.23555.1260625590576994737.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 21:10:09 +0000
References: <20210326194348.623782-1-colin.king@canonical.com>
In-Reply-To: <20210326194348.623782-1-colin.king@canonical.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Fri, 26 Mar 2021 19:43:48 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable id is being assigned a value that is never
> read, the assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - bpf: remove redundant assignment of variable id
    https://git.kernel.org/bpf/bpf-next/c/235fc0e36d35

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


