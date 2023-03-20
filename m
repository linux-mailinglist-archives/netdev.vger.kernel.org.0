Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194A06C0E96
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjCTKUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbjCTKUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D028E126C0;
        Mon, 20 Mar 2023 03:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ED496133F;
        Mon, 20 Mar 2023 10:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BAC0EC4339B;
        Mon, 20 Mar 2023 10:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679307617;
        bh=TOzZ4n152e17UuROK2BNa8fZDphjOM+ZX0EDrJXbk6c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Srbpnf5r6HWjh1ijeKZlcCG6365QTOHME+u13JwJzkPjSBtLSxChCUFyNK6WKlaMD
         qp9WN/F1p2dt9yDIHn+99OCB6TaAAgN8vxrXyUHSShT9JchC/6OccluNzlvEQhYBuV
         FT4dYmq1WHW5oV6PvqSjR2D/RetXWOFU8E+N8clGjmtu6eiicTFQSdUieleyfK5yuQ
         I+LTjutmSCNU2KUp3OfXBUUnWtDWr1nuDg5iqc0dk7GINAEgiVI/T0waV233WXzNK7
         /2FBCdFUhcCzuscxb/eagXZPIIl6uKde0OLB0sHW1B/oB1hdsZvZvjH+LsY3ZZyicL
         dBN8V4rfCdtDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A02D5E4F0D8;
        Mon, 20 Mar 2023 10:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: usb: lan78xx: Limit packet length to skb->len
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167930761765.15318.2929604643140284061.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Mar 2023 10:20:17 +0000
References: <20230318092552.93145-1-szymon.heidrich@gmail.com>
In-Reply-To: <20230318092552.93145-1-szymon.heidrich@gmail.com>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 18 Mar 2023 10:25:52 +0100 you wrote:
> Packet length retrieved from descriptor may be larger than
> the actual socket buffer length. In such case the cloned
> skb passed up the network stack will leak kernel memory contents.
> 
> Additionally prevent integer underflow when size is less than
> ETH_FCS_LEN.
> 
> [...]

Here is the summary with links:
  - [v3] net: usb: lan78xx: Limit packet length to skb->len
    https://git.kernel.org/netdev/net/c/7f247f5a2c18

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


