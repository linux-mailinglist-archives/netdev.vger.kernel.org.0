Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C665053A2
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 14:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240662AbiDRNAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 09:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242133AbiDRM7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 08:59:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B272F03F;
        Mon, 18 Apr 2022 05:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12833611CF;
        Mon, 18 Apr 2022 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72F6CC385AB;
        Mon, 18 Apr 2022 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650285611;
        bh=UjHumYdc82wnlGeLD8eIQ3nUM8EQ3vQ7nmLedHMKBXg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YgdYlJ9AqdKVrWfttDHxPsYex/q7y6zIsnrHEBEFu9URRRuVnheH8cfMaF+y77DBh
         X+PCT7d1zPmNdaSX+AAt2e/wn/U0nuNC34dLHQLjJnXZ2oY1meYMNEvwp2nCx4RtSH
         YLNwCvomYiBKPbyrrVk11ETL/nvxKGEGIi8mSBtyj1tyvAthzqDZ01cYQFxNfGybc1
         W51eH+w0DjNIMie4pHX3vCUwLL66ZzGkE8Fu8nJfyXWCOakpCnMpbwtDuEXDwbxVOd
         NtTC+E9BCRe60UUv9ZrG2prmifxEFKHwp0kn5NFRmf9kGoGUJQkH+qWPB/cZWd7qcw
         onI1dZs96VQWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58A83E8DD13;
        Mon, 18 Apr 2022 12:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: atlantic: invert deep par in pm functions, preventing
 null derefs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165028561135.26453.17217915183447099984.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Apr 2022 12:40:11 +0000
References: <87sfqaa8n5.fsf@posteo.de>
In-Reply-To: <87sfqaa8n5.fsf@posteo.de>
To:     Manuel Ullmann <labre@posteo.de>
Cc:     irusskikh@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, regressions@lists.linux.dev
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
by David S. Miller <davem@davemloft.net>:

On Mon, 18 Apr 2022 12:17:02 +0000 you wrote:
> From: Manuel Ullmann <labre@posteo.de>
> >From 6c4cd8210835489da84bf4ee5049945dc0f2c986 Mon Sep 17 00:00:00 2001
> Date: Mon, 18 Apr 2022 00:20:01 +0200
> 
> This will reset deeply on freeze and thaw instead of suspend and
> resume and prevent null pointer dereferences of the uninitialized ring
> 0 buffer while thawing.
> 
> [...]

Here is the summary with links:
  - net: atlantic: invert deep par in pm functions, preventing null derefs
    https://git.kernel.org/netdev/net/c/cbe6c3a8f8f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


