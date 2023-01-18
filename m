Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF8B671F47
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjAROTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjAROS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:18:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C030604A0
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 06:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FFFF61803
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 14:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96427C433F1;
        Wed, 18 Jan 2023 14:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674050418;
        bh=bzKlZAKerbXvPXB6wJKuLR4nAi56Xv9sVoP1Fhz5/AQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KTGehTPhH7E+uDUpimB18iUNQOvXVc9Z2JVeikFU4LshfR0PycqsK2SzjOm3ifylZ
         BJHT4EGyjPeUBWrmHFcENMMiqjo/25rsJmr0AfA4Ps0AEk1FguD1hOIrPiycmR/iWg
         AmR57bh7HNedCMELJrl4+IfGLoy/iIt8U5qPhPYM8H75GU9QMdb3YwFD+rep9SAoKn
         f74FhQQpFzrs0LOswZygOFNwmy1VU1FOeLlOhcXE0dP/Ygm2mDtRWz9gprH08d9IJ9
         MposimNiDbcCvxA5MfVqDnExnQLEGYhXtvZaDWasJKj5Ps5VEyl/XrOp1QNCFHmmVB
         ANg17c+lx1jCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76550C3959E;
        Wed, 18 Jan 2023 14:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] virtio_net: Reuse buffer free function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167405041848.31862.9917256420348896260.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 14:00:18 +0000
References: <20230116202708.276604-1-parav@nvidia.com>
In-Reply-To: <20230116202708.276604-1-parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     mst@redhat.com, jasowang@redhat.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        alexanderduyck@fb.com, xuanzhuo@linux.alibaba.com
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

On Mon, 16 Jan 2023 22:27:08 +0200 you wrote:
> virtnet_rq_free_unused_buf() helper function to free the buffer
> already exists. Avoid code duplication by reusing existing function.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] virtio_net: Reuse buffer free function
    https://git.kernel.org/netdev/net-next/c/eb1d929f1551

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


