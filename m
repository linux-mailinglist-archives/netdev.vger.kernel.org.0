Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68FB5E60CA
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 13:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiIVLUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 07:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiIVLUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 07:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EBD9F1BD;
        Thu, 22 Sep 2022 04:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 617C962C73;
        Thu, 22 Sep 2022 11:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B03A7C433D7;
        Thu, 22 Sep 2022 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663845615;
        bh=S0lOzd5z3YYkGNKH0uj+1mzkxSWESqxuMclPeY2j8DY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PS58UtFIGYd4hujWKeKwAhQra7BsJGM1BkU/TV1qYixVWV8SfHetSZOEjLWSehz5L
         UNUr4+4q2D1lKBaqmron8trTKqUCfXiFM9GvpttvCP63oHPKJMNBngExVam9sl5MZE
         rym0ED3xwIM1924L3K0Qt45EeJKKb/YwUF/nk52eY2dp/8F2oU/Nb6KyiqwfvSvCBu
         5jDbi1OF043VwcDY1XtYzbLg7MuXjYYd+bGx55Z1Pz/UEhbuWe7nNDUMNk2fJjYhWV
         tYd0L2GEOfMQd13gXusMfgHanVe3zt5w0/qn1dUiatNqKJFoFSZWX19x7cs0+Xf0kV
         SPAvLHDS/DiLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B7F2E21ED1;
        Thu, 22 Sep 2022 11:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] Separate SMC parameter settings from TCP
 sysctls
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166384561563.30593.9422265694634089959.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 11:20:15 +0000
References: <1663667542-119851-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1663667542-119851-1-git-send-email-guwen@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 20 Sep 2022 17:52:20 +0800 you wrote:
> SMC shares some sysctls with TCP, but considering the difference
> between these two protocols, it may not be very suitable for SMC
> to reuse TCP parameter settings in some cases, such as keepalive
> time or buffer size.
> 
> So this patch set aims to introduce some SMC specific sysctls to
> independently and flexibly set the parameters that suit SMC.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net/smc: Introduce a specific sysctl for TEST_LINK time
    https://git.kernel.org/netdev/net-next/c/77eee3251431
  - [net-next,v2,2/2] net/smc: Unbind r/w buffer size from clcsock and make them tunable
    https://git.kernel.org/netdev/net-next/c/0227f058aa29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


