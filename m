Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225BB4B5319
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 15:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355072AbiBNOUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 09:20:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiBNOUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 09:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753DC49FB9
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 06:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0779DB8100C
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F40EC340EE;
        Mon, 14 Feb 2022 14:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644848409;
        bh=oD33EPNYYdslmTQdMUulkS9RJvF2DRgt4Q++mIVda8k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=efLHh3uPmWW8FVdSLoN4RexJW2MGJW0QSzuwkNXxcfox2iZZo/VDyYuVXSfSHYLQK
         Adaw0ebmJESfUo6HYfzGqJU6XW0p4k7nXkSG1ivyBF6gWsxIxh3k3VSWf99gN9SfvL
         k7bNd0JglhGe0eDX0Vfj1IkXy09/ZBEnOvBduwEDGDBgt1SKmdZapSfINIs18eHAyi
         rOzGyxwIZTI7iWuGk4BtI+mi7lgvz6iKZbVHq/iFdfHkDSGvZkQWJ019+gnnl0/tv6
         6aQTxXenY3gkOQfMGc60GugTbDqY3+WpZ04EC39NVJ9yeyvLSePAU1csEUW8tdO+3Y
         yksUCItgDLMgg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 88759E6D447;
        Mon, 14 Feb 2022 14:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: bridge: update my email
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164484840955.14634.9842780506195787827.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 14:20:09 +0000
References: <20220214112332.3330923-1-nikolay@nvidia.com>
In-Reply-To: <20220214112332.3330923-1-nikolay@nvidia.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, bridge@lists.linux-foundation.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 14 Feb 2022 13:23:32 +0200 you wrote:
> I'm leaving NVIDIA and my email account will stop working in a week, update
> it with my personal account.
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
> Routing through -net to get merged in net-next so there are no
> discrepancies. It applies also to net-next if that is preferred.
> 
> [...]

Here is the summary with links:
  - [net] MAINTAINERS: bridge: update my email
    https://git.kernel.org/netdev/net/c/603c692d5741

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


