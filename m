Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD81389707
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbhESTvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232256AbhESTva (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 15:51:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3EB75611B0;
        Wed, 19 May 2021 19:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621453810;
        bh=rszwbAkPk9ccvnHq47Mvxi0c53lLCYYj20OpAcPxaJ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JX0z3LuN9sY5TV+rXJcgajBX4/rZpSuNlMZ7+MQL3uK97uzoHVpALKzj6A7w5GcYr
         F+QBEAMtvZpM9Vl0oxPb0HtOQldXHPCW2ILdNi2hQtkQ6+hQBppiRJn0pD2+KHBYXt
         73CKgYF2ZESAgdMaZiKYklCHPyCOJ5fh29FLsxjerq26NBCo1s2PcaeddlIFv5JSBx
         Ebu8wCkw9lL8kKvVJ8cYQUmUBnS1vzYM+9udxLVB4fV4EInrFScIvSa0Yn8R4w2mR0
         2yxi+QrGvCPy4v/hs2smtykKrdQqffDvl12XOOOGwd9rW0YAOIcacQCQ1dIqUUsW3J
         GC9W4di3kb22w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3195C60A56;
        Wed, 19 May 2021 19:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] dt-bindings: net: nfc: s3fwrn5: Add optional clock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162145381019.1870.2964109189084564601.git-patchwork-notify@kernel.org>
Date:   Wed, 19 May 2021 19:50:10 +0000
References: <20210519091613.7343-1-stephan@gerhold.net>
In-Reply-To: <20210519091613.7343-1-stephan@gerhold.net>
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, k.opasiak@samsung.com, robh+dt@kernel.org,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bongsu.jeon@samsung.com, ~postmarketos/upstreaming@lists.sr.ht
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 19 May 2021 11:16:12 +0200 you wrote:
> On some systems, S3FWRN5 depends on having an external clock enabled
> to function correctly. Allow declaring that clock in the device tree.
> 
> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> ---
> Changes in v2: Minor change in commit message only
> v1: https://lore.kernel.org/netdev/20210518133935.571298-1-stephan@gerhold.net/
> 
> [...]

Here is the summary with links:
  - [v2,1/2] dt-bindings: net: nfc: s3fwrn5: Add optional clock
    https://git.kernel.org/netdev/net-next/c/9cc52f5a533a
  - [v2,2/2] nfc: s3fwrn5: i2c: Enable optional clock from device tree
    https://git.kernel.org/netdev/net-next/c/340f42f7ff0b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


