Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649C0456E9C
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 13:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbhKSMDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 07:03:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234673AbhKSMDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 07:03:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1BFDA61B39;
        Fri, 19 Nov 2021 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637323213;
        bh=lqpchPmBXslRMIKYieGaGSpYCK20b7OSc4a8O58jBnE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NtyBMrkJcOzPxmdjVu4nSvHKDG8aFfh04dr+G1N4skGjqUiBnLBuNJj9SmWAm/wZB
         Z/S76G4rwwPwGH2wdr5uhsHtmOZEors0f9nhnhyL4rUKniVcc4avHSD10BXKuSFbIa
         xn+RAGy7LUvqHZszLT7O0khHHjd+m7APF62jYbhqfvBdwaG9bbD1JlJAQVbu5Y2nBU
         BHJ7CzFBkkqxI/brzjwTtq1S6lgPXHQCekeQD5+MiGjdJg43WxyNCVN9uurZokkIcb
         iXGDqdfjG/vsoSsrWPZaXs0na9jxUR77LydGEMuLNxcaVi/4XFPnlnpbtTZ1M8iMzW
         FB2Djn86B/IYw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1649060A39;
        Fri, 19 Nov 2021 12:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethtool: stats: Use struct_group() to clear all stats at once
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732321308.14736.7365949386575823100.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 12:00:13 +0000
References: <20211118203456.1288056-1-keescook@chromium.org>
In-Reply-To: <20211118203456.1288056-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        yuehaibing@huawei.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 12:34:56 -0800 you wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Add struct_group() to mark region of struct stats_reply_data that should
> be initialized, which can now be done in a single memset() call.
> 
> [...]

Here is the summary with links:
  - ethtool: stats: Use struct_group() to clear all stats at once
    https://git.kernel.org/netdev/net-next/c/812ad3d270cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


