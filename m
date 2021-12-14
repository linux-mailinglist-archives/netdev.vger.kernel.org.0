Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCCE47431A
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 14:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbhLNNAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 08:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234229AbhLNNAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 08:00:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5E8C061574;
        Tue, 14 Dec 2021 05:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 625F7B819A3;
        Tue, 14 Dec 2021 13:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1AB65C34606;
        Tue, 14 Dec 2021 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639486811;
        bh=Bnejt12xUiGuEcV0cdQ+MNHnzPTqYixYt6Kjc2hjZA4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hLXjk5hsKPsHw5PQTctDF6Xqkmei/1FeRPIU/lj0d1cq2IoHMS1Ry9ZMgUNIlCu4q
         uPGgdkEMd0KShzpgyQwtYaXLBZ0PxvCw+Y4OY2Zxz3InC0Vip9X35HUtw1E6IjBxiJ
         78TrnNTgvQdcqUBVl31sCtzaRjJUX+4ztvoauMJ6FSBxPXqmVSc21x3z5S0EoKP+Yj
         0tZtX0iYcAH6dvPxchDrDF2/uBNWp6ArL9sWIdzETOpAEH2AsRRMigEhrWAjekU6dr
         TBlzR10UnS+JIGPYaXLnA2KCJxQgfWGEH4qoGA2luZrr1eZuOG5tv+NnCBm5DpVto+
         lTT6XhLqLNaCA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 05DB360A2F;
        Tue, 14 Dec 2021 13:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rds: memory leak in __rds_conn_create()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163948681101.21223.11253999834434926614.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Dec 2021 13:00:11 +0000
References: <20211214104659.51765-1-hbh25y@gmail.com>
In-Reply-To: <20211214104659.51765-1-hbh25y@gmail.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Dec 2021 18:46:59 +0800 you wrote:
> __rds_conn_create() did not release conn->c_path when loop_trans != 0 and
> trans->t_prefer_loopback != 0 and is_outgoing == 0.
> 
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  net/rds/connection.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] rds: memory leak in __rds_conn_create()
    https://git.kernel.org/netdev/net/c/5f9562ebe710

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


