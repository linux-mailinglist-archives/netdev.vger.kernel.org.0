Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 417565871B9
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbiHATuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235052AbiHATuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5FB6171
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 12:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85AC8B81689
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 19:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37342C43142;
        Mon,  1 Aug 2022 19:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659383414;
        bh=Y8ZNSSYphy+/0NyKT2EHjG9hnkGr15bKFyIPpZhCRmg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U0d+cUouqIyEiV0v9Buv1vqgkPQMIV2XoYtLw4NGKoFR2W2aRPror0NslsiGSMlj4
         3VN3qEfkA9GgSuAk0AlMNYDxOWtdCRBo/mGaSSSjBnuY6LoPiZLgTx68z/xPCLBwWf
         l+qEujUBqEmDa2BuawPxHonkaNE70278Krp67Ah1VxfuG5/c2fS3pTYdnKUr2ITqdl
         lrAXEADhfXyL3/0duwHkiwLZDxdNnAd9xfeRk+Ej9QflGBi46bgDTl00s/gWlFf+1i
         0BoL490ZtnAtIoYYM34vB3z/PhduUynxobmTV4Cjcgx7vrLCdUK0CuaD1bMX4SLbcU
         MJx4lv0S57jUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2560DC43144;
        Mon,  1 Aug 2022 19:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/tls: Remove redundant workqueue flush before
 destroy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165938341414.9721.17857423014346259286.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 19:50:14 +0000
References: <20220801112444.26175-1-tariqt@nvidia.com>
In-Reply-To: <20220801112444.26175-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, saeedm@nvidia.com, gal@nvidia.com,
        maximmi@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 1 Aug 2022 14:24:44 +0300 you wrote:
> destroy_workqueue() safely destroys the workqueue after draining it.
> No need for the explicit call to flush_workqueue(). Remove it.
> 
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  net/tls/tls_device.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [net-next] net/tls: Remove redundant workqueue flush before destroy
    https://git.kernel.org/netdev/net-next/c/d81c7cdd7a6d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


