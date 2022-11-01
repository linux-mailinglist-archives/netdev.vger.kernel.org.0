Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEF061512D
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 19:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiKASAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 14:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiKASAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 14:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F093211C11
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 11:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EEC5B81EAA
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 18:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 146F9C433C1;
        Tue,  1 Nov 2022 18:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667325617;
        bh=hi3/rG+adxc22Q2ztzXfKvgRaAuSxlW59U3KnMS9jaU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cQnk+GAXXjE7SlxsMuKGfofyRmepjiTYnayvgHLRBwx+XIk3l9Ea8QDEHohW32Moo
         sKBPiOIbY6SBc/9QOLroUl06eDmPyB1TFzeMQprvIPbVboZi4304v1UFujhfNLBAn3
         eFK6EHSzo6dKK8SwqdVqLeGGCpHKWPveC+Cv7scpT4Q8jL6asbpMt4Lvca6nPM6ghL
         xJGGuQVpMGufpymLL9AFNbnLQE9AlAE3XpKCTTUQ0iif/CeJ+QD8dEzSItU6WUz5ej
         Cuo5c29PT+YIBZNz+WxtzvscN9XOyWfAbs4JjBnmPdSX0RpbdCDxlWr4fVFOJIpVmV
         EtQbsB4VgJgDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EA4C3E270D3;
        Tue,  1 Nov 2022 18:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool] add 10baseT1L mode to link mode tables
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166732561694.22124.17178596277168323304.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Nov 2022 18:00:16 +0000
References: <20221024152855.D0D6E604C3@lion.mk-sys.cz>
In-Reply-To: <20221024152855.D0D6E604C3@lion.mk-sys.cz>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, xose.vazquez@gmail.com,
        alexandru.tachici@analog.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Mon, 24 Oct 2022 17:28:55 +0200 (CEST) you wrote:
> Add recently added 10baseT1L/Full link mode to man page and ioctl and
> fallback code paths.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> ---
>  ethtool.8.in       | 1 +
>  ethtool.c          | 3 +++
>  netlink/settings.c | 1 +
>  3 files changed, 5 insertions(+)

Here is the summary with links:
  - [ethtool] add 10baseT1L mode to link mode tables
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=1b7d16496cc8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


