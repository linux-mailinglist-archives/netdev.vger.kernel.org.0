Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81F16DD8F3
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjDKLKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjDKLKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B89E58;
        Tue, 11 Apr 2023 04:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CF0B6247A;
        Tue, 11 Apr 2023 11:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 667C9C4339B;
        Tue, 11 Apr 2023 11:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681211417;
        bh=6b5K000Snt32Am8snjMeRagyFkOMtPsMRTWng3IugAk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tMuHRlGx8n0InI+d0CgtEURr7yJ6Zt56HvgIn0TX5f2HGtM1gaUyk8VwBH677aoM3
         p6OFiWi+JYaUfz3Tchg7tM59Y3HachQUnna+a9M7AwQO16ff5h3a5AlkUd23yjxIIh
         AFYbJrjBEI/yqILIMxUPktjXFE2QBlaPvr/E1EhQU5Xz2lwhhReWHR9VK2x62qkFzs
         rK54i3nCFPK6+hVlQP/H8h+iR/pauPUrF6WCywVzu2S92RyPdXruG6YIinRcnG3Dx6
         UjfGunmuX9HThQAzreo/LUJft9BH0PhhAHbuBGaz5khUct+JxirP0VauaPcG+CXO2i
         o9o9iUqDB0VuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B4F5C395C3;
        Tue, 11 Apr 2023 11:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fddi: skfp: rmt: Clean up some inconsistent indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168121141730.2757.8137118064541132856.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Apr 2023 11:10:17 +0000
References: <20230407034157.61276-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20230407034157.61276-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, abaci@linux.alibaba.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri,  7 Apr 2023 11:41:57 +0800 you wrote:
> No functional modification involved.
> 
> drivers/net/fddi/skfp/rmt.c:236 rmt_fsm() warn: if statement not indented.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4736
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - net: fddi: skfp: rmt: Clean up some inconsistent indenting
    https://git.kernel.org/netdev/net-next/c/89863a3b5f02

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


