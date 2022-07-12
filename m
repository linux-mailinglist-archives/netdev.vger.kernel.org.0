Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9F75726FD
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbiGLUKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiGLUKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:10:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F92BE69C;
        Tue, 12 Jul 2022 13:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0670B81BDB;
        Tue, 12 Jul 2022 20:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53213C341C0;
        Tue, 12 Jul 2022 20:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657656614;
        bh=L5dgNUIPOO5+bcxU5e2mjPSXK+Hb0hcBjyW4aG3Fe14=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ETU5eSIywau8832XHDxUwoHI9bK1HdQnIw7GpvG94/izbB9Wa472arLNdNgW7EFzD
         YSsV8fOgrULJXDhmf5eL+pileXu2MOU/Ifz7rjPzaorrAOsQl9lsx60iR56aFt6TGV
         Uy7xlqFOsE64xF2h3eggToUi5FPDnth43ivwbhR7qZ0j4UWYBxNT6fThkL3vuKRnqP
         PWEMBW6HhSm8D6YufAsa9ZlWSvZcbKm0UoFGcAAB3cfUMzAoH0bByH0h+tDDlPU7dd
         zPSdCUOpIRATwWdA0Kx1kdJxkNyrbZbHDLLGTmetpC+MqYde4gBUHZ1YbvrUJy0ZGs
         4Ddq1YnbB6D9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 29A7EE4522E;
        Tue, 12 Jul 2022 20:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel PATCH v1 0/1] This patch fixes a previous patch which did not
 remove setting
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165765661416.22843.5459975711518356370.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jul 2022 20:10:14 +0000
References: <20220711225359.996974-1-jiangzp@google.com>
In-Reply-To: <20220711225359.996974-1-jiangzp@google.com>
To:     Zhengping Jiang <jiangzp@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Mon, 11 Jul 2022 15:53:58 -0700 you wrote:
> scanning_paused to false after resuming. So after setting the value,
> the function to update scan will always quit.
> Also need to set the value first before updating passive scan.
> 
> BUG=b:236868580,b:236340454
> TEST=verified suspend is fixed in volteer with LE mouse
> TEST=bluetooth_AdapterSRHealth.sr_peer_wake_le_hid
> TEST=bluetooth_AdapterCLHealth.cl_adapter_pairing_suspend_resume_test
> 
> [...]

Here is the summary with links:
  - [kernel,v1,1/1] Bluetooth: hci_sync: Fix resuming passive scan after suspend resume
    https://git.kernel.org/bluetooth/bluetooth-next/c/0cc323d985f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


