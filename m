Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F094C8E40
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 15:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbiCAOuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 09:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235415AbiCAOuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 09:50:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDBC9284D;
        Tue,  1 Mar 2022 06:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 663C7B81988;
        Tue,  1 Mar 2022 14:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13FB2C340F0;
        Tue,  1 Mar 2022 14:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646146211;
        bh=gA9o0xmz6RRxTdFGIbJNp+4yVSE256v/wl49/XRB9Q8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QDAE146Ow9/Ox35JDaM3EN7HCYmiH/E0VWCBJP3pwM7xQa/nJJ2dgJBLyz4BTeK2V
         rasJfMqAbr6fbOCk/1sSTjrfltwkECwsJRyRy105ZZJFJ3ypmVGDUSzP3vpETQ1wU8
         8Uo+rs5GQzty3cNTapxR6ub0rusjNmg2Q4CitUt0c8x5fQ8MB2mI3JnV9JHbSYNkfE
         gbfwuOIkkZxW7e5al56u2ljn/kTVA16V8jVNqrF2EHHeks8Zza4PSe+6azNQHi7BNr
         4e8q0IztvOK23BmvKQ2pQnG3OYxBLYNN4yKw0zGOB71iovV2fxdnzMDrOToaFBBp6J
         KBSx2CbzZVDjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EAA87E6D44B;
        Tue,  1 Mar 2022 14:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless 2022-03-01
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164614621095.32176.12951724521893502415.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Mar 2022 14:50:10 +0000
References: <20220301143948.57278-1-johannes@sipsolutions.net>
In-Reply-To: <20220301143948.57278-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
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

This pull request was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  1 Mar 2022 15:39:47 +0100 you wrote:
> Hi,
> 
> So now for the first time I'm sending a pull request
> from our combined tree ... let's see if I'm getting
> it right.
> 
> We actually still have quite a few fixes, but most of
> them trickled in through the last couple of days, or
> were still somewhat under discussion.
> 
> [...]

Here is the summary with links:
  - pull-request: wireless 2022-03-01
    https://git.kernel.org/netdev/net/c/b8d06ce712e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


