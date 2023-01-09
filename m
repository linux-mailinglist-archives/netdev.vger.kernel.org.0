Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAF3661F5A
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 08:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbjAIHk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 02:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjAIHkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 02:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9A512D1C
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 23:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E189060EC5
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 07:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45EC3C433F0;
        Mon,  9 Jan 2023 07:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673250016;
        bh=Z5j5+reaUdQkqX7nR7PRZoUirveithB4SFi/dqGz8S0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OVKtgo8vqSpKT2fOx0tAl0DqkKjRzeFGGGwE2gA4O8CNSx/DK/EHmOVoaTF0UinjK
         cJJWrXagLgStGwfBx+hLCqrHlCcaYGT10pQGTWSbmpzTEtQLau5JZz6QS3Re/QtR0C
         oXT0fkiL2qIFvsnf0nsSakCFExC0xDGNJr2dCX70cxWVrI1DWkb6m5FW/Hce7XzySf
         Nc9P0pVZi6t2NrHoEBqzQ0rPHR+qnQxWHzOsxMGtHAhAlEKA/L7Xf9BDtS4Uaj9BUE
         hBAoFS8hMChmg7TctuclTXJC3wQW7sHXorC2EwU8WfFvPpCdu8WPz3zRyvUrxFxrbe
         LDvmpbwrar3dg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2464CE4D005;
        Mon,  9 Jan 2023 07:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] nfc: pn533: Wait for out_urb's completion in
 pn533_usb_send_frame()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167325001614.30057.15507780040740954686.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Jan 2023 07:40:16 +0000
References: <20230106082344.357906-1-linuxlovemin@yonsei.ac.kr>
In-Reply-To: <20230106082344.357906-1-linuxlovemin@yonsei.ac.kr>
To:     Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Cc:     kuba@kernel.org, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, lauro.venancio@openbossa.org,
        linville@tuxdriver.com, dokyungs@yonsei.ac.kr,
        jisoo.jang@yonsei.ac.kr
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

On Fri,  6 Jan 2023 17:23:44 +0900 you wrote:
> Fix a use-after-free that occurs in hcd when in_urb sent from
> pn533_usb_send_frame() is completed earlier than out_urb. Its callback
> frees the skb data in pn533_send_async_complete() that is used as a
> transfer buffer of out_urb. Wait before sending in_urb until the
> callback of out_urb is called. To modify the callback of out_urb alone,
> separate the complete function of out_urb and ack_urb.
> 
> [...]

Here is the summary with links:
  - [net,v2] nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()
    https://git.kernel.org/netdev/net/c/9dab880d675b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


