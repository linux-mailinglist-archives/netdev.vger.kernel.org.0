Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBE0606F2F
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 07:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiJUFKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 01:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiJUFKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 01:10:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0247CE09E6
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 22:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F8EE61DCA
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B48A1C43145;
        Fri, 21 Oct 2022 05:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666329020;
        bh=qEO4OGiNZro+nmqBuZWsrV4qpyQl1D0eCViUQEic3Dk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IDAC9gqp5Cz3Ib0ZpVuJCOcM0Yz+0osdhy7C1XfESAO0jAdiYk/UuM450bxUt0E8o
         0FzxN7G/QgdjWASBWVpiA2QZGBkaAmc/WmO/3Hju1tbGWxT/GOc7vQfafDeOdd+5Yi
         o3UROQqZXbEGzRs+JJjVEXjyXZ8Yys0t/fJ37+v5NUA4G7Gk9kuHwtYetRti3RWalF
         aEMp1g67/JiL6tFNp7BY7rhKmRR59qVqd5s5meId2TVPtL84epCDgXX9hAN3WjwjBL
         idy0kHGKlWEPMlj5+PAlTPzcilrn+5rxoAYHU9fW1omL1zCuRhh4KWi7jAJY9LmSba
         A0rXIvwGi4pVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94690E5250B;
        Fri, 21 Oct 2022 05:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net,v2 0/4] fix some issues in Huawei hinic driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166632902060.25874.18065416208387073064.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Oct 2022 05:10:20 +0000
References: <20221019095754.189119-1-shaozhengchao@huawei.com>
In-Reply-To: <20221019095754.189119-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, keescook@chromium.org,
        gustavoars@kernel.org, gregkh@linuxfoundation.org, ast@kernel.org,
        peter.chen@kernel.org, bin.chen@corigine.com, luobin9@huawei.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Oct 2022 17:57:50 +0800 you wrote:
> Fix some issues in Huawei hinic driver. This patchset is compiled only,
> not tested.
> 
> ---
> v2: remove cyclic release cmdq
> ---
> 
> [...]

Here is the summary with links:
  - [net,v2,1/4] net: hinic: fix incorrect assignment issue in hinic_set_interrupt_cfg()
    https://git.kernel.org/netdev/net/c/c0605cd6750f
  - [net,v2,2/4] net: hinic: fix memory leak when reading function table
    https://git.kernel.org/netdev/net/c/4c1f602df895
  - [net,v2,3/4] net: hinic: fix the issue of CMDQ memory leaks
    https://git.kernel.org/netdev/net/c/363cc87767f6
  - [net,v2,4/4] net: hinic: fix the issue of double release MBOX callback of VF
    https://git.kernel.org/netdev/net/c/8ec2f4c6b2e1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


