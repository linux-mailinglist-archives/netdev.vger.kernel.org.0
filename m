Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFBF502878
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352385AbiDOKwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352403AbiDOKwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:52:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F7D37A37;
        Fri, 15 Apr 2022 03:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDF38B82DFC;
        Fri, 15 Apr 2022 10:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81768C385A6;
        Fri, 15 Apr 2022 10:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650019811;
        bh=WxRk8XpgEHPJpkKEJ1NBRNv+VryEyW1KLyqGJICN7+Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QziOYV2kumxhFNVfqTr2ukMPkj2yVnK3NQvKgkt66s8cc1//Cpw/s4KRtFa+ygazd
         um/h+eln6gv1xHvOrdhwODZhk8JtOfuqlW2KgPKKjxf4yOIkxgD+0GDcOS8+eWygJk
         +FGiODiVaDOhBSp/RfSoFAfSwktQAj44nDlEJmX08Jtxcb9HUp96nAvt727ZG6JtbT
         wzCfgnsIk8Gjhae9FQqzFU9hI9ynaAUsdSjCVPtMw0WGX0ipBTrxogpe+CeENAkjkF
         yeoQ4rIConTqApBZkEFq3l886pn1MvyDusLOH7NcOG2+WtFnX4nrFI/qEW6gFHxdG1
         5Pt+m5imi2T7A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 62BFEEAC096;
        Fri, 15 Apr 2022 10:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] octeon_ep: fix error return code in octep_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001981140.26584.10130586040313059443.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 10:50:11 +0000
References: <20220415023957.1117879-1-yangyingliang@huawei.com>
In-Reply-To: <20220415023957.1117879-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vburru@marvell.com, aayarekar@marvell.com, sburla@marvell.com,
        davem@davemloft.net
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

On Fri, 15 Apr 2022 10:39:57 +0800 you wrote:
> If register_netdev() fails , it should return error
> code in octep_probe().
> 
> Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] octeon_ep: fix error return code in octep_probe()
    https://git.kernel.org/netdev/net-next/c/0a03f3c511f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


