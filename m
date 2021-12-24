Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7319947EE44
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 11:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344130AbhLXKaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 05:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343932AbhLXKaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 05:30:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6830C061401
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 02:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C8F262044
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 10:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D88EC36AEA;
        Fri, 24 Dec 2021 10:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640341809;
        bh=wVkGRN2yYxPdiGZCMbBfHLX/HMHwmw2luCIukn2Uq04=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I16TrHHHiGBR7AitNZQ3s6Z9mbvdCX/QsWkUFCGS8swwwmiphlx//Krnqbcg0f82b
         9SLPU32NMfn4pzsCe2WSYQbVZ+8L5PtCN96q1PS/iAM1sx3BAj7236Y1FSl9DpS8Ki
         7WfKxthXYynBWJX/idS7hpTuTz2xo00UBBQSyFThx51Dxv2DNF56bbF579NDQBi9fE
         fFB/qQsmisLhH3wwdJnVRNI2d5MaZGV71Tq3OAtF5HhSnC97gvicS2z8UDptA2oOMg
         H8jRdfmZEBF86IRaY93Ni1mfkf284VJSEDlacSvDEqxeMyVnmEcqXZUvFYORsiiIxM
         +qtchmtZT3xYA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 40CACEAC063;
        Fri, 24 Dec 2021 10:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wan/lmc: fix spelling of "its"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164034180926.11383.16580255915610634834.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Dec 2021 10:30:09 +0000
References: <20211223062611.24125-1-rdunlap@infradead.org>
In-Reply-To: <20211223062611.24125-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, khc@pm.waw.pl, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 22 Dec 2021 22:26:11 -0800 you wrote:
> Use the possessive "its" instead of the contraction of "it is" ("it's")
> in user messages.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - net: wan/lmc: fix spelling of "its"
    https://git.kernel.org/netdev/net-next/c/24d8a9001a91

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


