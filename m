Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C4F6427B1
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbiLELkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiLELkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E396619C20
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 03:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A379BB80EF2
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 11:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 543DBC4314C;
        Mon,  5 Dec 2022 11:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670240416;
        bh=vqEMC9L9UHK0Aa/k3IsaJg89shkWH49lZDCX59Lga40=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BSXafgwfQXyCtOwdHYTu81G98AQrhuAN8vteQOqAyP1qlwlHiOYh1gLYosAYWmU7C
         h+BF77F0nTPzasNhOmKj3VfWjgFTNfeR+89Pg+ZSt3x8W3g0EabuLZE3DDScDbkEtJ
         E80foV2HOtF74+VR8ecZTUJtW1qJu/vozHeSVZU77Ie2PMkQMT1AhXH31Vjh/x+Prl
         iVZlC1iaEMpXhN0/2oOpDoq7Ytz9f8LPus7KhVAEuXYHi8GXhCi3U5uC2RIGUGT/5K
         2HPGfG05nTFlEfgG/sU+DdB8T46LImUj7F9LuI6xmho2cdniGJU+/cgz6Dlg9ELLL1
         b1ccGv7WRGzVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3B42FE21EFD;
        Mon,  5 Dec 2022 11:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: add support for multicast filter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167024041623.2981.14283412214037001652.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Dec 2022 11:40:16 +0000
References: <20221202094214.284673-1-simon.horman@corigine.com>
In-Reply-To: <20221202094214.284673-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        na.wang@corigine.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  2 Dec 2022 10:42:14 +0100 you wrote:
> From: Diana Wang <na.wang@corigine.com>
> 
> Rewrite nfp_net_set_rx_mode() to implement interface to delivery
> mc address and operations to firmware by using general mailbox
> for filtering multicast packets.
> 
> The operations include add mc address and delete mc address.
> And the limitation of mc addresses number is 1024 for each net
> device.
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: add support for multicast filter
    https://git.kernel.org/netdev/net-next/c/de6248644966

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


