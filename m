Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9783CBC82
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 21:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhGPTaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 15:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232172AbhGPTaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 15:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 68E03613FE;
        Fri, 16 Jul 2021 19:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626463644;
        bh=6NgBJ/YZayNdXv9tJZpoBnBfM1/BhfDN/v9X3Ga7sbs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rFlA4wEYi6M69Yl+AP2GgCDkDmQa8rqx6hxz5umbqNynP6KNi6lBI+ZkfaFStUO0N
         Pb5l1SlebNueFH1jc7JVqFfGPyiG+LKVDgYRsnsb8It65NsyCWDHm1loT9wBGWQWj7
         XHCgf1jymvLtgvSkzulvr6uVqvXr5mLTLVFSETFsSn3k9oA+68mwR1MpAqfqBvMBtW
         YKZxqP++7WJ3OBavQOKsm9iB1MTRhkI1yegLjIA/68deEMcnP/egAGT9DJbz83zvhe
         zosVpXLN3saGPa1PvxBnzEZKCYsKARy5laAkGDNyJM8EA0FqA61YAmohtE/85RbVsT
         sGqSvP8uUbInQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5B3B5609DA;
        Fri, 16 Jul 2021 19:27:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next] bpf: add ambient BPF runtime context stored in
 current
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162646364436.14878.13764135374807267506.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Jul 2021 19:27:24 +0000
References: <20210712230615.3525979-1-andrii@kernel.org>
In-Reply-To: <20210712230615.3525979-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, yhs@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon, 12 Jul 2021 16:06:15 -0700 you wrote:
> b910eaaaa4b8 ("bpf: Fix NULL pointer dereference in bpf_get_local_storage()
> helper") fixed the problem with cgroup-local storage use in BPF by
> pre-allocating per-CPU array of 8 cgroup storage pointers to accommodate
> possible BPF program preemptions and nested executions.
> 
> While this seems to work good in practice, it introduces new and unnecessary
> failure mode in which not all BPF programs might be executed if we fail to
> find an unused slot for cgroup storage, however unlikely it is. It might also
> not be so unlikely when/if we allow sleepable cgroup BPF programs in the
> future.
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next] bpf: add ambient BPF runtime context stored in current
    https://git.kernel.org/bpf/bpf-next/c/c7603cfa04e7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


