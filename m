Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91A7584AEE
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbiG2FAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbiG2FAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CB414D2A;
        Thu, 28 Jul 2022 22:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B95E961E86;
        Fri, 29 Jul 2022 05:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15A31C43470;
        Fri, 29 Jul 2022 05:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659070816;
        bh=z517bwqpLwRNFxwY2OWBD6UCFulSnp5eNBeV/7/0QvY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t+BZgeEuOcXdPI1Fpemxz5vd51wa/0gxmOhnUBu2fwjP8NYW8i6zHbWCNxtXx4iFA
         5Bvi7rXMgIUwNnNK24wxM127+WZyIchnK5sZPwoPicNe24VNLURYjtZUyUh5ttGHuy
         a+BbOmUEQt/E11Z07NzD67I1w0kNCcet3lMKIHT4la/6ZUesiEIitBvtWkh9FTUXuS
         MLVuREw7xeT/ffj8afbHXopd/d0PeEvzzRt1O/zPKT33npja5wxfLPZlcApJdWAq6V
         d+q/rIemSEi46jpvXQynQ4gDLXU988LDlDHjK0K08QKWSttKSU75YgLxWDEcbaf0Q+
         jON3MqWe/nO4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E5F90C43145;
        Fri, 29 Jul 2022 05:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v2] tls: rx: Fix unsigned comparison with less than zero
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165907081593.3346.3097118939302829413.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 05:00:15 +0000
References: <20220728031019.32838-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20220728031019.32838-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     kuba@kernel.org, borisp@nvidia.com, john.fastabend@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Jul 2022 11:10:19 +0800 you wrote:
> The return from the call to tls_rx_msg_size() is int, it can be
> a negative error code, however this is being assigned to an
> unsigned long variable 'sz', so making 'sz' an int.
> 
> Eliminate the following coccicheck warning:
> ./net/tls/tls_strp.c:211:6-8: WARNING: Unsigned expression compared with zero: sz < 0
> 
> [...]

Here is the summary with links:
  - [-next,v2] tls: rx: Fix unsigned comparison with less than zero
    https://git.kernel.org/netdev/net-next/c/8fd1e1517792

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


