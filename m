Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39F74DA977
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 06:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353561AbiCPFB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 01:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244390AbiCPFB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 01:01:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4911F4D9DF
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 22:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F34AFB81A45
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 05:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EBA0C340EE;
        Wed, 16 Mar 2022 05:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647406810;
        bh=I9tcuBGqDu2rOUAJnwgwEX7d/NQ5JObbdwQXwiS6WEU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RxCdIyGp03mWyiAhm037wXTPZ+oGbgheANjbTAOgihmT9Auakkq/uOZUPpb2iszaJ
         43q20c8z5U5qS6FHT+YW4dY/GLTzLZ+ELGaavBlqlsQzDvOExbSz/hopfxl/eE45dp
         0vVGLDAI7eQRL6hEbb0OMC0gds15+VVZaheEcSOb9bawXyg6rmBGN2z8NTuE2YD0tt
         KrsXoUORsGQhyGxWAYizRNDl/bBgw64MzLqtQ37l6K8F1w8X2T5KMxcz7lRN5kzbVj
         YdATYE2ldHsZWcDRROqau9ZcakGrdv43WcD0cJeQpb8qRltIr4bMV2RL6pHxOOL0s0
         NQ4NZmuHKn88g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D6DDE6D3DD;
        Wed, 16 Mar 2022 05:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: Add l3mdev index to flow struct and avoid oif
 reset for port devices
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164740681044.10029.16814487037983806451.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Mar 2022 05:00:10 +0000
References: <20220314204551.16369-1-dsahern@kernel.org>
In-Reply-To: <20220314204551.16369-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        greearb@candelatech.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 14 Mar 2022 14:45:51 -0600 you wrote:
> The fundamental premise of VRF and l3mdev core code is binding a socket
> to a device (l3mdev or netdev with an L3 domain) to indicate L3 scope.
> Legacy code resets flowi_oif to the l3mdev losing any original port
> device binding. Ben (among others) has demonstrated use cases where the
> original port device binding is important and needs to be retained.
> This patch handles that by adding a new entry to the common flow struct
> that can indicate the l3mdev index for later rule and table matching
> avoiding the need to reset flowi_oif.
> 
> [...]

Here is the summary with links:
  - [net-next] net: Add l3mdev index to flow struct and avoid oif reset for port devices
    https://git.kernel.org/netdev/net-next/c/40867d74c374

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


