Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B4D6466AA
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiLHBuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLHBuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336739074B;
        Wed,  7 Dec 2022 17:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4D3761C4F;
        Thu,  8 Dec 2022 01:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 225BAC433D7;
        Thu,  8 Dec 2022 01:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670464217;
        bh=UIHtKtHvTL/2n27bUw1jPwdAPQCKa3/iuuM/BF33/kY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p0V45/98POz4vE5Lnesym4Q0XQEafZgG5t8YmQ/PDiSj7bYuL04f2rH7M/Y6xxXzz
         9hCA+nZpxcQIkpI1SkP4EdusL5vBfk5KQDJ9g5chLhSpUQ1Do8DpOR1qBSrMnz0YX6
         JxFLixfNNDqZKMHnSVIZjajN9uh7zcFwP52+Xv2Wm/WWI39FGByClWjsey31gsM/gc
         ziQmoMzwP3alqWSqrljgt8SEd5MZ+BD0sRBYRbWCQUV88tM6XgAfH+92dCqM87ea/T
         KLZcVt6DHF5iCC/uMdGOCOdiT8l+CcNJutJYnAvHAY3PfL/seQD5Ct2m3edjaHv2tf
         nxa27wNKCtoUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 06767E29F38;
        Thu,  8 Dec 2022 01:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154-next 2022-12-05
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167046421701.13767.2311529768713425185.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 01:50:17 +0000
References: <20221205131909.1871790-1-stefan@datenfreihafen.org>
In-Reply-To: <20221205131909.1871790-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  5 Dec 2022 14:19:09 +0100 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for *net-next*
> 
> This is the second pull request from wpan-next this cycle. Hoping its still on
> time we have a few follow ups from the first, bigger pull request.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154-next 2022-12-05
    https://git.kernel.org/netdev/net-next/c/cfbf877a338c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


