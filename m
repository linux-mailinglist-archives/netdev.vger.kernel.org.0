Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDEC5917E1
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 02:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbiHMAuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 20:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiHMAuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 20:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EC4BE1
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 17:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E13761730
        for <netdev@vger.kernel.org>; Sat, 13 Aug 2022 00:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF1D0C433D6;
        Sat, 13 Aug 2022 00:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660351814;
        bh=WBxoPNsXOMMjG8wfDYFLQC5Kw7J/JHXCdo26WgxtivQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R21ceL5i+1uywsfJvYMfifCgQHImpJgNEl0+31xjxHBvOhASVVXnISIcimVMwCf4C
         FyswLc+lDYpqhkkxqzIFb5DY2riCJLFT3Q678nNKrlmvV8oBsEWWHNN0/6xUtkbK+y
         MEbUo/dkFncNdGK238l6kNyCU9RypWQZFLEzHJMnGSKFCVx+Ra4C8ljvMdUH9Ldnqf
         Tnyq593eQ90j8C2bs05vkjAPu3+d8YGFFdOJTp2ZqBBbFldYC5F4HZG7qE4MWH0Jwy
         9WGN1G7ta7KET4iFBwCSLKDVHb98AhysV4P+LxB4pyL+68kFv5LNAaJtJpHzANdehs
         PqXRs8GLy4mHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5E52C43144;
        Sat, 13 Aug 2022 00:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] fec: Fix timer capture timing in `fec_ptp_enable_pps()`
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166035181387.28473.17521290569896858039.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Aug 2022 00:50:13 +0000
References: <20220811101348.13755-1-csokas.bence@prolan.hu>
In-Reply-To: <20220811101348.13755-1-csokas.bence@prolan.hu>
To:     =?utf-8?b?Q3PDs2vDoXMgQmVuY2UgPGNzb2thcy5iZW5jZUBwcm9sYW4uaHU+?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com
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

On Thu, 11 Aug 2022 12:13:49 +0200 you wrote:
> Code reimplements functionality already in `fec_ptp_read()`,
> but misses check for FEC_QUIRK_BUG_CAPTURE. Replace with function call.
> 
> Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
> ---
>  drivers/net/ethernet/freescale/fec_ptp.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)

Here is the summary with links:
  - fec: Fix timer capture timing in `fec_ptp_enable_pps()`
    https://git.kernel.org/netdev/net/c/61d5e2a251fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


