Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7EC93CF759
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbhGTJU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 05:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236289AbhGTJT2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 05:19:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 790BF6113B;
        Tue, 20 Jul 2021 10:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626775204;
        bh=VrAxaKyoDeNCFwDxgMDlLIkPRC5mcML/g+qep9mFWWg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MlvgUVzhsIf2LwUnnQ87O5uaCJqkXoMp7mISXdBvCFLenNhZZgdr3ZUGB9xrph5db
         8NJc+LfJ9zkfR9a1jMBC1lG04MioPdSarDMbKu65saVxt0ZyD5lpcvzCoJnNsIjo1O
         So6nFuXx/V2QjbGnyISKGRSEyIJcEhhdgEQC+wKZQUEEs7XDv1JFU57oBs9An2Lq9/
         ji+p8Op166oaKtwGftD5TbC5Kuz1XmR9tjbNgSCH4kY8mF7/JM+IWztTNjuMstD8EB
         XeIRlsn8OsWhHr0zidqtZj4G214SGXi8nf3sTwmPVtGYKvI+UGZZGAQb8I3OlW4G17
         Y8c8Z1cI/9bGg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6BAB260C2A;
        Tue, 20 Jul 2021 10:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] netlink: Deal with ESRCH error in nlmsg_notify()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162677520443.14646.13791240683070988286.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 10:00:04 +0000
References: <20210719051816.11762-1-yajun.deng@linux.dev>
In-Reply-To: <20210719051816.11762-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Jul 2021 13:18:16 +0800 you wrote:
> Yonghong Song report:
> The bpf selftest tc_bpf failed with latest bpf-next.
> The following is the command to run and the result:
> $ ./test_progs -n 132
> [   40.947571] bpf_testmod: loading out-of-tree module taints kernel.
> test_tc_bpf:PASS:test_tc_bpf__open_and_load 0 nsec
> test_tc_bpf:PASS:bpf_tc_hook_create(BPF_TC_INGRESS) 0 nsec
> test_tc_bpf:PASS:bpf_tc_hook_create invalid hook.attach_point 0 nsec
> test_tc_bpf_basic:PASS:bpf_obj_get_info_by_fd 0 nsec
> test_tc_bpf_basic:PASS:bpf_tc_attach 0 nsec
> test_tc_bpf_basic:PASS:handle set 0 nsec
> test_tc_bpf_basic:PASS:priority set 0 nsec
> test_tc_bpf_basic:PASS:prog_id set 0 nsec
> test_tc_bpf_basic:PASS:bpf_tc_attach replace mode 0 nsec
> test_tc_bpf_basic:PASS:bpf_tc_query 0 nsec
> test_tc_bpf_basic:PASS:handle set 0 nsec
> test_tc_bpf_basic:PASS:priority set 0 nsec
> test_tc_bpf_basic:PASS:prog_id set 0 nsec
> libbpf: Kernel error message: Failed to send filter delete notification
> test_tc_bpf_basic:FAIL:bpf_tc_detach unexpected error: -3 (errno 3)
> test_tc_bpf:FAIL:test_tc_internal ingress unexpected error: -3 (errno 3)
> 
> [...]

Here is the summary with links:
  - netlink: Deal with ESRCH error in nlmsg_notify()
    https://git.kernel.org/netdev/net-next/c/fef773fc8110

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


