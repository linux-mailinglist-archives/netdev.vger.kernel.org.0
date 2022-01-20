Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7330494D21
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiATLkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:40:14 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58164 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiATLkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:40:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 908C7CE2058
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 11:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B203EC340E7;
        Thu, 20 Jan 2022 11:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642678809;
        bh=7d9alnwex+rXe1zqYmsb6FRhffrIZaWHO369oP1y/SY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BwY5lK9Al0vOh5o6EX1UIENDXpY8XO/CEF40CnU7VBL3exHdYopFIY8ecltYOo+fT
         I8weYtIHS1Qnt5QR7ugK68xGBubct2erz1+3ridqxDCLQnsuVhTZkD8cjWATv1/PVb
         cYs0rrm8eYWWwI47p/6ftmUv6KT5a7/Xsf4Pnx6XYkEOlu2nzJQEX3hhCf3gm0vnOD
         CWDb9V/fi3xDCqv7OMo+DJ96iCDnUNZzhmXvhrWu0Vomi4bdAELOE6fKZaoXMIgeVu
         LuLhvGsof15spK3ua/RGD3Q5rPQq97L1/rs/nkMkB217hcA3Tj9IiixsPPVvrtsKhM
         CqUZlv+0HFeIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 95703F6079C;
        Thu, 20 Jan 2022 11:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethtool: Fix link extended state for big endian
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164267880960.20064.227719261291195.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Jan 2022 11:40:09 +0000
References: <20220120095550.5056-1-moshet@nvidia.com>
In-Reply-To: <20220120095550.5056-1-moshet@nvidia.com>
To:     Moshe Tal <moshet@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        netdev@vger.kernel.org, amcohen@nvidia.com, jiri@nvidia.com,
        petrm@nvidia.com, gal@nvidia.com, tariqt@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 20 Jan 2022 11:55:50 +0200 you wrote:
> The link extended sub-states are assigned as enum that is an integer
> size but read from a union as u8, this is working for small values on
> little endian systems but for big endian this always give 0. Fix the
> variable in the union to match the enum size.
> 
> Fixes: ecc31c60240b ("ethtool: Add link extended state")
> Signed-off-by: Moshe Tal <moshet@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net] ethtool: Fix link extended state for big endian
    https://git.kernel.org/netdev/net/c/e2f08207c558

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


