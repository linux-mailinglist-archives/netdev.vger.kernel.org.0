Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF4B64A531
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 17:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbiLLQnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 11:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbiLLQnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 11:43:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC6D15715
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 08:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BF5F61163
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 16:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82C47C433EF;
        Mon, 12 Dec 2022 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670863215;
        bh=rCK7dVdAbNO7R5/9ECmOsW4aVOrAtiKHWCrHO6pF1Ec=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V+MtGghMFahJUvZnZS7VsjTIT8QHzljyaVST+6BsN9kCUsOFi3CajvzSE5vJp1MJP
         j5r96F5adF01TVaYBySHg0G7mXnu8OyqTddmhzbQPdAP/xW8UT+BXtbF+yPYFB6pN6
         p7KP/BLl31/gyz0K560jCmVLGaNa0XCKoe9m8IdWZB+ndFb/AV/HsQOzQHHTgzkOTC
         T+zVI9eFsl4qm38+IcfQ3ucMfRqgiE+Ig7z9zAcM7OwV8AicCSiEwYUtdYjnTOmo4a
         SoeZusGUUDzhcJgQ4KB1hwPfG9nvX4kizdArGFUBbBX3lVxPgmIBILVBEUu5pTYGou
         37Hx/hsOoyH4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69891E21EF1;
        Mon, 12 Dec 2022 16:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] iplink: support JSON in MPLS output
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167086321542.24969.7742528363826860679.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 16:40:15 +0000
References: <20221210034648.90592-1-stephen@networkplumber.org>
In-Reply-To: <20221210034648.90592-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  9 Dec 2022 19:46:48 -0800 you wrote:
> The MPLS statistics did not support oneline or JSON
> in current code.
> 
> Fixes: 837552b445f5 ("iplink: add support for afstats subcommand")
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  ip/iplink.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)

Here is the summary with links:
  - iplink: support JSON in MPLS output
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=13cd02228fd6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


