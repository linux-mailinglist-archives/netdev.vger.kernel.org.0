Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F19306B1C
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 03:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhA1Ca4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 21:30:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhA1Cav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 21:30:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 266A264DCC;
        Thu, 28 Jan 2021 02:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611801011;
        bh=XdC0SwTH8F4VbZEujw8fnkZe7hmFy1gya8+FucKl9HI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bv9lhrGrSAdE5YIzsVzAr/VVmhgZMK5+ho+45IpcZ8p4BFQ+h6PtJCL85JnYSQEZU
         4Bn6Upg3sqth2Nug8G1OkujTqOo0fQJzB0Yvuy33UUoUQLyrnrOb4PHNa38+7+Mtf2
         W4mSgFcwDuAjfuReH4kLCcFhPFEhAw7x0tVMnMvLyq/Ps9/yQRYdBcExOQNUiS95ns
         AO00eb0WrIgETyKVhTnJPikI2OxCPAkjQMSjemwzP2NhzEmV2x/nvrEdJwPcPRVR4W
         Esn68hGTzENR9kUtFmGXNdphkAbXcnrYnxu3WR0QbsIqBftcOlu54DO1j7qF/ZGf++
         srOnxscSiRbKQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 12AF665307;
        Thu, 28 Jan 2021 02:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v5 1/2] bpf: allow rewriting to ports under
 ip_unprivileged_port_start
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161180101107.20337.1864637949509200235.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 02:30:11 +0000
References: <20210127193140.3170382-1-sdf@google.com>
In-Reply-To: <20210127193140.3170382-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, rdna@fb.com, kafai@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 27 Jan 2021 11:31:39 -0800 you wrote:
> At the moment, BPF_CGROUP_INET{4,6}_BIND hooks can rewrite user_port
> to the privileged ones (< ip_unprivileged_port_start), but it will
> be rejected later on in the __inet_bind or __inet6_bind.
> 
> Let's add another return value to indicate that CAP_NET_BIND_SERVICE
> check should be ignored. Use the same idea as we currently use
> in cgroup/egress where bit #1 indicates CN. Instead, for
> cgroup/bind{4,6}, bit #1 indicates that CAP_NET_BIND_SERVICE should
> be bypassed.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v5,1/2] bpf: allow rewriting to ports under ip_unprivileged_port_start
    https://git.kernel.org/bpf/bpf-next/c/772412176fb9
  - [bpf-next,v5,2/2] selftests/bpf: verify that rebinding to port < 1024 from BPF works
    https://git.kernel.org/bpf/bpf-next/c/8259fdeb3032

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


