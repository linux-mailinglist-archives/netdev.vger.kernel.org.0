Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF05355DF7
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 23:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343687AbhDFVaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 17:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234898AbhDFVaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 17:30:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DC788613BE;
        Tue,  6 Apr 2021 21:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617744608;
        bh=BawFUilrPkuY2k3NUQMjQeVCEpoFTVypSk5s1uGdKTE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XrlKX5qf5BbuYuoaJrXx7a1q+hu2oNLAJ60hNNN4i4kDc0ERyIZORvdOmfpGgERV4
         zi+/pls2ZjQjq/Hrd2zYXM3pyLB0uki++RyIe9w8PdF60/l3GaXrvUC373YQr8EAwT
         8wSiaT0NgrYeSkJX+aiVVj5MeX/gFRyM8HOcyt+nh5fmGxYhJXbFcbEdGhaY0+F9ap
         hO1qe9Gf0aWCZq7d3zNVwFlwhG4lmyVrT1Ol9Gkyef31VaN9GF0meoITmmn5qejyeX
         wVGZgN5inn9v9m+oiIqpQ4FAO7oZ5FtCgrfmQglFEPycgygvWXO4hB47ezHkzVbGWt
         aiOIzjYGACzYA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CFF23609FF;
        Tue,  6 Apr 2021 21:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch bpf-next] udp_bpf: remove some pointless comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161774460884.6918.8030006741497713012.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Apr 2021 21:30:08 +0000
References: <20210403052715.13854-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210403052715.13854-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        cong.wang@bytedance.com, jakub@cloudflare.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, lmb@cloudflare.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Fri,  2 Apr 2021 22:27:15 -0700 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> These comments in udp_bpf_update_proto() are copied from the
> original TCP code and apparently do not apply to UDP. Just
> remove them.
> 
> Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] udp_bpf: remove some pointless comments
    https://git.kernel.org/bpf/bpf-next/c/928dc406802d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


