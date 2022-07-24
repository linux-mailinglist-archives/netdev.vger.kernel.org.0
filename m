Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD31557F719
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 22:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiGXUuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 16:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiGXUuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 16:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BB160DE;
        Sun, 24 Jul 2022 13:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5FC8611D3;
        Sun, 24 Jul 2022 20:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 093C9C385A2;
        Sun, 24 Jul 2022 20:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658695813;
        bh=uwqI0DRzynEZYN2aj/U+B4YszZoPSiyyzFpWASAhnKc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QCEHPayg58X71OxnrqtbVnIcSYEyv5Q6F9aYUTjrWyhHatyq2ED11dCCUTGreqpao
         6hMVa3DC4xvgE27Rt69sX2g2UqAZl4QIOXzbjOIg9mDWPnYG7new2B8Iy928UhRkkB
         ziaFFqdu+xiOFAhx1BCsbQgutpBPwHwCDUfjpZAT2Up4iRPGqsJOKBEdDQUGOwyG6Z
         YI/4+muJsypHr9a6MFAt2YfAQ5m8StRNuIXw2C0/dBymLArUjrD6RLcM+5etXly9s1
         9sbeEsNXd/AQoWUkp1QIdY1ygVvJDRwkQSn/jfESnADwLwbLoASh0OvDHhxZEoEcuj
         hJ8YapmjmXwXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E3EAAF83697;
        Sun, 24 Jul 2022 20:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net] Documentation: fix sctp_wmem in ip-sysctl.rst
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165869581293.26749.2227624982855509937.git-patchwork-notify@kernel.org>
Date:   Sun, 24 Jul 2022 20:50:12 +0000
References: <eb4af790717c41995cd8bee67686d69e6fbb141d.1658414146.git.lucien.xin@gmail.com>
In-Reply-To: <eb4af790717c41995cd8bee67686d69e6fbb141d.1658414146.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 21 Jul 2022 10:35:46 -0400 you wrote:
> Since commit 1033990ac5b2 ("sctp: implement memory accounting on tx path"),
> SCTP has supported memory accounting on tx path where 'sctp_wmem' is used
> by sk_wmem_schedule(). So we should fix the description for this option in
> ip-sysctl.rst accordingly.
> 
> v1->v2:
>   - Improve the description as Marcelo suggested.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net] Documentation: fix sctp_wmem in ip-sysctl.rst
    https://git.kernel.org/netdev/net/c/aa709da0e032

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


