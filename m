Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2F160A937
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 15:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbiJXNRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 09:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235739AbiJXNPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 09:15:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23A6A344F
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 05:25:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54C91B815BB
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 12:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0417BC43145;
        Mon, 24 Oct 2022 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666613417;
        bh=jG78c4HjlXiwe/mRua60kND8Nl0pdWOGZDURjTnWQuE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jOyesOq/dhravsIrgbc5ym63ZE5C40eLYn0Leh6ht0LF+yezlCQofZ31uRaYFAqMY
         cs7ysbhqsiUPglm8IBFtQo8qqCZl6h2R7f2leZj8xCy79QsMRctm4O1ZAIUHbquo+u
         Cf2SpdACQW/qEJixe7fmkjZPVfX/aKTnGrM4fk3xHn0mM6EyYf8zDUu6y1slM26uhB
         hHtmK/qAtegyXRJYUMHx34MxLXJekLeNQs6q0X9Ta0wa+Wtn6LFGPQEtx6nXRokdjm
         mJUHKxVg2uBYbdrHiOV+iQQr2TviG71bV9hY7sA3QskEV4xsRh/pP3G9UM0MQUHrQt
         jiBTW8LqH/smw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1FF2E270DE;
        Mon, 24 Oct 2022 12:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] ibmveth: Always stop tx queues during close
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166661341692.16761.18167659894692301271.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 12:10:16 +0000
References: <20221020214052.33737-1-nnac123@linux.ibm.com>
In-Reply-To: <20221020214052.33737-1-nnac123@linux.ibm.com>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 20 Oct 2022 16:40:52 -0500 you wrote:
> netif_stop_all_queues must be called before calling H_FREE_LOGICAL_LAN.
> As a result, we can remove the pool_config field from the ibmveth
> adapter structure.
> 
> Some device configuration changes call ibmveth_close in order to free
> the current resources held by the device. These functions then make
> their changes and call ibmveth_open to reallocate and reserve resources
> for the device.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] ibmveth: Always stop tx queues during close
    https://git.kernel.org/netdev/net-next/c/127b7218bfdd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


