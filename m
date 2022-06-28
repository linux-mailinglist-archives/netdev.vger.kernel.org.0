Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0DE55E02C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbiF1FkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiF1FkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B8513F01
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 22:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D204161806
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 05:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26F21C341CE;
        Tue, 28 Jun 2022 05:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656394815;
        bh=UioxRStzuVCr8kri04rt3A8WiDsgcDPrLTr1QjbBtnI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pj88tiNEgu/WZXPJn+uWcjfp9nT89FmBS8+6/nqdWy1zlbXInGJHAQ0d1wn4j36Dq
         M/MHuGcb/0QDZYty4l09IjWy9Qdi6HB5mpGzzYW6OY38Awm+cqB0Tc5SOBndLV9cZ9
         v/2lRfzn54/QUU9qujyRS8DL02f/DYRZEkw7gRv9JQtbOKWHTCsmNvVm9C6/G0oOgG
         6I1/fTnj8Mxc9ycmGJ2lAix1/DPrTXGTc2X3pLEeykqkdsn9yO0ZW6Yk6L3UqJTMpf
         AKctcVEgchVpacL2dDmxkZh3kBAjklL+2cqrLPwLIwzN38dXQhgWsbIvBAuqnXH0IE
         +zVCCXxKKVrXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0CD82E49FA3;
        Tue, 28 Jun 2022 05:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] nfp: add VEPA and adapter selftest support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165639481504.10558.7562272764232611909.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 05:40:15 +0000
References: <20220624073816.1272984-1-simon.horman@corigine.com>
In-Reply-To: <20220624073816.1272984-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        fei.qin@corigine.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 24 Jun 2022 09:38:14 +0200 you wrote:
> Hi,
> 
> this short series implements two new features in the NFP driver.
> 
> 1. Support for ethtool -t: adapter selftest
> 2. VEPA mode in HW bridge.
>    This supplements existing support for VEB mode.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] nfp: support vepa mode in HW bridge
    https://git.kernel.org/netdev/net-next/c/be80141108bc
  - [net-next,2/2] nfp: add support for 'ethtool -t DEVNAME' command
    https://git.kernel.org/netdev/net-next/c/15137daef7b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


