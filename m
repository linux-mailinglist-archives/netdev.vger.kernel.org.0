Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE6C54C388
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 10:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbiFOIai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 04:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245032AbiFOIaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 04:30:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BE2483AE;
        Wed, 15 Jun 2022 01:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25FD9B81D01;
        Wed, 15 Jun 2022 08:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4059C34115;
        Wed, 15 Jun 2022 08:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655281813;
        bh=VarZDe74tJMa0gsjZ1yjdjB3qf69EUu2gu/+DbmOY/g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LRJfcLbtvfXGMf9gF1TC10SGZjbdnVfoQsgfr5ME+4LqWzVbw+15PJwhqs5ldt7Xj
         DBZf3EpZhl4CjgA4xmGTGdAyQgSKlzxjEloMMZhW4xzXshMUz9PiQgZC042E/KRJ/W
         fY9qwo/wWqiBi/b1w7cgRxjjzEV3+PMOp+wFcTuKAdO7f13/83I0CnK567F5FLWbQ5
         /0yAUQfCzlkb9JhKYSSuRUI82yMv2wSkgtl8YSZlXC6z32tuxp3WBvO/TErfe8DOko
         UUqemnDto9zV4WNh+a/DypBWmFlpfL/RByGMTCDHBIo+R93GHm38QOl66CvhJXfugu
         +6IvShYbIt8sA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA63EE6D466;
        Wed, 15 Jun 2022 08:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] dt-bindings: net: xilinx: document xilinx
 emaclite driver binding
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165528181375.16320.16353044588211056289.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 08:30:13 +0000
References: <1654793615-21290-1-git-send-email-radhey.shyam.pandey@amd.com>
In-Reply-To: <1654793615-21290-1-git-send-email-radhey.shyam.pandey@amd.com>
To:     Pandey@ci.codeaurora.org,
        Radhey Shyam <radhey.shyam.pandey@amd.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, harini.katakam@amd.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, git@amd.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 9 Jun 2022 22:23:35 +0530 you wrote:
> Add basic description for the xilinx emaclite driver DT bindings.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
> ---
> Changes since v1:
> - Move ethernet-controller.yaml reference after maintainers.
> - Drop interrupt second cell in example node.
> - Set local-mac-address to all 0s in example node.
> - Put the reg after compatible in DTS code.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] dt-bindings: net: xilinx: document xilinx emaclite driver binding
    https://git.kernel.org/netdev/net-next/c/3a51e969fa90

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


