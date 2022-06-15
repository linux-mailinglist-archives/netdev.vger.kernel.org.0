Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B214F54C112
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 07:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240005AbiFOFUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 01:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiFOFUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 01:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96436403F1
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 22:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DADD61721
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 05:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76AD6C3411B;
        Wed, 15 Jun 2022 05:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655270414;
        bh=/NiSZYa/KcmztUA0Ru2YJ/XLGaJnMrrsgfgrlT7QCdI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YnxRxnkTooi8r4woR7JjxEXzCmKx9dZhCnkQPwAqkCZZYnoVdN7lmaBAB3TUyTEwo
         Y5snAi8JkAVPypzOfY/wh2pQANq0iE0/l9D0F3dkwHxdXNZ03mUcpF7RFhLJqyrXKX
         iZjOobY/LlQNuy9e4UYOudi16G3ncd3a1iXG2SxyhSSyxsqgxwhm7yVxTXNZDbGwxh
         HTU+2yj9E6q0D1eH6MLrHLGNsUsPHAKSNJwOxr+asMpa3zql7yI1UhQjubr+xTiUFb
         I+/TbEvdy9G3JiS+5SZwlBbsufnj/J7JZV6SB1wovNJAM+aToklS1wR/64pEjjp6tn
         FhXDXxcqrcZww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 590CDE73856;
        Wed, 15 Jun 2022 05:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] mlxsw: Remove XM support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165527041436.22200.17526746006467463659.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 05:20:14 +0000
References: <20220613132116.2021055-1-idosch@nvidia.com>
In-Reply-To: <20220613132116.2021055-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        mlxsw@nvidia.com
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 13 Jun 2022 16:21:13 +0300 you wrote:
> The XM was supposed to be an external device connected to the
> Spectrum-{2,3} ASICs using dedicated Ethernet ports. Its purpose was to
> increase the number of routes that can be offloaded to hardware. This was
> achieved by having the ASIC act as a cache that refers cache misses to the
> XM where the FIB is stored and LPM lookup is performed.
> 
> Testing was done over an emulator and dedicated setups in the lab, but
> the product was discontinued before shipping to customers.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] mlxsw: Revert "Introduce initial XM router support"
    https://git.kernel.org/netdev/net-next/c/6a4b02b8fa40
  - [net-next,2/3] mlxsw: Revert "Prepare for XM implementation - prefix insertion and removal"
    https://git.kernel.org/netdev/net-next/c/725ff5320443
  - [net-next,3/3] mlxsw: Revert "Prepare for XM implementation - LPM trees"
    https://git.kernel.org/netdev/net-next/c/87c0a3c6766e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


