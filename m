Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE0C5B8F89
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 22:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiINUK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 16:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiINUKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 16:10:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B3C25DB;
        Wed, 14 Sep 2022 13:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18C73B81C98;
        Wed, 14 Sep 2022 20:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7CCBC433C1;
        Wed, 14 Sep 2022 20:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663186215;
        bh=2mXpFvdOt1OvzNHuzshAgYldAVI1T0KIUcLZXgJlUZ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E+VIbf81votm60urSSWBBfQyDVkdPQxEexclVTEb+QqCTArMTULLATFdLYoZ8Vd1D
         2fG9DEt7PWZDTND/AtD/Pj3ssQsBKbQ+oqhho33jtLZW99dPfH1akrdnVNjOlp4iMF
         PGwt3JDKhF7AhB68qiQllDeNBJ6GUg2RidKxsGRp5GNnGEsyeoBSmIM0Ed2SreIBC2
         q19momLFaH+MitdACqrFGvvBqAIvxwXYdSy0IWK8tiNh9j5d8+P84Tm+NCU7GCc961
         tzGOv8i8efuGRnmCRPLyQw/UwTk18OUCDgwulzrIhWgxJeveCYtmvadugxOjNxnQOh
         5qePUdR/fFrqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A4831E8834D;
        Wed, 14 Sep 2022 20:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel PATCH v1 0/1] Bluetooth: hci_sync: allow advertising during
 active scan without privacy
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166318621566.18930.18182109802852789130.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Sep 2022 20:10:15 +0000
References: <20220913220433.3308871-1-jiangzp@google.com>
In-Reply-To: <20220913220433.3308871-1-jiangzp@google.com>
To:     Zhengping Jiang <jiangzp@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 13 Sep 2022 15:04:32 -0700 you wrote:
> This patch allows the device to keep advertising during active scan when
> ll privacy is enabled, if the device is not using privacy mode.
> 
> Changes in v1:
> - Check privacy flag when disable advertising
> 
> Zhengping Jiang (1):
>   Bluetooth: hci_sync: allow advertising during active scan without
>     privacy
> 
> [...]

Here is the summary with links:
  - [kernel,v1,1/1] Bluetooth: hci_sync: allow advertising during active scan without privacy
    https://git.kernel.org/bluetooth/bluetooth-next/c/9afc675edeeb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


