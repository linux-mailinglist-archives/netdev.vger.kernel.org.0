Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98114C12BC
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 13:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240402AbiBWMal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 07:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbiBWMaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 07:30:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9210698F4D
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 04:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CEB261224
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7639CC340EB;
        Wed, 23 Feb 2022 12:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645619411;
        bh=DIYksVxESnqToSCHKVtxqPGvTwarNBeDdQI+ssE6eqY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FEoHScBpPJpgL1GSDp39TEvbvLBbcb1rkMKeFk72+DS+VNwMiiWnBZyxXwcVK5n/+
         EWb3lzvdmxoCg8xB/l713qwYgWO7wF1u8tDJdpC0B4P3aiXjlm5c9Md5UmxuSuySuf
         zskpTuGNybM2kHj38OVF9jil/OuafMo+UcfmJr9rQ+swQ/YDAV5mW+Ael/XT/Ug0BP
         9HBgmjJe2h87SERP4KvDo5bFvITyZBTAAUyQSuD5xYSRIYczuUR+OBjQ7Oxz0SNtCP
         wTDQCfv7S9wr8YOZEGCpP/xy4zotWn429d0Gz+szs/97xBMDjbwJ523kejd9RTu2K7
         puOVlq1sLEXew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63039E6D528;
        Wed, 23 Feb 2022 12:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/2] mctp: Fix incorrect refs for extended addr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164561941140.20664.15203606895453255117.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 12:30:11 +0000
References: <20220222041739.511255-1-matt@codeconstruct.com.au>
In-Reply-To: <20220222041739.511255-1-matt@codeconstruct.com.au>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jk@codeconstruct.com.au
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 22 Feb 2022 12:17:37 +0800 you wrote:
> This fixes an incorrect netdev unref and also addresses the race
> condition identified by Jakub in v2. Thanks for the review.
> 
> Cheers,
> Matt
> 
> Matt Johnston (2):
>   mctp: make __mctp_dev_get() take a refcount hold
>   mctp: Fix incorrect netdev unref for extended addr
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] mctp: make __mctp_dev_get() take a refcount hold
    https://git.kernel.org/netdev/net-next/c/dc121c008491
  - [net-next,v3,2/2] mctp: Fix incorrect netdev unref for extended addr
    https://git.kernel.org/netdev/net-next/c/e297db3eadd7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


