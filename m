Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4806052615F
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 13:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380063AbiEMLuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 07:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380056AbiEMLuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 07:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82051F8F0B
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 04:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93D00B82ED1
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B8FAC3411A;
        Fri, 13 May 2022 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652442615;
        bh=8aIkZWC3MI/iuJUCpmLCHr4091RVS1jHqPo854E78Tw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gmmj+MM2URa98Nb+OXsXc9hyaRKbAles0rrpNzKfDbCsd8jmtN5c2gDMyofJ/DmZb
         xGTI874fvLij2PxCmbDUwcrs1X0YydO2RM7yvRMYIcc4DTjgr/+zStvJYtHkWe35xB
         GY96nSn/44hBVjA7VeF9/xhpFwdFHWYHPROG0VjRw8aAJcB+nOF6YfjLBb2dh8SwxJ
         u9qRNMErAcswnyMQCwVKM1zebvUFm80ZzPn1tOPc45ph1aq1tHVQKt5stCKMFAuFJh
         glqm5X7BlsGYG+kvXFg7D4I9NpiKmnSwSHSLIJF6eptqRuqV+XupgySQHIOEHaVZB3
         e3YAZDjlEjxog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3A25CF03935;
        Fri, 13 May 2022 11:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] bnxt_en: Updates for net-next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165244261523.26306.11266147506673788204.git-patchwork-notify@kernel.org>
Date:   Fri, 13 May 2022 11:50:15 +0000
References: <1652409624-8731-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1652409624-8731-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 12 May 2022 22:40:20 -0400 you wrote:
> This small patchset updates the firmware interface, adds timestamping
> support for all receive packets, and adds revised NVRAM package error
> messages for ethtool and devlink.
> 
> Kalesh AP (1):
>   bnxt_en: parse and report result field when NVRAM package install
>     fails
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] bnxt_en: Update firmware interface to 1.10.2.95
    https://git.kernel.org/netdev/net-next/c/ad04cc058d64
  - [net-next,2/4] bnxt_en: Configure ptp filters during bnxt open
    https://git.kernel.org/netdev/net-next/c/11862689e8f1
  - [net-next,3/4] bnxt_en: Enable packet timestamping for all RX packets
    https://git.kernel.org/netdev/net-next/c/66ed81dcedc6
  - [net-next,4/4] bnxt_en: parse and report result field when NVRAM package install fails
    https://git.kernel.org/netdev/net-next/c/ab0bed4bf6fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


