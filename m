Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F8932DD3E
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhCDWkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:40:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230442AbhCDWkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:40:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E643865005;
        Thu,  4 Mar 2021 22:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614897609;
        bh=8alrRYOcPgLzLurJ8ePq+svkQQ3viIz7d9SOI7FYyGM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=We/Lg5Va9nP+GF9zwmm6syoR3iieCeDZYnN+oaS/FjK8iuSLSmgwIG9AbbyPHudvJ
         /0rmxEWXtByOcgKXj3IyLuawscMqLH14eCI44mzh3f175AOCCPCgA+hJYNAL28X8k/
         AeOLmTt/C/W321Vs1b8TJFmpJ3B37jAbkZ4zNwM4cH0OuPH2BL6pbPSoxd9uXgZPEm
         ETbCl6TEzJ3ljaocAQOpOlvzfIQ3xCuYwkPMWNg61WpkWI+klLkYmicy7u5g0FhbMk
         jNp/6vwChkQVZEE8ohyRnnW7Eoaz0VdeEjPN9Gk+VIAZCUKKl8ACM8O9tYTBry0wo/
         xKgMtkshURTiw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D4EE260A1B;
        Thu,  4 Mar 2021 22:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ibmvnic: always store valid MAC address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161489760886.17160.16363885063231426399.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Mar 2021 22:40:08 +0000
References: <20210304161828.GA6104@incl>
In-Reply-To: <20210304161828.GA6104@incl>
To:     Jiri Wiesner <jwiesner@suse.com>
Cc:     netdev@vger.kernel.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, drt@linux.ibm.com,
        ljp@linux.ibm.com, sukadev@linux.ibm.com, davem@davemloft.net,
        kuba@kernel.org, msuchanek@suse.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 4 Mar 2021 17:18:28 +0100 you wrote:
> The last change to ibmvnic_set_mac(), 8fc3672a8ad3, meant to prevent
> users from setting an invalid MAC address on an ibmvnic interface
> that has not been brought up yet. The change also prevented the
> requested MAC address from being stored by the adapter object for an
> ibmvnic interface when the state of the ibmvnic interface is
> VNIC_PROBED - that is after probing has finished but before the
> ibmvnic interface is brought up. The MAC address stored by the
> adapter object is used and sent to the hypervisor for checking when
> an ibmvnic interface is brought up.
> 
> [...]

Here is the summary with links:
  - [net] ibmvnic: always store valid MAC address
    https://git.kernel.org/netdev/net/c/67eb211487f0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


