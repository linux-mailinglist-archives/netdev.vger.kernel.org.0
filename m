Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C78C530598
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 21:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350823AbiEVTuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 15:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350859AbiEVTuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 15:50:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A52F38BEF;
        Sun, 22 May 2022 12:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74745B80D2B;
        Sun, 22 May 2022 19:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9DAAAC3411E;
        Sun, 22 May 2022 19:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653249012;
        bh=N5fNTXeGknJz8Jwza64mAq4Hj7r+bfA9SjFJrLFOfjc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cYLADIIkA7gAE095AXy1MbOkKIXFnUARwBQJ+ylcE/bGLpof5tBzssc0nSTzxtX1P
         lxN90kELXIKhgI+wc+uVtBqr4TgG9460I0JsLKPg0vYJ3zCdXMOX2UMcIakGdT6WCo
         /kMxUGTQ3vad6kebs1wsqGCNajqWF4Ki8ORqY7te9NWbaPXwrmZ2MxNoGFXiacfZKN
         nXsQWuu4IiQE1VSPIvjzT+0nwOhAdxfaXqGC0vOk4y1SZpUEs6EeAtsJRmjnx4doOL
         FjFy3pGCz4tp59o4bP9SISikipaNBGl5YjPIhrH5bc5A73hWObiuUArk197N35I4fq
         PZMut5XzlKu3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7E694F03945;
        Sun, 22 May 2022 19:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qed: fix typos in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165324901251.28407.2375178510820298452.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 19:50:12 +0000
References: <20220521111145.81697-43-Julia.Lawall@inria.fr>
In-Reply-To: <20220521111145.81697-43-Julia.Lawall@inria.fr>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     aelior@marvell.com, kernel-janitors@vger.kernel.org,
        manishc@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Sat, 21 May 2022 13:10:53 +0200 you wrote:
> Spelling mistakes (triple letters) in comments.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  include/linux/qed/qed_fcoe_if.h    |    4 ++--
>  include/linux/qed/qed_iscsi_if.h   |    4 ++--
>  include/linux/qed/qed_nvmetcp_if.h |    2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)

Here is the summary with links:
  - net: qed: fix typos in comments
    https://git.kernel.org/netdev/net-next/c/cc4e7fa549cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


