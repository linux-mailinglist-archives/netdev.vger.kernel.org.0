Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1087137B0C7
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 23:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhEKVbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 17:31:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhEKVbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 17:31:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B9DAA6191A;
        Tue, 11 May 2021 21:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620768609;
        bh=xM6w8kIaQ8slRjFnNOAAYS/CmYQHgMpdp0Wfj+iuE5A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m0+IR5IC8rvuSt2nM1Ql3S7ar9gG7ReSdDpcWI8IxgRMXu0X85l83YMuPo0Dve082
         v2Qh4LibeKxLigiVfXB1UNk2LpNFEdnU4typ3SSlUU++1hh9af66UlSvihWgz0g2vF
         KmS1MGR2Cz3iahNgF4KY+J+NO+NGOuMXFPJULwwm+8c+TIrky+q/ZNtW3cZioAgzw7
         aQCQKOOIiLn2KOQI/5zQG89kZRRP8O5ik0HZeSr+5GeEEARRE9dnsvUgQNIHdEtOh7
         vn9BsarTOkI4RW1qSR9rOiTq3QGj2n3DywUCtGovRXLi19oBGrMODcDjcOz0zdocfp
         kMb2jfiAi5aQQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AD3EA60A71;
        Tue, 11 May 2021 21:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] bpf: Limit static tcp-cc functions in the .BTF_ids list
 to x86
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162076860970.722.8375596589065957808.git-patchwork-notify@kernel.org>
Date:   Tue, 11 May 2021 21:30:09 +0000
References: <20210508005011.3863757-1-kafai@fb.com>
In-Reply-To: <20210508005011.3863757-1-kafai@fb.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, netdev@vger.kernel.org, msuchanek@suse.de,
        jslaby@suse.com, jolsa@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Fri, 7 May 2021 17:50:11 -0700 you wrote:
> During the discussion in [0].  It was pointed out that static functions
> in ppc64 is prefixed with ".".  For example, the 'readelf -s vmlinux.ppc':
> 
> 89326: c000000001383280    24 NOTYPE  LOCAL  DEFAULT   31 cubictcp_init
> 89327: c000000000c97c50   168 FUNC    LOCAL  DEFAULT    2 .cubictcp_init
> 
> The one with FUNC type is ".cubictcp_init" instead of "cubictcp_init".
> The "." seems to be done by arch/powerpc/include/asm/ppc_asm.h.
> 
> [...]

Here is the summary with links:
  - [bpf] bpf: Limit static tcp-cc functions in the .BTF_ids list to x86
    https://git.kernel.org/bpf/bpf/c/569c484f9995

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


