Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E33665651
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 09:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbjAKImB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 03:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236347AbjAKIl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 03:41:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF2B13F96;
        Wed, 11 Jan 2023 00:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 864BACE1AB7;
        Wed, 11 Jan 2023 08:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76032C433EF;
        Wed, 11 Jan 2023 08:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673426416;
        bh=RltmKVCLLxiv0UPbt5M2fnxSKCVqOvUm748rkCkwj1M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zoqi5qp+trkvdWfDm30y/PA+h+dGiDAtjhqHLuURxeInAMMsVScW9xsggi5dirInQ
         ajTEwph8XQW38HCLA2MmnF1enKyLUs0ziV/vZ47VeS/hUj1Aarv4ZawbN6fjpPNMrl
         UqHWRtIEwyX7QnwPML7RVlmmumg9KQDw8FIT16AOfUKjyRsHY3IhCwYn48U+xm9ueS
         aglf2k1kufNWYhonfepz9jDAp+QB/uGdKBKyQxKYgyCOPB7LlqO+EVftct3dXvNL/X
         zJ9G3GTZ78mNH+Yb8iGD22lDaG8q6V/SHTlqb7Aolc+3jZpUB9al35IXLDlZ7jcPsq
         XYIZfV8cy5ETQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A412E270F6;
        Wed, 11 Jan 2023 08:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: lan966x: check for ptp to be enabled in
 lan966x_ptp_deinit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167342641636.27294.1479434436242415206.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Jan 2023 08:40:16 +0000
References: <20230109153223.390015-1-clement.leger@bootlin.com>
In-Reply-To: <20230109153223.390015-1-clement.leger@bootlin.com>
To:     =?utf-8?b?Q2zDqW1lbnQgTMOpZ2VyIDxjbGVtZW50LmxlZ2VyQGJvb3RsaW4uY29tPg==?=@ci.codeaurora.org
Cc:     horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Mon,  9 Jan 2023 16:32:23 +0100 you wrote:
> If ptp was not enabled due to missing IRQ for instance,
> lan966x_ptp_deinit() will dereference NULL pointers.
> 
> Fixes: d096459494a8 ("net: lan966x: Add support for ptp clocks")
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: lan966x: check for ptp to be enabled in lan966x_ptp_deinit()
    https://git.kernel.org/netdev/net/c/b0e380b5d427

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


