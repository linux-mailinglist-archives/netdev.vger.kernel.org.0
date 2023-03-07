Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5793D6AF26B
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbjCGSxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbjCGSwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:52:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F89C80A5;
        Tue,  7 Mar 2023 10:40:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6C8AB819C5;
        Tue,  7 Mar 2023 18:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ACDD3C4339B;
        Tue,  7 Mar 2023 18:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678214422;
        bh=X7U6lGZkDiEVUuVswlZ8UB8GB7TB4qxGBQSRt6RD8ZY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tRzoEcIU5vclegF+N+VIacsSfWOCILTn7XUxNjrG5u8c2vXqQkSTZ7N6Dy0AGYGq5
         N4UZdNrjDuB4/ncwzFwxxiwIQszISfflY9o9qB1u3sv4Maqcad/4JBLrTjADm99/Yz
         3k8PDa5cuDaFZ0IJbuaPSSIiianzVY+tJFpjy8PKX9D16gsYJBraIITiYAzrJ9k3Mv
         g0wwCJTIfAMY9+epJ+q3heknDpok4vemHCu9P/x4CXURzOcz98vb4VNng/PNT5TQTq
         9OJ15fiXxL0kpRjylqspNba1OHzZx5IMQZREedU6+MzLakja37Kewcx4sBFJVJrdGR
         ugd2OInPh9xYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89556E61B62;
        Tue,  7 Mar 2023 18:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/1] Bluetooth: fix race condition in hci_cmd_sync_clear
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167821442255.6197.7520561514136538102.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Mar 2023 18:40:22 +0000
References: <20230304135035.6232-1-lm0963hack@gmail.com>
In-Reply-To: <20230304135035.6232-1-lm0963hack@gmail.com>
To:     Min Li <lm0963hack@gmail.com>
Cc:     luiz.dentz@gmail.com, marcel@holtmann.org, johan.hedberg@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jkosina@suse.cz, hdegoede@redhat.com,
        david.rheinsberg@gmail.com, wsa+renesas@sang-engineering.com,
        linux@weissschuh.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Sat,  4 Mar 2023 21:50:35 +0800 you wrote:
> There is a potential race condition in hci_cmd_sync_work and
> hci_cmd_sync_clear, and could lead to use-after-free. For instance,
> hci_cmd_sync_work is added to the 'req_workqueue' after cancel_work_sync
> The entry of 'cmd_sync_work_list' may be freed in hci_cmd_sync_clear, and
> causing kernel panic when it is used in 'hci_cmd_sync_work'.
> 
> Here's the call trace:
> 
> [...]

Here is the summary with links:
  - [v2,1/1] Bluetooth: fix race condition in hci_cmd_sync_clear
    https://git.kernel.org/bluetooth/bluetooth-next/c/83ce39248d6d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


