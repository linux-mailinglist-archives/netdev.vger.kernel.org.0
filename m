Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564A364CDB8
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238769AbiLNQKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238137AbiLNQKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EC563DB
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BDBF61B2F
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 16:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F09BFC433D2;
        Wed, 14 Dec 2022 16:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671034217;
        bh=vuF+G6t0ntLsFP5ImghdSG74YVnxSA50e/YZMOREfX4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cn0uTw0fFGXpKYB3KK+/1iM+tyvJzrGHwZlo1RrX0kUbDzwTocrRa5DX6c1WMKbem
         8M6B+5/dAPYmMJp1PIpHuIT1f/4l6PAJuUGhRSQpQzd13gStcTC5w1cXDR9zuoEjFR
         mfu/W1FhqmJr4RzQyls+GLkL/0dCa3V/DkecltZ9ZJlCKxjvVGJzlAnY7xJB3d9jm+
         kRbzpOXKG+R7U8bnYpopnTgeQWiooum+AU+LX46llMEC9ajhXsFQM544Z9BO0dxJ70
         L+Tsvvpqsg0FPxyPjpmB2EDA/doDOBfkPUUFS6WaR52dEcqNINkVQlEtO+Ik39TVZP
         wacR6MtAJXfng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CECDAE29F4D;
        Wed, 14 Dec 2022 16:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v1 0/4] Add new IPsec offload type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167103421684.12353.4505073967964991619.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Dec 2022 16:10:16 +0000
References: <cover.1670830561.git.leonro@nvidia.com>
In-Reply-To: <cover.1670830561.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     steffen.klassert@secunet.com, dsahern@gmail.com, leonro@nvidia.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        raeds@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Mon, 12 Dec 2022 09:54:02 +0200 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Extend ip tool to support new IPsec offload mode.
> Followup of the recently accepted series to netdev.
> https://lore.kernel.org/r/20221209093310.4018731-1-steffen.klassert@secunet.com
> --------------------------------------------------------------------------------
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v1,1/4] Update XFRM kernel header
    (no matching commit)
  - [iproute2-next,v1,2/4] xfrm: prepare state offload logic to set mode
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=bdd19b1edec4
  - [iproute2-next,v1,3/4] xfrm: add packet offload mode to xfrm state
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=a6e740ff406c
  - [iproute2-next,v1,4/4] xfrm: add an interface to offload policy
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=3422c62d581d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


