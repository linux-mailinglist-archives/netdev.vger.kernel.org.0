Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5D64BB8A5
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbiBRLua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:50:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbiBRLu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:50:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4311AF068
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 03:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 827DAB825DF
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 11:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B5B7C340F1;
        Fri, 18 Feb 2022 11:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645185009;
        bh=GYXNiEQzzD6zsLt0V9k9sN2xttiMprK6/YCYdM3ciKI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nbbQoTmbTczy1TQ+fiRD3IlX3P8qcyove1//8f69zqrsBA8eWypKgu5UnyPyKcWZC
         HTN2i0sXhg1puWrDclO0uS9FnuLaF9BVpgRD3NMTwyrPoUxs+9veKnOmF5Y7Qj5r+Z
         +8RmslC67IIYyzV4g9zr9DSSxDTTNbckjUtT3eYTffVAj2sLeHOn9qZX4bBOIdHqVN
         IBmFQUQaSBN758VmcPEvz+/z5JNHkpk6DJWUe4QIKpKOPq+m9LmRTWjiYP6p8xGN+m
         GgtlHTTBT43yoU2J62Q16GprY/ulvoDULJLHIyF6nFBWjz6UkVWuNXIMQvSUrck+IP
         dD7KcQ83TV20g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 32CF5E7BB08;
        Fri, 18 Feb 2022 11:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net-timestamp: convert sk->sk_tskey to atomic_t
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164518500920.13243.660537030973822064.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 11:50:09 +0000
References: <20220217170502.641160-1-eric.dumazet@gmail.com>
In-Reply-To: <20220217170502.641160-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, willemb@google.com, syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Feb 2022 09:05:02 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> UDP sendmsg() can be lockless, this is causing all kinds
> of data races.
> 
> This patch converts sk->sk_tskey to remove one of these races.
> 
> [...]

Here is the summary with links:
  - [net] net-timestamp: convert sk->sk_tskey to atomic_t
    https://git.kernel.org/netdev/net/c/a1cdec57e03a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


