Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF22482B1C
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 13:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiABMuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 07:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiABMuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 07:50:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7272C061574
        for <netdev@vger.kernel.org>; Sun,  2 Jan 2022 04:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4350260E9A
        for <netdev@vger.kernel.org>; Sun,  2 Jan 2022 12:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E7FBC36AEE;
        Sun,  2 Jan 2022 12:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641127810;
        bh=wxNqo5FVJByTWddQD2FJHIdvddumteJHiqAmZ4k2gj8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GPv0f3QkUOQnSWZrjmdnnr5KaHHDvsZGTGAf87jPBe2zbIUelTjrNPLF+u3byQBbv
         vKeMPzxuf3luBiOYvUL9iwDbgKgXzXAEliGs+JunIJ272ZhnzwShu7qy1F/oWFE5x+
         YP7V5jSJryI17CRc+Xv2VZn6Vn1Ybe5NEkP0w7qtvTsUVo36MNPaY/GI/UGh4urWC3
         amXNz+pi3IivSpJbafXJ89wq7heLhv/GHwe12ZzM4s/zmLzO6mX78UjX2WPIipB9kv
         ArVYB6jTue7pvJcre0aUiVkzP44mNesbo4CGsOr+t4nuiXV9lDItZNFSoHHdeewLg7
         3TDagNupF7CQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F323C395EB;
        Sun,  2 Jan 2022 12:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net 0/3] ENA driver bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164112781050.2909.15820867463263988707.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 12:50:10 +0000
References: <20220102073728.12242-1-akiyano@amazon.com>
In-Reply-To: <20220102073728.12242-1-akiyano@amazon.com>
To:     Arthur Kiyanovski <akiyano@amazon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, ndagan@amazon.com, shayagr@amazon.com,
        darinzon@amazon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 2 Jan 2022 07:37:25 +0000 you wrote:
> Patchset V2 chages:
> -------------------
> Updated SHA1 of Fixes tag in patch 3/3 to be 12 digits long
> 
> 
> Original cover letter:
> 
> [...]

Here is the summary with links:
  - [V2,net,1/3] net: ena: Fix undefined state when tx request id is out of bounds
    https://git.kernel.org/netdev/net/c/c255a34e02ef
  - [V2,net,2/3] net: ena: Fix wrong rx request id by resetting device
    https://git.kernel.org/netdev/net/c/cb3d4f98f0b2
  - [V2,net,3/3] net: ena: Fix error handling when calculating max IO queues number
    https://git.kernel.org/netdev/net/c/5055dc0348b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


