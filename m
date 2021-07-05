Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792EB3BC3BA
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 23:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhGEVlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 17:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230074AbhGEVln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 17:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9110A61988;
        Mon,  5 Jul 2021 21:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625521145;
        bh=1mb6JbXNyZgCObHmxZmdRO5rnBjKtLLrG10anGcwyMk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m37KOfuPFl43oXbrIOLjuZ4R5OWHGllkbu2PVq6bK5Vv9w/QYzqOxigliaZbWiTUj
         KHhnBPUcQKxYfiF1nWDxz4FsMoOBlmVMpjDHELjY5M1DqVlRBxBUtR2uZO+R/viK0i
         UGP/16b5xX7SHokSH3gsA8Lv9BET9UrQw4JzqaUpmrRUUFYYRbLFMWa4i2FsWIsc+m
         hTze3miVz6xgnSavFYExCzqXU4l+odVigu9rIdiSKDBaiAVoXPbRUUc4+SNek/X0FC
         wdt1FDhUOT4fA9TTR14HkJYMvY2at91xR6u2bAKtr22BDfe1yYBOLlo9BDlgLuJb07
         8wUS7UgS2zNmw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 846E860A4D;
        Mon,  5 Jul 2021 21:39:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] samples/bpf: Fix xdpsock with '-M' parameter missing
 unload process
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162552114553.18127.14437344539582058429.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Jul 2021 21:39:05 +0000
References: <20210628091815.2373487-1-wanghai38@huawei.com>
In-Reply-To: <20210628091815.2373487-1-wanghai38@huawei.com>
To:     wanghai (M) <wanghai38@huawei.com>
Cc:     davem@davemloft.net, bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Mon, 28 Jun 2021 17:18:15 +0800 you wrote:
> Execute the following command and exit, then execute it again, the
> following error will be reported.
> 
> $ sudo ./samples/bpf/xdpsock -i ens4f2 -M
> ^C
> $ sudo ./samples/bpf/xdpsock -i ens4f2 -M
> libbpf: elf: skipping unrecognized data section(16) .eh_frame
> libbpf: elf: skipping relo section(17) .rel.eh_frame for section(16) .eh_frame
> libbpf: Kernel error message: XDP program already attached
> ERROR: link set xdp fd failed
> 
> [...]

Here is the summary with links:
  - [bpf] samples/bpf: Fix xdpsock with '-M' parameter missing unload process
    https://git.kernel.org/bpf/bpf/c/2620e92ae6ed

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


