Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776525028B3
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 13:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352630AbiDOLMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 07:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345806AbiDOLMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 07:12:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604F3972AC
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 04:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F02EF6228E
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 11:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61A7BC385A9;
        Fri, 15 Apr 2022 11:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650021011;
        bh=f5522Fbo2dXjfAGlD5q36ttNQxa4AOpp2bPNvk44ymo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tCWvZrdhvWDj0GmOGuSJoJoH3TeuqffCAtoMOvHxaXdZnHLLDxy1EdyHpqX5MJX9Y
         zATFg/5vU/dX4oYdeZNTONFd0hLwHOnUCK9jTPfNBLkGNcyqPjC2InYhOrm/fmEWQ6
         Rk0Qb9dCtUd9N7BxZZVEfTj+KmP8t/q3kMSsr3OmjN8y3lg/ww0+IMesQXT3PSEPAV
         wKnGn7y1GG2A1sgFN3O1VZcVtOc/d5flMC+6ze9j6axeyLTKq6aXQoexV7B2HRFGHX
         1PxOGul5TlvrA3ibePMD3b/WC0j7fN0SC4Lnp05jkb9U1Hy4W52kCNR8KYrEs2fW1u
         8rwql0xGjJBnQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3EAF0EAC096;
        Fri, 15 Apr 2022 11:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] powerpc: Update MAINTAINERS for ibmvnic and VAS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165002101125.2718.18001601253242630733.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 11:10:11 +0000
References: <20220413194515.93139-1-sukadev@linux.ibm.com>
In-Reply-To: <20220413194515.93139-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        drt@linux.ibm.com, brking@linux.ibm.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Apr 2022 12:45:15 -0700 you wrote:
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> ---
>  MAINTAINERS | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - [1/1] powerpc: Update MAINTAINERS for ibmvnic and VAS
    https://git.kernel.org/netdev/net/c/60496069d0ae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


