Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CD761753A
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiKCDuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiKCDuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D951573A;
        Wed,  2 Nov 2022 20:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9593761D25;
        Thu,  3 Nov 2022 03:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F415BC433C1;
        Thu,  3 Nov 2022 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667447419;
        bh=9g/nOtdIoPnwAtyHNuLjlS2q1WjD6jbUWBaM7WO1FLM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Oh37KHRKhHNitTICGH3CNb6I5WKevI9X64dFEB5x+1IjvIVzFWk51YnpPyrHMkVVE
         yL8clM4YKoCRKSQC6X7KyIA7gMr2q3TDTbGzDxilO/I7KFFqxBD1fzCxRMWXMJJaXC
         6vPJJwi5T+7odiMso9oOnGUfxS07T1/GsUpJZnee9sJ4MX+OOn+NFfbrGkEplcJ1ct
         xUxGIZQegmULsOHkoUor2bAw9nCr5pEnk+KVkNrta0ubE7x7OZTHrAU4eR8FkwYfz0
         PqixV63w6g7Tl1b3gqXnfI8Um++my+5CXc6kdMABCCPAvkO/+8RvDYsyf94D+NA+qp
         MQQffo5vQ0q0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7990C41620;
        Thu,  3 Nov 2022 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-af: Allow mkex profile without DMAC and
 add L2M/L2B header extraction support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166744741887.12191.13337691779266481520.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 03:50:18 +0000
References: <20221031090856.1404303-1-sumang@marvell.com>
In-Reply-To: <20221031090856.1404303-1-sumang@marvell.com>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com, sbhatta@marvell.com,
        rkannoth@marvell.com, gakula@marvell.com, hkelam@marvell.com,
        naveenm@marvell.com, netdev@vger.kernel.org,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 31 Oct 2022 14:38:56 +0530 you wrote:
> 1. It is possible to have custom mkex profiles which do not extract
> DMAC at all into the key. Hence allow mkex profiles which do not
> have DMAC to be loaded into MCAM hardware. This patch also adds
> debugging prints needed to identify profiles with wrong
> configuration.
> 
> 2. If a mkex profile set "l2l3mb" field for Rx interface,
> then Rx multicast and broadcast entry should be configured.
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-af: Allow mkex profile without DMAC and add L2M/L2B header extraction support
    https://git.kernel.org/netdev/net-next/c/2cee6401c4ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


