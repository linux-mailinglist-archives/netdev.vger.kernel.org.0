Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2DF6D92E5
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbjDFJkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235293AbjDFJkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7060461AE;
        Thu,  6 Apr 2023 02:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F04F60B7A;
        Thu,  6 Apr 2023 09:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64194C433EF;
        Thu,  6 Apr 2023 09:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680774019;
        bh=J4U+Z5d5J4HEJ99Vl/KnTYBmF3dZlwcWP6QS0syhyNY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YP3bfGfGdHpC7RtCr9MGgenvBmlNV8g8TzuEm0iOkL7SgSmjXrJ6xg1RcXq2BgCh3
         jK16nlfExZdbsB4qC0QERQei/NDZsro6jR3yCilE/TfebcxIENwfaV4R3/wQRLbIr8
         iwExzv2DMmzfDWo457z3LhMNki3Z2KsdeNhUd+2QPPD2dJo+QlQ0Y22tRogGVOFO6f
         uUTXIZb8P1ic01cpdenDLq+KTg/+fJEO7HGTmJDKyWMDy4kDOAkP54tEp7lF/tBnJ1
         DnUzJuG6q3XTFgOJK6bKWLjjQ/G3DcmwQFDFvAw7UNHPsfyhDLExke016nQW9LKh6B
         +BaRfwAD1hWkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3C544E29F4B;
        Thu,  6 Apr 2023 09:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 0/7] net: dsa: microchip: ksz8: Enhance static MAC
 table operations and error handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168077401924.13664.4110281611954691133.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 09:40:19 +0000
References: <20230404101842.1382986-1-o.rempel@pengutronix.de>
In-Reply-To: <20230404101842.1382986-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     davem@davemloft.net, andrew@lunn.ch, edumazet@google.com,
        f.fainelli@gmail.com, kuba@kernel.org, pabeni@redhat.com,
        olteanv@gmail.com, woojung.huh@microchip.com,
        arun.ramadoss@microchip.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  4 Apr 2023 12:18:35 +0200 you wrote:
> This patch series improves the Microchip ksz8 driver by refactoring
> static MAC table operations for code reuse, implementing add/del_fdb
> functions, and making better use of error values in
> ksz8_r_sta_mac_table() and ksz8_w_sta_mac_table(). The changes aim to
> provide a more robust and maintainable driver with improved error
> handling.
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/7] net: dsa: microchip: ksz8: Separate static MAC table operations for code reuse
    https://git.kernel.org/netdev/net-next/c/f6636ff69ec4
  - [net-next,v1,2/7] net: dsa: microchip: ksz8: Implement add/del_fdb and use static MAC table operations
    https://git.kernel.org/netdev/net-next/c/57795412a447
  - [net-next,v1,3/7] net: dsa: microchip: ksz8: Make ksz8_r_sta_mac_table() static
    https://git.kernel.org/netdev/net-next/c/b5751cdd7dbe
  - [net-next,v1,4/7] net: dsa: microchip: ksz8_r_sta_mac_table(): Avoid using error code for empty entries
    https://git.kernel.org/netdev/net-next/c/559901b46810
  - [net-next,v1,5/7] net: dsa: microchip: ksz8_r_sta_mac_table(): Utilize error values from read/write functions
    https://git.kernel.org/netdev/net-next/c/ec2312f33735
  - [net-next,v1,6/7] net: dsa: microchip: Make ksz8_w_sta_mac_table() static
    https://git.kernel.org/netdev/net-next/c/c8e04374f9e1
  - [net-next,v1,7/7] net: dsa: microchip: Utilize error values in ksz8_w_sta_mac_table()
    https://git.kernel.org/netdev/net-next/c/3c2e6b54e4e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


