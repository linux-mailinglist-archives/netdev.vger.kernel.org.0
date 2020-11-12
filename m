Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0762E2B0B2B
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 18:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgKLRUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 12:20:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgKLRUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 12:20:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605201604;
        bh=Ii0gRUdrh7C37ds0H5EJMZESbBOnTU0/C3hu5J3WAbk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s+sinpdOle5545XEbpbwkPXCgreLguwMciqboJ7SQFEtglGBAQeok4I051XiNqnOi
         kcPRF3jmdOgRzMZEiMB1mUA0+inSJry/G7VGec23hKJ1pdD6H8DZ7J2p2wkVf/T0DS
         zbTeUWMQsi+vgMC6GJVckH5SW2Sh/uruKz2YwJsY=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] selftests/bpf: fix unused attribute usage in
 subprogs_unused test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160520160485.17608.9139256574933427173.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Nov 2020 17:20:04 +0000
References: <20201111231215.1779147-1-andrii@kernel.org>
In-Reply-To: <20201111231215.1779147-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed, 11 Nov 2020 15:12:15 -0800 you wrote:
> Correct attribute name is "unused". maybe_unused is a C++17 addition.
> This patch fixes compilation warning during selftests compilation.
> 
> Fixes: 197afc631413 ("libbpf: Don't attempt to load unused subprog as an entry-point BPF program")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/testing/selftests/bpf/progs/test_subprogs_unused.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [bpf] selftests/bpf: fix unused attribute usage in subprogs_unused test
    https://git.kernel.org/bpf/bpf/c/fd63729cc0a6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


