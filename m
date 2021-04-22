Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2D336889B
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 23:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239666AbhDVVas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 17:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237018AbhDVVap (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 17:30:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1B6DA61428;
        Thu, 22 Apr 2021 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619127010;
        bh=zUXfG7MLroZul7HgNtg5v28nBZ640QD3mRM1807IpZQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uWqQo9RWFf71CGV7wyAXId8HBpuAk15TN1axEeHrddqiVh+MUvz9iDTBIxH0XLFVw
         ngExMS95QCajOilk2FpHi5SbtkXuPhsjy21lK8DXYQGxHibO3DgqSyUcy3/RwUIBv3
         JkWxk0ipNnPq4Xxn5ZIJ5Yw8i6eGZkmBv0iGxPOhs7Yun2xovy1GJ+KSAV72fQST1x
         8ojJn/F6Eju6ZKeBAgBv0FoMRzJJwpUCBCdFgpH61KPGiSFfpkkQR9e9DwBASyxaPf
         +h6NBVu0qC2QwH5N8nCf62bIT2gFjY62BDF4d3ZSOqBICh6HxnQqDSbcWeOwffaYoV
         b+yMUemIXKGyA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0F589609AC;
        Thu, 22 Apr 2021 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3] bpf: Fix some invalid links in bpf_devel_QA.rst
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161912701005.19496.9540083866357841252.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Apr 2021 21:30:10 +0000
References: <1619062560-30483-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1619062560-30483-1-git-send-email-yangtiezhu@loongson.cn>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, brouer@redhat.com,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        lixuefeng@loongson.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 22 Apr 2021 11:36:00 +0800 you wrote:
> There exist some errors "404 Not Found" when I click the link
> of "MAINTAINERS" [1], "samples/bpf/" [2] and "selftests" [3]
> in the documentation "HOWTO interact with BPF subsystem" [4].
> 
> As Alexei Starovoitov suggested, just remove "MAINTAINERS" and
> "samples/bpf/" links and use correct link of "selftests".
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3] bpf: Fix some invalid links in bpf_devel_QA.rst
    https://git.kernel.org/bpf/bpf-next/c/64ef3ddfa95e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


