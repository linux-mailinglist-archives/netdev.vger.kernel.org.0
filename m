Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820634F093D
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 14:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357237AbiDCMMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 08:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357232AbiDCMMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 08:12:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AB1286C8
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 05:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B7A4B80D27
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 12:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C743AC340F0;
        Sun,  3 Apr 2022 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648987810;
        bh=WF3PAGojbpjAuPjv2wHAVtN4iM4Wil8ygnMIO2HCM2k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BZq2yBxxQlW/81WD4MzhaTwC9m85JyJq5xRaEbg81u1TO2ydzrPUvzD7+K9YhZLxL
         cdqdmzDnW+RofD9yzq+DBRc9lE1sFxRk3fxzfVnFV0D/HZCU4rJGc3hSWj1XMhtkF+
         OT3QJ7GwtUF1u8ADqIczhwIy87uA5Dp85xKYmp2D2PsG4N2mlzenYADwizqk5aKLA1
         QxP+3o+vmAiXOJ0hWHTcJJqW9rRwpHYgKCc9Z3L/7R6gJFVv3kMnJAg5XkS+FTb5FD
         3sBfqIMqfCgKh4j2Bh4BP98n6snjlf799U+ej51hsp6rQsGn4IyFEpp/wvhq4SpoXa
         4zaoRncTykmsA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A43F3F03839;
        Sun,  3 Apr 2022 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: net: fix nexthop warning cleanup double ip
 typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164898781066.6266.12433533234359992703.git-patchwork-notify@kernel.org>
Date:   Sun, 03 Apr 2022 12:10:10 +0000
References: <20220401155427.3238004-1-razor@blackwall.org>
In-Reply-To: <20220401155427.3238004-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, kuba@kernel.org,
        davem@davemloft.net
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

On Fri,  1 Apr 2022 18:54:27 +0300 you wrote:
> I made a stupid typo when adding the nexthop route warning selftest and
> added both $IP and ip after it (double ip) on the cleanup path. The
> error doesn't show up when running the test, but obviously it doesn't
> cleanup properly after it.
> 
> Fixes: 392baa339c6a ("selftests: net: add delete nexthop route warning test")
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> 
> [...]

Here is the summary with links:
  - [net] selftests: net: fix nexthop warning cleanup double ip typo
    https://git.kernel.org/netdev/net/c/692930cc4350

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


