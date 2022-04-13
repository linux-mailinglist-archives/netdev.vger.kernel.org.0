Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C453C4FF835
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 15:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbiDMNxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 09:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236014AbiDMNwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 09:52:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23782655A
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 06:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51787B824C8
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 13:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10278C385B0;
        Wed, 13 Apr 2022 13:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649857812;
        bh=oSGqgZbAOJHBqkARmsYlZWw5IfkdQaUsg4Df2CweX6A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Og7tvUudDNuanzZnmT16GWi4hPHXxr9UpW7BQWhIsgGNvySaQuYv9k39WR4YMbSI6
         gSjPImnbHmljs/08GXHq9jCZWCEzUInN6l04D5f9XJ0N2dNmcryVf0HVSKQ4uCttqY
         Zcd/nsP6rlJhlfe2Zfx3zT7HZgSq3G1GqEZNOa1hd+fTahKdbOQv4PejlzWyUHxdSj
         8uaP01inuAq0i3aJ0Ly+fTToEm5Kn22USR+EYXNYHmRfp+20RhSde74+oGpR1s/6U/
         Drf/m61xdxPPhLY+tflEDFlAII6FNnlmGq2+hetGel71ielVhIBLAucbKHwfNJ8rN6
         tEN3gcCpit/Jg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E913DE7399B;
        Wed, 13 Apr 2022 13:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: update nfp_X logging definitions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164985781195.18805.6062790620563119331.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 13:50:11 +0000
References: <20220412152600.190317-1-simon.horman@corigine.com>
In-Reply-To: <20220412152600.190317-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, dylan.muller@corigine.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 12 Apr 2022 17:26:00 +0200 you wrote:
> From: Dylan Muller <dylan.muller@corigine.com>
> 
> Previously it was not possible to determine which code path was responsible
> for generating a certain message after a call to the nfp_X messaging
> definitions for cases of duplicate strings. We therefore modify nfp_err,
> nfp_warn, nfp_info, nfp_dbg and nfp_printk to print the corresponding file
> and line number where the nfp_X definition is used.
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: update nfp_X logging definitions
    https://git.kernel.org/netdev/net-next/c/9386ebccfc59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


