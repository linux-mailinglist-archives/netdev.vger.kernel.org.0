Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F178647F8C
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 09:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiLIIuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 03:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLIIuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 03:50:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDC43AC0D;
        Fri,  9 Dec 2022 00:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C98DB82708;
        Fri,  9 Dec 2022 08:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0269EC433EF;
        Fri,  9 Dec 2022 08:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670575816;
        bh=d6Q16t/RGaB6fw8ZWK5UfodxMJ3ENcw7X4PNmH1LPFk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XElXveUsf0g/kJpKiN/pGB6IvVcTzw4w4crqu/01Zdoh4rP4Wk0OJuwva/YhSidbv
         McInE6EO6wzeIy0Qp1Cn51BmiRiVjljt9vWGXX5eyw0u2DOjKf3JLMp8DKDh4tXcMG
         ga9FL7bL/5k7HtNc8QmXP4oLhlrAXEvMPCQoTOE07d0vRm2dVKUaTXUgrRgSoYs0ri
         DOAuEuYWTo0RqxClMJzXw9MUcY4NMi6H/OJ7oddeFhcKd8Wtzhgi56ecuAxHfCBodl
         0vKDeQlrxcCJFz94BGJEBlAgrL+Iqjliw/YrFJq9o9Dx3jBM5c3ruOeb2lF9TVOXga
         er/JefpqzcHxg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D40A8C433D7;
        Fri,  9 Dec 2022 08:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] net: vmw_vsock: vmci: Check memcpy_from_msg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167057581586.8412.7293501811642337752.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Dec 2022 08:50:15 +0000
References: <20221206065834.1093081-1-artem.chernyshev@red-soft.ru>
In-Reply-To: <20221206065834.1093081-1-artem.chernyshev@red-soft.ru>
To:     Artem Chernyshev <artem.chernyshev@red-soft.ru>
Cc:     vdasa@vmware.com, sgarzare@redhat.com, pv-drivers@vmware.com,
        bryantan@vmware.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
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

On Tue,  6 Dec 2022 09:58:34 +0300 you wrote:
> vmci_transport_dgram_enqueue() does not check the return value
> of memcpy_from_msg().  If memcpy_from_msg() fails, it is possible that
> uninitialized memory contents are sent unintentionally instead of user's
> message in the datagram to the destination.  Return with an error if
> memcpy_from_msg() fails.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> [...]

Here is the summary with links:
  - [v4] net: vmw_vsock: vmci: Check memcpy_from_msg()
    https://git.kernel.org/netdev/net/c/44aa5a6dba82

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


