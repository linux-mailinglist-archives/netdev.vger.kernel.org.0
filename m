Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AE43A2051
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhFIWmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230084AbhFIWmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:42:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4A65E613EF;
        Wed,  9 Jun 2021 22:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623278425;
        bh=Illkht5WFpE954pZOZxc15dUTH5CLXx2m9a0e0ckTO0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NCJs8tjPi4KXJyp6rPi0MwJ989PBcYoNkElcTah1qwOAj9qfg0v1fCnLBYFcMvKzv
         jK0hfmkh1Hka9ec0MlQ9hNp8t3ir1hkEgPlKSz9/LdIh/Opq7gjNppyE/I5V/HrECA
         rtuxmloD4Q02vsG9BeFS/MZJWJ3hkZYv5dSfw1Ag4Y2UC6YW36vH5Y41FjkpPyfopp
         YkkXdfDXL46VGkr5ZdAtKR2wicjNNILsLfowMOA+QbwpHOpGi5+YuWPGxQiLFUjvIU
         Dx2s5zSj3P5aqzFbDmW2nbHrLoUq9x5uHeESSZwmpemG7YizYYbssxpkfMSCUNhkOM
         95cs85ePMmxSQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3E68760A0E;
        Wed,  9 Jun 2021 22:40:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] mlxsw: thermal: Fix null dereference of NULL
 temperature parameter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327842525.25473.13374384894678302693.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:40:25 +0000
References: <20210609175657.299112-1-colin.king@canonical.com>
In-Reply-To: <20210609175657.299112-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     jiri@nvidia.com, idosch@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, c_mykolak@nvidia.com, vadimp@nvidia.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  9 Jun 2021 18:56:57 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The call to mlxsw_thermal_module_temp_and_thresholds_get passes a NULL
> pointer for the temperature and this can be dereferenced in this function
> if the mlxsw_reg_query call fails.  The simplist fix is to pass the
> address of dummy temperature variable instead of a NULL pointer.
> 
> [...]

Here is the summary with links:
  - [next] mlxsw: thermal: Fix null dereference of NULL temperature parameter
    https://git.kernel.org/netdev/net-next/c/f3b5a8907543

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


