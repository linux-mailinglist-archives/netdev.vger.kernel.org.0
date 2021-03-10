Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D03334950
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhCJVAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:32802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232040AbhCJVAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 16:00:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8139B65021;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615410013;
        bh=ixLFLtX9TBn+PRmDFp6fdu1CTtYRGfNedGhxGDgrzPQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P0OF34NGKCIfifJnexBdrQJ9JXPqs0whzoQfeqNKt0AYYQ9tN0wP7BS36kwYeQo/v
         2J5HTwHkD42bni/HxVMccoI0w/z9L7tZzf57vA0UJc3S7SVpkPmwt1EA6Cb3xzPMdp
         8vfjqPHUihqxu/RjpN4qxqHGN/uCi3nRnZdNY87F0RxPGEimPOqJm7cAu2EvmeKHuw
         9RDA91SfIG/9iG3lr7PJHxuXAF1GUMyB9JpEyGSyeblZQ0Yde3fVct3i+ux5fUy8IZ
         V678oRTug1WJrfhpEsW6OUrHdCgXGhMLSOsFN3wg8JXWB2GARpl/oz4LiTZSl2r1gf
         8EK8cNLFo3qxw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 771A4609BB;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: add a helper to avoid issues with HW TX
 timestamping and SO_TXTIME
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541001348.4631.14974932942011425474.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 21:00:13 +0000
References: <20210310145044.614429-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210310145044.614429-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, po.liu@nxp.com,
        claudiu.manoil@nxp.com, vinicius.gomes@intel.com,
        richardcochran@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Mar 2021 16:50:44 +0200 you wrote:
> As explained in commit 29d98f54a4fe ("net: enetc: allow hardware
> timestamping on TX queues with tc-etf enabled"), hardware TX
> timestamping requires an skb with skb->tstamp = 0. When a packet is sent
> with SO_TXTIME, the skb->skb_mstamp_ns corrupts the value of skb->tstamp,
> so the drivers need to explicitly reset skb->tstamp to zero after
> consuming the TX time.
> 
> [...]

Here is the summary with links:
  - [net-next] net: add a helper to avoid issues with HW TX timestamping and SO_TXTIME
    https://git.kernel.org/netdev/net-next/c/847cbfc014ad

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


