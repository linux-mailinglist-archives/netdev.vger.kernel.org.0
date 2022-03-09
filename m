Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C574D28F0
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 07:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiCIGVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 01:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiCIGVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 01:21:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA5931DC4
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 22:20:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB3B3B81F86
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 06:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 858FFC340F5;
        Wed,  9 Mar 2022 06:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646806812;
        bh=n2ZH0r+Y1cZ+CfRQ0iw2bfCfCKG9ZV29pBxuiKQKKd8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KmlHnuknHGpS+3FbQifm3OvvUQNjJXaKCJKrMIwsaHl2sOZkRlwOFwDhnylB4lzGs
         EaPh1R5zs8zpc5f/8LawbZc8WG2X0LckMU8y0eUOtNGbrAgGBLvXby2HjvlX5sEdTi
         YPCD4KvhLCGq/Wcj5HcH9EYcxwbPeUrCCCfBhM+fXrVrodCZmXhaTYP8HXN4BJYhtU
         +0i/oC6cyXaW6ZEKvMM4A0ti1E0gg5RayPr3uY0p27Uj2uROPT1nwahWP5WRWoMgoq
         cJi+KU29wrqrhbeiPO0S9V1CROf9T3MYGR2ruU2j7q4aXCxilkqT545GqBkv7uoSQg
         Qo0R8hbpv0Wwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A20AF0383A;
        Wed,  9 Mar 2022 06:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] ptp: ocp: correct label for error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164680681243.10719.16166981249270623537.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 06:20:12 +0000
References: <20220308000458.2166-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220308000458.2166-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com, kernel-team@fb.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  7 Mar 2022 16:04:58 -0800 you wrote:
> When devlink_register() was removed from the error path, the
> corresponding label was not updated.   Rename the label for
> readability puposes, no functional change.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  drivers/ptp/ptp_ocp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next,v2] ptp: ocp: correct label for error path
    https://git.kernel.org/netdev/net-next/c/4587369b6cba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


