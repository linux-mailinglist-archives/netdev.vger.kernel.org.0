Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1500849D879
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiA0CuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 21:50:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46414 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiA0CuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 21:50:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99A3BB81FAC
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 02:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D2F3C340E9;
        Thu, 27 Jan 2022 02:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643251810;
        bh=6rj64uEZFYzf9WhPcFAhYCt9at5pxqNNuK43atXaWVk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WW+AtndUd2d5y2Mr2lXSGa6EzbBwOopuOQcZfLGjK9iY/Mpfys4ha6IdBCoOgX+oe
         tJiXEUu2M7BumxYjpkBWTrsq5eLGlDShmfj9o72ZPZzUDJUlytpPLtvG4ynChTfXO8
         8I6PDcKeEHWNry2ahmxhnD2KIVKMm/p/0c6qVzi7X2Q8+/ZPG/5kmIo54pu6bYDW3b
         KgvPfuAOQZslNoW/SGIhbfIU3lZBIveZDa9mLYrWwJ/+Yurjt2OxnUadXLjAOYUGsh
         sjU3KJTi6rXRIy+o277UDXst6UvdEyjk6zbgQHy0Tl9Rs/cQascjBHrMD2Ww3ULPj4
         /rTUenzWiMSQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 549FEE5D084;
        Thu, 27 Jan 2022 02:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] gve: Fix GFP flags when allocing pages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164325181034.16805.1401074570855321284.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 02:50:10 +0000
References: <20220126003843.3584521-1-awogbemila@google.com>
In-Reply-To: <20220126003843.3584521-1-awogbemila@google.com>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, jeroendb@google.com, csully@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 25 Jan 2022 16:38:43 -0800 you wrote:
> From: Catherine Sullivan <csully@google.com>
> 
> Use GFP_ATOMIC when allocating pages out of the hotpath,
> continue to use GFP_KERNEL when allocating pages during setup.
> 
> GFP_KERNEL will allow blocking which allows it to succeed
> more often in a low memory enviornment but in the hotpath we do
> not want to allow the allocation to block.
> 
> [...]

Here is the summary with links:
  - [net] gve: Fix GFP flags when allocing pages
    https://git.kernel.org/netdev/net/c/a92f7a6feeb3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


