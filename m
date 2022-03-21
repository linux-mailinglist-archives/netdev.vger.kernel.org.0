Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34664E3415
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbiCUXOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbiCUXNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:13:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC86D3FF244;
        Mon, 21 Mar 2022 16:00:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A13A61472;
        Mon, 21 Mar 2022 23:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBB42C340F0;
        Mon, 21 Mar 2022 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647903611;
        bh=5h2oCoQvtO3snJn2Kt0EzGtHfVi7KNO5+nJL43iXyTk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U1WaXkuJF8Bwgn04zXMr9gRo9L50wlOaS85J5TewKszNsY0yfG/vh0dS6YwGMkWJD
         nBMcY5qmq/xC0lp9WWfie4cM/kLMndfZP/DMLjSCX3afXBRRbiKHogIrlKHKpFDYOg
         QtpfEJQO7DdlzHYQrDOxEyyTA1Njroiwag4KBlPv16LJxFxOMgyNS68X7lsx1G2cx4
         ncCHTeoVLaNwW4IMnlCZgLdKGf6mU6JNX2yjHYt9Rq9YN1DaXvW4hCtq/lqI3/7IAq
         /IZ08TMQQ7/6jZGeGkDVroCAQtA0Pfc8VniQKCmh1SMOprD9DKKlDp4zN6LUGWIYH5
         /twfzzqCS3EgA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF02BE6D44B;
        Mon, 21 Mar 2022 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] net/tls: some optimizations for tls
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164790361171.11439.7928272038807397996.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 23:00:11 +0000
References: <cover.1647658604.git.william.xuanziyang@huawei.com>
In-Reply-To: <cover.1647658604.git.william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        pabeni@redhat.com, linux-kernel@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 19 Mar 2022 11:13:34 +0800 you wrote:
> Do some small optimizations for tls, including jump instructions
> optimization, and judgement processes optimization.
> 
> ---
> v1-v2:
>   - Delete a new line before "return rc;" in patch 2.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net/tls: remove unnecessary jump instructions in do_tls_setsockopt_conf()
    https://git.kernel.org/netdev/net-next/c/1ddcbfbf9dc9
  - [net-next,v2,2/2] net/tls: optimize judgement processes in tls_set_device_offload()
    https://git.kernel.org/netdev/net-next/c/b1a6f56b6506

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


