Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9AE6AB178
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 18:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjCERAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 12:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjCERAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 12:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F891423D
        for <netdev@vger.kernel.org>; Sun,  5 Mar 2023 09:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D4FBB80B02
        for <netdev@vger.kernel.org>; Sun,  5 Mar 2023 17:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4ED0C4339C;
        Sun,  5 Mar 2023 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678035617;
        bh=uPYr1V4EFqm0xIsMFlW3Ls1AtUNQKcYkHqnbR809KS0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vFVVFhslwxmpvkLEnac1HY0t7TB7X22XkjI+UGGxVmrLEZaP90JDmag6keJcLauis
         O6TvYy437ehPNp0BgsO3Mbviy/pDknmTPdUHODBSc30bscwGW4MwHnrBtqWsxfXFpj
         BXbhrA9V4hGsCulF75iqQHPC1KMD+QVLRZJSk95W6fiU1dGyfLcBZtKq8g6d9Ve1bI
         eBszuiRTOILRqE1X5/uBwC7Cvxg9VJBQ9V8i4hs7Q7NdByIplKl78tHnkPl9S/lear
         7B1K892YBUfU17WHBPyiHvd+iu2VmHL+wyfhUl8zgBnLqRPenbN3+uxy9gq4V3OwHe
         7rT6zeJnqOVYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A5658E68D5E;
        Sun,  5 Mar 2023 17:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] tc: f_u32: fix json object leak
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167803561767.1759.12092599139803014457.git-patchwork-notify@kernel.org>
Date:   Sun, 05 Mar 2023 17:00:17 +0000
References: <20230228073146.1224311-1-liuhangbin@gmail.com>
In-Reply-To: <20230228073146.1224311-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        stephen@networkplumber.org, liangwen12year@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Tue, 28 Feb 2023 15:31:46 +0800 you wrote:
> Previously, the code returned directly within the switch statement in
> the functions print_{ipv4, ipv6}. While this approach was functional,
> after the commit 721435dc, we can no longer return directly because we
> need to close the match object. To resolve this issue, replace the return
> statement with break.
> 
> Fixes: 721435dcfd92 ("tc: u32: add json support in `print_raw`, `print_ipv4`, `print_ipv6`")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [iproute2] tc: f_u32: fix json object leak
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=6637a6d512a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


