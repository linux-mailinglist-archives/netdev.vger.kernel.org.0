Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E86481C91
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 14:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239492AbhL3NkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 08:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbhL3NkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 08:40:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C870FC061574;
        Thu, 30 Dec 2021 05:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEFEE616DD;
        Thu, 30 Dec 2021 13:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28A0AC36AEF;
        Thu, 30 Dec 2021 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640871609;
        bh=SCpd+k2hQuqvRa/LUdzKFDSBwj6A8Ou8rza1SWTCyCo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LgRtqo4+jCxDUCca/TpVywtTXOy6USt2GoStoUEe2NYAUNmsExV7tULwPlrkyA24j
         2sus+mfnrZa+Cs6HQ2/g3C2DX+7sxec9mF1L7l3G+UKfNlQ/DE3URtPhwnQryibgxc
         B5XrVzGY84aELT7klnqL3HFn/cR9DWKIY1ncx8bUv0JydAyE2zD3Iq8a+S/VohD5fB
         hzXtAz8+FZleJqrQbQJN8mhMVK2OeJqIOdjUL9LuQpf34lmhz/B6WeUqj06B6/jmIT
         YcVUYe2CMnaWKZhanKNm+LngVoSTy0Wb1LJVZ1ZgsFIwGTpGqOJran4BSe+pOJKVi8
         E7xuQ2aT3iWiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 185B0C395E3;
        Thu, 30 Dec 2021 13:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/smc: Use the bitmap API when applicable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164087160909.13913.9270430560087118697.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 13:40:09 +0000
References: <2fe6e0424bed3ebd4098d3b881946ddf55342d1f.1640860762.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <2fe6e0424bed3ebd4098d3b881946ddf55342d1f.1640860762.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Dec 2021 11:40:40 +0100 you wrote:
> Using the bitmap API is less verbose than hand writing them.
> It also improves the semantic.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  net/smc/smc_wr.c | 19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)

Here is the summary with links:
  - net/smc: Use the bitmap API when applicable
    https://git.kernel.org/netdev/net-next/c/49dc9013e34b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


