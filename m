Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAB82F8AA5
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 03:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbhAPCAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 21:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728493AbhAPCAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 21:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BF9D623A58;
        Sat, 16 Jan 2021 02:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610762408;
        bh=VaARkPx5fFd1l2cwmnHRc7C7eEXkzddcwBekopGEo5w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HWV3FbOupouZg3ylVPjET+/Vl5r8OqP0Fgzvt6scMMYo7OVFBmHfC6ip+epI5eo91
         9AAWO5lYLOy0WzJ9YsEA5WYFRkT2fdWChtSiiMZibFeak7HtqcLAfNHcvxnvSeW7kC
         o9SdvTb1FSfTuCKjOzAcpdYEfpPJLmcz1TXW4Dp0k3AtdzeIQh42jkKSC+7ZZ1NR65
         NLgiqY67jFPy9UxPqGzz0NjhrVxoymM8E7ZDMURs8VH4+KnatkaItqTQoMIiwlkmpL
         B4stS+PCFvvCpefzoq6Ljv7js7JNXJhQ+bzBU5PwzXoxemz/P5FPq/KkCWA+eFE/nm
         hqPw9W9G2W/6g==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id B3726605AB;
        Sat, 16 Jan 2021 02:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] gianfar: remove definition of DEBUG
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161076240872.31907.16057181697743328640.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Jan 2021 02:00:08 +0000
References: <20210113215603.1721958-1-trix@redhat.com>
In-Reply-To: <20210113215603.1721958-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 13 Jan 2021 13:56:03 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Defining DEBUG should only be done in development.
> So remove DEBUG.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> 
> [...]

Here is the summary with links:
  - gianfar: remove definition of DEBUG
    https://git.kernel.org/netdev/net-next/c/2267c530f868

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


