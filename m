Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B1A675523
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbjATNA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjATNA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 08:00:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C3ABD14E;
        Fri, 20 Jan 2023 05:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDF1661F5E;
        Fri, 20 Jan 2023 13:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50706C433EF;
        Fri, 20 Jan 2023 13:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674219616;
        bh=UjqzhzJnuZIASVLLfX3u8vog0XhHHfK3vpedFw4EEas=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fRQrq4e0BgLZP3dW2YcTcLR+Oau9TPNo+5caD/tQubalA+Nt83K/wE3Ged5VJqfrT
         mf6RU/2+ekkhK5Obnm5Z/mEyhv2URISUZPxQDjABg0Ff0cJSiW3MPjRyESplPCh4hb
         5PR8izxXku/euNiurNsr25ngBuvWUOOelacx04kRAYKcOiDcSvJGc7u2aTF/XTn/jE
         sAZgeCXWDy7OJkMQTP+5+QKc0i8PiRyhgRfsj7DfrJ6zEqTNaC16Au9J72RIe9sd3p
         A9ZhJ2m0/hiamVEsKfwdI2Pt1/3BrieedWCth8iiyHEvSzY+VqNeCorNXp76EQeeCP
         LekK+dmU8W0ow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34C47C395DC;
        Fri, 20 Jan 2023 13:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnxt: Do not read past the end of test names
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167421961621.3650.4752984358502459675.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 13:00:16 +0000
References: <20230118203457.never.612-kees@kernel.org>
In-Reply-To: <20230118203457.never.612-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     michael.chan@broadcom.com, Niklas.Cassel@wdc.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
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

On Wed, 18 Jan 2023 12:35:01 -0800 you wrote:
> Test names were being concatenated based on a offset beyond the end of
> the first name, which tripped the buffer overflow detection logic:
> 
>  detected buffer overflow in strnlen
>  [...]
>  Call Trace:
>  bnxt_ethtool_init.cold+0x18/0x18
> 
> [...]

Here is the summary with links:
  - bnxt: Do not read past the end of test names
    https://git.kernel.org/netdev/net/c/d3e599c090fc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


