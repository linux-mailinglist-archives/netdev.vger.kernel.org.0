Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FC5322603
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 07:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhBWGl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 01:41:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231190AbhBWGlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 01:41:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A793A64DF2;
        Tue, 23 Feb 2021 06:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614062474;
        bh=v2kx1lRGhrsQ8pJzSazjxayM9GcvEqdJeq+eVkOxR7Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j5Fh7U9CX9xupyn7BbiUoToJmcBzoY5ZMRDueANJzgnfFaNZwfE/9c/Cw7vqgMMyf
         UsOSBpgVI7jf5XNjU4kLJSDZ6FPGVWKLwve97gtBcjl5UBdZw7y6mMzDldLGhA6XYL
         SPkiODqsj/u0u0vqWyXr3OVXWjqebRz8z48SjA7ALqadaJKB0An3Rbtir72otHqLEa
         /g5eNHa+TzxD2ttPM+wZM5Jccafi5gSdH/Nd84fkYhTw1lFSEeY0m0rn6MO6h35yFZ
         oWr+UjBbEvVpZALB/1cDi6qITkOrfb6Q0R0IBh6Unw9NMCZ9m/QZhktAv5/TMJrwGI
         hyhiEqasqV3eg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9657560973;
        Tue, 23 Feb 2021 06:41:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 bpf-next] Add CONFIG_DEBUG_INFO_BTF and
 CONFIG_DEBUG_INFO_BTF_MODULES check to bpftool feature command
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161406247460.885.4219717634423905912.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Feb 2021 06:41:14 +0000
References: <20210222195846.155483-1-grantseltzer@gmail.com>
In-Reply-To: <20210222195846.155483-1-grantseltzer@gmail.com>
To:     Grant Seltzer Richman <grantseltzer@gmail.com>
Cc:     andrii@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, irogers@google.com, yhs@fb.com,
        tklauser@distanz.ch, netdev@vger.kernel.org,
        mrostecki@opensuse.org, ast@kernel.org, quentin@isovalent.com,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon, 22 Feb 2021 19:58:46 +0000 you wrote:
> This adds both the CONFIG_DEBUG_INFO_BTF and CONFIG_DEBUG_INFO_BTF_MODULES
> kernel compile option to output of the bpftool feature command.
> This is relevant for developers that want to account for data structure
> definition differences between kernels.
> 
> Signed-off-by: Grant Seltzer <grantseltzer@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v4,bpf-next] Add CONFIG_DEBUG_INFO_BTF and CONFIG_DEBUG_INFO_BTF_MODULES check to bpftool feature command
    https://git.kernel.org/bpf/bpf-next/c/6b12bb20aeb3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


