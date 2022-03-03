Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCCB4CBB61
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 11:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbiCCKbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 05:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbiCCKa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 05:30:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E627E179A24;
        Thu,  3 Mar 2022 02:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E2C560BFF;
        Thu,  3 Mar 2022 10:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00B73C340F2;
        Thu,  3 Mar 2022 10:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646303412;
        bh=GhhKCDrH4JQOA+Apel0fm/Fn8ks4tUJHd3WuIEOhKd4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XBN13Z3xtAnUduC/ZWUmLQisZhnsiiPQqZUcL2qtUSb0FaqWBjWeMLNfyEnxcG/Ys
         +u1IWb7Pov671VOybutobIKsLSSWtuRQy6AHHtBD30VVJ6+wZTrghaoWj5vmShfUcl
         /1bYhxl09X6JytX396iSvgf8njm6Nh5YbdOhUx1xtz4mgzJjvMUxXFyLJeLp/KNXmk
         pCRnM5LU1x251eAhDqekXyPhozQ3CU9ns56c9JDEGCRWIE9Hoq9OuzFqOorGPfkef7
         GRMXjSCP+eP3f6qHRyghZPgOIldB39jjoba0PADZNdfgRZEASZ+umSXBkNy+P38uXC
         vJLoHOJ/U6aeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC319E5D087;
        Thu,  3 Mar 2022 10:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2 net-next] net: stmmac: Enable support for Qualcomm
 SA8155p-ADP board
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164630341189.19668.6956989790890987614.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 10:30:11 +0000
References: <20220302103950.30356-1-bhupesh.sharma@linaro.org>
In-Reply-To: <20220302103950.30356-1-bhupesh.sharma@linaro.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     netdev@vger.kernel.org, bhupesh.linux@gmail.com, vkoul@kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  2 Mar 2022 16:09:48 +0530 you wrote:
> Changes since v1:
> -----------------
> - v1 can be seen here: https://lore.kernel.org/netdev/20220126221725.710167-1-bhupesh.sharma@linaro.org/t/
> - Fixed review comments from Bjorn - broke the v1 series into two
>   separate series - one each for 'net' tree and 'arm clock/dts' tree
>   - so as to ease review of the same from the respective maintainers.
> - This series is intended for the 'net' tree.
> 
> [...]

Here is the summary with links:
  - [v2,1/2,net-next] net: stmmac: Add support for SM8150
    https://git.kernel.org/netdev/net-next/c/d90b3120473a
  - [v2,2/2,net-next] net: stmmac: dwmac-qcom-ethqos: Adjust rgmii loopback_en per platform
    https://git.kernel.org/netdev/net-next/c/a7bf6d7c9249

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


