Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27F8556FEE
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 03:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237920AbiFWBaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 21:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237880AbiFWBaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 21:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEBC4339E;
        Wed, 22 Jun 2022 18:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F14DFB81E82;
        Thu, 23 Jun 2022 01:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD3DAC3411B;
        Thu, 23 Jun 2022 01:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655947813;
        bh=EHKcw3CV9Z4hdOWq52eIVI9XCxk3qIlOlXsr1ft1M0I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ttSx9F1oXYqhmVBJbn/FXgbk5wZd8C5RJmZqANf9xIxEYffEdtpmY1RgD9+/liT5i
         tgfNeKK3J4BPUO1/YJhXWDbOypy7wgUCboxs2VWPNXQyfapjFn1kc+008Kk+lpjb+4
         lxw0J4rt+af7/p1TroAz1yvhqxWe+xmrnvAsgloK/Gpkd7+38OwREqVXaOuVA7coyU
         nPd3KZflFe/RkYFJzcZ24Dtt8/pUbt6RFyjCa1MXR91kqGQOcUa+WKL2kDX3A0Htq0
         RGibtQZxcvYxNmdp3hE72z0zjmlYKQs5j+S6v0FcyJqvD7J4WPOJbTVkYdkzOvrhEC
         FyrrlD3MKtekA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F783E7BB9B;
        Thu, 23 Jun 2022 01:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cxgb4vf: remove unexpected word "the"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165594781358.21755.11075562583865337616.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 01:30:13 +0000
References: <20220621084537.58402-1-jiangjian@cdjrlc.com>
In-Reply-To: <20220621084537.58402-1-jiangjian@cdjrlc.com>
To:     Jiang Jian <jiangjian@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rajur@chelsio.com, netdev@vger.kernel.org,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Jun 2022 16:45:37 +0800 you wrote:
> there is an unexpected word "the" in the comments that need to be removed
> 
> Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - cxgb4vf: remove unexpected word "the"
    https://git.kernel.org/netdev/net-next/c/f0d2ef7f92dc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


