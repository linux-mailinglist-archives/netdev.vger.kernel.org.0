Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BAE65109C
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 17:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiLSQkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 11:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiLSQkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 11:40:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1568A6541
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 08:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 919C96106E
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 16:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ECBCFC433F0;
        Mon, 19 Dec 2022 16:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671468018;
        bh=zkFZt6XrTKoeHtRZiMN4Wke5OsSf6uTqDxswv9F+ckQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gNG1/hTXaRMniM0a70dJ9TKW3yk87ZUAeeOSBlgz4Pwsa6j1zdTKfIOZ3CmyuG1Pb
         QBAi2OtUn+XPItM8rILu/cpW6KMTArqHqwoiSFqDNqiKokAqohn7FLf+mkcHre3/Qt
         WpSdl0MauurrQ7jIZw3jerXe9fzW1aCYDYypcJvC8zSF6d47/dQeqH0cIHcPesCKAm
         C133vyCI3trOPWBmwBDAOjLGxIRcburvX0nifez6TKx2oY4e+/tJ3cGkdQKktAYCi6
         FITSQTLjA/P1Oqtz95QFJOfBrVWOS3fxF1sSTEZW2bnrvn3wH/wdiSd4VlytpYiW02
         IBmhIc0w7LjEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3C63E21EF8;
        Mon, 19 Dec 2022 16:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch iproute2-main] devlink: fix mon json output for trap-policer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167146801786.14443.17666600704802890792.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Dec 2022 16:40:17 +0000
References: <20221215170056.170827-1-jiri@resnulli.us>
In-Reply-To: <20221215170056.170827-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, idosch@nvidia.com
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

On Thu, 15 Dec 2022 18:00:56 +0100 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> There is a json footer missed for trap-policer output in "devlink mon".
> So add it and fix the json output.
> 
> Fixes: a66af5569337 ("devlink: Add devlink trap policer set and show commands")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [iproute2-main] devlink: fix mon json output for trap-policer
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=1e994cf69cfd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


