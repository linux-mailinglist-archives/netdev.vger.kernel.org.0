Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9896427AE
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiLELki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbiLELkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0C319C12
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 03:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB8F560F8A
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 11:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 167D3C433B5;
        Mon,  5 Dec 2022 11:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670240416;
        bh=KfoIp4VdLOEYEP3FMmcraUSoQx1LHIqKHEqQEQM/Wq0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CHiFi8D4jYKu9qrswLx/6M3a8bKXRmsYC5LLC1yM9QxzgYwALk+9u5Vlt1391FHub
         1zBM2utnkpoPcN/t3w4kzpHEhA9qtotcbttDu1cmbxUcmqKY4fxz2rXww31qicPbtK
         ukRY7Kf7Kt2rK4eUQ00BtwiSpRubAXZ5qw46AyuqGmjzXAdK79PNBtbeerOzmNXhzQ
         nd5zwVFo/mMLbeWiDA6vQoH8Xu1mbifKrpFCTLvKio3IfIdneIkgHnj9TYX/4KeKGm
         88QP+vBvcAZs3vRpY4tDd/h1JFqUrQ3Psbs35NnwqZnZ7Lwo7N96NX+Uj1YHSNbwfY
         Ot6LS7z/26EiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8E09E43EFD;
        Mon,  5 Dec 2022 11:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] net: microchip: sparx5: correctly free skb in xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167024041594.2981.11902528259008393433.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Dec 2022 11:40:15 +0000
References: <20221202083544.2905207-1-casper.casan@gmail.com>
In-Reply-To: <20221202083544.2905207-1-casper.casan@gmail.com>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, daniel.machon@microchip.com,
        UNGLinuxDriver@microchip.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, horatiu.vultur@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Dec 2022 09:35:44 +0100 you wrote:
> consume_skb on transmitted, kfree_skb on dropped, do not free on
> TX_BUSY.
> 
> Previously the xmit function could return -EBUSY without freeing, which
> supposedly is interpreted as a drop. And was using kfree on successfully
> transmitted packets.
> 
> [...]

Here is the summary with links:
  - [v3,net] net: microchip: sparx5: correctly free skb in xmit
    https://git.kernel.org/netdev/net/c/121c6672b019

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


