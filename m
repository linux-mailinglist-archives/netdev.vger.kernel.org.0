Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F04590603
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 19:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbiHKRk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 13:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235659AbiHKRkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 13:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21AFBC33
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 10:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAEAC60F37
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 17:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40186C433B5;
        Thu, 11 Aug 2022 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660239614;
        bh=8TKBjgAr0z5ukseSYXU9EJAokz0U85Nag1EQlPuep2I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pGNePsltJu/QNEY6BwkhM0R/BTKubrfxnl93sdpria0JncKRW949rVMYF1oSHSwr1
         Pz8RIf38DWkFuzk/VS0C7oiOKLe1umb30ZiuaYWGo3iKGpLoP2zAvY2SCsLFGQt3ae
         GDQmpIDG+AP22nFM0ouRE6Eqscreip5JOdTvWGkDZ8pbTNdF9cN+9C3jqEhkW/V0NA
         SLh4TlbJPrjyHUrGzx8ZboyH1nRfO7FUWQGoA/ScDZDirltD+CWnh+hPy9Jwk2ZPMm
         X7Rdc/6MuPWd+INRuXAFbrGBLM4X9mv8eJARzsSTNGGl1QNHGrMo7bsOHJNdW0Tk7h
         M3mhhYMKBDwGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 27982C43144;
        Thu, 11 Aug 2022 17:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: add missing kdoc for struct
 genl_multicast_group::flags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166023961415.31756.821324678513060798.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Aug 2022 17:40:14 +0000
References: <20220809232012.403730-1-kuba@kernel.org>
In-Reply-To: <20220809232012.403730-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, fw@strlen.de
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  9 Aug 2022 16:20:12 -0700 you wrote:
> Multicast group flags were added in commit 4d54cc32112d ("mptcp: avoid
> lock_fast usage in accept path"), but it missed adding the kdoc.
> 
> Mention which flags go into that field, and do the same for
> op structs.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] net: add missing kdoc for struct genl_multicast_group::flags
    https://git.kernel.org/netdev/net/c/5c221f0af68c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


