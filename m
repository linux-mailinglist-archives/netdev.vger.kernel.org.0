Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CDA42B024
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 01:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhJLXcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 19:32:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233456AbhJLXcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 19:32:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C9F0960EB6;
        Tue, 12 Oct 2021 23:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081406;
        bh=hYZ3wQsBF8dRx+fngwMq0v1VF6IcAPIounIgsDCgwvI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mxXUZzkb1vs6aspkW6Vyr4PgFkm38uAOx49idCo7DJOEt0e0CKppdgW/CLdiS8hsf
         eWaXwrUhtGQcgxUe3T8CI94kGgLTK9pY+y4knCElvnvvlJYztYJjdyd+2/MspRosyh
         Sc7eDRTNxdH18es6LWt2LYF2HruiR5tXWcKx+pWrX2X5s/4E9wRQM6OZmZpMEtM2cj
         4Wpc4PXDF5AvoDLPavzh7DfXM8dWikjTRJqSzwh1LgP4XDU+VK/v1NqBlcmNsE4QpY
         CRnRK48xLI4sJ3w749awGy3aIN1p+9PwCyAbjxKmDxzYea+m5SdhksnYLeXLt2bAg7
         g+04alCRMU6tA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BD035609EF;
        Tue, 12 Oct 2021 23:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: fix spurious error message when unoffloaded
 port leaves bridge
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163408140676.20518.15659021615096165662.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Oct 2021 23:30:06 +0000
References: <20211012112730.3429157-1-alvin@pqrs.dk>
In-Reply-To: <20211012112730.3429157-1-alvin@pqrs.dk>
To:     =?utf-8?b?QWx2aW4gxaBpcHJhZ2EgPGFsdmluQHBxcnMuZGs+?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        alsi@bang-olufsen.dk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 13:27:31 +0200 you wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Flip the sign of a return value check, thereby suppressing the following
> spurious error:
> 
>   port 2 failed to notify DSA_NOTIFIER_BRIDGE_LEAVE: -EOPNOTSUPP
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: fix spurious error message when unoffloaded port leaves bridge
    https://git.kernel.org/netdev/net/c/43a4b4dbd48c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


