Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E774F143B
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 14:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbiDDMCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 08:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbiDDMCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 08:02:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E1C34B8B;
        Mon,  4 Apr 2022 05:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0410F60FED;
        Mon,  4 Apr 2022 12:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57D08C34111;
        Mon,  4 Apr 2022 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649073615;
        bh=78FNZht/g+BY2v+PRzDms1AEl+f2DpPx4NG82SQXWiY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M1cLVXCAt61ahCX16LKen1KNFOwvZ6Y228DOhfWr4y3FpidJdC4MtxFJyu/m+dcSG
         /xEvA0Qk2d9FKfeef7zfJNW4EbSQ5Hm52Lhr+3AKO2AdnRg3VO3xn89Jiw/KWovKln
         WXwFtKIqoqyvSzG9+k2bS6UAGo10jQP9HJMeCKOvDik99Ey67JUjgZgxIiTjJCAATC
         ZLVhYnjUAhVN06afoR2PwmsRUnZCRFOLBPj/9TWNbCLMYY409buo3EGj5BnWXPf/YN
         gpYuH8DGO8IGgjeFpiKVUEntXbM6+WMmImwKTVlhc1ndE0lnJsj+jOSwSZ/gD9KHMZ
         wGIUMYWRgwVSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3ACF4E8DBD1;
        Mon,  4 Apr 2022 12:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] bnxt_en: XDP redirect fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164907361523.19769.5490628771939833913.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Apr 2022 12:00:15 +0000
References: <1648858872-14682-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1648858872-14682-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com, bpf@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  1 Apr 2022 20:21:09 -0400 you wrote:
> This series includes 3 fixes related to the XDP redirect code path in
> the driver.  The first one adds locking when the number of TX XDP rings
> is less than the number of CPUs.  The second one adjusts the maximum MTU
> that can support XDP with enough tail room in the buffer.  The 3rd one
> fixes a race condition between TX ring shutdown and the XDP redirect path.
> 
> Andy Gospodarek (1):
>   bnxt_en: reserve space inside receive page for skb_shared_info
> 
> [...]

Here is the summary with links:
  - [net,1/3] bnxt_en: Synchronize tx when xdp redirects happen on same ring
    https://git.kernel.org/netdev/net/c/4f81def272de
  - [net,2/3] bnxt_en: reserve space inside receive page for skb_shared_info
    https://git.kernel.org/netdev/net/c/facc173cf700
  - [net,3/3] bnxt_en: Prevent XDP redirect from running when stopping TX queue
    https://git.kernel.org/netdev/net/c/27d4073f8d9a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


