Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E955726FA
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbiGLUKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiGLUKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E223BE6B0;
        Tue, 12 Jul 2022 13:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A34661A18;
        Tue, 12 Jul 2022 20:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5AD82C341C8;
        Tue, 12 Jul 2022 20:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657656614;
        bh=kHVaz4LkBkvGBh1Syd+eWooUZG+L82rtyMOr7V33XbU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SBULjhojKlj2MDvDG1NFF9PZv8n0HYaklNuhHG/KKXX/SnEHJ6Ue7u9tbzzSe0kHa
         4AAfNtKM9zK3U1KoAp4uIihPPgeRBMNwz/vZHIn7ariIAkykhCahVEL4rLz2RCK8eE
         TXILcUHF4AuquloIU/5OmyLYPDER/+3aaCOgOfvRVC5vQ0+hPJuZde5RZdnE9+S6v3
         Dj7VfqomQ2O6TFsWCCaXVAaNMsYFED9lwyBqeLnCV+92r18l6zOGRzIyUZrtpQ9yo8
         IRs/SrIcGd6x9TYHFyAsE3T7cIL/DPAegdBWv4R7W1BGIngcG4v/UMF4/EvjX/DhPd
         mBASWLBmfor2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 31B17E45228;
        Tue, 12 Jul 2022 20:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel PATCH v2 0/1] Bluetooth: hci_sync: Fix resuming scan after
 suspend resume
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165765661419.22843.6745868828865009344.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jul 2022 20:10:14 +0000
References: <20220712000530.2531197-1-jiangzp@google.com>
In-Reply-To: <20220712000530.2531197-1-jiangzp@google.com>
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

On Mon, 11 Jul 2022 17:05:29 -0700 you wrote:
> This patch fixes a previous patch which did not remove setting
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
  - [kernel,v2,1/1] Bluetooth: hci_sync: Fix resuming scan after suspend resume
    https://git.kernel.org/bluetooth/bluetooth-next/c/0cc323d985f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


