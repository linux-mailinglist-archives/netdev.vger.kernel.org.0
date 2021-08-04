Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB6D3DFF2D
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 12:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbhHDKKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 06:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237463AbhHDKKU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 06:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F73F61037;
        Wed,  4 Aug 2021 10:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628071807;
        bh=QtNsX1gCgoVD6MhvZPu2giLHtN+8L9ej/kYS6YKkOfY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HLsMfCgThoe88gCqrNJRIIh6jQ3Aktjf7BHkUh3pep68kwNngIJg4LUsecCcIY1Yi
         A87aJusaAYR1p0jh5et063VV5Fw0LYi1DHLfLGMlmbWpmumnuP4ERo8WYrv+VXT6Vp
         Y0ka72/MVNTWLZWx3fY1StNxk9v5Eog6vPuuDFaPDdVXHL24dNEjPwyHP7mXL57mVh
         EpXPjnMUeHwsrDqFD0lUfDk0C89e5mAFRuEg3UmilsufAlMG+jrLOcZKgR3GXgpw6S
         DPTDfHrYK7DKnO9RkiZjAtA8SAwAjgF5YVG5uyF0SxvbTp5c/9HJdxy39md0zv2u4i
         n72whDZgWFH1w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2F69960A72;
        Wed,  4 Aug 2021 10:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net): ipsec 2021-08-04
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162807180719.12271.7694584072756075901.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 10:10:07 +0000
References: <20210804070329.1357123-1-steffen.klassert@secunet.com>
In-Reply-To: <20210804070329.1357123-1-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Wed, 4 Aug 2021 09:03:23 +0200 you wrote:
> 1) Fix a sysbot reported memory leak in xfrm_user_rcv_msg.
>    From Pavel Skripkin.
> 
> 2) Revert "xfrm: policy: Read seqcount outside of rcu-read side
>    in xfrm_policy_lookup_bytype". This commit tried to fix a
>    lockin bug, but only cured some of the symptoms. A proper
>    fix is applied on top of this revert.
> 
> [...]

Here is the summary with links:
  - pull request (net): ipsec 2021-08-04
    https://git.kernel.org/netdev/net/c/d00551b40201

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


