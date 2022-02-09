Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484194AE951
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239564AbiBIF2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:28:07 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbiBIFU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:20:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00582C03C1A2
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 21:20:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABF1FB81ED8
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7706AC340F3;
        Wed,  9 Feb 2022 05:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644384028;
        bh=DmfQ74uyq1ShaIt4nOAhtDHHHQgakhF+2A6sD17/laY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oPeLx3e9z6YgaGXvHtZ5QWI6d1r9QCp4iGyhNYxf692uO69y9D+S3mpDLiQyu2+Ys
         rNxhLpPYOFiuIeuBKiaa3bSPvjHb5RebbQjquTtZ+acBK6kotHXQxJvXYmgyhfokf1
         iB20usJ0DByUz3i3HUXklFGuPe0xqWxwrPckKTODUatG+A2uBYNrXGXII3Q5PH2sBA
         QZETNFBRNukIMI6t0qwUx/ffaDqHdZ057BzptjHWGc70cpliZAfNfG8mySrqk9r1+C
         91qLLz3/coYp8EJ92LQtPwDQgSAYS4i4R0uGwxefowH4lVBPBt5XN1D3q94mNKw8iK
         +lj/pkAzdJjqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60A04E5D084;
        Wed,  9 Feb 2022 05:20:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: flower: fix ida_idx not being released
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164438402839.12376.922923367113776157.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 05:20:28 +0000
References: <20220208101453.321949-1-simon.horman@corigine.com>
In-Reply-To: <20220208101453.321949-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, louis.peens@corigine.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  8 Feb 2022 11:14:53 +0100 you wrote:
> From: Louis Peens <louis.peens@corigine.com>
> 
> When looking for a global mac index the extra NFP_TUN_PRE_TUN_IDX_BIT
> that gets set if nfp_flower_is_supported_bridge is true is not taken
> into account. Consequently the path that should release the ida_index
> in cleanup is never triggered, causing messages like:
> 
> [...]

Here is the summary with links:
  - [net] nfp: flower: fix ida_idx not being released
    https://git.kernel.org/netdev/net/c/7db788ad627a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


