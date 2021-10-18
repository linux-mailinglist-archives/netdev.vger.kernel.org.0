Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6154318EE
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhJRMWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231310AbhJRMWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 08:22:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1F28A60F11;
        Mon, 18 Oct 2021 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634559607;
        bh=QQanW1q6kwVYSVV1bMmedzFF+auB/GiSN7W7MSHMpFI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=paeguLI12OTRL9RW72yTY66tN7t590faCgcMIZ07kcIJihw42Xozg9f8G/srykudQ
         3dbhT8sptqc4V+m7F5cQdNA2kX+JXxhkBtlvR+JI+xyK7gR4mtVUU0ZMjE9NVtgX53
         eqRcKN128vOSvqXdFLl4szqzBbhmreZbLwSF1xLd8NkhIdpLBoYEV5CrlL1rNYIh9t
         FNdTAyU9sKAs85nO44GuvYXtoPZ2G5n+XZ1AUrkUGota77lgH3K0N2PKu2u6HTCT6t
         y9pk5dbf9Qn5VD8KVfKFSbDM53DwW4I64h5ku4a+WUHiCQ+FN3AgDLCmmUePxwSj8X
         SRTK6aMvvqDpg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0E78B600E6;
        Mon, 18 Oct 2021 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: ethernet: ave: Introduce UniPhier NX1 SoC
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163455960705.13509.11402587154059994747.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 12:20:07 +0000
References: <1634520457-16440-1-git-send-email-hayashi.kunihiko@socionext.com>
In-Reply-To: <1634520457-16440-1-git-send-email-hayashi.kunihiko@socionext.com>
To:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        mhiramat@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 18 Oct 2021 10:27:35 +0900 you wrote:
> This series includes the patches to add basic support for new UniPhier NX1
> SoC. NX1 SoC also has the same kinds of controls as the other UniPhier
> SoCs.
> 
> Kunihiko Hayashi (2):
>   dt-bindings: net: ave: Add bindings for NX1 SoC
>   net: ethernet: ave: Add compatible string and SoC-dependent data for
>     NX1 SoC
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] dt-bindings: net: ave: Add bindings for NX1 SoC
    https://git.kernel.org/netdev/net-next/c/8e60189d937c
  - [net-next,2/2] net: ethernet: ave: Add compatible string and SoC-dependent data for NX1 SoC
    https://git.kernel.org/netdev/net-next/c/9fd3d5dced97

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


