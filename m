Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4DC4F143A
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 14:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbiDDMCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 08:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbiDDMCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 08:02:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C117E34B8E;
        Mon,  4 Apr 2022 05:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E44D460FDE;
        Mon,  4 Apr 2022 12:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A516C3411F;
        Mon,  4 Apr 2022 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649073615;
        bh=wgjlOCgJSaoQwXvoRxQ+C1kP8bW5rNkcpSQYGUyWom8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DPV1pyHd+hoPUDQEhUUOTgDgvb/aYWAuhL3iPRdxy17yBte8zoKG41uJB8iCnEAH1
         /413J8R0yPoNmwtB9iZhULSG5C+Tt3amANsZBim//HV6QrsjrPSbr/QaG2+A6vRU9u
         2gg6UzgemLey4L/oA0QggBv+HM/E6MZ55OKel+1n/ztKhZckdlRpSha9mt8gqxKLM7
         bmN+iz3nBnWz3MAeqArdQUwficwt7cXLUjbMFZdlsK4O9T3wyXYLEGVSsv2dFbzA2P
         X3RiuueO55XK/J9yfEQURxpM5dieQC8R4R5Xh5KzWZ+6XLcsyJg+PJFIus9EcAiAw1
         SqR9x0Lfik7jQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 23744E85D5D;
        Mon,  4 Apr 2022 12:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] qed: fix ethtool register dump
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164907361514.19769.9729966277697106913.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Apr 2022 12:00:15 +0000
References: <20220401185304.3316-1-manishc@marvell.com>
In-Reply-To: <20220401185304.3316-1-manishc@marvell.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, aelior@marvell.com,
        palok@marvell.com, pkushwaha@marvell.com, stable@vger.kernel.org,
        tim.gardner@canonical.com, davem@davemloft.net
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 1 Apr 2022 11:53:04 -0700 you wrote:
> To fix a coverity complain, commit d5ac07dfbd2b
> ("qed: Initialize debug string array") removed "sw-platform"
> (one of the common global parameters) from the dump as this
> was used in the dump with an uninitialized string, however
> it did not reduce the number of common global parameters
> which caused the incorrect (unable to parse) register dump
> 
> [...]

Here is the summary with links:
  - [net] qed: fix ethtool register dump
    https://git.kernel.org/netdev/net/c/20921c0c8609

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


