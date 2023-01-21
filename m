Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201E9676300
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 03:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjAUCUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 21:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjAUCUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 21:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C5571345;
        Fri, 20 Jan 2023 18:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E164B82B09;
        Sat, 21 Jan 2023 02:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC2A4C433D2;
        Sat, 21 Jan 2023 02:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674267616;
        bh=ZUsPg4Kr/C+/7WTA9W/Y4G22KxjoxR+qYGPDDGoBCiI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lXaOKRE/xbWzMDgTtIVY5MhqG6L0bBwvEqV+TgliKLMGygXmQNMJNy7AQfCj3aYU4
         9dCxT2t0yANdiFupeROSPCCVjCa0/RwcNmPGM4MqSRlccCVrnSn20eHQA9dmofnznh
         gahBJMUp1f5V9s6ANAIacTeXp9ErtwoiHkTMIvqe0eV1qX5VCMl5MzdFXZUoh4el1v
         a8YTmxNcMfNJD7A5NsXMyyza6uIvlxNZhFwZRpSHhJD1Yf6vDtUpLcy+uChjYDKme9
         tBDZVWxNyOKmK4idqrabC5NWCPkgy/YBpgPPn4CKMSCAuoM8Ya/EJUDdoRtdUwHWlP
         YwF6Aw/tC4cVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B63FC395DC;
        Sat, 21 Jan 2023 02:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mana: Fix IRQ name - add PCI and queue number
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167426761663.30830.2616442699421099701.git-patchwork-notify@kernel.org>
Date:   Sat, 21 Jan 2023 02:20:16 +0000
References: <1674161950-19708-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1674161950-19708-1-git-send-email-haiyangz@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
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

On Thu, 19 Jan 2023 12:59:10 -0800 you wrote:
> The PCI and queue number info is missing in IRQ names.
> 
> Add PCI and queue number to IRQ names, to allow CPU affinity
> tuning scripts to work.
> 
> Cc: stable@vger.kernel.org
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> [...]

Here is the summary with links:
  - [net] net: mana: Fix IRQ name - add PCI and queue number
    https://git.kernel.org/netdev/net/c/20e3028c39a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


