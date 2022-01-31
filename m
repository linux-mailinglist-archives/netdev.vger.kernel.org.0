Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09FE4A45C3
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350815AbiAaLqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:46:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52204 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377961AbiAaLkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:40:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64C5EB82A80;
        Mon, 31 Jan 2022 11:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1A8F2C340F0;
        Mon, 31 Jan 2022 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643629211;
        bh=F3VB/Ke48CzSbhew1F/xY+83LjkMPywa2NzyHUBVae8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oGv5z4Lx48O4JPewFp/+e1iHv6z2KfcgD13D+tfN3CFg/WOQlEC6jKB/mFrR7YQ98
         ZQgLr8XLFUgZH49cVXnqoGr7yRrq5/I8VqA2gZXQbi7sPWRrQWGNNnrF8utNoXQCXi
         +hf53MyP5y2VPyWikaj38Rs/dPfv5a2SRPoc+mk+H2NgElyhIYxVyDvBTlBmytdRkj
         kSnXl20sDak/7CF2UpgvE8gEmwkYNaYIYPlXSd87CajTC7yfFqcyDNOCcvQa3BOchU
         0CaiHtVDv5tCv9cJuafaCRjYklePngBho9be5IKw9+ci0Ot/gUJpLMYpG2R8PexAOd
         88ix1CmekAn/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F0E8BE6BAC6;
        Mon, 31 Jan 2022 11:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] phy: make phy_set_max_speed() *void*
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164362921098.6327.14956574731405336404.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Jan 2022 11:40:10 +0000
References: <4889c4d5-cff8-5b15-bd50-8014b95b18e8@omp.ru>
In-Reply-To: <4889c4d5-cff8-5b15-bd50-8014b95b18e8@omp.ru>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        linux-renesas-soc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Jan 2022 21:32:40 +0300 you wrote:
> After following the call tree of phy_set_max_speed(), it became clear
> that this function never returns anything but 0, so we can change its
> result type to *void* and drop the result checks from the three drivers
> that actually bothered to do it...
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE static
> analysis tool.
> 
> [...]

Here is the summary with links:
  - [v2] phy: make phy_set_max_speed() *void*
    https://git.kernel.org/netdev/net-next/c/73c105ad2a3e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


