Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B9E4E7CEC
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiCZABw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 20:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiCZABu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 20:01:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09165DA31;
        Fri, 25 Mar 2022 17:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D5F3B82A9E;
        Sat, 26 Mar 2022 00:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44CD5C004DD;
        Sat, 26 Mar 2022 00:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648252812;
        bh=dX2SyFHr9niOTbQWNxyNk3ZjF15nVV76JJD1thEeLUI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c5x8lsbi6a6ROo30II0pt50lV+AmdwJITLVEltrgAaWP9oN5pF/QjtdDs8EeGeJci
         +ugQ59w4ouJaPuclIqw52Jco4qSwY1OeNjNuaEsU15BxGOfpWD0/ertKGdVvfbxvxo
         QPY9N+DIOAEy+PpUF12SWIrhDbDdTrICutcdLl6hfzxy2mDqeshDkcbqnk9vV9ySWK
         aTHViotMoejyYgFArGnJRV7xdmwy0p5nE2BEMnd9oBTXLc/9m6xaRqTvsH27Lwz8HF
         chPIlK2fJwyFP8Lre7zn9mPvu0I0zTgpTd1+PhQ21jVBg9oE9NoOVHg0rCyz1OXH9r
         t2/Zoi+o5YFCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2A6BCE6BBCA;
        Sat, 26 Mar 2022 00:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] net: hns3: add some fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164825281217.29666.7213436242346733301.git-patchwork-notify@kernel.org>
Date:   Sat, 26 Mar 2022 00:00:12 +0000
References: <20220324125450.56417-1-huangguangbin2@huawei.com>
In-Reply-To: <20220324125450.56417-1-huangguangbin2@huawei.com>
To:     huangguangbin (A) <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 24 Mar 2022 20:54:46 +0800 you wrote:
> This series adds some fixes for the HNS3 ethernet driver.
> 
> Jian Shen (4):
>   net: hns3: fix bug when PF set the duplicate MAC address for VFs
>   net: hns3: fix port base vlan add fail when concurrent with reset
>   net: hns3: add vlan list lock to protect vlan list
>   net: hns3: refine the process when PF set VF VLAN
> 
> [...]

Here is the summary with links:
  - [net,1/4] net: hns3: fix bug when PF set the duplicate MAC address for VFs
    https://git.kernel.org/netdev/net/c/ccb18f05535c
  - [net,2/4] net: hns3: fix port base vlan add fail when concurrent with reset
    https://git.kernel.org/netdev/net/c/c0f46de30c96
  - [net,3/4] net: hns3: add vlan list lock to protect vlan list
    https://git.kernel.org/netdev/net/c/1932a624ab88
  - [net,4/4] net: hns3: refine the process when PF set VF VLAN
    https://git.kernel.org/netdev/net/c/190cd8a72b01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


