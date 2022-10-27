Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D040960EE9E
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbiJ0DbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234349AbiJ0Dan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:30:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE90C3134D;
        Wed, 26 Oct 2022 20:30:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 808B9B824D5;
        Thu, 27 Oct 2022 03:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2EC78C43142;
        Thu, 27 Oct 2022 03:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666841424;
        bh=5yZglqEjI6DLEgMYAuvs13qPfyxCKHtDpp7LbGv3GXg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HIJZKjHGzmA+/ht6xo/dM8xg3ma8fsifhPvZXaJcAYzaw9XV3bXT9WPmJCQ8hnWD5
         Cp1RZMHhp59NRdOL8DFxSMXEYM+MzW6tz6n/09JVUcX3wgaclRxcRZNyZPt8k+xnU2
         pITsKgV+QGJycIFgg0wY2sgq6sSyE2Qg1pqqWQAqBPeSjXnAA+9kSeOCZs6ipGV9s5
         ftR+xgLIGsShcNRUSgEWeFMY7nTLXclEejqY81hRa9OuzUc3kWADfle+wnUbSORRIV
         +LXQ0l1bEjNrssWt8/ORJwXQjB7DinB7CWrsXjeVjpxVEblglh13Jwgk0Ed/SIXkOG
         yWaQyMkcL4tVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC99AE45192;
        Thu, 27 Oct 2022 03:30:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: fec: limit register access on i.MX6UL
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166684142389.32384.14074247744155373970.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 03:30:23 +0000
References: <20221024080552.21004-1-jbe@pengutronix.de>
In-Reply-To: <20221024080552.21004-1-jbe@pengutronix.de>
To:     Juergen Borleis <jbe@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
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

On Mon, 24 Oct 2022 10:05:52 +0200 you wrote:
> Using 'ethtool -d […]' on an i.MX6UL leads to a kernel crash:
> 
>    Unhandled fault: external abort on non-linefetch (0x1008) at […]
> 
> due to this SoC has less registers in its FEC implementation compared to other
> i.MX6 variants. Thus, a run-time decision is required to avoid access to
> non-existing registers.
> 
> [...]

Here is the summary with links:
  - [v2] net: fec: limit register access on i.MX6UL
    https://git.kernel.org/netdev/net/c/0a8b43b12dd7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


