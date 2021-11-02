Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E35A44250D
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhKBBWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhKBBWk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 21:22:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C7140610A3;
        Tue,  2 Nov 2021 01:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635816006;
        bh=e+lUJFOqXBvJnh/5xiUx72HvkVO9Jt+hp22ZJUEkTBs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HCEU8QYbtnSLV+y7brc/+F7bx6UZ4fwCtOmKpkDPpJP6oyoqurqeljHnoq2E74vyU
         ZiHbTNfRKnXVmOPucAcVtDQU8D0EP3/E5ZoDcpftJxqtwy4tgdrwXz9RFOIoKlU0H5
         kp0WoTB18sadaX/EZzmB9UBbcVnm4mO8BsWaR1cMDixwLjP+1M1K+Hg/Z2bHHJcZhB
         RtGvk0trKrOM+2q5r6SHZ5jumgz/76Rv3kmVSMHHv8wL1FUN9CUQKKCHv6TkDsoL8J
         Hg9DlSHkajKzlwHgXt9eYMjmcNUIQbSF4iFcpXUp0ENW5ijXpGoNH+bEdCyWubd8bp
         G8AHtgEYafaVQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BA1EE609B9;
        Tue,  2 Nov 2021 01:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] libbpf: deprecate AF_XDP support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163581600675.29215.12439947755445948936.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Nov 2021 01:20:06 +0000
References: <20211029090111.4733-1-magnus.karlsson@gmail.com>
In-Reply-To: <20211029090111.4733-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Fri, 29 Oct 2021 11:01:11 +0200 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Deprecate AF_XDP support in libbpf ([0]). This has been moved to
> libxdp as it is a better fit for that library. The AF_XDP support only
> uses the public libbpf functions and can therefore just use libbpf as
> a library from libxdp. The libxdp APIs are exactly the same so it
> should just be linking with libxdp instead of libbpf for the AF_XDP
> functionality. If not, please submit a bug report. Linking with both
> libraries is supported but make sure you link in the correct order so
> that the new functions in libxdp are used instead of the deprecated
> ones in libbpf.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] libbpf: deprecate AF_XDP support
    https://git.kernel.org/bpf/bpf-next/c/0b170456e0dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


