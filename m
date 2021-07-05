Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBF13BC34C
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 22:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhGEUCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 16:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhGEUCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 16:02:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ACF8D61976;
        Mon,  5 Jul 2021 20:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625515203;
        bh=wpo+0pr3faebsE/lSwM98bM79NzWfL/TYYrh9kIJCo0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AyX3WKq6RBkd9KV6+0O7ogxzvJVstkRiqwmCwjfIBxnXGQNjHyfvFFuLBnjoSCsqF
         EI9vgPEdHDmBTn7vrrDq6xBImZ1uvE21yrooRDa1f6oWOI9Axs3l8FoWHTRZqf6V48
         pMZo6u/zkIMKfk7navrl0s5WnkTmmkgRfYlLlzc6WxxUKKOKvrvFmEqjlVMVQJ0VGM
         psPxP4FQZ1pRzoSXkC4iaFUs7E8JiP/ZQgElsxz+fyD3DqnVATOWGzIAguPWXNUU+s
         utwU61q5PoW2YUXntHQ1yqgXkwlz+dT654fUzfe2uz/hOU83DXWtVYvISi3maCWrrJ
         AKNn+glPBwCZQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 98FA860A6C;
        Mon,  5 Jul 2021 20:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] samples/bpf: add -fno-asynchronous-unwind-tables to
 BPF Clang invocation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162551520362.31121.10016943232621757251.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Jul 2021 20:00:03 +0000
References: <20210705103841.180260-1-toke@redhat.com>
In-Reply-To: <20210705103841.180260-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Mon,  5 Jul 2021 12:38:41 +0200 you wrote:
> The samples/bpf Makefile currently compiles BPF files in a way that will
> produce an .eh_frame section, which will in turn confuse libbpf and produce
> errors when loading BPF programs, like:
> 
> libbpf: elf: skipping unrecognized data section(32) .eh_frame
> libbpf: elf: skipping relo section(33) .rel.eh_frame for section(32) .eh_frame
> 
> [...]

Here is the summary with links:
  - [bpf-next] samples/bpf: add -fno-asynchronous-unwind-tables to BPF Clang invocation
    https://git.kernel.org/bpf/bpf/c/5a0ae9872d5c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


