Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0FE3ABB4C
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 20:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhFQSWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 14:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhFQSWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 14:22:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AC960613E1;
        Thu, 17 Jun 2021 18:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623954003;
        bh=V6wpjAnkawqPIR0EXb+NS0jx+gumDb8lkhTsONQB1js=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nfyRalhK36Cv2dOIENycULZOVTv0b7ojsAXI7QsXBB+MpmvopdFY/i5nmm89qJVOW
         n3tNYxrF84scC2OoCHa3t25gzySiGUwrouJzGpZQP3ctv2JzmplwRBbxkJN0aLAg6q
         N/9G2ZBZojM03CxMKvlUcviPfdMOabXnacpJn3Fw1qWI8S6z0JXIaHKInleJoS6ZJg
         ji7KlTVW3pVXeMBtN1fTSKNlk2oj9RrJgjHeQZVHhl1HI69ZRt7NSRKFP53+FOW+lI
         ghbml5N4PQu42PamRKBuj4/veXNBPar9IDWp1TBO0lci5LeZ3/TRVyH0/9NMi7HGhf
         Cvir+9h9YskCg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9C179609EA;
        Thu, 17 Jun 2021 18:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next][V2] net: pcs: xpcs: Fix a less than zero u16 comparison
 error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162395400363.25060.1069176598126607006.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Jun 2021 18:20:03 +0000
References: <20210615135253.59159-1-colin.king@canonical.com>
In-Reply-To: <20210615135253.59159-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     olteanv@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 15 Jun 2021 14:52:53 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the check for the u16 variable val being less than zero is
> always false because val is unsigned. Fix this by using the int
> variable for the assignment and less than zero check.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: f7380bba42fd ("net: pcs: xpcs: add support for NXP SJA1110")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - [next,V2] net: pcs: xpcs: Fix a less than zero u16 comparison error
    https://git.kernel.org/netdev/net-next/c/d356dbe23f60

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


