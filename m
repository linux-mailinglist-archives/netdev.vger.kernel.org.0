Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C444AA651
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 04:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379275AbiBEDuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 22:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiBEDuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 22:50:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6A9C061346;
        Fri,  4 Feb 2022 19:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 011C5B839A4;
        Sat,  5 Feb 2022 03:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A008BC340EF;
        Sat,  5 Feb 2022 03:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644033008;
        bh=mXGGPzkMphVN/vNDxO0Db/r+CxmdI8M2QTgO5oSLptc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VtIlM+aj4dj+XxwnH5ONF2STs0o9OvMrnAlzxilwbHCCcykHMNviVK1zXjE94623D
         btnYCKQeTY7dL5J/HTCkZVb4Dr6n93ALiBvI9ATq1o/kUgk2MyzOxWWfgyH0a8bUOu
         RAyqQU+erdufyB0MTG7T+xbEtWioSrYM4YOqf3Md6LcomFYER38OBZWLC9NEzGcPvK
         rZ2XnulrYOdsHcYcSr1IFRc4ntyUHnOY05Dxu0IzV2qZxeA9DYVHiL09C1wv/5ZLVE
         kogoqrkKxNQvJDjtc5EUk/9Tf1kDr4wf1g6hzrMWLIjMkGqYqRgIgG6OX9o/ptxtSv
         WUtL1bwsqzhIw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 802D3E5869F;
        Sat,  5 Feb 2022 03:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: don't include ndisc.h from ipv6.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164403300852.24542.401822864711989941.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 03:50:08 +0000
References: <20220203231240.2297588-1-kuba@kernel.org>
In-Reply-To: <20220203231240.2297588-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jk@codeconstruct.com.au, stefan@datenfreihafen.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        oliver@neukum.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        alex.aring@gmail.com, jukka.rissanen@linux.intel.com,
        matt@codeconstruct.com.au, linux-usb@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  3 Feb 2022 15:12:40 -0800 you wrote:
> Nothing in ipv6.h needs ndisc.h, drop it.
> 
> Link: https://lore.kernel.org/r/20220203043457.2222388-1-kuba@kernel.org
> Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>
> Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: don't include ndisc.h from ipv6.h
    https://git.kernel.org/netdev/net-next/c/c78b8b20e349

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


