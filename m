Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338D752D02C
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 12:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiESKKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 06:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiESKKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 06:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DE6A7747
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 03:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6CC861909
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 10:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28E0FC34100;
        Thu, 19 May 2022 10:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652955012;
        bh=VJ0fyJQ9OWoXPaQxYbYce6jsdQiTlabWQ4ReFJkv18c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cfASxiloLYm8Ghw10H1URVNjTIAskYI/t7kaqTVY68ryUft0LG8uPxPovg+kqDrs3
         QC9D7usZWwhkP3nLvjiRwj7h85FIt2dvDmXEgFl9clhWtS2C5lBf5N2MdRwPlasSVf
         ORUFi3KHFYivHB5dTqONNUEuqR1XYn/7ex/4d8IddtWqieW5DzyWe5jmNGykd0SGzT
         G0CGMfHNrP2X3P80dAUUGKcWM87BDuAzGK/Aw83z490xFEl0BE551786L4jpZ5QUgc
         fiksAjI5GuLVweQVN4akK0IJoqTyOloh3rk41cvojtRD+s+ag8BYn2Wq8Wyu/6HqSG
         0vrTizA1m1SPg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0E350F03935;
        Thu, 19 May 2022 10:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower: support ct merging when mangle action
 exists
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165295501205.2233.12388007105285504823.git-patchwork-notify@kernel.org>
Date:   Thu, 19 May 2022 10:10:12 +0000
References: <20220518075055.130649-1-simon.horman@corigine.com>
In-Reply-To: <20220518075055.130649-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 18 May 2022 09:50:55 +0200 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> Current implementation of ct merging doesn't support the case
> that the fields mangling in pre_ct rules are matched in post_ct
> rules.
> 
> This change is to support merging when mangling mac address,
> ip address, tos, ttl and l4 port. VLAN and MPLS mangling is
> not involved yet.
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower: support ct merging when mangle action exists
    https://git.kernel.org/netdev/net-next/c/e43d940f480b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


