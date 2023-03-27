Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DA96C9E74
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbjC0Iod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbjC0IoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:44:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E874C2C
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 01:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70668B80EBE
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 08:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2EEADC433D2;
        Mon, 27 Mar 2023 08:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679906417;
        bh=iy9ID6X5zcuDfTjmhvDwyHxw6dIpKSrfxXZOZZ0BR0A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XyPvpUyebO1nZiCoVX63Ixo1ikYpoTUMnl+idz/luJNcE2JHdUh2pUlUm4A2I4f4o
         iUIUHd9F8xAscIgVSzUdySoML9ax2iQcjZ0FlP3RfHjYSBkv3sXTqIQImJOuvlanOi
         Hq9pPY078IegqF2bXLfnZTxT/0NAjSKmFy/kXwqn0BOp6CSnnjFJKTVGT9VGWCm64T
         YLc2pSeP/rhK5eVvg+9pLYDp52I0ywegR1NUF03/RGkgkShfn/D/2JkIbjkD0t32wb
         ZKX97qBJSg/MgV5zeraeNVl0IGEKN1Yzq/MfYMuVI8Wh7CGZl09etQisb7uUPRJuHQ
         wJ+PAI7GF6UMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 14AADE4D029;
        Mon, 27 Mar 2023 08:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] dev_ioctl: fix a W=1 warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167990641707.16673.6007595565648794348.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Mar 2023 08:40:17 +0000
References: <d4a549bc-062c-e6cb-fb2f-75f32f8b3964@gmail.com>
In-Reply-To: <d4a549bc-062c-e6cb-fb2f-75f32f8b3964@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Mar 2023 23:11:49 +0100 you wrote:
> This fixes the following warning when compiled with GCC 12.2.0 and W=1.
> 
> net/core/dev_ioctl.c:475: warning: Function parameter or member 'data'
> not described in 'dev_ioctl'
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] dev_ioctl: fix a W=1 warning
    https://git.kernel.org/netdev/net-next/c/e5b42483ccce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


