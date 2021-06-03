Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E928A39ACE9
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhFCVb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 17:31:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhFCVbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 17:31:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 55899613D8;
        Thu,  3 Jun 2021 21:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622755807;
        bh=sw4MDD9qny2ynlrCAnn04HnUSspiFRVLPaD0QeiKRRI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o76L0jV5FRpBvAfWaWYeV5LtTLVhv+shZ5kDS/5+Hl8sdDF+yy1cavw9P7WW0v3sT
         +2Rg1Eooqf23jcceafPE7bF30kbSBGbO/FKOD3RkPx/aqLZz+b+91EwfeY3/TuX1vu
         MEd5otrE38CdmJ3jHMdKQvFxCO+Uf4It/ecR/z/z2oMHxKGL3/6qBKCsnZ31xV7mXq
         78Jptc+F6ifiyYbZpmXwMKzOiRh4byypEJOTPkT3dXNAzDmpga8gMtetlP9B0qYx+m
         5KLAdmYdfXcjUrGr++Xi7sVOxHzAC0bVWeeBxWxxoJBha1Tg/X7vFjeNYuPjL54ot7
         6No5Mx96CR0/w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 494B460ACA;
        Thu,  3 Jun 2021 21:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: tcp better handling of reordering then loss
 cases
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275580729.14468.5072295293344961553.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 21:30:07 +0000
References: <20210603005121.3438186-1-ycheng@google.com>
In-Reply-To: <20210603005121.3438186-1-ycheng@google.com>
To:     Yuchung Cheng <ycheng@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        ncardwell@google.com, bianmingkun@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  2 Jun 2021 17:51:21 -0700 you wrote:
> This patch aims to improve the situation when reordering and loss are
> ocurring in the same flight of packets.
> 
> Previously the reordering would first induce a spurious recovery, then
> the subsequent ACK may undo the cwnd (based on the timestamps e.g.).
> However the current loss recovery does not proceed to invoke
> RACK to install a reordering timer. If some packets are also lost, this
> may lead to a long RTO-based recovery. An example is
> https://groups.google.com/g/bbr-dev/c/OFHADvJbTEI
> 
> [...]

Here is the summary with links:
  - [net-next] net: tcp better handling of reordering then loss cases
    https://git.kernel.org/netdev/net-next/c/a29cb6914681

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


