Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A86343B2AC
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbhJZMwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232718AbhJZMwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 08:52:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 21DF460ED4;
        Tue, 26 Oct 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635252607;
        bh=9RzMEm7MGaozxVLG5vp+DYNmZ6H8u5oCItjBoJvFX60=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uCH+4KWlIpIKsP8NT/vTY6sWm5iGKbOWMtoxihRl1Ub/2iwZgX0gyypE7TiauTzpM
         YAso0yYbsDl5VgXDN9RfxgPO0j56brquIQEmPl/YhoOUuqqnx6N1gwDGgyqgte+e/f
         CvKUVbD7gbWly9BOr/PHDCyNjhGwsLhtbGcb9YutwQHrBeRK4SC9lowQPAwUMGqiEQ
         hRgYoxMi8uaLSbT+isu9zo9gv95Vxp/pC3FMSMAdbkBdfWraXWrkHGVKKRSwlackjK
         asxlO5OKj3N6MeArh64L1OcmrxqbwuuWQC27qW63LIeWBPIq2T7LO6A9/6LBJbGF1t
         vCo/jQ9U2gIdA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0D6D1609CC;
        Tue, 26 Oct 2021 12:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] nfc: port100: fix using -ERRNO as command type mask
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525260704.9181.10376941005733048899.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 12:50:07 +0000
References: <20211025144936.556495-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211025144936.556495-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     thierry.escande@linux.intel.com, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Oct 2021 16:49:36 +0200 you wrote:
> During probing, the driver tries to get a list (mask) of supported
> command types in port100_get_command_type_mask() function.  The value
> is u64 and 0 is treated as invalid mask (no commands supported).  The
> function however returns also -ERRNO as u64 which will be interpret as
> valid command mask.
> 
> Return 0 on every error case of port100_get_command_type_mask(), so the
> probing will stop.
> 
> [...]

Here is the summary with links:
  - [v2] nfc: port100: fix using -ERRNO as command type mask
    https://git.kernel.org/netdev/net/c/2195f2062e4c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


