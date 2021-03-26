Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B871A34AD00
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 18:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhCZRAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 13:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230202AbhCZRAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 13:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9E21A61A28;
        Fri, 26 Mar 2021 17:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616778009;
        bh=BC6xlKkZRp3xCjGVPtCYhAmd9tLNCaYcfVyP0X8ymGA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FvRacEmcoThK6vTHIQ0a7ugE/HimheoSNNNeXdnWBZQzJFkAhKmENi7Ki4zmzOyoV
         XjEIrKd2NW01Mpv577Aq+eeZkCu3GpqZqibPGuoun5avfiI2v5gjrm6WJiDX9ivH48
         lJEAs+p90t4ewFdFOups5Nma4yZni0lZ1F+m7RgZUAFUfyl+yhQGVFx7v1/yLLjurP
         9M3mjmTlR2f4G90rOqt1sba5R2arv7t9xXQijEEzZNg7His+a7ony3ff79BDA9qEWr
         gF3etFJXMSEp7samNLyWjtFMHZpD7hPbqlzbtZPQVdjoAzO3flmje+Tvp5G9WRvfES
         mQtkSgXS+Fnjg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 77E5F6096E;
        Fri, 26 Mar 2021 17:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v3 1/2] bpf: enforce that struct_ops programs be GPL-only
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161677800948.29837.17125226736651176276.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 17:00:09 +0000
References: <20210326100314.121853-1-toke@redhat.com>
In-Reply-To: <20210326100314.121853-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        davem@davemloft.net, brouer@redhat.com, aarcange@redhat.com,
        williams@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (refs/heads/master):

On Fri, 26 Mar 2021 11:03:13 +0100 you wrote:
> With the introduction of the struct_ops program type, it became possible to
> implement kernel functionality in BPF, making it viable to use BPF in place
> of a regular kernel module for these particular operations.
> 
> Thus far, the only user of this mechanism is for implementing TCP
> congestion control algorithms. These are clearly marked as GPL-only when
> implemented as modules (as seen by the use of EXPORT_SYMBOL_GPL for
> tcp_register_congestion_control()), so it seems like an oversight that this
> was not carried over to BPF implementations. Since this is the only user
> of the struct_ops mechanism, just enforcing GPL-only for the struct_ops
> program type seems like the simplest way to fix this.
> 
> [...]

Here is the summary with links:
  - [bpf,v3,1/2] bpf: enforce that struct_ops programs be GPL-only
    https://git.kernel.org/bpf/bpf/c/12aa8a9467b3
  - [bpf,v3,2/2] bpf/selftests: test that kernel rejects a TCP CC with an invalid license
    https://git.kernel.org/bpf/bpf/c/d8e8052e42d0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


