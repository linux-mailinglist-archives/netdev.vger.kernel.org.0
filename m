Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0751C50B4B7
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446425AbiDVKNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354901AbiDVKNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:13:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13612DD70
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8007B61E3B
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 10:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA3EBC385A4;
        Fri, 22 Apr 2022 10:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650622211;
        bh=bGTho2n9U0wtaCpdrKwFWmTXLsAV6tjjvi5P2q8ZwzM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R58ZyToh0ZlyhjyJtetsGQ1sDc06w3anCSPdMkf/Ahkv+GdZ7kRgX3FN95vr1WK8H
         LM5ksVGnvw+XWjylc/1479NTIqJrihj0Hu/U48TcPOO/suaarYgWGAiPLK3fYPOgI6
         f5W0Z5OZV3pky8zMfXd+iF0Kwt2sldRPFe4Q6DZq8Q//pVhGkHULBj/MQDhS9nnPQr
         fvCuXZeNDlMvcK/3J90bO3fLfWY3oXw7PPwssKei34Lf1BFMqjRYGf15gSfVag40B4
         JUueyFJzS12ilt18WXhemxXsKTqQi5usK1uoZA02NJrwi19Lho9ED0A4nhXvMRZ8LH
         tMn1Km8y7gkmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA7F3F0383D;
        Fri, 22 Apr 2022 10:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: support 802.1ad VLAN assingment to VF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165062221176.10818.12451538760168256565.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 10:10:11 +0000
References: <20220419124443.271047-1-simon.horman@corigine.com>
In-Reply-To: <20220419124443.271047-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com
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
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Apr 2022 14:44:43 +0200 you wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> The NFP driver already supports assignment of 802.1Q VLANs to VFs
> 
> e.g.
>  # ip link set $DEV vf $VF_NUM vlan $VLAN_ID [proto 802.1Q]
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: support 802.1ad VLAN assingment to VF
    https://git.kernel.org/netdev/net-next/c/59359597b010

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


