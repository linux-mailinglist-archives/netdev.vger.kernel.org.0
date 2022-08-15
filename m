Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292465927C7
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 04:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiHOCaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 22:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbiHOCaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 22:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27DB216
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 19:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D835B80CEF
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 02:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D376C433D6;
        Mon, 15 Aug 2022 02:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660530614;
        bh=yNGhb15bBN2WNCMIyz8ZsTE4qjeqWgyzqDn+3VqgOL8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O2mNmFT2hI08Tz/vKkoFBA90OeX++MD+LlgiyYOVZ9ZqRt+mhi3PPEjs6Vtl/SBaI
         uAaY+y+eSggkY3NLjsgtZyTg5cFiXIAPnuwcZKJ0tuOyQuPB9pwRowVoulVNgAWmM+
         4CKTPllOI/IEvVeODjL589z2t9Dyprmg8UsBni1ffEf2Sy9EJHMQ9iDzRDF0j6JCcH
         rbqtAqS8ov41nmobdiYcF3M1AnVhtPeVNa00ELR9Tz7GAvZ24PER9yOJ6ZmKNLzcuy
         pxst8TGWli5cvVxA4iAvTdFx/O3v0Frz6D6M4+xmftGkP8wdGM/Nry7yD6zc3SC64/
         RQVhYKhbgmKLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0E747C43142;
        Mon, 15 Aug 2022 02:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] vdpa: fix statistics API mismatch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166053061405.5578.5561668794405395129.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Aug 2022 02:30:14 +0000
References: <20220815022505.13839-1-stephen@networkplumber.org>
In-Reply-To: <20220815022505.13839-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Sun, 14 Aug 2022 19:25:05 -0700 you wrote:
> The final vdpa.h header from upstream has slightly different
> definition of VDPA stats get, causing compilation failure.
> 
> Fixes: 6f97e9c9337b ("vdpa: Add support for reading vdpa device statistics")
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  vdpa/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [iproute2] vdpa: fix statistics API mismatch
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=f3849120887f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


