Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320A4466344
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357881AbhLBMOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:14:39 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56374 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357895AbhLBMNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:13:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E90F1CE221B;
        Thu,  2 Dec 2021 12:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E56AEC53FCD;
        Thu,  2 Dec 2021 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638447008;
        bh=WGxZxxOxo/iEVtoBrbZrUbl8D0pmoPnzwWY3MpJZGhI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tDGDir7z6ntq/n1zc0JTDMcWYlCYtClbgFbxRgI990AQfO9sV4PB8Nf8+aS2CcvBP
         I5TXs/Fx0TiilyDqj+VDM+kdo19USTIzBYPLPIgIovasiHZNKL2hOAQBlMatgzoMyK
         IDqTvjjAYHrJaBMvxBp50DUQ18xlIQQCTPJvxqjQGn9Iqdi/0sfw77wMMAj0af88Oa
         0DzIUzrbNtEngwVhCcT0ltcTSoABR2Y5E602a6JWbC0egUAloKSSUtq8TFntYtzUYa
         1WsOLaLKricQ8CxZsuBOysxfw0QJRx9rxqtLzuWmiq9myNzCHTEsAfjWzMjDrVwHTZ
         xtLlvpCMltLsA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C705C60A7E;
        Thu,  2 Dec 2021 12:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v2 1/2] dt-bindings: net: dsa: split generic port
 definition from dsa.yaml
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844700881.4273.14536880840903138023.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:10:08 +0000
References: <20211130211625.29724-1-ansuelsmth@gmail.com>
In-Reply-To: <20211130211625.29724-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, john@phrozen.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        robh@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 22:16:24 +0100 you wrote:
> Some switch may require to add additional binding to the node port.
> Move DSA generic port definition to a dedicated yaml to permit this.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/net/dsa/dsa-port.yaml | 77 +++++++++++++++++++
>  .../devicetree/bindings/net/dsa/dsa.yaml      | 60 +--------------
>  2 files changed, 79 insertions(+), 58 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml

Here is the summary with links:
  - [net-next,v2,1/2] dt-bindings: net: dsa: split generic port definition from dsa.yaml
    https://git.kernel.org/netdev/net-next/c/75c990154479
  - [net-next,v2,2/2] dt-bindings: net: dsa: qca8k: improve port definition documentation
    https://git.kernel.org/netdev/net-next/c/dfb40cba6d45

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


