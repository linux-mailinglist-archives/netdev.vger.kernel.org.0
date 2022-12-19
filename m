Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A028650BA7
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 13:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiLSMcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 07:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbiLSMbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 07:31:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58B7101E9;
        Mon, 19 Dec 2022 04:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98323B80DEC;
        Mon, 19 Dec 2022 12:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3740FC433EF;
        Mon, 19 Dec 2022 12:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671453016;
        bh=zSdqXMb4K/fJ1ucxsistP/D6X+IyGXlXaIYBLlqpdnA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JXobkxaK5msKZ8yEJMXg7aQQQUaNLkcxs/rJODgaYJRuoGi8+1JUp6tjTpp5woL7O
         cod5tpF7FxZquyM+7jMVfYivFhw1A7yLr8Y1P4pREhqKeAhGK0A9zvZ83KW3U+HHMb
         GeqBDCgHdlutqqAH9oNswhRbJ5EAQZCWpDs3zvTuKEqYcFxFhGGe1+zGMslfGMkBeX
         NQSsPj7d5HifE7hmyzr6yjOVR925A6jhizvluh9tXZgISv98sRH/q9TWuqg/ERezt0
         qK/sp/ec4OtyqrabLt9Zt4eeWX3iMNSTIX4pflrYr0WkMdJQ7goEn/vmfDQjXnldkc
         J1vQoR2Q96aVQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C171E21EF8;
        Mon, 19 Dec 2022 12:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: microchip: vcap: Fix initialization of value and
 mask
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167145301611.31436.11110109817741497081.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Dec 2022 12:30:16 +0000
References: <20221219082215.76652-1-horatiu.vultur@microchip.com>
In-Reply-To: <20221219082215.76652-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, UNGLinuxDriver@microchip.com,
        lkp@intel.com, error27@gmail.com, saeed@kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Mon, 19 Dec 2022 09:22:15 +0100 you wrote:
> Fix the following smatch warning:
> 
> smatch warnings:
> drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c:103 vcap_debugfs_show_rule_keyfield() error: uninitialized symbol 'value'.
> drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c:106 vcap_debugfs_show_rule_keyfield() error: uninitialized symbol 'mask'.
> 
> In case the vcap field was VCAP_FIELD_U128 and the key was different
> than IP6_S/DIP then the value and mask were not initialized, therefore
> initialize them.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: microchip: vcap: Fix initialization of value and mask
    https://git.kernel.org/netdev/net/c/10073399cb5e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


