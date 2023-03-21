Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63576C287B
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 04:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjCUDKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 23:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCUDKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 23:10:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29F324CAC;
        Mon, 20 Mar 2023 20:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EA79B811CF;
        Tue, 21 Mar 2023 03:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D932AC433EF;
        Tue, 21 Mar 2023 03:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679368217;
        bh=5II7b+BkVoa4QOA60BgChtOdWYA0PzzTAZsvlZtgtLw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GdrpCZCIC8A4OKRXMMTtaTDf3wHFP8iv4In0FTOpLiX8avN+ToWtsJxMLxhF87Y4V
         QEB2xOeZQlenGJ97WqeaSvioVLljgnMI03y0Jj0ORJDER1mWLGMNpRpxSpPMNfjrT4
         2TynwHJbpEX/AKMozC/d2kDAiZ1YNIdY+/ZlgfqEOOC0XJZmMpbV+pmTLk2P904jfp
         szSo6CEJbTXmFifsO/JIQWFgtLJGrJRijiLcD7VWYgOC/ghZQWxm2BgZilmccD+DdA
         66dsoFaIdyQRdjofw2vUSQVwi2ElUPRanYXfHs3SlmoNDXpRsCfgC1+w7o18YqXmx4
         sIyTTr7F1e7Kg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BC675E68D22;
        Tue, 21 Mar 2023 03:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: cxgb3: remove unused fl_to_qset function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167936821776.24814.6478937204704825271.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Mar 2023 03:10:17 +0000
References: <20230319172433.1708161-1-trix@redhat.com>
In-Reply-To: <20230319172433.1708161-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     rajur@chelsio.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 19 Mar 2023 13:24:33 -0400 you wrote:
> clang with W=1 reports
> drivers/net/ethernet/chelsio/cxgb3/sge.c:169:32: error: unused function
>   'fl_to_qset' [-Werror,-Wunused-function]
> static inline struct sge_qset *fl_to_qset(const struct sge_fl *q, int qidx)
>                                ^
> This function is not used, so remove it.
> 
> [...]

Here is the summary with links:
  - net: cxgb3: remove unused fl_to_qset function
    https://git.kernel.org/netdev/net-next/c/a08df15eab0c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


