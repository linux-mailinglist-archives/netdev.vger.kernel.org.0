Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F19397C59
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbhFAWVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234714AbhFAWVq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:21:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 57C52613C1;
        Tue,  1 Jun 2021 22:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622586004;
        bh=MMPGEvoq9xfRD0tXifmGagEtYijZ6aQOMQDo0jS+s0s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tN6J4kUyzM/MVsbvUYaXYarA6sh365M/dOZdOxoMCpvcFjLwydKCEc5x5a6zsoiRY
         4izvgJ/f3fmQENIqQYOli0/vpB6bW26wk2m1GGR+1VzLa4ejrHurL2UhmANe1qXFua
         ifnZvaNJKBy1iYds6MCsmQu59/jIeW3wVMsQiRSwy3ggr7aHblanBZgC/fsqwty/h4
         YH1dEuZCS+/rD2jPAh1jGUB9XlAh5gqDuHYx7VdGDVqn9AoqAy64i9Cc5XR8NWVmjp
         zv/9ldL6PlzlkCQ2/h9Df253/MZdYYOUwO35x0KAGHAgN6eOebmSW/JAtlWTTzaoUK
         D6vnoeABjjkQg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4D6BD60A6F;
        Tue,  1 Jun 2021 22:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: enetc: catch negative return code from
 enetc_pf_to_port()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162258600431.8548.9090038985462098109.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 22:20:04 +0000
References: <20210531161707.1142218-1-olteanv@gmail.com>
In-Reply-To: <20210531161707.1142218-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 31 May 2021 19:17:07 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> After the refactoring introduced in commit 87614b931c24 ("net: enetc:
> create a common enetc_pf_to_port helper"), enetc_pf_to_port was coded up
> to return -1 in case the passed PCIe device does not have a recognized
> BDF.
> 
> [...]

Here is the summary with links:
  - [net-next] net: enetc: catch negative return code from enetc_pf_to_port()
    https://git.kernel.org/netdev/net-next/c/37d4b3fdc55d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


