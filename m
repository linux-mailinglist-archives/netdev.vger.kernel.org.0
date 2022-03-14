Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158394D8F52
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 23:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235047AbiCNWLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 18:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242461AbiCNWLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 18:11:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9F93CA42
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 15:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B235613F9
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 22:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C29BC340F4;
        Mon, 14 Mar 2022 22:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647295810;
        bh=eoh2Nfc8UXrqyjp5fbK8iydpJmIK4r+/vcl4mUJWk1w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lIOpZ+fKi1cdzhsZR04VCUAgRdR1qPQsgc9VwDPMsn+YEol4sNfxRjoU4Kn4uQKf8
         9NsQWqk2juz4Qvm4ds/X19T/un+ZOe0nNCIUW3HAxyS1GCx9zvso6jrvayN8+F3vNl
         wrA4esICxjG4FbaY2vCOlqXvXlR8sqjCIe/xpertWMqkS2zj55UBkK4duqhOhucaXZ
         a5I/tSX8p6cO08QQQlAY/ZNITST0DISNe898QIRJbVQ/Q7KpAhHZ6XnnRedofhC1xj
         risNZ0C1xeOF4yzJqQiZVrfecTVpEmuWOsY560XWG9/cr0tqJdeo2QG8WQNlnbGVML
         3T5pwm85sdBkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70E08E6D44B;
        Mon, 14 Mar 2022 22:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5e: Fix use-after-free in
 mlx5e_stats_grp_sw_update_stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164729581045.6716.776079823522358668.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Mar 2022 22:10:10 +0000
References: <20220312005353.786255-1-saeed@kernel.org>
In-Reply-To: <20220312005353.786255-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jdamato@fastly.com, saeedm@nvidia.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 11 Mar 2022 16:53:53 -0800 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> We need to sync page pool stats only for active channels. Reading ethtool
> stats on a down netdev or a netdev with modified number of channels will
> result in a user-after-free, trying to access page pools that are freed
> already.
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5e: Fix use-after-free in mlx5e_stats_grp_sw_update_stats
    https://git.kernel.org/netdev/net-next/c/8772cc499bff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


