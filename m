Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0409D5BD960
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiITBaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiITBaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351405FC8
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2214B81D1C
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AECE8C433D6;
        Tue, 20 Sep 2022 01:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663637414;
        bh=tQyA+ntXqsWziVr/ePuWZO+2OPbEwrNgfVyY3gWwGhQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CBhBYA3D7emXSozpNuk5vUzufmxcVolsery93IjQJJePNmiLgharyNJtClAyy+j8L
         IErPf5k7sr06OzAReKsIuyshMQTBwy12/wfOAVRjWTn6D792q8vG5ni4ahZX8N3JNF
         Z0H9sPZ9A78P/QZSrFbjp7qxzKidnrw+P1YQ7Vm8srqz9i3jcWT4xm7MaKvp8MGu+/
         C45yVnP++UNsavevuzsyYEHlzpOMuVF8dcWQxKCp5D7lqxC3pQaoy+pS8QwGQFbQJw
         1i3EU+gpnK9Qr02WQf1iASdMg/jHUnJkj4EZ917yX4pPmvE0Cmr3nipMsDR7MlZ/v2
         2LwkYz7Fwcgtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 888BCE52536;
        Tue, 20 Sep 2022 01:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnxt_en: fix flags to check for supported fw version
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363741455.2241.2399800438869532349.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:30:14 +0000
References: <20220915234932.25497-1-vfedorenko@novek.ru>
In-Reply-To: <20220915234932.25497-1-vfedorenko@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     michael.chan@broadcom.com, pavan.chebbi@broadcom.com,
        netdev@vger.kernel.org, richardcochran@gmail.com
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

On Fri, 16 Sep 2022 02:49:32 +0300 you wrote:
> The warning message of unsupported FW appears every time RX timestamps
> are disabled on the interface. The patch fixes the flags to correct set
> for the check.
> 
> Fixes: 66ed81dcedc6 ("bnxt_en: Enable packet timestamping for all RX packets")
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> 
> [...]

Here is the summary with links:
  - bnxt_en: fix flags to check for supported fw version
    https://git.kernel.org/netdev/net/c/ae8ffba8baad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


