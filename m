Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900B66D070A
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbjC3NkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjC3NkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5698A5B;
        Thu, 30 Mar 2023 06:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 844B16208A;
        Thu, 30 Mar 2023 13:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0948C433EF;
        Thu, 30 Mar 2023 13:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680183617;
        bh=GRppcmNkqQfKrMjETx+93B3BFnC+3fz229CX6H31eJg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S5E5Cn/1hrz170DbGodNg48ZncPKgi5Q8zOEyS2cRucKoqtceb6v8g8qk68yWt4cv
         n6eJMECW5Fzg6QsUH25QKXkKqZs6w/Ok1enfa8VPbwa9dQ8bSm1MFDUJozYOlV3sfe
         QnzoVQcylCcttwgJe3o1jHF4Xvh2W5/Om00WDhbUsUXFiSC/6j3qadtAxlTzFmJubi
         OICmREr5yNnqHgimmfCzIQoeImYvL1yrE4G5Sz51/yWnHJaLAxpo7WXeb+T5q7SDpM
         OALi/bXCVUDFM7EKH7w/xkrMfteLN1LCv99xSEdArLgvxVUv/M1/NJdf9iNGDLSbTB
         I7zeLDjKSkFOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B29CDE2A037;
        Thu, 30 Mar 2023 13:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] smsc911x: remove superfluous variable init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168018361772.4908.16470300581984281615.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 13:40:17 +0000
References: <20230329064414.25028-1-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230329064414.25028-1-wsa+renesas@sang-engineering.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        geert+renesas@glider.be, steve.glendinning@shawell.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 29 Mar 2023 08:44:14 +0200 you wrote:
> phydev is assigned a value right away, no need to initialize it.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> 
> Changes since v1:
> * rebased to net-next as of today
> * added Geert's tag (thanks!)
> 
> [...]

Here is the summary with links:
  - [net-next,v2] smsc911x: remove superfluous variable init
    https://git.kernel.org/netdev/net-next/c/da617cd8d906

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


