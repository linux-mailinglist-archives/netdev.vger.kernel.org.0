Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7966A5041
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 01:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjB1Aqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 19:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjB1Aqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 19:46:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0439B1E9DD;
        Mon, 27 Feb 2023 16:46:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0AADB80DDA;
        Tue, 28 Feb 2023 00:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51879C4339B;
        Tue, 28 Feb 2023 00:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677545196;
        bh=8mHk19AjQuJa9XYTgMsCu7A9O/jXCgpG4Oguslh76kw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hni33q/1aFAIPcbsi/tjl44ZjiK0nLYkepyno62CMbLfhxGTA0nBDT+23BzNhYhcd
         bF1C6CgB7OSFVKfW0C1NSnD2K8elZKZ/WbNHcH94xDK4c/Y5b/Jc3jeGzJD6tUeHV9
         8k5XbIkhTmpx9ml0XjuNVrrb0zsWCbGiJkqDdFQIIQMix42N/Jf+BiS05577mZ8ryh
         7dL4U9D8JoaX74pFtghZiCXL8RiDY1L4mnck2tFAoTS5lH0Um/Em3sBmrGkvKO8580
         HAnVbn7SQ9BKOOmHKgzEEqjLPJ7ubcHbqKXFso0QGI5Fw2un/NYASNpGVnteVQScWG
         6Tvyp0kaQhi7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30F03C41676;
        Tue, 28 Feb 2023 00:46:36 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2023-02-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167754519619.16363.3451389364009193293.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Feb 2023 00:46:36 +0000
References: <20230227131053.BD779C433D2@smtp.kernel.org>
In-Reply-To: <20230227131053.BD779C433D2@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 27 Feb 2023 13:10:53 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2023-02-27
    https://git.kernel.org/netdev/net-next/c/4db692d68256

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


