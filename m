Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6746943E4
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 12:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjBMLKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 06:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjBMLKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 06:10:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FF9D529
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 03:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE33760FB3
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 11:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2091EC433D2;
        Mon, 13 Feb 2023 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676286618;
        bh=vjq7xOBy74292FI7MTihZK90GEhi448q3wJIgY5qdQ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VMHH0SRdu3qcNiRC3xu3M66oqZfsNWkVloTym54KcOHpbtQonyoR0xJUalVzLEQa8
         sRhSWcFcWcuuILEV2LhQRXYEU2a54dz/KlpbEVTdXCgiJ8fCSCXIagMyySR/UDD4m4
         MyZSkLUER1DYII3uWiLzlZjbnSSnxCEndt0hKf8WxaivQDs6rp34RAW3Y5u8ujBqR1
         ZnQvsu9CYWC14wieSrW+qngk974whWTRlRMf/5OI9Vgj/w1qiWdjeZ59OARLgGoiO2
         rserAdvlZh9gxUnsmhDUXUzE8LH3/pdDxAXh2sJGNxRo+azR28gfgBNrCidPF3JoeZ
         KQLgGI0DS8Rug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A354C41676;
        Mon, 13 Feb 2023 11:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 0/4] ionic: on-chip descriptors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167628661803.25720.7388517816151143630.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 11:10:18 +0000
References: <20230211005017.48134-1-shannon.nelson@amd.com>
In-Reply-To: <20230211005017.48134-1-shannon.nelson@amd.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
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

On Fri, 10 Feb 2023 16:50:13 -0800 you wrote:
> We start with a couple of house-keeping patches that were originally
> presented for 'net', then we add support for on-chip descriptor rings
> for tx-push, as well as adding support for rx-push.
> 
> I have a patch for the ethtool userland utility that I can send out
> once this has been accepted.
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/4] ionic: remove unnecessary indirection
    https://git.kernel.org/netdev/net-next/c/7bb990097db7
  - [v4,net-next,2/4] ionic: remove unnecessary void casts
    https://git.kernel.org/netdev/net-next/c/896de449f804
  - [v4,net-next,3/4] net: ethtool: extend ringparam set/get APIs for rx_push
    https://git.kernel.org/netdev/net-next/c/5b4e9a7a71ab
  - [v4,net-next,4/4] ionic: add tx/rx-push support with device Component Memory Buffers
    https://git.kernel.org/netdev/net-next/c/40bc471dc714

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


