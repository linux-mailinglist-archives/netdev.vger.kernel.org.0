Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6363B5F12FF
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 21:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiI3TuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 15:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbiI3TuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 15:50:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E5937187
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 12:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 804A4B829DB
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 19:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45826C433D7;
        Fri, 30 Sep 2022 19:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664567416;
        bh=wB5jPFoxlqJTUHNgRqvi14LNqYYdRdNHAwhaXPpMf6o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M3IvxijQsmtkyppVvQMiwr9ieVOzzHqwteq0wSYVFu8X9Susfk1+JSoSffJGFjlJA
         38zUEnvIKI+411SLA7Z3yUL5ZsH2DznH0Rfru39/6b5newQe/3u5Fs+gGaHq4vQWKP
         7+ESNn2XRqgn1aSLZFBbH411BLka9kw0nRimqI1IzS62vYfLtZkgEubEzfrqN28d2+
         8mMs6Op15chBcNlWwShlQgd2SdrZmXD/9AHW7L9hAShus5CrJfCJ9LxTr7usnGh+O6
         5b8nTvMHNgTYycpnA2hC8iDX74lHax1/saAMYTL+QAgwX5JpVPhnV7khUnfD0/pTnX
         gNXmOUFFw1Tyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B959E4D013;
        Fri, 30 Sep 2022 19:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] devlink: fix man page for linecard
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166456741617.21102.14406785805334622973.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 19:50:16 +0000
References: <20220930194411.73209-1-stephen@networkplumber.org>
In-Reply-To: <20220930194411.73209-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, jiri@nividia.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Fri, 30 Sep 2022 12:44:11 -0700 you wrote:
> Doing make check on iproute2 runs several checks including man page
> checks for common errors. Recent addition of linecard support to
> devlink introduced this error.
> 
> Checking manpages for syntax errors...
> an-old.tmac: <standard input>: line 31: 'R' is a string (producing the registered sign), not a macro.
> Error in devlink-lc.8
> 
> [...]

Here is the summary with links:
  - [iproute2] devlink: fix man page for linecard
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=86c9664092a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


