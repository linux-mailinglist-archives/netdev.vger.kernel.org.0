Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BDD640A14
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 17:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbiLBQCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 11:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233958AbiLBQB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 11:01:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E090390754
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 08:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82BF3B821E6
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 16:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12E03C433B5;
        Fri,  2 Dec 2022 16:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669996818;
        bh=5FUv/bWFWGVY0H9G7TbWigPZiXpeFEpyw/U6q1RQxf0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bsrBuJgI8oa4q9eUduQd+iJLjGTy5YvqKNDLNrOrO0nwIdNBF+mc7Rz3bpRpnqii+
         Xd8YZ4tNEZTA2ehFENZsAFeeAVWdGYYtVr+ilnIr6AQ9DqXckHD7kvDI10GAWFsrLx
         +7Jgyfk4sb+iV65zjiFrHUaon+5KSJI3NRfkK1JVNA8h+xoUDpF5vyiz74LupbXGcI
         kSJwP7PvSbgJjWqqinG/5Y0aC7LPi8/VIszQ6rYNQWJJB1TsGuiTFZQw3NRLkBUNvR
         CQIQJ95Fe7oOfoo7BWRN+7DFvLHu5sVOXqlsCnAAC2V7l+RgUtFNAP8DyCnGVzZmwQ
         meDQP8q+sufeg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F019BC41622;
        Fri,  2 Dec 2022 16:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2 1/2] ip neigh: Support --json on ip neigh get
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166999681798.3415.15126666390269574202.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Dec 2022 16:00:17 +0000
References: <63b6585719b0307d81191bbcf5228b94f81c112f.1669930736.git.cdleonard@gmail.com>
In-Reply-To: <63b6585719b0307d81191bbcf5228b94f81c112f.1669930736.git.cdleonard@gmail.com>
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     stephen@networkplumber.org, dsahern@kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu,  1 Dec 2022 23:41:05 +0200 you wrote:
> The ip neigh command supports --json for "list" but not for "get". Add
> json support for the "get" command so that it's possible to fetch
> information about specific neighbors without regular expressions.
> 
> Fixes: aac7f725fa46 ("ipneigh: add color and json support")
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> 
> [...]

Here is the summary with links:
  - [iproute2,1/2] ip neigh: Support --json on ip neigh get
    (no matching commit)
  - [iproute2,2/2] testsuite: Add test for ip --json neigh get
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=acea9032e92e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


