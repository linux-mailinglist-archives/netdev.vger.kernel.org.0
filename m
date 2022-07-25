Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A78157FD2A
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 12:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbiGYKKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 06:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbiGYKKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 06:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFBD2DCE;
        Mon, 25 Jul 2022 03:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F773612BB;
        Mon, 25 Jul 2022 10:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4FE7C341D2;
        Mon, 25 Jul 2022 10:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658743813;
        bh=yfParoQXMrEGU8dG++5USAtAYMV91fpxtQezxCWY2Fw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F0rPl6iCfLqHYI2nx9Ncbb27eEuGQgq65GDSq57477YG8ygUwWMa7j5Lpo/WRvvOE
         y5Hb217u6RIxr/AFie+8bDxJdxppcU6mNZCMgfmEQD6THUSmHZnWE+hQ2CCLFuF661
         N8aVtTctpapW1YS16KuSBnfXPsYQqwvmRlnRbwDMJDMvN6QU1gWJI5m4YFDDjISp88
         Qpm5WEg75yF2Kd3XQKjYGO36euRsHNpsehIKujFDFwk0q+VrtkTlXy+BDmGw4qEUKl
         AOrEAGE6dIRsTFSiZgRTHciXxr2CvAFtkvgRxB8l1k0xFAFc0kTessGP4gd6NR5j+o
         CX3mgRYCt/83Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B9E8E450B5;
        Mon, 25 Jul 2022 10:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] s390/qeth: Fix typo 'the the' in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165874381356.12821.2746281291182999684.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jul 2022 10:10:13 +0000
References: <20220722093834.77864-1-slark_xiao@163.com>
In-Reply-To: <20220722093834.77864-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     borntraeger@linux.ibm.com, svens@linux.ibm.com,
        wintera@linux.ibm.com, wenjia@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Jul 2022 17:38:34 +0800 you wrote:
> Replace 'the the' with 'the' in the comment.
> 
> Signed-off-by: Slark Xiao <slark_xiao@163.com>
> ---
>  drivers/s390/net/qeth_core_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - s390/qeth: Fix typo 'the the' in comment
    https://git.kernel.org/netdev/net/c/1aaa62c4838a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


