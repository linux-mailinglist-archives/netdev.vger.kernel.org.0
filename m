Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E1B3DEDDE
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235857AbhHCMaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235709AbhHCMaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 08:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1E79960F92;
        Tue,  3 Aug 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627993808;
        bh=zZBDwl4mF8S7HyR8EoVvXQRAZbgyktGfLjOCnGxBHIg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=swul862ETScHPw/dmtVXHDSjPHI0TRlnjEsryDXg9odYbugyNjMOAhPCzAdw0cTW3
         HvgFXo3VRQ3VM+6ymcLDPN3MPTmPhl64dVcmxpYLzUILAH/otgT9cxSbCmoOv3mj4/
         3epIkcTUUnwoA9c9FTY/+Wg0WT3dm1AOaRLANnt9Pgdv+ek5MOqbSnLxgNoEvJBGoE
         W9C1IlffMn60Wr4heLpj+7gIsNEIXMEFf9DXs3GOBropX/HBarvgKkA9EhI45O18Qc
         Zx+CzXxgP0Wz7NLZhY9vELz5nGRAwzBO2EwpIPQYYOo4PobJdlOQnAn+eaqaMwHx/d
         jIBmyyTJcqNlw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1368C60A49;
        Tue,  3 Aug 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 00/14] [net-next] drivers/net/Space.c cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162799380807.17755.14586598490801190741.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 12:30:08 +0000
References: <20210803114051.2112986-1-arnd@kernel.org>
In-Reply-To: <20210803114051.2112986-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, arnd@arndb.de, davem@davemloft.net,
        macro@orcam.me.uk, ast@kernel.org, andrew@lunn.ch, andriin@fb.com,
        bgolaszewski@baylibre.com, christophe.jaillet@wanadoo.fr,
        opendmb@gmail.com, edumazet@google.com, fthain@telegraphics.com.au,
        f.fainelli@gmail.com, geert@linux-m68k.org, kuba@kernel.org,
        jeyu@kernel.org, schmitzmic@gmail.com,
        paul.gortmaker@windriver.com, sammy@sammy.net,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  3 Aug 2021 13:40:37 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> I discovered that there are still a couple of drivers that rely on
> beiong statically initialized from drivers/net/Space.c the way
> we did in the last century. As it turns out, there are a couple
> of simplifications that can be made here, as well as some minor
> bugfixes.
> 
> [...]

Here is the summary with links:
  - [v2,01/14,net-next] bcmgenet: remove call to netdev_boot_setup_check
    https://git.kernel.org/netdev/net-next/c/0852aeb9c350
  - [v2,02/14,net-next] natsemi: sonic: stop calling netdev_boot_setup_check
    https://git.kernel.org/netdev/net-next/c/19a11bf06c57
  - [v2,03/14,net-next] appletalk: ltpc: remove static probing
    https://git.kernel.org/netdev/net-next/c/81dd3ee5962d
  - [v2,04/14,net-next] 3c509: stop calling netdev_boot_setup_check
    https://git.kernel.org/netdev/net-next/c/8bbdf1bdf22c
  - [v2,05/14,net-next] cs89x0: rework driver configuration
    https://git.kernel.org/netdev/net-next/c/47fd22f2b847
  - [v2,06/14,net-next] m68k: remove legacy probing
    https://git.kernel.org/netdev/net-next/c/e179d78ee11a
  - [v2,07/14,net-next] ax88796: export ax_NS8390_init() hook
    https://git.kernel.org/netdev/net-next/c/375df5f8c181
  - [v2,08/14,net-next] xsurf100: drop include of lib8390.c
    https://git.kernel.org/netdev/net-next/c/f8ade8dddb16
  - [v2,09/14,net-next] move netdev_boot_setup into Space.c
    https://git.kernel.org/netdev/net-next/c/5ea2f5ffde39
  - [v2,10/14,net-next] make legacy ISA probe optional
    https://git.kernel.org/netdev/net-next/c/4228c3942821
  - [v2,11/14,net-next] wan: remove stale Kconfig entries
    https://git.kernel.org/netdev/net-next/c/db3db1f41754
  - [v2,12/14,net-next] wan: remove sbni/granch driver
    https://git.kernel.org/netdev/net-next/c/72bcad5393a7
  - [v2,13/14,net-next] wan: hostess_sv11: use module_init/module_exit helpers
    https://git.kernel.org/netdev/net-next/c/d52c1069d658
  - [v2,14/14,net-next] ethernet: isa: convert to module_init/module_exit
    https://git.kernel.org/netdev/net-next/c/a07d8ecf6b39

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


