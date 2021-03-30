Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A007134F2B2
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 23:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhC3VAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 17:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232558AbhC3VAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 17:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C2A5619B1;
        Tue, 30 Mar 2021 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617138009;
        bh=qMO9D6IAsZ8HpnlE5kwlJX+n4a65d0ouLpNCluVbleM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fSJzekK+RYclYECoPTYhgM26AHIblQoG0GZ4VXoeGDpIMcfJZAW8LmbT5lr/VdeOF
         dfH+V8I+KGj4kOK3GZ73aORMeaqLRsOll9kWBy90VNKo0mxWtdXNR7+6Li0E9sLyS7
         fEOx1hMUAO9w2TQEy+2gRUAe5bl3UOqQJfKWGPMX8YKP16J5kiQEg4raibXykxgsVZ
         m9nQXteNxoIj1zEWipEj1aT2r+URkCWqwYl76BkkaDV5kE6OHzK/YwYnTuwMHp8gkC
         Etdxzdc8bu1PPiDZmHexVwEDD81CdsV8tcZ0nril+kPip4n/s6It63OzFpvzvd9Nzd
         i0wPm/34jZFkA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1A8D460A3B;
        Tue, 30 Mar 2021 21:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch bpf-next] net: filter: Remove unused bpf_load_pointer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161713800910.19867.3798831652691518137.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 21:00:09 +0000
References: <20210330024843.3479844-1-hefengqing@huawei.com>
In-Reply-To: <20210330024843.3479844-1-hefengqing@huawei.com>
To:     He Fengqing <hefengqing@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, ongliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 30 Mar 2021 02:48:43 +0000 you wrote:
> Remove unused bpf_load_pointer function in filter.h
> 
> Signed-off-by: He Fengqing <hefengqing@huawei.com>
> ---
>  include/linux/filter.h | 9 ---------
>  1 file changed, 9 deletions(-)

Here is the summary with links:
  - [bpf-next] net: filter: Remove unused bpf_load_pointer
    https://git.kernel.org/bpf/bpf-next/c/913d55037616

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


