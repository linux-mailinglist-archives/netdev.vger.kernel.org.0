Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1812A6E872E
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbjDTBKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjDTBKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87A649DB
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59D7D60C6E
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B818FC433EF;
        Thu, 20 Apr 2023 01:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681953018;
        bh=E9qDIlJI1DXZ4T2IrOADzghjHKGYbMsaTaw1yguJZoI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lMPya108QRf1XlNI8OB0wImi2VXGe4fK3k9j9CSwhOYbbo1U/1orxrUhCyPHZNEO0
         ahg0ozr/JRsXpVXcdcIUBrE5sR3glnPbJloHIMad6v+QaGLq+c2/zHhBP3oqdhaKFy
         dP6chtW17i/6FHHxuDDfNNUUG2UGv8hnp8S775AD6P9+merJvHWTWgy3XgKqAxL6g2
         I7dE8Owx2xHJ57oMiMAnAAoKzesH5PFRtIvRwaa6hDxOxEdJypPehMY41mAqXKsTQr
         f5Y6/L7IrZZW+soL1bMxPWx9ZQgxu6cPNw2WDq/0fIoE0HWtxUwaAJ8j3BoF4sEQZ8
         j8uFiRunuRZLQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A5911E4D033;
        Thu, 20 Apr 2023 01:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2023-04-17 (i40e)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168195301867.26669.6974185240222164254.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 01:10:18 +0000
References: <20230417205245.1030733-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230417205245.1030733-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        aleksandr.loktionov@intel.com
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

This series was applied to netdev/net.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 17 Apr 2023 13:52:43 -0700 you wrote:
> This series contains updates to i40e only.
> 
> Alex moves setting of active filters to occur under lock and checks/takes
> error path in rebuild if re-initializing the misc interrupt vector
> failed.
> 
> The following are changes since commit 338469d677e5d426f5ada88761f16f6d2c7c1981:
>   net/sched: clear actions pointer in miss cookie init fail
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE
> 
> [...]

Here is the summary with links:
  - [net,1/2] i40e: fix accessing vsi->active_filters without holding lock
    https://git.kernel.org/netdev/net/c/8485d093b076
  - [net,2/2] i40e: fix i40e_setup_misc_vector() error handling
    https://git.kernel.org/netdev/net/c/c86c00c69355

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


