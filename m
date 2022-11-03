Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C7061753B
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiKCDu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiKCDuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B008915708;
        Wed,  2 Nov 2022 20:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67050B82665;
        Thu,  3 Nov 2022 03:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09737C4347C;
        Thu,  3 Nov 2022 03:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667447419;
        bh=500B4x0DuxrWLF+8Lr2lqo/3dXl91tmpY40d59ENr4E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W5iiRgCoVQzFV+N0UfZuGwe37mzwFV+VFy41Tno1m4COUY7LzF5mewJp2MdaFhSNW
         qnoyRuVaqhCsky0fFY7EN/XmdW8unrvjzDhykdAsbfsyrGNq34V6U5iw8P7XNIqLd1
         FM9eSUNZ/NAf+EK3RKZmOf1xulJDiRushLVPA2MrcMroLObHuvTjJoFGQOpnaKjMJW
         VrBtopcOeeK3hTYIjUlgA5IGVosalTq4e17y8l7+iUWk1JwmHWeeRsVXSd2Br5b//l
         8QVzjSFPEHD0U1DUcK3mk48NJNDQ/JTj/N4otbtfJf/p9KOgv9kPpaID8IiWbJaade
         q91AIy+ZA2YhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7CECE270DC;
        Thu,  3 Nov 2022 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sfc (gcc13): synchronize ef100_enqueue_skb()'s return type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166744741893.12191.4306844598535321397.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 03:50:18 +0000
References: <20221031114440.10461-1-jirislaby@kernel.org>
In-Reply-To: <20221031114440.10461-1-jirislaby@kernel.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     ecree.xilinx@gmail.com, linux-kernel@vger.kernel.org,
        mliska@suse.cz, habetsm.xilinx@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 31 Oct 2022 12:44:40 +0100 you wrote:
> ef100_enqueue_skb() generates a valid warning with gcc-13:
>   drivers/net/ethernet/sfc/ef100_tx.c:370:5: error: conflicting types for 'ef100_enqueue_skb' due to enum/integer mismatch; have 'int(struct efx_tx_queue *, struct sk_buff *)'
>   drivers/net/ethernet/sfc/ef100_tx.h:25:13: note: previous declaration of 'ef100_enqueue_skb' with type 'netdev_tx_t(struct efx_tx_queue *, struct sk_buff *)'
> 
> I.e. the type of the ef100_enqueue_skb()'s return value in the declaration is
> int, while the definition spells enum netdev_tx_t. Synchronize them to the
> latter.
> 
> [...]

Here is the summary with links:
  - sfc (gcc13): synchronize ef100_enqueue_skb()'s return type
    https://git.kernel.org/netdev/net-next/c/3319dbb3e755

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


