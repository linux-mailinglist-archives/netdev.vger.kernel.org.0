Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A9161ED6E
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiKGIuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiKGIuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:50:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F125B1582F;
        Mon,  7 Nov 2022 00:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B34060F55;
        Mon,  7 Nov 2022 08:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4AF7C4347C;
        Mon,  7 Nov 2022 08:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667811015;
        bh=/Du2bQwS1VbD9PfcLDdD3Qdgfsuldj4KV/St+qJjKak=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dZdNaAiUaNuneZQ27wsIMq/ZZTIHGJrCoitgp72NfGPpI5a/7wDckqLAdnnkXEx79
         u/xrhfiQKjsysFg9/cy2wB2pkWQPo+RcO/+YrdRh5eCHunO54Jkn9cmAIdHdlbv5z4
         lY4M34G0YBHbVTK3cH/pxLRdSGWUViCojb49jdaxD1KVcgJsfPDAsoxdkZoqZPjf8H
         bqkO8OwTyifTWMsQpl9H76yqFLTX53vvNICaTzw1hOAMbcc9QGP+oVe41U1taHmt3n
         dh8bbg6GFrb26GP4aU/OwxR0liRKzyERq63JFZcKd7z4kQB/57jU2TOhpNWm3pUXAl
         eDph1FF7/zKWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ADD3AE2A022;
        Mon,  7 Nov 2022 08:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: axiemac: add PM callbacks to support
 suspend/resume
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166781101570.969.6358244265379731485.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Nov 2022 08:50:15 +0000
References: <20221101011139.900930-1-andy.chiu@sifive.com>
In-Reply-To: <20221101011139.900930-1-andy.chiu@sifive.com>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, greentime.hu@sifive.com
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
by David S. Miller <davem@davemloft.net>:

On Tue,  1 Nov 2022 09:11:39 +0800 you wrote:
> Support basic system-wide suspend and resume functions
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> ---
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 36 +++++++++++++++++++
>  1 file changed, 36 insertions(+)

Here is the summary with links:
  - [net-next] net: axiemac: add PM callbacks to support suspend/resume
    https://git.kernel.org/netdev/net-next/c/a3de357b087e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


