Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A052319605
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhBKWut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhBKWus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 17:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CDB5164E3E;
        Thu, 11 Feb 2021 22:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613083807;
        bh=IXiqdLyl39Ag/iyN3ITxDWKAB3xKcTcBvC50xBOKw2I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WygIxQp8JN72NNc1SyNDWXoRJjs3vHFA87RwIbXaYVsERdIWnWc+LYZABsMCF415V
         jQQ0gAsgQWA8vhxfJ4Mylwmd/Y7BKIvy91cUoirl0eudTD9M62H5E0efscixhN9yQt
         p2EPx147P/D1aSN9QpqHmpndqvugLEDNcrYd4Y7palAXezcMbGX+tLZqQovUQOdtjZ
         7AJzIa3H8sm/z0iLp4YFtyAjjjBfVg5z9J5hiAYrE843aPuRisrnQZfTOOh1MabU88
         Ea9vWAb+JiZR1R7yRSbMr65ck3WBB915JNwKbo45BfzyeilLaoIKocp62zEYL1Ekxw
         MDdqkv9pPLF2g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C0856600E8;
        Thu, 11 Feb 2021 22:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] bnxt_en: 2 bug fixes.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308380778.17877.14244262768593051573.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 22:50:07 +0000
References: <1613028264-20306-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1613028264-20306-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 11 Feb 2021 02:24:22 -0500 you wrote:
> Two unrelated fixes.  The first one fixes intermittent false TX timeouts
> during ring reconfigurations.  The second one fixes a formatting
> discrepancy between the stored and the running FW versions.
> 
> Please also queue these for -stable.  Thanks.
> 
> Edwin Peer (1):
>   bnxt_en: reverse order of TX disable and carrier off
> 
> [...]

Here is the summary with links:
  - [net,1/2] bnxt_en: reverse order of TX disable and carrier off
    https://git.kernel.org/netdev/net/c/132e0b65dc2b
  - [net,2/2] bnxt_en: Fix devlink info's stored fw.psid version format.
    https://git.kernel.org/netdev/net/c/db28b6c77f40

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


