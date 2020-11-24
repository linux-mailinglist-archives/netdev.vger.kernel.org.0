Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DAB2C340A
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388808AbgKXWaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387714AbgKXWaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 17:30:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606257005;
        bh=Dph1ZK1vQqK/ULAE+cLL8yH/aR9yZ19moRF+hYJckj0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A/vU6p6TB7dJkTIUMRYNBYLRPrCwsH8pv29u4ypOY24aMiZ6qfzxP5GI6rZU84AgV
         XiQWFCo/K4OfrdBIhuogvwtXKj/1OJ56KTOR0aTY6+radkbqC+m74XE5sy1S5KZHph
         4sz92TYCdC89TBZTvT+B4S/O5GRwehXZneMWfI1o=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] tools/bpftool: fix error return value in
 build_btf_type_table()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160625700509.27050.8212004857900634536.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Nov 2020 22:30:05 +0000
References: <20201124104100.491-1-thunder.leizhen@huawei.com>
In-Reply-To: <20201124104100.491-1-thunder.leizhen@huawei.com>
To:     Leizhen (ThunderTown) <thunder.leizhen@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Tue, 24 Nov 2020 18:41:00 +0800 you wrote:
> An appropriate return value should be set on the failed path.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  tools/bpf/bpftool/btf.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [1/1] tools/bpftool: fix error return value in build_btf_type_table()
    https://git.kernel.org/bpf/bpf/c/68878a5c5b85

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


