Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F1A431A40
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 15:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhJRNC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 09:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231781AbhJRNCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 09:02:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6642C61212;
        Mon, 18 Oct 2021 13:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634562007;
        bh=p1kdOX7a7EeRip5bNDMpg7FQKKbZ5w/mBvliWziI8SQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OA03dnuAiTHZoIqxXgEPMrBc36OIRmcvdz+m1h0t2ITIV4JNwgsGQ7duQnUQg5XQk
         xPCd1sEuKGf6NJadXbUvg1vpxSViHRNaiTDr+6vLuBSKOJAEhe/eHY6H01nKui16Ha
         1Rvfs6u9yv2aWORIeBywnBQcTcWcneg26HDrtFZWSpYzgGZLzklUsaMlJu0/PxpqlN
         B2A9djahKO4Ln+Q757iGi5yYBvYygVb81ZygB17WUr9fkPWZ4UrWyDGrVDPniyjDiJ
         CzTm6AIexminVIHzBklKoDsIbqya+KmyPHAYyNFwWescCsabiAUmT/IZdwNsTH7qtq
         jWxmeybhb4NCQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5B413600E6;
        Mon, 18 Oct 2021 13:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] mctp: unify sockaddr_mctp types
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163456200736.664.14926664578207340379.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 13:00:07 +0000
References: <20211018032935.2092613-1-jk@codeconstruct.com.au>
In-Reply-To: <20211018032935.2092613-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, esyr@redhat.com,
        geert@linux-m68k.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 18 Oct 2021 11:29:34 +0800 you wrote:
> Use the more precise __kernel_sa_family_t for smctp_family, to match
> struct sockaddr.
> 
> Also, use an unsigned int for the network member; negative networks
> don't make much sense. We're already using unsigned for mctp_dev and
> mctp_skb_cb, but need to change mctp_sock to suit.
> 
> [...]

Here is the summary with links:
  - [net,1/2] mctp: unify sockaddr_mctp types
    https://git.kernel.org/netdev/net/c/b416beb25d93
  - [net,2/2] mctp: Be explicit about struct sockaddr_mctp padding
    https://git.kernel.org/netdev/net/c/5a20dd46b8b8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


