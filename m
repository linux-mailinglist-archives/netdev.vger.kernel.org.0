Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BAD346E3A
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 01:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbhCXAUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 20:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231374AbhCXAUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 20:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 07798619E6;
        Wed, 24 Mar 2021 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616545210;
        bh=kHLBGVKJ3fl7L+jP2KrvLdy5Z63m8GqqvbdZsFlyBhw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S/POvoe9D5WikKcIY+SMwT0juCCVGD4cyHwMUnIiWLDoXXS1pYHFGSkbzbTeFh5Vc
         X9jxPaiGcRdxiUyqvFalsPq4mk4buYH8WayG5s2ZlRLC879oWXTAFkU89m53zOl2lw
         WfMIPx0yyP3r7XnCZ3eom4YfBl2cs22TaPDzcZchbN5i2t8jR9gL/bA4cbUxZVw6gs
         T/1dBNOga+/c20h6FpN0RGntl9CzIOR80I1pm8BIE8wFc/kMQ5g6A6X78xsBYrPDDE
         3GivnCn5uNg6yAJvKhfe2TEFWZyKuE+YRtj0e5RKdCs12dYKrXt5oKVlpQlt95nOZA
         8XgSJ2iIQr0hg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EBBFD60A6A;
        Wed, 24 Mar 2021 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: avoid 64-bit modulus
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161654520996.13502.14966166701949033388.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 00:20:09 +0000
References: <20210323010505.2149882-1-elder@linaro.org>
In-Reply-To: <20210323010505.2149882-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, rdunlap@infradead.org,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 20:05:05 -0500 you wrote:
> It is possible for a 32 bit x86 build to use a 64 bit DMA address.
> 
> There are two remaining spots where the IPA driver does a modulo
> operation to check alignment of a DMA address, and under certain
> conditions this can lead to a build error on i386 (at least).
> 
> The alignment checks we're doing are for power-of-2 values, and this
> means the lower 32 bits of the DMA address can be used.  This ensures
> both operands to the modulo operator are 32 bits wide.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipa: avoid 64-bit modulus
    https://git.kernel.org/netdev/net-next/c/437c78f976f5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


