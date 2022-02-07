Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7893E4ABEDA
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447826AbiBGNB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446549AbiBGMn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 07:43:29 -0500
X-Greylist: delayed 91801 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 04:40:12 PST
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D106C033252;
        Mon,  7 Feb 2022 04:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2048B81240;
        Mon,  7 Feb 2022 12:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EA63C36AE2;
        Mon,  7 Feb 2022 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644237609;
        bh=Bi+YRTjzamuxy0Bbl8Ld2t5KWt1ALAj8F1h1s7aksL4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BMm0uVY5iTIHH3NKUqXCQZcpwC7f59j6QpQu3kWk/2N8uURfuPQiOm2XD+FJ6OmTd
         uGuITypjb8T4Bi+2ZePUAqQr+cnVtt3rnLAlKkYzoea778aUFJ4h8oRk1MLWRXyZk/
         1Ri9hImoNPzIijDPLFbbEOVN+CByZcEtK262oCJeAyn1x8TWJDpTqgtsuQxu0RKjG/
         nBBSUMXY97ps5IFKBkFHHMfv2x6VaJThwfKKr1nbfI+UD+KjT0+EuNnMAPBhzyfdCj
         /uGrDAeZ9vrU1VDrvQYuZx42r68q5FtVu1AXMW9IMqgOLjY6nG7We6aAijpAeh+kn1
         J8IIFsyZcfbzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 78495E5D09D;
        Mon,  7 Feb 2022 12:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next] net: hns3: add support for TX push mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164423760948.4874.7091354263258727957.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Feb 2022 12:40:09 +0000
References: <20220207014423.3218-1-huangguangbin2@huawei.com>
In-Reply-To: <20220207014423.3218-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 7 Feb 2022 09:44:23 +0800 you wrote:
> From: Yufeng Mo <moyufeng@huawei.com>
> 
> For the device that supports the TX push capability, the BD can
> be directly copied to the device memory. However, due to hardware
> restrictions, the push mode can be used only when there are no
> more than two BDs, otherwise, the doorbell mode based on device
> memory is used.
> 
> [...]

Here is the summary with links:
  - [V2,net-next] net: hns3: add support for TX push mode
    https://git.kernel.org/netdev/net-next/c/87a9b2fd9288

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


