Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA52F3ABC87
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhFQTW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:22:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233248AbhFQTWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 15:22:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 63486613E7;
        Thu, 17 Jun 2021 19:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623957613;
        bh=ejbi4RURQrGCoKI8yVzwJ+te8dAjfsRwIB4Fdp6jeBE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VKulPuFyizmX8ss4sx1pZ0fK29eFt9rS1QBhL/jo2+b1dsrN2uI3BzvFnFasaaDmH
         DywgHqT0c76Y55TtUXV/liRfY/ScN8+k+iYvVlp19gERiY6WFDZMXiKXPs425I7Tp7
         MyvRt9wbmCaM+ay71vBaTCX6/UNLNS+KHvVPsceIWAT4+u+C2yJkCdfAJUet+1BwtS
         iVQcYqlntUPUFIfL9q5BcG8gNMD61HW9gcKsMadp6UqZ8dS1lWgSALQK+0PSAxR+qU
         eJgughKMNJHrYBwPAJA/zAWdz2URDIodX3A5khclbuFOkBk+U+916FaIHgNpX0ar5p
         Qom5SoO4j+5ig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 54D2E60A6C;
        Thu, 17 Jun 2021 19:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/6] net: gianfar: 64-bit statistics and rx_missed_errors
 counter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162395761334.22568.1258823578567953392.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Jun 2021 19:20:13 +0000
References: <cover.1623922686.git.esben@geanix.com>
In-Reply-To: <cover.1623922686.git.esben@geanix.com>
To:     Esben Haabendal <esben@geanix.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rasmusvillemoes.dk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 17 Jun 2021 11:49:12 +0200 you wrote:
> This series replaces the legacy 32-bit statistics to proper 64-bit ditto,
> and implements rx_missed_errors counter on top of that.
> 
> The device supports a 16-bit RDRP counter, and a related carry bit and
> interrupt, which allows implementation of a robust 64-bit counter.
> 
> Esben Haabendal (6):
>   net: gianfar: Convert to ndo_get_stats64 interface
>   net: gianfar: Extend statistics counters to 64-bit
>   net: gianfar: Clear CAR registers
>   net: gianfar: Avoid 16 bytes of memset
>   net: gianfar: Add definitions for CAR1 and CAM1 register bits
>   net: gianfar: Implement rx_missed_errors counter
> 
> [...]

Here is the summary with links:
  - [1/6] net: gianfar: Convert to ndo_get_stats64 interface
    https://git.kernel.org/netdev/net-next/c/d59a24fd1bdb
  - [2/6] net: gianfar: Extend statistics counters to 64-bit
    https://git.kernel.org/netdev/net-next/c/2658530d797f
  - [3/6] net: gianfar: Clear CAR registers
    https://git.kernel.org/netdev/net-next/c/ef09487431a9
  - [4/6] net: gianfar: Avoid 16 bytes of memset
    https://git.kernel.org/netdev/net-next/c/e2dbbbe52c4a
  - [5/6] net: gianfar: Add definitions for CAR1 and CAM1 register bits
    https://git.kernel.org/netdev/net-next/c/8da32a1071af
  - [6/6] net: gianfar: Implement rx_missed_errors counter
    https://git.kernel.org/netdev/net-next/c/14870b75fe0b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


