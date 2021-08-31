Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533013FC673
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241484AbhHaLLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 07:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241420AbhHaLLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 07:11:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5F2FA61058;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630408208;
        bh=6XTiFVpAOU/U5QiTGxTmalseSswMAbrKt9dCYpd7zDE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=taQzhgpbYHMJ8UjsN5eR+CHkGMC0IxXRWA/+EHoGSqprf1pEknB75XRbho5E4snZ7
         mb5IVZhwkDmRJo9PFq+mxMolvJZmwP/UkFJLF0DwTC31rkjNscy0Shc6AZs0Tvcowt
         6H+nBTwmjo2ge8brzDHojEwOWOJGW0VZbinmrGMlrkHDe+RGhCBUVvG5bSrV2XBWAM
         x9n5CHiNsyGg5ePEuxpSPSp5s7IWOE+r2d3lFnBYR3oAvarFA+KQfEmtsPQ2+84nd+
         0x8Ej4PnpSpJR6F/94NL470xh8HV2/33/dpGkjn3LohGPnu1b1SkUoAOQNdlF/imxO
         3a3DAFuSnC4YA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5A33060A9D;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dpaa2-eth: Replace strlcpy with strscpy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163040820836.5377.14060243264259649124.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Aug 2021 11:10:08 +0000
References: <20210830130531.12429-1-wangborong@cdjrlc.com>
In-Reply-To: <20210830130531.12429-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     davem@davemloft.net, ioana.ciornei@nxp.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 30 Aug 2021 21:05:31 +0800 you wrote:
> The strlcpy should not be used because it doesn't limit the source
> length. As linus says, it's a completely useless function if you
> can't implicitly trust the source string - but that is almost always
> why people think they should use it! All in all the BSD function
> will lead some potential bugs.
> 
> But the strscpy doesn't require reading memory from the src string
> beyond the specified "count" bytes, and since the return value is
> easier to error-check than strlcpy()'s. In addition, the implementation
> is robust to the string changing out from underneath it, unlike the
> current strlcpy() implementation.
> 
> [...]

Here is the summary with links:
  - dpaa2-eth: Replace strlcpy with strscpy
    https://git.kernel.org/netdev/net-next/c/995786ba0dab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


