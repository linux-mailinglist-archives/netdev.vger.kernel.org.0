Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDB9619456
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiKDKUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiKDKUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:20:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB58325295;
        Fri,  4 Nov 2022 03:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 478CB6213D;
        Fri,  4 Nov 2022 10:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F8AEC4347C;
        Fri,  4 Nov 2022 10:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667557219;
        bh=NDQ5Mp093HyrrPYJ19MdXYRs0xi1e+NzMOuWI9ru3k4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mxf/sGOa5fYeqXl4sIRq/Db6liwIV4tnQd+hcx3AddXyoJe7vj+OBmMAS/hlhSqz6
         MskImR6TlA+FYt7SPEOamGyowk08c/Bx7TjB2JNp2Riz7Rn149BNMTIspqRsei7XZu
         vvmnJGpa5VfSQmae3d1bfKdrE/wyD+shvUlcC5nh//nhv/Sie7uHUMTWtbA+P7VOa0
         nKyCdWIgotEWQbzjwCWpZXP2LBKMP8c/5d4wwiGqLoVj7iuYs81ME3/dUd1x0Y63q4
         OoTVMSpygvRQUYSHChe3TQrjn46vX2fzMOK+HTF98dLupYh06Lv1HOvGHSM7AhkwiD
         k3Hrw7EOoUneg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 860DEE52509;
        Fri,  4 Nov 2022 10:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rds: remove redundant variable total_payload_len
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166755721954.22576.7298281566046818273.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 10:20:19 +0000
References: <20221101104104.29878-1-colin.i.king@gmail.com>
In-Reply-To: <20221101104104.29878-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  1 Nov 2022 10:41:04 +0000 you wrote:
> Variable total_payload_len is being used to accumulate payload lengths
> however it is never read or used afterwards. It is redundant and can
> be removed.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  net/rds/send.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - rds: remove redundant variable total_payload_len
    https://git.kernel.org/netdev/net-next/c/d28c0e73efbe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


