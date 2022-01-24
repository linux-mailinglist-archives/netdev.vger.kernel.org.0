Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50EB498046
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 14:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242782AbiAXNCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 08:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239721AbiAXNC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 08:02:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82383C06173B;
        Mon, 24 Jan 2022 05:02:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08F1CB80F98;
        Mon, 24 Jan 2022 13:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1322C340E1;
        Mon, 24 Jan 2022 13:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643029345;
        bh=nje50B4517VqOu/GSvwxl8SaiOfls+mUGaMg7iQTLF8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u/n7aYw2fZZjdNW+0jTkYJADmHP/3tSgp3xAOs2ZVEebSCh88sszP40CNLhoZAS/n
         phzF6hINq0o4DjfIv3kx7GXSg3JqYXInuK9keOP8DU617iALOitzA0Az8U+dM/FzPk
         UnkyfNU2+Bf4QAjdUd3xmZePYpM+huR+UuZiGhKSEOAdEL9Ttm4h9M9JLdNEyZHerk
         dI9FYXzmFIF8uUvtl4tYu0KPW9zWet5iwduEklVAaCAaPIim5q7LwoYy7ptvaXzbJS
         j5x0KH73gYMBK1EFXTvGN1EBUWJkAaQRvE3pf91xix5bD3oU5PdIQAYJJj5liKB0CQ
         AsdlijJioI1sg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98996F6079B;
        Mon, 24 Jan 2022 13:02:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: atlantic: Use the bitmap API instead of hand-writing it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164302934562.10228.6268047056193544757.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Jan 2022 13:02:25 +0000
References: <27b498801eb6d9d9876b35165c57b7f8606f4da8.1642920729.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <27b498801eb6d9d9876b35165c57b7f8606f4da8.1642920729.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     irusskikh@marvell.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 23 Jan 2022 07:53:46 +0100 you wrote:
> Simplify code by using bitmap_weight() and bitmap_zero() instead of
> hand-writing these functions.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/aquantia/atlantic/aq_filters.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Here is the summary with links:
  - net: atlantic: Use the bitmap API instead of hand-writing it
    https://git.kernel.org/netdev/net/c/ebe0582bee78

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


