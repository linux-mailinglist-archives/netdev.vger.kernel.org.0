Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5E148184D
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbhL3CAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbhL3CAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:00:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EECDC061574;
        Wed, 29 Dec 2021 18:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 168FCB81A79;
        Thu, 30 Dec 2021 02:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE20CC36AF3;
        Thu, 30 Dec 2021 02:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640829611;
        bh=ujXPO7dE+EgUmc9vdO7f3CV8GivQkt/bE9MHChveU5I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gGqaTnR+m69xj0CSgP45SyJ4JJC0KXi0qrYgT6ZBngAzgwG2NAiDGqSZ25p8tj/ci
         52ZnmUVsUG+gkUGdnFQXJr845p0uVD4CPnn5no2UnzbOHVmajdE+ORqq0iY3PgD4nd
         hItrwg28+W9MIOnIpYC+0j9JpL3DvJ+JPQfIN19FS2F2jg0GOl+7cO73N+fp8clLG4
         zGqsm0vsttWp0KWeXhx/AlCn8pYZiJVd96HZ7WTEtadi2antX27K+Wmn07QjGnxxPD
         fETO4qCCjUpCNELMG+6dMbH+NxwABUaUJgjqH9TYE9KyCjGJbSGhE1L2lp1uwPev8z
         2uFrsa2qW9/iQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AAE8DC395E2;
        Thu, 30 Dec 2021 02:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6] sun4i-emac.c: add dma support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164082961168.30206.13406661054070190413.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 02:00:11 +0000
References: <tencent_DE05ADA53D5B084D4605BE6CB11E49EF7408@qq.com>
In-Reply-To: <tencent_DE05ADA53D5B084D4605BE6CB11E49EF7408@qq.com>
To:     None <conleylee@foxmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Dec 2021 09:43:51 +0800 you wrote:
> From: Conley Lee <conleylee@foxmail.com>
> 
> Thanks for your review. Here is the new version for this patch.
> 
> This patch adds support for the emac rx dma present on sun4i. The emac
> is able to move packets from rx fifo to RAM by using dma.
> 
> [...]

Here is the summary with links:
  - [v6] sun4i-emac.c: add dma support
    https://git.kernel.org/netdev/net-next/c/47869e82c8b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


