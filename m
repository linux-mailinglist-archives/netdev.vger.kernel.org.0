Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DFB4710FB
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241141AbhLKCeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233815AbhLKCeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:34:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912AFC061714;
        Fri, 10 Dec 2021 18:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36BCEB82AA6;
        Sat, 11 Dec 2021 02:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C81E0C00446;
        Sat, 11 Dec 2021 02:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639189821;
        bh=bYseClG6Ux01VKc220PLdCYmhyp9RwokMlUgwVtm+XY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lxy1ZKwDMBP+93PP6bJ9ktaHsEiFLzdnkMm+PotxldByFYHsRcnRRpTA78KnAUGXt
         AuKmiyqfLC26/I7m//Tsi/MIeead+qK54VilqaUN0uYouWq5fgJvlGqSiMyGFlTXE/
         zmUk6BSPCL+QB+IMM6pSCsXkW+93hs+dDcMhIahSSp1GU7IIrDcQXxIa1Fry0SVx25
         9xrDfkMTVDf6cXPo8Zr6LLn55cmuwICuSYLIS8xfBIHMlAok0aoI9N/vH2ipPugOs1
         giZWRK75StIUwVCeGQYKdhqmS/FPPCGi2hrP8lOMJV8ouYouSQH/9BlQJKRukemxtu
         LA/lu0njvbzSg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B250D608FC;
        Sat, 11 Dec 2021 02:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request v2: bpf-next 2021-12-10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163918982172.1867.2851221184169760716.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Dec 2021 02:30:21 +0000
References: <20211210234746.2100561-1-andrii@kernel.org>
In-Reply-To: <20211210234746.2100561-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Dec 2021 15:47:46 -0800 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> There are three merge conflicts between bpf and bpf-next:
> 
> 1. Documentation/bpf/index.rst. Please Just drop the libbpf and BTF sections,
>    so that the resulting content is like this:
> 
> [...]

Here is the summary with links:
  - pull-request v2: bpf-next 2021-12-10
    https://git.kernel.org/netdev/net-next/c/be3158290db8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


