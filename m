Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B03B547230
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 07:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiFKFUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 01:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiFKFUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 01:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C05BF7
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 22:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD6C5B83893
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 05:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80D1BC3411E;
        Sat, 11 Jun 2022 05:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654924814;
        bh=L4kobC6hkAdfRhTOr5dREzR2DLOORvKV7o0DtN5Id/8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZffMNIxD1QWzSRcIgDdtND9S/JhAQQIxeO/bFpyL+JYECFkwXJwlH334JM6oR8tA4
         yM9EB3IMv/gTkOxGJIamJU17zavZFXGPSYMaP2rn+NMzPlXKI0c8nhPjNCFP4CQkAA
         QVK8qRju2ZOM0C/k9xaUWthaK96MkfIrcbJoEGaf+SghLC2raRZvkOuzeqW4Y8aljR
         2TEfRqPn3cXWRkDZ9NvTPy6H2rc0vKhUOjGgcpJxggZ71dcKHff1WhtLV87FOsdwcd
         WbCq33WXmwQ1CLTgI/yozK3H2jcHRdEoMYGdIm2NZve6AowFffjf0oxm/2QqUFoLjY
         QmahI7ZUeVHbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 665FEE737F0;
        Sat, 11 Jun 2022 05:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2022-06-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165492481441.17520.6828944246269859398.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Jun 2022 05:20:14 +0000
References: <20220609162620.2619258-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220609162620.2619258-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, sassmann@redhat.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu,  9 Jun 2022 09:26:16 -0700 you wrote:
> This series contains updates to i40e and iavf drivers.
> 
> Grzegorz prevents addition of TC flower filters to TC0 and fixes queue
> iteration for VF ADQ to number of actual queues for i40e.
> 
> Aleksandr prevents running of ethtool tests when device is being reset
> for i40e.
> 
> [...]

Here is the summary with links:
  - [net,1/4] i40e: Fix adding ADQ filter to TC0
    https://git.kernel.org/netdev/net/c/c3238d36c3a2
  - [net,2/4] i40e: Fix calculating the number of queue pairs
    https://git.kernel.org/netdev/net/c/0bb050670ac9
  - [net,3/4] i40e: Fix call trace in setup_tx_descriptors
    https://git.kernel.org/netdev/net/c/fd5855e6b135
  - [net,4/4] iavf: Fix issue with MAC address of VF shown as zero
    https://git.kernel.org/netdev/net/c/645603844270

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


