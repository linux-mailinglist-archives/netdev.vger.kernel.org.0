Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86ADE67A8E5
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbjAYCk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbjAYCkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:40:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C5F530F3
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 18:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5F61CCE1D21
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9FD82C433A1;
        Wed, 25 Jan 2023 02:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674614417;
        bh=zCeM1nzGcf1Hg5ks7cP/HsUmB3F5l4IBTnuUeSdT4kE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IEgsOJ5Mv/j2X5nl9vyQSGinl04GtVpy+pK7e08nR+7LyabbwdDv8p1RoWboM7n0P
         VTXJ+NkuVpflr4ZNZAu/0UGnnrmslCO5EgD3ie8YzcTNsXs37yLn/5UcVeZBbbvIh3
         faPQcrAmznAj71/tTWOnKb4sdeh6arn4HN39/E34LrCGHIZ+I/BbSTaMY7KI/Isrg7
         tb6ogmoFFs6V5RX9glqtNY/lBOg//R+24ZhtTgJG5zaYqJ3e0hTh9LosTIc+gKAxyE
         Jy2In10J0t1bhGKLcksl2VHO3iIHAKXsIWM02Kj5kp7/iukUl3Wx51PhrMCy9r1qJM
         hJ26TC1gj78Lw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8AE45E21EE1;
        Wed, 25 Jan 2023 02:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower: change get/set_eeprom logic and enable
 for flower reps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167461441756.2895.17746063847665155230.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 02:40:17 +0000
References: <20230123134135.293278-1-simon.horman@corigine.com>
In-Reply-To: <20230123134135.293278-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        james.hershaw@corigine.com, louis.peens@corigine.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 23 Jan 2023 14:41:35 +0100 you wrote:
> From: James Hershaw <james.hershaw@corigine.com>
> 
> The changes in this patch are as follows:
> 
> - Alter the logic of get/set_eeprom functions to use the helper function
> nfp_app_from_netdev() which handles differentiating between an nfp_net
> and a nfp_repr. This allows us to get an agnostic backpointer to the
> pdev.
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower: change get/set_eeprom logic and enable for flower reps
    https://git.kernel.org/netdev/net-next/c/74b4f1739d4e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


