Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2A857D0C1
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 18:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiGUQKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 12:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGUQKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 12:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE0AB862;
        Thu, 21 Jul 2022 09:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A4AA61D07;
        Thu, 21 Jul 2022 16:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89AECC341C0;
        Thu, 21 Jul 2022 16:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658419814;
        bh=HOE/flbCziKu2voAYBrndOCgntACUbS6q6MoJRpxXLk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n2KSyOjp4la/FcqMfQZnczNR08ZLwUSz+YF3Jw9nyHiLC9ijJUU9U/zGsDioa1Fo0
         v90CYmjgNA90FJgAws5N90/8uotYe5tht9ClreBRPOfEVeZ1FBFCVErNhVu9ZExPyM
         5grEu5t6lZb7u83fAoYntI0tQK916iG46+FavPa1JOONtxrUwyj7uM/tYQ6G8y2zCC
         E9A9co2vBSI+r9Uy9Xh3DIc/UYy1NhCHjEj0x48dz74VSmtW58jJ74HZQkSL/IWnbp
         j60KpyN9P1/rqZVVvvGAA9TRfU+fPgB5bYL67idAM9UMXs1iOwkQOjgMx1qonwIIfA
         mKjqgZfKu7f/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66BE8E451B0;
        Thu, 21 Jul 2022 16:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/4] Bluetooth: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165841981441.30268.9603484388527010825.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jul 2022 16:10:14 +0000
References: <1658383473-32188-1-git-send-email-quic_zijuhu@quicinc.com>
In-Reply-To: <1658383473-32188-1-git-send-email-quic_zijuhu@quicinc.com>
To:     Zijun Hu <quic_zijuhu@quicinc.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, luiz.von.dentz@intel.com, swyterzone@gmail.com,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Thu, 21 Jul 2022 14:04:29 +0800 you wrote:
> This patch series remove bluetooth HCI_QUIRK_BROKEN_ERR_DATA_REPORTING
> the quirk was introduced by 'commit cde1a8a99287 ("Bluetooth: btusb: Fix
> and detect most of the Chinese Bluetooth controllers")' to mark HCI
> commands HCI_Read|Write_Default_Erroneous_Data_Reporting broken within BT
> device driver, but the reason why these two HCI commands are broken is
> that feature "Erroneous Data Reporting" is not enabled by firmware, so BT
> core driver can addtionally check feature bit "Erroneous Data Reporting"
> instead of the quirk to decide if these two HCI commands work fine.
> 
> [...]

Here is the summary with links:
  - [v2,1/4] Bluetooth: hci_sync: Check LMP feature bit instead of quirk
    https://git.kernel.org/bluetooth/bluetooth-next/c/ca832c5e178f
  - [v2,2/4] Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for QCA
    https://git.kernel.org/bluetooth/bluetooth-next/c/9ee3f82b5015
  - [v2,3/4] Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for fake CSR
    https://git.kernel.org/bluetooth/bluetooth-next/c/08454349a054
  - [v2,4/4] Bluetooth: hci_sync: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING
    https://git.kernel.org/bluetooth/bluetooth-next/c/4d22b9f84c44

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


