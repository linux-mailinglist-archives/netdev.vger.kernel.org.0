Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509845EC719
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbiI0PAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 11:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiI0PAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5858A6ACA;
        Tue, 27 Sep 2022 08:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 629C5B81C24;
        Tue, 27 Sep 2022 15:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA4DFC433B5;
        Tue, 27 Sep 2022 15:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664290816;
        bh=sFdOOobofzRSevtw276melbjxHB5ys6FHTANHXpopgw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WX4frANPnykC7qs55nXP80M3bAJFh2unwqwJoLJz5GoRiCR/4tA2eX3ltERmzEusN
         ZpXEtM9u9BJrVbs1qhr1UwE7RiFjZChweNT8cHUR+K/Da1G5Bwv4myqnXY2Icqr9xI
         Y+TgflGxjmtemWgyaqdHtM9qos4EjC72lgbpjPjAVKn4i1jfs71rlVUcro8c9WFOpe
         2j2gI/x3ApIC6mFjV9+EQVpgraTbi1SQTdP/PG3QZQd1xTAf1tBlCOSubUA9x0eRRG
         x276lzU3aiR3loaZeBLqb9rXPRglLOI3gTyDj4CH6NomJ2JSV4/Va7DxdApUNDxvh0
         e7trxI6k33RRg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE978E21EC6;
        Tue, 27 Sep 2022 15:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] headers: Remove some left-over license text
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166429081584.27886.14059951639048254195.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Sep 2022 15:00:15 +0000
References: <88410cddd31197ea26840d7dd71612bece8c6acf.1663871981.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <88410cddd31197ea26840d7dd71612bece8c6acf.1663871981.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     yhs@fb.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 22 Sep 2022 20:41:40 +0200 you wrote:
> Remove some left-over from commit e2be04c7f995 ("License cleanup: add SPDX
> license identifier to uapi header files with a license")
> 
> When the SPDX-License-Identifier tag has been added, the corresponding
> license text has not been removed.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - [v2] headers: Remove some left-over license text
    https://git.kernel.org/netdev/net-next/c/73dfe93ea1b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


