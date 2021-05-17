Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B522F386D38
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238825AbhEQWv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344096AbhEQWv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 18:51:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 461776124C;
        Mon, 17 May 2021 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621291811;
        bh=Xms9XjtAFhei32WVHK1yeEXxidroFjjKryVIv4+BRzM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l/473ZwDVdzDPh0kiZ4CloGbv54phK6+dvXjZG4dPPCc2awcTcDH/573W4TTq042g
         ihGUporTjAHouOAMxVJLWpoXEdm1U67XeerWGGrKzvdkkm+6clBLXXN+aPvQXOKi28
         qYXUk3MBoYKF5nraQN8PZcVxdreeQhBdlyj7neHthTFio1eKYI3Nw4TqLZYELg+R9z
         NPEWuKq2xCNAtinsN1h7sb3SGRTAamz99qKrk94S8Zvvv6hRjgRHLjBLq24SNtZXeI
         Q6+dMZbdDTpU3VkkLKIOSzwt2SQ2Z/a0AizEcSKysrJnYLgFYWujEcvW3xeNtV0eJX
         re3vgO53AJrXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3ACD860A56;
        Mon, 17 May 2021 22:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: wwan: Add WWAN port type attribute
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162129181123.15707.2752380746532598870.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 22:50:11 +0000
References: <1621245214-19343-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1621245214-19343-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        dcbw@gapps.redhat.com, aleksander@aleksander.es
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 17 May 2021 11:53:34 +0200 you wrote:
> The port type is by default part of the WWAN port device name.
> However device name can not be considered as a 'stable' API and
> may be subject to change in the future. This change adds a proper
> device attribute that can be used to determine the WWAN protocol/
> type.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net] net: wwan: Add WWAN port type attribute
    https://git.kernel.org/netdev/net-next/c/b3e22e10fdda

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


