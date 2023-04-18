Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9106E574F
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 04:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjDRCKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 22:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjDRCKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 22:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049841A1;
        Mon, 17 Apr 2023 19:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B01062C38;
        Tue, 18 Apr 2023 02:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1335C433A0;
        Tue, 18 Apr 2023 02:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681783819;
        bh=MvfqSWbs8IULCqRVEwCUVudPRPAhWInXRLQP6KdLf4g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N8dDczYqartLaUqoIyTNnBT8ml/i6GU3vvQJNL5tL0bcr7JsVZSDKTp30lcVwo6GV
         xdS7LOzJs9sHbMRrAbSswEyY4ldrTzo8T08AnKJQC65WN9LOg0h5Uaj0ouhpNnzzqP
         ubW3A/MVAXg4hxM3y/5y3mhos/Bh+v+XHRqYkB+IAmLOOmteXoiEVpRLxuj2vzhSKy
         6PT2Qd/xDA6jCsHU7UKbRYi6+YBL7+pc4BJysYeGpUI0u9270ymphtBqPryzPUWfP7
         mDLX3mQXeWGGOvGXJwpXHoD+n3Zz6vYEZRx9u6WzWqSXpr6P+WD9mI7GdTUuD+g/G4
         n6zLzufhQHkVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A8DA6C40C5E;
        Tue, 18 Apr 2023 02:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/3] XDP Rx HWTS metadata for stmmac driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168178381968.5081.7896199883043114155.git-patchwork-notify@kernel.org>
Date:   Tue, 18 Apr 2023 02:10:19 +0000
References: <20230415064503.3225835-1-yoong.siang.song@intel.com>
In-Reply-To: <20230415064503.3225835-1-yoong.siang.song@intel.com>
To:     Song@ci.codeaurora.org, Yoong Siang <yoong.siang.song@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, sdf@google.com, alexanderduyck@fb.com,
        brouer@redhat.com, boon.leong.ong@intel.com,
        jacob.e.keller@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net
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

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 15 Apr 2023 14:45:00 +0800 you wrote:
> Implemented XDP receive hardware timestamp metadata for stmmac driver.
> 
> This patchset is tested with tools/testing/selftests/bpf/xdp_hw_metadata.
> Below are the test steps and results.
> 
> Command on DUT:
> 	sudo ./xdp_hw_metadata <interface name>
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/3] net: stmmac: introduce wrapper for struct xdp_buff
    https://git.kernel.org/netdev/net-next/c/5b24324a907c
  - [net-next,v6,2/3] net: stmmac: add Rx HWTS metadata to XDP receive pkt
    https://git.kernel.org/netdev/net-next/c/e3f9c3e34840
  - [net-next,v6,3/3] net: stmmac: add Rx HWTS metadata to XDP ZC receive pkt
    https://git.kernel.org/netdev/net-next/c/9570df353309

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


