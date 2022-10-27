Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3422F60FCAE
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 18:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbiJ0QKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 12:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbiJ0QKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 12:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EF0186F8
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 09:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FEF3B824E0
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 16:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BBE99C433D7;
        Thu, 27 Oct 2022 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666887015;
        bh=kcaNfbKRE4/mJdoDivoEhEb5age2K6Kis/Hr79tEUAI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uI8m5BSaxYNI+BvzeNEJaxb/yWAdgh/jqAnU+kvndsQFZfFEzvrYaR3bxQ6JWqrom
         pUbsFweDjOkjLJdMNdBIKMuOSh7lm1encfaGFkabxViCKwhIszHeOXrHDAQfW4HIlO
         jSeqiy4xQeilyzpyu6GMFM/fr6XDCL2VMcouC8vcbVKdsIzInvKJnxHNpnJq/SaFX1
         pet+nVQmRsOvyJuBH36AN9CWJ//wjEiTv8WJqVX9kKx3FhI8OY+zRhj+chiyn75g6v
         +n6iUTTntK5p5jL4LE2g33k5tZBv++9DzpINz7APC2dtohh9/zvkKLBARTcjaB9iWO
         58B8uW8LIYIqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9C92BC4166D;
        Thu, 27 Oct 2022 16:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] genetlink: limit the use of validation workarounds to old
 ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166688701563.13652.7647745678345134859.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 16:10:15 +0000
References: <20221026001524.1892202-1-kuba@kernel.org>
In-Reply-To: <20221026001524.1892202-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com,
        johannes@sipsolutions.net, jiri@nvidia.com
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

On Tue, 25 Oct 2022 17:15:24 -0700 you wrote:
> During review of previous change another thing came up - we should
> limit the use of validation workarounds to old commands.
> Don't list the workarounds one by one, as we're rejecting all existing
> ones. We can deal with the masking in the unlikely event that new flag
> is added.
> 
> Link: https://lore.kernel.org/all/6ba9f727e555fd376623a298d5d305ad408c3d47.camel@sipsolutions.net/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] genetlink: limit the use of validation workarounds to old ops
    https://git.kernel.org/netdev/net/c/ce48ebdd5651

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


