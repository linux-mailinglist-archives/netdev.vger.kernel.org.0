Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA1A6886E2
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbjBBSmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbjBBSly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:41:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558207CC80;
        Thu,  2 Feb 2023 10:41:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0454061CB4;
        Thu,  2 Feb 2023 18:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D0DBC433D2;
        Thu,  2 Feb 2023 18:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675363218;
        bh=3A2n6cFSrOjxIKO9lKcSECWrTggQY+SWeTQyV9xcx90=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZprKzMlm0RyL9WRM3pNOYB6gA616oKPki5iQ6XbjNrFUKZijf6GolZ0TphA5lkQ8M
         lsl5GW8iRyxv137dp64JhKPDygwV+8ubq3gBfgBhPVjErVkkSNWzr16Kfqr+n4bWHg
         jBi9upGQaDTo2TLYhp81w/UqO+fL3LEWbMC85OnahKPqzN+UaU4L7p0bYvZmyvZyjm
         7N6Bl5vTcPX8i/uz7THYxfpDB3zPR0MRpN2BAULLTOER9W3P+nYYzI1Ko04kFg+glf
         4URvqmSmx5V4EZnR7AUHV3CMeovhBD8SJW0ImluPrXptqi6r2mSFjDS0uazarUsd29
         XGwKFVmyU5O0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B414C0C40E;
        Thu,  2 Feb 2023 18:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] virtio-net: Keep stop() to follow mirror sequence of
 open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167536321823.25597.8843231088596715068.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 18:40:18 +0000
References: <20230202163516.12559-1-parav@nvidia.com>
In-Reply-To: <20230202163516.12559-1-parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        jiri@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 2 Feb 2023 18:35:16 +0200 you wrote:
> Cited commit in fixes tag frees rxq xdp info while RQ NAPI is
> still enabled and packet processing may be ongoing.
> 
> Follow the mirror sequence of open() in the stop() callback.
> This ensures that when rxq info is unregistered, no rx
> packet processing is ongoing.
> 
> [...]

Here is the summary with links:
  - [net] virtio-net: Keep stop() to follow mirror sequence of open()
    https://git.kernel.org/netdev/net/c/63b114042d8a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


