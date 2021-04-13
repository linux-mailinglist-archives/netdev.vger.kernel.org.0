Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA8A35E882
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346813AbhDMVu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:50:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230491AbhDMVu3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 17:50:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2D22F61244;
        Tue, 13 Apr 2021 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618350609;
        bh=Un6U65OWGwgFrqPCIYWZqGW+RU7pZclUW6kfKnkLKEM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VtT7rEysQIRlQsY3lD/MrJpd8il4rTkJSfooJPZ9A7Vs/MrG75qG1iozi/1Y24AxL
         i5zsYIlfkb4bB57uXNHLjqyKHn/h1ySNULR5H3K2i3GCDRfBsvQwuN+QlRFP/fBa4G
         0ko42XIo5riAZYVgvCq8+s0//6PUIQUnXseNovGF/ViWPpEAPvANnj6K3zvOmFN/BY
         F00qk92G0HilkQbd4RApBQ4oyHgyTUnW1U1fKIx7VoF9/RFJzinNBXE+lv3NB1zLbc
         xKV+Mkq8730BGozP6G6jQOjjDL1HAxILhEfrNzmrM1fhbMj2wOS3YKsMbWgINauIU+
         7SQ1pbc2unF6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1F32560CCF;
        Tue, 13 Apr 2021 21:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] ibmvnic: improve failover sysfs entry
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835060912.23734.13003524857245613317.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 21:50:09 +0000
References: <20210413083144.10423-1-lijunp213@gmail.com>
In-Reply-To: <20210413083144.10423-1-lijunp213@gmail.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 13 Apr 2021 03:31:44 -0500 you wrote:
> The current implementation relies on H_IOCTL call to issue a
> H_SESSION_ERR_DETECTED command to let the hypervisor to send a failover
> signal. However, it may not work if there is no backup device or if
> the vnic is already in error state,
> e.g., "ibmvnic 30000003 env3: rx buffer returned with rc 6".
> Add a last resort, that is to schedule a failover reset via CRQ command.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] ibmvnic: improve failover sysfs entry
    https://git.kernel.org/netdev/net-next/c/334c42414729

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


