Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B854CFE7E
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 13:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240418AbiCGMbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 07:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239831AbiCGMbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 07:31:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CB585BEB;
        Mon,  7 Mar 2022 04:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52BD0B811CC;
        Mon,  7 Mar 2022 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED5EBC340F5;
        Mon,  7 Mar 2022 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646656211;
        bh=HPwXi6u2RxyXpPRxeLThCpw0lecTKeSTLtRjAnp6Cs8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WXgdA2vucVVKGhbcrARYbAoCqySvVnegfhdb3jZ/WZWgdw3BX0oP7q0FnDOOxHy2e
         uik+sLVf8fOTBGh1/XDtQqoGuKoI5jxgZOiwG/noE68GfQEUwlyutPn3+fy1AwXiea
         EzthY/kP8pnucMTWUCpmA+py3zxx2C98SouPdl8eg5wJ92FV1yb5FxbPqaN9wlIdYH
         WKJvgSWulIHCUR8NMNI6FAJH2w05691DuzLqxjPIFQNMfhJky8G3XYL/Hqb1Co54qR
         +Rw7I1qfsOrMVGasczD3459D1x+8M4E8ztni6osgCA7QaI5VJYmXQdKWwn7HohJggd
         1cIF+IMWHUmHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C819DE6D3DE;
        Mon,  7 Mar 2022 12:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: return success if there was nothing to do
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164665621081.9112.654277203956305910.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Mar 2022 12:30:10 +0000
References: <20220305171448.692839-1-trix@redhat.com>
In-Reply-To: <20220305171448.692839-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat,  5 Mar 2022 09:14:48 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this representative issue
> dsa.c:486:2: warning: Undefined or garbage value
>   returned to caller
>   return err;
>   ^~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - net: dsa: return success if there was nothing to do
    https://git.kernel.org/netdev/net-next/c/cd5169841c49

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


