Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE80E4663AD
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346897AbhLBMdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:33:43 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:33316 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346396AbhLBMdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:33:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51434CE22BA;
        Thu,  2 Dec 2021 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77842C5831A;
        Thu,  2 Dec 2021 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638448210;
        bh=baE5xYkWzKPOgNmDYhr7c/t3gupPTNGXOwGObufV0A8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a8soVpPwCQE+0h5rQWoL7u1ugh1ALkMhT8pQwOrToI+nV79htHxKu8ljf59RUrk8i
         rAC3N8r+pefNE2sauzr2gFoyZ6sJ98EvDFbstyqoqb+8PyZN+h0Zib0IAo2FsDm3DD
         Vofys/HTGNZzJ52MaNar4ES7TagyqFnLDmY4rf+xo+ee+QscbGR4N7GHxkv+p8tZUY
         v5lvkWyPPGZqtmGXVe/mfQVxKs2E9o7hLiTAP4vGbI4/fFDTilwIByUcyonpGzHM5O
         gQ0Wl0kpFNNwvI3LqmkxmOXb/6GAEu5ZvGf+7ViXu2U2X3JI9V8toKDe6HNIkMGK4Y
         aFUgnhQnVZvFg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 57E6C609EF;
        Thu,  2 Dec 2021 12:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] dt-bindings: net: lan966x: Add additional properties
 for lan966x
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844821035.14016.15945102178226862801.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:30:10 +0000
References: <20211202110504.480220-1-horatiu.vultur@microchip.com>
In-Reply-To: <20211202110504.480220-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 2 Dec 2021 12:05:04 +0100 you wrote:
> This patch updates the dt-bindings for lan966x switch.
> It adds the properties 'additionalProperties' and
> 'unevaluatedProperties' for ethernet-ports and ports nodes. In this way
> it is not possible to add more properties to these nodes.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net-next] dt-bindings: net: lan966x: Add additional properties for lan966x
    https://git.kernel.org/netdev/net-next/c/a72d45e64654

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


