Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F23F5B07C9
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiIGPAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiIGPAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:00:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5374E60A;
        Wed,  7 Sep 2022 08:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EBEFB81DAE;
        Wed,  7 Sep 2022 15:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFABAC433B5;
        Wed,  7 Sep 2022 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662562818;
        bh=LDaAYPiMQUwOKCdX537Ls4chLt3OGo4ond9LIYOfcbk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iXMQ870TZr//kmFS6G0LslxyFB/qCsOk0djZetOwujEB8l4o54Kj3LNlpgZGI4wOY
         fqezNp17mVY/m2ahfFWs9wEOlXHVkazpqxkHwKvqXa7uM+Ev9xae9c9qoVlJUOxR+d
         OJIMO/2MNkgml07qG5KV99VYWy4Hfb5csfk3stv++7YYRnN7aIncIiXy+f4/Wx8DMQ
         taCtwnw/NIiLTqEA0RKqRF5sRhnDqu4E1rCfBhXoLBK0tPK7pzHpj4gSVMGbg8e48U
         V21SEsMz9DJgl/2diBqzuHyDgK8K2MURFOaig1seVrwRTe8QuRukoICQzCpSeSmEiR
         B7++BQPYJPPVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BD4F8C73FE7;
        Wed,  7 Sep 2022 15:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sysctl: remove unused variable long_max
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166256281877.26447.3691488668583692931.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Sep 2022 15:00:18 +0000
References: <20220905125042.2234889-1-liushixin2@huawei.com>
In-Reply-To: <20220905125042.2234889-1-liushixin2@huawei.com>
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        wangkefeng.wang@huawei.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 5 Sep 2022 20:50:42 +0800 you wrote:
> The variable long_max is replaced by bpf_jit_limit_max and no longer be
> used. So remove it.
> 
> No functional change.
> 
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> 
> [...]

Here is the summary with links:
  - net: sysctl: remove unused variable long_max
    https://git.kernel.org/netdev/net-next/c/53fc01a0a8cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


