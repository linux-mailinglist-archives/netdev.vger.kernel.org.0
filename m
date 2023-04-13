Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66F56E05EB
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 06:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDMEUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 00:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjDMEUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 00:20:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DEC7EF8
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 21:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C74D63B55
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AF26C4339B;
        Thu, 13 Apr 2023 04:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681359618;
        bh=01nwy8WVlV+jGfkot4Ztjv9f4a8jvTIYB1vxdQNFCQA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r79RGQK5emBUQuWZsuKbpHbs6SXR7m3xLJVdSSjAJk/FzUszr9ukd6Gzeen4QqVA5
         qhEH6fbzEhpPQbztMmAIgwva3QW2akqgHWyT8L9cLLP5fEZphuM6XZ7xEhSalbxTfB
         ymAqnbOabzNOm7GR3FlA6pFCbRPrchtQ4Y3PkM15ulUrsn1XlAN599F8IFGH2Q4AZZ
         /+8rO8EdK5YMA0l4Y6cVvAOT9lkhYRAmg1PVoNYzg6PePLNR1MhDh+FfL6VXo+FGna
         /mA3p0wCpk0QkJD5AYP2HmMTcb4pICljfCaKEwpy14Z4z4pNUoK2xwuQ39/UUQs3Ms
         6zedgT+Voe5EA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7108BE52443;
        Thu, 13 Apr 2023 04:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/3] net: thunderbolt: Fix for sparse warnings and typos
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168135961845.12762.9753450047878314840.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 04:20:18 +0000
References: <20230411091049.12998-1-mika.westerberg@linux.intel.com>
In-Reply-To: <20230411091049.12998-1-mika.westerberg@linux.intel.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, michael.jamet@intel.com, YehezkelShB@gmail.com,
        andriy.shevchenko@linux.intel.com, simon.horman@corigine.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 11 Apr 2023 12:10:46 +0300 you wrote:
> Hi all,
> 
> This series tries to fix the rest of the sparse warnings generated
> against the driver. While there fix the two typos in comments as well.
> 
> The previous version of the series can be found here:
> 
> [...]

Here is the summary with links:
  - [v2,1/3] net: thunderbolt: Fix sparse warnings in tbnet_check_frame() and tbnet_poll()
    https://git.kernel.org/netdev/net-next/c/185367221503
  - [v2,2/3] net: thunderbolt: Fix sparse warnings in tbnet_xmit_csum_and_map()
    https://git.kernel.org/netdev/net-next/c/5bbec0adfa03
  - [v2,3/3] net: thunderbolt: Fix typos in comments
    https://git.kernel.org/netdev/net-next/c/9c60f2a4446c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


