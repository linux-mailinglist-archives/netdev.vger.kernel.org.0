Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAAA5EEC16
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbiI2Cua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234202AbiI2Cu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:50:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6A728E1A;
        Wed, 28 Sep 2022 19:50:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 545536200D;
        Thu, 29 Sep 2022 02:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A25ACC43470;
        Thu, 29 Sep 2022 02:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664419825;
        bh=tubfkDxWIIvpnStySyrVCci7ZewjNXhXbri8kj3N8aE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d6/vXL51Ps/Pk5cteqhp5lZAOxRsyTmmLHK+UFygtvWx41g7MqZWT04huawWpNc2Z
         mxoY6xrg4S0DiXf6mlgaZS4AK36evdwEhcuoSyy5XNwfTWN0KP57Hr9ZHSlhghpyw6
         QxmepZ/4lu+cvJ5hHbhPbU6fqiyb+R943keE2GKBcOeaXOsUx1G3BOWjQ5+vm7h+ap
         A9WJbqjPWNMrjj7AtgMlJkiWX/Y7eEzZTYl6ZMbsm1MKq8XRi9dcp1knL+XneHCY2X
         JcuVk6hM68rn027mHqcOHsjMPCtjx07tGSoi2eD3Sd3Y4Wr/DQSTXTkrqAtMnHfSiK
         TqdanwJRmF9EA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 856D9E4D024;
        Thu, 29 Sep 2022 02:50:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL][V2] updates from mlx5-next 2022-09-24
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166441982554.2371.18322511585722466183.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 02:50:25 +0000
References: <20220927201906.234015-1-saeed@kernel.org>
In-Reply-To: <20220927201906.234015-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jgg@nvidia.com, saeedm@nvidia.com,
        linux-rdma@vger.kernel.org, leonro@nvidia.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 27 Sep 2022 13:19:06 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Please pull mlx5-next branch
> 
> v1->v2:
>   - tossed already applied rdma commit.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL,V2] updates from mlx5-next 2022-09-24
    https://git.kernel.org/netdev/net-next/c/0d5bfebf7401

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


