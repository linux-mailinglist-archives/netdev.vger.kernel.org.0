Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C264C6E38
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbiB1Nbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236121AbiB1Nbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:31:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580387B552;
        Mon, 28 Feb 2022 05:31:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16D85B81189;
        Mon, 28 Feb 2022 13:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A784BC340F5;
        Mon, 28 Feb 2022 13:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646055059;
        bh=9Fuh2MNeoeiOmRlGUWBsyrCqVcEnKHPKqyQxhxFSxDY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cXiWK9LUouwev72EGQAPfWHTqqpXgnrOTuMJX+HHhw+6pegD1D/596esWUX1DbrzM
         FSgQASyFCbOQdCx4KTp6iadU2QA6gwDGTum61077AJt6/RHaV42f+i7wGMLOn2L80i
         UGxrj8tQ8KXdeq3sK7W2B+UzhdSKd47a/YXN2TXg1M/EfTSPGceBOZiQB6kleiINHz
         mhiqrRlvKMPoOTKJ3vdTbpYYXo9JGNqx30US4mreDXZQpEdVkg1/EyBsb2O6wIzXmF
         WWzgC0eQzbvLEGhcE8KAUHGJyXzxa9c+OPpookQeyb7Wh4ZEJgmWgLMLTgkHCXKpF+
         gUFNhIeKRctjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8CCD6EAC09E;
        Mon, 28 Feb 2022 13:30:59 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wan: lmc: use time_is_before_jiffies() instead of open
 coding it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164605505957.13902.9499552380771509374.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 13:30:59 +0000
References: <1646018028-61175-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1646018028-61175-1-git-send-email-wangqing@vivo.com>
To:     Qing Wang <wangqing@vivo.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Sun, 27 Feb 2022 19:13:48 -0800 you wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> Use the helper function time_is_{before,after}_jiffies() to improve
> code readability.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> 
> [...]

Here is the summary with links:
  - net: wan: lmc: use time_is_before_jiffies() instead of open coding it
    https://git.kernel.org/netdev/net-next/c/b7eb7f67eb29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


