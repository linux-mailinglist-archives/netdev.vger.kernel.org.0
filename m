Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D4E4CFEF5
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 13:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbiCGMlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 07:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238852AbiCGMlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 07:41:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F55745045;
        Mon,  7 Mar 2022 04:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D351B811DD;
        Mon,  7 Mar 2022 12:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97A7AC36AE3;
        Mon,  7 Mar 2022 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646656811;
        bh=vCnNaNj/55Uqkab9aHqyVqzmFrdwACuyT3H9pWWd7Xk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CU4RL6dx4QrTG/B0J7V4w8C9l1JCMsJDqfc/NTc25Ao/DcCNlXYsgHwh74qvLi79V
         B00bdzALKf67WENhSv+JCPJ6PFTqDiX2BdHXtQ1QwzfKafqv6mKDN95GEpgoSkc5k2
         YichRb5v5ee0eHuWACcKtNwUIhWlF2jAJn/1wAmtUqURzr18YcgASha92qiulI42zR
         hJ8Rh0kyryykjs1V6wYp4iK2QjYsh0lm3dEi8lq8e+o6ppS4t+GxsIzaYEf5JDyOvK
         HKwo135L6f8e/0fw5hccOyhRkZ4OMJkg5rpvZ5TKVkPRhgFHtEzIQBKrt1iWKck6EC
         gHf00fjcahxbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70902E7BB18;
        Mon,  7 Mar 2022 12:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] smsc95xx: Ignore -ENODEV errors when device is
 unplugged
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164665681144.14619.4945223702291737274.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Mar 2022 12:40:11 +0000
References: <20220305204720.2978554-1-festevam@gmail.com>
In-Reply-To: <20220305204720.2978554-1-festevam@gmail.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, steve.glendinning@shawell.net,
        UNGLinuxDriver@microchip.com, fntoth@gmail.com,
        martyn.welch@collabora.com, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, marex@denx.de, festevam@denx.de
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  5 Mar 2022 17:47:20 -0300 you wrote:
> From: Fabio Estevam <festevam@denx.de>
> 
> According to Documentation/driver-api/usb/URB.rst when a device
> is unplugged usb_submit_urb() returns -ENODEV.
> 
> This error code propagates all the way up to usbnet_read_cmd() and
> usbnet_write_cmd() calls inside the smsc95xx.c driver during
> Ethernet cable unplug, unbind or reboot.
> 
> [...]

Here is the summary with links:
  - [v2,net] smsc95xx: Ignore -ENODEV errors when device is unplugged
    https://git.kernel.org/netdev/net/c/c70c453abcbf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


