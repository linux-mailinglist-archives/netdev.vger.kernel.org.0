Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A3864AB34
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbiLLXK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233737AbiLLXKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381BD645E;
        Mon, 12 Dec 2022 15:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E57F7B80EF1;
        Mon, 12 Dec 2022 23:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A06D8C433F0;
        Mon, 12 Dec 2022 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670886616;
        bh=KYA9QvMvCCQe3+hISQ+W+fe+/cBb5NYHLvVMSYxITjM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=drZ+mlU9LbLyusTWwJOjo4olWkq3udHf96bZcx2aWwtadRq73rwKtAu+VuANMlOT3
         4RrHBbGq+2NjMLKYjJOcd59vW3ky7AkjyF3sfciL1WJwSqaFNk9XpUi8X8itEbPXch
         xwgfzay7iGeOgzz2Ou1HgubmRsFkNjWVQO6fdEYJ6RAoFkULWK8v9M0j6dIcfaAUVp
         iV4iBPkVBGVCScvTle+37H5mnqLB6i8F7/BEJXA5/mwa47CyR+uZ4VYWLiJLZ8XCWo
         yCd5GyNdRaeEEHS+qtqoFMo06M1k7U7yygTOqysTBcRDlU0hTZum7aWaaAxjVRQcKQ
         ThdKaXIbvTuwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8598DC41612;
        Mon, 12 Dec 2022 23:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: hellcreek: Sync DSA
 maintainers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088661654.21170.13721326754554337713.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 23:10:16 +0000
References: <20221212081546.6916-1-kurt@linutronix.de>
In-Reply-To: <20221212081546.6916-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vivien.didelot@gmail.com,
        colin.foster@in-advantage.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Dec 2022 09:15:46 +0100 you wrote:
> The current DSA maintainers are Florian Fainelli, Andrew Lunn and Vladimir
> Oltean. Update the hellcreek binding accordingly.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  .../devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml       | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] dt-bindings: net: dsa: hellcreek: Sync DSA maintainers
    https://git.kernel.org/netdev/net-next/c/93e637a37b28

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


