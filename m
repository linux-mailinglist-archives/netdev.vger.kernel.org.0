Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F84C3DFE2E
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237192AbhHDJk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237120AbhHDJkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 05:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DB7BC61004;
        Wed,  4 Aug 2021 09:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628070007;
        bh=rPZaRuUEzFLOblI684UBTjrYp0Rla6ljxbeG2/n7IhU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TH3OCczKb86zssGnxgtJ2Pxnxv2Il6eseohXYGLm24NBMAPIgJLP2h2cqEmlfZPHU
         dgvmZBZecnQRVdG4pCyFvtcIEKCJaWKQpMDOFS+V43WyMugWK4dhBL9xYO8H7KDjmv
         Iqy3X5HZcHyo0gFO+T5b8VuD4QWjSNPgtrK4Sn0qOtZ4EO3n3tn1We/NG6B2Oumpbi
         BffZ6veG+2FNoorS/czXXBPW+GMNI4rp2Nd/ABNu+6nMU663cqklCXjTKMjhJ+6XEN
         Dt1RiloSg8xSXCVWjLWcUdtkhI+87jhcHUS9N9QurMHefimiO0KrqafmW6aIUfkv8Y
         QK1kW/lTYTAlw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CCB4760A7D;
        Wed,  4 Aug 2021 09:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: exthdrs: get rid of indirect calls in
 ip6_parse_tlv()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162807000783.29242.9231647640834514806.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 09:40:07 +0000
References: <20210803153105.1414473-1-eric.dumazet@gmail.com>
In-Reply-To: <20210803153105.1414473-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, justin.iurman@uliege.be, lixiaoyan@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  3 Aug 2021 08:31:05 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> As presented last month in our "BIG TCP" talk at netdev 0x15,
> we plan using IPv6 jumbograms.
> 
> One of the minor problem we talked about is the fact that
> ip6_parse_tlv() is currently using tables to list known tlvs,
> thus using potentially expensive indirect calls.
> 
> [...]

Here is the summary with links:
  - [net-next] ipv6: exthdrs: get rid of indirect calls in ip6_parse_tlv()
    https://git.kernel.org/netdev/net-next/c/51b8f812e5b3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


