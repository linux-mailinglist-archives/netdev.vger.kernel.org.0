Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB93455AC6
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344205AbhKRLoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:44:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344254AbhKRLnJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 06:43:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9C0E0610FB;
        Thu, 18 Nov 2021 11:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637235609;
        bh=ZZU/GbTgZesYLAIQqs8+F9zSYQ6Nmu/dQnurNPHhDT0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VtbXy4HfDAulh2dV2/AiCxIp62UHz7N3h4FOv+WaGgatFoIO8av+UoUaLLNHdosOW
         YE11hkVUc0JNrQHON/1zI7L48VG1Zw2K8IJ6erBXokFdjWYdbz7RXP6r+STfAy+8Oc
         4qEZJ2Rq2jwhmt8FXJrnACrwmpKrMGRmHqBoteRhL/UKi4msMXldWHX0Yyqg5MPlga
         HlgXDp47+ZLrA4dmDk0jFetZDrvfqgKCf1lOZ9BqcN2iqtic76UhA60f0Oun7OCrUK
         yjrS2CtB6UUIie9WuXx2FqCi480q+HSHKkujAHC2w2QCTlA0F1E5iHqn1u4omOZCvf
         j5xBXpMnn2K/A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 90884609CD;
        Thu, 18 Nov 2021 11:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1] devlink: Don't throw an error if flash notification
 sent before devlink visible
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163723560958.11739.17800228079533384711.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 11:40:09 +0000
References: <1009da147a0254f01779a47610de8df83d18cefe.1637160341.git.leonro@nvidia.com>
In-Reply-To: <1009da147a0254f01779a47610de8df83d18cefe.1637160341.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        danieller@nvidia.com, jiri@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        amcohen@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Nov 2021 16:49:09 +0200 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The mlxsw driver calls to various devlink flash routines even before
> users can get any access to the devlink instance itself. For example,
> mlxsw_core_fw_rev_validate() one of such functions.
> 
> __mlxsw_core_bus_device_register
>  -> mlxsw_core_fw_rev_validate
>   -> mlxsw_core_fw_flash
>    -> mlxfw_firmware_flash
>     -> mlxfw_status_notify
>      -> devlink_flash_update_status_notify
>       -> __devlink_flash_update_notify
>        -> WARN_ON(...)
> 
> [...]

Here is the summary with links:
  - [net,v1] devlink: Don't throw an error if flash notification sent before devlink visible
    https://git.kernel.org/netdev/net/c/fec1faf221f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


