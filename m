Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327C942726F
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 22:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242595AbhJHUmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 16:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242456AbhJHUmD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 16:42:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 07A9261100;
        Fri,  8 Oct 2021 20:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633725608;
        bh=i93zlvLGbPdIN605psSBmdgSHVoOYonlTX5HOGnse8c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BVQGmYG4yECp6RJkhSxJrNWfqrnblGNGXpp3W8xuR70EyAPc89FrqvNPpNwQ7uOXL
         CsQYEtaMtCC+9M61iKX9WrZddah0PU3z/Ki6Vc9XT9EMk49Jjog4/H1pu6fcP+pXjw
         fTKHh94pKog2HV4S1J1vsQTNc+lwt7Eb3k6Ekh9vAxTr1MI6p33Xd/6hob7bSRfn1a
         0jgoEjK1ZhUw/WX0DT66f43tC5lMu56BE/cB12bETCbdYA0pkh1AjL0/teR9XQoZqx
         NRteVGcA1IfDnFzdPZ7X9qWnwIzbClDzEDZ7PZcut7YAu0D2EId89iUrNPgF3DzPc7
         yM6F3rHjKaQzQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E87E360A38;
        Fri,  8 Oct 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v5 0/3] add support for writable bare tracepoint
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163372560794.10596.8697420048010685781.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 20:40:07 +0000
References: <20211004094857.30868-1-hotforest@gmail.com>
In-Reply-To: <20211004094857.30868-1-hotforest@gmail.com>
To:     Hou Tao <hotforest@gmail.com>
Cc:     ast@kernel.org, rostedt@goodmis.org, daniel@iogearbox.net,
        andrii@kernel.org, yhs@fb.com, kafai@fb.com, mingo@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, houtao1@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon,  4 Oct 2021 17:48:54 +0800 you wrote:
> From: Hou Tao <houtao1@huawei.com>
> 
> Hi,
> 
> The patchset series supports writable context for bare tracepoint.
> 
> The main idea comes from patchset "writable contexts for bpf raw
> tracepoints" [1], but it only supports normal tracepoint with
> associated trace event under tracefs. Now we have one use case
> in which we add bare tracepoint in VFS layer, and update
> file::f_mode for specific files. The reason using bare tracepoint
> is that it doesn't form a ABI and we can change it freely. So
> add support for it in BPF.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v5,1/3] bpf: support writable context for bare tracepoint
    https://git.kernel.org/bpf/bpf-next/c/65223741ae1b
  - [bpf-next,v5,2/3] libbpf: support detecting and attaching of writable tracepoint program
    https://git.kernel.org/bpf/bpf-next/c/ccaf12d6215a
  - [bpf-next,v5,3/3] bpf/selftests: add test for writable bare tracepoint
    https://git.kernel.org/bpf/bpf-next/c/fa7f17d066bd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


