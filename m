Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67C46EB04E
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjDURLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDURLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:11:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E252416DC9
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:10:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5100E65230
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 17:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABCE6C433D2;
        Fri, 21 Apr 2023 17:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682097019;
        bh=3z/XSHn1jQ1cFyEKosMGJAasx2TyKZ+OZCW0It26m/I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gYgYT7X6kt6Phh4pGZwBdbzYhsNGR8WBlrRmQjmojdZyPIyu2UoJ282YSgg3Mayo8
         GVHuh0bdzs9GBUODsdjfHdFyVnS0AXNuZuVn3GW789pl/msoNVQwYDyG3H1jTrnYE5
         MbCTicgYDFQeO9lBjazocI5CWOLwj3otYT98KKPg/C4uhIQEZqYb3C07odwKS0487J
         5pr5KjAr8rkHpezwZCqNHJ3o7/iXLA86ohsxH9taa6ph3NoKqNBMILaGrEudmyJPTj
         03pgFvhvaNc/ZkOxgK+gBqxHYEhV1YfXEdtNBETDd4tVKeEXSxa58VXb4x6THjnfD9
         toFw+1qRSUW7A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91193C395EA;
        Fri, 21 Apr 2023 17:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] lwtunnel: fix warning from strncpy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168209701959.22890.1735093423634852695.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 17:10:19 +0000
References: <20230421170339.21247-1-stephen@networkplumber.org>
In-Reply-To: <20230421170339.21247-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
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

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Fri, 21 Apr 2023 10:03:39 -0700 you wrote:
> The code for parsing segments in lwtunnel would trigger a warning
> about strncpy if address sanitizer was enabled. Simpler to just
> use strlcpy() like elsewhere.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  ip/iproute_lwtunnel.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [iproute2] lwtunnel: fix warning from strncpy
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=f666443f4bae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


