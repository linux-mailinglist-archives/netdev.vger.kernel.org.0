Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8233D5EC6E9
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 16:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbiI0Ovo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 10:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbiI0OvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 10:51:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295E55B077;
        Tue, 27 Sep 2022 07:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6470561A05;
        Tue, 27 Sep 2022 14:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE671C433D6;
        Tue, 27 Sep 2022 14:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664290215;
        bh=axSkT7wopRkPF4+TxkNdX6InmludY04cLnPwzYvxWp8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GxUuVqGFSzk+7xviLu2t/xrxAexr9sDWvpOjgpAlrSPrXobFCPUCrPDE5HSo8/WmL
         GV2onFYGXuLic5bEwqfkim0HaXkAGiqncM47TLkMy6wzkvb9YVnqhz/ErmV7Mo0rTM
         OHHeMvljkadCsg8tGr3laaag0McodM16RGCFrApU7P6Zo+/6Za8t5YNBrGsUtqOfe3
         H3ksUU4BPNmNerdOvI6f8vW+ADghpZu9wgocn7dl4oXr6ckxoJjKucjuGRfdK0VXCs
         0eD1vRpfYov8lfP12AoXyHD8qclFyKDdpneQt+xQGBI3ZoorMbd4kizfymfkN/QCsP
         PP0Foq2AnogwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A12A9E21EC5;
        Tue, 27 Sep 2022 14:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] Add Support for Dell 5811e with usb-id 0x413c:0x81c2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166429021565.22749.13023746895326673030.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Sep 2022 14:50:15 +0000
References: <20220926150740.6684-1-linux@fw-web.de>
In-Reply-To: <20220926150740.6684-1-linux@fw-web.de>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-usb@vger.kernel.org, frank-w@public-files.de, bjorn@mork.no,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, johan@kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 26 Sep 2022 17:07:38 +0200 you wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Add new USB-id for dell branded EM7455 with this usb-id in qcserial and qmi
> driver.
> MBIM-mode works out of the box with 6.0-rc6.
> 
> Frank Wunderlich (2):
>   USB: serial: qcserial: add new usb-id for Dell branded EM7455
>   net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455
> 
> [...]

Here is the summary with links:
  - [1/2] USB: serial: qcserial: add new usb-id for Dell branded EM7455
    (no matching commit)
  - [2/2] net: usb: qmi_wwan: Add new usb-id for Dell branded EM7455
    https://git.kernel.org/netdev/net/c/797666cd5af0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


