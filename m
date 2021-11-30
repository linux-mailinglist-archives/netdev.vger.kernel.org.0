Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1174633DC
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241368AbhK3MNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:13:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50588 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237097AbhK3MNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:13:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAE3CB818A7;
        Tue, 30 Nov 2021 12:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A9ED6C56748;
        Tue, 30 Nov 2021 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638274210;
        bh=HeQd/dO8d/hwP17hIH91xif10KnxJDka7AIozkOHwwo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QIFjHBnzngJ3o33VHU+3Tqsb2ywFIBo+dnrxOge0R4in+iJPwur6cLJ4YqUbLidZ0
         Gaas0I6szp+iJr76J8S0yTfQTpmHQcRooFpNR5j/WsVPVHugAzhU4nr0W/VASdnN7W
         DRzWxsBucXY2Fw5rlYU9DRVy7CXu5q/G4Bcf0wbzwfVMj7eF3Oca0aS0Ypxzd63mAN
         3x8DfbDiwNdDaGcUqKDnT0l7gqlomBCprjtm51MkILPvfXjyhNivnZSc9IqupRCQXm
         NlyYEQ4VuQOWfOyMvztSZ2udLaoKFtMzggKAK9l/wHO1BcG09cl8va38sO6IbK2+xa
         KlTNPZaRMwYhA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 979D660A94;
        Tue, 30 Nov 2021 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: Add platform level debug register dump
 feature
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827421061.23105.11588996803410866762.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:10:10 +0000
References: <20211128195854.257486-1-bhupesh.sharma@linaro.org>
In-Reply-To: <20211128195854.257486-1-bhupesh.sharma@linaro.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     netdev@vger.kernel.org, vkoul@kernel.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, qiangqing.zhang@nxp.com,
        davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 Nov 2021 01:28:54 +0530 you wrote:
> dwmac-qcom-ethqos currently exposes a mechanism to dump rgmii registers
> after the 'stmmac_dvr_probe()' returns. However with commit
> 5ec55823438e ("net: stmmac: add clocks management for gmac driver"),
> we now let 'pm_runtime_put()' disable the clocks before returning from
> 'stmmac_dvr_probe()'.
> 
> This causes a crash when 'rgmii_dump()' register dumps are enabled,
> as the clocks are already off.
> 
> [...]

Here is the summary with links:
  - [net-next] net: stmmac: Add platform level debug register dump feature
    https://git.kernel.org/netdev/net-next/c/4047b9db1aa7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


