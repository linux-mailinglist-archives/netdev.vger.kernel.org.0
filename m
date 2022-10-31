Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC4A61415E
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 00:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiJaXKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 19:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaXKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 19:10:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9E5F30;
        Mon, 31 Oct 2022 16:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9FBB614D8;
        Mon, 31 Oct 2022 23:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07A07C433D6;
        Mon, 31 Oct 2022 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667257816;
        bh=maYAtLJfToR5owGf7FOIkaJDILVb30hJrDc1P44+LZw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sXvGB9JyOI7wlFDVvV1pE3KwPcqoTF0E+Pb3Yg1OS/y3tqa9Uad+oPndA/EbLaimB
         UNkNTm2iZRzsYsZ7gXfdn1VNg2Xcc/Vq/YxPle3IYHduOXaK2AooyM4UH8ZCqugOxx
         FyURoKS2+tF+1sUnRE+oqWDHs74GZWj7ijUqSAAKdRMyHnkV/maYdCDkAm1CBMnpqk
         WLthyiS5dO6Q4yFEWYxwJjvIEUzWtZ89c7oh7JF710dgxSAww+WN5W6+ci/PEuyUlu
         zKn6D7PDfu5MMadK5CLgwn5+uDFvV9ieQ3StR8nVzkj/L1e9wDoVXb6loy6AkbhnB6
         0NWSOKH0O1jFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0CC3E50D96;
        Mon, 31 Oct 2022 23:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: Fix EALREADY and ELOOP cases in bt_status()
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166725781590.15466.14816541505567733815.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 23:10:15 +0000
References: <9a1270540f0c2db13e81a9d69098391f1ad22107.1667113164.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <9a1270540f0c2db13e81a9d69098391f1ad22107.1667113164.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, luiz.von.dentz@intel.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Sun, 30 Oct 2022 08:00:03 +0100 you wrote:
> 'err' is known to be <0 at this point.
> 
> So, some cases can not be reached because of a missing "-".
> Add it.
> 
> Fixes: ca2045e059c3 ("Bluetooth: Add bt_status")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - Bluetooth: Fix EALREADY and ELOOP cases in bt_status()
    https://git.kernel.org/bluetooth/bluetooth-next/c/8fceb58d84ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


