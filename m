Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1A9568746
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 13:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbiGFLuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 07:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbiGFLuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 07:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E82286CF
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 04:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1772DB81C20
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 11:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0DD3C341C0;
        Wed,  6 Jul 2022 11:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657108212;
        bh=UE0sFS3hFEy0S7ofUd7npxO4gcSngzOidRbx/RQNt3Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eR2CFtEKMs4Q+zExj9ZuNP5M4sBiQSxiN0ZI7WEm+t/J253CKaS6FaUFZXJxv8M6G
         QsezlD8Y+SmmP7t8zxUnOZEcHYopiZ4VNQ0QdwHcxEsTXGXK4pa+tKxyBkjsBFNwLK
         pTH+dzBmVikUkXzfUeXPUPLEw4F6PINLUPD8Ondq1qL7de8XnRbGgOsYOqGmNs1oJE
         Y8gr40ZGBswg1dx4tVHF8XUYeoa3QOjSqhupd5E9W4Wy6Aiq3wHSDILyCg9GweiGn/
         Xi7hl2/p6MBCc57/reKtx/nmX0egLgKaS6dPKEd6Y0wN+grCidENV7h5sSCBvecDt7
         4UC+d7jcRVnCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 874C9E45BD9;
        Wed,  6 Jul 2022 11:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] Fix police 'continue' action offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165710821254.17892.518464885237285514.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Jul 2022 11:50:12 +0000
References: <20220704204405.2563457-1-vladbu@nvidia.com>
In-Reply-To: <20220704204405.2563457-1-vladbu@nvidia.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@nvidia.com,
        jianbol@nvidia.com, idosch@nvidia.com, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, netdev@vger.kernel.org,
        maord@nvidia.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 4 Jul 2022 22:44:03 +0200 you wrote:
> TC act_police with 'continue' action had been supported by mlx5 matchall
> classifier offload implementation for some time. However, 'continue' was
> assumed implicitly and recently got broken in multiple places. Fix it in
> both TC hardware offload validation code and mlx5 driver.
> 
> Vlad Buslov (2):
>   net/sched: act_police: allow 'continue' action offload
>   net/mlx5e: Fix matchall police parameters validation
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/sched: act_police: allow 'continue' action offload
    https://git.kernel.org/netdev/net/c/052f744f4446
  - [net,2/2] net/mlx5e: Fix matchall police parameters validation
    https://git.kernel.org/netdev/net/c/4d1e07d83ccc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


