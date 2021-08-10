Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD563E8437
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 22:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbhHJUU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 16:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232851AbhHJUU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 16:20:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DC17960F94;
        Tue, 10 Aug 2021 20:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628626805;
        bh=VdV1s6LdLnj+V2FiURRO+XOlJpDjgTL7v60lLLPRBtE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oTQiehzL1H2R98IZi14TSEzpO9GkS9DtbNfteH1q0DejubQavTYqyC1oBwn7aYzbD
         BC8uzx6/M+ujn6QDUCiNimTM+kBUzFWa1OS+lnkXnjQChMxHjSf2OBiUe2XVJJdXj7
         S3KT60K0JN4hHKE1+EjtyRkOGLHyKSx06siF9VriaGtDHiYE7p+pH9ztFwuNzINOuv
         48RCfjxp60N6ezYpmgueRf74VvhUC7ffBGd/VezzLcZ70F0MbC/PFmUO8vxGY14Sn0
         7POMKak5eGX033uI5wT0sBA1Ai2Ysk7+Gzx63ya5msXVPNPou43q0FRQqSPh645xGJ
         yFBhsn1vsxMGw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CEBB560A3B;
        Tue, 10 Aug 2021 20:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: bridge: fix flags interpretation for extern learn
 fdb entries
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162862680584.11744.11028894548739295364.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Aug 2021 20:20:05 +0000
References: <20210810110010.43859-1-razor@blackwall.org>
In-Reply-To: <20210810110010.43859-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, vladimir.oltean@nxp.com,
        bridge@lists.linux-foundation.org, nikolay@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 10 Aug 2021 14:00:10 +0300 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Ignore fdb flags when adding port extern learn entries and always set
> BR_FDB_LOCAL flag when adding bridge extern learn entries. This is
> closest to the behaviour we had before and avoids breaking any use cases
> which were allowed.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: bridge: fix flags interpretation for extern learn fdb entries
    https://git.kernel.org/netdev/net/c/45a687879b31

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


