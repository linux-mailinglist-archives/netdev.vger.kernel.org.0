Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E8E2851E8
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 20:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgJFSuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 14:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgJFSuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 14:50:05 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602010204;
        bh=0XKbMbZ5MvyR9C7xcDSUmo/y8dt1xwmaTrh5izgfWKE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hk5zx+eBXzb97WvjMA+7goetnN+E6uepIQx/UNx4ZMlCXv1kHumVwruu7KtF1zhUk
         s3VvtNyHgrwAz88LhvAcslyomwdEj4uksuVwZAJd3uGu4f70ymgtCd1Ms88y18fMDm
         05fWb8pP8TvG4H35DZwVmvBbT1UKME0TZlq6aru4=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 1/2] samples/bpf: change Makefile to cope with
 latest llvm
From:   patchwork-bot+bpf@kernel.org
Message-Id: <160201020454.15578.6708342423327646865.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Oct 2020 18:50:04 +0000
References: <20201006043427.1891742-1-yhs@fb.com>
In-Reply-To: <20201006043427.1891742-1-yhs@fb.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kernel-team@fb.com, andriin@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Mon, 5 Oct 2020 21:34:26 -0700 you wrote:
> With latest llvm trunk, bpf programs under samples/bpf
> directory, if using CORE, may experience the following
> errors:
> 
> LLVM ERROR: Cannot select: intrinsic %llvm.preserve.struct.access.index
> PLEASE submit a bug report to https://bugs.llvm.org/ and include the crash backtrace.
> Stack dump:
> 0.      Program arguments: llc -march=bpf -filetype=obj -o samples/bpf/test_probe_write_user_kern.o
> 1.      Running pass 'Function Pass Manager' on module '<stdin>'.
> 2.      Running pass 'BPF DAG->DAG Pattern Instruction Selection' on function '@bpf_prog1'
>  #0 0x000000000183c26c llvm::sys::PrintStackTrace(llvm::raw_ostream&, int)
>     (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x183c26c)
> ...
>  #7 0x00000000017c375e (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x17c375e)
>  #8 0x00000000016a75c5 llvm::SelectionDAGISel::CannotYetSelect(llvm::SDNode*)
>     (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x16a75c5)
>  #9 0x00000000016ab4f8 llvm::SelectionDAGISel::SelectCodeCommon(llvm::SDNode*, unsigned char const*,
>     unsigned int) (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x16ab4f8)
> ...
> Aborted (core dumped) | llc -march=bpf -filetype=obj -o samples/bpf/test_probe_write_user_kern.o
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/2] samples/bpf: change Makefile to cope with latest llvm
    https://git.kernel.org/bpf/bpf-next/c/9618bde489b2
  - [bpf-next,v2,2/2] samples/bpf: fix a compilation error with fallthrough marking
    https://git.kernel.org/bpf/bpf-next/c/544d6adf3c3d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


