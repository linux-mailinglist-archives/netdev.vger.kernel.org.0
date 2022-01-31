Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910DC4A45CA
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245494AbiAaLqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379823AbiAaLoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:44:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA3CC061768;
        Mon, 31 Jan 2022 03:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5559CB82A4C;
        Mon, 31 Jan 2022 11:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2848FC340EE;
        Mon, 31 Jan 2022 11:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643628609;
        bh=yRqQyx2N8i8cFfnirg2FCCsc3Oj2+dUCL+wE3mAZ2Co=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Eumuxzi+mEMzHKG4vGB0ZS+zarLripY0PKO7Nx6U/vKNXjYJ2DqNnbVDx8EixxjWB
         LB25zVAmA17PIkxpMtaXDswmrsUGkqs+hgB/9FyW6H0k5czmypAp3X3BwRmbLOKUwW
         vDVQXezg6xQRNqxZ+Qfe6roiQ31xgAX4PkQ0m2VUJmBwwXdQYhnHLKR5mCl3j2ZJy7
         lfZi1sefA3maKUoeWJuy+bxAq7I1ZWO2cJClj8wy9YH0IJiL2E+vlVOL3PVvjt1nHd
         nLrFppW7vmgp37PkgdJ54pou41Uc/fc6c0Wum73Tq7qY1z/3+6hq8Von6EAN2GEAIr
         nGMECHUH7GC0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12630E6BAC6;
        Mon, 31 Jan 2022 11:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v11] net: bonding: Add support for IPV6 ns/na to
 balance-alb/balance-tlb mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164362860907.1609.7647430897755348054.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Jan 2022 11:30:09 +0000
References: <20220128144442.101289-1-sunshouxin@chinatelecom.cn>
In-Reply-To: <20220128144442.101289-1-sunshouxin@chinatelecom.cn>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jay.vosburgh@canonical.com,
        nikolay@nvidia.com, huyd12@chinatelecom.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Jan 2022 09:44:42 -0500 you wrote:
> Since ipv6 neighbor solicitation and advertisement messages
> isn't handled gracefully in bond6 driver, we can see packet
> drop due to inconsistency between mac address in the option
> message and source MAC .
> 
> Another examples is ipv6 neighbor solicitation and advertisement
> messages from VM via tap attached to host bridge, the src mac
> might be changed through balance-alb mode, but it is not synced
> with Link-layer address in the option message.
> 
> [...]

Here is the summary with links:
  - [v11] net: bonding: Add support for IPV6 ns/na to balance-alb/balance-tlb mode
    https://git.kernel.org/netdev/net-next/c/0da8aa00bfcf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


