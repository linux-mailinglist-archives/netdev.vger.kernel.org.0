Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2F83DEB72
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhHCLAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235560AbhHCLAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B3496610A8;
        Tue,  3 Aug 2021 11:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627988405;
        bh=myda+1xt6kf8Sxsdj75YIIC+VLtT++ftiaNJq7e98Sc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pipLyt9bkUCgr0R2sog/hvnMDwmdKEWfyKBVfTAkuhxiFHuWqwBYIFIG1ifNbkp0c
         gu5akEtn1fyQi/Tto0VnXZLL1iKXCAOWK4QfmOiBPuX59YBlHoGTZVAIaxapTnQ6if
         YLIG9fO0xpHqf4y3O71Ezz3w6dIRyeecTAVsmg9G2cJA8MWW1I3xGWbvDEksnU6XZW
         G9zp54AD2tvBDsF+8qnjX5VQZbjxIKa6+4bGj27HimBCccjbWAw3Gy/VqLe0fu3OQh
         3Lx/Gm3QHql8LG+2FRA0jWSgCDzvSJtRdm3L49QR7G7qtRh2VeqE5J53MCjp3Eh81o
         2+zj8vZKM1ZnQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC02D60075;
        Tue,  3 Aug 2021 11:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch bpf-next] unix_bpf: check socket type in
 unix_bpf_update_proto()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162798840569.8237.10177064889058148886.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 11:00:05 +0000
References: <20210731195038.8084-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210731195038.8084-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        jiang.wang@bytedance.com, cong.wang@bytedance.com,
        jakub@cloudflare.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, lmb@cloudflare.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Sat, 31 Jul 2021 12:50:38 -0700 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> As of now, only AF_UNIX datagram socket supports sockmap.
> But unix_proto is shared for all kinds of AF_UNIX sockets,
> so we have to check the socket type in
> unix_bpf_update_proto() to explicitly reject other types,
> otherwise they could be added into sockmap too.
> 
> [...]

Here is the summary with links:
  - [bpf-next] unix_bpf: check socket type in unix_bpf_update_proto()
    https://git.kernel.org/bpf/bpf-next/c/83f31535565c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


