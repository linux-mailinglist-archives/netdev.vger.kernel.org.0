Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D97A2FF58B
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 21:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbhAUULg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 15:11:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbhAUUKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 15:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 835D123A5E;
        Thu, 21 Jan 2021 20:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611259808;
        bh=NVG38ZLu+Anij+JW/Lk7dyyHi6rcXm3ZIO5ByrJ7gHE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PRb+pQ02ya/yj4JGqHuK08Y3VZ6ktr0ajwRhnfvi3znOYiQLRQUnvh4PfqL+zWUfa
         3gCzREzS57O4Td+JIej9X7O+X0g5J6FCLAT9v9vsUA8L0QMRCvZwjzC6uhUW+BRaCK
         iBm9jTuWGNUV/1cqJCIBVJN3wk4kafHfhHIoYZd8RoHCAXWqs8TMxXts4JwJjGp61R
         b6rGI/BW5XcLs1bY1Lgb4uzHVI1ciaX+sa9dNEJg39Fb0YlX8Ml/aiqbP/7bsjqYhs
         sZs4Re6iemq0Q46gZ4ZzO8HKRKWmEXZqoq1nAp6CfZlHo41ZpEAABsHTYPD9k/SQFF
         ZW3xIXOsbSe1Q==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 7304D60192;
        Thu, 21 Jan 2021 20:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Add devlink health reporters for NIX block
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161125980846.10330.13299364305009726430.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jan 2021 20:10:08 +0000
References: <20210119100120.2614730-1-george.cherian@marvell.com>
In-Reply-To: <20210119100120.2614730-1-george.cherian@marvell.com>
To:     George Cherian <george.cherian@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        corbet@lwn.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 19 Jan 2021 15:31:18 +0530 you wrote:
> Devlink health reporters are added for the NIX block.
> 
> Address Jakub's comment to add devlink support for error reporting.
> https://www.spinics.net/lists/netdev/msg670712.html
> 
> This series is in continuation to
> https://www.spinics.net/lists/netdev/msg707798.html
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] octeontx2-af: Add devlink health reporters for NIX
    https://git.kernel.org/netdev/net-next/c/5ed66306eab6
  - [net-next,2/2] docs: octeontx2: Add Documentation for NIX health reporters
    https://git.kernel.org/netdev/net-next/c/d41b3365bda7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


