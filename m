Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB1D3947E1
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 22:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhE1UVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 16:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhE1UVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 16:21:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AF7BD6139A;
        Fri, 28 May 2021 20:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622233203;
        bh=1Qp7R+3RSXiXgrS0kFmoQgrl6WbUjoVruqLmvrOIPJk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tGBbRbyOxyL2q/aKBn8q9p/fPs0M2ip1qicYxR15dOrNTuWou2tN+69x2YZCF9Dxj
         nNPR+AW8Z/0weCs0lM6xaWHUULAsE8orPSm9ATWAc/sHC++awBGNpfOUvxBf2BfIbh
         P3ccQ0wgmo4vhzqSCYvwhI3dufs8SEt5bN1B+HzK2io85qSOsAkZTMGRtiduoQBU+p
         BqL8MgoUGPkaXgTFq7+50HfUg6TtbktwEkDGiMn3nVd6O1x4RbX6FcDfItM+w6XwhD
         jLdY5jwLmhempeuPFqRdo0CeMbuF4VpzyUZvZz9s0irJbAuYgHCCdcExuMz+jx/uRn
         FSGS81PPwVvcg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9EAC160A6C;
        Fri, 28 May 2021 20:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf/devmap: remove drops variable from bq_xmit_all()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162223320364.3755.2019874007174661527.git-patchwork-notify@kernel.org>
Date:   Fri, 28 May 2021 20:20:03 +0000
References: <20210528024356.24333-1-liuhangbin@gmail.com>
In-Reply-To: <20210528024356.24333-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, toke@redhat.com,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, brouer@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 27 May 2021 22:43:56 -0400 you wrote:
> As Colin pointed out, the first drops assignment after declaration will
> be overwritten by the second drops assignment before using, which makes
> it useless.
> 
> Since the drops variable will be used only once. Just remove it and
> use "cnt - sent" in trace_xdp_devmap_xmit()
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf/devmap: remove drops variable from bq_xmit_all()
    https://git.kernel.org/bpf/bpf-next/c/e8e0f0f48478

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


