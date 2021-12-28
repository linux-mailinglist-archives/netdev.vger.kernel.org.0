Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D60E48090A
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 13:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhL1MUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 07:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbhL1MUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 07:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF75DC061574;
        Tue, 28 Dec 2021 04:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53995611E0;
        Tue, 28 Dec 2021 12:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7DB7C36AEB;
        Tue, 28 Dec 2021 12:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640694009;
        bh=ZqpNAYZslppWZAxjgspaQbIdA3KXNlCzslcoXk+px7w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yh0FK3eQNTf9BuUJgC8K0liaqz8H+4LI4UDhvbCQ9QqMXRg34iskTpGRlqcfYII2M
         vA/U+1flea/CcDQ/vGoJ+vqPJHkRbvDgLJpPlCYLAo5NqnrbLW+VsybPiQSA73o+/s
         C7KZCvz8uBkT1nxm+isS9K8S7BTdMYr3gFLr+MAtzavoZYJ6yMqPsn6zIwUo3SORsx
         FGV0f6nAikmj+6n2cPQc6kmGSaZsA6XfgfTKUqmXaaLw7cSNlX8kkQCA9PgMtrc4ZS
         Y+1I9NbT2KpQyRsV4pawHC+VuygmiHk9AHwI0r8v9Jst8uFbPrXYnbOmSnps8aUnGq
         C/mOvuf1xMasQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 845DBC395E8;
        Tue, 28 Dec 2021 12:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ag71xx: Fix a potential double free in error handling
 paths
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164069400953.26128.4657256476646014759.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Dec 2021 12:20:09 +0000
References: <b2da37192380cdb9e81cad6484754b3159d12400.1640541019.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <b2da37192380cdb9e81cad6484754b3159d12400.1640541019.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, linux@rempel-privat.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 26 Dec 2021 18:51:44 +0100 you wrote:
> 'ndev' is a managed resource allocated with devm_alloc_etherdev(), so there
> is no need to call free_netdev() explicitly or there will be a double
> free().
> 
> Simplify all error handling paths accordingly.
> 
> Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - net: ag71xx: Fix a potential double free in error handling paths
    https://git.kernel.org/netdev/net/c/1cd5384c88af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


