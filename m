Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141F6631C3F
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiKUJA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiKUJAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:00:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EB7193CD
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 01:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98F6FB80D79
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45419C433B5;
        Mon, 21 Nov 2022 09:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669021216;
        bh=ChOyvrwmFHZrNADqe8vJQ0hfa4V8zkvs8z9H4fGQNFk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R0LZ7oatrxHvl3VVxT5E8AU/U9gOmneCavCAhgdpw7yaSouOhNE3EqPXeHI7fkjaq
         XtR5NLVOCscTAV58UhNqLn7JPQEF2/T1ceW/TibRqairKVqvjyzqCSPnWzjHwdWNke
         wLulhvi+gh0SUWumZ3LwGR2WtvGzA/SekbpQr6e6b3BMJ0lWalr6HfYeFTfuYygApj
         e+JI8L4jhs3ELxIR4KvxAkTxal9BQ6DjyoBZ4SU+l2zWywNoqPdrz6BCuCqhoU3e9I
         ccMTACuNG8QuaTe7Jmp05CpSJTAJDP1zyhO09nkUxmBPmoQ/XutW6eroT7+DYA3uQz
         nsd+3cNlKwebw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 278C3E29F3F;
        Mon, 21 Nov 2022 09:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3] nfc: Fix potential memory leak of skb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166902121615.26857.6390374258212309010.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Nov 2022 09:00:16 +0000
References: <20221117113714.12776-1-shangxiaojing@huawei.com>
In-Reply-To: <20221117113714.12776-1-shangxiaojing@huawei.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     krzysztof.kozlowski@linaro.org, pavel@denx.de,
        u.kleine-koenig@pengutronix.de, kuba@kernel.org, michael@walle.cc,
        cuissard@marvell.com, sameo@linux.intel.com,
        clement.perrochaud@nxp.com, r.baldyga@samsung.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Nov 2022 19:37:11 +0800 you wrote:
> There are still somewhere maybe leak the skb, fix the memleaks by adding
> fail path.
> 
> Shang XiaoJing (3):
>   nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()
>   nfc: nxp-nci: Fix potential memory leak in nxp_nci_send()
>   nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()
> 
> [...]

Here is the summary with links:
  - [1/3] nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()
    https://git.kernel.org/netdev/net/c/e204ead35401
  - [2/3] nfc: nxp-nci: Fix potential memory leak in nxp_nci_send()
    https://git.kernel.org/netdev/net/c/614761e1119c
  - [3/3] nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()
    https://git.kernel.org/netdev/net/c/60dcb5ff55e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


