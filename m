Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34C955027B
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbiFRDaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiFRDaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4D469CF9;
        Fri, 17 Jun 2022 20:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A39BDB82D1F;
        Sat, 18 Jun 2022 03:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A959C3411E;
        Sat, 18 Jun 2022 03:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655523013;
        bh=imZHSh61aXEmeSuzVYB46shMBkAiRz4LBhIdGDei7uw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CoLBeiqnMkQayAFQu3ZzfzaEuH3m4blvIILNipETVLBaypLpRYgn5evT9Mn8VMybd
         J0UDkztCvcoSCnksOAZ85vDdscjGA58k24cE1KTGRPfUj8SfaY6OZ2gZsLcQ0yBKTH
         9aAoNTR08droCSO5ITuR5pbSZQkWbDO+iU/5QNK+eqG8zFDHK2kbNKW9qLxzIpn03T
         RhuRY8Ws65qljA/VaAEKxojWxKRByNmfN830YCiT4b/grpLYQBdM7WQdPjnfeo/IY8
         z5fcabNRW3l54FzCIe9MhFA/XVXNfI5KN37rPm5kcXrWs/iyd3CCyx+wDgmNDmwZN6
         gnzjVE/34hZNQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3CC99E7387A;
        Sat, 18 Jun 2022 03:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethtool: Fix get module eeprom fallback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165552301324.7046.10386873519636092978.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Jun 2022 03:30:13 +0000
References: <20220616160856.3623273-1-ivecera@redhat.com>
In-Reply-To: <20220616160856.3623273-1-ivecera@redhat.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, idosch@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vladyslavt@nvidia.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Jun 2022 18:08:55 +0200 you wrote:
> Function fallback_set_params() checks if the module type returned
> by a driver is ETH_MODULE_SFF_8079 and in this case it assumes
> that buffer returns a concatenated content of page  A0h and A2h.
> The check is wrong because the correct type is ETH_MODULE_SFF_8472.
> 
> Fixes: 96d971e307cc ("ethtool: Add fallback to get_module_eeprom from netlink command")
> Cc: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] ethtool: Fix get module eeprom fallback
    https://git.kernel.org/netdev/net/c/a3bb7b63813f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


