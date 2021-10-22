Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11AEE437FFC
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 23:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhJVVm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 17:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231363AbhJVVm0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 17:42:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AD75C6103E;
        Fri, 22 Oct 2021 21:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634938807;
        bh=ShC8hJxvoA+WbOqS9KKdnLtgNz3Jvywk17FK7HzDmWY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kJ+2N84puDwy0LTBL+dgSkrmSdGrE8sxXwOF9XK4sGtNPY5pxwMzyoR7XS6s9X/2I
         iUnJUcb18jnQZ9XW9ZrWf7acfpOL5SfDHqGSIP2bbOyHjcQ/YDrV4LP686R3OS3/pN
         XC+vbF++Oi0cA/F9lVIpsPbj33dRlv3bmsIJChLTdFjMa+AxfKlWcWdcREdRcO3+RE
         rItGnpEiT4UcAWbi8+uY01Poy6Rj7/dm+dgNAGegmTskiSCxpnyL50hfdrk4AOG6KU
         wNcjRdmFgiiFbui4NtZgybRqGV2G2qqwJmiGKwkBs47EXxngPhMSCkgy1+GXdl32dv
         Hsi/gcFWVvNtw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9C4A060A2A;
        Fri, 22 Oct 2021 21:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] gre/sit: Don't generate link-local addr if
 addr_gen_mode is IN6_ADDR_GEN_MODE_NONE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163493880763.14343.15333810862594904484.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Oct 2021 21:40:07 +0000
References: <20211020200618.467342-1-ssuryaextr@gmail.com>
In-Reply-To: <20211020200618.467342-1-ssuryaextr@gmail.com>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org, a@unstable.cc, kuba@kernel.org,
        davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 20 Oct 2021 16:06:18 -0400 you wrote:
> When addr_gen_mode is set to IN6_ADDR_GEN_MODE_NONE, the link-local addr
> should not be generated. But it isn't the case for GRE (as well as GRE6)
> and SIT tunnels. Make it so that tunnels consider the addr_gen_mode,
> especially for IN6_ADDR_GEN_MODE_NONE.
> 
> Do this in add_v4_addrs() to cover both GRE and SIT only if the addr
> scope is link.
> 
> [...]

Here is the summary with links:
  - [net-next] gre/sit: Don't generate link-local addr if addr_gen_mode is IN6_ADDR_GEN_MODE_NONE
    https://git.kernel.org/netdev/net-next/c/61e18ce7348b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


