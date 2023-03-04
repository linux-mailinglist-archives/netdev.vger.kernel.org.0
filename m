Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0126AA78C
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 03:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjCDCUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 21:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjCDCUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 21:20:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A413E65C5C
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 18:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D3B16191C
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 02:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 890E0C4339B;
        Sat,  4 Mar 2023 02:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677896418;
        bh=ClzWdkjI+jnNj33ISJOLFDI28DqoJfXV96zxUQS3K8E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gmen0rM07LFMkj7bLQcBeY7Wsy9XvXyrNAWPDGlMIhgoG8zufcA8YNPkgxtDsJIQV
         wK/FyCvM10X7B6y4AD4dBGfMdCvRhv8vy27yhL3QxMolEeBiYayFbQ8WsvCGEV5cXw
         jwK9sDFS9s+e+K6cJQungCUc7EsoUvwuQuxkKcM3tGshYf4lA9/tzCfLbbkC3LkStk
         lHmyeg9f5Te7iyzpFzMZjlWSnGsFsWhBpc9pDFJX4U3ZZF65yakGC5qoPDLJZv0Tsp
         /iIrUG4d/trGsY5RwHUreQzwAYTsOwD0eoScMKZRotOPZy3BQgwDCjCzDZvFe1yrFZ
         EygWM3BplDIqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69121C41679;
        Sat,  4 Mar 2023 02:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] genl: print caps for all families
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167789641842.26474.14173384120838089819.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Mar 2023 02:20:18 +0000
References: <20230225003754.1726760-1-kuba@kernel.org>
In-Reply-To: <20230225003754.1726760-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     stephen@networkplumber.org, dsahern@gmail.com, jhs@mojatatu.com,
        netdev@vger.kernel.org, johannes@sipsolutions.net
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

On Fri, 24 Feb 2023 16:37:54 -0800 you wrote:
> Back in 2006 kernel commit 334c29a64507 ("[GENETLINK]: Move
> command capabilities to flags.") removed some attributes and
> moved the capabilities to flags. Corresponding iproute2
> commit 26328fc3933f ("Add controller support for new features
> exposed") added the ability to print those caps.
> 
> Printing is gated on version of the family, but we're checking
> the version of each individual family rather than the control
> family. The format of attributes in the control family
> is dictated by the version of the control family alone.
> 
> [...]

Here is the summary with links:
  - [iproute2] genl: print caps for all families
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=2a98bc13169b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


