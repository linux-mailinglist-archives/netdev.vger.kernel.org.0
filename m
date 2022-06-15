Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C0654BFA1
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 04:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345519AbiFOCU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 22:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244004AbiFOCUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 22:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C914927CE6;
        Tue, 14 Jun 2022 19:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37021B81BE7;
        Wed, 15 Jun 2022 02:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1EF6C341C4;
        Wed, 15 Jun 2022 02:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655259614;
        bh=RkK29Anq4ut5sOL8np/E3I3mXEVNbem0IfIyeWhC9M4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cE71ktGeCO0zpq+1rPuBU1qv9KwA0ktV/QLdtl7jA5exq6xXOA9tAJ/JNX+0AexkD
         u3lFi7OeVAB6j7Q9WpREFQc1yK4hHbKqpFC5LV85zxZv7Ebz7oqt/5eqTH/nVEMbYE
         lP9drFwmtiDeNNT8DLBOQG2TsRFKS8z7SfNAeNevpOb925WnGCs4Octc16zZ3XtxW4
         6527IXrCOFgY8q6KbZUH5VAGkM8ZUAek8T1zz5xPaHD9NPPyX1be+qHm8pnPsgiKgD
         62x5v08yIGU7OSdvUGf9U6vgP22PUjKsCSfnSohf0GBVRIOrIaGvmMiivXK2HY+Aqr
         aAM+TOiChyXTg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9DFEFFD99FF;
        Wed, 15 Jun 2022 02:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL][next-next][rdma-next] mlx5-next: updates 2022-06-14                               
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165525961464.10274.8388525139871863585.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 02:20:14 +0000
References: <20220614184028.51548-1-saeed@kernel.org>
In-Reply-To: <20220614184028.51548-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     jgg@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, leonro@nvidia.com,
        saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Jun 2022 11:40:28 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> The following changes since commit f2906aa863381afb0015a9eb7fefad885d4e5a56:
> 
>   Linux 5.19-rc1 (2022-06-05 17:18:54 -0700)
> 
> are available in the Git repository at:
> 
> [...]

Here is the summary with links:
  - [GIT,PULL,next-next,rdma-next] mlx5-next: updates 2022-06-14
    https://git.kernel.org/netdev/net-next/c/6ac6dc746d70

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


