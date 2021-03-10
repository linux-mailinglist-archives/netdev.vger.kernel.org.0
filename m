Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2351B334981
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhCJVKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:10:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232130AbhCJVKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 16:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EC61264DE5;
        Wed, 10 Mar 2021 21:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615410609;
        bh=49pXUaGUGpqj5XhnIuPkqVMSWqzvbT3ibFYECNe4zy4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A0vlFFHn4SWb0szdYKnhZPLuCn3wDEyf+KGPp1+pGScnlb1UsvZiB8sgxk6QZl3Hq
         fFtbt6XBrvwpe3MV5VWlgMgQrcFwRxILcsUhb6iMYuLGxPmpRjUIqyY2YJDgOIPodr
         cde5gVCo2DTVaF89UtpX0NkfbzmnoyfIuRUWkAOJfIsTOIh/ioUOCDkAQPot+56bTi
         Vmjtt6Y860Yr646RhTAErV+WpuLbHtbkB4Y1ZY5RvSgZI8++RHPLjjhPyl5ETexhF/
         UWmccXJld+tyHQiSNPy8cE0L5f80WxZEyq5yyJTLGqHTbqpvA3uHCB6nmrymOt+6iv
         +Z5MvrGyXrfHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DCAA560970;
        Wed, 10 Mar 2021 21:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] mlxsw: Misc updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541060889.9110.7979313781537777479.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 21:10:08 +0000
References: <20210310110220.2534350-1-idosch@idosch.org>
In-Reply-To: <20210310110220.2534350-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, danieller@nvidia.com, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Mar 2021 13:02:14 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patch set contains miscellaneous updates for mlxsw.
> 
> Patches #1-#2 reword an extack message to make it clearer and fix a
> comment.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] mlxsw: spectrum: Reword an error message for Q-in-Q veto
    https://git.kernel.org/netdev/net-next/c/825e8885779d
  - [net-next,2/6] mlxsw: reg: Fix comment about slot_index field in PMAOS register
    https://git.kernel.org/netdev/net-next/c/675e5a1e1afa
  - [net-next,3/6] mlxsw: spectrum: Bump minimum FW version to xx.2008.2406
    https://git.kernel.org/netdev/net-next/c/2ab781c2ccf4
  - [net-next,4/6] mlxsw: reg: Extend MFDE register with new log_ip field
    https://git.kernel.org/netdev/net-next/c/ff12ba3ad78d
  - [net-next,5/6] mlxsw: core: Expose MFDE.log_ip to devlink health
    https://git.kernel.org/netdev/net-next/c/315afd2068a8
  - [net-next,6/6] mlxsw: Adjust some MFDE fields shift and size to fw implementation
    https://git.kernel.org/netdev/net-next/c/4734a750f467

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


