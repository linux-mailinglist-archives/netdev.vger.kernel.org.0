Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6230B635092
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 07:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235871AbiKWGkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 01:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235794AbiKWGkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 01:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FC7ED708
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 22:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA19A61A98
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47082C433D6;
        Wed, 23 Nov 2022 06:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669185615;
        bh=Nvro9XNHweVqrIPXQwaEFTUQhGsliQgQDhnS8OVD//M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lv6LTEsAKsfDBpbLW/rYgs5F+9UcOUuFBjRTcnNsrsIzCS2+0mAxdOfZsPLwaLwj+
         tsfi6esdrtOn0Lru6YbQl2C8gvM8ftodbFSz3JVA/kzaAjd498MY83fUI/dKoIyxK8
         ACgzlE8r/U96hAhQeA8lcmHCO30AwH2yOTJif+egkFppnEhp2sqqQbFvzxfmeQAVWi
         4DiWbuC9tbDSwtVQr7kQZAbgjdg0jpxs+5HroQyhQ0tCT4LcYX7+2CkTHqlbyUufwQ
         pAcmJV2JaDsWoVT/0o3nnjMnbTLbMLWNswWy08hCKkKfqwpkg9PYwpTCyTuLWCWeE0
         0cdERgSK9FOvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2654AC395ED;
        Wed, 23 Nov 2022 06:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] remove #if 0 code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166918561515.32105.8869876018320846721.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 06:40:15 +0000
References: <20221123030256.63229-1-stephen@networkplumber.org>
In-Reply-To: <20221123030256.63229-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Tue, 22 Nov 2022 19:02:56 -0800 you wrote:
> Let's not keep unused code. The YAGNI means that this dead
> code doesn't work now, and if it did it would have to change.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  ip/ipmroute.c   | 12 +-----------
>  ip/xfrm_state.c | 11 -----------
>  tc/p_icmp.c     | 24 ------------------------
>  tc/q_gred.c     |  3 +--
>  tc/tc_class.c   |  4 ----
>  5 files changed, 2 insertions(+), 52 deletions(-)

Here is the summary with links:
  - [iproute2] remove #if 0 code
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=a04a01a59470

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


