Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9166C380F70
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 20:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhENSMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 14:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232649AbhENSMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 14:12:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E38996141F;
        Fri, 14 May 2021 18:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621015848;
        bh=Jz/NOP16I0D/Krpn+zHrYeoD0G+Qq6veqSnBLjN2j7k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=COmnAaqO9OnlocmmzT5MM5R5Hs8LsFBIHGynwygthzbUEQ11eU3ZIXDOwVTQY28AS
         2e8FdvCTfBrYhg4jhavVODwP78WYxCVsicg75eDL1XwkRXCW/L68+NBGtyD+BFdxxA
         Zq2zcIH5Ft5DsJd/pRwg+3aRBiPQtRWXbW+GJajSTvqkW1A/zLpgc47y6t/YdsFIEO
         Qrr7dPYPs4FfOzDvJIels/jiR9ypvvmmjsWIA2VVxMjIHmkj3j8hTgan+R8aQxW6Kz
         9h9qxxcpBxoW0RG/hsw31j0qNxJX7+kQx9lcEwAhhv9skrtkWoFRluV86YTQPJ/nSJ
         jpUHMebimhr5g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D767B60A2F;
        Fri, 14 May 2021 18:10:48 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] selftests/bpf: convert static to global in tc_redirect
 progs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162101584887.1840.15055012966734973391.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 18:10:48 +0000
References: <20210514170528.3750250-1-sdf@google.com>
In-Reply-To: <20210514170528.3750250-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Fri, 14 May 2021 10:05:28 -0700 you wrote:
> Both IFINDEX_SRC and IFINDEX_DST are set from the userspace
> and it won't work once bpf merges with bpf-next.
> 
> Fixes: 096eccdef0b3 ("selftests/bpf: Rewrite test_tc_redirect.sh as prog_tests/tc_redirect.c")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/testing/selftests/bpf/progs/test_tc_neigh.c | 4 ++--
>  tools/testing/selftests/bpf/progs/test_tc_peer.c  | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [bpf] selftests/bpf: convert static to global in tc_redirect progs
    https://git.kernel.org/bpf/bpf/c/c9a7c013569d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


