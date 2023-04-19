Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E1E6E74AB
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjDSIKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjDSIKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137B6100
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0E0E63567
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 005F0C433EF;
        Wed, 19 Apr 2023 08:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681891819;
        bh=6kSE/tqUO/gOgEmxhLdScGk6DPsWA/xA7K+yuvj/5K8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ml29KzXrNQW1iu9kmv8UvSxjNMMonKwhgcR2ft9Oll+oxHVrtWVHFTgboR+3AJA5R
         Lm6llznMDvE9MkaHPAS9rDM8CiO6q08JlzDLFP+6u6hP5QFo6+1Hjw0IK302R8mgZp
         J8mYUw7FIlTCAfVnf4W3RYvVTOcocIFawx9KR84FQfe6mVlYRfNKr4MBiTdy4A81wq
         eZfsxiLE9k9YmwIVufGyF2Iu53G+0sxKojqrCJEnPHaEGbR1Ay8eLGMh5YAopS/S9o
         CNf9eY2vENxWkmZMBOip3logqavAY7d6MwWp1iug/f0QSh9jQpnp6AW7dsAO6tMt2b
         QDpmFCGas3v4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB01CC561EE;
        Wed, 19 Apr 2023 08:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: vmxnet3: Fix NULL pointer dereference in
 vmxnet3_rq_rx_complete()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168189181889.29892.971792346285800712.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 08:10:18 +0000
References: <20230417122127.178549-1-snishika@redhat.com>
In-Reply-To: <20230417122127.178549-1-snishika@redhat.com>
To:     Seiji Nishikawa <snishika@redhat.com>
Cc:     doshir@vmware.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 17 Apr 2023 21:21:27 +0900 you wrote:
> When vmxnet3_rq_create() fails to allocate rq->data_ring.base due to page
> allocation failure, subsequent call to vmxnet3_rq_rx_complete() can result in
> NULL pointer dereference.
> 
> To fix this bug, check not only that rxDataRingUsed is true but also that
> adapter->rxdataring_enabled is true before calling memcpy() in
> vmxnet3_rq_rx_complete().
> 
> [...]

Here is the summary with links:
  - net: vmxnet3: Fix NULL pointer dereference in vmxnet3_rq_rx_complete()
    https://git.kernel.org/netdev/net/c/6f4833383e85

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


