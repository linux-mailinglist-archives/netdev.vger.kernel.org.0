Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F574C6E31
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbiB1Nbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbiB1Nbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:31:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2157B552;
        Mon, 28 Feb 2022 05:31:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5582B61366;
        Mon, 28 Feb 2022 13:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD1B1C340FB;
        Mon, 28 Feb 2022 13:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646055059;
        bh=COP7QMQ9xUh7IM7rpNprhgLL+2MxeN0ohPvU/K2GftA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vDTFmWujGUdDKfVK1TT+i+W3mqIvA117XWM7lHGSUoMCwOMMVzpbe/MjwiS+irAyQ
         oNQU9sG1gT18Cl5mYdelGAJFaCmjnlOaPisAaJJY7wiuRmJa4Y4BwYDw5FLiybMdlc
         2GPey8rCmLlzhLB4F50yUPykbg9nfiJan8JxoYBnAzKDytnwzB+Oojbr+3Mu7l+wRg
         ZdXfQnVkaYQMghdFaIY2/t8OKVKRrWKEDYqlzt2ptKB2H5vk/2NiNxu+/NIAAYYX0k
         05fRLX+5U8D0VFGyfHf9mezW1OiiH4BWUp/EGJGUiuuJtYMXSRfw/JM+Jvp6mAffGG
         sEI7Mb4U7XRuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 96773F0383C;
        Mon, 28 Feb 2022 13:30:59 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qlcnic: use time_is_before_jiffies() instead of open
 coding it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164605505961.13902.9622614799721918952.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 13:30:59 +0000
References: <1646017980-61037-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1646017980-61037-1-git-send-email-wangqing@vivo.com>
To:     Qing Wang <wangqing@vivo.com>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Sun, 27 Feb 2022 19:13:00 -0800 you wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> Use the helper function time_is_{before,after}_jiffies() to improve
> code readability.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> 
> [...]

Here is the summary with links:
  - net: qlcnic: use time_is_before_jiffies() instead of open coding it
    https://git.kernel.org/netdev/net-next/c/3b6cab7b5a2f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


