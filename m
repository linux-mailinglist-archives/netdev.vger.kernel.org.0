Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062054072F3
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 23:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhIJVbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 17:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhIJVbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 17:31:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9BAD46120E;
        Fri, 10 Sep 2021 21:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631309406;
        bh=he/eiPzoHf/e5ZbbrGfHTOTtJt0Bx2r9OPNv1xvzWqw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PD1JFa81AugRhfttwXA4U5TyYCdfhHmwiTY8Zoe3Rfnxzd4WBS+yYgb7lrvbQqTuW
         cgVGkcQTKqqVo0U07hTvdPmItJ/zh3GJIPKoSbAaG7m3DnlHZEf4Bj44DmEppWT4Jn
         B57ncC2KSEQx33iYZ6pQUGNjC5camFPXEY7Lqsc0/yZoG2kJ0uDoEcpBWaAZ7HJm/Y
         crdIXqcZmvdlsZBlANtgC4qm5Jce9oSO9bkpKlPCBdGZU5sK04jRvZC+wK4VjVqvY1
         SK3ZGBO5kCWGQogxDQsKy0ZxnzbNgeQdDKVPuLhig6E1aCxNa2Xu5+ohD3rOMlnxH8
         jexoNy8R6SO4g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8E918609FF;
        Fri, 10 Sep 2021 21:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3 0/2] add hwtstamp to __sk_buff
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163130940657.19089.1279931064701174947.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Sep 2021 21:30:06 +0000
References: <20210909220409.8804-1-vfedorenko@novek.ru>
In-Reply-To: <20210909220409.8804-1-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     kafai@fb.com, andrii.nakryiko@gmail.com, daniel@iogearbox.net,
        ast@kernel.org, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Fri, 10 Sep 2021 01:04:07 +0300 you wrote:
> This patch set adds hardware timestamps to __sk_buff. The first patch
> implements feature, the second one adds a selftest.
> 
> v2 -> v3:
> * rebase on bpf-next
> 
> v1 -> v2:
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/2] bpf: add hardware timestamp field to __sk_buff
    https://git.kernel.org/bpf/bpf-next/c/f64c4acea51f
  - [bpf-next,v3,2/2] selftests/bpf: test new __sk_buff field hwtstamp
    https://git.kernel.org/bpf/bpf-next/c/3384c7c7641b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


