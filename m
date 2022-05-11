Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5691B5232F9
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbiEKMUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiEKMUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2771693986;
        Wed, 11 May 2022 05:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BED3F61B11;
        Wed, 11 May 2022 12:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19A4BC34116;
        Wed, 11 May 2022 12:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652271613;
        bh=XoSrYn9clPi4ZNMI0zqMJuo51XfiuJts3q1xFeoGlBw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TFLeOAgsH8L7Ocnp00lU24V75mgM9n1tTkTjIW2RzvhvYHuWOTsz7KGWKh1ly+psk
         lMJIxDEprEjPqxvyrq/+tbIZWXoAfdY0zRBvPtM5HLYyqkbgIUoXb8Fub4Xl8pLsCw
         lsVT4uhMSAnlA2tR4AYVPAu0pEbqs1ONvWjMcCzDL/zU1PYoR1GUn7TTeySiTeeGyc
         QEIoAroKTaf9oy3m5XEdoZmljsNCcunzuoFYOz44XFrXWlP+be6pz/dqFZ0O9hVMY+
         lMREpiprZ/rCqVXxHhc2vKVwxmTGjGliCk4KaiS6zSpV5zpNfc6oi165f2hMLA6zyx
         NmQTRhxuKPPFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0420EF03930;
        Wed, 11 May 2022 12:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: appletalk: remove Apple/Farallon LocalTalk PC
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165227161301.6774.12913603208154130370.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 12:20:13 +0000
References: <20220509150130.1047016-1-kuba@kernel.org>
In-Reply-To: <20220509150130.1047016-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, corbet@lwn.net, arnd@arndb.de,
        jiapeng.chong@linux.alibaba.com, linux-doc@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon,  9 May 2022 08:01:30 -0700 you wrote:
> Looks like all the changes to this driver had been tree-wide
> refactoring since git era begun. The driver is using virt_to_bus()
> we should make it use more modern DMA APIs but since it's unlikely
> to be getting any use these days delete it instead. We can always
> revert to bring it back.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: appletalk: remove Apple/Farallon LocalTalk PC support
    https://git.kernel.org/netdev/net-next/c/03dcb90dbf62

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


