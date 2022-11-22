Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18950633497
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 06:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiKVFA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 00:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiKVFAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 00:00:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736B42AE10
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 21:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 327E8B80B51
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCC76C433D6;
        Tue, 22 Nov 2022 05:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669093221;
        bh=mLL5PtDQmFmOJfKXXPQaVWGV+3L0gaq4tJ/PFoo12WA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=anH2CFX3YYYDy1rxJH9R9wFFFRhVAxLjbeSoZiokgJmb4y6r++Rni7LDiWuyI9Rey
         FVN+uAKA3Yl8A/2laLQSi0JV8RFcYGzT9Io92hXyG1FEdhxD9bzNP8gIV6Tf6p/Vq0
         EPFK6J6p5VrDGLkdweZkg2wHtu4zMBzfwI2D7DiAOcxwM+wZ56sI0XEqUh5ifrbc3v
         Zr2tJqRBZqZYd/lDYXaGmWwAsolj/V2ybm312qVV64dwqCQxoqSyLcZ2U0fhcIVdaR
         6aJUIxEaiXXx6a/7tXb4guMy5xA5jHCmWNzpI8srGh3dXtbYZXbbZFcjvUuDl6if61
         wkCOc12eYSjZw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1855E270C3;
        Tue, 22 Nov 2022 05:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: at803x: fix error return code in at803x_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166909322178.4259.16603810146433251778.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 05:00:21 +0000
References: <20221118103635.254256-1-weiyongjun@huaweicloud.com>
In-Reply-To: <20221118103635.254256-1-weiyongjun@huaweicloud.com>
To:     Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robert.hancock@calian.com,
        weiyongjun1@huawei.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Nov 2022 10:36:35 +0000 you wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fix to return a negative error code from the ccr read error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 3265f4218878 ("net: phy: at803x: add fiber support")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: phy: at803x: fix error return code in at803x_probe()
    https://git.kernel.org/netdev/net/c/1f0dd412e34e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


