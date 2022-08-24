Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85DF59F07A
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 03:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiHXBAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 21:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiHXBAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 21:00:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CA086C1B;
        Tue, 23 Aug 2022 18:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1959B821EE;
        Wed, 24 Aug 2022 01:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85582C433B5;
        Wed, 24 Aug 2022 01:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661302819;
        bh=iC7SqXVQna9QrJAWzAIe2I/XMSK3Ja0zWs7o9ZaS4/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aW8el5bsNLrYZj98x/spqVUT2AH+7Fx/q6s8PWcqAiGazhWgZcD/Dxd3GYgHUuMWt
         D7bu+2//WXPqa75xZccMVxVvzolztvKB5X7ELtBwClK4PrkZK3Erk+S7JkJwZeQI/U
         XF7V5yMJ7SwiFhV8taDG2HtXyvitPkaO2SjyLLtxmTkaIm+xYMagcRBWpXJNmCVYoF
         xY8hlyCCuCaHSVJAQtvi5baKCMk8WZihWNQomTt9+Suj2nCP3K6m05Z9A4czxc4vAg
         lizI0y2F4od/zjHO8wJ+h7p5s4KshVQVhSBOlJ7Dfn949bovFJacZwJsYxY0TiWIi9
         aD5LcINiyB0FA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5C386E2A042;
        Wed, 24 Aug 2022 01:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] ice: xsk: reduced queue count fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166130281936.24197.6741245384320101402.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 01:00:19 +0000
References: <20220822163257.2382487-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220822163257.2382487-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 22 Aug 2022 09:32:55 -0700 you wrote:
> Maciej Fijalkowski says:
> 
> this small series is supposed to fix the issues around AF_XDP usage with
> reduced queue count on interface. Due to the XDP rings setup, some
> configurations can result in sockets not seeing traffic flowing. More
> about this in description of patch 2.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ice: xsk: prohibit usage of non-balanced queue id
    https://git.kernel.org/netdev/net/c/5a42f112d367
  - [net,2/2] ice: xsk: use Rx ring's XDP ring when picking NAPI context
    https://git.kernel.org/netdev/net/c/9ead7e74bfd6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


