Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A6841EEE6
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhJANvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:51:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhJANvv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 09:51:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DF098615A4;
        Fri,  1 Oct 2021 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633096206;
        bh=QsrwgEDlnzCYhoiQTwSZw3yujYZZdTgqAndaqPQioKI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qS4NzFSZ9prAMB/4qAsljCUHxhlZpGotwoZGGsmZhbQMGbjp5wF6dO7W+S0FjkOHV
         dssQAaEmujoIzGBkA/Ba+azxIq95T+2RaHC4WvA+Suu44Aycd2OHoN5mZEf68l7ZxT
         B2RIDSjofAWRBB8fi/X+JT0yuRu//GyQ/XnyWQHdu34//DpDiTIGJUbqu4LCj3V8Tf
         FVYTR/l7JvXytdrV8X30iM+YMSqAunL3yBmYMmpAkO/iUhTt/DJqyP8UC2MfxzAIrB
         +3Wx851ppQrCPXL9ZWiWrij7nZLlDy+tVmIwi32cPXnK8/MFVyASenazTGakERgI5A
         NCKpU6yTisqnw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D1120609D6;
        Fri,  1 Oct 2021 13:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] devlink: report maximum number of snapshots with regions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163309620685.4652.15529220423526477869.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Oct 2021 13:50:06 +0000
References: <20210930212104.1674017-1-jacob.e.keller@intel.com>
In-Reply-To: <20210930212104.1674017-1-jacob.e.keller@intel.com>
To:     Keller@ci.codeaurora.org, Jacob E <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, kubakici@wp.pl, jiri@resnulli.us,
        gurucharanx.g@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 30 Sep 2021 14:21:04 -0700 you wrote:
> Each region has an independently configurable number of maximum
> snapshots. This information is not reported to userspace, making it not
> very discoverable. Fix this by adding a new
> DEVLINK_ATTR_REGION_MAX_SNAPSHOST attribute which is used to report this
> maximum.
> 
> Ex:
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: report maximum number of snapshots with regions
    https://git.kernel.org/netdev/net-next/c/a70e3f024d5f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


