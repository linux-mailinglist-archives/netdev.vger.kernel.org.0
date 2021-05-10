Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDB33799EE
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 00:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbhEJWVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 18:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231905AbhEJWVS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 18:21:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 132E761554;
        Mon, 10 May 2021 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620685212;
        bh=4oY1apo5/J7SvKAH0z7O3N0gLfuwPOnbbw0zclqHahc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=netWBYpNUpGUfqvQSQN3jF9KKDqXewPenHuUtCSq89fuwJ+FlGkN4ljg2ypZ1dmbE
         HqpJK/OFUe8Vj1sCw+zMlQfh9s2A067q1SKOqvL1P8DjzTepsWs3Myp4Bqfuuo00vL
         4mVorjipFXDHTKePG2J64uUTgfMG9olmd2+Y0y0vAXVu6fiXBZ47eC1RKhAC6IL/Qi
         KrIcz01lhizFr8vK6upvKDamxV76IVV/c8I6nvXKvXZRt41IMvk/DOBZ/Mgls0deom
         ZYM0MJSCZqJCg98lqkvqqRJfefFZj+g1SA+VYaivdESYoK1sbmYAqvKU9FxIi5mHq3
         M+5IfJKe3sfFg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 05BE760A6F;
        Mon, 10 May 2021 22:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] Add PTP support for TJA1103
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068521201.17141.3763962700851866302.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 22:20:12 +0000
References: <20210510153433.224723-1-radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <20210510153433.224723-1-radu-nicolae.pirea@oss.nxp.com>
To:     Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 10 May 2021 18:34:31 +0300 you wrote:
> Hi,
> 
> This is the PTP support for TJA1103.
> The RX timestamp is found in the reserved2 field of the PTP package.
> The TX timestamp has to be read from the phy registers. Reading of the
> timestamp works with interrupts or with polling(that starts when
> .nxp_c45_txtstamp is called).
> The implementation of .adjtime is done by read modify write because there
> is no way to atomically add/subtract a constant from the clock value.
> 
> [...]

Here is the summary with links:
  - [v2,1/2] ptp: ptp_clock: make scaled_ppm_to_ppb static inline
    https://git.kernel.org/netdev/net-next/c/9d9d415f0048
  - [v2,2/2] phy: nxp-c45-tja11xx: add timestamping support
    https://git.kernel.org/netdev/net-next/c/514def5dd339

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


