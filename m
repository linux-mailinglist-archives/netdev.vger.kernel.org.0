Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E37699D15
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 20:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjBPTkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 14:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjBPTkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 14:40:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E184C3D0;
        Thu, 16 Feb 2023 11:40:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE27360AF5;
        Thu, 16 Feb 2023 19:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4CED5C4339B;
        Thu, 16 Feb 2023 19:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676576434;
        bh=NeMXaBl39Nypdvex1C7YTQGUvXvWRpcPhPehhhcpfi4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s7reDAKmPJC51hNgJ3c68UXoxXa2Egbolo2OORy2wFzDOb1P3siPus7B5zL0/iWav
         4XGiwDM/8aDlIYdlVuK5wMb4j70ONGqHfwBY9N92wUFNvRp2SjDgC904yvsFwmltk7
         Q4nMtnAq9eLoH5DTTob8BPJUsCWfGmM90wssKAVuTsdN5Dw/nFbzWfpPd8W/fwPImW
         wv/btqlPkyPmKRyMkUhrp65S6OYI2ZKKfYOk6ssogUCvd746dR+6FFazZ37ML3M+J9
         LXZK7UpET4khmISoxws23V5kSr3HiVwIpoYm/t4KRrqeQvS8Pxq8lRuaOCclsBprFt
         ZLniz/yA08SQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3260FE270CB;
        Thu, 16 Feb 2023 19:40:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Please pull mlx5-next changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167657643420.21159.10847582499249880114.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 19:40:34 +0000
References: <20230215095624.1365200-1-leon@kernel.org>
In-Reply-To: <20230215095624.1365200-1-leon@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     jgg@nvidia.com, pabeni@redhat.com, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Feb 2023 11:56:24 +0200 you wrote:
> Hi Jason,
> 
> Following previous conversations [1] and our clear commitment to do the TC work [2],
> please pull mlx5-next shared branch, which includes low-level steering logic to allow
> RoCEv2 traffic to be encrypted/decrypted through IPsec.
> 
> Thanks
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Please pull mlx5-next changes
    https://git.kernel.org/netdev/net-next/c/84cb1b53cdba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


