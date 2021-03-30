Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5B634DDE5
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 04:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhC3CAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 22:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229763AbhC3CAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 22:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 719F36193A;
        Tue, 30 Mar 2021 02:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617069608;
        bh=KX1+8e1VgM1HYQn7FeFYykjFkEttjZcu+KtPlmCTql0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q+mdB8AApydzdXepaq0BglHBhAexLvYoQhFw6n3k7NFTpDS/dui05MzdBiHVd6JBc
         ZAMCT/nB+rShOhGvZgO88nrXXligRHUMMNGOY9icklz+8i1MFQEfb4/Pd4wGcNG8lI
         TPOkEkFH9HrU6hXj+2Ajg++Kq5G8B0WUIl06trlwyGH4f8RddvmYnLLpKhFMz/OSWw
         JbyFaNl8hNhpHcG6LkXEgnJFy2M/WlcDkXMTYx6SkqJvP+7wB4RcWUQPegdMia4+MT
         XVzv7bIKCnsxzzviamRYnW0Q63yhtOCQLkc5RphoXF+Z1uUlqnvIFAy/j+kyISdoUG
         iyz45QIYtTczQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 622FF60A49;
        Tue, 30 Mar 2021 02:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: tcp: Limit calling some tcp cc functions to
 CONFIG_DYNAMIC_FTRACE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161706960839.12105.10125740091884845374.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 02:00:08 +0000
References: <20210329221357.834438-1-kafai@fb.com>
In-Reply-To: <20210329221357.834438-1-kafai@fb.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, lmb@cloudflare.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon, 29 Mar 2021 15:13:57 -0700 you wrote:
> pahole currently only generates the btf_id for external function and
> ftrace-able function.  Some functions in the bpf_tcp_ca_kfunc_ids
> are static (e.g. cubictcp_init).  Thus, unless CONFIG_DYNAMIC_FTRACE
> is set, btf_ids for those functions will not be generated and the
> compilation fails during resolve_btfids.
> 
> This patch limits those functions to CONFIG_DYNAMIC_FTRACE.  I will
> address the pahole generation in a followup and then remove the
> CONFIG_DYNAMIC_FTRACE limitation.
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: tcp: Limit calling some tcp cc functions to CONFIG_DYNAMIC_FTRACE
    https://git.kernel.org/bpf/bpf-next/c/7aae231ac93b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


