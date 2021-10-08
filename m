Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FCA4263F8
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 07:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhJHFCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 01:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229706AbhJHFCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 01:02:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 372AD61073;
        Fri,  8 Oct 2021 05:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633669207;
        bh=rvyT9UDSyAaXYGTAEv0hPa/nw4WDjtO8dKc1Hmyy4Jg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m/oTwYveCbbcJOs4UlZ50wViLV852pLPa8lIPUWKL8vjifs1fMltTVnjoxR8X5b42
         tLTMyZd2bOPLRQYUYLl8qlnrv4u8thFslEKejHDfxm745jWhJ2+/j293+hxv+P2rYc
         w7cbXLFSCh+uWKdx7r86xb4qJqBLvTiqGngxtB5VzC0EKeZi7kIccd1Ln1fK1j+IWN
         GP6aSC672gk2v1U/oaybQkjGb9NUGEUybcTuSd/l41ywRRC3yIL/LN+fiWzLmOHgSR
         6Cpdtf1Ri2bEKLmaNTdj0vLwLMCHl4/yVq9U0Yvg31TlnzEtutO+Ph9VV2sYQGq7oY
         91smZCQ0Bpqqw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2A40960A53;
        Fri,  8 Oct 2021 05:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] selftests/bpf: skip the second half of
 get_branch_snapshot in vm
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163366920716.3542.2142107199252164729.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 05:00:07 +0000
References: <20211007050231.728496-1-songliubraving@fb.com>
In-Reply-To: <20211007050231.728496-1-songliubraving@fb.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Wed, 6 Oct 2021 22:02:31 -0700 you wrote:
> VMs running on latest kernel support LBR. However, bpf_get_branch_snapshot
> couldn't stop the LBR before too many entries are flushed. Skip the
> hit/waste test for VMs before we find a proper fix for LBR in VM.
> 
> Fixes: 025bd7c753aa ("selftests/bpf: Add test for bpf_get_branch_snapshot")
> Signed-off-by: Song Liu <songliubraving@fb.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] selftests/bpf: skip the second half of get_branch_snapshot in vm
    https://git.kernel.org/bpf/bpf-next/c/aa67fdb46436

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


