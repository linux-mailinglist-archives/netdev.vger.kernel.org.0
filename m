Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E054BB8AA
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbiBRLue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:50:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234933AbiBRLua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:50:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D7B1AF6FC;
        Fri, 18 Feb 2022 03:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F3D561F59;
        Fri, 18 Feb 2022 11:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB691C340F7;
        Fri, 18 Feb 2022 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645185011;
        bh=+Tm6XQr1neIAUJJmAPCVtNSPwkTNH14UQ8J/awwEb1I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VHvg1lwSZA6CsMdCKyUvnh82opMwGVM1dWY3aDqlRn/7UhePCcLedvO3gpcAz8us5
         //6xmyAoPQhrwWrofL+/HJ03vd42n76V5ctAONnCYixBaq+3MncqgLrFqYGS0sLv+n
         vvtymPKned9R91p8xpHBUwKIG5VK2of+G0z6SGC3QIeZIT0nnDAUKvdnCDv7gT5iGr
         gEW7GB7bjJLzgh70fXE1zMT3nSLpIUli/kcrcoEiVs45SMPDji7NiMAdhywXVBT7SP
         zG53O8GYhO+Wsa1jM05MF5N5Ye28IWnUYkllzZpUVpb6P9o3Xn1uBCjd7bmpg5HgGE
         jkyzDEkuFntiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B6347E6BBD2;
        Fri, 18 Feb 2022 11:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] teaming: deliver link-local packets with the link
 they arrive on
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164518501174.13243.5915741906688907086.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 11:50:11 +0000
References: <20220217212312.2827792-1-jeffreyji@google.com>
In-Reply-To: <20220217212312.2827792-1-jeffreyji@google.com>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, brianvv@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, jeffreyji@google.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Feb 2022 21:23:12 +0000 you wrote:
> From: jeffreyji <jeffreyji@google.com>
> 
> skb is ignored if team port is disabled. We want the skb to be delivered
> if it's an link layer packet.
> 
> Issue is already fixed for bonding in
> commit b89f04c61efe ("bonding: deliver link-local packets with skb->dev set to link that packets arrived on")
> 
> [...]

Here is the summary with links:
  - [v2,net-next] teaming: deliver link-local packets with the link they arrive on
    https://git.kernel.org/netdev/net-next/c/aaae162aeb67

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


