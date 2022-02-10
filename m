Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9134B11B0
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243624AbiBJPaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:30:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiBJPaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:30:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73848C5
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D9B061C21
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 15:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60B7CC36AE2;
        Thu, 10 Feb 2022 15:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644507011;
        bh=iV3o+zgnxGkRQFUE440B9faytNd6cvRU/MhYYx2AxIg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rbXZxLGD8Wx8jPQnK7q1ll1B/A5Gy5CM/ylAo/T+lx7RZafUTC8SNDhXpPTnxP3My
         zp8/Pmm/i3Obt/+PHdOsA+WBsPOxUaC/SufweK1/B1te8lXuVC8JYsiH5a0zr4+leK
         vgaNYjE2d2c/5vBBD7si6IURF3L6uQKmPYCatswM4C2eHGJMYj8AtjIoHcQd4DUdt9
         7jIDqxUQL5wz1dVowfx9D1PaeyvlXsgvj+o/84hqxXXmVuQRgnzNlBEj8t581Nl0Ds
         fIROT/HtOxNKtFEa5IoGMGbygeYuuD9M95ZKclGVgybjreSUaEuqP7KlyHN//nulhv
         BzzzHGifs1iRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B349E6BB38;
        Thu, 10 Feb 2022 15:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] qed: prevent a fw assert during device shutdown
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164450701130.11192.14184881749818862341.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 15:30:11 +0000
References: <20220209192814.2048658-1-vbhavaraju@marvell.com>
In-Reply-To: <20220209192814.2048658-1-vbhavaraju@marvell.com>
To:     Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, manishc@marvell.com,
        davem@davemloft.net, pdhende@marvell.com, palok@marvell.com,
        aelior@marvell.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 9 Feb 2022 11:28:14 -0800 you wrote:
> Device firmware can assert if the device shutdown path in driver
> encounters an async. events from mfw (processed in
> qed_mcp_handle_events()) after qed_mcp_unload_req() returns.
> A call to qed_mcp_unload_req() currently marks the device as inactive
> and thus stops any new events, but there is a windows where in-flight
> events might still be received by the driver.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] qed: prevent a fw assert during device shutdown
    https://git.kernel.org/netdev/net-next/c/ca2d5f1ff059

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


