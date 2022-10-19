Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E974603818
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 04:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiJSCaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 22:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJSCaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 22:30:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF41BA909
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 19:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7353CB821E3
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 02:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22612C43470;
        Wed, 19 Oct 2022 02:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666146619;
        bh=doIOr83KkmqH3jXHguw7ALPGA/EjNTD3nfKCT4dh5kI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YWl6YttEPqGC/wOoGBScBwq/cgzu3pQjYoTFbLORiS82Q87kmoNAYFVZDU4grGPAR
         WOz+vM7m2z4Z1c45Uo89iiIi+HNQO6CNVTGZpmhVKUsaKNtKQ+g0J487kULxy3Lqbt
         xEHlhfMogMgaJJXT+isH9c+YJkgLk0yrbooYaK9VOUzNhl4v4X2l1d0fxLZWZa730L
         I3IhsNCOxorAAipjYSrEYYA/pSeY5Vd2LdUwRte9+DQ8zN8C09CTD8kphK960E8Nzq
         X3XtfIoR66MESYeR1KC9XVKsaqv0RBRExvfSbe3EYI0xfxYBWI4eiW3ePNlu7f60pS
         D2t0z1lOhhX7A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E66BCE52500;
        Wed, 19 Oct 2022 02:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ionic: catch NULL pointer issue on reconfig
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166614661893.8072.18200909096186189166.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 02:30:18 +0000
References: <20221017233123.15869-1-snelson@pensando.io>
In-Reply-To: <20221017233123.15869-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io, brett@pensando.io
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 17 Oct 2022 16:31:23 -0700 you wrote:
> From: Brett Creeley <brett@pensando.io>
> 
> It's possible that the driver will dereference a qcq that doesn't exist
> when calling ionic_reconfigure_queues(), which causes a page fault BUG.
> 
> If a reduction in the number of queues is followed by a different
> reconfig such as changing the ring size, the driver can hit a NULL
> pointer when trying to clean up non-existent queues.
> 
> [...]

Here is the summary with links:
  - [net] ionic: catch NULL pointer issue on reconfig
    https://git.kernel.org/netdev/net/c/aa1d7e1267c1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


