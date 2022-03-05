Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4394CE47D
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 12:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiCELVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 06:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCELVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 06:21:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBF04B40F
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 03:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64515611F5
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 11:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD99CC340F2;
        Sat,  5 Mar 2022 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646479213;
        bh=885zk7Y/41/mL1DgEDDTSEALzxgfdPCH27ObUmudG9k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qJ4cKUrUsdTAns1YiDMjEcFG8bXqSYk8kCSpcboMj+smN075RtbxpsaRG/tMzadpP
         3clv2dw2sqqZ1F7vkwuA83rkBvc1iKwDFY7HpItnnh0MsUUdVs4Yt8FWo7Va0vh4Uk
         rouxE9vTOWtTV8VcIWJc7NW2ysHafqC8ogClUTzlCJnoOgxz660lgMRpCAWGpAbQlA
         3cPXFfXu4W1OjfZ3ZNeIOL56fbhvO6zSebEFjBwpW5V+BGo3c63G4jbVt9kIBEMC8K
         4St4QYTPiVyf7wmUtWpjwftTP4b+uRrKMdcOeYk4x9NkGGKC0vKILlvH1xWBDGvFm/
         WsTh3Zn9xyCQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F148F0383B;
        Sat,  5 Mar 2022 11:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] bnxt_en: Updates.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164647921358.16870.18042647942636680702.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Mar 2022 11:20:13 +0000
References: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Sat,  5 Mar 2022 03:54:33 -0500 you wrote:
> This patch series contains mainly NVRAM related features.  More
> NVRAM error checking and logging are added when installing firmware
> packages.  A new devlink hw health report is now added to report
> and diagnose NVRAM issues.  Other miscellaneous patches include
> reporting correctly cards that don't support link pause, adding
> an internal unknown link state, and avoiding unnecessary link
> toggle during firmware reset.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] bnxt_en: refactor error handling of HWRM_NVM_INSTALL_UPDATE
    https://git.kernel.org/netdev/net-next/c/8e42aef0b730
  - [net-next,2/9] bnxt_en: add more error checks to HWRM_NVM_INSTALL_UPDATE
    https://git.kernel.org/netdev/net-next/c/54ff1e3e8fc3
  - [net-next,3/9] bnxt_en: parse result field when NVRAM package install fails
    https://git.kernel.org/netdev/net-next/c/02acd399533e
  - [net-next,4/9] bnxt_en: introduce initial link state of unknown
    https://git.kernel.org/netdev/net-next/c/0f5a4841f2ec
  - [net-next,5/9] bnxt_en: Properly report no pause support on some cards
    https://git.kernel.org/netdev/net-next/c/9a3bc77ec65e
  - [net-next,6/9] bnxt_en: Eliminate unintended link toggle during FW reset
    https://git.kernel.org/netdev/net-next/c/7c492a2530c1
  - [net-next,7/9] bnxt_en: Do not destroy health reporters during reset
    https://git.kernel.org/netdev/net-next/c/f16a91692866
  - [net-next,8/9] bnxt_en: implement hw health reporter
    https://git.kernel.org/netdev/net-next/c/bafed3f231f7
  - [net-next,9/9] bnxt_en: add an nvm test for hw diagnose
    https://git.kernel.org/netdev/net-next/c/22f5dba5065d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


