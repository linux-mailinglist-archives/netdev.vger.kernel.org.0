Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724D95EB042
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiIZSlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiIZSl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:41:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFBA357F6;
        Mon, 26 Sep 2022 11:40:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B05CA61236;
        Mon, 26 Sep 2022 18:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C0CCC43142;
        Mon, 26 Sep 2022 18:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664217616;
        bh=HcPJFpL/M1ZGby70MyF+4H1pa7B2wwargZhXC5X3umc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=satmSBg/pzKe1bqzGKCUnd7A30Px5JXNcKhbFVC7wZZ357zcUKFRM3y5eCJSlDvi4
         KWJuiCQxkigSa5XN5DpvAfHqDMQ6K9/mUwLrhQFlyQVoi28oo0M65A3N+nEBmpQX6I
         gJvb6i9uyVlfSTVlFQ1TK4FjJGbGI241zA6yLFFgM4ZbHyn9JzxVvj46AqBmN7+Z/6
         ufM7pSzkpnzgkLcX85oRnzDoiWsAIiI56OTIAbyeOh7gLcLJDKJVsBzn/RhCn5b9Su
         UFsoFBz+grOnSiVGSZCEYt4WfF2LLYxOkw4dJamKsPdPyhMGPTen8EaKty9PRpvb6L
         UMgjJGCOIo/cw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2573C070C8;
        Mon, 26 Sep 2022 18:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 1/2] dt-bindings: net: rockchip-dwmac: add rv1126
 compatible
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166421761598.17810.9168180824427436208.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 18:40:15 +0000
References: <20220920140944.2535-1-anand@edgeble.ai>
In-Reply-To: <20220920140944.2535-1-anand@edgeble.ai>
To:     Anand Moon <anand@edgeble.ai>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, heiko@sntech.de,
        david.wu@rock-chips.com, linux-rockchip@lists.infradead.org,
        krzysztof.kozlowski@linaro.org, jagan@edgeble.ai,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 20 Sep 2022 14:09:40 +0000 you wrote:
> Add compatible string for RV1126 gmac, and constrain it to
> be compatible with Synopsys dwmac 4.20a.
> 
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Jagan Teki <jagan@edgeble.ai>
> Signed-off-by: Anand Moon <anand@edgeble.ai>
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] dt-bindings: net: rockchip-dwmac: add rv1126 compatible
    https://git.kernel.org/netdev/net-next/c/b36fe2f43662
  - [net-next,v3,2/2] net: ethernet: stmicro: stmmac: dwmac-rk: Add rv1126 support
    https://git.kernel.org/netdev/net-next/c/c931b060f093

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


