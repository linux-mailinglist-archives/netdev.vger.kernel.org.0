Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12904A9806
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 11:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241674AbiBDKuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 05:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiBDKuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 05:50:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64612C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 02:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B29B061A6D
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BAADC340F0;
        Fri,  4 Feb 2022 10:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643971809;
        bh=roqRMDpH/4nKZBfuHSnxENZei9BTqeDFe414HDQ50TQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lj88ZYyzq6xGVdWL/VAs0QTICM45vkaw3+yIQgV0wEPpbJK6+90S8mHdCoc2lTY+m
         uWx99YM1K78ny1B+t3eocRYjQyq2/JdkrjeO1PgnD8bZ6z2a+GcP5m8pJPcopz+y+6
         fRD9Ib490AFgdA9bwmi2Swms7G8ghd9Yd3fGxEJ3v18nTGR/SbGxpMfdw8fPoaV8+g
         nxbDVmne2KRt51aEAOfpLFpTqPv+AR152HujWUXl6p7VYzu3slJLyowMG5gmwMbVCE
         d3X8DJJCXxqTgfHAV+Ap3NM/Mvvq7MD9jlHTbyxdvtXIjIZ5jFEgpoUvRBfDzD8b0d
         S6HUyxHhdsNYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02F61E5D09D;
        Fri,  4 Feb 2022 10:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ixgbevf: Require large buffers for build_skb on
 82599VF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164397180900.10982.1793858039267627806.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Feb 2022 10:50:09 +0000
References: <20220203224916.1416367-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220203224916.1416367-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, samjonas@amazon.com,
        netdev@vger.kernel.org, konrad0.jankowski@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  3 Feb 2022 14:49:16 -0800 you wrote:
> From: Samuel Mendoza-Jonas <samjonas@amazon.com>
> 
> From 4.17 onwards the ixgbevf driver uses build_skb() to build an skb
> around new data in the page buffer shared with the ixgbe PF.
> This uses either a 2K or 3K buffer, and offsets the DMA mapping by
> NET_SKB_PAD + NET_IP_ALIGN. When using a smaller buffer RXDCTL is set to
> ensure the PF does not write a full 2K bytes into the buffer, which is
> actually 2K minus the offset.
> 
> [...]

Here is the summary with links:
  - [net,1/1] ixgbevf: Require large buffers for build_skb on 82599VF
    https://git.kernel.org/netdev/net/c/fe68195daf34

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


