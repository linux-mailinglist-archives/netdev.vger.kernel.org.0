Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E284B11DD
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243720AbiBJPkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:40:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243707AbiBJPkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:40:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266F29C
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 07:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D66A0B825F7
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 15:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93420C340F3;
        Thu, 10 Feb 2022 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644507609;
        bh=5RrzUSRE88SsckWwcwQ3X1zCVnmAFwEijYZ4r6KFWTM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RLOpKFN3OmeEzFTKv0HRlrz1BS5l/lMkIPicEuOd5KCQDXdg1yQZMIduLebM14jbG
         FRihNKswvvHnNwWSRKxYO0X4i6jFMqyf2u/xJHn2W/XFk3npORUc/Ibvyh46YXPPg+
         Ou7RYn2N/PIi9z20oiPD3jcIxRjqhHKkRR41inow4LQHZXhOAfqsKI/9136P0O5kWU
         X4rDHQiT0W9pr5D4zWZz9R9IixR2jpLyf2obdQV6f4K5qHtnNYF/g987V0YCEhAw64
         LOTXyqN/dlDZBT/dxCBPNzoMg9BMmFkWE/ZUcQsk2oPDNuJFn6R4u5kjonaVMtFjZ6
         wx7O4AkkTsB6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 780CCE6D3DE;
        Thu, 10 Feb 2022 15:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-pf: Add TC feature for VFs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164450760948.15967.13752904728813083905.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 15:40:09 +0000
References: <1644493904-10734-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1644493904-10734-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sundeep.lkml@gmail.com, hkelam@marvell.com, gakula@marvell.com,
        sgoutham@marvell.com
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

On Thu, 10 Feb 2022 17:21:44 +0530 you wrote:
> This patch adds TC feature for VFs also. When MCAM
> rules are allocated for a VF then either TC or ntuple
> filters can be used. Below are the commands to use
> TC feature for a VF(say lbk0):
> 
> devlink dev param set pci/0002:01:00.1 name mcam_count value 16 \
>  cmode runtime
> ethtool -K lbk0 hw-tc-offload on
> ifconfig lbk0 up
> tc qdisc add dev lbk0 ingress
> tc filter add dev lbk0 parent ffff: protocol ip flower skip_sw \
>  dst_mac 98:03:9b:83:aa:12 action police rate 100Mbit burst 5000
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-pf: Add TC feature for VFs
    https://git.kernel.org/netdev/net-next/c/4b0385bc8e6a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


