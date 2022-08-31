Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CA05A7699
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiHaGa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiHaGaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:30:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D181B5A161;
        Tue, 30 Aug 2022 23:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 411F4B81EF9;
        Wed, 31 Aug 2022 06:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB257C43141;
        Wed, 31 Aug 2022 06:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661927418;
        bh=tBiDYMeArABlNJXAOf1ORfNMLagaAyFyHlY58DqnxQM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=igfBMjLnChY5AHxPvn3n35mGMuxX1DVkKuM31SQqIAwf9u99ZW495FvidQcpnyMze
         c6q7gnYJnhnHk2kYCp++JorFxLhU5Z/ojY9DUNLXab4c4UkAi1RFp7dKk8k9twdRBS
         7FuqvD3MDp7XMJZIRsFjh6kKM5eNiwa/tjwo76G3FJg5yhSvvHzeW1+S7awx8Z5Mmz
         f6bs89NjOgfvlKbk0vWe0mulA84QlbSgLR+bNwpqyfylHZfQBXJVSHc6mlCnCKI0yR
         Phdp13nBx+LRWUCLmnRbG7pWLWXE4oEqBp3eMqluEyeBcbAyO4mgmHAf9d70EN10QG
         xppJnhRbZDDcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5E0CE924D6;
        Wed, 31 Aug 2022 06:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mlxsw: minimal: Return -ENOMEM on allocation failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166192741780.4297.10553152157089963359.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 06:30:17 +0000
References: <YwjgwoJ3M7Kdq9VK@kili>
In-Reply-To: <YwjgwoJ3M7Kdq9VK@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     idosch@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jiri@nvidia.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 Aug 2022 18:03:30 +0300 you wrote:
> These error paths return success but they should return -ENOMEM.
> 
> Fixes: 01328e23a476 ("mlxsw: minimal: Extend module to port mapping with slot index")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/minimal.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] mlxsw: minimal: Return -ENOMEM on allocation failure
    https://git.kernel.org/netdev/net-next/c/57688eb887af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


