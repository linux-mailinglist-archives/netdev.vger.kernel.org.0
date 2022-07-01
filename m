Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79EC562960
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 05:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbiGADKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 23:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbiGADKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 23:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379C8248FE
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 20:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4F94B82E02
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 03:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76D82C341CB;
        Fri,  1 Jul 2022 03:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656645016;
        bh=crnXSW0N5uhFAVrUH+HxdX3qDlgKLqnOxZuTv2RF6L8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gcxxxin9ZbV5hvWVitQ52naSHwXzoQynziYwAE+mB8y62O3PcRAqLiSK8mAlj7mW9
         SPwxeA//zfF+9rT/5ztArmWTCYFa8yRn7VqCBDGX5T+bHzq8ybKcQ/VYcJQjXoKuIR
         PI3hCvxoVWHDCOf5CFoXx3Q8BuKqwNS26V4IIUzz8XexuyPIkUdSmuCsCqS0hIpb+J
         MadwX7S30TvkdfcoadJvrnPyKjCTQvg8wRd/hgkc55GKVscEsn0TkLo9P1+p6QkUb/
         IKv/wkK4pHMpNrD24ZSLhhwh4gFKSdCiji78VWw8BpU1YlEIuxOt4vqenGn1tN9Ydd
         6WFTGUP66DjQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E950E49BBB;
        Fri,  1 Jul 2022 03:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15][pull request] 1GbE Intel Wired LAN Driver
 Updates 2022-06-30
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165664501631.21670.6787936863990384832.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 03:10:16 +0000
References: <20220630213208.3034968-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220630213208.3034968-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 30 Jun 2022 14:31:53 -0700 you wrote:
> This series contains updates to misc Intel drivers.
> 
> Jesse removes unused macros from e100, e1000, e1000e, i40e, iavf, igc,
> ixgb, ixgbe, and ixgbevf drivers.
> 
> Jiang Jian removes repeated words from ixgbe, fm10k, igb, and ixgbe
> drivers.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] intel: remove unused macros
    https://git.kernel.org/netdev/net-next/c/fda35af97595
  - [net-next,02/15] ixgbe: remove unexpected word "the"
    https://git.kernel.org/netdev/net-next/c/4fb8cfedd8fc
  - [net-next,03/15] fm10k: remove unexpected word "the"
    https://git.kernel.org/netdev/net-next/c/a5f976580238
  - [net-next,04/15] igb: remove unexpected word "the"
    https://git.kernel.org/netdev/net-next/c/4d5173c6f6eb
  - [net-next,05/15] ixgbe: drop unexpected word 'for' in comments
    https://git.kernel.org/netdev/net-next/c/eb6683b622c5
  - [net-next,06/15] intel/e1000:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/38f0430e1658
  - [net-next,07/15] intel/e1000e:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/e2ef1c2d9a14
  - [net-next,08/15] intel/fm10k:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/17527829dfb6
  - [net-next,09/15] intel/i40e:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/09f85edd98e2
  - [net-next,10/15] intel/iavf:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/afdc8a54e297
  - [net-next,11/15] intel/igb:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/7cdb8cc82ffb
  - [net-next,12/15] intel/igbvf:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/1ca33bf983f3
  - [net-next,13/15] intel/igc:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/1e401f7680c9
  - [net-next,14/15] intel/ixgbevf:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/8bfb7869ec37
  - [net-next,15/15] intel/ice:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/173e468c717c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


