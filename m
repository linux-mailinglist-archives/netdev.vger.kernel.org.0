Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61C566A991
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 07:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjANGK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 01:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjANGKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 01:10:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6C130D4
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 22:10:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F1AF1CE09FF
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 06:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E058AC433F0;
        Sat, 14 Jan 2023 06:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673676620;
        bh=Vr5ZgNVPBuw3km7CgOz+6ckPTRgtAhGVdN/oTj/NXVE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nvVs0L1qyn8BwD5gjbipiAYLONvq+f0xzQd1M+/KLJDPWWpJCW7rHk5fYLvZ3YMvW
         SkZMGvHUclw4egxc50LftCOBF8/UEay6vlQTYogmGXNjpnQtjzjB8AGxCNZGaBrnuN
         zkB5wJ6fPO1F+iihsegK3cndO5a2JwCZ1Enhq5XbUj+xoJhdgoJgbT1VnOrRzLWHMA
         MPeup4fepubOm52pwxuLKPn+5Us7biZrgUH867WVpdgpMlsoDjhuQMAzJRZTBocCy1
         d3ERagdTaBTIq3SQqEVDruBASy4UDG1lQ5oYwE1GYxOzA/98Kg4r+uNk8+O1cLP6dc
         +402rhNtIuJeQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C2293E21EE0;
        Sat, 14 Jan 2023 06:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/4] mlxbf_gige: add BlueField-3 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167367662079.24172.10989787510239582838.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 06:10:20 +0000
References: <20230112202609.21331-1-davthompson@nvidia.com>
In-Reply-To: <20230112202609.21331-1-davthompson@nvidia.com>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, cai.huoqing@linux.dev,
        brgl@bgdev.pl, limings@nvidia.com, chenhao288@hisilicon.com,
        huangguangbin2@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 Jan 2023 15:26:05 -0500 you wrote:
> This patch series adds driver logic to the "mlxbf_gige"
> Ethernet driver in order to support the third generation
> BlueField SoC (BF3).  The existing "mlxbf_gige" driver is
> extended with BF3-specific logic and run-time decisions
> are made by the driver depending on the SoC generation
> (BF2 vs. BF3).
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] mlxbf_gige: add MDIO support for BlueField-3
    https://git.kernel.org/netdev/net-next/c/2321d69f92aa
  - [net-next,v3,2/4] mlxbf_gige: support 10M/100M/1G speeds on BlueField-3
    https://git.kernel.org/netdev/net-next/c/20d03d4d9437
  - [net-next,v3,3/4] mlxbf_gige: add "set_link_ksettings" ethtool callback
    https://git.kernel.org/netdev/net-next/c/cedd97737a1f
  - [net-next,v3,4/4] mlxbf_gige: fix white space in mlxbf_gige_eth_ioctl
    https://git.kernel.org/netdev/net-next/c/e1cc8ce46200

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


