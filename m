Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D4151CE9E
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387891AbiEFBYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387844AbiEFBX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:23:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91929C2D;
        Thu,  5 May 2022 18:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E29A62029;
        Fri,  6 May 2022 01:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1082EC385B4;
        Fri,  6 May 2022 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651800015;
        bh=4sE3ggOy+dlpQdbHbeyDY3gRDDi9ok/3eqQEzCi+FZM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kzwLOw6JqC+w2wVVoacvJm9uu12CQct/IMjI/mjVIzNPw3m+np6ldV0/iix2ZGMYF
         j4oMPMaBxzg7De8UdDyKDV9oHm7vtT8IoZ0AMEN/elTXUPWNTqbQWf/e4ZnR+TH+tG
         eQVyDBzMV5g+j0hMY3bc/F813aKlvK/SwCGcBiyhV8EFr8dl74lKmtH5pQWPVcJJDo
         oHxfdakfVzWq7X70b0RTBgU5XJntEsD8JmLkozKPCqzQMoASmssnwDeatKtq2arfUb
         A2h0Krhjf+M7OmY8bhMeyQ7TPSsjC1e972PJSxM0SGfyJ8RGTb+1f3TH3yFKJMwAjK
         376bYn/4cVA2Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6C47F03876;
        Fri,  6 May 2022 01:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] net: switch to netif_napi_add_tx()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165180001494.16316.16139936183700758910.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 01:20:14 +0000
References: <20220504163725.550782-1-kuba@kernel.org>
In-Reply-To: <20220504163725.550782-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, rafal@milecki.pl, f.fainelli@gmail.com,
        opendmb@gmail.com, dmichail@fungible.com, hauke@hauke-m.de,
        tariqt@nvidia.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        shshaikh@marvell.com, manishc@marvell.com, jiri@resnulli.us,
        hayashi.kunihiko@socionext.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, grygorii.strashko@ti.com,
        elder@kernel.org, wintera@linux.ibm.com, wenjia@linux.ibm.com,
        svens@linux.ibm.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, s-vadapalli@ti.com,
        chi.minghao@zte.com.cn, linux-rdma@vger.kernel.org,
        linux-hyperv@vger.kernel.org, mptcp@lists.linux.dev
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 May 2022 09:37:24 -0700 you wrote:
> Switch net callers to the new API not requiring
> the NAPI_POLL_WEIGHT argument.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: rafal@milecki.pl
> CC: f.fainelli@gmail.com
> CC: opendmb@gmail.com
> CC: dmichail@fungible.com
> CC: hauke@hauke-m.de
> CC: tariqt@nvidia.com
> CC: kys@microsoft.com
> CC: haiyangz@microsoft.com
> CC: sthemmin@microsoft.com
> CC: wei.liu@kernel.org
> CC: decui@microsoft.com
> CC: shshaikh@marvell.com
> CC: manishc@marvell.com
> CC: jiri@resnulli.us
> CC: hayashi.kunihiko@socionext.com
> CC: peppe.cavallaro@st.com
> CC: alexandre.torgue@foss.st.com
> CC: joabreu@synopsys.com
> CC: mcoquelin.stm32@gmail.com
> CC: grygorii.strashko@ti.com
> CC: elder@kernel.org
> CC: wintera@linux.ibm.com
> CC: wenjia@linux.ibm.com
> CC: svens@linux.ibm.com
> CC: mathew.j.martineau@linux.intel.com
> CC: matthieu.baerts@tessares.net
> CC: s-vadapalli@ti.com
> CC: chi.minghao@zte.com.cn
> CC: linux-rdma@vger.kernel.org
> CC: linux-hyperv@vger.kernel.org
> CC: mptcp@lists.linux.dev
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: switch to netif_napi_add_tx()
    https://git.kernel.org/netdev/net-next/c/16d083e28f1a
  - [net-next,2/2] net: move snowflake callers to netif_napi_add_tx_weight()
    https://git.kernel.org/netdev/net-next/c/8d602e1a132e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


