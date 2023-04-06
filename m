Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C0A6D8D4C
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbjDFCKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234351AbjDFCKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D85559B
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFA9962CEA
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4037DC4339E;
        Thu,  6 Apr 2023 02:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680747018;
        bh=8PjuXgN8aQ2O91FPsyunbYhIQpHbXSNu7DO1dRFNg+c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a0q1bCHnNfI2OkofRP/cjGAlfTIYJ/d0fBYDPTUSg6TR4YkPFaazAUTy31Mrt25LV
         Yuz0c0ub/Gt7XqO8pTdH+EYGumBg9vVTg5VyHjWlugE+/+PHJ0SLgrH6T6VYxY5PHE
         1j0u03Ix0SOKYViXW0JPJ8PR3JwszY+RYGI4axDFNNp1H9emvkKKP1yfZNSeqzGm2t
         Ew1ltVY6BFQSNGIXob9Ey+A2BLGXC87W81hYuxbb3Z8liXsXo4dO/Jg3n+TscrRx+i
         FoGJKClI4WbbvrO0wN6xG9jYI2pclUHxC5bQbbJCrVNJE2RpsuczxUeO00TryX3G/N
         5tk8Rex9Hg5UQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 05044C4167B;
        Thu,  6 Apr 2023 02:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: net: rps_default_mask.sh: delete veth link
 specifically
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168074701801.16861.10286793160931620799.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 02:10:18 +0000
References: <20230404072411.879476-1-liuhangbin@gmail.com>
In-Reply-To: <20230404072411.879476-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  4 Apr 2023 15:24:11 +0800 you wrote:
> When deleting the netns and recreating a new one while re-adding the
> veth interface, there is a small window of time during which the old
> veth interface has not yet been removed. This can cause the new addition
> to fail. To resolve this issue, we can either wait for a short while to
> ensure that the old veth interface is deleted, or we can specifically
> remove the veth interface.
> 
> [...]

Here is the summary with links:
  - [net] selftests: net: rps_default_mask.sh: delete veth link specifically
    https://git.kernel.org/netdev/net/c/38e058cc7d24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


