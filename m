Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B06B5EF250
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 11:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbiI2JkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 05:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbiI2JkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 05:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799721AD82
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE03460E07
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 09:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DA5AC433B5;
        Thu, 29 Sep 2022 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664444415;
        bh=Hua47d9r0LqMZVMrmRqScvWEKWYSJJ1d5o9dWXhfAUM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b9Tz3fpty++LdfZPAcjTOkyW2fTqVX41Iho6G3cHEQ95ajZsAOva+UNtuxNNPzL70
         s6xDZIblJR+PCCaLTkp1rl2DS8qZ1pt3fFEhDOHzzcimxSQhCc1LhxX/QnYtV2sF5/
         9jwZOCUgfQIywtp1sXS4TuwZ9wGc5ARNvEqXf0Y8NtxTP4wqPin1LHs6VNr5RKbU5g
         BQyRgcEHdYA4pWLSqixK4HVOBHQMC7PAnwnfxuESjhHr67p9uOT5hcxiH0qFWhmTYQ
         jG0OQqTCyfiESBBXP1lb4ZGkM2cvWLJzTloTXNsKv2HSUB2YsIB1diA1zUF97VU1aj
         /qyHZI4UwZ2PA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 03920E4D01B;
        Thu, 29 Sep 2022 09:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethernet: 8390: remove unnecessary check of mem
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166444441501.5703.17301364528175756194.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 09:40:15 +0000
References: <20220927151406.797800-1-yangyingliang@huawei.com>
In-Reply-To: <20220927151406.797800-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 27 Sep 2022 23:14:06 +0800 you wrote:
> The 'mem' returned by platform_get_resource() has been checked in probe
> function, so it is no need do this check in remove function.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/8390/mcf8390.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] ethernet: 8390: remove unnecessary check of mem
    https://git.kernel.org/netdev/net-next/c/0e9804cff182

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


