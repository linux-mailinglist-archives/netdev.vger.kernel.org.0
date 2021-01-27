Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A4B306640
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 22:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbhA0VdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 16:33:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232435AbhA0VbJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 16:31:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D8A9E64DCC;
        Wed, 27 Jan 2021 21:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611783009;
        bh=0q5sDg8bmZxPtZGnEYMQ4V1nzFuO4kZO0OjqrA+hhO4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W2N6yaBZO08eMYsdzYpMBLNLviq3hASShAYAkRWyjBhsBSviQdUuWezRfjf2sSXjs
         kk2EehFUR0qkgM3rxpQrbdozg0VaU7DWUhNXiZcVngWmOAl+WXs7Wy6rVZ+AW8R/Lo
         3yIQ8hBedtXS8sebypWJw1jI0zgD5C5k83uaGw9dhf7O1d/x/XyYLmdy8fkY2Bp0v5
         5lFJv+291pT+Ew6Qbo+NWuPiKuABrzcZLa7f1VO0isVPXLYbWCLIhm/joTy+6Belgh
         ltuA6lsh1zj58lu0ZslZvjRGwNB87uwywKQr2zIxN5awyoojSSVLDdTGAJG9LBYWpJ
         K1Q6QQHJGmCYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C727C613A8;
        Wed, 27 Jan 2021 21:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: change 'BPF_ADD' to 'BPF_AND' in
 print_bpf_insn()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161178300980.5444.2843489458453917484.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jan 2021 21:30:09 +0000
References: <20210127022507.23674-1-dong.menglong@zte.com.cn>
In-Reply-To: <20210127022507.23674-1-dong.menglong@zte.com.cn>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jackmanb@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, dong.menglong@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 26 Jan 2021 18:25:07 -0800 you wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> This 'BPF_ADD' is duplicated, and I belive it should be 'BPF_AND'.
> 
> Fixes: 981f94c3e921 ("bpf: Add bitwise atomic instructions")
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: change 'BPF_ADD' to 'BPF_AND' in print_bpf_insn()
    https://git.kernel.org/bpf/bpf-next/c/60e578e82b7d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


