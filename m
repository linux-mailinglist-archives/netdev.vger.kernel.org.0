Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6596D7254
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 04:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236202AbjDECUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 22:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjDECUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 22:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BD826AD
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 19:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2481B639E1
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 768F5C4339B;
        Wed,  5 Apr 2023 02:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680661217;
        bh=gqOndga763yYerrUEQ7PIJu4N6bIU2gny+zjHRYmeNc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bbqQCrlBKKKTOony1RXQuC002uxQF/Si5aM/knYkxCpFzhjWqLBrEhKr3hArQRXDK
         6jDdVGS8Tz+IWpcElPTJKhnaDQ1URIasSi2EWhKRUsapTyoOSTiZVOdMshZrJPzorf
         ka8XBcP+VDvGMkI6Hk/4RCu/woCIQj+iw8oUftvt0lcwKsnoyl0EcVn+8sOfhrYAXc
         rqR5/7qiCKA8FO1wpfNre9NcTOx5E5he51amKoaeZ5fBbOlok8e+iJ9dqo+o9terdT
         aEP7mk6tIIp6FKaxH8xhYxs9Ckt3LKGFafxD7w2a+i9dLtO93eC1brhsgK+B4jQaQP
         33DYiFcUdXfCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B601C395C5;
        Wed,  5 Apr 2023 02:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] ip-xfrm: accept "allow" as action in ip xfrm policy
 setdefault
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168066121737.20148.661337088295698202.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Apr 2023 02:20:17 +0000
References: <dc8c3fcd81a212e47547ae59ee6857ce25048ddd.1680268153.git.sd@queasysnail.net>
In-Reply-To: <dc8c3fcd81a212e47547ae59ee6857ce25048ddd.1680268153.git.sd@queasysnail.net>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, nicolas.dichtel@6wind.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Fri, 31 Mar 2023 15:18:25 +0200 you wrote:
> The help text claims that setdefault takes ACTION values, ie block |
> allow. In reality, xfrm_str_to_policy takes block | accept.
> 
> We could also fix that by changing the help text/manpage, but then
> it'd be frustrating to have multiple ACTION with similar values used
> in different subcommands.
> 
> [...]

Here is the summary with links:
  - [iproute2] ip-xfrm: accept "allow" as action in ip xfrm policy setdefault
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=009739adb92c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


