Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC154B6F4C
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 15:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238787AbiBOOk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:40:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238773AbiBOOkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:40:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D2010243A;
        Tue, 15 Feb 2022 06:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E23DB81A66;
        Tue, 15 Feb 2022 14:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E754BC340F3;
        Tue, 15 Feb 2022 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644936011;
        bh=W+PZiXTkYYnYXtN8VwBPcPEFiBLPX741Pr608myZGug=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZZqIsTFR8P4fhKOYLoIsdyVtOw6Ic3k9rD5JeUlevGOn/VHt+ySFeUqtByqqApGFM
         dkujXNapxRFLOGxNUoOc98VkzM5fPzKyEZ0/ws7vqs7DPySW40EeG8QOxorHwjMcXE
         RRxA8U69C8Eov70j7L7TpVm9zqQAOfxL7FE+BeYEIItMoVXNY2FmyGnXghtghVD+6R
         JRu8/ngo0yAFbGJ5igYex2Xkjz8pn9LtqSc6RrE6/ESLpAQUo9vNZLr8di2LXHN5lK
         SUxyDLl1P8iHP9vsU1J3lkH/cNXuAAh0dW/iTb8XH9gh8f2ga9sFvexxES4vNa+A4I
         BWBeYBZeX6iEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D23B0E6D447;
        Tue, 15 Feb 2022 14:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dpaa2-switch: fix default return of
 dpaa2_switch_flower_parse_mirror_key
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164493601085.31968.17393307108905491138.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Feb 2022 14:40:10 +0000
References: <20220214154139.2891275-1-trix@redhat.com>
In-Reply-To: <20220214154139.2891275-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     ioana.ciornei@nxp.com, davem@davemloft.net, kuba@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Mon, 14 Feb 2022 07:41:39 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this representative problem
> dpaa2-switch-flower.c:616:24: warning: The right operand of '=='
>   is a garbage value
>   tmp->cfg.vlan_id == vlan) {
>                    ^  ~~~~
> vlan is set in dpaa2_switch_flower_parse_mirror_key(). However
> this function can return success without setting vlan.  So
> change the default return to -EOPNOTSUPP.
> 
> [...]

Here is the summary with links:
  - dpaa2-switch: fix default return of dpaa2_switch_flower_parse_mirror_key
    https://git.kernel.org/netdev/net/c/2a36ed7c1cd5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


