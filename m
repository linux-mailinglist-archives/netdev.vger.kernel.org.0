Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9477D5BD94A
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiITBUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiITBUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E9D402C9
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FC9AB822E1
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12F90C433B5;
        Tue, 20 Sep 2022 01:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636816;
        bh=zReI1/NFCoX2Iq8CrByW8zJnC3urjvsDRIqE5Uk/Fr8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=slqdKDW+1xARur+V71rBQ2xVUBGtey845m0NFinT1DaHSbfMA8t5IlHNQW2Q5M08E
         ANv2SKux9DhxhFRGqNkFVPwGAHt8Weuyl9r9VHaasY/b2D7d5g3FC59L5QMU3POSvf
         X52wjToZe2sYc0GIpd+YRq/4XIfiOCLw9QjTpJDh/aosxfLiMefU4S3WYN7gpuyuxh
         YMvzw21G9II+7lYDmJkjqPjmr0dEe7uo9PHm0C7pZBiiG6w0rPlhCVmQ3Emc1WDinA
         t75yWLufHb4Hq1WOKh8jxAT6NbQ+iuhOQa5k5OC8ui/RIxZxaIleJOM1ujafxS47JQ
         P8o9W5allH0rg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2BA7E52535;
        Tue, 20 Sep 2022 01:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/4] batman-adv: Start new development cycle
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363681598.30260.16186925512365052536.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:20:15 +0000
References: <20220916161454.1413154-2-sw@simonwunderlich.de>
In-Reply-To: <20220916161454.1413154-2-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Simon Wunderlich <sw@simonwunderlich.de>:

On Fri, 16 Sep 2022 18:14:51 +0200 you wrote:
> This version will contain all the (major or even only minor) changes for
> Linux 6.1.
> 
> The version number isn't a semantic version number with major and minor
> information. It is just encoding the year of the expected publishing as
> Linux -rc1 and the number of published versions this year (starting at 0).
> 
> [...]

Here is the summary with links:
  - [1/4] batman-adv: Start new development cycle
    https://git.kernel.org/netdev/net-next/c/ea92882b1fd8
  - [2/4] batman-adv: Drop unused headers in trace.h
    https://git.kernel.org/netdev/net-next/c/7d315c07eda7
  - [3/4] batman-adv: Drop initialization of flexible ethtool_link_ksettings
    https://git.kernel.org/netdev/net-next/c/813e62a6fe75
  - [4/4] batman-adv: remove unused struct definitions
    https://git.kernel.org/netdev/net-next/c/76af7483b3c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


