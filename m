Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB0439953F
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 23:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhFBVL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 17:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229682AbhFBVLt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 17:11:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 61862613F4;
        Wed,  2 Jun 2021 21:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622668206;
        bh=LOaVzp/89AL8IRTka1m6th9iCgZ/AjueQ9IGQkgvPb8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DpCwror/tmpU838P4DlawwckRGPLvapy75ZXWJQCkGnsTxpDQ+9HmYng0/Qqlv5F7
         lM9uCvPbDEZQapCCLzzFUr+apHt2lD9eJHxwHyz5V14PwFTJrOMsXSQVQk2ZB97GQv
         ElWVd3shKqAltVk22usk1GQThPhfnP32a3rPUGap/gbgHnui7qlURMeSkdgTUgquTN
         o1OVuQ2ZhZDZMX2M69Avi4mgEeCk/h19mwGYzwdURoLQk8kX36GFZ2HQNAS+wVVgDT
         FTPe2aXkodNg6ZvrnDLsPfU7t7AteFZx4om76XgjLWpzGs7UwmbRmziJlZQSGefZC3
         3IzaCCZldZWsQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5A56960BFB;
        Wed,  2 Jun 2021 21:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] decnet: Fix spelling mistakes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162266820636.24657.12764427589600957390.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 21:10:06 +0000
References: <20210602065544.105734-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210602065544.105734-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 2 Jun 2021 14:55:44 +0800 you wrote:
> Fix some spelling mistakes in comments:
> thats  ==> that's
> serivce  ==> service
> varience  ==> variance
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] decnet: Fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/5debe0b30bac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


