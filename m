Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07BB47FE1D
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 16:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237314AbhL0PKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 10:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhL0PKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 10:10:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46163C06173E;
        Mon, 27 Dec 2021 07:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AA4861092;
        Mon, 27 Dec 2021 15:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D40C9C36AEB;
        Mon, 27 Dec 2021 15:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640617809;
        bh=U/HFy+Z7Oq960fR6lFgXfqmxrCAIDCB36niYBt7QSWY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hhr7NHnNaOFW+YCWj49wkgXQWUwXRgyvByFwBzibYbouga35hPDgrTgsTgr3BvYjt
         sCyiEZDsPehZWaqp1ANFkWqHujhmJY22xp/+XTai4ido9o1GC5ojjusLhHCruFoftq
         aqhWm3pny+wXehstx++vHZi62ts4jePMo5H38/fzZ5CF/9n2idl0pDOwK9Bsza9DIX
         lF7uYkaFKnRYE/wM3JGsS+5sM3wjHXHAAeonf6K7E+u7QC/57iAKliy46QpB/snATJ
         wRKuxudkb4JgXdnk8e8ML6BuIDtHObMGqzMkbISK5SUCw4Yy/KzFS5Sm6fJMjJ00e6
         CoejTaD59CvoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA0A9C395DE;
        Mon, 27 Dec 2021 15:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: uapi: use kernel size_t to fix user-space builds
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164061780975.2692.5490009815113965560.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Dec 2021 15:10:09 +0000
References: <20211226120347.77602-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211226120347.77602-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv@altlinux.org, arnd@arndb.de,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 26 Dec 2021 13:03:47 +0100 you wrote:
> Fix user-space builds if it includes /usr/include/linux/nfc.h before
> some of other headers:
> 
>   /usr/include/linux/nfc.h:281:9: error: unknown type name ‘size_t’
>     281 |         size_t service_name_len;
>         |         ^~~~~~
> 
> [...]

Here is the summary with links:
  - nfc: uapi: use kernel size_t to fix user-space builds
    https://git.kernel.org/netdev/net/c/79b69a83705e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


