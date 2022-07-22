Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4347B57E12B
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 14:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiGVMAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 08:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbiGVMAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 08:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88B0E03D;
        Fri, 22 Jul 2022 05:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70F5061E86;
        Fri, 22 Jul 2022 12:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8785C341C7;
        Fri, 22 Jul 2022 12:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658491214;
        bh=1j7PW/sFyD9QjxYJpGlIH5c6bmVwAeW+UkAQK9QsJSE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EhwAVBDnksS07Kke8xZwIGKi1vMn2nNHCkJF/8y2wG7fBPpUhCXYrdN5izT51TCvk
         r3a21taZpHuLLEJFzcphVWivIJaEdK92VX/rTVXYvlokZpiqd5K16XAdLYwy+S/cnN
         mMtNy1dT+LxaA36tr8xaMBY9xeYJfbse49L7E7+gka83o7+HgGtWn+Gv1+t0Xcw81c
         l0PyPp1ymrJo+aXPMzDYQElIyqxSgOc6CwCWQfBI6RTMtjjxMiLzwUWrgLgPuGnX80
         2vxc1WF68gzAIIIjVpg6mF7SxgmrRqZxvWrJpcoTqy/5WBCzYTX5CIOLcSaUhctzOr
         z2fq2GCgpC53Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A69A9E451BB;
        Fri, 22 Jul 2022 12:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] caif: Fix bitmap data type in "struct caifsock"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165849121467.11142.18393766946931766129.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 12:00:14 +0000
References: <b7a88272148a30cf2d0a97f2e82260a0dcb370a1.1658346566.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <b7a88272148a30cf2d0a97f2e82260a0dcb370a1.1658346566.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 20 Jul 2022 21:49:46 +0200 you wrote:
> Bitmap are "unsigned long", so use it instead of a "u32" to make things
> more explicit.
> 
> While at it, remove some useless cast (and leading spaces) when using the
> bitmap API.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - caif: Fix bitmap data type in "struct caifsock"
    https://git.kernel.org/netdev/net/c/8ee18e2a9e7b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


