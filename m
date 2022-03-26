Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA374E845F
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 22:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbiCZVVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 17:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbiCZVVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 17:21:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346645576F;
        Sat, 26 Mar 2022 14:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55C7460E8C;
        Sat, 26 Mar 2022 21:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC3C1C34110;
        Sat, 26 Mar 2022 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648329610;
        bh=0uIKyawOLoHLm394PBEW9HSFN9iKeMVQMYPJNL5EEfo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QRWtOB8X+n+tNJyT813j4O4KjEvNscKDBDZXoo+mVYdnNM06tWh2+qREZYbW+Jgwo
         98FMcDt87x2y8jvYiR44ERmIyvLRgV5SJUwLpSZteib35Ly56G98muBE6+2j54o2q4
         lkUnBzOe7fy9VTuQdWB9P2EPW13GUekfxG7LnfC/t85bAh8sK4oUcIUW6emXXcwcEf
         8DhqlYJocO5D5Hc3SFbSy7kd9n0ObT8mpVX1VD7dzlfZyOJEH0h6sPiBVaol/sMli6
         /4cO+to8It906fVj58HQuCdJYVqHvrQS7sCzUPIEms+0zaXmGychYv8GozYw02Tgoj
         796fDx+Ajla3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B88AF03849;
        Sat, 26 Mar 2022 21:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-af: initialize action variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164832961056.3419.13458141974807020265.git-patchwork-notify@kernel.org>
Date:   Sat, 26 Mar 2022 21:20:10 +0000
References: <20220326160306.2900822-1-trix@redhat.com>
In-Reply-To: <20220326160306.2900822-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com,
        Sunil.Goutham@marvell.com, naveenm@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 26 Mar 2022 09:03:06 -0700 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this representative issue
> rvu_npc.c:898:15: warning: Assigned value is garbage
>   or undefined
>   req.match_id = action.match_id;
>                ^ ~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - octeontx2-af: initialize action variable
    https://git.kernel.org/netdev/net/c/33b5bc9e7033

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


