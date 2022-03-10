Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEFEB4D3FE4
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 04:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239327AbiCJDvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 22:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239320AbiCJDvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 22:51:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CAE12A761;
        Wed,  9 Mar 2022 19:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 405A5617CB;
        Thu, 10 Mar 2022 03:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 954DAC340F6;
        Thu, 10 Mar 2022 03:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646884210;
        bh=kdFN+ZxawFeOYO+NPEeoYxMxb8yCjIulGptx4+kxFBI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mWXPnwv0LP0a/bNmIr9AIjjCIAkTM/2ftvieTdSnA085ddeL2fMMosmysItaY1+R8
         jszRl3navG2SJwDS8XNRlhddER0RdGcW1Hw+TCc1OY6+YK/ICogwYUOZiPEZbcNUAv
         fgPXbaDbOSWBcJxh0sTwQGGiekKIH7O/0fVtQrYhgtb/wc6yEvbQzzm3hhED0/dZhV
         W5krj9YyTH08FEW+qXAnnIe/LINZmwn+M5SPBeKqeF8GcT4rmxYdjuRDdKwgc4L9cD
         w431LL1xdPutbE6IdnN40FrZ5kxNdN7lFYcbq4/uDPcTkDe4kjgnvO/yBnCqGPNmZC
         hZpNwchngx5xw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 771DDE8DD5B;
        Thu, 10 Mar 2022 03:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH linux-next v2] drivers: vxlan: fix returnvar.cocci warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164688421048.27281.6372396210369759355.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 03:50:10 +0000
References: <20220308134321.29862-1-guozhengkui@vivo.com>
In-Reply-To: <20220308134321.29862-1-guozhengkui@vivo.com>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        edumazet@google.com, bigeasy@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengkui_guo@outlook.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  8 Mar 2022 21:43:09 +0800 you wrote:
> Fix the following coccicheck warning:
> 
> drivers/net/vxlan/vxlan_core.c:2995:5-8:
> Unneeded variable: "ret". Return "0" on line 3004.
> 
> Fixes: f9c4bb0b245c ("vxlan: vni filtering support on collect metadata device")
> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
> 
> [...]

Here is the summary with links:
  - [linux-next,v2] drivers: vxlan: fix returnvar.cocci warning
    https://git.kernel.org/netdev/net-next/c/e58bc864630f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


