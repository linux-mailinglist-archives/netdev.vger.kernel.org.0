Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB234DE390
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241185AbiCRVbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbiCRVbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:31:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808E817A2FA;
        Fri, 18 Mar 2022 14:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 308C3B825CC;
        Fri, 18 Mar 2022 21:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3EECC340ED;
        Fri, 18 Mar 2022 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647639010;
        bh=li9JCCb2DVPAKEDVDaLf5+VBVHfU25LQtkMzTQvIuZY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WXdgABg+E1gRkcJQl3yaoqoIHYyBP6acymi8WtFFd3CXqFMl2NpFI19VE4fpvX5K/
         cQie1FVdp5+jWD5GhAOrWm+SFdEjI/4CEX3XmOh4EBh94JbmXW7VLGuUQ/FpQhmrYZ
         HoNUi4rOF8TijOCc66uc0RjeTPHMqfJBnYiXQr+nIRBVAvIr7w+MGZbpkh4UmP7rS9
         jq3V8+l0mvLn1YxuI/WXIZ8+6/CAhxFLDEVmvCDKVSvCnKxLUTo4mcWwy9hGqP7dHM
         V+wqGAjBYMu8F062lWaPsbWMy5eEo8HQGLW742lGgYMr0cDH3/92rmSz3A0RS6AVK0
         j6w+mNPH4uqGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A4D37E6D402;
        Fri, 18 Mar 2022 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atl1c: remove redundant assignment to variable size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164763901067.24897.16807570827930422254.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 21:30:10 +0000
References: <20220318005021.82073-1-colin.i.king@gmail.com>
In-Reply-To: <20220318005021.82073-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, gatis@mikrotik.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Mar 2022 00:50:21 +0000 you wrote:
> Variable sie is being assigned a value that is never read. The
> The assignment is redundant and can be removed.
> 
> Cleans up clang scan build warning:
> drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1054:22: warning:
> Although the value stored to 'size' is used in the enclosing
> expression, the value is never actually read from 'size'
> [deadcode.DeadStores]
> 
> [...]

Here is the summary with links:
  - atl1c: remove redundant assignment to variable size
    https://git.kernel.org/netdev/net-next/c/0978e5919c28

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


