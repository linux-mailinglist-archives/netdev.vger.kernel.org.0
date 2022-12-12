Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5E864AB94
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbiLLXaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233933AbiLLXaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:30:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CEF1ADAE;
        Mon, 12 Dec 2022 15:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3DBF612A3;
        Mon, 12 Dec 2022 23:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 113A8C433A4;
        Mon, 12 Dec 2022 23:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670887818;
        bh=+/gZuwbX2AOZla/BINx/sTVv2bw8lA7Os1gfimf9CMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RCyAkMYFmiEeSLpRTJ+sEjo2J7UD/Wr9cvV1GUCAKk3HodPI6+obFn11jqQZOCsfU
         SUQvEC3ulp6ASCkITJFo+ykWwY5afoyNGTKb7olJVaHQQSAblyNr0auBnP22zVI9Lh
         J7i6zlxkREMb25jMbbH+hhmRlktS7R+yMwNzv2/6uwV8SBhphsj0wFQ6r8a6XNCekR
         WRcnV7jYFE0qsYf/MbRsUswDK/PB4R84NcZ6PrcpHSQFSUOKh/EBbmFNDiUmbEeaH4
         EMyqtkAisouy0gZTsvv6v87/jrBkcWRIZpDbn7nZOk9M5GgGRi5lLXlF9V0PVi0087
         dv0cF4V2hlfQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E66A2C41612;
        Mon, 12 Dec 2022 23:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] lib: packing: replace bit_reverse() with bitrev8()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088781794.32014.12837469418338196039.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 23:30:17 +0000
References: <20221210004423.32332-1-koshchanka@gmail.com>
In-Reply-To: <20221210004423.32332-1-koshchanka@gmail.com>
To:     Uladzislau Koshchanka <koshchanka@gmail.com>
Cc:     olteanv@gmail.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 10 Dec 2022 03:44:23 +0300 you wrote:
> Remove bit_reverse() function.  Instead use bitrev8() from linux/bitrev.h +
> bitshift.  Reduces code-repetition.
> 
> Signed-off-by: Uladzislau Koshchanka <koshchanka@gmail.com>
> ---
>  lib/Kconfig   |  1 +
>  lib/packing.c | 16 ++--------------
>  2 files changed, 3 insertions(+), 14 deletions(-)

Here is the summary with links:
  - lib: packing: replace bit_reverse() with bitrev8()
    https://git.kernel.org/netdev/net-next/c/1280d4b76f34

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


