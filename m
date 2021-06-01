Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB54396D01
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 07:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhFAFvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 01:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232915AbhFAFvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 01:51:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9F246613AB;
        Tue,  1 Jun 2021 05:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622526603;
        bh=VCzH3BoPB2RIkvJY/BJI5kw9URxgsqORyWnXV23YrXo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pNOP2ymdMgMzC+vdpEpQ0qwOcs2aKyGRV2rch8h7m3jVexxV1WcObbdP9J9YUWjCj
         1RRhh/bv33KrCYLsTQMIShCZZXu19onh2uozrNj5nXYlt2xSgU2JEqLV/+5GTTCbFs
         AOD0OyCLC+C36Bi0NbVM4AtlukMLKKy5PDp4Ig/qI/jUBjHUCQquf8rTTtUFKaWWQC
         LzCm28NiZTHmJS/LovD4zjpsLQb+Vg/wBIqcADATkdHRRqC3XE+goF66Ap58sBpu/6
         voBB6rgvtib/Onzb2WMsCh6HvUO+y2vM4Ka3S9rgrSHH2AOtONxM8e74JOCnkMqIBL
         yD9gDaCWoRl0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 94BB7609D9;
        Tue,  1 Jun 2021 05:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH] nfc: fix NULL ptr dereference in llcp_sock_getname()
 after failed connect
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162252660360.4642.10005433752607898965.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 05:50:03 +0000
References: <20210531072138.5219-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210531072138.5219-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com,
        sameo@linux.intel.com, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thadeu.cascardo@canonical.com, stable@vger.kernel.org,
        syzbot+80fb126e7f7d8b1a5914@syzkaller.appspotmail.com,
        butterflyhuangxx@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 31 May 2021 09:21:38 +0200 you wrote:
> It's possible to trigger NULL pointer dereference by local unprivileged
> user, when calling getsockname() after failed bind() (e.g. the bind
> fails because LLCP_SAP_MAX used as SAP):
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   CPU: 1 PID: 426 Comm: llcp_sock_getna Not tainted 5.13.0-rc2-next-20210521+ #9
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1 04/01/2014
>   Call Trace:
>    llcp_sock_getname+0xb1/0xe0
>    __sys_getpeername+0x95/0xc0
>    ? lockdep_hardirqs_on_prepare+0xd5/0x180
>    ? syscall_enter_from_user_mode+0x1c/0x40
>    __x64_sys_getpeername+0x11/0x20
>    do_syscall_64+0x36/0x70
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> [...]

Here is the summary with links:
  - [RESEND] nfc: fix NULL ptr dereference in llcp_sock_getname() after failed connect
    https://git.kernel.org/netdev/net/c/4ac06a1e013c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


