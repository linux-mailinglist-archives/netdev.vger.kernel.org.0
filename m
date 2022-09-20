Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168805BD915
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiITBKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiITBKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:10:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C279E3DBCA;
        Mon, 19 Sep 2022 18:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7CB562029;
        Tue, 20 Sep 2022 01:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21DB2C43149;
        Tue, 20 Sep 2022 01:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636221;
        bh=34HXl4T49GzuA6i6GvvwF9X9c520F2JQ11y22QqfihY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a3F+u7zgQuFTzdU46JX2Q7YvTGI+bOTd/xx+BhggRpHR2GR5R14QCjwaDvER/YdFb
         4WP2a717Z4nleF8E2i+6LQrgg6mpCo2zFh/poIyHZ18+IHlzOQkINz5FfNX/uA27gC
         8cnmtStfVgt5BdJZakYA6j1lJXy8xe6BViOjg65CaPBvXSLQ0UonhGsM/HdCnxG5/P
         avEU2x6D49w8hq/dqqBJ7h1i6Ga9HfhFnE8AM2e/vC2qX1l7ok8lLhau5YmjHvAXu5
         RpB4MkSl+eEArMnZ+nnrERD6AxY0GF/bmX4C/trRjtZiOdb4BoOqQb+ShaFcIxgZ4l
         A1p9lQaAd3Q6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0EDBAE52538;
        Tue, 20 Sep 2022 01:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ravb: Add R-Car Gen4 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363622105.23429.13997190928850161238.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:10:21 +0000
References: <2ee968890feba777e627d781128b074b2c43cddb.1662718171.git.geert+renesas@glider.be>
In-Reply-To: <2ee968890feba777e627d781128b074b2c43cddb.1662718171.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
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

On Fri,  9 Sep 2022 12:10:11 +0200 you wrote:
> Add support for the Renesas Ethernet AVB (EtherAVB-IF) blocks on R-Car
> Gen4 SoCs (e.g. R-Car V4H) by matching on a family-specific compatible
> value.
> 
> These are treated the same as EtherAVB on R-Car Gen3.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> [...]

Here is the summary with links:
  - net: ravb: Add R-Car Gen4 support
    https://git.kernel.org/netdev/net-next/c/949f252a8594

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


