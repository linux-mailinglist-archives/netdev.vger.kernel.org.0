Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E255697F6
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 04:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbiGGCaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 22:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiGGCaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 22:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C370E2E697
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 19:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FF48B81FAA
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 02:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 027EAC341CA;
        Thu,  7 Jul 2022 02:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657161013;
        bh=A9Y4kzO4IQB7hbgD5zUGGOADSmtntg1kIVNL4xbsFdY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EbqcGPVSJ1v3g/L17j4Lf5+Xe/e2Jp2T2JZV1ojm+n2gnzhujSHobxsvSToIxyt6d
         suXtLTM15CyAABlQ+1dRckcFp4vJNhf/wmmpiDwgcx5uykcu7GwcMNRAstUo9JNzpU
         Cf1wuIDv9fNAKkRVIO2yUi0XRmYTJ/c62cdSsehwNWiYN0b/fwTG0kU+01exqtaoJf
         4a7pnin3qqNWodEVeoB86QX/b7t2a5L1fS0JmuDQMMJfaoeiVpIuxKCrks/Ihbq247
         VmIIyJZlxJwP1HyxZARWpj0Y+MixRT7Vov7PY3p0o4tqahFbokaN5lJoOXnF7PT+6r
         75s3iXAdD1AGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9FAFE45BD9;
        Thu,  7 Jul 2022 02:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "Merge branch 'octeontx2-af-next'"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165716101288.29614.11685072662484235825.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jul 2022 02:30:12 +0000
References: <20220707013201.1372433-1-kuba@kernel.org>
In-Reply-To: <20220707013201.1372433-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, rkannoth@marvell.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  6 Jul 2022 18:32:01 -0700 you wrote:
> This reverts commit 2ef8e39f58f08589ab035223c2687830c0eba30f, reversing
> changes made to e7ce9fc9ad38773b660ef663ae98df4f93cb6a37.
> 
> There are build warnings here which break the normal
> build due to -Werror. Ratheesh was nice enough to quickly
> follow up with fixes but didn't hit all the warnings I
> see on GCC 12 so to unlock net-next from taking patches
> let get this series out for now.
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "Merge branch 'octeontx2-af-next'"
    https://git.kernel.org/netdev/net-next/c/69d7d257cd35

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


