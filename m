Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E380745D273
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346211AbhKYBfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:35:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346768AbhKYBdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 20:33:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E49D5610E9;
        Thu, 25 Nov 2021 01:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637803809;
        bh=jXKil1Gqi2sG9/iea9fWXH5XijpMGybqlBKr/TYTblc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FQ+tgn6fTmc2xk15bOMyL/UNa2heZG8V9rKsGQz676HBymo9/UnChAs4mNW02Ynh4
         DvB5IHyMCq2eCFksWARF9Z/sk6DnqxSnP/SY8EU2jcreylPU/cSlBByJfyXA/Sa2YR
         0BiTPkCAkmcuGTxnt3RNwza1+kALpMY4277wwTIiF5Zlj1aHKyzqUAvrLVkgSaMwJ/
         JqvfwySFDr1X54zPaY8XgIlc+CAMSb+yFEguefWq3UD9Jz4GeBndS5fGHBJ8hOhQc2
         yw2GP6H7dWR+ZakLpCTk0gBHZ3glkg960aI+gUQdCSRDC2KhsO7aoxqMFKAg6g1zGv
         0D7pAvsNJ4aug==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DDFDF609D5;
        Thu, 25 Nov 2021 01:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: Allow base 16 inputs in sysfs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163780380990.5226.6384863172926981067.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 01:30:09 +0000
References: <20211124101122.3321496-1-idosch@idosch.org>
In-Reply-To: <20211124101122.3321496-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        nikolay@nvidia.com, roopa@nvidia.com, bernard@vivo.com,
        David.Laight@ACULAB.COM, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 12:11:22 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Cited commit converted simple_strtoul() to kstrtoul() as suggested by
> the former's documentation. However, it also forced all the inputs to be
> decimal resulting in user space breakage.
> 
> Fix by setting the base to '0' so that the base is automatically
> detected.
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: Allow base 16 inputs in sysfs
    https://git.kernel.org/netdev/net-next/c/5a45ab3f248b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


