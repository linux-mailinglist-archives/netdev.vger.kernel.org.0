Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2015546341D
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241538AbhK3MXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241508AbhK3MXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:23:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B92C061748
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 04:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D27A3CE198E
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0530DC58319;
        Tue, 30 Nov 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638274810;
        bh=j/2T7udC5wsDZugIkXnjsFiaAOqYy1DiyCiDPRXfvHE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jaq7dND4gFbltlmT2fAA6ecDK4c9/D/+mkRB3zRqiKyucgQNYhliGUQBeFYj9vlJ5
         weq5wloQOEqIhInopEvZaetL5HucKUWJxGJEvrf2tz88dvH3udX6vgrSV2v2QqtOnV
         Q9ilQKe4uIUGeMui3loq8kujLuy9uocblAa0Y3+ZZlO/Y/IbaCrSIgP85F9moJb6IS
         QgV7cKpV/Kjsa+Db9zYryNnRDHh5nA21sf93xMxeAHG02DJiCdXVUolLCnCt15pgIM
         5q/r3+l53OEgE6EAXqsF04MttUhQ9ctbkjBLdc+HgyxC/5LefDG8OSP0fzIr5QqQB6
         5np5q+rSCRQFw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E355B60A94;
        Tue, 30 Nov 2021 12:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: cxgb: fix a typo in kernel doc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827480992.28928.14905391090925940059.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:20:09 +0000
References: <20211130070312.5494-2-sakiwit@gmail.com>
In-Reply-To: <20211130070312.5494-2-sakiwit@gmail.com>
To:     =?utf-8?q?J=CE=B5an_Sacren_=3Csakiwit=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        andrew@lunn.ch, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 00:03:11 -0700 you wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> Fix a trivial typo of 'pakcet' in cxgb kernel doc.
> 
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb/sge.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: cxgb: fix a typo in kernel doc
    https://git.kernel.org/netdev/net-next/c/6167597d442f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


