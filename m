Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B692B581E48
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240151AbiG0DaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiG0DaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E025FC0;
        Tue, 26 Jul 2022 20:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A82B9615BB;
        Wed, 27 Jul 2022 03:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E4B1C433D7;
        Wed, 27 Jul 2022 03:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658892613;
        bh=mYmkGhE+TDagfGq63u9eYbxdP+GDgv7ePkP1LSAJqKs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sKmgipJZdaQ3mY02St2TXXPZzxu7vijYNkCk7LXwtRHYCwO3D1sAgIxhuwIQk4csd
         0Zpjhd5BpGgpA953SKHYygzo1q8HT01vHaSDiMLInHj+pcQ/DCcSNID3tXEoEJAhyG
         e04y2WF7Ephr5yKViC+ZyXTcaMrtO7KS4kyWI/odJNFLvrOkobyB4YfdU/4GMfyNZm
         vl6IIJnhFcnDQSsFnWK1TDZchd4j1m/eMN9AKr5VXZYlRjDW27KtI1yCDmoyT1VsUj
         EJNt6FOyiwuS60UrBlIVz27Zf/a/O72LkAPtWFzO7aFI96CVRQ9Od0ub6o/dzMjZAV
         HJOx+TkFh751Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7327C43140;
        Wed, 27 Jul 2022 03:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: net: Fix typo 'the the' in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165889261294.20797.8257357342204781894.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jul 2022 03:30:12 +0000
References: <20220725020124.5760-1-slark_xiao@163.com>
In-Reply-To: <20220725020124.5760-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 25 Jul 2022 10:01:24 +0800 you wrote:
> Replace 'the the' with 'the' in the comment.
> 
> Signed-off-by: Slark Xiao <slark_xiao@163.com>
> ---
>  tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - selftests: net: Fix typo 'the the' in comment
    https://git.kernel.org/netdev/net-next/c/060468f0ddbb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


