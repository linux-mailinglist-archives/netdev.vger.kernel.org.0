Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FDB3B3986
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 00:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhFXWwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 18:52:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232904AbhFXWwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 18:52:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3A8D1613CF;
        Thu, 24 Jun 2021 22:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624575004;
        bh=ua3ZyYxAkImXrnxq7tikXivA3hIOa3hHGXq3LxOPQ70=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uQMH5g5kfhYNWGL+xnQ6UO73xfSFJ29ZdN/VtXhyNVihA1g5GFgCeomEIt2egIFQH
         1tVWsbqUmg//+OWUc4Ukum6eTpUGKje7qfnHvh8dX4OGXw1Gbky3uUS4ioRicD+gkB
         IFF12XrItkM34QfRAJH5vJy1Bjxz0I7kFlBj/eF1xMiz8Iec4vwtB7dkBPahYw5esw
         YAIUc2V6I8X2CZpkbMnOimOqIl4Zl5HX/uOkVDS8K9N3xW73kvp25m3vVT0lq6keO2
         8+AisHdvH+OX5HHQk30aTH1LsCpKjbeaV8a8ukhqJyo2YlJUCBA7BKN08bOUZmgttn
         Gf/+CeptxjHXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3275F60A37;
        Thu, 24 Jun 2021 22:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mlxsw: core_env: Avoid unnecessary memcpy()s
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162457500420.3017.8580129795343540642.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 22:50:04 +0000
References: <20210624194724.2681198-1-idosch@idosch.org>
In-Reply-To: <20210624194724.2681198-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 24 Jun 2021 22:47:24 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Simply get a pointer to the data in the register payload instead of
> copying it to a temporary buffer.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] mlxsw: core_env: Avoid unnecessary memcpy()s
    https://git.kernel.org/netdev/net-next/c/911bd1b1f08f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


