Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2004BA400
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 16:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242322AbiBQPK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 10:10:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbiBQPK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 10:10:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AC9277930
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EB4E61E72
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 15:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EA7AC340EF;
        Thu, 17 Feb 2022 15:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645110610;
        bh=zvhNvnd/u4tnTFIbzyrRiz31vQU32jqxy8fqccyMmKE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jz3V/sMUSENBjqCIPOaxsCgNSdINxSwwNyi2tc96vGMgUJWYywqVY/I9y+BB9qZ90
         cJ96t1u20CD27rnSrcj0wPhEUjctkSs8crzUrTbWPdhgQr9JNX762G7eUQqcyB4L2A
         v5oV0MF4Ax0hgKJm4l8w1gFRPIlL+T7uSZ1CksucHS+nCLRfwfDlNDb5t89/L3K90C
         zwbGy0LtQMaj+gFA7L514swOH5NbpIdQ6+65pvtS51rstKZT7Oj/cMGII6qoQE1+sn
         +zOqdGnKSYUB+jIfSkbsWRIhD8kU3btreHkIJ3P2tH+cp6xg3+TCdl4xzbdDWqDe7W
         pHSvqM0bjn14A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ECEA6E7BB07;
        Thu, 17 Feb 2022 15:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ping: fix the dif and sdif check in ping_lookup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164511060996.20469.3269996433957457977.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 15:10:09 +0000
References: <ea03066bc7256ab86df8d3501f3440819305be57.1644988852.git.lucien.xin@gmail.com>
In-Reply-To: <ea03066bc7256ab86df8d3501f3440819305be57.1644988852.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        segoon@openwall.com
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

On Wed, 16 Feb 2022 00:20:52 -0500 you wrote:
> When 'ping' changes to use PING socket instead of RAW socket by:
> 
>    # sysctl -w net.ipv4.ping_group_range="0 100"
> 
> There is another regression caused when matching sk_bound_dev_if
> and dif, RAW socket is using inet_iif() while PING socket lookup
> is using skb->dev->ifindex, the cmd below fails due to this:
> 
> [...]

Here is the summary with links:
  - [net] ping: fix the dif and sdif check in ping_lookup
    https://git.kernel.org/netdev/net/c/35a79e64de29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


