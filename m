Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6920635EEF
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238700AbiKWNHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238861AbiKWNHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:07:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4FAE0DD5;
        Wed, 23 Nov 2022 04:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE26FB81F72;
        Wed, 23 Nov 2022 12:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BBF5C433C1;
        Wed, 23 Nov 2022 12:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207815;
        bh=Rwnqe+d+f8uO+vt7eyPZUvBUdxUgOipJ+45IIg74uDA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rr5cyBtSeiCCsOgCTG0kVwZX6caXsH+IHJsKNHxWm0qzDJ3HGWKVWRUxzDENU37iU
         fcaoqyLOSDRjPvt/hjvhTjwb99KNYggA5uASSMOYEF2y0mxsZ45madSvB9+vhYQjIo
         67qfMxhp2pGiwdLwHQImqTGTInoDQXPmrlOqjnV/CoCThQzAPLvkNtTYnXdEpHMRTa
         jrhOIniUfDbkQcUmxDQcCM/jDBmRuiTBjRza4rwnaVnW7RmauRS/1o89aDFegOvs8G
         w6MkfG7qBJVrWLyxiarfjqsO8+UphYVc1hy9eNDZVA4rzSPARXHmqEah30L9PC98Vf
         f8vQaM0T972/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2A7ABC395ED;
        Wed, 23 Nov 2022 12:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] arcnet: fix potential memory leak in com20020_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166920781516.7047.7595861515103191510.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 12:50:15 +0000
References: <20221120062438.46090-1-wanghai38@huawei.com>
In-Reply-To: <20221120062438.46090-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     m.grzeschik@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@dominikbrodowski.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Sun, 20 Nov 2022 14:24:38 +0800 you wrote:
> In com20020_probe(), if com20020_config() fails, dev and info
> will not be freed, which will lead to a memory leak.
> 
> This patch adds freeing dev and info after com20020_config()
> fails to fix this bug.
> 
> Compile tested only.
> 
> [...]

Here is the summary with links:
  - [net] arcnet: fix potential memory leak in com20020_probe()
    https://git.kernel.org/netdev/net/c/1c40cde6b517

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


