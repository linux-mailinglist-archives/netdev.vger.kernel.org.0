Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3889563DF9
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 05:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiGBDUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 23:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiGBDUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 23:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601DA31939;
        Fri,  1 Jul 2022 20:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEAB361D49;
        Sat,  2 Jul 2022 03:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F4E6C341D2;
        Sat,  2 Jul 2022 03:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656732015;
        bh=OvuVpVPS6/GrGV2NzoMPgZ9Rp0c5IZsuTqh8AK//5cs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r5xN2FLHaFCRW/VEn1uPgTzB1wRFElRpIqMPGDOLgmbHwhy3aC41X+3DgbjMwRWSO
         U0yRGlZ6dO9fK6+N0xsQNjX0/SFDIuV+x3Dx803nzN+FwjfwpTXuWuHmvzhZYqj8kw
         VDgCJGdRskzBlgAveqaPMgqapy+DsK6KJ8Aev0z60RItKfoq00hjyU3LzAcSiKZRJV
         zJ9C+dMa4cFh5FN6hgtb80z6wfBjMo+yW9zRcXq03cBX5thtTtF4wNLcZ4Jka9Jn5u
         nbIpUuYnumxKhGXbvKfrUt3IXjQDbkBq+yrAjX4fOouXimN+xK4OM51O1JZKecjpdA
         k+cbcw1qz8+Gg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A916E49F60;
        Sat,  2 Jul 2022 03:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qlogic/qed: fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165673201530.6297.13790509676583179402.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Jul 2022 03:20:15 +0000
References: <20220630123924.7531-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220630123924.7531-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, aelior@marvell.com, manishc@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 30 Jun 2022 20:39:24 +0800 you wrote:
> Delete the redundant word 'a'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_int.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - qlogic/qed: fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/04740c53cac4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


