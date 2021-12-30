Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA0D48184B
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbhL3CAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbhL3CAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:00:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0FEC061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 18:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0907C615C8
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 02:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65C6CC36AE1;
        Thu, 30 Dec 2021 02:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640829611;
        bh=r+7At58GAqPK0C4GwxpSddBgEjWnuwMGZO/F9d/1SD4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XTfq9CqmPTS6uh+bbmOzmBwyKyN8owYn+L3qqpc/1cVICoFUDVw1gGi9pdSfKvcBs
         MGpuWSXD7yoTUHHHlswk4grQG9/UN4VFo7cfuLj1IiQc7wSLxVDQridaEDqcnXtbyE
         yI3wV/HRLhvx++tLqpWT1R1j3vGCQPjPQTY6jGDTXrrVUV92u5e3rh89/1QrX//NKq
         X7jL6lJbm9pbEyHE1LkVjJEIUWCY8IaYnjDJKN4Y8tkexprW0TGcmMZMYKKmjS7UXl
         qpUVATpsaUd7xrysDI6lUTQTPxIZrYkIyyY69aHl9xZZNrTIcQXYMpdSofNuIggi0p
         vGyJ348cO/aPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4CBC5C395E5;
        Thu, 30 Dec 2021 02:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: bridge: mcast: fix
 br_multicast_ctx_vlan_global_disabled helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164082961129.30206.7745851458626854957.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 02:00:11 +0000
References: <20211228153142.536969-1-nikolay@nvidia.com>
In-Reply-To: <20211228153142.536969-1-nikolay@nvidia.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Dec 2021 17:31:42 +0200 you wrote:
> We need to first check if the context is a vlan one, then we need to
> check the global bridge multicast vlan snooping flag, and finally the
> vlan's multicast flag, otherwise we will unnecessarily enable vlan mcast
> processing (e.g. querier timers).
> 
> Fixes: 7b54aaaf53cb ("net: bridge: multicast: add vlan state initialization and control")
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: bridge: mcast: fix br_multicast_ctx_vlan_global_disabled helper
    https://git.kernel.org/netdev/net/c/168fed986b3a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


