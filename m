Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C6A5159AE
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 03:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382045AbiD3Bxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 21:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382035AbiD3Bxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 21:53:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407FD6178;
        Fri, 29 Apr 2022 18:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 900256243D;
        Sat, 30 Apr 2022 01:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D144BC385AE;
        Sat, 30 Apr 2022 01:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651283411;
        bh=fiQr+EHrMiDtkKfEyrknJHIPmgs9EP6w9pQlZtQ+6WU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sQBckF+2Btn45cJ0V63IBV7TPbvs1UZ6Rr8pY7Mxg0XFWi7SAIECSYNQBglIxh8A8
         Do4dUMHsiYTCnu4RXJEVxyo60eeeBH9KX9A2tODWgyAkuAakQoNCnQPDiOMBSOxUAg
         z14R3eb+GCFP7ZmHsUqWTmRly6hqHPhVJK2jNxShwGUo6Iiewl6kmEf3VdxZE9Fykn
         05XhLhgtn4FcU1QnidGSoxnpnOztjTrshDQ+4BNx2pfIV2eNMJPZqVguvd40AnE2IE
         dZUECZClBdmwylYrgSDo5X35sZqyaWk/Sjp8t3RsXT9LohP+DACjqEQmfT7O7U0Jcg
         3j+lCMaMixsVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD491F03847;
        Sat, 30 Apr 2022 01:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] hinic: fix bug of wq out of bound access
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165128341170.13664.7916355260334073632.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 01:50:11 +0000
References: <282817b0e1ae2e28fdf3ed8271a04e77f57bf42e.1651148587.git.mqaio@linux.alibaba.com>
In-Reply-To: <282817b0e1ae2e28fdf3ed8271a04e77f57bf42e.1651148587.git.mqaio@linux.alibaba.com>
To:     Qiao Ma <mqaio@linux.alibaba.com>
Cc:     luobin9@huawei.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Apr 2022 20:30:16 +0800 you wrote:
> If wq has only one page, we need to check wqe rolling over page by
> compare end_idx and curr_idx, and then copy wqe to shadow wqe to
> avoid out of bound access.
> This work has been done in hinic_get_wqe, but missed for hinic_read_wqe.
> This patch fixes it, and removes unnecessary MASKED_WQE_IDX().
> 
> Fixes: 7dd29ee12865 ("hinic: add sriov feature support")
> Signed-off-by: Qiao Ma <mqaio@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [net-next] hinic: fix bug of wq out of bound access
    https://git.kernel.org/netdev/net/c/52b2abef450a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


