Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F7568B99C
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjBFKNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjBFKNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:13:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501802194C
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 02:12:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E415B80E8D
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 10:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4372BC433A0;
        Mon,  6 Feb 2023 10:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675678221;
        bh=ff6xS9r4lTCcCIzcYMSh5vUjCBZYxdAqfUV4Ya31eao=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AmkU+pZEfmhXr9N6CCjUEltF28xVvoLea5hOUVqOBX5M9O1lIH0bfmL96GVXjYCUN
         HbnNsiaoxk8+Jz/MAxJpz8hLNAPC/XG55Uz3tIB73skrIdhSnw2mbwQEWYLLs+c/rS
         ZlM//X7QijwqOr5yvq2jNxMwu/rj0qAjOOQOyQ8A3+20ti8RuOHozXnIuVRIqXqnI5
         aXHvispWqUJ/y2eXKQjGHpTB8wgSM81XUq5beEi7ibCShohR84khLAKExRVyVsbwLp
         F/sx7yhRLNL6ymbN7Yu3tMHI8KR3A9dq1YEvirsUA9b8wDPERDmL5De1ObtLnn+aJg
         81wliDyjDu6ug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 321DAE55EFB;
        Mon,  6 Feb 2023 10:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10][pull request] implement devlink reload in ice
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167567822120.32454.7485136447860639738.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 10:10:21 +0000
References: <20230203211456.705649-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230203211456.705649-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        michal.swiatkowski@linux.intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri,  3 Feb 2023 13:14:46 -0800 you wrote:
> Michal Swiatkowski says:
> 
> This is a part of changes done in patchset [0]. Resource management is
> kind of controversial part, so I split it into two patchsets.
> 
> It is the first one, covering refactor and implement reload API call.
> The refactor will unblock some of the patches needed by SIOV or
> subfunction.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] ice: move RDMA init to ice_idc.c
    https://git.kernel.org/netdev/net-next/c/2b8db6afbc95
  - [net-next,02/10] ice: alloc id for RDMA using xa_array
    https://git.kernel.org/netdev/net-next/c/2be29286ed9f
  - [net-next,03/10] ice: cleanup in VSI config/deconfig code
    https://git.kernel.org/netdev/net-next/c/0db66d20f9cf
  - [net-next,04/10] ice: split ice_vsi_setup into smaller functions
    https://git.kernel.org/netdev/net-next/c/6624e780a577
  - [net-next,05/10] ice: stop hard coding the ICE_VSI_CTRL location
    https://git.kernel.org/netdev/net-next/c/a696d61528f0
  - [net-next,06/10] ice: split probe into smaller functions
    https://git.kernel.org/netdev/net-next/c/5b246e533d01
  - [net-next,07/10] ice: sync netdev filters after clearing VSI
    https://git.kernel.org/netdev/net-next/c/70fbc15a655c
  - [net-next,08/10] ice: move VSI delete outside deconfig
    https://git.kernel.org/netdev/net-next/c/227bf4500aaa
  - [net-next,09/10] ice: update VSI instead of init in some case
    https://git.kernel.org/netdev/net-next/c/ccf531b2d670
  - [net-next,10/10] ice: implement devlink reinit action
    https://git.kernel.org/netdev/net-next/c/31c8db2c4fa7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


