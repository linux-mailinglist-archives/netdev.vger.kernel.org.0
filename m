Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CA7547245
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 07:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiFKFuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 01:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiFKFuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 01:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D63029A
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 22:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54FF8B8387E
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 05:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0DCABC3411D;
        Sat, 11 Jun 2022 05:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654926616;
        bh=RAXujIIrVOWNUYXahr8tbAP+dse9eofmrcbPKMKuDb0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xg5F6TT1tnl27uW106Pe2i3SsVGBwDvlKECbAh96Ky6P6o6uYp0EU2bVNx5j4GQ5j
         tmW9e48QWGLQHaVIv6biZhzpF1PAo4XJesEnVzfV+j4N/JmddnTP4lZfwd7uwqp4pW
         zDsW/uCmo0zO6veR2zURJlDJr+7n6ni6ZoxCG+BaYBSKTs/WlhiGYc8f0AHp0LoxS2
         CcZOac+IhKZquz9LRu+bAx3Z5gl0QPjeK0iYu6NKTJJu+NIh9k3NYCUbj7REi65X35
         854c467f1Ijv9TzwYbCule0dhDc/K78QRx1L2h9lSh2HNjpuS5gWpL4R2gCUt/aKmn
         tOrvkwgI/V8tw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E781DE737E8;
        Sat, 11 Jun 2022 05:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower: support to offload pedit of IPv6
 flowinto fields
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165492661594.29780.7283941415835258546.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Jun 2022 05:50:15 +0000
References: <20220609080136.151830-1-simon.horman@corigine.com>
In-Reply-To: <20220609080136.151830-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Jun 2022 10:01:36 +0200 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> Previously the traffic class field is ignored while firmware has
> already supported to pedit flowinfo fields, including traffic
> class and flow label, now add it back.
> 
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower: support to offload pedit of IPv6 flowinto fields
    https://git.kernel.org/netdev/net-next/c/27f2533bcc6e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


