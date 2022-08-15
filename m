Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4177A592D33
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242353AbiHOKkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 06:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242320AbiHOKkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 06:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE8E271
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 03:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FAF8B80DF2
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 10:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 608BCC43140;
        Mon, 15 Aug 2022 10:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660560014;
        bh=4iyTnLRAWpQkZ1bB4qb5AQPD0eH51ezFu34OkwRIqqg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dMBNMi1uiFTx8Dc9C656voE1XMGYhYfN30rvNSpujjt0gllv0ModVtFojCBYbcQKn
         83p5/TmfDorBgkOdJ1HHwTf0hWloVqWP++X2k2+MM2xB4/xF9HFGZpDy7O3BnvW16z
         nNJIEMwvl3VYSSZcxtq3jqdwkVfzbFcHpDTX4JzOcKhk83UpVzlaJwl6GkQjB1xyqw
         mK0NMgYhNhxvozn28KpJHWypnGJQWTerrbLdyaZws++upYCLnt6K4wdWcWUBZzqlr1
         wA19VHkusQ4lQLh5/VPNLCy4YkDA5UeI9AEzwEYaEHIGaIVtrnQw3c8zMyt5s3Hk4P
         ol+Edm1n7PS7A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3EE90E2A050;
        Mon, 15 Aug 2022 10:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-08-11 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166056001425.15339.102327911809000452.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Aug 2022 10:40:14 +0000
References: <20220811161714.305094-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220811161714.305094-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
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

On Thu, 11 Aug 2022 09:17:12 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Benjamin corrects a misplaced parenthesis for a WARN_ON check.
> 
> Michal removes WARN_ON from a check as its recoverable and not
> warranting of a call trace.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ice: Fix VSI rebuild WARN_ON check for VF
    https://git.kernel.org/netdev/net/c/7fe05e125d5f
  - [net,2/2] ice: Fix call trace with null VSI during VF reset
    https://git.kernel.org/netdev/net/c/cf90b74341ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


