Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375FE6C9BAA
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbjC0HKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjC0HKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADB8422F;
        Mon, 27 Mar 2023 00:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A86260F37;
        Mon, 27 Mar 2023 07:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 399F8C433EF;
        Mon, 27 Mar 2023 07:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679901017;
        bh=IUvyyiwYsPE4r6JBVkCkjnwgxhjW8rOJJ1v9wfvuYbc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kaVm+a8FXz6ry4wmnizZfLIkN35fKbtSLTug4RseOaXD5n8X2Ez1CQw3fo9uXbxs8
         3lJlIk/P/Rstsjh1PPdA39wyQjpp8ViHiLyfCuQFEDT6t5kBu4i0z0qNHYhueUl+Dx
         aKZFXVV3qcZJPd0TS1Y2HHrHnt/UVmLNCS6cUBJXT0eHGAg/U/A3MWTm0xe6Ti6d1N
         Y7wNzCaGLuZHl/dkCLxLzBwlIPPyCJ+9JWrtPquKlALsykBTaLCm766bJTp+BQOknf
         FjoCgbMp+xvJFgs64YJKBqzvjWK1n3697FyX++wYI99Hs4/PbTNxGZViKUDyneKXED
         sc1r6xvYDaLGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22CC3E2A038;
        Mon, 27 Mar 2023 07:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/net_failover: fix txq exceeding warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167990101713.32063.15572792835882009965.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Mar 2023 07:10:17 +0000
References: <20230324091954.1890561-1-faicker.mo@ucloud.cn>
In-Reply-To: <20230324091954.1890561-1-faicker.mo@ucloud.cn>
To:     Faicker Mo <faicker.mo@ucloud.cn>
Cc:     sridhar.samudrala@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        keescook@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Mar 2023 17:19:54 +0800 you wrote:
> The failover txq is inited as 16 queues.
> when a packet is transmitted from the failover device firstly,
> the failover device will select the queue which is returned from
> the primary device if the primary device is UP and running.
> If the primary device txq is bigger than the default 16,
> it can lead to the following warning:
> eth0 selects TX queue 18, but real number of TX queues is 16
> 
> [...]

Here is the summary with links:
  - [v2] net/net_failover: fix txq exceeding warning
    https://git.kernel.org/netdev/net/c/e3cbdcb0fbb6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


