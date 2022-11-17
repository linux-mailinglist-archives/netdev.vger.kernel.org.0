Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D8662DA8A
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbiKQMUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbiKQMUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:20:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86158CDB;
        Thu, 17 Nov 2022 04:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FC6DB8202B;
        Thu, 17 Nov 2022 12:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D15FAC433D7;
        Thu, 17 Nov 2022 12:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668687615;
        bh=zwN5bVe5WAkj+FXvlwFf9oL8ehM6z67yh4sK5wyiV/c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rJI1Q+kDLJCrGIt03RTzmScSKVcracSu/n6aHGv1vXzZycjEsZVUvcX+dO5OB/1qu
         8qJnIdqqn59eKvh0ILUg/fm14yRmjehF4lX3jcl8PSo+qiD4UM60XP4hRL2wHv6bgi
         LBxtyG75Q8at0tnjFIOVR8shCcebmXJFujXGF4gduAwLXnA1FP0HuIDxFNULSx7RdH
         3AVxPg1pEl+g41ME+JDiigs8aF23s9E2f6UJ+xjg+eUSg3paMYGa3HBrQUG+J1dL1F
         ybGu48jBv9GbtOPW18vERTSIat0FUZsZb7Rd3L+0vWiGhpEPRygMxe6y2WDS1XpWZi
         Y7TbcBc5JH5yQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B6EBCE29F44;
        Thu, 17 Nov 2022 12:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sctp: sm_statefuns: Remove pointer casts of the same type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166868761574.3361.9152586755960572521.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Nov 2022 12:20:15 +0000
References: <20221115020705.3220-1-zeming@nfschina.com>
In-Reply-To: <20221115020705.3220-1-zeming@nfschina.com>
To:     Li zeming <zeming@nfschina.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 15 Nov 2022 10:07:05 +0800 you wrote:
> The subh.addip_hdr pointer is also of type (struct sctp_addiphdr *), so
> it does not require a cast.
> 
> Signed-off-by: Li zeming <zeming@nfschina.com>
> ---
>  net/sctp/sm_statefuns.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - sctp: sm_statefuns: Remove pointer casts of the same type
    https://git.kernel.org/netdev/net-next/c/b0798310f84c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


