Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B08E6CD270
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 09:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjC2HAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 03:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjC2HAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 03:00:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB53213B;
        Wed, 29 Mar 2023 00:00:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03DD5B820BB;
        Wed, 29 Mar 2023 07:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8885EC4339E;
        Wed, 29 Mar 2023 07:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680073226;
        bh=6AclYn/S7r8SWu3KMLT4e+S8wOGCxPEWVdhe45EdI7M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MxcN/pyyzelRYwT61NHSU43OmywKg/WqqCgTvshh0l6J8kJMIGr/sJC19t6IBkePJ
         VoEFRrboRypbMiwkXWwEyIajSlttM1Li8dPtr6gPQ9MQmIkMeXWuz6FaRPPds/F0Xc
         SdUtCyAE832MCiE/HcTKtLzAQuuBPwbzvutgqTQKyZYTL0q7SQovj8JmQtclC7BAUd
         YeUIjZ+ogGRaIxGR7BV3UnzY9Rbay4y5vPJ5xhlZxtP1CW5kcvGxjvwuBloo4vHCzF
         GE9L9mVSqMIK7iWPYyyDESHqZlPNcy1LtepeII7A/f1x3lWKGeTlK/+ceOiP44/IgH
         GCHcAOt8sZ4uQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66B75E55B21;
        Wed, 29 Mar 2023 07:00:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] docs: netdev: clarify the need to sending reverts as
 patches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168007322641.11543.13495744971092435002.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 07:00:26 +0000
References: <20230327172646.2622943-1-kuba@kernel.org>
In-Reply-To: <20230327172646.2622943-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 27 Mar 2023 10:26:46 -0700 you wrote:
> We don't state explicitly that reverts need to be submitted
> as a patch. It occasionally comes up.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: corbet@lwn.net
> CC: linux-doc@vger.kernel.org
> 
> [...]

Here is the summary with links:
  - [net-next] docs: netdev: clarify the need to sending reverts as patches
    https://git.kernel.org/netdev/net-next/c/e70f94c6c75c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


