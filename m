Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC763F2C79
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 14:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbhHTMwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 08:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240262AbhHTMwx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 08:52:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 48772610D2;
        Fri, 20 Aug 2021 12:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629463935;
        bh=Va7ZQFgJHrGn7mNkVlFaDEcq8Ve2SUabng9PkIPguek=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AsDMkT+EdHVIezFXvrifc4GM6Q+peUlMb9yLT6fdnN8UbPcNKq1TuRlVXlk8FddJU
         BF6Pfhi75Et2geJxN/8ywC/MqcltalVUZoo3x/dBh4dhlY+XWYSjA4wicSynbSooos
         Fwvk0vQI1d6tG7Hb1UX7A7tekUP/oK7Sh1zjkp39bR7NpUpPVSKg3TBlkTn6S6Psb0
         FOqpFNy2XyTj+GfAvi6bSUodcWyzx9uF+CN7Uml8aZDFmhp+SOpVBblzs0qxV64r9k
         x2BrnpkXF6VC4cJidJrV3g/oBkCXZ5trOwyfVZ0GEovHI3FL0jYKiB6zDZSZolox2I
         YHqyuEVWBGuEg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 42AC060A89;
        Fri, 20 Aug 2021 12:52:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/1] ice: do not abort devlink info if board identifier
 can't be found
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162946393526.27725.12188950066010528143.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Aug 2021 12:52:15 +0000
References: <20210819223451.245613-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210819223451.245613-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        netdev@vger.kernel.org, tonyx.brelinski@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 19 Aug 2021 15:34:51 -0700 you wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> The devlink dev info command reports version information about the
> device and firmware running on the board. This includes the "board.id"
> field which is supposed to represent an identifier of the board design.
> The ice driver uses the Product Board Assembly identifier for this.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/1] ice: do not abort devlink info if board identifier can't be found
    https://git.kernel.org/netdev/net/c/a8f89fa27773

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


