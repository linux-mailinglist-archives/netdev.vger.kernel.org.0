Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BA4463BC0
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 17:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbhK3Qdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 11:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbhK3Qdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 11:33:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED6BC061574;
        Tue, 30 Nov 2021 08:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91E00B81A56;
        Tue, 30 Nov 2021 16:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38E6AC53FCD;
        Tue, 30 Nov 2021 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638289809;
        bh=c5M+V55eq8kpA9tUax0yqfPtgOAn3oo0WlSLkiB+yRc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OC3DmhcRi/oC/0jRlTPVXqgFphyssd0KCY9pChqbBwMD0ueemkUvU60yeXsfx+r8A
         7mwNJ/DC9+Mfs0N12BFSXC65QRRZJoC1+/QGQzLe4ME+lpNxoR8895a2/TJy970aLb
         H4IV4nj71SFBbFKY/s5vRQ1AY2bTBUa2Spznrk9ZpkY96GRAp99tCFJjZvRSLykxxR
         iBF+YE5Z8/FZyQj0M2NNpu2QNlSuGCqCBtlbBWxkGXNBlRttxS1SRyt+VODOEokTRS
         T68DtRr8tTpN6OQMbbQE4tei4t+opPAAJYw2oTsxlEUNLAFLpTMG70DGcRsNXXdIu6
         mvFJese+o0chA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 17D0B60A50;
        Tue, 30 Nov 2021 16:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] mips, bpf: Fix reference to non-existing Kconfig symbol
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163828980909.14069.11489400841762742926.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 16:30:09 +0000
References: <20211130160824.3781635-1-johan.almbladh@anyfinetworks.com>
In-Reply-To: <20211130160824.3781635-1-johan.almbladh@anyfinetworks.com>
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        paulburton@kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        tsbogend@alpha.franken.de, bpf@vger.kernel.org,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        lukas.bulwahn@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 30 Nov 2021 17:08:24 +0100 you wrote:
> The Kconfig symbol for R10000 ll/sc errata workaround in the MIPS JIT was
> misspelled, causing the workaround to not take effect when enabled.
> 
> Fixes: 72570224bb8f ("mips, bpf: Add JIT workarounds for CPU errata")
> Reported-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> 
> [...]

Here is the summary with links:
  - [bpf] mips, bpf: Fix reference to non-existing Kconfig symbol
    https://git.kernel.org/bpf/bpf/c/099f83aa2d06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


