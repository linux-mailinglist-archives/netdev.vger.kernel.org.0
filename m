Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E8560C19A
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 04:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiJYCUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 22:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiJYCUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 22:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9551A1CFF6
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 19:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77B8D61705
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 02:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB4DDC433B5;
        Tue, 25 Oct 2022 02:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666664415;
        bh=vgFxY4qHkJR9JhH/NflfauK21Lag8e2UwQ8Ou+OHZ6E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=up33ZruXQ1T/9EPmgSuMW7XnhKPCfbQlK/4uHdKeqnXr0XbNU+aNbkLZREROSEwLk
         78aJV0FwQWlJsh1Ey5kAgeLeRybi09iKXn4KaTVS+OnYP48+LP8SkBbb8Q2QgxwwOE
         R56aLOVyo6eM6rlBPRE66WV9NRFd8t7j71ambU+spRzNvNyWiSdSwB+UqUZ7CRGRJY
         +GIAa9LJcI2ekHhpgcKjv04w9alTelGO5+cR676189fbaLYFqY/7dpufVT6SBarh3f
         cDx8j02PQZcpskrjU4+yTJvPDwKfCV3qKueg5tvL5lsUsTZZO3UGhX3Xa1uO1XYbLw
         S5mupklvufScA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AE4C3E29F32;
        Tue, 25 Oct 2022 02:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] genetlink: piggy back on resv_op to default to a reject
 policy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166666441571.15570.13995760382513953418.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Oct 2022 02:20:15 +0000
References: <20221021193532.1511293-1-kuba@kernel.org>
In-Reply-To: <20221021193532.1511293-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, johannes@sipsolutions.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de, jiri@nvidia.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 21 Oct 2022 12:35:32 -0700 you wrote:
> To keep backward compatibility we used to leave attribute parsing
> to the family if no policy is specified. This becomes tedious as
> we move to more strict validation. Families must define reject all
> policies if they don't want any attributes accepted.
> 
> Piggy back on the resv_start_op field as the switchover point.
> AFAICT only ethtool has added new commands since the resv_start_op
> was defined, and it has per-op policies so this should be a no-op.
> 
> [...]

Here is the summary with links:
  - [net] genetlink: piggy back on resv_op to default to a reject policy
    https://git.kernel.org/netdev/net/c/4fa86555d1cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


