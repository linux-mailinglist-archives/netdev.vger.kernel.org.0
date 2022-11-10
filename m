Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEF8623A6E
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 04:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbiKJDaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 22:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbiKJDaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 22:30:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B43C1A225
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 19:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFE7DB82089
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 03:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66E85C433D7;
        Thu, 10 Nov 2022 03:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668051015;
        bh=U4gPpba15M1/Tg7cin2987AMh0wz+Yum0ReHHYCUBjs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k6mY7AGIINxnIl9/iQvtK5Ywb2hNPhYIhan7/i1+e9F0YnT2L6557tqOG31y93d0u
         Vxi6bpwmk/6qK7Ri7BFBmeNwg66WY8mhisYX09id56xnwxsLmMSPN7UdI6HVx81L/Q
         qo4kqWeS6N7X2waj33PLVFrTeWvS0WeikH5u5bk3aNpRanTyFUBIVYX7xvDleN9Qkb
         uBApoRvNRb6eYDvM9S7S3DLgUSPl5TLevIJxj7+Ah0m+10hGs9K9ZDyu2qto6XCD0f
         oTSCfD/0ir5VqiL7q5U/4E3UBPbzD+EcD4AgrosVu69PPUfulh7gGci/QAXvoBv/fG
         WSkuV85r/yLRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B14BC395F6;
        Thu, 10 Nov 2022 03:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] mctp: Fix an error handling path in mctp_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166805101530.26797.441965147459668060.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 03:30:15 +0000
References: <20221108095517.620115-1-weiyongjun@huaweicloud.com>
In-Reply-To: <20221108095517.620115-1-weiyongjun@huaweicloud.com>
To:     Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     matt@codeconstruct.com.au, jk@codeconstruct.com.au,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, netdev@vger.kernel.org
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

On Tue,  8 Nov 2022 09:55:17 +0000 you wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> If mctp_neigh_init() return error, the routes resources should
> be released in the error handling path. Otherwise some resources
> leak.
> 
> Fixes: 4d8b9319282a ("mctp: Add neighbour implementation")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Acked-by: Matt Johnston <matt@codeconstruct.com.au>
> 
> [...]

Here is the summary with links:
  - [net,v2] mctp: Fix an error handling path in mctp_init()
    https://git.kernel.org/netdev/net/c/d4072058af4f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


