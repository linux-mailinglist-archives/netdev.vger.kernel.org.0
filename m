Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7190D3195F2
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhBKWky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:40:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229903AbhBKWks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 17:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 25DF664E44;
        Thu, 11 Feb 2021 22:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613083208;
        bh=YmEQhpSBJbbrLTxLyj4Uq112aIUKy+37WQI/4SJ+Xg0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Je0kjxogToLpgOAHoN3kVPwVIxhUMberr3hT5BncB6j5jhgBeRXBNAezYjGuCaR5M
         quGhgSGMsjKsjPA05IWmrMMS8RBAaR+q9THm+BEtgVMQVjeAISr0W+8t9MglX0VYpl
         kqYwFpK46lgwWsLkAh4iX15TKE4NNg2vfl8f/XVDrwr9HTDFQwcLmhAPSjQSn0CLz3
         lV+GcDqBI3YavGK0nR7hqExo3HRL57jcdOX63XsBjXFPR3C7y0uEvx8UxY7uOuWs7x
         rYAvj+VMg7S95HvsoTZB0mzj9Q0ec7vkn4TrHcalVAC854chOg8RgI24duWj/si32u
         U/ONhs7AWtpCw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1513060A2A;
        Thu, 11 Feb 2021 22:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] bonding: 3ad: support for 200G/400G ports and
 more verbose warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308320808.12386.11954612042219547044.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 22:40:08 +0000
References: <20210210204333.729603-1-razor@blackwall.org>
In-Reply-To: <20210210204333.729603-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, andy@greyhouse.net,
        j.vosburgh@gmail.com, vfalico@gmail.com, kuba@kernel.org,
        davem@davemloft.net, alexander.duyck@gmail.com, idosch@nvidia.com,
        nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Feb 2021 22:43:30 +0200 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Hi,
> We'd like to have proper 200G and 400G support with 3ad bond mode, so we
> need to add new definitions for them in order to have separate oper keys,
> aggregated bandwidth and proper operation (patches 01 and 02). In
> patch 03 Ido changes the code to use pr_err_once instead of
> pr_warn_once which would help future detection of unsupported speeds.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] bonding: 3ad: add support for 200G speed
    https://git.kernel.org/netdev/net-next/c/ab73447c38e4
  - [net-next,v2,2/3] bonding: 3ad: add support for 400G speed
    https://git.kernel.org/netdev/net-next/c/138e3b3cc0bb
  - [net-next,v2,3/3] bonding: 3ad: Print an error for unknown speeds
    https://git.kernel.org/netdev/net-next/c/5edf55ad95b5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


