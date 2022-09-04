Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBFA5AC3E8
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 12:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbiIDKaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 06:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbiIDKaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 06:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD6B1E3D9;
        Sun,  4 Sep 2022 03:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33C2D60F53;
        Sun,  4 Sep 2022 10:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94C2DC433D6;
        Sun,  4 Sep 2022 10:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662287415;
        bh=4xItITvB09LXZTE/Dt2LR+Q6hPF+fmotlYZtZXDpR34=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N6tHprYenMBKba7marcqRvgUuxZPX+AN/e0oVlTA87j3thLqW6CWN97cKKoUx6R/G
         9UaBt1m0gu3i77vdvW/gldmOan705+yUKxDfwwqRCZDkxlg8a3iRfFcvwmAnfYZY53
         g2dOmpxtpKauj1y4SyEU8TqKZAe8pv1A08LqL4bbIl750OIY8Ko1yrTWYz5Rx77o1I
         rVDdsOc0EfkpVLKpftbWaXPHsumFgdqKvlt8tkOR6Hx8IyVvQciHMNCOU1EA1htM0G
         7kNDG59dPJOoGmfClBL9jytV+Qqyi6d9rbFTassP15GUY7aYFDKGjMDOt79K37ITC4
         RTZxqZqZ5TVug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 744E3C395DB;
        Sun,  4 Sep 2022 10:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2022-09-03
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166228741546.4621.14755594680799707752.git-patchwork-notify@kernel.org>
Date:   Sun, 04 Sep 2022 10:30:15 +0000
References: <20220903145618.77721-1-johannes@sipsolutions.net>
In-Reply-To: <20220903145618.77721-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
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

This pull request was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  3 Sep 2022 16:56:17 +0200 you wrote:
> Hi,
> 
> So here we have a set of fixes for the current cycle again,
> the one thing I know of that's been relatively widely reported
> is the aggregation timer warning, which Mukesh fixes by setting
> the link pointer. Also with various other fixes, of course, no
> less important.
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2022-09-03
    https://git.kernel.org/netdev/net/c/c90714017cb3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


