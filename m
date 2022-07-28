Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEE0583B84
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 11:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbiG1JuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 05:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbiG1JuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 05:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2753ED75
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 02:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8964AB82396
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C9E2C433C1;
        Thu, 28 Jul 2022 09:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659001813;
        bh=uyamihGJPYpb+1UKyEZlh23ZP/yq8vuvWLYPDQDmWrM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mS/QBFZ/2FvwFdFCLNnovUq28fmJQ8MwA9VacyHCoalfP0aDTSuEPO4wZPAfULfGj
         jkbaMj/d0DDoLdQZ3GBPk2qPX4qhBSAtGIxopU7c6N6879bz+kOb7Bmgq19D9zbGYi
         W8ULARzOp2AzfllC0PkNgFDhOijm0hRodELyVpCHU9CEqMF4SvIfHbJJcmgsuHmiDF
         mUEOxEtV8nuOOvOvD8NLKznPr4cINUY5y+Db3hGu/sLxGpygOcSTImX+rT+xMg/8Fn
         uiAD11A0KzSOLhsIErvp83Bcsv4MLaHE+zktFLGaa+AVMPyyL1SGOvpHcEXvP1xa0n
         rFgndWEzFFRkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12C61C43143;
        Thu, 28 Jul 2022 09:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] add missing includes and forward declarations to
 networking includes under linux/
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165900181307.10387.10913900759777322330.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jul 2022 09:50:13 +0000
References: <20220726215652.158167-1-kuba@kernel.org>
In-Reply-To: <20220726215652.158167-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 26 Jul 2022 14:56:52 -0700 you wrote:
> Similarly to a recent include/net/ cleanup, this patch adds
> missing includes to networking headers under include/linux.
> All these problems are currently masked by the existing users
> including the missing dependency before the broken header.
> 
> Link: https://lore.kernel.org/all/20220723045755.2676857-1-kuba@kernel.org/ v1
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] add missing includes and forward declarations to networking includes under linux/
    https://git.kernel.org/netdev/net-next/c/5f10376b6bc1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


