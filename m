Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7DB534B265
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhCZXAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:00:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230142AbhCZXAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 19:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D063061A4D;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616799612;
        bh=E99klQEJ/mgFinVQR2cwQHhYGfzcyqgaf6uidtZd7u4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DJVxNhzLfMx+onVJ5jhSVW2zMYdYd1wJpA7tDioFetqv1T4EOqGVS/9qVh7QKT58p
         6PM5eOR8mwUsg+te+M0XdTWSDcn8VSbwKIxDvBwT32QCZZgSBx61bVLtUXSTZCml3Q
         ARSxGNwBfD9fQlD9YXNaLd2uMrvJ7jt+ZtPN3P9XRe/okZWKfK36xD2+c4fkqaX3zW
         3pKeuNBOp0bQb3jev6IVhseWDrY0JLC2p4pGvw5/Dd1bv1t6dgGm3tqykS8EBk48CB
         1ImnQGzFOIzISaMwEBLzGDMkpDrnpdLQ5AkMcyb6HFOdMyHSZcs7kh8REar9uMGF8v
         XV8/lZNUK7fWw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B0D4B60970;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] ethtool: fec: Fix bitwise-and with ETHTOOL_FEC_NONE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161679961271.14639.16724597651328898788.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 23:00:12 +0000
References: <20210326142733.557548-1-colin.king@canonical.com>
In-Reply-To: <20210326142733.557548-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 26 Mar 2021 14:27:33 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently ETHTOOL_FEC_NONE_BIT is being used as a mask, however
> this is zero and the mask should be using ETHTOOL_FEC_NONE instead.
> Fix this.
> 
> Addresses-Coverity: ("Bitwise-and with zero")
> Fixes: 42ce127d9864 ("ethtool: fec: sanitize ethtool_fecparam->fec")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - [next] ethtool: fec: Fix bitwise-and with ETHTOOL_FEC_NONE
    https://git.kernel.org/netdev/net-next/c/cf2cc0bf4fde

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


