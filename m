Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCAA962B64F
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 10:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbiKPJU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 04:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiKPJUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 04:20:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CD42649F
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 01:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0096861B10
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 09:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62B7AC433D7;
        Wed, 16 Nov 2022 09:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668590419;
        bh=+GkeljMjUw8mV5bsZpsLdLMpILGx5D+hgsk8z3MLg34=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iv+cCQu2C8/eTFfPjFoEajkrJZrVIeKl6Q2uT3q3V60MQgunECF6CluiOY5HVv/vM
         LHGCn7ig3QjsEz3C9bcIF9SFe3rBiP2gM6aLAmnaeH7z9pl5RvopwpEG8fadfwSaHb
         Ikq2dfMW6eoXdo0q2cPARfL7zG1mcDpua0KrLzfNAmG+NkQ1pDGykCyChvXjONd5kt
         NW53pRiZLS3DWc4E/alHsmI1o0kepIw7nIHsDjkDsUw2LEQu0Rn3Wffk5lF7iHi2RI
         93QbS/atOfE7+rgVkh89acsExzNkTc/I9odAjNw4e823+3GvUncyMXtEJ9ZFGULu8e
         CEH7jfgD4/a0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E247C395F6;
        Wed, 16 Nov 2022 09:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 00/12] sfc: TC offload counters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166859041931.4735.9297046813943664208.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 09:20:19 +0000
References: <cover.1668430870.git.ecree.xilinx@gmail.com>
In-Reply-To: <cover.1668430870.git.ecree.xilinx@gmail.com>
To:     <edward.cree@amd.com>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com
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
by David S. Miller <davem@davemloft.net>:

On Mon, 14 Nov 2022 13:15:49 +0000 you wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> EF100 hardware supports attaching counters to action-sets in the MAE.
> Use these counters to implement stats for TC flower offload.
> 
> The counters are delivered to the host over a special hardware RX queue
>  which should only ever receive counter update messages, not 'real'
>  network packets.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,01/12] sfc: fix ef100 RX prefix macro
    https://git.kernel.org/netdev/net-next/c/5ae0c2263402
  - [v2,net-next,02/12] sfc: add ability for an RXQ to grant credits on refill
    https://git.kernel.org/netdev/net-next/c/e39515398487
  - [v2,net-next,03/12] sfc: add start and stop methods to channels
    https://git.kernel.org/netdev/net-next/c/85697f97fd3c
  - [v2,net-next,04/12] sfc: add ability for extra channels to receive raw RX buffers
    https://git.kernel.org/netdev/net-next/c/36df6136a7d0
  - [v2,net-next,05/12] sfc: add ef100 MAE counter support functions
    https://git.kernel.org/netdev/net-next/c/e5731274cdd1
  - [v2,net-next,06/12] sfc: add extra RX channel to receive MAE counter updates on ef100
    https://git.kernel.org/netdev/net-next/c/25730d8be5d8
  - [v2,net-next,07/12] sfc: add hashtables for MAE counters and counter ID mappings
    https://git.kernel.org/netdev/net-next/c/19a0c989104a
  - [v2,net-next,08/12] sfc: add functions to allocate/free MAE counters
    https://git.kernel.org/netdev/net-next/c/0363aa295781
  - [v2,net-next,09/12] sfc: accumulate MAE counter values from update packets
    https://git.kernel.org/netdev/net-next/c/c4bad432b95a
  - [v2,net-next,10/12] sfc: attach an MAE counter to TC actions that need it
    https://git.kernel.org/netdev/net-next/c/2e0f1eb05692
  - [v2,net-next,11/12] sfc: validate MAE action order
    https://git.kernel.org/netdev/net-next/c/83a187a4eb3a
  - [v2,net-next,12/12] sfc: implement counters readout to TC stats
    https://git.kernel.org/netdev/net-next/c/50f8f2f7fbf2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


