Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81186C5E7F
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjCWFKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjCWFKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:10:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6711EFC6
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AC01B81F1A
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 05:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FDE8C433EF;
        Thu, 23 Mar 2023 05:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679548219;
        bh=FNGtDx5mKd5TEqSr9IOunDfmrppOdAq6yg5guEcCVaw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VrSl+TAshE4gomneguLjTutJ9YzhDM6OOMlmtExKTCJMoO2Z9q5HXstyG4shBfvL3
         1eZXRt1h1iWa5w5Gv44phO7ikagRddsPyVfXofbVtyKmE2RNuTjwRtdsTnY+46VDXr
         7jHtzyDRF8QD2oCrmX7e2eNWHP5By4stjnTaUpBk/LH1Knl1F6ET9QNLrstR4gTnbE
         fA0Tnn/Urxx3yY6kQLjyxZaZHZcZst8xvLmvv77wnTAYvVpRNKyxr7aCzNzNga/BXl
         dc4Q1Kv4MLPs/9tZ9CuQ4n0S1Wn7kSQxjMcsUoCeHjhRiIBmt3ONdP2bHJNHzv8Fpz
         /i+lgwEH6yL4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B35AE61B85;
        Thu, 23 Mar 2023 05:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Extend packet offload to fully support libreswan
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167954821917.28676.8873243993295057235.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 05:10:19 +0000
References: <20230320094722.1009304-1-leon@kernel.org>
In-Reply-To: <20230320094722.1009304-1-leon@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com, paulb@nvidia.com,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        saeedm@nvidia.com, raeds@nvidia.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Mar 2023 11:47:22 +0200 you wrote:
> The following patches are an outcome of Raed's work to add packet
> offload support to libreswan [1].
> 
> The series includes:
>  * Priority support to IPsec policies
>  * Statistics per-SA (visible through "ip -s xfrm state ..." command)
>  * Support to IKE policy holes
>  * Fine tuning to acquire logic.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Extend packet offload to fully support libreswan
    https://git.kernel.org/netdev/net-next/c/e4d264e87aa2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


