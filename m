Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9F92DA701
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 05:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgLOEBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 23:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgLOEAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 23:00:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608004807;
        bh=+qh9ef/Ur/7x9sMSS/DJSNDWYv0LVX7+u5IVF1V1GpI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=df2w/Sm5m1CC5dbLH0y4ULiI40+eUCV1Wtr0RPaXSumq2Fxzd6nn31UrdQyZAnRDq
         sxtwx9zhGSNZdeU0ppeiqAEMGsRAwd6hzNZbJ7EF10uZZzIRmEujEkPr2q33CVWFdF
         1+garb6j6fzBKbCH8htz+v/jdi0jWDLbaP2oO4On+s/JaHBe7f80PJzBWE4ptz2TsS
         O6AtwI22r7EuW81h4NvOaLkiX/ojzAFFcGz1WQhs1+3t9XjmKhtscA+n9/NIaxOC2p
         0+Nckmbt4+r8UieKdaaqI1JuolfrxmHMR7SwYtfSXt9X3etWWQJPKh+g6RsfCPhlb6
         L9ACmO5kClbHg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: hns3: fix expression that is currently always true
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160800480755.12571.337817358900148497.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 04:00:07 +0000
References: <20201215000033.85383-1-colin.king@canonical.com>
In-Reply-To: <20201215000033.85383-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, tanhuazhong@huawei.com,
        shenjian15@huawei.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 15 Dec 2020 00:00:33 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The ||  condition in hdev->fd_active_type != HCLGE_FD_ARFS_ACTIVE ||
> hdev->fd_active_type != HCLGE_FD_RULE_NONE will always be true because
> hdev->fd_active_type cannot be equal to two different values at the same
> time. The expression is always true which is not correct. Fix this by
> replacing || with && to correct the logic in the expression.
> 
> [...]

Here is the summary with links:
  - [next] net: hns3: fix expression that is currently always true
    https://git.kernel.org/netdev/net-next/c/efd5a1584537

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


