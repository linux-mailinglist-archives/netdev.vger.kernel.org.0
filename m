Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54A6544B5E
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 14:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245161AbiFIMKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 08:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245164AbiFIMKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 08:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9960B26520D;
        Thu,  9 Jun 2022 05:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2789BB82D53;
        Thu,  9 Jun 2022 12:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3690C341C4;
        Thu,  9 Jun 2022 12:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654776612;
        bh=PwBBBz/dC7cgFr8moGbFG7v4skdx3aTmukVX1l9htzc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FR3+qoKH0jU5DSwFRsaTQE1ge6SqA5GUN785MvKid/Thz3i12gHRQ0eu3WmqFxSyD
         QSKmG2Jhu5+qsRV5iWrTMz8NKtzNENDaaAnAvo5IO/bPPsW4GdGpqHSvlYHKmyBr/i
         vQfeAzs9+WxUrO2gm7+s6xBY2O/qNY5yN4GMBZaNU8/hoRr841q+smeZIIevlI6cTr
         2TOIvgn+V3H//SxBBFT5UPf9Q76ZU6xhiTPyvhukwWDnywvAFlIYtuyqBgFVhxEMjR
         Ax2OV10TWbsJAgiLVradd8N05imn/PzdOwI//bt0CwkDDbutYFq1zBpgeYQfFZChXE
         XRr5Zh14c8w9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9B4AE737F0;
        Thu,  9 Jun 2022 12:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf, docs: Fix typo "BFP_ALU" to "BPF_ALU"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165477661275.11342.4271222664827162362.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 12:10:12 +0000
References: <20220609083937.245749-1-fujimotoksouke0@gmail.com>
In-Reply-To: <20220609083937.245749-1-fujimotoksouke0@gmail.com>
To:     Kosuke Fujimoto <fujimotokosuke0@gmail.com>
Cc:     corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, fujimotoksouke0@gmail.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu,  9 Jun 2022 04:39:37 -0400 you wrote:
> "BFP" should be "BPF"
> 
> Signed-off-by: Kosuke Fujimoto <fujimotokosuke0@gmail.com>
> ---
>  Documentation/bpf/instruction-set.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - bpf, docs: Fix typo "BFP_ALU" to "BPF_ALU"
    https://git.kernel.org/bpf/bpf-next/c/492f99e4190a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


