Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01C85753E4
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 19:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239297AbiGNRUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 13:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbiGNRUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 13:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04DC4E857
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 10:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 898EEB82775
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 17:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1AC14C34115;
        Thu, 14 Jul 2022 17:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657819214;
        bh=ejwGDUoYQOfvvQBAdAJTrGds3cOtSMp0EJ4q9QPDuKY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dZQ5oI9YPo8TRLBHcehHfRfiXWceelCRuTtgV1dIWiHhOOQFopt9n/R4RcLbc/l0z
         ljL1tcj0zRnur+tjeIpj5VitN/iqfIVMuM/zimj1pPUe3ybAwicXBmEGuMa3ieV7G4
         2ifPaIsrI8O7GBEmUFbcMuq9P6mt1+2ZYmapPH66DtNSFGQUVv57ZPaG5NdTbUWisX
         skaothAXez74uLtrHXrSPhvdwfhP2z7FGAmpAq/NPoVRznLLPf2SJrtiT/B6hWpoFe
         MDbGLMVTYgRl1gFlSf0B3jnZeifh7lJmxIPAzzPd2ikl1x3VJ0qoBQ7SZzRsWFgkfM
         I01eul2dLXg5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F1B42E45225;
        Thu, 14 Jul 2022 17:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] nfp: flower: configure tunnel neighbour on cmsg rx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165781921398.9202.7080735912085993376.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 17:20:13 +0000
References: <20220714081915.148378-1-simon.horman@corigine.com>
In-Reply-To: <20220714081915.148378-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 14 Jul 2022 10:19:15 +0200 you wrote:
> From: Tianyu Yuan <tianyu.yuan@corigine.com>
> 
> nfp_tun_write_neigh() function will configure a tunnel neighbour when
> calling nfp_tun_neigh_event_handler() or nfp_flower_cmsg_process_one_rx()
> (with no tunnel neighbour type) from firmware.
> 
> When configuring IP on physical port as a tunnel endpoint, no operation
> will be performed after receiving the cmsg mentioned above.
> 
> [...]

Here is the summary with links:
  - [net,v2] nfp: flower: configure tunnel neighbour on cmsg rx
    https://git.kernel.org/netdev/net/c/656bd03a2cd8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


