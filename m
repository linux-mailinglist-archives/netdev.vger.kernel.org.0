Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89C55A0BAF
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236765AbiHYIkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238304AbiHYIkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:40:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1008A1E1
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A2FFB8279E
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 08:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24B82C433D6;
        Thu, 25 Aug 2022 08:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661416814;
        bh=Fch14+xedvzrClnjYalDfOFQUmXmA36kD1F6iRMrCuQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mxSMLQ4265R0r6S5+6X/TfKAriuXJr37IzYYSAzfdCCkPPGE720G4tUZuVtsDA6MZ
         dGZQLdlZsjJJ6YBOCqiY0F5J2Btafzs15f22b67jJz+EBfdsIgoeicOL08Ve9wDgcs
         I5oMaJOMaCWNrFE8CbuFPnn/WoRy9P8fjaoE5nPolwmp3prKN/9dTzKlEn+pj0BUCI
         c7jO3dDzAxg7/CkPAjev+UVTyRPn9KKIbLdSl1eDwX5AeVIG3WCG3k/OleL5xKRWph
         BeHkrP+05lSaEctLoSbEK1QUh3nY14PRdaAxpuCnhcirzJRp7kfkR7T+5wawN9IyUa
         QouTcNw+gKVgg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F31E2E2A03C;
        Thu, 25 Aug 2022 08:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] net: gro: skb_gro_header helper function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166141681399.8929.6193115207084669995.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 08:40:13 +0000
References: <20220823071034.GA56142@debian>
In-Reply-To: <20220823071034.GA56142@debian>
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        xeb@mail.ru, roopa@nvidia.com, eng.alaamohamedsoliman.am@gmail.com,
        bigeasy@linutronix.de, heikki.krogerus@linux.intel.com,
        gregkh@linuxfoundation.org, iwienand@redhat.com,
        netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 23 Aug 2022 09:10:49 +0200 you wrote:
> Introduce a simple helper function to replace a common pattern.
> When accessing the GRO header, we fetch the pointer from frag0,
> then test its validity and fetch it from the skb when necessary.
> 
> This leads to the pattern
> skb_gro_header_fast -> skb_gro_header_hard -> skb_gro_header_slow
> recurring many times throughout GRO code.
> 
> [...]

Here is the summary with links:
  - [V2] net: gro: skb_gro_header helper function
    https://git.kernel.org/netdev/net-next/c/35ffb6654729

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


