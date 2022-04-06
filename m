Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37924F6635
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238416AbiDFRHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238381AbiDFRGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:06:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DC74BEF19;
        Wed,  6 Apr 2022 07:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16E2761A35;
        Wed,  6 Apr 2022 14:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C203C385A9;
        Wed,  6 Apr 2022 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255413;
        bh=b+Jn04l7J+92NIm/oLXywT4M2+LZAPg9gjG3dxBRhAc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FNtLxxWtrEPrA0lRhvpokbYAVdtth3ABiOwFLmVQdT6iioShyLzf1gjf2M3Geeu7B
         7mLSvsQ62gUa4mGQ4F5opq153IYHFBm4k2S+MOcL72dJo/S1OSNHYwOVT/mU0PlZve
         i2AuEROItMLB6xhWZdk3Atp0KrkNBEH5N3y2sTylV/snVLSHKB8wzBnw1CY4dLFDL4
         OBxb81qUQjDro6w3XPzOLEKa78VAOegm9AB4XO/ZcIky/H0DkdncyQ1uLNQuwMhBCQ
         CI4b34Mks3eVX9f9epfp4pwhPLn9MpcMNjgTZ0HX/BSpSOUia7aS5wjTiltjnryQBP
         UBW4hica35p2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6495DE8DBDD;
        Wed,  6 Apr 2022 14:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND] net: usb: remove duplicate assignment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925541340.21938.4564814458141656979.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 14:30:13 +0000
References: <1649236624-4208-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1649236624-4208-1-git-send-email-wangqing@vivo.com>
To:     Qing Wang <wangqing@vivo.com>
Cc:     bjorn@mork.no, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  6 Apr 2022 02:17:03 -0700 you wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> netdev_alloc_skb() has assigned ssi->netdev to skb->dev if successed,
> no need to repeat assignment.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> 
> [...]

Here is the summary with links:
  - [RESEND] net: usb: remove duplicate assignment
    https://git.kernel.org/netdev/net-next/c/207d924dcf32

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


