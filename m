Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB66B40DA20
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239854AbhIPMlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239616AbhIPMl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 08:41:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 51A1160FA0;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631796008;
        bh=WQSJ5NAy0xneJITrZzs+Kd+/pHbYYVNdYNFomRs3bdA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p8BG9qQRGEItT5oUjQxtbHjHiZJoP4srH2FQDcyc1TvUWatAASy7qHyRwTuVMCL26
         abKPqi42iuLz/a7Wh/aiulyW/a/0wF9pt6zOqFmENOoGIC2SQTtBhonCI6jG72yKdS
         BX8kMn6q8DWGMDEsdU0KZBHiKVtrkBQQo1P3ac9mm+8lfmRxEoV+awSu76mx1SV1J4
         5PR2BKvrl7LOCyij09QBdan+ZY3yL3TD3770yvMbLNRjvOa7hPzvF/1OjZDYKI6LJc
         bEHV2M9GG0Op8DYCYYE2oEIbwqnANPeiO6gkGjcACVHG8xTi5KHNoiyXDtMhMw3zhr
         Tnv/mYtSsYH5w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 47B2E60A9E;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: atl1c: Make use of the helper function dev_err_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163179600828.19379.233519670589472147.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 12:40:08 +0000
References: <20210915145749.7251-1-caihuoqing@baidu.com>
In-Reply-To: <20210915145749.7251-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 15 Sep 2021 22:57:48 +0800 you wrote:
> When possible use dev_err_probe help to properly deal with the
> PROBE_DEFER error, the benefit is that DEFER issue will be logged
> in the devices_deferred debugfs file.
> And using dev_err_probe() can reduce code size, and simplify the code.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> 
> [...]

Here is the summary with links:
  - net: atl1c: Make use of the helper function dev_err_probe()
    https://git.kernel.org/netdev/net-next/c/d502933c30c6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


