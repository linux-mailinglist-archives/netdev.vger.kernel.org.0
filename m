Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E91A50FA2F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348686AbiDZKWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348747AbiDZKWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:22:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8C622B04;
        Tue, 26 Apr 2022 02:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67BB560C09;
        Tue, 26 Apr 2022 09:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3CCDC385AC;
        Tue, 26 Apr 2022 09:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650966610;
        bh=IZSiNIBmx6JMn/z3aQJoM97u2+VcmJQwarlNVP1yzDU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pdOy/m2fi1a+aLfrTEhfSC6KWIqy+8tL+I9PV0IxjgyUjSLgvYV0ozk7jLCy1wBmW
         rTiY3D3zBvWITwIAKE83ImkGk1uMWOEAgkszRy7a1qGbNBY8VKD1sAyUniBuOoUc3e
         cusnr1QTRfANAAyhY5Q3E9G8Mu6gzHs2ZbGUM0SqaunIK7wDQprvsnzSamKIc66i0Q
         YbCoMtcUrSBoflBsaIaDySGJN6W7Pv1PQj1TBqRKWeCBelPJ6jSV/cNywjsH36fgn6
         Id4usSQVm26FsGrhttLqCktR/fTD+T56ekQXNrTqEoldi+m36s+hjYTziV+l11HQRX
         acGMFTPhWMzDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9784E6D402;
        Tue, 26 Apr 2022 09:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: usb: qmi_wwan: add support for Sierra Wireless EM7590
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165096661069.14700.16385830873722579454.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Apr 2022 09:50:10 +0000
References: <20220425054028.5444-1-etyang@sierrawireless.com>
In-Reply-To: <20220425054028.5444-1-etyang@sierrawireless.com>
To:     Ethan Yang <ipis.yang@gmail.com>
Cc:     bjorn@mork.no, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        gchiang@sierrawireless.com, etyang@sierrawireless.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 25 Apr 2022 13:40:28 +0800 you wrote:
> From: Ethan Yang <etyang@sierrawireless.com>
> 
> add support for Sierra Wireless EM7590 0xc081 composition.
> 
> Signed-off-by: Ethan Yang <etyang@sierrawireless.com>
> ---
>  drivers/net/usb/qmi_wwan.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [v2] net: usb: qmi_wwan: add support for Sierra Wireless EM7590
    https://git.kernel.org/netdev/net-next/c/561215482cc6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


