Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAC6462BB6
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 05:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238234AbhK3Edc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 23:33:32 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41996 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238233AbhK3Edb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 23:33:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8F703CE1771;
        Tue, 30 Nov 2021 04:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D00DC58327;
        Tue, 30 Nov 2021 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638246609;
        bh=cgy1nIS9X4AedMyJCUFrifZmfTUIV+5F+J6zzaWQsfE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hSkiKUAy6dr1VjifKmrM1/Hvn48URAB/RVFYnp+Btb2RS2kO2N+jPQWnOdQD4ZDzm
         H+COrQJHhuKWSfxmcHnECB7J+Xf0amUn9NawlljI7CHXa66uI818b99GcN30KwSIeE
         H5H6r2nxuRn8dNvBwoTnmp8NZMunw3vM3HUATqBPlemCpkTenpup/6S0xcedCQUaqo
         1RcoZMivukuYqmA60CeZNUEoTQ4jaPFq9HEzYaepf4hkGKI8yqAyThxA4IMHyyM0AW
         p1x3TQluTWH7ud7lAjOw24ysA6bTz6+F/zA9ogSdm+c0kH5//yseWxeUNIO/a/Gjav
         lVHK7iK7il0rQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7B00860A50;
        Tue, 30 Nov 2021 04:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethtool: netlink: Slightly simplify
 'ethnl_features_to_bitmap()'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163824660949.1110.7224603685200899861.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 04:30:09 +0000
References: <17fca158231c6f03689bd891254f0dd1f4e84cb8.1638091829.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <17fca158231c6f03689bd891254f0dd1f4e84cb8.1638091829.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 28 Nov 2021 12:03:30 +0100 you wrote:
> The 'dest' bitmap is fully initialized by the 'for' loop, so there is no
> need to explicitly reset it.
> 
> This also makes this function in line with 'ethnl_features_to_bitmap32()'
> which does not clear the destination before writing it.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - ethtool: netlink: Slightly simplify 'ethnl_features_to_bitmap()'
    https://git.kernel.org/netdev/net-next/c/72a2ff567fc3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


