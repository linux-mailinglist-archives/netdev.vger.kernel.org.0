Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEBD06A842F
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 15:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjCBOaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 09:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjCBOaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 09:30:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547253C785
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 06:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE622B8122C
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 14:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74F66C433D2;
        Thu,  2 Mar 2023 14:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677767418;
        bh=Z1rqm30IOt3F6ei/OO0lkFngHFiCTWkUd0LXxX1Fhjk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CuF95hK1Dv+QzTD8x+xu04jVCQUV8aBYOXhdVyb3nw1roF9/y4mDOfJeZ+0ci8i0m
         92XDdtkcE7wmtVydFWLhp9xq0vvgD5iEWN0rvLecbpmJ3kem40ETe5KX8/DWr5SaZx
         HyP17h7G3pAN49b8tkIxeXnxn9EcgTWJbn5tTeWKuTu7m3PtQjNYg5vo+uZvv1bigw
         cNphRUtDuVXdV5uAPF4yM01zhI/CGmhaXdOHk0OoG5+blmVNS5DFtuVfkdf3SkdzpR
         3b+Y2/5iblyWG42g6UfeJlv9QvSrafGGkKT7ZKQrqnQi4/hVfFm1Sb+C/qjoDw2DBy
         UFGnzsiEjqYDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 53591C43161;
        Thu,  2 Mar 2023 14:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: use indirect calls helpers for
 sk_exit_memory_pressure()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167776741833.7420.4115296269644452313.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Mar 2023 14:30:18 +0000
References: <20230301133247.2346111-1-edumazet@google.com>
In-Reply-To: <20230301133247.2346111-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, brianvv@google.com,
        fw@strlen.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed,  1 Mar 2023 13:32:47 +0000 you wrote:
> From: Brian Vazquez <brianvv@google.com>
> 
> Florian reported a regression and sent a patch with the following
> changelog:
> 
> <quote>
>  There is a noticeable tcp performance regression (loopback or cross-netns),
>  seen with iperf3 -Z (sendfile mode) when generic retpolines are needed.
> 
> [...]

Here is the summary with links:
  - [net] net: use indirect calls helpers for sk_exit_memory_pressure()
    https://git.kernel.org/netdev/net/c/5c1ebbfabcd6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


