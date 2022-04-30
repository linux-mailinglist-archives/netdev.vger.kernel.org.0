Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648EB5159D4
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 04:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382078AbiD3Cnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 22:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379621AbiD3Cnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 22:43:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F15C34;
        Fri, 29 Apr 2022 19:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E0C1624D4;
        Sat, 30 Apr 2022 02:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 734A0C385AE;
        Sat, 30 Apr 2022 02:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651286412;
        bh=hMXm0FDPBVaRAA0ihJM2dwRadf7fwAMo07DedxmvExw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uW2Yi+i5wpuAow8kgyPrTBwgzVcV+9Ddt0fUW5ZAwMqnYUPpUEzWpAWzdCVLSa25A
         //7G1ZcWoyXjZhzCn7YPs/giIXTGZXR6Gm9LP76ND9XbQlD1DfC5Ck5mMBops+ASYZ
         1hgfTQ4dXweY8DT42/qECBtrxuS2IXRPpyr9EKI2lqMETbn81IdvZjR5K63WyjTplA
         tip8BUUIZ9Sblc7brHTDnXm6VKEaDJEcQJW2qWqADZiqta1lYTuwwHdu4DGZ0R9KF7
         aQgQ6JYf62j5m7bhczsSMK5xwi7a3T3v6us5xsER2XIccFaxGKyvkytwDkHXZpllaQ
         TqUxaOZ0lO+/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 549B4E8DBDA;
        Sat, 30 Apr 2022 02:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: mt7530: add missing of_node_put() in mt7530_setup()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165128641233.32243.13238642734431611860.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 02:40:12 +0000
References: <20220428095317.538829-1-yangyingliang@huawei.com>
In-Reply-To: <20220428095317.538829-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, dan.carpenter@oracle.com,
        andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 28 Apr 2022 17:53:17 +0800 you wrote:
> Add of_node_put() if of_get_phy_mode() fails in mt7530_setup()
> 
> Fixes: 0c65b2b90d13 ("net: of_get_phy_mode: Change API to solve int/unit warnings")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/dsa/mt7530.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - net: dsa: mt7530: add missing of_node_put() in mt7530_setup()
    https://git.kernel.org/netdev/net/c/a9e9b091a1c1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


