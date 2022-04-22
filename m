Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E957B50C0F0
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 23:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiDVVJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 17:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiDVVJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 17:09:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E261E33A389
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 13:04:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8128CB8321A
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 20:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48C6BC385A4;
        Fri, 22 Apr 2022 20:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650657612;
        bh=aGS0WKMlMgUmyQf1FbNlHQe/ai0IQmat79E6dUGPU2U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pdb6FSnqosqMUyASwE32Mr57u2D7d9H+LNMLV0WllWLHcFRGWosBljd02EmXpeUxX
         7Ge/cbn1TKweHwu60Vgyj27Op21lQ6r/jJ19K9Gc39nOVj6bbNRLaRxhQKR7a6SOCe
         DLnIn9+/J3VFrwMilw97y1soFnBMhRjPzCtOm6aOh8ksHP70ZH0GsJ+lFrDAWPYHgL
         aZ6B31iR56BoQnow5RtKJRopnBQkaXSPy2x0NrKEJgtvl+GWfw3gL+CDFnqJzCXZiL
         XWlos6y57UhUvBb2WyDpJlrHwOkmJ6a2STNvOUoC7ww/a/l613+Tl8jO9PGIC5tISK
         /fDjxk+UIsW7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 27D59E85D90;
        Fri, 22 Apr 2022 20:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v2] ip-link: put types on man page in alphabetic
 order
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165065761215.15235.14710788649799669202.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 20:00:12 +0000
References: <20220420031115.26270-1-stephen@networkplumber.org>
In-Reply-To: <20220420031115.26270-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 19 Apr 2022 20:11:15 -0700 you wrote:
> Lets try and keep man pages using alpha order, it looks like
> it started that way then drifted.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  man/man8/ip-link.8.in | 175 +++++++++++++++++++++---------------------
>  1 file changed, 89 insertions(+), 86 deletions(-)

Here is the summary with links:
  - [iproute2-next,v2] ip-link: put types on man page in alphabetic order
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=f6559beaf7ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


