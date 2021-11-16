Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1350453289
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 14:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236429AbhKPNDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 08:03:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236453AbhKPNDG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 08:03:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 510CD6127C;
        Tue, 16 Nov 2021 13:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637067609;
        bh=Q7hrkqfXVGRCpsgwp8NtgAY9kNuAVaMQNOpA9mTtT6k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jovKs6Z0WpGq5mBsndlqXKn1Dj0ezLZGFskeK2GBZuV/Vb3QQsZB/IyhFyUAynAfu
         8gC08NMP+5+k1YH+6ef6QGneqEJdkouHnTWL7Eyb4JOw+wfdVz26o2WYx5ZPHNpBGn
         M0OwaGrQ77OOlfBLtaDdxIXe58hMkwEoFShUAPOBMF5z4jU/ue0o6hjqdw2aOhW61H
         0WT+f8QcJHUr0Ij7FgsU0RdiHUN4SR42eTC/ctREZCHReyBDXjBmx/QynV5FIMZMU6
         07y/cgddYfg6xK7vFixVtarsgy3fa1Vmybsv7/VZAvhrbsawoR/64w13QsEiN6BG0n
         hGwRyKVJFUECQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 43A2360A49;
        Tue, 16 Nov 2021 13:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/3] bpftool: update documentation and fix checks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163706760927.10284.10367416441736723127.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Nov 2021 13:00:09 +0000
References: <20211115225844.33943-1-quentin@isovalent.com>
In-Reply-To: <20211115225844.33943-1-quentin@isovalent.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Mon, 15 Nov 2021 22:58:41 +0000 you wrote:
> This set updates the list of options for bpftool commands, as displayed in
> the summary of the man pages. It also updates the script that checks those
> option lists, to make it more robust, and more reusable if the layout of
> bpftool's directory changed.
> 
> Checkpatch complained about the missing SPDX tag when I added a new file
> under bpftool/Documentation; I fixed it by adding the tag, and while at it,
> I also added the tags to all RST files for bpftool's documentation (see
> first patch of this set).
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/3] bpftool: Add SPDX tags to RST documentation files
    https://git.kernel.org/bpf/bpf-next/c/4344842836e9
  - [bpf-next,2/3] bpftool: Update doc (use susbtitutions) and test_bpftool_synctypes.py
    https://git.kernel.org/bpf/bpf-next/c/b62318152040
  - [bpf-next,3/3] selftests/bpf: Configure dir paths via env in test_bpftool_synctypes.py
    https://git.kernel.org/bpf/bpf-next/c/e12cd158c8a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


