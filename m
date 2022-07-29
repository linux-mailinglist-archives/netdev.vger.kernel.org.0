Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B6A584B29
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbiG2Fac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbiG2FaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:30:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD07DFBB;
        Thu, 28 Jul 2022 22:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95DE861EA0;
        Fri, 29 Jul 2022 05:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E719CC43140;
        Fri, 29 Jul 2022 05:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659072619;
        bh=wDCzmB4eJFbSSvyoCZElKojmCus+4/oANVG54d/8q+M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GBXcqVSRtS+63Su56lQEeCgCwmKhozpT/EwJq/KCn0uAPpe/nB4TCNLiRkTXr6i9i
         yjgR7w8UkpRMH6jLkwxysgi52aZ3Nw/xsw3EjmNpiuYCNmoQ4qTLSTWltEtUXFMsGk
         +ab+JFw5E4ORuXkSPsYs/RVhh81gTggGMBDH6WIEfjUcyQFQ6P7wozQdQVfgRLCAP7
         IPUfupq8ne7RwNLmPpyA00dikc8d/KzZ0vKimnVsYrDZD9liwTFUzSnUIYorqTCaYr
         XuFsQhJ2e73T6UGwvFxUimCsQgd/eIbi7dkNKXE1yCe+iy2aVWxlPpbho85xx4whlu
         IOXW/zeOijvPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CEA08C43146;
        Fri, 29 Jul 2022 05:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] firewire: net: Make use of
 get_unaligned_be48(), put_unaligned_be48()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165907261984.17632.6914991497819890237.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 05:30:19 +0000
References: <20220726144906.5217-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20220726144906.5217-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     kuba@kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        stefanr@s5r6.in-berlin.de, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 26 Jul 2022 17:49:06 +0300 you wrote:
> Since we have a proper endianness converters for BE 48-bit data use
> them.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/firewire/net.c | 14 ++------------
>  include/net/firewire.h |  3 +--
>  2 files changed, 3 insertions(+), 14 deletions(-)

Here is the summary with links:
  - [net-next,v1,1/1] firewire: net: Make use of get_unaligned_be48(), put_unaligned_be48()
    https://git.kernel.org/netdev/net-next/c/29192a170e15

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


