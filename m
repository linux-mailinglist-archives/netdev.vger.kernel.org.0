Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4675811A8
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 13:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238824AbiGZLKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 07:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiGZLKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 07:10:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BBEBC8A
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 04:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FD00B815DF
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 11:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09D99C341C0;
        Tue, 26 Jul 2022 11:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658833814;
        bh=2WObeUghJo8qVHFwIB9qVXYYlZD9cQ68IjGpdtov7vo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pjB0Tj6Wg+VMdujNLQ/KIts2lT1gKcAE/AzIf9xNxsdoKrydNKv0e1MqgeRibPZA5
         K9rGtCVZykudtSiGTVXbHcI4Bu4wFdBMsFPvAFE3PLBX44LGx2OuId6OV4UuC0GBvA
         MzSDZJSBoJQpVygKPfR8MqghQUIjiBzlS+xS0z05wcdre8gCQuuJznEeGT2BMggLl6
         OC7QXdRAOQ7cx6WADRe2BmKXQDgVxulHCszp9EKRgG2+NLQzEwYRmQ/0TnhWR980l2
         eqq+kNVVLhU6foL4IHIVsfreBgQThnkVOtD5w/3e2iqmV+GL64F72u5AW7udxxv2qJ
         9/Bv713y5ZM0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EAEC8E4481D;
        Tue, 26 Jul 2022 11:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH 0/2] Octeontx2 minor tc fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165883381395.14481.6765732902430628783.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jul 2022 11:10:13 +0000
References: <1658650874-16459-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1658650874-16459-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 24 Jul 2022 13:51:12 +0530 you wrote:
> This patch set fixes two problems found in tc code
> wrt to ratelimiting and when installing UDP/TCP filters.
> 
> Patch 1: CN10K has different register format compared to
> CN9xx hence fixes that.
> Patch 2: Check flow mask also before installing a src/dst
> port filter, otherwise installing for one port installs for other one too.
> 
> [...]

Here is the summary with links:
  - [net,1/2] octeontx2-pf: cn10k: Fix egress ratelimit configuration
    https://git.kernel.org/netdev/net-next/c/5ec9c514d4a0
  - [net,2/2] octeontx2-pf: Fix UDP/TCP src and dst port tc filters
    https://git.kernel.org/netdev/net-next/c/d351c90ce248

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


