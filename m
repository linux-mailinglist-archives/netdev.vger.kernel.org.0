Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11CB3B6B37
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 01:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbhF1XNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 19:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236608AbhF1XMi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 19:12:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 198F761D08;
        Mon, 28 Jun 2021 23:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624921812;
        bh=fxoPPkezoq09U1qbqIWrKlH5vEDlaCz1ty2xT3XSrEE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kb+wqh5fq71WIMagv4QK5G+EaDzj4O6VdYReR09+wcVSBUweL4SYfyNHjZ9f2H4JH
         U1EDB7RuU0fpXimmoMqdMXPLYwRAICtDn+KACVbQkCtXx3K74wRBJ55f0dxxPPUZs7
         pSbxYSOEM6ROFLWBEBOZ6NMIRDfDxF5Q7oLMjdQ0rdICHMSEsku5+CXIgDc4/LPJB+
         EqOkXEp8eh7Yk96f9I+qnTJCv7YLtxoMrVcae/WJdfhRtW4EddVVbrv1g4KrJcxWXh
         AeagGwN5hSqMpVQU9fbAGjtjH9KOaITX5uQvjZ7bGt8P+mWwLSFXPXgotWaU37K0ZC
         H/PX/q9/+tz5g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 09BD260D08;
        Mon, 28 Jun 2021 23:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: mrp: Update the Test frames for MRA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162492181203.29625.17848811968952266150.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 23:10:12 +0000
References: <20210626201804.1737815-1-horatiu.vultur@microchip.com>
In-Reply-To: <20210626201804.1737815-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 26 Jun 2021 22:18:04 +0200 you wrote:
> According to the standard IEC 62439-2, in case the node behaves as MRA
> and needs to send Test frames on ring ports, then these Test frames need
> to have an Option TLV and a Sub-Option TLV which has the type AUTO_MGR.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_mrp.c         | 27 +++++++++++++++++++++++++++
>  net/bridge/br_private_mrp.h | 11 +++++++++++
>  2 files changed, 38 insertions(+)

Here is the summary with links:
  - [net-next] net: bridge: mrp: Update the Test frames for MRA
    https://git.kernel.org/netdev/net-next/c/f7458934b079

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


