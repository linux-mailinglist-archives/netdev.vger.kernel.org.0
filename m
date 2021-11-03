Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4ED444421
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 16:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhKCPCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 11:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231304AbhKCPCs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 11:02:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 80D0E61076;
        Wed,  3 Nov 2021 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635951611;
        bh=jWCMYuWajVvJ5x7/F1+deHeYv6zzi2sK+QhqwCuRmQQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VGhewqwgfQ4yiq9+n6njXVU8BoLwRF+blPVwYEQz8bPlKh2JryogoIY8dWN2XgXLK
         qSvK2iHB7kJlBR8NC8X72fnizpPuRHLUmZmhKbqAabaycRX5SmmWjAdHY4j2Ng18zD
         7gFjdz7eu+Qvp9Hm54zRtyksNpXlfdeg0lcu//oaOzDo6nawoNg0KvB+6i1jXAk6uK
         8Php8+d3CFNEdPUz/xRNZYWlG7bTx4scusf57uYOEe9+ttDUdNOZOW7xiC876eBvyi
         A1am66n1j2eP3//KFtGyTd3tlyyfskguC6VaphLLeMf4s1wzk2W2bouVeq3H9AO1ek
         +nbFF55h5oYIg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6F0A56095B;
        Wed,  3 Nov 2021 15:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3 0/4] Support RENAME_EXCHANGE on bpffs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163595161144.22644.942879656026929279.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 15:00:11 +0000
References: <20211028094724.59043-1-lmb@cloudflare.com>
In-Reply-To: <20211028094724.59043-1-lmb@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     viro@zeniv.linux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, mszeredi@redhat.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 28 Oct 2021 10:47:20 +0100 you wrote:
> Add support for renameat2(RENAME_EXCHANGE) on bpffs. This is useful
> for atomic upgrades of our sk_lookup control plane.
> 
> v3:
> - Re-use shmem_exchange (Miklos)
> 
> v2:
> - Test exchanging a map and a directory (Alexei)
> - Use ASSERT macros (Andrii)
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/4] libfs: move shmem_exchange to simple_rename_exchange
    https://git.kernel.org/bpf/bpf/c/6429e46304ac
  - [bpf-next,v3,2/4] libfs: support RENAME_EXCHANGE in simple_rename()
    https://git.kernel.org/bpf/bpf/c/3871cb8cf741
  - [bpf-next,v3,3/4] selftests: bpf: convert test_bpffs to ASSERT macros
    https://git.kernel.org/bpf/bpf/c/9fc23c22e574
  - [bpf-next,v3,4/4] selftests: bpf: test RENAME_EXCHANGE and RENAME_NOREPLACE on bpffs
    https://git.kernel.org/bpf/bpf/c/7e5ad817ec29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


