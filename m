Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD483509E5
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhCaWA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232109AbhCaWAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4D11761077;
        Wed, 31 Mar 2021 22:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617228011;
        bh=vTrlL3ZbdYW70WavlFxk0XXBOGprcU+kERhCf3PpJZQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dPXJnBBOHEgT2CcrtxDGDSkSRETeVSX2uSLPki/Y/BQZmpPtxjQh+OKJsWf+iIN7O
         z3/gQlhLyBdlHXZBpHXWhUlO7j16neTG9q75F5lS2k/vvSzQYf8EqehxzqAVk+qp6X
         8smLF6HXzkOkLtOUZEHpn12I57l95K5Oa2dpFUb1wh4hpQs8pKSehMJuMtCgh6PwVT
         wamtJbLYb6MrrO+48Nvlg5ECfka7jmiNP6Ft8JuM9iH61KDKJYOBXB6Qo7IDMPTRxK
         UUxP1Qmnorm2YnzctW63RdHTMkLIm2GM4I+LpJzEbFn4xx1kLQnrWDpo8LBJVvrQcO
         Kg4/5S+QHqbVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 40668608FD;
        Wed, 31 Mar 2021 22:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request (net): ipsec 2021-03-31
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161722801126.26765.12625919401749264300.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 22:00:11 +0000
References: <20210331081847.3547641-1-steffen.klassert@secunet.com>
In-Reply-To: <20210331081847.3547641-1-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Wed, 31 Mar 2021 10:18:36 +0200 you wrote:
> 1) Fix ipv4 pmtu checks for xfrm anf vti interfaces.
>    From Eyal Birger.
> 
> 2) There are situations where the socket passed to
>    xfrm_output_resume() is not the same as the one
>    attached to the skb. Use the socket passed to
>    xfrm_output_resume() to avoid lookup failures
>    when xfrm is used with VRFs.
>    From Evan Nimmo.
> 
> [...]

Here is the summary with links:
  - pull request (net): ipsec 2021-03-31
    https://git.kernel.org/netdev/net/c/c9170f132178

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


