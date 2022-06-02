Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017E053B10B
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiFBBAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiFBBAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFD82A1431
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 18:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00B7C615CE
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 01:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44629C34119;
        Thu,  2 Jun 2022 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654131613;
        bh=44SmpGUn/ny/JY5t6msKpDoFfni627X26tsaLfrSwxA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tuwiR4DmEQJ45K06NxCwdOot47KBt+3eMF+H+awmCoF4p5FJ4wn+Zj/20w91LP102
         AYAhzxc1m6vwc2HYlcOkX6hw1dhULgUud4Eh6WtLy6auaqa6DY/Jnnw2OCtHEpZ9+k
         IOHzJ8uO0c/D2k5gmT9Ix9cOpAcK1LteGc6KhPTDxTQRFgdyu2Pmr+KlxazaSkr6YR
         JB2ahOjBl7Xk83GU7ZwIPSnxf+ugWqFcVvix7zucJHhRqVrqVIArrkkUwwXKTAdU/G
         sehJ/jGG0lftxnSzLahO/7hcnFfNmSKsXPmf2xOWj0c7DVdX9RxCdLj5Z7/3X58w7M
         qfANqjDWw3NSQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 245A2F0394E;
        Thu,  2 Jun 2022 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] sfc/siena: fix some efx_separate_tx_channels
 errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165413161314.28793.16204429882190460033.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Jun 2022 01:00:13 +0000
References: <20220601063603.15362-1-ihuguet@redhat.com>
In-Reply-To: <20220601063603.15362-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, cmclachlan@solarflare.com, brouer@redhat.com,
        netdev@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  1 Jun 2022 08:36:01 +0200 you wrote:
> Trying to load sfc driver with modparam efx_separate_tx_channels=1
> resulted in errors during initialization and not being able to use the
> NIC. This patches fix a few bugs and make it work again.
> 
> This has been already done for sfc, do it also for sfc_siena.
> 
> v2:
> * fix patch that didn't apply cleanly
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] sfc/siena: fix considering that all channels have TX queues
    https://git.kernel.org/netdev/net/c/183614bff5fc
  - [net,v2,2/2] sfc/siena: fix wrong tx channel offset with efx_separate_tx_channels
    https://git.kernel.org/netdev/net/c/25bde571b4a8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


