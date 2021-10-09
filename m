Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0CD427A4D
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 14:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244916AbhJIMwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 08:52:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233117AbhJIMwF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 08:52:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 520D86109E;
        Sat,  9 Oct 2021 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633783808;
        bh=dNacaGCbmo+/TkpuEjrh6dHVk5tbhDXGkTjLiJByys8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rQr1C5yYu2M3TOiDJKxb2lTqH9uPcpYQRPT+lZPr4IZGEWMaaiKD5nW1Gq8/qObhj
         rb+EmuBSwkHME+p5CXe6Lif6Qy8qKh6dK34Ip1ZWp2BZxxK6QfUG+S2fcEJauvb0Kk
         yR2DD+iHqN51+/bECz+Pvkd1v2tuNU3bPuHePTrUzr4r/YA7Zp0mZHWbfumN6dKtdV
         eMAZghfLYfkf0bucC4ZVdxo0Uv+vNcoWox+Xk9zWXoLL4umojwraNop7QPht8CIWr/
         u5zLMcxzBRPiZ/e+uts5EbTX7Ym+14ti0/kbVujPxDxwOgiAAVHXfaXX6hs6vqpgXK
         uZVIyK15HSdpQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 48AC760A53;
        Sat,  9 Oct 2021 12:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dsa: fix typo in
 dsa-tag-protocol description
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163378380829.3217.12747487765105950738.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Oct 2021 12:50:08 +0000
References: <20211009122736.173838-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211009122736.173838-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        tobias@waldekranz.com, olteanv@gmail.com, robh+dt@kernel.org,
        michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  9 Oct 2021 15:27:35 +0300 you wrote:
> There is a trivial typo when spelling "protocol", fix it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next,1/2] dt-bindings: net: dsa: fix typo in dsa-tag-protocol description
    https://git.kernel.org/netdev/net-next/c/5ee61ad7d593
  - [net-next,2/2] dt-bindings: net: dsa: document felix family in dsa-tag-protocol
    https://git.kernel.org/netdev/net-next/c/7932d53162dc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


