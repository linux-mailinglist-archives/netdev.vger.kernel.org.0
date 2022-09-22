Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCACE5E65FF
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiIVOlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiIVOk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:40:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F437E309
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 07:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1620B837EF
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 79C2BC433D7;
        Thu, 22 Sep 2022 14:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663857614;
        bh=o/rkJb8pWfWbMsRrDzUMwGpTIxxJLvbb8ztEnWEJI+0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qV5eape96c3GTCF0NnzcYgQ9+jKNq675Bu04F7KaeGPpd1s3HBowa7UaO4+fcfKMH
         dU7EidfIh22YJTsSpMCIgDcjtvENT4988r5YJVPQtU7oCIU7hiS/rBOKSNJyPBHuEJ
         31msmmzlTnMDrKuBBJ7vG34rwvbLLmcYtbRtXWIs7KKhv4kQj/2PVgLhV0ApsztbfV
         vPTvXLuEB2FW1gL+6oEcd9gEXaPrlzdEHtqNAohfaQUVOcUrF8yVlKKrLcset3FJib
         7uXCRjdlv8Tqj8Yk6C+Ws1R2GB5mtDuJyVkLhLVf3ZR+MW+erVnF6fWeYmNbyFMxJ1
         lsuAV1wYNclHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B7B5E4D03F;
        Thu, 22 Sep 2022 14:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: forwarding: add shebang for sch_red.sh
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166385761437.22604.1345969771959253503.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 14:40:14 +0000
References: <20220922024453.437757-1-liuhangbin@gmail.com>
In-Reply-To: <20220922024453.437757-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, dsahern@kernel.org,
        petrm@mellanox.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 22 Sep 2022 10:44:53 +0800 you wrote:
> RHEL/Fedora RPM build checks are stricter, and complain when executable
> files don't have a shebang line, e.g.
> 
> *** WARNING: ./kselftests/net/forwarding/sch_red.sh is executable but has no shebang, removing executable bit
> 
> Fix it by adding shebang line.
> 
> [...]

Here is the summary with links:
  - [net] selftests: forwarding: add shebang for sch_red.sh
    https://git.kernel.org/netdev/net/c/83e4b196838d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


