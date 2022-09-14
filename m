Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2325B8F87
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 22:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiINUK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 16:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiINUKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 16:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DFEC10;
        Wed, 14 Sep 2022 13:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CCAF61ED9;
        Wed, 14 Sep 2022 20:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D18C2C433B5;
        Wed, 14 Sep 2022 20:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663186215;
        bh=g6KUO98zbkQKhRZROdFqw4U5su9kSopTVBix/TJw0vI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nEoChH23HgaLlAmOJpNLC9BTj5z4Ye0zaB1QCJrCsxd7BI2ntpljeCATeJfOSOjHn
         R2Pq02qpQLtUxsB7zO/ENiUQ5EQS+w7geqNjIt5HB+tGinPHF+12hK8D1fbIsWDdu3
         d3jtCEXIB6n7MfbqY4vAUeAHDlzwepPW1fymosp3yPvd0TgwBr26OWtreNy8jL+yrH
         m4zvYXk1kFNgEvAL7XE3Y/0bubSgnmJWO7M7o+T8r+RlKR5eIoaUwZvL8+WXjp2Ms4
         tt7LM1lKYQ1DB5z+GHa/vHxabbTphAAbk5xm1lZ90m/v8LzUs2U6cfkEPr+stgZMGf
         6x3pLCTK17UvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B00D4C73FF7;
        Wed, 14 Sep 2022 20:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel PATCH v2 0/1] Bluetooth: hci_sync: allow advertise when scan
 without RPA
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166318621571.18930.13188395810053943250.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Sep 2022 20:10:15 +0000
References: <20220913233715.3323089-1-jiangzp@google.com>
In-Reply-To: <20220913233715.3323089-1-jiangzp@google.com>
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

On Tue, 13 Sep 2022 16:37:14 -0700 you wrote:
> This patch allows the device to keep advertising during active scan when
> ll privacy is enabled, if the device is not using privacy mode.
> 
> Changes in v2:
> - Modify title to reduce length within limit
> 
> Changes in v1:
> - Check privacy flag when disable advertising
> 
> [...]

Here is the summary with links:
  - [kernel,v2,1/1] Bluetooth: hci_sync: allow advertise when scan without RPA
    https://git.kernel.org/bluetooth/bluetooth-next/c/9afc675edeeb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


