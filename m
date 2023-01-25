Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FE767ADDF
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 10:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbjAYJab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 04:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235264AbjAYJaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 04:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570684FAC7
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 01:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3FB8B818BA
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 09:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85C64C4339C;
        Wed, 25 Jan 2023 09:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674639016;
        bh=9yO3u/1bOfpHDakwpYRA6IjAuidDhwFXU8yPfNkFEDY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RF863F9lle/LT16Q+KTXe3SHmJ0PUYxPDO8f2yfDfIIyQMTBetA5tueG2ahdHWVez
         zTOMFrhT7l/UX+lzkTCNf1cGXHs3AqqBt9uD4U7f5Hb+4La1eVArGACncl9lcVB7MI
         5dj7s8M9N+U/7SUiO0kmW2HDOxfIULm3o41V0fkA2bPC0YPsYW/8xiKOHCibujO3wH
         YPiEmfUXT8zVD/ZwxsHIs6PgZvQw7RmAcc2mx2Ktlo6ePdcX+aiKIVSZ0E0eKOJX6X
         1KZikV9ZzVmPimsHiiLqPrjBgOT/DxPGyzW5mANLuQ1KlfIzOmDEfS8POvvl/Ky04c
         2CYxcyPqFu8Mw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64AB3E52507;
        Wed, 25 Jan 2023 09:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] virtio-net: Reduce debug name field size to 16 bytes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167463901640.21491.221307420769013666.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 09:30:16 +0000
References: <20230123035511.1122358-1-parav@nvidia.com>
In-Reply-To: <20230123035511.1122358-1-parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     mst@redhat.com, jasowang@redhat.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 23 Jan 2023 05:55:11 +0200 you wrote:
> virtio queue index can be maximum of 65535. 16 bytes are enough to store
> the vq name with the existing string prefix.
> 
> With this change, send queue struct saves 24 bytes and receive
> queue saves whole cache line worth 64 bytes per structure
> due to saving in alignment bytes.
> 
> [...]

Here is the summary with links:
  - [net-next] virtio-net: Reduce debug name field size to 16 bytes
    https://git.kernel.org/netdev/net-next/c/d0671115869d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


