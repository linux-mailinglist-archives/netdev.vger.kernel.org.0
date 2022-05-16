Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C714A528CC8
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238619AbiEPSUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiEPSUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:20:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E355BF59
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FB67613EF
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 18:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A0A6C34100;
        Mon, 16 May 2022 18:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652725212;
        bh=MTSbfkLDRHB/pA73mES9iJs7ArtqDquy8elePESw/iE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oeo1Q1ca9qGmOmg6UWookDwq0OJtpQfe/sPaaDRGsF5pKl8m7Z3BI+qIL54VzLqms
         zrwtJ31YY4iWLoH2GSVnNWrq4K+6JDUsOiz/CMMaAzN/+/IWforJnaiyA+BIo5qMP/
         hVe7GeO9ztaeC3jHpBLj0eB2GEt+9iaq3R7yF5493nDxGlHYzSHGr4L2zA4JAVP+LF
         eb1AzaU/2jJRziDRB+O0wUadxW9OIReJbMslTrqG+ApdlR6Nr5F8ukSCpbL/Icm01f
         ws9F9RTwy2CXPN5st+XjhAeX6XNEe4xx7h6CR9CYzzbE3kJAF2m35qjw7xLGKBNtpd
         NTh/DpUSVNhuw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76247F03939;
        Mon, 16 May 2022 18:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] iplink: remove GSO_MAX_SIZE definition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165272521248.7536.2682282020920950973.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 18:20:12 +0000
References: <20220516153457.3086137-1-eric.dumazet@gmail.com>
In-Reply-To: <20220516153457.3086137-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, edumazet@google.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Mon, 16 May 2022 08:34:57 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> David removed the check using GSO_MAX_SIZE
> in commit f1d18e2e6ec5 ("Update kernel headers").
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [iproute2] iplink: remove GSO_MAX_SIZE definition
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=6b6979b9d443

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


