Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A02463609F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236351AbiKWN4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236483AbiKWNzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:55:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35C08C092
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 05:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49ECC61CEB
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 13:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9CBF1C4347C;
        Wed, 23 Nov 2022 13:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669211415;
        bh=nhWu6tM4o6EDuKd6KZ+ovfBy1k0/yLWZ4TfSbMkb3fM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MCk+Q5FXM0dcxdQ1xLXvwcTdZy3Ql7H6NJTA/NTrBIwrLW4HOQS53FEp2DjOXeL+9
         mwcLTsl8yBPTKNW87ngvQlU11Zilmf4QzUsv06ajhhZ6KDIhrqk7iAnXI8mYEgSCph
         QXHNovXb8tGoguBfoVahXGMDlvJ3Om2UnFPPrSmX/2Mm9CHpCGXhtPGojLeeRAvU9Y
         wKCqdbbsZZDE/mLmNsUJk///oq0jap1wcncoWoZgkpA5cKktZdtIL+ulFDxTks0mGp
         vfIRavvaQ4Xq4N9ncPpjEgp6HEZ31B8EC/6zNLtv+higDcsAQ/p/H4TRCO60FGZUeL
         jKZsSWitDeUWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8ACD8E21EF9;
        Wed, 23 Nov 2022 13:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sfc: ensure type is valid before updating seen_gen
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166921141556.13791.9281968802067933541.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 13:50:15 +0000
References: <20221121213708.13645-1-edward.cree@amd.com>
In-Reply-To: <20221121213708.13645-1-edward.cree@amd.com>
To:     <edward.cree@amd.com>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, keescook+coverity-bot@chromium.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 21 Nov 2022 21:37:08 +0000 you wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> In the case of invalid or corrupted v2 counter update packets,
>  efx_tc_rx_version_2() returns EFX_TC_COUNTER_TYPE_MAX.  In this case
>  we should not attempt to update generation counts as this will write
>  beyond the end of the seen_gen array.
> 
> [...]

Here is the summary with links:
  - [net-next] sfc: ensure type is valid before updating seen_gen
    https://git.kernel.org/netdev/net-next/c/e80bd08fd75a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


