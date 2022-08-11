Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868E7590479
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238330AbiHKQc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238961AbiHKQbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:31:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA83C10FB;
        Thu, 11 Aug 2022 09:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFFD16145B;
        Thu, 11 Aug 2022 16:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54816C4347C;
        Thu, 11 Aug 2022 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234215;
        bh=fwNryxcXoLuBUuV+BJ0v6gHwy+VG3pWeBl4er5b7iiQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FUhA5HBWP6tafLrt5KNuOu44kVTAlGPW/0xiZ55lAyX1vT1oV0LfruA86r4s5y1lt
         RCMWj98Abx4w8w++H/sdvVSQlmrSwR1hNlLxKcOgj5xX3jfeZXo34N9IB1Oa1vY+Al
         xx57qIR4XBwtjVOSNGmr6KytFxx5lSJXtRvxwd+BrgkNy0+tyeV7sXJ+7oedGICxN/
         Sj3Ib4iejilkBAqTbeXrYbzqeprBBwc1qtOwSvD4eBJjoMtCMDj140+A/VuAnHxsyj
         ghkhpeZjqMvQrZoPXPiCcOkbBcF2Ilg3boBQEGa0GwwT0I/xNOyD3ejBKXiBUonBka
         04Zb9MxShstaA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 35C28C43144;
        Thu, 11 Aug 2022 16:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mlxsw: minimal: Fix deadlock in ports creation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166023421521.9507.10489139013497988620.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Aug 2022 16:10:15 +0000
References: <f4afce5ab0318617f3866b85274be52542d59b32.1660211614.git.petrm@nvidia.com>
In-Reply-To: <f4afce5ab0318617f3866b85274be52542d59b32.1660211614.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vadimp@nvidia.com, idosch@nvidia.com
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

On Thu, 11 Aug 2022 11:57:36 +0200 you wrote:
> From: Vadim Pasternak <vadimp@nvidia.com>
> 
> Drop devl_lock() / devl_unlock() from ports creation and removal flows
> since the devlink instance lock is now taken by mlxsw_core.
> 
> Fixes: 72a4c8c94efa ("mlxsw: convert driver to use unlocked devlink API during init/fini")
> Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net] mlxsw: minimal: Fix deadlock in ports creation
    https://git.kernel.org/netdev/net/c/4f98cb0408b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


