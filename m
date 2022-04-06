Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD94B4F667E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238374AbiDFQ5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238273AbiDFQ4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:56:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64213468CC;
        Wed,  6 Apr 2022 07:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B825B82252;
        Wed,  6 Apr 2022 14:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D4F4C385A6;
        Wed,  6 Apr 2022 14:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649254813;
        bh=31uDdoV1TPC9gI4HFhbd7m4q67CwQW2mh97T95us+IA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t6ykpFrY1yAUFKmaBoaORP9J8Nzuo9YrCPy3YRsidcM8gXRW1pGNflAXpfVQgg2eZ
         BjhdfTyzHzU4kApNqLL+WJkovfln755zfNnNK/UOjp74RYpciwcyWC5GMlTRfs5m2B
         q9I7oTasDdJ1KPbh8GtTshD2yNlY8iORWEUMBaoAbG+6G1gq2gsk22Mwso1yeJI2CU
         uVKWQQWxdQKAE+Z1jurK0tTOssRXy6Poo59GqT0rQQVkCIroGVenQmylh4n+9outWc
         yiOqcJTUS4Lc4WHH2kB0j1LY0hN+cEkarouVpVhQ3NbIvv8L6tV3ejDYvM7STMQo5A
         5Zj4MZMGCQJlA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EBAC7E8DBDA;
        Wed,  6 Apr 2022 14:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2022-04-05
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925481296.16469.9237290319102354767.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 14:20:12 +0000
References: <20220405163803.63815-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220405163803.63815-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  5 Apr 2022 09:38:00 -0700 you wrote:
> Maciej Fijalkowski says:
> 
> We were solving issues around AF_XDP busy poll's not-so-usual scenarios,
> such as very big busy poll budgets applied to very small HW rings. This
> set carries the things that were found during that work that apply to
> net tree.
> 
> [...]

Here is the summary with links:
  - [net,1/3] ice: synchronize_rcu() when terminating rings
    https://git.kernel.org/netdev/net/c/f9124c68f05f
  - [net,2/3] ice: xsk: fix VSI state check in ice_xsk_wakeup()
    https://git.kernel.org/netdev/net/c/72b915a2b444
  - [net,3/3] ice: clear cmd_type_offset_bsz for TX rings
    https://git.kernel.org/netdev/net/c/e19778e6c911

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


