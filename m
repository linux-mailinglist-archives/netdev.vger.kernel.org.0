Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27881623ABD
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 05:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiKJEAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 23:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiKJEAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 23:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDCB2496E
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 20:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 114B1B8208B
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 04:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D777C433B5;
        Thu, 10 Nov 2022 04:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668052815;
        bh=CPOjXDDk9AgeAG/mKa+JQg1iYQRa51eJl1b+WBMMiCs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZEmkZtKerI6zl6l9qpMt2LucHS8xR+T0uYf7v0wcuGVBYTyMpKnHazhHHRVKIVxJG
         z7ZR/uhuZHZ4gYBQCtlp0N1/stkt9U3anO7M+suUafBJAAG+5GoRvQmY1dzcg/RYd1
         lHeuUXXcJ04qG0V+E2Da0sDCRUkwhvlYeopwBTcHFlKmF86gZl9Suc7Ve6JjPUkrQ2
         SfimWpwMj8Y0EDjZayXDyA/r+p4QIdsr47UV8iUXizUmzSyZBYQSNm6YPptZiwr+/4
         ppmw06UdUR0qm1ooomvp+U3S+M/q9xFLDg3/00nMqOcUaZprOhckihkYdsyFFzEyk6
         ogmTlWSmeJe6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7AE20E21EEC;
        Thu, 10 Nov 2022 04:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cxgb4vf: shut down the adapter when
 t4vf_update_port_info() failed in cxgb4vf_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166805281549.8987.7985515761353959392.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 04:00:15 +0000
References: <20221109012100.99132-1-shaozhengchao@huawei.com>
In-Reply-To: <20221109012100.99132-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, rajur@chelsio.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        arjun@chelsio.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
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

On Wed, 9 Nov 2022 09:21:00 +0800 you wrote:
> When t4vf_update_port_info() failed in cxgb4vf_open(), resources applied
> during adapter goes up are not cleared. Fix it. Only be compiled, not be
> tested.
> 
> Fixes: 18d79f721e0a ("cxgb4vf: Update port information in cxgb4vf_open()")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] cxgb4vf: shut down the adapter when t4vf_update_port_info() failed in cxgb4vf_open()
    https://git.kernel.org/netdev/net/c/c6092ea1e6d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


