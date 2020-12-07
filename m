Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961AF2D1DC2
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 23:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgLGWur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 17:50:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgLGWur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 17:50:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607381406;
        bh=F1SHKlUoaSMySF5lG04zNADGBC4IIxqFTuq0d9GASWk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kIZiNv34trwZrflswTPlmKsjfOM3rW+WEzSlgPYz4cZwDmwUh/zhczNcyYAw/qZmi
         EiXB0y47O6BDKXGqF55oGfG5fKibxmz2LmjOzuq1B91iNzzqWhtWxCPOLvKCd4/PAP
         q0fUETh/MeO9viTeXBLDtWThNux6fhfN5QfE+CorpsYFAvjMrlOo9XysDXccyBJczc
         7cUgB1UcLMMd344cntwiZa59OHp/FJo6hmFnmfiCz+/yNX4iatKNy23ksZMskEsvXb
         Pla9KB+7jR+Fp6enlf2lQUj1+RCoFhoj1vHCExnrkt9R1DuByolcwp7DHaLXEVsqw1
         65soTBGrMeSBA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: avoid overflows involving hash elem_size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160738140673.13800.6309279331247475101.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Dec 2020 22:50:06 +0000
References: <20201207182821.3940306-1-eric.dumazet@gmail.com>
In-Reply-To: <20201207182821.3940306-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, bpf@vger.kernel.org,
        syzkaller@googlegroups.com, guro@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon,  7 Dec 2020 10:28:21 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Use of bpf_map_charge_init() was making sure hash tables would not use more
> than 4GB of memory.
> 
> Since the implicit check disappeared, we have to be more careful
> about overflows, to support big hash tables.
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: avoid overflows involving hash elem_size
    https://git.kernel.org/bpf/bpf-next/c/e1868b9e36d0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


